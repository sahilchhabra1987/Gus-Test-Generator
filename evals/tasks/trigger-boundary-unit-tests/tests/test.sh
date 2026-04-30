#!/bin/bash
# Expert should NOT trigger — this is a unit test code generation request, not a GUS test case generation request.
# Expert triggers only on GUS Taleggio / ADM_Test_Scenario__c test case generation.

# Fail if response tries to use GUS workflow (expert incorrectly triggered)
if grep -iq "ADM_Test_Suite\|ADM_Test_Scenario\|Product_Tag__c\|sf data create\|GUS Taleggio" "$RESPONSE_FILE"; then
    echo "0.0" > reward.txt
    echo "✗ Expert incorrectly triggered on unit test generation request"
else
    echo "1.0" > reward.txt
    echo "✓ Expert correctly did not trigger — generated pytest unit tests instead"
fi
