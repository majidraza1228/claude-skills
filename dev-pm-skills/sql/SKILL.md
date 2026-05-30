---
name: sql
description: >
  Use this skill when the user wants to write, review, optimize, or explain a
  SQL query. Triggers on 'write a SQL query', 'how do I query this', 'SQL for
  this report', 'optimize this query', 'explain this SQL', 'JOIN help', 'GROUP
  BY', 'window function', 'this query is slow', 'add an index', 'database
  query', 'write a migration', or 'schema change'. Also triggers on 'PostgreSQL',
  'MySQL', 'SQLite', 'aggregate query', 'subquery', or 'CTE'. Do NOT use for
  ORM-specific query builders — describe the ORM and ask separately.
version: "1.0"
updated: "2026-05-30"
---

# SQL Skill

## Safety — Read First

- NEVER write UPDATE or DELETE without a WHERE clause — always flag this
- NEVER run schema changes (ALTER, DROP) without a backup/rollback plan
- Always add LIMIT to exploratory SELECT queries on large tables
- Flag any query that could lock a table in production (e.g. adding index without CONCURRENTLY)
- If the user asks to DROP a table or column, confirm the intent explicitly

## Output Template

```
## Query: {what it does}

### SQL
{query}

### How it works
{step-by-step explanation of each clause}

### Performance notes
{index recommendations, estimated row scans, potential issues}

### Safety notes
{any risks — missing WHERE, lock contention, large scans}
```

## Worked Examples

### Example 1 — Aggregation with filter

INPUT:
Show me total revenue per customer for orders placed in the last 30 days, only for customers with more than $500 in orders.

OUTPUT:
```
## Query: Revenue per customer, last 30 days, >$500

### SQL
SELECT
  c.id,
  c.name,
  SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.created_at >= NOW() - INTERVAL '30 days'
GROUP BY c.id, c.name
HAVING SUM(o.amount) > 500
ORDER BY total_revenue DESC;

### How it works
1. JOIN customers to orders on customer_id
2. WHERE filters to last 30 days
3. GROUP BY aggregates per customer
4. HAVING filters groups after aggregation (must use HAVING, not WHERE, for aggregate conditions)
5. ORDER BY shows highest revenue first

### Performance notes
- Ensure index exists on orders.created_at and orders.customer_id
- Without indexes: full table scan on orders — slow on large tables
- CREATE INDEX idx_orders_customer_date ON orders(customer_id, created_at);

### Safety notes
No DELETE/UPDATE — read-only query. Safe to run in production.
```

### Example 2 — Safe UPDATE with guard

INPUT:
Update all users who haven't logged in for 90 days to status = 'inactive'.

OUTPUT:
```
## Query: Mark inactive users

### SQL
-- Step 1: Preview affected rows first
SELECT id, email, last_login_at
FROM users
WHERE last_login_at < NOW() - INTERVAL '90 days'
  AND status != 'inactive';

-- Step 2: After confirming the preview looks right, run the update
UPDATE users
SET
  status = 'inactive',
  updated_at = NOW()
WHERE last_login_at < NOW() - INTERVAL '90 days'
  AND status != 'inactive';

### How it works
- Filters users whose last login was >90 days ago
- Skips already-inactive users (idempotent — safe to re-run)
- Sets updated_at for audit trail

### Performance notes
- Add index on last_login_at if this runs frequently
- On large tables, consider batching: add LIMIT 1000 and loop

### Safety notes
IMPORTANT: Run the SELECT preview first — confirm row count before UPDATE.
No LIMIT on the UPDATE is intentional (idempotent), but verify the WHERE
clause covers exactly the users you intend to affect.
```

### Example 3 — Window function

INPUT:
Show each order with its rank within that customer's orders by amount (highest = rank 1).

OUTPUT:
```
## Query: Order rank per customer

### SQL
SELECT
  o.id,
  o.customer_id,
  o.amount,
  RANK() OVER (
    PARTITION BY o.customer_id
    ORDER BY o.amount DESC
  ) AS rank_by_amount
FROM orders o
ORDER BY o.customer_id, rank_by_amount;

### How it works
- PARTITION BY customer_id: restart ranking for each customer
- ORDER BY amount DESC: highest amount = rank 1
- RANK() gives the same rank to ties (use ROW_NUMBER() to force unique ranks)

### Performance notes
Window functions are computed after WHERE/GROUP BY. Add WHERE filters
before the window function to reduce the dataset first.
```

## Common Patterns (Secondary Reference)

| Need | Pattern |
|------|---------|
| Top N per group | `RANK() OVER (PARTITION BY x ORDER BY y) <= N` |
| Running total | `SUM(amount) OVER (ORDER BY date)` |
| Previous row value | `LAG(amount, 1) OVER (ORDER BY date)` |
| Deduplicate | `SELECT DISTINCT ON (email) * FROM users ORDER BY email, created_at DESC` |
| Upsert | `INSERT INTO ... ON CONFLICT (key) DO UPDATE SET ...` |
| Safe migration | `ALTER TABLE ... ADD COLUMN ... DEFAULT NULL` then backfill separately |
| Non-blocking index | `CREATE INDEX CONCURRENTLY idx_name ON table(col)` (PostgreSQL) |
