---
id: wp-05-ai-intake-copilot
title: "Work Package 05: Document OCR, Smart Payment Allocation & Natural Language Copilot"
status: pending
phase: design
slug: property-management
target_repo: visulate
branch: feat/wp-05-ai-intake-copilot
design_doc: docs/projects/property-management/02-designs/02-application-services-tdd.md
dependencies:
  - wp-03-backend-domain-services
  - wp-04-accounting-ledger-engine
scope:
  - ai
  - ocr
  - multimodal
  - copilot
  - yardi-ingest
---

# Work Package 05: Document OCR, Smart Payment Allocation & Natural Language Copilot

## 1. Objective & Deliverables Overview
Implement the workload-reducing AI helper engine specified in SOW Section 3.4 and TDD Section 5:
1. **Multimodal Document OCR**: Extracts structured invoice data from vendor bills and receipts.
2. **Smart Payment Matcher**: Fuzzy matches bank/Zelle transaction descriptions against active tenants and leases.
3. **Natural Language Copilot**: Converts conversational prompts (e.g., *"Daryl Terrace paid their rent on the 23rd"*) into structured interactive confirmation cards and verified database commits.
4. **Yardi Ingestion Engine**: Backfills 2026–2027 operational rent roll and ledger records from interim Yardi reports.

### Key Target Files to Create:
1. `packages/server/src/ai/document_intake.service.ts`: Vision extractor with JSON schema validation.
2. `packages/server/src/ai/payment_matcher.service.ts`: Fuzzy matching service for incoming payments.
3. `packages/server/src/ai/transaction_copilot.service.ts`: NLP intent parser and conversational resolution engine.
4. `packages/server/src/ai/yardi_ingestion.service.ts`: Structured parser and backfill orchestrator for Yardi CSV/PDF exports.
5. `packages/server/tests/ai_copilot.test.ts`: Evaluation test suite with sample documents and prompts.

---

## 2. Technical Contracts & Implementation Specifications

### 2.1 Multimodal Document OCR (`document_intake.service.ts`)
- **Input**: Image (`image/jpeg`, `image/png`) or PDF document buffer.
- **Extraction Schema**:
  ```typescript
  export interface ParsedBillData {
    supplierName: string;
    invoiceNumber: string;
    invoiceDate: string;
    dueDate: string;
    totalAmount: number;
    propertyAddress: string;
    lineItems: Array<{
      description: string;
      amount: number;
    }>;
  }
  ```
- **Fuzzy Resolution**: Matches `supplierName` against `rnt_suppliers_all` and `propertyAddress` against `rnt_properties`. Returns a pre-populated draft Accounts Payable object for user confirmation.

### 2.2 Conversational Transaction Copilot (`transaction_copilot.service.ts`)
- **Example Prompt**: *"Daryl Terrace paid their rent on the 23rd"*
- **Resolution Strategy**:
  1. **Entity Extraction**: Matches `"Daryl Terrace"` to Property ID `42` (`2354 Daryl Terrace`), finds active lease for Unit 1.
  2. **Temporal Resolution**: Resolves `"on the 23rd"` relative to current system date to `2026-11-23`.
  3. **Confirmation Payload**:
     ```json
     {
       "action": "RECORD_RENT_PAYMENT",
       "propertyId": 42,
       "propertyName": "2354 Daryl Terrace",
       "unitName": "Unit 1",
       "tenantName": "Robert Johnson",
       "paymentDate": "2026-11-23",
       "amount": 1650.00,
       "paymentMethod": "OTHER",
       "confidence": 0.96
     }
     ```
  4. Returns the structured payload for client UI confirmation before calling `PaymentService.allocatePayment()`.

### 2.3 Yardi 2026–2027 Ingestion Module (`yardi_ingestion.service.ts`)
- Ingests CSV or structured PDF exports from Yardi.
- Maps Yardi unit IDs and tenant names to target PostgreSQL `unit_id` and `tenant_id`.
- Generates retroactive AR charges and matching payment allocations for historical continuity.

---

## 3. Acceptance Criteria & Automated Verification Commands
1. [ ] Document OCR extracts supplier, total amount, and line items with > 95% accuracy on test bill samples.
2. [ ] Prompt *"Daryl Terrace paid their rent on the 23rd"* parses into correct property, unit, and payment payload.
3. [ ] Yardi ingestion processes sample rent roll CSV and outputs validated database insertion records.
4. [ ] Automated test suite execution:
   ```bash
   npm --prefix packages/server test -- --grep "AI"
   ```
