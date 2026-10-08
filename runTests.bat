@echo off
rem Step 1 registers new class_name scripts (global class cache); skipping it after adding a new class makes GUT fail with "Nonexistent function" errors.
"C:\Program Files\GODOT\godot.exe" --headless --import
"C:\Program Files\GODOT\godot.exe" --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit,res://tests/integration -gexit

pause
