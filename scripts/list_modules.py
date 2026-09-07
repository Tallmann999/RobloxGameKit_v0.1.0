#!/usr/bin/env python3
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
catalog = json.loads((root / "module-catalog.json").read_text(encoding="utf-8"))
print(f"RobloxGameKit {catalog['kitVersion']}")
for m in catalog['modules']:
    deps = ', '.join(m.get('depends', [])) or '-'
    print(f"{m['id']:16} {m['status']:10} deps={deps:20} {m.get('description','')}")
