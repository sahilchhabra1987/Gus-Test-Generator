#!/bin/bash
# Expert must generate all 4 test types with minimum 15 scenarios total.

score=0
total=6

# Check 1: Generates at least 15 scenarios (count TS- prefixed scenario IDs)
scenario_count=$(grep -oi "TS-[0-9]\+" "$RESPONSE_FILE" | sort -u | wc -l | tr -d ' ')
if [ "$scenario_count" -ge 15 ]; then
    score=$((score + 1))
    echo "✓ Generated $scenario_count scenarios (≥15 required)"
else
    echo "✗ Only generated $scenario_count scenarios (need ≥15)"
fi

# Check 2: Includes Functional tests
if grep -iq "functional\|happy.path\|valid.*input\|success.*flow" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Includes functional tests"
else
    echo "✗ Missing functional test coverage"
fi

# Check 3: Includes Integration tests
if grep -iq "integration\|payment.*gateway\|email.*service\|inventory.*service\|API\|external" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Includes integration tests"
else
    echo "✗ Missing integration test coverage"
fi

# Check 4: Includes Edge Cases / Negative tests
if grep -iq "edge.case\|negative\|invalid\|boundary\|exceed\|empty\|null\|error\|fail" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Includes edge cases / negative tests"
else
    echo "✗ Missing edge case coverage"
fi

# Check 5: Includes Performance tests
if grep -iq "performance\|load\|concurrent\|response.time\|latency\|throughput\|scale" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Includes performance tests"
else
    echo "✗ Missing performance test coverage"
fi

# Check 6: Priority distribution (not all P0)
p0_count=$(grep -oi "P0" "$RESPONSE_FILE" | wc -l | tr -d ' ')
p1_count=$(grep -oi "P1" "$RESPONSE_FILE" | wc -l | tr -d ' ')
p2_count=$(grep -oi "P2" "$RESPONSE_FILE" | wc -l | tr -d ' ')
if [ "$p1_count" -gt 0 ] || [ "$p2_count" -gt 0 ]; then
    score=$((score + 1))
    echo "✓ Priority distribution uses multiple levels (P0=$p0_count, P1=$p1_count, P2=$p2_count)"
else
    echo "✗ All scenarios marked P0 — unrealistic priority distribution"
fi

reward=$(echo "scale=2; $score / $total" | bc)
echo "$reward" > reward.txt
echo "Score: $score/$total"
