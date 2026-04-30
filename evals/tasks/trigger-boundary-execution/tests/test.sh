#!/bin/bash
# Expert should NOT trigger — this is test result tracking, which is explicitly out of scope.
# Expert scope: generate test cases. NOT: track results, update test status, report on runs.

# Fail if response tries to generate new test scenarios (wrong behavior)
if grep -iq "ADM_Test_Suite__c\|generate.*test.*scenario\|15 scenarios\|coverage" "$RESPONSE_FILE"; then
    echo "0.0" > reward.txt
    echo "✗ Expert incorrectly tried to generate test cases instead of declining this out-of-scope request"
else
    # Check that response correctly redirects to GUS UI or declines
    if grep -iq "out of scope\|GUS.*UI\|Taleggio.*UI\|not.*handle\|cannot.*track\|result tracking" "$RESPONSE_FILE"; then
        echo "1.0" > reward.txt
        echo "✓ Expert correctly declined out-of-scope test execution tracking request"
    else
        echo "0.5" > reward.txt
        echo "~ Expert did not generate test cases but also did not clearly redirect — partial credit"
    fi
fi
