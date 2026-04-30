#!/bin/bash
# Expert should ask for PRD and Product Tag before generating anything.
# It must NOT start generating test scenarios without inputs.

# Fail if expert starts generating test scenarios immediately (skipped input collection)
if grep -iq "TS-001\|TS-002\|Test Scenario 1\|Functional Test\|P0.*Happy Path" "$RESPONSE_FILE"; then
    echo "0.0" > reward.txt
    echo "✗ Expert generated test scenarios without collecting PRD and Product Tag first"
    exit 0
fi

# Check that expert asks for PRD
PRD_ASKED=false
if grep -iq "PRD\|product requirement\|requirements document\|feature description" "$RESPONSE_FILE"; then
    PRD_ASKED=true
fi

# Check that expert asks for Product Tag
TAG_ASKED=false
if grep -iq "product tag\|Product_Tag__c\|tag.*GUS\|GUS.*tag" "$RESPONSE_FILE"; then
    TAG_ASKED=true
fi

if $PRD_ASKED && $TAG_ASKED; then
    echo "1.0" > reward.txt
    echo "✓ Expert correctly asked for both PRD and Product Tag before generating"
elif $PRD_ASKED || $TAG_ASKED; then
    echo "0.5" > reward.txt
    echo "~ Expert asked for one input but not both — partial credit"
else
    echo "0.0" > reward.txt
    echo "✗ Expert did not ask for required inputs"
fi
