---
name: doc-generator
description: >
  Use this skill when the user wants to generate documentation from code,
  create API docs, write README files, produce function/class reference docs,
  or generate JSDoc/docstring/type documentation. Triggers on 'document this
  code', 'write docs for', 'generate API reference', 'add docstrings', 'create
  a README', or 'explain this module'. Covers Python, JavaScript, TypeScript,
  Go, Rust, and Java. Do NOT use for code review or finding bugs — use
  /skills/code-review instead. Do NOT use for writing tutorials or guides — use
  /skills/tutorial-writer instead.
version: "1.0"
updated: "2026-05-30"
---

# Documentation Generator Skill

## Source Table

Before generating docs, extract from these sources:

| Source | Path | What to Extract |
|--------|------|-----------------|
| Source file | {user-provided path} | All public functions, classes, methods, their parameters, return types |
| Existing docs | ./README.md or ./docs/ | Current doc structure, any existing descriptions to preserve |
| Package config | package.json / pyproject.toml / Cargo.toml | Project name, version, description, dependencies |
| Type definitions | *.d.ts / *.pyi / type annotations | Parameter types, return types, generic constraints |

## Output Template

For each public function/method:

```
### `{function_name}({params}): {return_type}`

{One-sentence description of what it does.}

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| {name} | `{type}` | {yes/no} | {what it does} |

**Returns:** `{type}` — {what the return value represents}

**Example:**
```{language}
{minimal working example showing typical usage}
```

**Throws:** {list of exceptions/errors, or "None"}
```

## Worked Example

INPUT:
```python
def retry(fn, max_attempts=3, delay=1.0, backoff=2.0):
    last_error = None
    for attempt in range(max_attempts):
        try:
            return fn()
        except Exception as e:
            last_error = e
            time.sleep(delay * (backoff ** attempt))
    raise last_error
```

OUTPUT:
```
### `retry(fn, max_attempts, delay, backoff): T`

Calls a function with automatic retry on failure using exponential backoff.

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| fn | `Callable[[], T]` | yes | Zero-argument function to call |
| max_attempts | `int` | no | Maximum retry attempts (default: 3) |
| delay | `float` | no | Initial delay in seconds (default: 1.0) |
| backoff | `float` | no | Multiplier applied to delay after each retry (default: 2.0) |

**Returns:** `T` — The return value of `fn` on first successful call

**Example:**
```python
result = retry(lambda: requests.get("https://api.example.com/data"), max_attempts=5)
```

**Throws:** Re-raises the last exception if all attempts fail
```

## Rules
1. Document public API only — skip internal/private functions unless asked
2. Infer types from annotations, defaults, and usage when not explicitly typed
3. Every function gets at least one usage example
4. Use the language's native doc format when asked (JSDoc, docstrings, rustdoc)
