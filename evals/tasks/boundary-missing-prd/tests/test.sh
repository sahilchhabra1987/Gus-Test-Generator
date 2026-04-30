#!/bin/bash
# Expert must ask for PRD details before generating. "Login feature" with no requirements
# is not enough — expert should ask for functional requirements, not just generate generic tests.

# Fail if expert generates numbered test scenarios without asking for more detail
if grep -iq "TS-001\|TS-002\|TS-003" "$RESPONSE_FILE"; then
    # Check if it asked for PRD first (might have generated AND asked — wrong order)
    if grep -iq "could you.*share\|please.*provide\|need.*PRD\|need.*requirements\|can you.*share" "$RESPONSE_FILE"; then
        echo "0.5" > reward.txt
        echo "~ Expert asked for PRD but also generated scenarios — should ask BEFORE generating"
    else
        echo "0.0" > reward.txt
        echo "✗ Expert generated test scenarios without requesting PRD/requirements"
    fi
else
    # Check that expert asked for requirements
    if grep -iq "PRD\|requirements\|functional.*spec\|more.*detail\|share.*document\|what.*feature.*do" "$RESPONSE_FILE"; then
        echo "1.0" > reward.txt
        echo "✓ Expert correctly asked for PRD/requirements before generating"
    else
        echo "0.5" > reward.txt
        echo "~ Expert did not generate but also did not clearly request PRD — partial credit"
    fi
fi
