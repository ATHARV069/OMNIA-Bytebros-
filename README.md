# OMNIA

**One Goal. Multiple Agents. Real Execution. Verified Results.**

OMNIA is an autonomous AI execution workspace that transforms a natural-language objective into verified deliverables through coordinated specialist agents — Research, Data, and Creation — orchestrated by a central planner.

> Built for hackCBS 9.0 | Japandi-inspired design | Vite · React · TypeScript · Fastify · Prisma/Supabase · Google Gemini

---

## ⚡ Quick Start

### Prerequisites
- Node.js ≥ 20
- pnpm 9

### 1. Install dependencies
```bash
pnpm install
```

### 2. Configure environment
Create `.env` files from the example. **Never commit real secrets.**

**Root / API** (`packages/api/.env`):
```
NODE_ENV=development
API_PORT=3001
NEXT_PUBLIC_API_URL=http://localhost:3001

# Google Gemini (Required for real AI execution)
GEMINI_API_KEY=your-gemini-api-key
GEMINI_MODEL=gemini-1.5-pro

# Database (Supabase PostgreSQL)
DATABASE_URL=postgresql://user:pass@host:5432/db
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Web Search (Google Custom Search)
WEB_SEARCH_API_KEY=your-google-api-key
WEB_SEARCH_ENGINE_ID=your-search-engine-id

# Meko MCP (Optional shared context)
MEKO_MCP_URL=https://mcp.mekodata.ai/mcp
MEKO_MCP_AUTH_TOKEN=your-auth-token
```

> `GEMINI_API_KEY` and `DATABASE_URL` are required for real AI execution and persistence. Without them, the frontend runs in a clearly-labeled **Demo Mode** simulation.

### 3. Start the database
```bash
cd packages/database
pnpm db:generate
pnpm db:push
```

### 4. Start the backend (port 3001)
```bash
cd packages/api
pnpm dev
```

### 5. Start the frontend (port 3000)
```bash
cd packages/web
pnpm dev
```
Open **http://localhost:3000**.

---

## 📜 Available Scripts

| Command | Purpose |
|---------|---------|
| `pnpm dev` | Start all services (turbo) |
| `pnpm build` | Production build all packages |
| `pnpm typecheck` | TypeScript typecheck all packages |
| `pnpm lint` | Lint all packages |
| `pnpm test` | Run tests |
| `pnpm db:push` | Push Prisma schema to database |

Per-package scripts also exist in `packages/web`, `packages/api`, `packages/database`, etc.

---

## 🏗️ Architecture

```
packages/
├── web            # Vite + React + TypeScript frontend (port 3000)
├── api            # Fastify backend + Socket.IO (port 3001)
├── agent-runtime  # Orchestrator + Gemini + Research/Data/Creation agents
├── context        # Meko MCP + local-database context adapters
├── database       # Prisma client + repositories (Supabase PostgreSQL)
├── shared         # Zod schemas, types, event types
└── tool-registry  # Web search, fetch webpage, compare entities, PDF report
```

### Data flow
1. User submits an objective on the dashboard.
2. The Fastify API creates an execution and the orchestrator generates a plan via Gemini.
3. Specialist agents (Research → Data → Creation) execute tasks with real tools (web search, fetch, compare, PDF).
4. Execution progress streams via Socket.IO.
5. An independent verification engine checks outputs before delivery.
6. The user views/downloads the verified deliverable.

---

## 🎨 Design

OMNIA uses a **Japandi** design system — Japanese minimalism + Scandinavian warmth:

- Warm porcelain / paper backgrounds, charcoal ink text
- Sage and deep-forest accents, muted terracotta emphasis
- Inter (interface) + Newsreader (editorial) + JetBrains Mono (technical) typography
- 4px spacing scale, thin borders, subtle shadows
- Light / dark / system theme toggle (persisted to `localStorage`)
- Framer Motion for restrained, state-driven animations

---

## 🔐 Security

- API keys and credentials are **server-side only** — never exposed to the browser.
- Webpage fetching includes SSRF protection (blocks localhost/private IP ranges).
- Retrieved content is treated as untrusted; no arbitrary model-generated commands are executed.
- Row-level security and authorization are enforced where user-specific data exists.
- `.env` files are gitignored. Never commit them.

---

## 🧪 Testing & Verification

### Frontend
```bash
cd packages/web
pnpm typecheck   # tsc -b
pnpm build       # vite build
pnpm dev         # http://localhost:3000
```

### Backend
```bash
cd packages/api
pnpm typecheck   # tsc --noEmit
pnpm dev         # tsx watch src/index.ts
```

### Demo Mode
When `GEMINI_API_KEY` / `DATABASE_URL` are not configured, the frontend shows a clearly-labeled **Demo Mode** banner and simulates the execution workflow. This is **not** real agent execution — configure the env vars and start the API for real execution.

---

## 🚦 Current Status

| Item | Status |
|------|--------|
| Frontend (Vite) | ✅ Starts on :3000 |
| Typecheck (`tsc -b`) | ✅ Passes |
| Production build (`vite build`) | ✅ Passes |
| Gemini integration | Implemented; requires `GEMINI_API_KEY` |
| Database / persistence | Schema ready; requires `DATABASE_URL` |
| Meko MCP context | Placeholder; requires `MEKO_MCP_URL` + token |
| Real end-to-end AI workflow | Blocked until API keys + DB configured |

---

## 📄 License

MIT

---

<sub>Built for hackCBS 9.0 · OMNIA · One Goal. Multiple Agents. Real Execution. Verified Results.</sub>
