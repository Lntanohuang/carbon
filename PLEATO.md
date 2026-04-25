# 小折 Pleato — Factory AI Management System

工厂 AI 管理系统，面向加工服务行业。

## Architecture

```
Hermes Agent (AI Layer)     →  Natural language interface
        ↕ MCP Protocol
Carbon MES (Business Layer) →  ERP + MES + QMS
        ↕ SQL
Supabase (Data Layer)       →  PostgreSQL + Realtime
```

## Quick Start

```bash
# 1. Start Supabase (in carbon directory)
cd carbon/packages/database && supabase start

# 2. Start Redis
cd carbon && docker compose up -d redis

# 3. Start Inngest dev server
npx inngest-cli dev --port 8288

# 4. Start Carbon ERP
cd carbon && npm run dev:erp

# 5. Start Hermes Agent (with Pleato config)
conda activate pleato
cd hermes-agent && hermes --config ../pleato-config/cli-config.yaml
```

## Components

- `carbon/` — Fork of [crbnos/carbon](https://github.com/crbnos/carbon) with Pleato extensions
- `hermes-agent/` — [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) AI layer
- `pleato-config/` — Hermes Agent config + factory-specific skills
