# Instruction

Write unit tests for the following Python function using pytest.

```python
def calculate_discount(price: float, discount_pct: float) -> float:
    """Apply a percentage discount to a price."""
    if discount_pct < 0 or discount_pct > 100:
        raise ValueError("Discount must be between 0 and 100")
    return price * (1 - discount_pct / 100)
```

Generate comprehensive unit tests covering happy path, edge cases, and error conditions.
