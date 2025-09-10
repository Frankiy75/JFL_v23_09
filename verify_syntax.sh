#!/bin/bash

# Simple MQL5 Syntax Verification Script
# This script performs basic syntax checks for the ZigZag indicator

echo "=== ZigZag Indicator Syntax Verification ==="
echo

MQL_FILE="JFL_v23_10.mq5"

if [ ! -f "$MQL_FILE" ]; then
    echo "ERROR: $MQL_FILE not found!"
    exit 1
fi

echo "File found: $MQL_FILE"
echo "File size: $(wc -c < $MQL_FILE) bytes"
echo "Total lines: $(wc -l < $MQL_FILE)"
echo

# Check for basic syntax issues
echo "=== Basic Syntax Checks ==="

# Check for unmatched braces
OPEN_BRACES=$(grep -o '{' $MQL_FILE | wc -l)
CLOSE_BRACES=$(grep -o '}' $MQL_FILE | wc -l)
echo "Open braces: $OPEN_BRACES"
echo "Close braces: $CLOSE_BRACES"

if [ $OPEN_BRACES -eq $CLOSE_BRACES ]; then
    echo "✅ Braces are balanced"
else
    echo "❌ Braces are NOT balanced"
fi

# Check for function declarations vs definitions
echo
echo "=== Function Analysis ==="
FUNC_DECLARATIONS=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*.*(" $MQL_FILE || true)
echo "Function-like declarations: $FUNC_DECLARATIONS"

# Check for key functions we modified
echo
echo "=== Modified Functions Check ==="
if grep -q "bool IsPivotConfirmed" $MQL_FILE; then
    echo "✅ IsPivotConfirmed function found"
else
    echo "❌ IsPivotConfirmed function missing"
fi

if grep -q "bool ValidateCurrentExtreme" $MQL_FILE; then
    echo "✅ ValidateCurrentExtreme function found"
else
    echo "❌ ValidateCurrentExtreme function missing"
fi

if grep -q "void InterpolateLine" $MQL_FILE; then
    echo "✅ InterpolateLine function found"
else
    echo "❌ InterpolateLine function missing"
fi

# Check for semicolon issues (basic check)
echo
echo "=== Basic Statement Checks ==="
MISSING_SEMICOLON=$(grep -n -E "^\s*[^/{}]*[^;{}]\s*$" $MQL_FILE | grep -v "^\s*$" | grep -v "//" | head -5)
if [ -z "$MISSING_SEMICOLON" ]; then
    echo "✅ No obvious missing semicolons detected"
else
    echo "⚠️  Potential missing semicolons (might be false positives):"
    echo "$MISSING_SEMICOLON"
fi

# Check for string literals and comments balance
echo
echo "=== String and Comment Balance ==="
DOUBLE_QUOTES=$(grep -o '"' $MQL_FILE | wc -l)
if [ $((DOUBLE_QUOTES % 2)) -eq 0 ]; then
    echo "✅ Double quotes appear balanced"
else
    echo "❌ Double quotes might be unbalanced"
fi

# Check for key indicator properties
echo
echo "=== Indicator Properties Check ==="
if grep -q "#property indicator_chart_window" $MQL_FILE; then
    echo "✅ Chart window indicator property found"
else
    echo "❌ Chart window indicator property missing"
fi

if grep -q "#property indicator_buffers" $MQL_FILE; then
    echo "✅ Indicator buffers property found"
else
    echo "❌ Indicator buffers property missing"
fi

if grep -q "OnInit()" $MQL_FILE; then
    echo "✅ OnInit function found"
else
    echo "❌ OnInit function missing"
fi

if grep -q "OnCalculate(" $MQL_FILE; then
    echo "✅ OnCalculate function found"
else
    echo "❌ OnCalculate function missing"
fi

echo
echo "=== Summary ==="
echo "Basic syntax verification completed."
echo "Note: This is a basic check. Full compilation should be done in MetaTrader 5."
echo "=== End of Verification ==="