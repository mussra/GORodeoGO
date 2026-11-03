#!/usr/bin/env python3
"""Build both menu alternatives, restoring the preferred main scene even on failure."""
import pathlib, subprocess, sys
project = pathlib.Path(__file__).resolve().parents[1]
config = project / 'project.godot'
original = config.read_text()
engine = sys.argv[1]
out = pathlib.Path(sys.argv[2]).resolve()
out.mkdir(parents=True, exist_ok=True)
try:
    for label,scene in [('Futurista','main_menu.tscn'),('Cartoon','main_menu_cartoon.tscn')]:
        import re
        config.write_text(re.sub(r'run/main_scene="[^"]+"',f'run/main_scene="res://src/Presentation/{scene}"',original))
        subprocess.run([engine,'--headless','--path',str(project),'--export-debug','Android Review',str(out/f'Rancho-Prueba-0.21.14-{label}.apk')],check=True)
finally:
    config.write_text(original)
