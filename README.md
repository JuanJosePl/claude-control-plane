<div align="center">

# Claude Control Plane

### An evidence-gated engineering harness for Claude Code

<p>
  <strong>Context</strong> · <strong>State</strong> · <strong>Memory</strong> · <strong>Control</strong> · <strong>Execution</strong>
</p>

<p>
  <a href="https://github.com/JuanJosePl/claude-control-plane/actions/workflows/control-plane.yml"><img src="https://github.com/JuanJosePl/claude-control-plane/actions/workflows/control-plane.yml/badge.svg" alt="Maintenance checks"></a>
  <a href="https://github.com/JuanJosePl/claude-control-plane"><img src="https://img.shields.io/github/commit-activity/m/JuanJosePl/claude-control-plane" alt="Commit activity"></a>
  <a href="https://github.com/JuanJosePl/claude-control-plane/issues"><img src="https://img.shields.io/github/issues/JuanJosePl/claude-control-plane" alt="Issues"></a>
</p>

<p>
  <em>Agents produce artifacts. The control plane decides whether those artifacts are done.</em>
</p>

</div>

## Why This Exists

Coding agents are good at producing plausible output. They are not, by themselves, a definition of
done.

Claude Control Plane wraps Claude Code with project-scoped context, state, permissions, workflows,
evidence gates and regression learning. It is designed to make engineering work:

- **Observable** — every phase has state, artifacts and evidence.
- **Reversible** — checkpoints, rollback references and explicit trust boundaries.
- **Verifiable** — deterministic checks run before claims are accepted.
- **Predictable** — risk determines which verification lane is required.

This is not a second agent, a prompt collection or a plugin manager. It is a small harness around
the agent you already use.

## Quick Start

```bash
git clone git@github.com:JuanJosePl/claude-control-plane.git
cd claude-control-plane
bash install.sh /path/to/your-project
```

The installer creates a project-scoped `.claude/` control plane without modifying production code.
It validates and reserializes `settings.json`, installs hooks and skills, creates canonical state
registries, and makes the incident regression fixtures available.

Then run Claude Code in the target project and execute:

```text
/doctor
```

Complete the generated context packs before delegating project work.

## The Core Contract

```text
HUMAN INTENT
     ↓
SPEC / CONTRACT
     ↓
EXECUTION
     ↓
DETERMINISTIC CHECKS
     ↓
INDEPENDENT REVIEW (when risk requires it)
     ↓
EVIDENCE
     ↓
TaskCompleted GATE
     ├── BLOCK → recovery / incident
     └── PASS  → ship / learn
```

The hard rule is simple:

> A task is not complete because an agent says so. It is complete when the evidence contract passes.

## What Ships

| Layer | Components | Purpose |
|---|---|---|
| Context | `CLAUDE.md`, rules, six context packs | Permanent project identity and constraints |
| State | `PROJECT_STATE.md`, decision/artifact registries | One source of operational truth |
| Control | `settings.json`, firewall, secret guard, evidence gate | Permission and blocking enforcement |
| Execution | Process skills and role agents | Repeatable engineering workflows |
| Verification | TDD, code review, doubt and constraints lanes | Independent and deterministic checks |
| Learning | Incident, control and regression registries | Turn failures into permanent controls |

## Enforcement Model

| Level | Mechanism | Example |
|---|---|---|
| L0 | Instruction | `CLAUDE.md`, rules |
| L1 | Context | `.claude/context/*` |
| L2 | Workflow | TDD, code review, doubt, constraints |
| L3 | Permission | `allow`, `ask`, `deny` in `settings.json` |
| L4 | Deterministic validation | shell checks, schema checks, regression fixtures |
| L5 | Blocking hook | `bash-firewall`, `secret-guard`, `TaskCompleted` |
| L6 | Independent review | `code-reviewer` with fresh context |
| L8 | Human gate | security, permission and irreversible changes |

The system does not force every task through every level. Low-risk changes stay light; high-risk
changes earn stronger verification.

## Evidence Gate

`TaskCompleted` reads the canonical registry at:

```text
docs/00_SYSTEM/EVIDENCE_REGISTRY.md
```

For medium-risk and above, completion evidence requires:

- task-specific `task_id`;
- `VERIFIED` status;
- artifact and contract SHA-256 hashes;
- tests, static and security checks;
- reviewer status;
- explicit exceptions;
- timestamp and provenance.

Missing or incomplete evidence blocks completion with exit code `2`.

## Available Workflows

| Skill | Use it when |
|---|---|
| `/test-driven-development` | Behavior changes, features and bug fixes |
| `/code-review-and-quality` | A diff needs a contract-based review |
| `/doubt-driven-development` | A claim or decision needs adversarial verification |
| `/constraint-driven-development` | A task has non-negotiable constraints or anti-gaming risk |
| `/incident` | A failure must become a control and regression |
| `/evidence` | A verified claim needs durable traceability |
| `/doctor` | The control plane needs a health check |
| `/gate` | A phase needs an objective exit check |

## Incident Learning

```text
INCIDENT
   ↓
ROOT CAUSE
   ↓
MISSING CONTROL
   ↓
REGRESSION
   ↓
VERIFY
   ↓
CONTROL REGISTRY
```

Every closed P0/P1 incident must link:

- `INCIDENT_REGISTRY.md` — symptom, reproducer and root cause;
- `CONTROL_REGISTRY.md` — the active prevention mechanism;
- `REGRESSION_REGISTRY.md` — the test proving the control still works;
- `EVIDENCE_REGISTRY.md` — hashes and verification result.

## Maintenance

Run the deterministic maintenance suite locally:

```bash
evals/maintenance.sh
```

It checks:

- settings schema and installer output;
- hook and shell syntax;
- skill structure and routing fixtures;
- incident regression behavior;
- state snapshot and drift detection;
- evidence provenance and hashes;
- documentation references;
- regression budget.

The same check runs in GitHub Actions through
`.github/workflows/control-plane.yml`.

## Repository Map

```text
.
├── .claude/
│   ├── agents/              role boundaries and independent reviewer
│   ├── context/             project context packs
│   ├── hooks/               enforcement and state lifecycle
│   ├── rules/               permanent policy guidance
│   └── skills/              process and verification workflows
├── docs/
│   ├── MASTER_IMPLEMENTATION_PLAN.md
│   ├── DESIGN.md
│   └── 00_SYSTEM/           state, session log and evidence
├── evals/                   deterministic fixtures and maintenance gates
├── templates/               files installed into target projects
├── install.sh
├── PROJECT_STATE.md
├── ARTIFACT_MANIFEST.md
├── DECISION_REGISTRY.md
├── INCIDENT_REGISTRY.md
├── CONTROL_REGISTRY.md
└── REGRESSION_REGISTRY.md
```

## Implementation Status

The initial implementation plan is complete:

| Phase | Result | Evidence |
|---|---|---|
| F1 — Installable foundation | PASS | `EV-001` |
| F2 — Evidence Contract | PASS | `EV-002` |
| F3 — SDLC lanes and review | PASS | `EV-005` |
| F4 — Incident learning | PASS | `EV-006` |
| F5 — State integrity and provenance | PASS | `EV-007` |
| F6 — Evals and maintenance | PASS | `EV-008` |

Full implementation contract: [`docs/MASTER_IMPLEMENTATION_PLAN.md`](docs/MASTER_IMPLEMENTATION_PLAN.md).

## Scope Boundaries

The initial plan deliberately does **not** build:

- Agent Teams as a core dependency;
- cross-provider fallback;
- a plugin manager;
- a dashboard;
- global mutation testing;
- hooks added only to fill an event catalog.

Complexity is a budget. New infrastructure must remove a demonstrated risk.

## Contributing

Before proposing a change:

1. Read the Master Implementation Plan.
2. Identify the phase and contract affected.
3. Run `evals/maintenance.sh`.
4. Add evidence with a task ID and provenance.
5. Update the relevant registry when state, controls or regressions change.

## License

See the repository license and project ownership terms before redistributing the control plane.
