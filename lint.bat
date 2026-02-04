@echo off
REM Luacheck lint script for WideTradeSkillsPlus

echo Running Luacheck on WideTradeSkillsPlus...
echo.

luacheck *.lua

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Luacheck completed successfully!
) else (
    echo.
    echo Luacheck found issues. Please review the output above.
    exit /b %ERRORLEVEL%
)
