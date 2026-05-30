---
name: performance
description: >
  Use this skill when the user wants to optimize speed, reduce memory usage,
  or fix slow code. Triggers on 'this is too slow', 'optimize this', 'reduce
  latency', 'high memory usage', 'performance review', 'profile this', 'N+1
  query', 'this times out', 'slow API response', 'CPU spike', or 'how do I
  make this faster'. Also triggers on 'cache this', 'add an index', 'lazy
  load', or 'reduce bundle size'. Do NOT optimize without measuring first —
  this skill enforces measure-first. Do NOT use for correctness bugs — use
  /skills/debugging instead.
version: "1.0"
updated: "2026-05-30"
---

# Performance Skill

## Safety — Read First

- NEVER optimize without measuring first — you will optimize the wrong thing
- NEVER cache data that must be consistent (financial balances, inventory counts) without an invalidation strategy
- NEVER add an index without checking the write overhead on high-write tables
- If optimizing a database query, test on production-scale data, not dev fixtures

## The Measure-First Rule

```
1. MEASURE   — Profile before touching any code
2. IDENTIFY  — Find the actual bottleneck (not the assumed one)
3. CHANGE    — Make one change at a time
4. MEASURE   — Confirm improvement with numbers
5. REPEAT    — If more improvement needed, go back to step 1
```

## Output Template

```
## Performance Analysis: {component}

### Measured baseline
{metric: response time / memory / CPU — e.g. "P95 = 4.2s", "memory = 800MB"}

### Bottleneck identified
{file:line or query} — {why this is slow}

### Fix
{specific change}

### Expected improvement
{estimated gain — e.g. "should reduce to ~200ms", "eliminates N+1"}

### How to verify
{profiling command or metric to check after the fix}

### Trade-offs
{what this optimization costs — memory, complexity, consistency, etc.}
```

## Worked Examples

### Example 1 — N+1 Query

INPUT:
```python
def get_orders_with_users():
    orders = Order.query.all()
    return [{"order": o.id, "user": o.user.name} for o in orders]
# Takes 8 seconds for 500 orders
```

OUTPUT:
```
## Performance Analysis: get_orders_with_users()

### Measured baseline
500 orders → 8s response time (501 queries: 1 for orders + 1 per order for user)

### Bottleneck identified
o.user.name on each iteration triggers a separate SELECT per order — classic N+1.

### Fix
orders = Order.query.options(joinedload(Order.user)).all()
# Replaces 501 queries with 1 JOIN query

### Expected improvement
~20ms (1 query vs 501 queries — ~400x improvement)

### How to verify
Add query counter logging:
  from sqlalchemy import event
  # count queries before and after

### Trade-offs
joinedload fetches all user fields even if you only need name.
Use load_only(User.name) to fetch only the needed column.
```

### Example 2 — Repeated computation

INPUT:
```javascript
function getDashboard(users) {
  return users.map(user => ({
    name: user.name,
    tier: getTier(user.totalSpend),  // expensive calculation
    discount: getDiscount(user.totalSpend)  // calls getTier internally too
  }));
}
```

OUTPUT:
```
## Performance Analysis: getDashboard()

### Bottleneck identified
getTier() called twice per user — once directly, once inside getDiscount().
For 10,000 users: 20,000 getTier() calls instead of 10,000.

### Fix
function getDashboard(users) {
  return users.map(user => {
    const tier = getTier(user.totalSpend);  // compute once
    return {
      name: user.name,
      tier,
      discount: getDiscount(tier)  // pass tier instead of recomputing
    };
  });
}
// Requires getDiscount() to accept a tier instead of spend — change signature

### Expected improvement
50% reduction in getTier() calls. Impact depends on getTier() cost.

### How to verify
console.time('dashboard'); getDashboard(users); console.timeEnd('dashboard');

### Trade-offs
Requires changing getDiscount() signature — check all callers.
```

## Quick Wins by Category (Secondary Reference)

### Database
- Add index on columns used in WHERE, JOIN, ORDER BY clauses
- Use `SELECT specific_columns` instead of `SELECT *`
- Use pagination — never return unbounded result sets
- Fix N+1 queries with eager loading (joinedload, includes, preload)
- Use `EXPLAIN ANALYZE` to verify index is being used

### Backend / API
- Cache expensive, stable computations (Redis, in-memory)
- Move heavy work to background jobs (Celery, Sidekiq, BullMQ)
- Add response compression (gzip/brotli)
- Use connection pooling for DB and HTTP clients

### Frontend
- Lazy load routes and heavy components
- Debounce search inputs and resize handlers
- Avoid layout thrash (batch DOM reads then writes)
- Use `useMemo` / `useCallback` only where profiling shows it helps

### General
- Profile first — never guess
- Optimize the slowest thing, not the most interesting thing
- A 10x algorithmic improvement beats any micro-optimization
