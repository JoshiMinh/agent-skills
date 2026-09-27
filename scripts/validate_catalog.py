#!/usr/bin/env python3
"""Validate Skills Manager metadata against local SKILL.md frontmatter."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILLS_DIR = ROOT / "skills"
METADATA_DIR = ROOT / ".skills-manager" / "skills"
SCENARIO_SKILLS_DIR = ROOT / ".skills-manager" / "scenario-skills"
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def parse_frontmatter(path: Path) -> dict[str, object]:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        raise ValueError("missing opening YAML frontmatter delimiter")
    end = text.find("\n---\n", 4)
    if end < 0:
        raise ValueError("missing closing YAML frontmatter delimiter")

    block = text[4:end]
    name_match = re.search(r"^name:\s*[\"']?([^\n\"']+)", block, re.MULTILINE)
    description_match = re.search(r"^description:\s*(.+)$", block, re.MULTILINE)
    tags_match = re.search(r"^\s*tags:\s*(\[[^\n]*\])", block, re.MULTILINE)
    if not name_match or not description_match:
        raise ValueError("frontmatter must contain name and description")

    tags: list[str] = []
    if tags_match:
        try:
            parsed_tags = json.loads(tags_match.group(1).replace("'", '"'))
        except json.JSONDecodeError as error:
            raise ValueError(f"tags must be a JSON-style string array: {error}") from error
        if not isinstance(parsed_tags, list) or not all(isinstance(tag, str) for tag in parsed_tags):
            raise ValueError("tags must be a string array")
        tags = parsed_tags

    return {
        "name": name_match.group(1).strip(),
        "description": description_match.group(1).strip().strip("\"'"),
        "tags": tags,
    }


def main() -> int:
    errors: list[str] = []
    metadata_by_path: dict[str, dict[str, object]] = {}
    skill_ids: set[str] = set()

    for metadata_path in sorted(METADATA_DIR.glob("*.json")):
        try:
            metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as error:
            errors.append(f"{metadata_path.relative_to(ROOT)}: invalid JSON: {error}")
            continue
        path_key = metadata.get("path_key")
        skill_id = metadata.get("skill_id")
        if not isinstance(path_key, str) or not isinstance(skill_id, str):
            errors.append(f"{metadata_path.relative_to(ROOT)}: path_key and skill_id must be strings")
            continue
        if path_key in metadata_by_path:
            errors.append(f"duplicate path_key: {path_key}")
        if skill_id in skill_ids:
            errors.append(f"duplicate skill_id: {skill_id}")
        metadata_by_path[path_key] = metadata
        skill_ids.add(skill_id)

    skill_paths: set[str] = set()
    for skill_file in sorted(SKILLS_DIR.glob("*/SKILL.md")):
        relative_dir = skill_file.parent.relative_to(ROOT).as_posix()
        skill_paths.add(relative_dir)
        try:
            frontmatter = parse_frontmatter(skill_file)
        except (OSError, ValueError) as error:
            errors.append(f"{skill_file.relative_to(ROOT)}: {error}")
            continue

        name = frontmatter["name"]
        if name != skill_file.parent.name:
            errors.append(f"{skill_file.relative_to(ROOT)}: name {name!r} must match directory")
        if not isinstance(name, str) or not NAME_PATTERN.fullmatch(name):
            errors.append(f"{skill_file.relative_to(ROOT)}: invalid skill name {name!r}")
        if not frontmatter["description"]:
            errors.append(f"{skill_file.relative_to(ROOT)}: description is empty")

        metadata = metadata_by_path.get(relative_dir)
        if metadata is None:
            errors.append(f"{relative_dir}: missing Skills Manager metadata")
            continue
        if metadata.get("path") != relative_dir:
            errors.append(f"{relative_dir}: metadata path does not match path_key")
        if metadata.get("tags") != frontmatter["tags"]:
            errors.append(f"{relative_dir}: metadata tags do not match SKILL.md tags")

    for orphan in sorted(set(metadata_by_path) - skill_paths):
        errors.append(f"{orphan}: metadata points to a missing skill")

    for mapping_path in sorted(SCENARIO_SKILLS_DIR.glob("*/*.json")):
        try:
            mapping = json.loads(mapping_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as error:
            errors.append(f"{mapping_path.relative_to(ROOT)}: invalid JSON: {error}")
            continue
        if mapping.get("skill_id") not in skill_ids:
            errors.append(f"{mapping_path.relative_to(ROOT)}: references an unknown skill_id")
        if mapping.get("scenario_id") != mapping_path.parent.name:
            errors.append(f"{mapping_path.relative_to(ROOT)}: scenario_id does not match directory")

    if errors:
        print("Catalog validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(f"Catalog validation passed: {len(skill_paths)} skills, {len(skill_ids)} metadata records")
    return 0


if __name__ == "__main__":
    sys.exit(main())
