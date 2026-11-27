---
id: wp-03-backend-domain-services
title: "Work Package 03: Core Property, Tenancy & Contact Backend Services"
status: pending
phase: design
slug: property-management
target_repo: visulate
branch: feat/wp-03-backend-domain-services
design_doc: docs/projects/property-management/02-designs/02-application-services-tdd.md
dependencies:
  - wp-01-schema
scope:
  - backend
  - domain-services
  - api
  - typescript
---

# Work Package 03: Core Property, Tenancy & Contact Backend Services

## 1. Objective & Deliverables Overview
Implement the modern TypeScript/Node.js backend service layer for Properties, Units, Tenants, Leases, and Contacts. This replaces legacy procedural PHP classes (`rnt_properties.class.php`, `rnt_tenants.class.php`, `rnt_agreement.class.php`) with type-safe domain services, input validation, optimistic concurrency control, and RESTful API endpoints.

### Key Target Files to Create:
1. `packages/server/src/domains/properties/property.service.ts`: Property and Unit lifecycle, occupancy calculations, and PostGIS spatial queries.
2. `packages/server/src/domains/tenancy/tenancy.service.ts`: Tenant onboarding, lease creation, renewal workflows, and agreement action logging.
3. `packages/server/src/domains/contacts/contact.service.ts`: People directory and business unit associations.
4. `packages/server/src/api/routes/property.router.ts`: Fastify/Express REST endpoints for properties and units.
5. `packages/server/src/api/routes/tenancy.router.ts`: REST endpoints for tenants, leases, and action history.
6. `packages/server/tests/property.service.test.ts`: Automated unit and integration tests.

---

## 2. Legacy PHP Context & Modern Service Architecture
- **Legacy Files**:
  - `code/php/classes/database/rnt_properties.class.php` (818 LOC)
  - `code/php/classes/database/rnt_tenants.class.php` (450 LOC)
  - `code/php/classes/database/rnt_agreement.class.php` (520 LOC)
- **Key Modern Patterns**:
  - **Optimistic Concurrency**: Check `updated_at` timestamps on write operations to prevent lost updates.
  - **Multi-Tenancy**: Enforce `business_id` scoping across all database queries.
  - **PostGIS Geocoding**: Store property coordinates as `ST_SetSRID(ST_MakePoint(lng, lat), 4326)` and provide spatial bounding-box search.

---

## 3. Interface Contracts & Domain Models

### 3.1 Domain Interfaces
```typescript
export interface CreatePropertyInput {
  businessId: bigint;
  name: string;
  address1: string;
  city: string;
  state?: string;
  zipcode: string;
  units: number;
  datePurchased?: string;
  purchasePrice?: number;
  latitude?: number;
  longitude?: number;
}

export interface CreateTenancyAgreementInput {
  businessId: bigint;
  unitId: bigint;
  tenantId: bigint;
  startDate: string;
  endDate: string;
  monthlyRent: number;
  deposit: number;
  notes?: string;
}

export interface TenancyAgreementSummary {
  agreementId: bigint;
  unitId: bigint;
  propertyName: string;
  unitName: string;
  tenantName: string;
  startDate: string;
  endDate: string;
  monthlyRent: number;
  status: 'ACTIVE' | 'TERMINATED' | 'EXPIRED';
}
```

### 3.2 REST API Specifications
- `GET /api/v1/properties`: Query properties by business ID with pagination and optional coordinate bounding box.
- `POST /api/v1/properties`: Create a new property; generates default unit records if `units == 1`.
- `GET /api/v1/properties/:id/units`: List all units for a given property with occupancy status.
- `POST /api/v1/tenancy/agreements`: Create an active lease agreement and transition unit status to `OCCUPIED`.
- `POST /api/v1/tenancy/agreements/:id/terminate`: Terminate a lease, record move-out date, and transition unit to `VACANT`.

---

## 4. Acceptance Criteria & Automated Verification Commands
1. [ ] Property and Unit creation workflows enforce validation rules (`units >= 1`, valid ZIP code).
2. [ ] Creating an active agreement transitions the unit status from `VACANT` to `OCCUPIED`.
3. [ ] PostGIS coordinates query correctly and return GeoJSON representations.
4. [ ] Optimistic locking throws a `409 Conflict` if `updated_at` has changed.
5. [ ] Automated test suite execution:
   ```bash
   npm --prefix packages/server install
   npm --prefix packages/server test -- --grep "Property|Tenancy"
   ```
