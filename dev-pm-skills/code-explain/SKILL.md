---
name: code-explain
description: >
  Use this skill when the user wants to understand code they didn't write or
  can't follow. Triggers on 'explain this code', 'what does this do', 'walk me
  through this', 'I don't understand this function', 'what is this regex',
  'how does this algorithm work', 'explain this line by line', or 'what is this
  pattern called'. Also triggers on 'why is this written this way', 'what does
  this return', or 'summarize this file'. Do NOT use for reviewing code quality
  — use /skills/code-review instead. Do NOT use for fixing bugs — use
  /skills/debugging instead.
version: "1.0"
updated: "2026-05-30"
---

# Code Explain Skill

## Safety — Read First

- If the code contains credentials, tokens, or PII, note it immediately before explaining anything
- Never execute code to demonstrate its behavior — explain statically

## Output Template

Adjust depth based on the user's question. Default to the Standard explanation.

```
## What this code does
{1-2 sentence plain-English summary of the purpose}

## How it works
{step-by-step walkthrough — use numbered steps, reference line numbers}

## Key concepts
{explain any non-obvious patterns, algorithms, or language features used}

## Example
Input:  {example input}
Output: {what the code produces}

## Gotchas
{anything that could surprise or trip up the reader}
```

## Worked Examples

### Example 1 — Algorithm

INPUT:
```python
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```

OUTPUT:
```
## What this code does
Searches a sorted list for a target value and returns its index (or -1 if not found).
It's ~20x faster than a linear scan for large lists.

## How it works
1. Start with two pointers: lo (start) and hi (end of list)
2. Each iteration, check the middle element
3. If it matches → return its index
4. If the middle is too small → discard the left half (lo = mid + 1)
5. If the middle is too big → discard the right half (hi = mid - 1)
6. If lo > hi, the value isn't in the list → return -1

## Key concepts
Binary search: each step eliminates half the remaining elements.
Time complexity: O(log n) — a list of 1 million items takes at most 20 comparisons.

## Example
arr = [1, 3, 5, 7, 9], target = 7
Step 1: mid=2, arr[2]=5 < 7 → lo=3
Step 2: mid=3, arr[3]=7 == 7 → return 3

## Gotchas
- The list MUST be sorted — binary search gives wrong results on unsorted input
- (lo + hi) // 2 avoids integer overflow vs (lo + hi) / 2 in languages with fixed integers
```

### Example 2 — Regex

INPUT:
```
^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$
```

OUTPUT:
```
## What this code does
Validates that a string looks like an email address.

## How it works
^           — must start at beginning of string
[\w.-]+     — one or more word chars (a-z, 0-9, _), dots, or hyphens → username part
@           — literal @ symbol
[\w.-]+     — one or more word chars, dots, or hyphens → domain name
\.          — literal dot (escaped)
[a-zA-Z]{2,} — two or more letters → top-level domain (com, org, io...)
$           — must end at end of string

## Example
"user@example.com"  → matches
"user@.com"         → fails (no domain before dot)
"user@com"          → fails (no dot + TLD)
"@example.com"      → fails (no username)

## Gotchas
- This is a basic check — it won't catch all invalid emails (e.g. "a@b.c" passes)
- For production, prefer sending a confirmation email over regex validation
- Doesn't support quoted strings or IP address domains (RFC 5321 edge cases)
```

## Explanation Depth Guide

| User says | Depth to use |
|-----------|-------------|
| "what does this do" | 2-sentence summary only |
| "explain this" | Standard template |
| "walk me through line by line" | Full step-by-step with line refs |
| "explain like I'm new to Python" | Add language concept explanations |
| "why is it written this way" | Focus on design rationale + alternatives |
