@echo off
setlocal EnableExtensions

:: ==============================================================================
:: KIMI CLI LAUNCHER v2.0.0
::
::   1. Checks for a Kimi CLI update (update-kimi.ps1) and installs it
::   2. Asks which mode to run (skipped when a mode is passed as %1)
::   3. Asks new chat vs. previous chats
::   4. Launches the CLI
::
::   Usage: kimi-launch.cmd [mode] [directory] [inner]
::     mode: menu ^| auto-max ^| auto ^| yolo ^| plan ^| manual  (default: menu)
::     "inner" is used internally when re-launched inside the terminal window.
::
::   NOTE: plain sequential/goto batch, no delayed expansion, like dslaunch.
:: ==============================================================================

set "VERSION=2.0.0"

set "MODE=%~1"
set "DIR=%~2"
if "%MODE%"=="" set "MODE=menu"
if "%DIR%"=="" set "DIR=%USERPROFILE%"
set "KIMI=%USERPROFILE%\.kimi-code\bin\kimi.exe"

if /i "%~3"=="inner" goto INNER
:: Re-launch inside Windows Terminal so everything runs in the real window
:: instead of a flashing console. Fall back to the classic console host.
where wt.exe >nul 2>nul
if errorlevel 1 goto INNER
wt.exe --title "Kimi CLI" -d "%DIR%" "%~f0" %MODE% "%DIR%" inner
exit /b 0

:INNER
cd /d "%DIR%"
cls
echo ==============================================================================
echo  _  ___       _    ___ _    ___
echo ^| ^|/ (_^)_ __ (_)  / __^| ^|  ^|_ _^|
echo ^| ' ^<^| ^| '  \^| ^| ^| (__^| ^|__ ^| ^|
echo ^|_^|\_\_^|_^|_^|_^|_^|_^|  \___^|____^|___^|
echo.
echo                    KIMI CLI LAUNCHER v%VERSION%
echo ==============================================================================
echo  Folder: %DIR%
echo.
echo === Update check ===
if exist "%~dp0update-kimi.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-kimi.ps1"
) else (
    echo    [SKIP] update-kimi.ps1 not found
)

if /i not "%MODE%"=="menu" goto RESOLVE

:MODE_MENU
echo.
echo === Mode ===
echo    [1] Auto + K3 Max   (auto mode, K3 1M context, max thinking)
echo    [2] Auto            (fully autonomous, never asks)
echo    [3] Yolo            (auto-approve tools, may still ask)
echo    [4] Plan            (plan first, execute after approval)
echo    [5] Manual          (confirm every tool)
echo.
set "PICK="
set /p "PICK=Select a mode [1-5]: "
if not defined PICK goto MODE_MENU
set "PICK=%PICK:~0,1%"
if "%PICK%"=="1" set "MODE=auto-max" & goto RESOLVE
if "%PICK%"=="2" set "MODE=auto" & goto RESOLVE
if "%PICK%"=="3" set "MODE=yolo" & goto RESOLVE
if "%PICK%"=="4" set "MODE=plan" & goto RESOLVE
if "%PICK%"=="5" set "MODE=manual" & goto RESOLVE
echo    [!!] Invalid selection - pick 1 to 5.
goto MODE_MENU

:RESOLVE
set "ARGS="
if /i "%MODE%"=="auto-max" (
    rem Auto permission mode, K3 model (1M context), max thinking effort.
    set "ARGS=--auto -m kimi-code/k3"
    set "KIMI_MODEL_THINKING_EFFORT=max"
)
if /i "%MODE%"=="auto" set "ARGS=--auto"
if /i "%MODE%"=="yolo" set "ARGS=--yolo"
if /i "%MODE%"=="plan" set "ARGS=--plan"

echo.
echo === Session ===
echo    [1] New chat
echo    [2] Browse previous chats
echo.
set "SPICK="
set /p "SPICK=Select [1-2] (default 1): "
if not defined SPICK set "SPICK=1"
set "SPICK=%SPICK:~0,1%"
if "%SPICK%"=="2" set "ARGS=%ARGS% --session"

echo.
echo ==============================================================================
if defined ARGS ( echo  Launching: kimi %ARGS% ) else ( echo  Launching: kimi )
echo ==============================================================================
echo.
"%KIMI%" %ARGS%
if errorlevel 1 pause
exit /b 0
