---
id: wp-06-web-frontend
title: "Work Package 06: Responsive Nuxt 3 / Vue 3 / shadcn-vue UI & Management Dashboard"
status: pending
phase: design
slug: property-management
target_repo: visulate
branch: feat/wp-06-web-frontend
design_doc: docs/projects/property-management/02-designs/02-application-services-tdd.md
dependencies:
  - wp-03-backend-domain-services
  - wp-04-accounting-ledger-engine
scope:
  - frontend
  - ui
  - vue
  - nuxt
  - tailwind
  - shadcn-vue
---

# Work Package 06: Responsive Nuxt 3 / Vue 3 / shadcn-vue UI & Management Dashboard

## 1. Objective & Deliverables Overview

Build the modern, responsive web application using **Nuxt 3** (Vue 3 with `<script setup lang="ts">`), **Tailwind CSS**, and **shadcn-vue** (Radix Vue primitives). This modern frontend completely replaces all 179 legacy Smarty templates (`code/php/templates/`) and Oracle database-driven dynamic menu tables (`RNT_MENUS*`) with a typed, reactive, modular component architecture, interactive financial dashboards, and embedded AI interaction cards.

### Key Target Files to Create in `packages/web/`:
1. `nuxt.config.ts`: Nuxt 3 configuration enabling `@nuxtjs/tailwindcss`, `@pinia/nuxt`, shadcn-vue component alias resolution, and runtime environment configuration.
2. `layouts/default.vue`: Core dashboard shell featuring sidebar navigation, business-unit switcher, user profile dropdown, and global quick-action copilot bar.
3. `pages/properties/index.vue`: Property list grid/table view with occupancy status badges, search/filters, PostGIS map preview toggle, and unit count badges.
4. `pages/properties/[id].vue`: Property detail view featuring unit list matrix, active tenancy indicators, photo gallery, and financial summary cards.
5. `pages/billing/index.vue`: Billing & Rent Roll hub featuring monthly rent roll batch generation, AR aging bucket cards, and manual charge modal.
6. `pages/accounting/trial-balance.vue`: Interactive General Ledger trial balance with debit/credit balance verification, date period selector, and drill-down to journal transactions.
7. `components/ai/TransactionCopilotModal.vue`: Natural language transaction copilot modal powered by shadcn-vue dialogs, transforming conversational prompts (e.g., *"Daryl Terrace paid their rent on the 23rd"*) into structured payment confirmations.
8. `components/ai/BillIntakeDropzone.vue`: Drag-and-drop OCR bill intake component with multi-file dropzone, vision OCR progress feedback, and structured invoice field editing before posting.
9. `stores/copilot.ts` & `stores/properties.ts`: Pinia stores for state management and caching.
10. `server/api/[...].ts`: Nitro server engine route proxy for authenticated communication with backend domain services.
11. `tests/components/TransactionCopilotModal.spec.ts` & `tests/pages/properties.spec.ts`: Vitest test suites with `@vue/test-utils`.

---

## 2. Legacy Smarty Template Replacement & Modern Nuxt 3 Architecture

### 2.1 Legacy Modernization Context
- **Legacy Footprint**: 179 Smarty `.tpl` files tightly coupled to PHP sessions, procedural SQL queries, and Oracle `RNT_MENUS` table entries.
- **Modern Nuxt 3 Foundation**:
  - **Vue 3 `<script setup lang="ts">`**: Modern Composition API with compile-time reactivity (`ref`, `computed`, `reactive`).
  - **Pinia Stores**: Type-safe centralized state management for tenant selection, business unit context, and cached entity lists.
  - **Nitro Server Engine**: Full-stack server routes (`server/api/`) providing server-side session validation, API gateway forwarding, and SSR hydration.
  - **Tailwind CSS & shadcn-vue**: Consistent accessible design system based on Radix Vue primitives (`Dialog`, `DropdownMenu`, `Tabs`, `Table`, `Badge`, `Card`, `Tooltip`).

---

## 3. Detailed Vue SFC Component Specifications

### 3.1 Property List & Detail Views

#### `pages/properties/index.vue` (Property List)
```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAsyncData } from '#imports'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { IconBuilding, IconSearch, IconMapPin } from 'lucide-vue-next'

interface PropertySummary {
  propertyId: number
  propertyName: string
  address: string
  unitCount: number
  occupiedUnits: number
  monthlyGrossRent: number
  occupancyRate: number
}

const searchQuery = ref('')
const { data: properties, pending, refresh } = await useFetch<PropertySummary[]>('/api/properties')

const filteredProperties = computed(() => {
  if (!properties.value) return []
  const q = searchQuery.value.toLowerCase().trim()
  if (!q) return properties.value
  return properties.value.filter(p => 
    p.propertyName.toLowerCase().includes(q) || 
    p.address.toLowerCase().includes(q)
  )
})
</script>

<template>
  <div class="space-y-6 p-6">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">Properties</h1>
        <p class="text-muted-foreground">Manage real estate assets, rentable units, and occupancy.</p>
      </div>
      <Button to="/properties/new">Add Property</Button>
    </div>

    <div class="flex items-center space-x-2">
      <div class="relative flex-1 max-w-sm">
        <IconSearch class="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
        <Input v-model="searchQuery" placeholder="Filter properties by name or address..." class="pl-9" />
      </div>
    </div>

    <div v-if="pending" class="text-center py-12 text-muted-foreground">Loading properties...</div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <Card v-for="prop in filteredProperties" :key="prop.propertyId" class="hover:shadow-md transition-shadow">
        <CardHeader class="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle class="text-base font-semibold truncate">{{ prop.propertyName }}</CardTitle>
          <Badge :variant="prop.occupancyRate >= 90 ? 'default' : 'secondary'">
            {{ prop.occupancyRate }}% Occupied
          </Badge>
        </CardHeader>
        <CardContent>
          <div class="flex items-center text-sm text-muted-foreground mb-4">
            <IconMapPin class="mr-1 h-3.5 w-3.5" />
            <span class="truncate">{{ prop.address }}</span>
          </div>
          <div class="grid grid-cols-2 gap-2 text-sm">
            <div>
              <span class="text-muted-foreground">Units:</span>
              <span class="font-medium ml-1">{{ prop.occupiedUnits }} / {{ prop.unitCount }}</span>
            </div>
            <div class="text-right">
              <span class="text-muted-foreground">Gross Rent:</span>
              <span class="font-medium ml-1">${{ prop.monthlyGrossRent.toLocaleString() }}</span>
            </div>
          </div>
          <NuxtLink :to="`/properties/${prop.propertyId}`" class="mt-4 block">
            <Button variant="outline" class="w-full">View Units & Leases</Button>
          </NuxtLink>
        </CardContent>
      </Card>
    </div>
  </div>
</template>
```

#### `pages/properties/[id].vue` (Property Detail & Unit Matrix)
- Fetches detailed property record, unit list, and active leases using `useFetch('/api/properties/' + route.params.id)`.
- Renders tabbed navigation: **Units & Rent Roll**, **Financial P&L**, **Maintenance**, and **Location / PostGIS Map**.
- Renders unit status chips (`Occupied`, `Vacant Ready`, `Notice Given`, `Maintenance Hold`).

---

### 3.2 Billing / Rent Roll (`pages/billing/index.vue`)
- **Monthly Rent Roll Batch Generator**: Interactive button triggering `/api/billing/generate-rent-roll` with month/year picker and preview modal.
- **AR Aging Summary Cards**: Four metric cards displaying Current, 1–30 Days, 31–60 Days, and 90+ Days delinquent balances.
- **Receivables Table**: Reactive shadcn-vue `Table` supporting status filtering (`OPEN`, `PARTIAL`, `PAID`), tenant search, and 1-click payment allocation drawer.

---

### 3.3 General Ledger Trial Balance (`pages/accounting/trial-balance.vue`)
```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

interface TrialBalanceRow {
  accountCode: string
  accountName: string
  accountType: 'ASSET' | 'LIABILITY' | 'EQUITY' | 'REVENUE' | 'EXPENSE'
  debit: number
  credit: number
}

const selectedPeriod = ref('2026-11')
const { data, pending, refresh } = await useFetch<{
  accounts: TrialBalanceRow[]
  totalDebit: number
  totalCredit: number
  isBalanced: boolean
}>(() => `/api/ledger/trial-balance?period=${selectedPeriod.value}`)
</script>

<template>
  <div class="space-y-6 p-6">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">General Ledger Trial Balance</h1>
        <p class="text-muted-foreground">Verify mathematical debit/credit balance parity across all accounts.</p>
      </div>
      <div class="flex items-center space-x-3">
        <input type="month" v-model="selectedPeriod" class="border rounded px-3 py-1.5 text-sm" @change="refresh()" />
        <Button variant="outline" @click="refresh()">Recalculate</Button>
      </div>
    </div>

    <!-- Parity Indicator Banner -->
    <div v-if="data" :class="[
      'p-4 rounded-lg flex items-center justify-between border',
      data.isBalanced ? 'bg-emerald-50 border-emerald-200 text-emerald-900' : 'bg-red-50 border-red-200 text-red-900'
    ]">
      <div class="flex items-center space-x-2">
        <span class="font-semibold text-lg">{{ data.isBalanced ? '✓ Books in Balance' : '⚠ Discrepancy Detected' }}</span>
        <span class="text-sm">Total Debits: ${{ data.totalDebit.toLocaleString(undefined, { minimumFractionDigits: 2 }) }} | Total Credits: ${{ data.totalCredit.toLocaleString(undefined, { minimumFractionDigits: 2 }) }}</span>
      </div>
      <div class="text-sm font-mono">
        Variance: ${{ Math.abs(data.totalDebit - data.totalCredit).toFixed(2) }}
      </div>
    </div>

    <!-- Trial Balance Table -->
    <Card>
      <CardContent class="p-0">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Account Code</TableHead>
              <TableHead>Account Name</TableHead>
              <TableHead>Type</TableHead>
              <TableHead class="text-right">Debit ($)</TableHead>
              <TableHead class="text-right">Credit ($)</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="acc in data?.accounts" :key="acc.accountCode">
              <TableCell class="font-mono text-sm">{{ acc.accountCode }}</TableCell>
              <TableCell class="font-medium">{{ acc.accountName }}</TableCell>
              <TableCell><span class="text-xs px-2 py-0.5 rounded bg-slate-100 font-mono">{{ acc.accountType }}</span></TableCell>
              <TableCell class="text-right font-mono">{{ acc.debit ? acc.debit.toFixed(2) : '-' }}</TableCell>
              <TableCell class="text-right font-mono">{{ acc.credit ? acc.credit.toFixed(2) : '-' }}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  </div>
</template>
```

---

### 3.4 AI Transaction Copilot (`components/ai/TransactionCopilotModal.vue`)

Natural language transaction assistant:
- Translates input such as *"Daryl Terrace paid their rent on the 23rd"* into structured payment verification.
- Displays confidence score, extracted tenant name, resolved property/unit, parsed date, and proposed debit/credit ledger accounts before posting.

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { IconSparkles, IconCheck, IconAlertCircle } from 'lucide-vue-next'

const isOpen = ref(false)
const promptText = ref('')
const isParsing = ref(false)
const isPosting = ref(false)
const parsedResult = ref<{
  propertyId: number
  propertyName: string
  unitName: string
  tenantId: number
  tenantName: string
  paymentDate: string
  amount: number
  paymentTypeId: number
  confidence: number
} | null>(null)

async function analyzePrompt() {
  if (!promptText.value.trim()) return
  isParsing.value = true
  try {
    const res = await $fetch('/api/ai/transaction-copilot/parse', {
      method: 'POST',
      body: { prompt: promptText.value }
    })
    parsedResult.value = res as any
  } catch (err) {
    console.error('Failed to parse prompt', err)
  } finally {
    isParsing.value = false
  }
}

async function confirmAndPost() {
  if (!parsedResult.value) return
  isPosting.value = true
  try {
    await $fetch('/api/payments/allocate', {
      method: 'POST',
      body: {
        tenantId: parsedResult.value.tenantId,
        paymentDate: parsedResult.value.paymentDate,
        amount: parsedResult.value.amount,
        paymentTypeId: parsedResult.value.paymentTypeId,
        memo: `Logged via Copilot: "${promptText.value}"`
      }
    })
    isOpen.value = false
    parsedResult.value = null
    promptText.value = ''
  } catch (err) {
    console.error('Failed to post payment', err)
  } finally {
    isPosting.value = false
  }
}

defineExpose({ open: () => { isOpen.value = true } })
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogContent class="sm:max-w-lg">
      <DialogHeader>
        <DialogTitle class="flex items-center space-x-2">
          <IconSparkles class="h-5 w-5 text-indigo-500" />
          <span>Transaction Copilot</span>
        </DialogTitle>
        <DialogDescription>
          Type naturally to record rent receipts, utility charges, or vendor expenses.
        </DialogDescription>
      </DialogHeader>

      <div class="space-y-4 py-2">
        <div class="flex space-x-2">
          <Input 
            v-model="promptText" 
            placeholder="e.g. Daryl Terrace paid their rent on the 23rd"
            @keydown.enter.prevent="analyzePrompt"
            :disabled="isParsing" 
          />
          <Button @click="analyzePrompt" :disabled="isParsing || !promptText.trim()">
            <span v-if="isParsing">Parsing...</span>
            <span v-else>Parse</span>
          </Button>
        </div>

        <!-- Structured Parsed Confirmation Card -->
        <div v-if="parsedResult" class="p-4 rounded-lg border bg-slate-50 space-y-3">
          <div class="flex items-center justify-between border-b pb-2">
            <span class="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Proposed Transaction</span>
            <Badge :variant="parsedResult.confidence >= 0.85 ? 'default' : 'secondary'">
              {{ Math.round(parsedResult.confidence * 100) }}% Confidence
            </Badge>
          </div>

          <div class="grid grid-cols-2 gap-2 text-sm">
            <div>
              <span class="text-muted-foreground">Property / Unit:</span>
              <p class="font-medium">{{ parsedResult.propertyName }} ({{ parsedResult.unitName }})</p>
            </div>
            <div>
              <span class="text-muted-foreground">Tenant:</span>
              <p class="font-medium">{{ parsedResult.tenantName }}</p>
            </div>
            <div>
              <span class="text-muted-foreground">Payment Date:</span>
              <p class="font-medium">{{ parsedResult.paymentDate }}</p>
            </div>
            <div>
              <span class="text-muted-foreground">Amount:</span>
              <p class="font-medium text-emerald-600 font-mono">${{ parsedResult.amount.toFixed(2) }}</p>
            </div>
          </div>
        </div>
      </div>

      <DialogFooter>
        <Button variant="ghost" @click="isOpen = false">Cancel</Button>
        <Button 
          v-if="parsedResult" 
          @click="confirmAndPost" 
          :disabled="isPosting" 
          class="bg-emerald-600 hover:bg-emerald-700 text-white"
        >
          <IconCheck class="mr-1.5 h-4 w-4" />
          <span>{{ isPosting ? 'Posting...' : 'Confirm & Post to Ledger' }}</span>
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
```

---

### 3.5 Multimodal OCR Bill Intake (`components/ai/BillIntakeDropzone.vue`)

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { IconUploadCloud, IconFileText, IconCheckCircle } from 'lucide-vue-next'

const isDragging = ref(false)
const isAnalyzing = ref(false)
const extractedBill = ref<{
  supplierName: string
  invoiceNumber: string
  invoiceDate: string
  dueDate: string
  totalAmount: number
  propertyAddress: string
  matchedSupplierId?: number
  matchedPropertyId?: number
} | null>(null)

async function handleFileUpload(file: File) {
  isAnalyzing.value = true
  const formData = new FormData()
  formData.append('document', file)

  try {
    const res = await $fetch('/api/ai/document-intake/ocr', {
      method: 'POST',
      body: formData
    })
    extractedBill.value = res as any
  } catch (err) {
    console.error('OCR Extraction failed', err)
  } finally {
    isAnalyzing.value = false
  }
}

function onDrop(e: DragEvent) {
  isDragging.value = false
  if (e.dataTransfer?.files?.length) {
    handleFileUpload(e.dataTransfer.files[0])
  }
}
</script>

<template>
  <div class="space-y-6">
    <div 
      @dragover.prevent="isDragging = true"
      @dragleave.prevent="isDragging = false"
      @drop.prevent="onDrop"
      :class="[
        'border-2 border-dashed rounded-xl p-8 text-center transition-colors cursor-pointer',
        isDragging ? 'border-indigo-500 bg-indigo-50/50' : 'border-slate-300 hover:border-slate-400'
      ]"
    >
      <input type="file" class="hidden" id="bill-upload" accept="image/*,application/pdf" @change="(e: any) => handleFileUpload(e.target.files[0])" />
      <label for="bill-upload" class="cursor-pointer space-y-2 block">
        <IconUploadCloud class="mx-auto h-10 w-10 text-muted-foreground" />
        <div class="text-sm font-medium">
          Drop vendor bills or contractor invoices here, or <span class="text-indigo-600">browse</span>
        </div>
        <p class="text-xs text-muted-foreground">Accepts PDF, PNG, JPG, or HEIC</p>
      </label>
    </div>

    <!-- Extraction Loading State -->
    <div v-if="isAnalyzing" class="p-6 rounded-lg border bg-slate-50 text-center space-y-2">
      <div class="animate-spin inline-block h-6 w-6 border-2 border-indigo-600 border-t-transparent rounded-full" />
      <p class="text-sm font-medium">Extracting vendor, line items, and totals via multimodal OCR...</p>
    </div>

    <!-- Parsed Bill Review Form -->
    <Card v-if="extractedBill" class="border-emerald-200">
      <CardHeader>
        <CardTitle class="text-lg flex items-center text-emerald-800">
          <IconCheckCircle class="mr-2 h-5 w-5 text-emerald-600" />
          Review Extracted Bill Details
        </CardTitle>
      </CardHeader>
      <CardContent class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Supplier / Vendor</label>
          <Input v-model="extractedBill.supplierName" class="mt-1" />
        </div>
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Invoice Number</label>
          <Input v-model="extractedBill.invoiceNumber" class="mt-1" />
        </div>
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Invoice Date</label>
          <Input type="date" v-model="extractedBill.invoiceDate" class="mt-1" />
        </div>
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Due Date</label>
          <Input type="date" v-model="extractedBill.dueDate" class="mt-1" />
        </div>
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Property Address</label>
          <Input v-model="extractedBill.propertyAddress" class="mt-1" />
        </div>
        <div>
          <label class="text-xs font-semibold text-muted-foreground uppercase">Total Amount ($)</label>
          <Input type="number" step="0.01" v-model="extractedBill.totalAmount" class="mt-1 font-mono" />
        </div>
        <div class="md:col-span-2 pt-2 flex justify-end space-x-2">
          <Button variant="outline" @click="extractedBill = null">Discard</Button>
          <Button class="bg-emerald-600 hover:bg-emerald-700 text-white">Post to Accounts Payable</Button>
        </div>
      </CardContent>
    </Card>
  </div>
</template>
```

---

## 4. Acceptance Criteria & Automated Verification Commands

1. [ ] Nuxt 3 application passes Vue SFC TypeScript compilation cleanly with zero errors:
   ```bash
   npx nuxi typecheck packages/web
   ```
2. [ ] All core dashboard routes (`/properties`, `/properties/[id]`, `/billing`, `/accounting/trial-balance`) render without hydration errors.
3. [ ] Pinia stores manage business unit selection and reactive caching cleanly.
4. [ ] AI Transaction Copilot and OCR Bill Intake dropzone integrate seamlessly with server API routes.
5. [ ] Automated test, lint, and production build verification:
   ```bash
   npm --prefix packages/web install
   npm --prefix packages/web run build
   npm --prefix packages/web test
   ```
