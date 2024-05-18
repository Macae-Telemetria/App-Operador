@echo off
setlocal enabledelayedexpansion
for /l %%i in (15,1,80) do (
    set "num=%%i"
    set "num=0000!num!"
    set "num=!num:~-4!"
    copy frame_0014.png frame_!num!.png
)
