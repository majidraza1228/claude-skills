---
name: tdd
description: >
  Use this skill when the user wants to write tests, practice test-driven
  development, asks 'write tests for this', 'how do I test this', 'TDD this
  feature', 'what should I test', 'test coverage', 'unit test', 'integration
  test', or 'mock this dependency'. Also triggers on 'red-green-refactor',
  'test first', 'test pyramid', or 'write failing tests before code'. Do NOT
  use for reviewing existing tests — use /skills/code-review instead. Do NOT
  use for debugging failing tests — diagnose the root cause first.
version: "1.0"
updated: "2026-05-30"
---

# Test-Driven Development Skill

## Safety — Read First

- NEVER write tests that pass without actually exercising the logic (vacuous tests)
- NEVER mock the system under test — only mock its external dependencies
- If a test cannot fail, it is not a test

## The Red-Green-Refactor Loop

```
1. RED   — Write a failing test for the smallest next behavior
2. GREEN — Write the minimum code to make it pass (no more)
3. REFACTOR — Clean up without changing behavior; tests must still pass
```

Repeat for each behavior. Never skip to GREEN without a RED first.

## Output Template

For each test suite requested, output:

```
## Test Plan: {component/function name}

### Behaviors to test
1. {behavior} → {expected outcome}
2. {behavior} → {expected outcome}
...

### Test code
{full test file or block}

### What's NOT tested here
- {intentional gaps and why}

### To run
{command}
```

## Worked Examples

### Example 1

INPUT:
Write TDD tests for a `divide(a, b)` function in Python.

OUTPUT:
```
## Test Plan: divide(a, b)

### Behaviors to test
1. Divides two positive numbers → returns correct float
2. Divides with a negative numerator → returns negative float
3. Divides by zero → raises ValueError
4. Divides zero by a number → returns 0.0
5. Divides two equal numbers → returns 1.0

### Test code
```python
import pytest
from math_utils import divide

def test_divides_positive_numbers():
    assert divide(10, 2) == 5.0

def test_divides_with_negative_numerator():
    assert divide(-10, 2) == -5.0

def test_raises_on_divide_by_zero():
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(10, 0)

def test_zero_divided_by_number():
    assert divide(0, 5) == 0.0

def test_equal_numbers_return_one():
    assert divide(7, 7) == 1.0
```

### What's NOT tested here
- Float precision edge cases — add if this function is used in financial calculations
- Very large numbers — add if overflow is a concern for your domain

### To run
pytest test_math_utils.py -v
```

### Example 2

INPUT:
Write tests for a `UserService.create_user(email, password)` that saves to a database.

OUTPUT:
```
## Test Plan: UserService.create_user(email, password)

### Behaviors to test
1. Valid inputs → user saved to DB, returns user object
2. Duplicate email → raises DuplicateEmailError
3. Invalid email format → raises ValidationError
4. Weak password (< 8 chars) → raises ValidationError
5. DB failure → raises ServiceError (not raw DB error)

### Test code
```python
import pytest
from unittest.mock import MagicMock, patch
from services.user_service import UserService
from exceptions import DuplicateEmailError, ValidationError, ServiceError

@pytest.fixture
def mock_db():
    return MagicMock()

@pytest.fixture
def service(mock_db):
    return UserService(db=mock_db)

def test_creates_user_with_valid_inputs(service, mock_db):
    mock_db.insert.return_value = {"id": "123", "email": "a@b.com"}
    user = service.create_user("a@b.com", "securepass1")
    assert user["email"] == "a@b.com"
    mock_db.insert.assert_called_once()

def test_raises_on_duplicate_email(service, mock_db):
    mock_db.insert.side_effect = DuplicateEmailError("Email taken")
    with pytest.raises(DuplicateEmailError):
        service.create_user("taken@b.com", "securepass1")

def test_raises_on_invalid_email(service):
    with pytest.raises(ValidationError, match="invalid email"):
        service.create_user("not-an-email", "securepass1")

def test_raises_on_weak_password(service):
    with pytest.raises(ValidationError, match="password too short"):
        service.create_user("a@b.com", "short")

def test_wraps_db_error_as_service_error(service, mock_db):
    mock_db.insert.side_effect = Exception("connection lost")
    with pytest.raises(ServiceError):
        service.create_user("a@b.com", "securepass1")
```

### What's NOT tested here
- Password hashing (test separately in a PasswordHasher unit test)
- Email sending on signup (test in integration tests or email service unit tests)

### To run
pytest tests/test_user_service.py -v
```

## Test Pyramid Reference

| Layer | Speed | Coverage | When to write |
|-------|-------|----------|---------------|
| Unit (80%) | Fast | Single function/class in isolation | Always — for every behavior |
| Integration (15%) | Medium | Real DB or service, no mocks | When unit tests can't catch wiring bugs |
| E2E (5%) | Slow | Full stack, real browser/API | For critical user journeys only |

## Rules (Secondary Reference)

1. **Test behaviors, not implementations** — test what the function does, not how it does it
2. **One assertion per concept** — tests that assert many things are hard to diagnose when they fail
3. **Name tests as sentences** — `test_raises_on_divide_by_zero` not `test_divide_3`
4. **Mock external dependencies only** — databases, APIs, file system, clocks
5. **DAMP over DRY** — descriptive and meaningful test code beats tightly abstracted test helpers
6. **If it's hard to test, the design is probably wrong** — difficulty testing is a signal to refactor
