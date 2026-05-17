# AI Agentic Workflow Patterns

The 7 core patterns for building reliable agents with Claude Code. Each includes architecture, use cases, and a minimal implementation sketch.

---

## Pattern 1: ReAct (Reasoning + Acting)

The agent alternates: **Thought → Action → Observation → Thought → Action**. Each step is explicit.

**Use cases:** Research assistants, data analysis agents, debugging assistants.

**Key components:**
- Reasoning loop with explicit thought steps
- Tool registry (search, calculator, API calls, file ops)
- Max iteration safeguard

```python
class ReActAgent:
    def run(self, task, max_iterations=5):
        context = []
        for i in range(max_iterations):
            thought = self.llm.generate_thought(task, context)
            action = self.llm.select_action(thought, self.tools)
            observation = self.execute_tool(action)
            context.append({thought, action, observation})
            if self.is_complete(observation):
                return self.llm.generate_answer(context)
```

---

## Pattern 2: Reflection / Self-Critique

Agent generates initial output, then critiques and refines it. Each pass improves quality.

**Use cases:** Code review and improvement, essay drafting, data quality checks.

**Key components:** Generator, Critic/Evaluator, Refinement loop, Quality rubric.

```python
class ReflectionAgent:
    def run(self, prompt, max_iterations=3):
        output = self.generate_initial(prompt)
        for i in range(max_iterations):
            critique = self.critique(output, criteria=["correctness", "efficiency", "readability"])
            if critique.is_satisfactory():
                break
            output = self.refine(output, critique)
        return output
```

---

## Pattern 3: Plan-and-Solve

Agent first creates a step-by-step plan, then executes each step. Plans can be adjusted mid-execution.

**Use cases:** Multi-step tasks, project management, complex pipelines.

**Key components:** Planner (decomposes task), Executor (runs steps), Plan adjuster (replans on failure).

```python
class PlanAndExecuteAgent:
    def run(self, task):
        plan = self.create_plan(task)
        results = []
        for step in plan.steps:
            result = self.execute_step(step, results)
            if result.failed:
                plan = self.create_plan(task, partial_results=results)
            results.append(result)
        return self.synthesize(results)
```

---

## Pattern 4: Tool Use / Function Calling

Agent selects and calls tools (APIs, databases, calculators) based on the task.

**Use cases:** Personal assistants (calendar, email, search), system automation, data retrieval.

**Key components:** Tool registry with schemas, tool selection logic, parameter extraction, retry handling.

```python
tools = [
    {"name": "search_email", "description": "Search emails by sender, subject, or date"},
    {"name": "add_calendar_event", "description": "Add event to calendar"}
]

class ToolUseAgent:
    def run(self, user_request):
        tool_calls = self.llm.select_tools(user_request, self.tools)
        results = [self.execute_tool(call.name, call.params) for call in tool_calls]
        return self.llm.synthesize_response(user_request, results)
```

---

## Pattern 5: Multi-Agent Collaboration

Multiple specialized agents work together with distinct roles. They communicate, delegate, and synthesize.

**Use cases:** Software development (architect + coder + tester), research teams, customer support.

**Key components:** Agent roles, communication protocol, orchestrator, shared memory/context.

```python
class MultiAgentOrchestrator:
    def run(self, task):
        research = self.researcher.research(task.topic)   # Phase 1
        draft = self.writer.write(research, task.style)   # Phase 2
        final = self.editor.edit(draft)                   # Phase 3
        return final
```

---

## Pattern 6: Memory & Context Management (RAG)

Agent maintains context across sessions using retrieval-augmented generation or persistent memory.

**Use cases:** Conversational assistants with user history, knowledge bases, personalized tutors.

**Key components:** Vector database, embedding model, retrieval logic, memory update mechanism.

```python
class MemoryAgent:
    def run(self, user_input):
        context = self.retrieve_context(user_input)         # Retrieve relevant past
        response = self.llm.generate(user_input, context)   # Generate with context
        self.store_interaction(user_input, response)         # Store new interaction
        return response
```

---

## Pattern 7: Chain-of-Thought (CoT)

Agent shows explicit reasoning steps before arriving at an answer. Improves accuracy on complex tasks.

**Use cases:** Math problem solving, logical reasoning, debugging and root cause analysis.

```python
COT_TEMPLATE = """
Let's solve this step by step:

Problem: {problem}

Step 1: [Identify what we know]
Step 2: [Identify what we need to find]
Step 3: [Choose the approach]
Step 4: [Show calculations]
Step 5: [State the answer]
"""
```

---

## Implementation Priority

| Priority | Pattern | Why |
|---|---|---|
| 1 | ReAct | Most versatile, widely used |
| 2 | Tool Use | Foundational for practical agents |
| 3 | Reflection | High impact on output quality |
| 4 | Plan-and-Solve | Essential for complex tasks |
| 5 | Multi-Agent | Advanced, builds on others |
| 6 | Memory/RAG | Critical for production systems |
| 7 | Chain-of-Thought | Specialized for reasoning tasks |

---

## Recommended Stack

- **LLM:** `claude-sonnet-4-6` or `claude-opus-4-6`
- **Framework:** LangGraph (state management) or custom
- **Vector DB:** ChromaDB (local) / Pinecone (production)
- **Schemas:** Pydantic for tool parameter validation

## Evaluation Criteria (per pattern)

- **Correctness:** Does it solve the test case?
- **Latency:** Response time
- **Cost:** Token usage
- **Reliability:** Success rate across 5 runs
- **Observability:** Logging and tracing in place
