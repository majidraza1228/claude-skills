# Fitness Coach — Split Skill Example

This directory demonstrates **Pattern 7** (skills over 500 lines drop their bottom half).

## The Problem

The original `fitness-coach` skill was 800 lines. Safety rules at line 700+
never fired in testing. The fix: split into 4 focused sub-skills, each under
200 lines, with safety rules at the top of each one.

## Original Structure (Bad — 800 lines, single file)

```
SKILL.md (800 lines)
├── Lines 1-100:    Exercise selection     ✅ Always worked
├── Lines 100-200:  Rep/set calculations   ✅ Always worked
├── Lines 200-350:  Progression models     ✅ Usually worked
├── Lines 350-500:  Nutrition guidance     ⚠️  Sometimes worked
├── Lines 500-650:  Recovery protocols     ⚠️  Unreliable
└── Lines 650-800:  Safety warnings        ❌ Never fired
```

## New Structure (Good — 4 files, each under 200 lines)

```
fitness-coach/
├── README.md          ← You are here
├── exercise/
│   └── SKILL.md       ← Exercise selection + programming (180 lines)
├── nutrition/
│   └── SKILL.md       ← Meal planning + macros (150 lines)
├── recovery/
│   └── SKILL.md       ← Rest days, deloads, sleep (120 lines)
└── safety/
    └── SKILL.md       ← Injury mods, contraindications (100 lines)
```

Each sub-skill has:
1. **Safety rules in lines 1–20** (always fires)
2. **Output template in lines 20–50** (always fires)
3. **Worked example in lines 50–100** (always fires)
4. **Detailed rules after line 100** (usually fires — and that's fine for non-critical rules)

## Key Takeaway

The safety rules that *never fired* at line 700 of the monolith now fire
*every time* at line 5 of each sub-skill. Same rules, different position,
completely different behavior.
