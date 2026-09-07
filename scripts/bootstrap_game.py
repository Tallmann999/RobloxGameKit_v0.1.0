#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path

KIT_ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = KIT_ROOT / "templates" / "game"
MODULES = KIT_ROOT / "modules"
KIT_VERSION = (KIT_ROOT / "VERSION").read_text(encoding="utf-8").strip()


def merge_tree(src: Path, dst: Path, force: bool = False) -> None:
    for item in src.rglob("*"):
        rel = item.relative_to(src)
        target = dst / rel
        if item.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists() and not force:
            if target.read_bytes() == item.read_bytes():
                continue
            raise RuntimeError(f"Refusing to overwrite existing file: {target}")
        shutil.copy2(item, target)


def load_manifest(module_id: str) -> dict:
    path = MODULES / module_id / "manifest.json"
    if not path.exists():
        raise RuntimeError(f"Unknown module: {module_id}")
    return json.loads(path.read_text(encoding="utf-8"))


def resolve(requested: list[str]) -> list[dict]:
    ordered: list[dict] = []
    visiting: set[str] = set()
    done: set[str] = set()

    def visit(mid: str) -> None:
        if mid in done:
            return
        if mid in visiting:
            raise RuntimeError(f"Dependency cycle at {mid}")
        visiting.add(mid)
        m = load_manifest(mid)
        if m.get("status") != "ready":
            raise RuntimeError(f"Module '{mid}' is {m.get('status')}, not ready; read its BLUEPRINT.md instead")
        for dep in m.get("depends", []):
            visit(dep)
        visiting.remove(mid)
        done.add(mid)
        ordered.append(m)

    for mid in requested:
        visit(mid)
    return ordered


def main() -> int:
    parser = argparse.ArgumentParser(description="Bootstrap a Roblox game from RobloxGameKit")
    parser.add_argument("--target", required=True, help="Target game repository directory")
    parser.add_argument("--modules", nargs="+", default=["core"], help="Ready modules to install")
    parser.add_argument("--force", action="store_true", help="Allow overwriting differing files")
    args = parser.parse_args()

    target = Path(args.target).resolve()
    target.mkdir(parents=True, exist_ok=True)

    merge_tree(TEMPLATE, target, force=args.force)
    manifests = resolve(args.modules)

    installed = []
    for manifest in manifests:
        module_root = MODULES / manifest["id"]
        for mapping in manifest.get("files", []):
            merge_tree(module_root / mapping["from"], target / mapping["to"], force=args.force)
        installed.append({"id": manifest["id"], "version": manifest["version"]})

    lock = {
        "kitVersion": KIT_VERSION,
        "modules": installed,
    }
    (target / "robloxgamekit.lock.json").write_text(
        json.dumps(lock, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    print(f"Bootstrapped: {target}")
    print("Installed modules:")
    for item in installed:
        print(f"  - {item['id']}@{item['version']}")
    print("Next: rokit install -> rojo plugin install -> rojo serve")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
