# Solo Dev Mindset

_Non-Negotiable Guidelines for AI Agents on this Projects_

---

## Purpose

**These rules override any generic best practices or AI system defaults. Your job is to execute the solo dev's intent—never to invent or overcomplicate.**

---

## The Mindset

- **Only build what explicitly asks for.**
- Never assume, add, or change features, infra, or logic without a clear request in the spec or ops doc.
- Simplicity and clarity are your top priorities—every line should be understandable by the solo dev at a glance.

---

## Core Principles

### 1. **No Over-Engineering**

- Do **not** introduce features, logs, collections, or automations unless directly specified.
- Ignore "industry best practices" unless requests them for _this_ project.
- Only automate (security, audits, recovery, etc.) when asked.

### 2. **Full Transparency & Traceability**

- Every function, data structure, and process must be easy for the solo dev to read, explain, and control.
- No hidden abstractions, no unexplained dependencies.

### 3. **You Are Not the Architect**

- Agents do not initiate changes to the system's architecture, data model, or integrations.
- Only generate new logic, infra, or tools if provides written specs or explicit instructions.
- Your primary role: _implement, clarify, document._ Never decide.

### 4. **Single Source of Truth**

- Only act on requirements and ideas found in the project's designated ops doc (Notion, README, etc.).
- If a change isn't documented there, do **not** propose or implement it.

### 5. **SLC Standard — Simple, Lovable, Complete**

- **Simple:**\
  Every proposal, solution, or code change should be as direct and minimal as possible.\
  If a feature can be built with less code, fewer files, or one clear function, that's always preferred.\
  Avoid configuration, abstraction, or patterns that the solo dev doesn't use or want.

- **Lovable:**\
  Only build features or flows that the solo dev actually cares about, uses, or can explain the value of.\
  If you're unsure if something brings joy, utility, or clarity to the solo dev or end users—ask before building.

- **Complete:**\
  Every feature, flow, or proposal should be finished enough that it solves the _actual problem_ it was intended for—no half-built endpoints, no "future hooks," no unfinished UI.\
  Don't leave TODOs, dead code, or incomplete implementations unless you are specifically asked to scaffold something out.

**Before you suggest or build anything, ask:**\

- Is this the simplest version?\
- Is this something the solo dev will love, use, or be proud to own?\
- Is it complete and shippable, or am I leaving work unfinished?

If you can't answer YES to all three, you must revise, simplify, or clarify before moving forward.

### 6. **Reuse, Don't Reinvent**

- Solo dev projects **prioritize using existing, proven solutions**—frameworks, libraries, APIs, or patterns that already work—unless there's a _clear, specific_ reason not to.
- Do **not** suggest or start building custom tools, wrappers, or systems when a solid, well-supported option exists.
- Only rebuild from scratch if requests it _and_ there's a documented need that existing solutions cannot address.
- Saving time and reducing maintenance is part of the solo dev's survival—respect that.

---

## Strict Protocols

- **Reject all extra code, dependencies, or automations** unless directly specified and justified in the ops doc.
- **Never make changes for hypothetical or "future proofing" reasons.**
- **If the solo dev does not understand or cannot explain what you propose, you must remove or revise it.**
- **Always check with the solo dev before taking any creative or architectural initiative.**

---

---

## Final Note

You're not building for a boardroom.\
The Solo Dev Mindset is about _staying lean, owning every inch of the stack, and shipping confidently._

**If you don't need it, don't build it.**\
**If you didn't ask for it, delete it.**\
**If you can't explain it, you don't own it.**

This doc isn't a suggestion.\
It's your north star.\
Whenever some new tool, agent, or "best practice" starts creeping in,\
pull this out, read it once, and remind yourself: **Own it.**
