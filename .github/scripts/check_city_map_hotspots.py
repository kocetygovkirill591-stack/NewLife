#!/usr/bin/env python3
"""Check that all six city-map labels align with their Godot touch areas."""
from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

EXPECTED = {
    "ЖИЛОЙ": "Жилой район",
    "ТОРГОВЫЙ": "Торговый район",
    "ЦЕНТР": "Центр",
    "ДЕЛОВОЙ": "Деловой район",
    "ПРОМЫШЛЕННЫЙ": "Промышленный район",
    "ПАРКОВЫЙ": "Парковый район",
}
TOLERANCE = 0.01


def fail(message: str) -> None:
    print(f"CITY_MAP_HOTSPOTS: FAIL — {message}", file=sys.stderr)
    raise SystemExit(1)


def parse_labels(svg_root: ET.Element) -> dict[str, tuple[float, float, float, float]]:
    try:
        width = float(svg_root.attrib["width"])
        height = float(svg_root.attrib["height"])
    except (KeyError, ValueError) as error:
        fail(f"SVG must declare numeric width and height: {error}")
    labels: dict[str, tuple[float, float, float, float]] = {}
    for group in svg_root.iter():
        if group.tag.rsplit("}", 1)[-1] != "g":
            continue
        children = list(group)
        for index, element in enumerate(children[:-1]):
            if element.tag.rsplit("}", 1)[-1] != "rect":
                continue
            if element.attrib.get("fill", "").lower() != "#f7f4e7":
                continue
            following = children[index + 1]
            if following.tag.rsplit("}", 1)[-1] != "text":
                continue
            label = "".join(following.itertext()).strip()
            if label not in EXPECTED:
                continue
            if label in labels:
                fail(f"duplicate SVG label: {label}")
            try:
                labels[label] = (
                    float(element.attrib["x"]) / width,
                    float(element.attrib["y"]) / height,
                    float(element.attrib["width"]) / width,
                    float(element.attrib["height"]) / height,
                )
            except (KeyError, ValueError, ZeroDivisionError) as error:
                fail(f"invalid rectangle for {label}: {error}")
    return labels


def parse_hotspots(script: str) -> dict[str, tuple[float, float, float, float]]:
    map_start = script.find("_add_hotspot_artwork(CITY_MAP_TEXTURE")
    map_end = script.find('], "Коснись подписи', map_start)
    if map_start < 0 or map_end < 0:
        fail("could not locate the map hotspot array in main.gd")
    block = script[map_start:map_end]
    pattern = re.compile(r'\{"name":"([^"]+)",\s*"rect":Rect2\(([^)]*)\)\}')
    hotspots: dict[str, tuple[float, float, float, float]] = {}
    for name, raw_values in pattern.findall(block):
        try:
            values = tuple(float(value.strip()) for value in raw_values.split(","))
        except ValueError:
            fail(f"invalid Rect2 values for {name}")
        if len(values) != 4:
            fail(f"Rect2 for {name} must contain four values")
        if name in hotspots:
            fail(f"duplicate hotspot: {name}")
        hotspots[name] = values  # type: ignore[assignment]
    return hotspots


def main() -> None:
    project_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / "godot-project"
    svg_path = project_dir / "assets" / "city_map.svg"
    script_path = project_dir / "scripts" / "main.gd"
    if not svg_path.is_file() or not script_path.is_file():
        fail(f"missing required file: {svg_path} or {script_path}")
    try:
        svg_root = ET.parse(svg_path).getroot()
        script = script_path.read_text(encoding="utf-8")
    except (ET.ParseError, OSError) as error:
        fail(f"cannot read map sources: {error}")

    labels = parse_labels(svg_root)
    hotspots = parse_hotspots(script)
    if set(labels) != set(EXPECTED):
        fail(f"expected six SVG labels, found {sorted(labels)}")
    if set(hotspots) != set(EXPECTED.values()):
        fail(f"expected six touch areas, found {sorted(hotspots)}")

    failures: list[str] = []
    for label, hotspot_name in EXPECTED.items():
        visual = labels[label]
        touch = hotspots[hotspot_name]
        deltas = tuple(abs(a - b) for a, b in zip(visual, touch))
        if any(delta > TOLERANCE for delta in deltas):
            failures.append(f"{hotspot_name}: visual={visual}, touch={touch}, delta={deltas}")
        else:
            print(f"PASS: {hotspot_name}")

    if failures:
        for item in failures:
            print(f"FAIL: {item}", file=sys.stderr)
        print(f"CITY_MAP_HOTSPOTS: FAIL ({len(failures)} mismatches)", file=sys.stderr)
        raise SystemExit(1)
    print("CITY_MAP_HOTSPOTS: PASS (6 districts)")


if __name__ == "__main__":
    main()
