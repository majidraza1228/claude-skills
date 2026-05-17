# Skill Audit Checklist

One-page reference. Print this or paste it into an issue for each skill you review.

## Skill: _______________

### Description (Pattern 1)
- [ ] ≥ 150 characters
- [ ] Contains 3+ trigger phrases users actually say
- [ ] Lists file types / languages / domains covered
- [ ] No jargon-only terms (use plain language too)

### Exclusions (Pattern 2)
- [ ] All "do not use for X" are in the description, not the body
- [ ] Every exclusion has a "use /Y instead" redirect
- [ ] Tested: prompting with excluded use case routes correctly

### Tone (Pattern 3)
- [ ] No hedge words: maybe, could, might, consider, perhaps
- [ ] Instructions use imperatives: Flag, List, Output, Return
- [ ] Tone matches desired output precision

### Source References (Pattern 4)
- [ ] No vague "check relevant files" instructions
- [ ] All file references use Source / Path / What to Extract format
- [ ] Exact field names specified (not "the necessary settings")

### Output Template (Pattern 5)
- [ ] Output structure explicitly defined
- [ ] Uses {placeholder} syntax for variable fields
- [ ] Tested: 3 runs produce identical structure

### Examples (Pattern 6)
- [ ] 1–2 worked input → output examples included
- [ ] Examples placed before rules (not after)
- [ ] Examples cover the most common use case

### Length & Priority (Pattern 7)
- [ ] Total lines < 500
- [ ] Safety/critical rules in first 100 lines
- [ ] Output template in first 200 lines
- [ ] Examples in first 250 lines
- [ ] Tested: bottom-half rules actually fire

### Final Validation
- [ ] 3 trigger prompts → skill activates correctly
- [ ] 2 exclusion prompts → skill does NOT activate
- [ ] 3 identical prompts → output structure matches
- [ ] Edge case prompt → safety rules fire
