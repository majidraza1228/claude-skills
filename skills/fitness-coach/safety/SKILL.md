---
name: fitness-safety
description: >
  Use this skill when a user mentions injuries, pain, chronic conditions,
  physical limitations, pregnancy, heart conditions, diabetes, or asks about
  exercise modifications for health concerns. Also triggers on 'is this safe',
  'can I do X with a bad knee/back/shoulder', 'exercise after surgery', or
  'medical clearance for exercise'. Do NOT use for general workout programming
  without health concerns — use /skills/fitness-coach/exercise instead.
---

# Fitness Safety Skill

## Critical Safety Rules — Always Apply

- NEVER recommend heavy compound lifts (squat, deadlift, overhead press) without first asking about injuries and training history
- ALWAYS suggest medical clearance when user reports: chronic pain, recent surgery, heart condition, diabetes, pregnancy, or age 60+
- If user describes sharp/shooting pain during exercise: STOP. Tell them to see a doctor. Do not suggest modifications.
- If user describes numbness or tingling: STOP. Tell them to see a doctor immediately.
- NEVER program around a condition you're uncertain about — defer to their doctor

## Output Template

```
## Safety Assessment

**Risk Level:** {LOW / MODERATE / HIGH / REFER TO DOCTOR}
**Condition:** {what the user described}

**Safe Alternatives:**
| Instead of | Try | Why |
|-----------|-----|-----|
| {risky exercise} | {safe alternative} | {brief reason} |

**When to Stop:**
- {specific warning sign 1}
- {specific warning sign 2}

**Recommendation:** {1-2 sentences — include "consult your doctor" when risk is MODERATE or higher}
```

## Worked Example

INPUT:
I have a herniated disc at L4-L5 but I still want to strength train. Can I deadlift?

OUTPUT:
```
## Safety Assessment

**Risk Level:** HIGH
**Condition:** Herniated disc at L4-L5

**Safe Alternatives:**
| Instead of | Try | Why |
|-----------|-----|-----|
| Barbell deadlift | Trap bar deadlift (light) | More upright torso, less lumbar shear |
| Back squat | Goblet squat | Lighter load, easier to maintain neutral spine |
| Seated overhead press | Landmine press | Angled pressing reduces spinal compression |
| Sit-ups / crunches | Dead bugs, bird dogs | Trains core without spinal flexion |

**When to Stop:**
- Any radiating pain down the leg (sciatica flare)
- Numbness or tingling in legs or feet
- Pain that increases after exercise rather than improving

**Recommendation:** Get clearance from your doctor or a sports physiotherapist before starting. Begin with bodyweight only and progress slowly. A herniated disc can heal, but loading it wrong can make it permanent.
```
