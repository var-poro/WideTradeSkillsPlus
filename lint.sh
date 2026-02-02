#!/bin/bash
# Luacheck lint script for WideTradeSkillsPlus

echo "Running Luacheck on WideTradeSkillsPlus..."
echo ""

luacheck *.lua

if [ $? -eq 0 ]; then
    echo ""
    echo "Luacheck completed successfully!"
else
    echo ""
    echo "Luacheck found issues. Please review the output above."
    exit $?
fi
