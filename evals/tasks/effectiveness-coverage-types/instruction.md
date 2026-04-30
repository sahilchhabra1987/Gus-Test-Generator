# Instruction

Generate a comprehensive test suite for the following PRD. I need full coverage across all test types.

## PRD: Shopping Cart Checkout

### Overview
Logged-in users can add items to a cart and complete a purchase.

### Requirements
1. Users can add/remove items from cart
2. Cart persists across sessions (30 day expiry)
3. Checkout requires shipping address and payment method
4. Supports credit card, PayPal, and Apple Pay
5. Order confirmation email sent within 2 minutes
6. Inventory decremented on successful checkout
7. Failed payments rollback inventory changes
8. Cart supports max 50 line items

Product Tag ID: a1aEE000002H2InYAK
