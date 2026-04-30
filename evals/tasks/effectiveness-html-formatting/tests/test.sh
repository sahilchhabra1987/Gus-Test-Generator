#!/bin/bash
# Expert must format Test_Details__c content using HTML tags.
# Plain text output = failure. Proper HTML structure = pass.

score=0
total=4

# Check 1: Uses <ul> or <ol> tags (not plain bullet points)
if grep -iq "<ul>\|<ol>" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Uses HTML list tags (<ul> or <ol>)"
else
    echo "✗ Missing HTML list tags — plain text bullets won't render in GUS"
fi

# Check 2: Uses <li> tags for list items
if grep -iq "<li>" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Uses <li> tags for list items"
else
    echo "✗ Missing <li> tags"
fi

# Check 3: Uses <strong> or <b> for labels (Action:, Expected:, Preconditions:)
if grep -iq "<strong>\|<b>" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Uses <strong> for labels"
else
    echo "✗ Missing <strong> tags for section labels"
fi

# Check 4: Uses <p> tags for paragraphs (not raw newlines)
if grep -iq "<p>" "$RESPONSE_FILE"; then
    score=$((score + 1))
    echo "✓ Uses <p> tags for paragraphs"
else
    echo "✗ Missing <p> tags — content won't be paragraph-separated in GUS"
fi

# Calculate reward
reward=$(echo "scale=2; $score / $total" | bc)
echo "$reward" > reward.txt
echo "Score: $score/$total"
