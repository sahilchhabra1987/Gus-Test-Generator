#!/bin/bash
# Test that expert triggers and starts workflow

# Check that response mentions collecting inputs or starts generation workflow
if grep -iq "PRD\|product tag\|test case\|test suite\|test scenario" "$RESPONSE_FILE"; then
    echo "1.0" > reward.txt
    echo "✓ Expert triggered and started workflow"
else
    echo "0.0" > reward.txt
    echo "✗ Expert did not trigger or start workflow"
fi
