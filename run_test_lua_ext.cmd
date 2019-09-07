@echo off
@regsvr32 /s ".\win32exts.dll"
.\win32exts_exe.exe /regserver
".\lua51.exe"  ".\test_lua_ext.lua"
