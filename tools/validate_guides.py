#!/usr/bin/env python3
"""
ForeverLevelingGuide guide data validator (lightweight, offline).

Validates guide data files for structural issues, chain integrity, and common
authoring mistakes to speed up in-game verification/tuning on WoW Forever.
This does NOT perform in-game validation and does NOT invent/verify real quest
IDs, mapIDs, or coordinates.

Usage:
  python tools/validate_guides.py [project_root]

Exit code: 1 if any errors are found, else 0.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path


KNOWN_TYPES = {
    "accept", "pickup", "take", "start",
    "turnin", "handin", "finish", "deliver", "submit",
    "complete", "do", "objective", "objectives", "progress", "work",
    "goto", "travel", "move", "run", "fly", "taxi", "discover", "arrive", "path", "waypoint",
    "level", "grind", "xp", "ding", "reach",
    "hearth", "hearthstone",
    "sethearth", "inn", "home", "bind",
    "train", "learn", "trainer",
    "buy", "vendor", "sell", "repair",
    "collect", "item", "getitem", "get", "loot", "gather", "acquire", "purchase",
    "use",
    "kill", "grindmobs",
    "class", "profession", "spell",
    "note", "info", "text", "talk", "speak",
}

TRAVEL_TYPES = {
    "goto", "travel", "move", "run", "fly", "taxi", "discover", "arrive", "path", "waypoint",
}
LEVEL_TYPES = {"level", "grind", "xp", "ding", "reach"}
QUEST_TYPES = {
    "accept", "pickup", "take", "start",
    "turnin", "handin", "finish", "deliver", "submit",
    "complete", "do", "objective", "objectives", "progress", "work",
}
COLLECT_TYPES = {"collect", "item", "getitem", "get", "loot", "gather", "acquire", "purchase"}
ALLOWED_FACTIONS = {"Horde", "Alliance", "Neutral"}


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []
        self.infos = []

    def add(self, level, msg):
        if level == "error":
            self.errors.append(msg)
        elif level == "warn":
            self.warnings.append(msg)
        else:
            self.infos.append(msg)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def find_matching(text: str, open_idx: int, open_ch: str, close_ch: str):
    depth = 0
    i = open_idx
    in_str = None  # '"', "'", or 'long'
    long_eq = 0
    n = len(text)
    while i < n:
        ch = text[i]
        nxt = text[i + 1] if i + 1 < n else ""

        if in_str == "long":
            end = "]" + ("=" * long_eq) + "]"
            if text.startswith(end, i):
                i += len(end)
                in_str = None
                continue
            i += 1
            continue

        if in_str in ('"', "'"):
            if ch == "\\":
                i += 2
                continue
            if ch == in_str:
                in_str = None
            i += 1
            continue

        # line/long comments
        if ch == "-" and nxt == "-":
            m = re.match(r"--\[(=*)\[", text[i:])
            if m:
                eq = len(m.group(1))
                end = "]" + ("=" * eq) + "]"
                j = text.find(end, i + len(m.group(0)))
                i = n if j < 0 else j + len(end)
                continue
            j = text.find("\n", i)
            i = n if j < 0 else j + 1
            continue

        # long string
        m = re.match(r"\[(=*)\[", text[i:])
        if m:
            in_str = "long"
            long_eq = len(m.group(1))
            i += len(m.group(0))
            continue

        if ch in ('"', "'"):
            in_str = ch
            i += 1
            continue

        if ch == open_ch:
            depth += 1
        elif ch == close_ch:
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def parse_string_literal(s: str):
    if not s or s[0] not in ('"', "'"):
        return None, 0
    q = s[0]
    i = 1
    out = []
    while i < len(s):
        ch = s[i]
        if ch == "\\" and i + 1 < len(s):
            out.append(s[i + 1])
            i += 2
            continue
        if ch == q:
            return "".join(out), i + 1
        out.append(ch)
        i += 1
    return None, 0


def extract_guides_from_file(path: Path, report: Report):
    text = read_text(path)
    guides = []
    needle = "ns:RegisterGuide("
    i = 0
    while True:
        j = text.find(needle, i)
        if j < 0:
            break
        k = j + len(needle)
        while k < len(text) and text[k].isspace():
            k += 1
        if k >= len(text) or text[k] not in ('"', "'"):
            # Likely a function definition (e.g. function ns:RegisterGuide(...)) or a
            # non-literal call; only string-literal registrations are guide data.
            i = j + 1
            continue
        key, consumed = parse_string_literal(text[k:])
        if key is None:
            report.add("error", f"{path.name}: failed to parse RegisterGuide key near offset {j}")
            i = j + 1
            continue
        k += consumed
        while k < len(text) and text[k].isspace():
            k += 1
        if k >= len(text) or text[k] != ",":
            report.add("error", f"{path.name}:{key}: expected ',' after guide key")
            i = j + 1
            continue
        k += 1
        while k < len(text) and text[k].isspace():
            k += 1
        if k >= len(text) or text[k] != "{":
            report.add("error", f"{path.name}:{key}: expected guide table '{{'")
            i = j + 1
            continue
        close = find_matching(text, k, "{", "}")
        if close < 0:
            report.add("error", f"{path.name}:{key}: unterminated guide table")
            i = j + 1
            continue
        guides.append((key, text[k:close + 1], path))
        i = close + 1
    return guides


def extract_steps_block(guide_table_text: str):
    m = re.search(r"\bsteps\s*=\s*\{", guide_table_text)
    if not m:
        return None, guide_table_text
    brace_idx = guide_table_text.find("{", m.end() - 1)
    if brace_idx < 0:
        return None, guide_table_text
    close = find_matching(guide_table_text, brace_idx, "{", "}")
    if close < 0:
        return None, guide_table_text
    return guide_table_text[brace_idx + 1:close], guide_table_text[:m.start()] + guide_table_text[close + 1:]


def parse_step_tables(steps_inner: str):
    steps = []
    i = 0
    n = len(steps_inner)
    while i < n:
        if steps_inner[i] == "{":
            close = find_matching(steps_inner, i, "{", "}")
            if close < 0:
                break
            steps.append(steps_inner[i:close + 1])
            i = close + 1
            continue
        i += 1
    return steps


def get_str_field(block: str, name: str):
    m = re.search(rf"\b{name}\s*=\s*(\"(?:\\.|[^\"])*\"|'(?:\\.|[^'])*')", block)
    if not m:
        return None
    val, _ = parse_string_literal(m.group(1))
    return val


def get_num_field(block: str, name: str):
    m = re.search(rf"\b{name}\s*=\s*(-?\d+(?:\.\d+)?)", block)
    if not m:
        return None
    try:
        return float(m.group(1)) if "." in m.group(1) else int(m.group(1))
    except Exception:
        return None


def get_bool_field(block: str, name: str):
    m = re.search(rf"\b{name}\s*=\s*(true|false)\b", block)
    if not m:
        return None
    return m.group(1) == "true"


def parse_coords(step_text: str):
    m = re.search(r"\bcoords\s*=\s*\{", step_text)
    if not m:
        return None
    brace_idx = step_text.find("{", m.end() - 1)
    if brace_idx < 0:
        return None
    close = find_matching(step_text, brace_idx, "{", "}")
    if close < 0:
        return None
    inner = step_text[brace_idx + 1:close]
    coords = {}
    for key in ("mapID", "mapId", "map", "uiMapID", "x", "X", "y", "Y"):
        val = get_num_field(inner, key)
        if val is not None:
            coords[key] = val
    return coords


def normalize_coord(v):
    try:
        n = float(v)
    except Exception:
        return None
    if n > 1:
        n = n / 100.0
    return n


def validate_guide(key, guide_table, path: Path, all_keys: set, report: Report):
    steps_inner, header = extract_steps_block(guide_table)

    title = get_str_field(header, "title")
    faction = get_str_field(header, "faction")
    min_level = get_num_field(header, "minLevel")
    max_level = get_num_field(header, "maxLevel")
    nxt = get_str_field(header, "next") or get_str_field(header, "nextGuide") or get_str_field(header, "nextKey")
    scaffold = get_bool_field(header, "scaffold")

    ctx = f"{path.name}:{key}"
    if not title:
        report.add("warn", f"{ctx}: missing or non-literal title")
    if faction and faction not in ALLOWED_FACTIONS:
        report.add("warn", f"{ctx}: faction '{faction}' is unusual (expected Horde/Alliance/Neutral)")
    if min_level is None:
        report.add("warn", f"{ctx}: missing minLevel")
    if max_level is None:
        report.add("warn", f"{ctx}: missing maxLevel")
    if isinstance(min_level, (int, float)) and isinstance(max_level, (int, float)) and min_level > max_level:
        report.add("error", f"{ctx}: minLevel ({min_level}) > maxLevel ({max_level})")
    if nxt:
        if nxt == key:
            report.add("error", f"{ctx}: next points to itself")
        elif nxt not in all_keys:
            report.add("error", f"{ctx}: next '{nxt}' does not match any registered guide key")
    if scaffold is True and title and "scaffold" not in title.lower() and "wip" not in title.lower():
        report.add("info", f"{ctx}: scaffold guide title does not mention scaffold/WIP (optional)")

    if steps_inner is None:
        report.add("error", f"{ctx}: missing steps table")
        return {"key": key, "path": str(path), "faction": faction, "minLevel": min_level, "maxLevel": max_level, "next": nxt, "scaffold": scaffold, "steps": 0}

    step_tables = parse_step_tables(steps_inner)
    if len(step_tables) == 0:
        report.add("warn", f"{ctx}: steps table is empty")

    for idx, st in enumerate(step_tables, start=1):
        stype_raw = get_str_field(st, "type") or get_str_field(st, "kind") or "note"
        stype = re.sub(r"[\s\-_\u2011\u2013\u2014]+", "", str(stype_raw).lower())
        stitle = get_str_field(st, "title") or get_str_field(st, "name") or get_str_field(st, "text") or get_str_field(st, "desc")
        if stype not in KNOWN_TYPES:
            report.add("warn", f"{ctx} step {idx}: unknown/uncommon step type '{stype_raw}'")
        if not stitle:
            report.add("info", f"{ctx} step {idx} ({stype_raw}): no explicit title (engine may auto-title)")

        quest = get_num_field(st, "quest") or get_num_field(st, "questID") or get_num_field(st, "questId") or get_num_field(st, "id")
        if stype in QUEST_TYPES and quest is None:
            report.add("info", f"{ctx} step {idx} ({stype_raw}): no quest ID (intentional for scaffold/prose, but required for verified routes)")
        elif quest is not None and not isinstance(quest, int):
            report.add("warn", f"{ctx} step {idx}: quest ID should be an integer")

        if stype in LEVEL_TYPES:
            lvl = get_num_field(st, "level") or get_num_field(st, "toLevel") or get_num_field(st, "value") or get_num_field(st, "at") or get_num_field(st, "required")
            if lvl is None:
                report.add("warn", f"{ctx} step {idx} (level): missing target level")
            else:
                if isinstance(min_level, (int, float)) and lvl < min_level - 1:
                    report.add("info", f"{ctx} step {idx}: level target {lvl} is below guide minLevel {min_level}")
                if isinstance(max_level, (int, float)) and lvl > max_level + 1:
                    report.add("info", f"{ctx} step {idx}: level target {lvl} is above guide maxLevel {max_level}")

        coords = parse_coords(st)
        if stype in TRAVEL_TYPES and coords is None:
            report.add("info", f"{ctx} step {idx} (travel): no coords; arrival auto-complete/arrow targeting unavailable until coords are added")
        if coords is not None:
            mapid = coords.get("mapID") or coords.get("mapId") or coords.get("map") or coords.get("uiMapID")
            x = coords.get("x") if coords.get("x") is not None else coords.get("X")
            y = coords.get("y") if coords.get("y") is not None else coords.get("Y")
            if mapid is None:
                report.add("warn", f"{ctx} step {idx}: coords missing mapID")
            else:
                try:
                    if float(mapid) <= 0:
                        report.add("warn", f"{ctx} step {idx}: coords mapID looks invalid ({mapid})")
                except Exception:
                    pass
            if x is None or y is None:
                report.add("warn", f"{ctx} step {idx}: coords missing x/y")
            else:
                nx = normalize_coord(x)
                ny = normalize_coord(y)
                if nx is None or ny is None or not (0.0 <= nx <= 1.0 and 0.0 <= ny <= 1.0):
                    report.add("warn", f"{ctx} step {idx}: coords out of expected range (x={x}, y={y}; expected 0-1 or 0-100)")

        if stype in COLLECT_TYPES:
            item = get_str_field(st, "item") or get_num_field(st, "item") or get_num_field(st, "itemID") or get_num_field(st, "itemId") or get_str_field(st, "itemName")
            if item is None and quest is None:
                report.add("info", f"{ctx} step {idx} (collect): no item or quest specified")

        note = get_str_field(st, "note") or get_str_field(st, "desc") or get_str_field(st, "description")
        if stype == "note" and not stitle and not note:
            report.add("warn", f"{ctx} step {idx}: note step has no title/note text")

    return {
        "key": key,
        "path": str(path),
        "faction": faction,
        "minLevel": min_level,
        "maxLevel": max_level,
        "next": nxt,
        "scaffold": scaffold,
        "steps": len(step_tables),
    }


def parse_toc_data_files(toc_path: Path):
    data_files = []
    for line in read_text(toc_path).splitlines():
        s = line.strip()
        if not s or s.startswith("#"):
            continue
        s_norm = s.replace("\\", "/")
        if s_norm.lower().startswith("data/") and s_norm.lower().endswith(".lua"):
            data_files.append(s_norm)
    return data_files


def main(argv):
    root = Path(argv[1]).resolve() if len(argv) > 1 else Path(__file__).resolve().parent.parent
    toc = root / "ForeverLevelingGuide.toc"
    data_dir = root / "Data"
    report = Report()

    print("ForeverLevelingGuide validator (offline)")
    print(f"Root: {root}")

    if not toc.exists():
        report.add("error", f"Missing TOC: {toc}")
    if not data_dir.exists():
        report.add("error", f"Missing Data directory: {data_dir}")
    if report.errors:
        for msg in report.errors:
            print(f"ERROR: {msg}")
        return 1

    toc_data_files = parse_toc_data_files(toc)
    toc_data_set = {p.lower() for p in toc_data_files}
    print(f"TOC data files: {len(toc_data_files)}")

    data_files_on_disk = sorted([p for p in data_dir.glob("*.lua")], key=lambda p: p.name.lower())
    disk_rel_set = {("Data/" + p.name).lower() for p in data_files_on_disk}

    for rel in toc_data_files:
        if not (root / rel).exists():
            report.add("error", f"TOC references missing file: {rel}")
    for rel in sorted(disk_rel_set):
        if rel not in toc_data_set:
            report.add("warn", f"Data file on disk not listed in TOC: {rel}")

    all_guides = []
    for p in data_files_on_disk:
        all_guides.extend(extract_guides_from_file(p, report))

    keys = [g[0] for g in all_guides]
    key_set = set()
    dups = set()
    for k in keys:
        if k in key_set:
            dups.add(k)
        key_set.add(k)
    for d in sorted(dups):
        report.add("error", f"Duplicate guide key registered: {d}")

    print(f"Guides found: {len(all_guides)}")

    guide_infos = [validate_guide(key, table_text, path, key_set, report) for key, table_text, path in all_guides]

    by_key = {g["key"]: g for g in guide_infos}
    for g in guide_infos:
        nxt = g.get("next")
        if not nxt or nxt not in by_key:
            continue
        ng = by_key[nxt]
        if g.get("faction") and ng.get("faction") and g["faction"] != ng["faction"]:
            report.add("warn", f"{g['key']}: next '{nxt}' faction ({ng['faction']}) differs from guide faction ({g['faction']})")
        gmax = g.get("maxLevel")
        nmin = ng.get("minLevel")
        if isinstance(gmax, (int, float)) and isinstance(nmin, (int, float)):
            if nmin > gmax + 5:
                report.add("warn", f"{g['key']}: next '{nxt}' starts at {nmin}, but guide ends at {gmax} (possible gap)")
            if nmin < gmax - 10:
                report.add("info", f"{g['key']}: next '{nxt}' starts at {nmin}, below guide end {gmax} (overlap may be intentional)")

    print("")
    print(f"Summary: {len(report.errors)} error(s), {len(report.warnings)} warning(s), {len(report.infos)} info")
    if report.errors:
        print("\nErrors:")
        for msg in report.errors:
            print(f"  - {msg}")
    if report.warnings:
        print("\nWarnings:")
        for msg in report.warnings:
            print(f"  - {msg}")
    if report.infos:
        print("\nInfo:")
        for msg in report.infos:
            print(f"  - {msg}")

    if not report.errors and not report.warnings:
        print("\nOK: guide data looks structurally consistent (offline checks only).")
    elif not report.errors:
        print("\nOK (no errors): warnings/info above are expected for scaffolds and should be addressed during in-game verification.")

    return 1 if report.errors else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
