---
name: database-schema
description: >
  Use this skill when the user wants to design, review, or change a database
  schema. Triggers on 'design a schema', 'what tables do I need', 'schema
  review', 'add a column', 'database design', 'entity relationship', 'how
  should I store this', 'foreign key', 'normalize this', 'migration script',
  'add a table', or 'schema change'. Also triggers on 'one-to-many', 'many-to-many',
  'junction table', 'index strategy', or 'schema for this feature'. Do NOT
  use for writing queries against an existing schema — use /skills/sql instead.
version: "1.0"
updated: "2026-05-30"
---

# Database Schema Skill

## Safety — Read First

- NEVER add a NOT NULL column to a large production table without a default or a staged migration
- NEVER DROP COLUMN or DROP TABLE without confirming data is backed up and no code references it
- NEVER rename a column without a dual-write migration period in production
- Any schema change that locks a table must be scheduled during low-traffic or use online DDL

## Output Template

```
## Schema Design: {feature or entity name}

### Tables

#### {table_name}
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid / bigint | PRIMARY KEY | Use uuid for distributed systems |
| {col} | {type} | {NOT NULL / DEFAULT / FK} | {notes} |
| created_at | timestamptz | NOT NULL DEFAULT now() | |
| updated_at | timestamptz | NOT NULL DEFAULT now() | Add trigger to auto-update |

#### Indexes
- {index definition} — {why: query pattern it serves}

#### Relationships
- {table.col} → {table.col}: {one-to-many / many-to-many} — {notes}

### Migration script
{SQL DDL to create or alter the tables}

### Rollback script
{SQL to undo the migration}

### Trade-offs
{decisions made and alternatives considered}
```

## Worked Examples

### Example 1 — New feature schema

INPUT:
Design a schema for an e-commerce order system. Users place orders. Each order has multiple items. Items reference products.

OUTPUT:
```
## Schema Design: Order System

### Tables

#### users (existing — shown for reference)
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PRIMARY KEY |
| email | varchar(255) | NOT NULL UNIQUE |
| created_at | timestamptz | NOT NULL DEFAULT now() |

#### orders
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PRIMARY KEY DEFAULT gen_random_uuid() | |
| user_id | uuid | NOT NULL REFERENCES users(id) | |
| status | varchar(20) | NOT NULL DEFAULT 'pending' | pending/confirmed/shipped/cancelled |
| total_amount | numeric(10,2) | NOT NULL | Denormalized for query speed |
| created_at | timestamptz | NOT NULL DEFAULT now() | |
| updated_at | timestamptz | NOT NULL DEFAULT now() | |

#### order_items
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PRIMARY KEY DEFAULT gen_random_uuid() | |
| order_id | uuid | NOT NULL REFERENCES orders(id) ON DELETE CASCADE | |
| product_id | uuid | NOT NULL REFERENCES products(id) | |
| quantity | integer | NOT NULL CHECK (quantity > 0) | |
| unit_price | numeric(10,2) | NOT NULL | Snapshot price at time of order |
| created_at | timestamptz | NOT NULL DEFAULT now() | |

#### Indexes
- `CREATE INDEX idx_orders_user_id ON orders(user_id)` — queries by user
- `CREATE INDEX idx_orders_status ON orders(status)` — status dashboards
- `CREATE INDEX idx_order_items_order_id ON order_items(order_id)` — item lookups

#### Relationships
- users → orders: one-to-many (one user, many orders)
- orders → order_items: one-to-many with CASCADE DELETE
- products → order_items: one-to-many (product can be in many orders)

### Migration script
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  status varchar(20) NOT NULL DEFAULT 'pending',
  total_amount numeric(10,2) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id),
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price numeric(10,2) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

### Rollback script
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;

### Trade-offs
- unit_price is stored on order_items (not fetched from products) so historical
  orders aren't affected when product prices change
- total_amount is denormalized on orders for fast dashboard queries — must be
  kept in sync with order_items on insert/update
```

### Example 2 — Safe column addition

INPUT:
Add an `avatar_url` column to the existing users table. It's optional.

OUTPUT:
```
## Schema Design: Add avatar_url to users

### Migration script
-- Safe: nullable column, no default needed, no table lock on PostgreSQL
ALTER TABLE users ADD COLUMN avatar_url varchar(500);

-- Add index only if you'll query by avatar_url (unlikely — skip for now)

### Rollback script
ALTER TABLE users DROP COLUMN avatar_url;

### Trade-offs
- Nullable (no DEFAULT) — existing rows get NULL, which is correct for optional field
- varchar(500) — enough for most CDN URLs; increase if needed
- No NOT NULL constraint until all rows have been backfilled (if ever required)
```

## Schema Design Rules (Secondary Reference)

1. **Always store timestamps** — `created_at` and `updated_at` on every table
2. **Use uuid for distributed systems**, bigint sequences for single-node systems
3. **Snapshot prices/values** — never rely on a JOIN to historical data that changes (e.g. product price)
4. **Nullable = optional, NOT NULL = required** — be explicit about every column
5. **Add indexes for your query patterns**, not speculatively — indexes slow writes
6. **Use ON DELETE CASCADE carefully** — make sure child deletion is always correct
7. **Staged migration for NOT NULL columns**: add nullable → backfill → add NOT NULL constraint
