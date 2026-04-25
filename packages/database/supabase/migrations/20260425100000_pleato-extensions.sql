-- ============================================================
-- Pleato (小折) Factory AI Management System
-- Migration: Extend Carbon tables + create Pleato-specific tables
-- ============================================================

-- Enable trigram extension for fuzzy search
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ============================================================
-- 1. EXTEND customer TABLE
-- ============================================================
ALTER TABLE "customer"
  ADD COLUMN IF NOT EXISTS "alias" TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS "phone" TEXT,
  ADD COLUMN IF NOT EXISTS "wechatId" TEXT,
  ADD COLUMN IF NOT EXISTS "addressDefault" TEXT,
  ADD COLUMN IF NOT EXISTS "creditLimit" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "paymentCycleDays" INTEGER DEFAULT 30,
  ADD COLUMN IF NOT EXISTS "totalUnpaid" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "notes" TEXT,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- Trigram index for fuzzy name search
CREATE INDEX IF NOT EXISTS "customer_name_trgm_idx"
  ON "customer" USING GIN ("name" gin_trgm_ops);

-- GIN index for alias array search
CREATE INDEX IF NOT EXISTS "customer_alias_gin_idx"
  ON "customer" USING GIN ("alias");

-- ============================================================
-- 2. EXTEND supplier TABLE
-- ============================================================
ALTER TABLE "supplier"
  ADD COLUMN IF NOT EXISTS "alias" TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS "phone" TEXT,
  ADD COLUMN IF NOT EXISTS "wechatId" TEXT,
  ADD COLUMN IF NOT EXISTS "paymentTerms" TEXT,
  ADD COLUMN IF NOT EXISTS "totalPayable" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "notes" TEXT,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- Trigram index for fuzzy name search
CREATE INDEX IF NOT EXISTS "supplier_name_trgm_idx"
  ON "supplier" USING GIN ("name" gin_trgm_ops);

-- GIN index for alias array search
CREATE INDEX IF NOT EXISTS "supplier_alias_gin_idx"
  ON "supplier" USING GIN ("alias");

-- ============================================================
-- 3. EXTEND item TABLE (products/services)
-- ============================================================
ALTER TABLE "item"
  ADD COLUMN IF NOT EXISTS "specTemplate" JSONB,
  ADD COLUMN IF NOT EXISTS "defaultPrice" NUMERIC(15, 2),
  ADD COLUMN IF NOT EXISTS "category" TEXT,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- ============================================================
-- 4. EXTEND customerItemPriceOverride TABLE (千人千价)
-- ============================================================
ALTER TABLE "customerItemPriceOverride"
  ADD COLUMN IF NOT EXISTS "spec" JSONB,
  ADD COLUMN IF NOT EXISTS "price" NUMERIC(15, 5),
  ADD COLUMN IF NOT EXISTS "lastUsedAt" TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS "useCount" INTEGER DEFAULT 0,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- Expression index for spec-based unique lookup
CREATE UNIQUE INDEX IF NOT EXISTS "customerItemPriceOverride_customer_item_spec_uq"
  ON "customerItemPriceOverride" ("customerId", "itemId", (COALESCE("spec"::TEXT, '')))
  WHERE "customerId" IS NOT NULL AND "spec" IS NOT NULL;

-- ============================================================
-- 5. EXTEND salesOrder TABLE
-- ============================================================
ALTER TABLE "salesOrder"
  ADD COLUMN IF NOT EXISTS "discountAmount" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "taxRate" NUMERIC(5, 4) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "totalAmount" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "paidAmount" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "deliveryAddr" TEXT,
  ADD COLUMN IF NOT EXISTS "deliveryDate" DATE,
  ADD COLUMN IF NOT EXISTS "pleato_paymentTerms" TEXT CHECK ("pleato_paymentTerms" IN ('cash', 'credit', 'partial')),
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- ============================================================
-- 6. EXTEND salesOrderLine TABLE
-- ============================================================
ALTER TABLE "salesOrderLine"
  ADD COLUMN IF NOT EXISTS "spec" JSONB,
  ADD COLUMN IF NOT EXISTS "deliveredQty" NUMERIC(15, 4) DEFAULT 0,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- ============================================================
-- 7. EXTEND purchaseOrder TABLE
-- ============================================================
ALTER TABLE "purchaseOrder"
  ADD COLUMN IF NOT EXISTS "totalAmount" NUMERIC(15, 2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "paidAmount" NUMERIC(15, 2) DEFAULT 0,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- ============================================================
-- 8. EXTEND purchaseOrderLine TABLE
-- ============================================================
ALTER TABLE "purchaseOrderLine"
  ADD COLUMN IF NOT EXISTS "spec" JSONB,
  -- reserved fields
  ADD COLUMN IF NOT EXISTS "extra1" TEXT,
  ADD COLUMN IF NOT EXISTS "extra2" TEXT,
  ADD COLUMN IF NOT EXISTS "extra3" TEXT,
  ADD COLUMN IF NOT EXISTS "extra4" TEXT,
  ADD COLUMN IF NOT EXISTS "extra5" TEXT,
  ADD COLUMN IF NOT EXISTS "extra6" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra7" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra8" NUMERIC,
  ADD COLUMN IF NOT EXISTS "extra9" JSONB,
  ADD COLUMN IF NOT EXISTS "extra10" TIMESTAMPTZ;

-- ============================================================
-- 9. CREATE payments TABLE (收付款流水 - NEW)
-- ============================================================
CREATE TABLE "pleatoPayment" (
  "id" TEXT NOT NULL DEFAULT id('ppay'),
  "paymentNo" TEXT NOT NULL,
  "direction" TEXT NOT NULL CHECK ("direction" IN ('in', 'out')),
  "orderId" TEXT,
  "orderType" TEXT CHECK ("orderType" IN ('sales', 'purchase')),
  "partyId" TEXT NOT NULL,
  "partyType" TEXT NOT NULL CHECK ("partyType" IN ('customer', 'supplier')),
  "amount" NUMERIC(15, 2) NOT NULL,
  "paymentDate" DATE NOT NULL DEFAULT CURRENT_DATE,
  "account" TEXT,
  "notes" TEXT,
  "companyId" TEXT NOT NULL,
  "createdBy" TEXT NOT NULL,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- reserved fields
  "extra1" TEXT,
  "extra2" TEXT,
  "extra3" TEXT,
  "extra4" TEXT,
  "extra5" TEXT,
  "extra6" NUMERIC,
  "extra7" NUMERIC,
  "extra8" NUMERIC,
  "extra9" JSONB,
  "extra10" TIMESTAMPTZ,

  CONSTRAINT "pleatoPayment_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "pleatoPayment_paymentNo_uq" UNIQUE ("paymentNo", "companyId"),
  CONSTRAINT "pleatoPayment_companyId_fkey"
    FOREIGN KEY ("companyId") REFERENCES "company"("id")
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "pleatoPayment_createdBy_fkey"
    FOREIGN KEY ("createdBy") REFERENCES "user"("id")
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX "pleatoPayment_partyId_idx" ON "pleatoPayment" ("partyId", "partyType");
CREATE INDEX "pleatoPayment_orderId_idx" ON "pleatoPayment" ("orderId", "orderType");
CREATE INDEX "pleatoPayment_paymentDate_idx" ON "pleatoPayment" ("paymentDate");
CREATE INDEX "pleatoPayment_companyId_idx" ON "pleatoPayment" ("companyId");
CREATE INDEX "pleatoPayment_direction_idx" ON "pleatoPayment" ("direction");

ALTER TABLE "pleatoPayment" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "SELECT" ON "public"."pleatoPayment"
FOR SELECT USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_role())::text[]
  )
);

CREATE POLICY "INSERT" ON "public"."pleatoPayment"
FOR INSERT WITH CHECK (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('accounting_create'))::text[]
  )
);

CREATE POLICY "UPDATE" ON "public"."pleatoPayment"
FOR UPDATE USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('accounting_update'))::text[]
  )
);

CREATE POLICY "DELETE" ON "public"."pleatoPayment"
FOR DELETE USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('accounting_delete'))::text[]
  )
);

-- ============================================================
-- 10. CREATE pleatoInventory TABLE (库存 - NEW, itemInventory was dropped in Carbon)
-- ============================================================
CREATE TABLE "pleatoInventory" (
  "id" TEXT NOT NULL DEFAULT id('pinv'),
  "itemId" TEXT NOT NULL,
  "spec" JSONB,
  "quantity" NUMERIC(15, 4) NOT NULL DEFAULT 0,
  "location" TEXT,
  "ownerCustomerId" TEXT,
  "materialStatus" TEXT CHECK ("materialStatus" IN ('raw', 'processing', 'finished', 'shipped')),
  "enteredAt" TIMESTAMPTZ DEFAULT NOW(),
  "notes" TEXT,
  "companyId" TEXT NOT NULL,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMPTZ,
  -- reserved fields
  "extra1" TEXT,
  "extra2" TEXT,
  "extra3" TEXT,
  "extra4" TEXT,
  "extra5" TEXT,
  "extra6" NUMERIC,
  "extra7" NUMERIC,
  "extra8" NUMERIC,
  "extra9" JSONB,
  "extra10" TIMESTAMPTZ,

  CONSTRAINT "pleatoInventory_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "pleatoInventory_itemId_fkey"
    FOREIGN KEY ("itemId") REFERENCES "item"("id")
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "pleatoInventory_ownerCustomerId_fkey"
    FOREIGN KEY ("ownerCustomerId") REFERENCES "customer"("id")
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "pleatoInventory_companyId_fkey"
    FOREIGN KEY ("companyId") REFERENCES "company"("id")
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX "pleatoInventory_itemId_idx" ON "pleatoInventory" ("itemId");
CREATE INDEX "pleatoInventory_ownerCustomerId_idx"
  ON "pleatoInventory" ("ownerCustomerId")
  WHERE "ownerCustomerId" IS NOT NULL;
CREATE INDEX "pleatoInventory_materialStatus_idx" ON "pleatoInventory" ("materialStatus");
CREATE INDEX "pleatoInventory_companyId_idx" ON "pleatoInventory" ("companyId");

ALTER TABLE "pleatoInventory" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "SELECT" ON "public"."pleatoInventory"
FOR SELECT USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_role())::text[]
  )
);

CREATE POLICY "INSERT" ON "public"."pleatoInventory"
FOR INSERT WITH CHECK (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('inventory_create'))::text[]
  )
);

CREATE POLICY "UPDATE" ON "public"."pleatoInventory"
FOR UPDATE USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('inventory_update'))::text[]
  )
);

CREATE POLICY "DELETE" ON "public"."pleatoInventory"
FOR DELETE USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('inventory_delete'))::text[]
  )
);

-- ============================================================
-- 11. CREATE pleatoInventoryLog TABLE (库存流水 - NEW)
-- ============================================================
CREATE TABLE "pleatoInventoryLog" (
  "id" TEXT NOT NULL DEFAULT id('pinvl'),
  "inventoryId" TEXT,
  "itemId" TEXT NOT NULL,
  "changeType" TEXT NOT NULL CHECK ("changeType" IN ('in', 'out', 'transfer', 'adjust')),
  "quantityChange" NUMERIC(15, 4) NOT NULL,
  "referenceType" TEXT,
  "referenceId" TEXT,
  "operator" TEXT,
  "notes" TEXT,
  "companyId" TEXT NOT NULL,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- reserved fields
  "extra1" TEXT,
  "extra2" TEXT,
  "extra3" TEXT,
  "extra4" TEXT,
  "extra5" TEXT,
  "extra6" NUMERIC,
  "extra7" NUMERIC,
  "extra8" NUMERIC,
  "extra9" JSONB,
  "extra10" TIMESTAMPTZ,

  CONSTRAINT "pleatoInventoryLog_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "pleatoInventoryLog_itemId_fkey"
    FOREIGN KEY ("itemId") REFERENCES "item"("id")
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "pleatoInventoryLog_companyId_fkey"
    FOREIGN KEY ("companyId") REFERENCES "company"("id")
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX "pleatoInventoryLog_itemId_idx" ON "pleatoInventoryLog" ("itemId");
CREATE INDEX "pleatoInventoryLog_changeType_idx" ON "pleatoInventoryLog" ("changeType");
CREATE INDEX "pleatoInventoryLog_referenceId_idx" ON "pleatoInventoryLog" ("referenceType", "referenceId");
CREATE INDEX "pleatoInventoryLog_createdAt_idx" ON "pleatoInventoryLog" ("createdAt");
CREATE INDEX "pleatoInventoryLog_companyId_idx" ON "pleatoInventoryLog" ("companyId");

ALTER TABLE "pleatoInventoryLog" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "SELECT" ON "public"."pleatoInventoryLog"
FOR SELECT USING (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_role())::text[]
  )
);

CREATE POLICY "INSERT" ON "public"."pleatoInventoryLog"
FOR INSERT WITH CHECK (
  "companyId" = ANY (
    (SELECT get_companies_with_employee_permission('inventory_create'))::text[]
  )
);
