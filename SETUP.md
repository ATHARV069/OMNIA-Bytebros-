# OMNIA Setup Instructions

## Project Structure

```
omnia/
├── .env.example           # Environment variables template
├── .gitignore
├── package.json           # Root package.json with Turborepo
├── pnpm-workspace.yaml    # pnpm workspace config
├── turbo.json             # Turborepo pipeline config
├── README.md
├── SETUP.md               # This file
├── apps/
│   ├── web/               # Next.js 14 frontend
│   └── api/               # Fastify backend API
└── packages/
    ├── shared/            # Shared types, Zod schemas, utilities
    ├── database/          # Prisma schema, repositories
    ├── agent-runtime/     # Orchestrator, agents, Gemini client
    ├── tool-registry/     # Typed tools (search, fetch, PDF, etc.)
    └── context/           # Context adapter (MEKO + local fallback)
```

## Prerequisites

- Node.js 20+
- pnpm 9+ (`npm install -g pnpm`)
- PostgreSQL database (Supabase recommended)
- Google Gemini API key
- Google Custom Search API key + Engine ID (for web search)

## Installation

### 1. Install Dependencies

```bash
# From the root directory
pnpm install
```

If you encounter workspace resolution issues, try:

```bash
# Install from each package directory
cd packages/shared && pnpm install
cd ../database && pnpm install
cd ../tool-registry && pnpm install
cd ../context && pnpm install
cd ../agent-runtime && pnpm install
cd ../../apps/api && pnpm install
cd ../web && pnpm install
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```env
# Required
GEMINI_API_KEY=your-gemini-api-key
DATABASE_URL=postgresql://user:pass@host:5432/db
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
WEB_SEARCH_API_KEY=your-google-api-key
WEB_SEARCH_ENGINE_ID=your-search-engine-id

# Optional
MEKO_MCP_URL=https://your-meko-instance.com/mcp
MEKO_MCP_AUTH_TOKEN=your-auth-token
GEMINI_MODEL=gemini-1.5-pro
API_PORT=3001
NEXT_PUBLIC_API_URL=http://localhost:3001
```

### 3. Set Up Database

```bash
# Generate Prisma client
pnpm db:generate

# Push schema to database
pnpm db:push

# (Optional) Seed with demo data
pnpm db:seed

# (Optional) Open Prisma Studio
pnpm db:studio
```

### 4. Start Development Servers

```bash
# Start all services (API + Web)
pnpm dev
```

Or start individually:

```bash
# Terminal 1 - API server
cd apps/api && pnpm dev

# Terminal 2 - Web app
cd apps/web && pnpm dev
```

Access:
- Web app: http://localhost:3000
- API server: http://localhost:3001
- API health: http://localhost:3001/api/health

## Required API Keys

### Google Gemini API
1. Go to https://aistudio.google.com/apikey
2. Create an API key
3. Add to `GEMINI_API_KEY`

### Google Custom Search (Web Search)
1. Go to https://console.cloud.google.com/
2. Enable "Custom Search API"
3. Create credentials (API Key) → add to `WEB_SEARCH_API_KEY`
4. Go to https://programmablesearchengine.google.com/
5. Create a search engine (search the entire web)
6. Get the Search Engine ID → add to `WEB_SEARCH_ENGINE_ID`

### Supabase
1. Create project at https://supabase.com
2. Settings → Database → Connection string → `DATABASE_URL`
3. Settings → API → Project URL → `NEXT_PUBLIC_SUPABASE_URL`
4. Settings → API → anon/public key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. Settings → API → service_role key → `SUPABASE_SERVICE_ROLE_KEY` (server only!)

## Running the Demo Workflow

1. Open http://localhost:3000
2. Click "Open Workspace" or go to http://localhost:3000/dashboard
3. Select "Default Workspace" project
4. Enter an objective (or use the example):
   > "Research five AI presentation tools, compare their publicly available features and pricing, identify the best options for students, and create a professional PDF report with source references."
5. Click "Create Execution"
6. Review the generated plan
7. Click "Approve & Start Execution"
8. Watch the live execution view
9. When complete, view results and download the PDF

## Troubleshooting

### pnpm Workspace Issues
If `pnpm install` fails with 404 errors for `@omnia/*` packages:
1. Ensure you're running from the root directory
2. Check that `pnpm-workspace.yaml` exists
3. Try `pnpm install --shamefully-hoist`
4. Or install packages individually (see step 1)

### Database Connection
- Ensure `DATABASE_URL` uses the correct format: `postgresql://user:pass@host:5432/db?schema=public`
- For Supabase, use the "Session Pooler" connection string for production

### Web Search Not Working
- Verify `WEB_SEARCH_API_KEY` and `WEB_SEARCH_ENGINE_ID` are correct
- Check Google Cloud Console → APIs → Custom Search API is enabled
- Verify the search engine is set to "Search the entire web"

### API Connection Issues
- Ensure `NEXT_PUBLIC_API_URL` matches the API server URL
- Check CORS settings in `apps/api/src/index.ts`

## Development Commands

```bash
# Build all packages
pnpm build

# Type checking
pnpm typecheck

# Linting
pnpm lint

# Run tests
pnpm test

# Database commands
pnpm db:studio      # Open Prisma Studio
pnpm db:migrate     # Run migrations
pnpm db:seed        # Seed database
```

## Architecture Overview

### Core Flow
1. **User** → Creates execution with objective
2. **Orchestrator** → Generates plan via Gemini
3. **User** → Approves plan
4. **Orchestrator** → Creates tasks, manages dependencies
5. **Agents** → Execute tasks:
   - Research Agent → Web search + fetch + extract claims
   - Data Agent → Normalize + compare + structure
   - Creation Agent → Generate PDF report
6. **Verification** → Independent checks on results
7. **User** → Reviews and downloads deliverables

### Key Components

- **Shared Types** (`packages/shared`): All Zod schemas, TypeScript types
- **Database** (`packages/database`): Prisma schema, repositories for all entities
- **Agent Runtime** (`packages/agent-runtime`): Orchestrator, 3 specialist agents, Gemini client
- **Tool Registry** (`packages/tool-registry`): 8 typed tools with SSRF protection
- **Context** (`packages/context`): MEKO adapter + local database fallback
- **API** (`apps/api`): Fastify server with Socket.IO for realtime
- **Web** (`apps/web`): Next.js 14 with Tailwind, Framer Motion, Zustand

## Security Notes

- Never commit `.env` files
- `SUPABASE_SERVICE_ROLE_KEY` only used server-side
- `NEXT_PUBLIC_*` variables exposed to browser
- SSRF protection in `fetch_webpage` tool
- Row Level Security should be enabled on Supabase tables

## Next Steps

Priority 0 (Complete):
- ✅ Project structure and core types
- ✅ Database schema with all entities
- ✅ Orchestrator with task dependency management
- ✅ 3 specialist agents (Research, Data, Creation)
- ✅ 8 typed tools with validation
- ✅ Context adapter with MEKO + fallback
- ✅ Fastify API with all endpoints
- ✅ Next.js web app with dashboard, execution view, settings
- ✅ Real-time Socket.IO integration
- ✅ Verification engine

Priority 1 (To Implement):
- [ ] Real database integration testing
- [ ] Actual Gemini API integration
- [ ] Real web search with Google Custom Search
- [ ] PDF generation with pdf-lib
- [ ] Supabase RLS policies
- [ ] Authentication system
- [ ] Unit and integration tests

Priority 2 (Future):
- [ ] MEKO MCP integration
- [ ] Electron desktop app
- [ ] Advanced scheduling
- [ ] More specialist agents
- [ ] Plugin system