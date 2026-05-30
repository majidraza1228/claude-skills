---
name: logging
description: >
  Use this skill when the user wants to add, improve, or review logging in
  their code. Triggers on 'add logging', 'how should I log this', 'structured
  logging', 'what should I log', 'logging best practices', 'observability',
  'this is hard to debug in production', 'add tracing', 'log levels', or 'why
  can't I see what's happening'. Also triggers on 'correlation ID', 'request
  ID', 'log format', 'centralized logging', or 'when should I use error vs
  warn'. Do NOT use for fixing bugs found via logs — use /skills/debugging
  instead.
version: "1.0"
updated: "2026-05-30"
---

# Logging Skill

## Safety — Read First

- NEVER log passwords, tokens, API keys, or full credit card numbers
- NEVER log PII (emails, names, SSNs) without confirming compliance requirements
- NEVER use print() or console.log() in production code — use a proper logger
- Sanitize user-supplied data before logging — it can contain injection payloads

## Log Level Guide

| Level | Use when | Example |
|-------|----------|---------|
| ERROR | Something broke that needs attention now | DB connection failed, payment rejected |
| WARN | Something unexpected happened but recovered | Retry succeeded, deprecated API called |
| INFO | Normal significant events | User logged in, order placed, job started |
| DEBUG | Detailed trace for diagnosing issues | Query params, function arguments, intermediate values |

**Rule:** INFO in production. DEBUG only in dev/staging or behind a flag.

## Output Template

```
## Logging Plan: {component}

### What to log
| Event | Level | Fields to include |
|-------|-------|-------------------|
| {event} | {level} | {field1, field2, ...} |

### What NOT to log
- {sensitive field or reason}

### Structured log format
{example log entry as JSON}

### Where to add it
{file:line references}
```

## Worked Examples

### Example 1 — API endpoint

INPUT:
Add logging to my Flask POST /orders endpoint.

OUTPUT:
```
## Logging Plan: POST /orders

### What to log
| Event | Level | Fields to include |
|-------|-------|-------------------|
| Request received | INFO | request_id, user_id, item_count |
| Validation failed | WARN | request_id, user_id, validation_errors |
| Order created | INFO | request_id, user_id, order_id, total_amount |
| Payment failed | ERROR | request_id, user_id, order_id, error_code (NOT card details) |
| Unexpected exception | ERROR | request_id, user_id, exception type + message + stack trace |

### What NOT to log
- Payment card numbers or CVV
- Full request body (may contain sensitive data)
- User passwords

### Structured log format
{
  "timestamp": "2026-05-17T10:23:01Z",
  "level": "INFO",
  "event": "order_created",
  "request_id": "req_abc123",
  "user_id": "usr_456",
  "order_id": "ord_789",
  "total_amount": 49.99
}

### Implementation
import logging
import uuid

logger = logging.getLogger(__name__)

@app.route('/orders', methods=['POST'])
def create_order():
    request_id = str(uuid.uuid4())
    user_id = current_user.id

    logger.info("order_request_received", extra={
        "request_id": request_id, "user_id": user_id
    })

    try:
        order = Order.create(...)
        logger.info("order_created", extra={
            "request_id": request_id,
            "user_id": user_id,
            "order_id": order.id,
            "total_amount": order.total
        })
        return jsonify(order), 201

    except ValidationError as e:
        logger.warning("order_validation_failed", extra={
            "request_id": request_id,
            "user_id": user_id,
            "errors": e.messages
        })
        return jsonify({"error": e.messages}), 400

    except Exception as e:
        logger.error("order_creation_failed", exc_info=True, extra={
            "request_id": request_id, "user_id": user_id
        })
        return jsonify({"error": "internal_error"}), 500
```

## Structured Logging Rules (Secondary Reference)

1. **Use structured logs (JSON)** — machines parse JSON; humans can too. Plain strings are grep-only.
2. **Always include a correlation/request ID** — lets you trace one request across services
3. **Log at boundaries** — entering/leaving a service, calling an external API, starting/finishing a job
4. **Log the outcome, not just the action** — "payment_failed" not just "calling payment API"
5. **Include enough context to reproduce** — IDs, amounts, error codes — not "something went wrong"
6. **Use `exc_info=True` on exceptions** — captures the full stack trace automatically
7. **Don't log in a tight loop** — sample high-frequency events or aggregate them
