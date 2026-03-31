---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
status: 'complete'
completedAt: '2026-03-30'
inputDocuments: ['docs/prd.md', 'docs/product-brief-ftrade.md', 'docs/product-brief-ftrade-distillate.md']
workflowType: 'architecture'
project_name: 'FTrade'
user_name: 'Chau'
date: '2026-03-30'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements (35 total, 28 new Phase 3):**

| Group | FRs | Architectural Impact |
|---|---|---|
| AI Morning Brief (FR1-6) | Core MVP feature | Backend cron → Claude API → cache → serve. Shared content model. |
| Feedback & Accuracy (FR7-9) | Data collection | Database cho feedback records, accuracy comparison engine |
| Free/Premium Gating (FR10-13) | Business logic | User tier management, IAP integration, entitlement checking |
| Notifications (FR14-16) | Push infrastructure | FCM integration, notification preferences storage |
| Compliance (FR17-20) | AI safety layer | Output validation pipeline, disclaimer injection, ToS consent |
| Admin (FR21-25) | Monitoring | Dashboard (platform TBD), analytics, cost tracking |
| Data & Connectivity (FR26-28) | Resilience | Offline cache cho Morning Brief, connectivity monitoring |
| Existing Phase 1-2 (FR29-35) | Foundation | Already implemented — MQTT, news, watchlist, TA/FA, alerts |

**Non-Functional Requirements Driving Architecture:**

| NFR | Architectural Decision It Drives |
|---|---|
| NFR1 (cron < 30min) | Cron job reliability, Claude API timeout handling |
| NFR6 (API key backend only) | Mandatory backend proxy — cannot call Claude from app |
| NFR11 (10K concurrent) | Cache-first architecture, CDN for Morning Brief |
| NFR12 (shared content) | Single generation → broadcast model, not per-user |
| NFR13 (CDN/edge cache) | Static file serving or edge function response caching |
| NFR15 (99% uptime trading hours) | Managed infrastructure, no single point of failure |
| NFR16 (retry 3x exponential) | Resilient cron job with fallback to previous brief |

**Scale & Complexity:**

- Primary domain: Mobile (Flutter) + Serverless Backend
- Complexity level: High
- Estimated architectural components: ~8 (Flutter app, backend proxy, cron service, cache layer, push service, IAP service, admin interface, AI validation pipeline)

### Technical Constraints & Dependencies

1. **Existing stack (non-negotiable):** Flutter + Riverpod + Freezed + fpdart Either + Hive
2. **AI provider:** Claude API (Anthropic) — decided by founder
3. **Data sources:** SSI MQTT (realtime), VNDirect REST (historical/FA), Vietstock RSS (news) — all unofficial
4. **Payment:** IAP only (Apple/Google mandate for digital subscriptions)
5. **Solo developer:** Must use managed/serverless services to minimize ops
6. **Budget constraint:** AI cost ≤ $3/paid user/month, free ≤ $0.5/user/month

### Cross-Cutting Concerns

1. **Caching Strategy** — Morning Brief 4h TTL, market data real-time, news hourly, FA 6h. Multiple cache layers (local Hive + backend/CDN)
2. **Authentication & Entitlements** — Free vs Premium tier gating across multiple features
3. **Compliance Pipeline** — AI output validation + disclaimer injection applies to all AI-generated content
4. **Offline Resilience** — Cache Morning Brief cuối cùng, hiển thị khi offline kèm timestamp (FR5). Các screen khác giữ nguyên behavior Phase 1-2.
5. **Error Handling** — Backend failures, API timeouts, data source outages all need graceful degradation
6. **Cost Control** — Shared brief model, rate limiting, usage tracking per tier

## Starter Template Evaluation

### Primary Technology Domain

Brownfield mobile app (Flutter, Phase 1-2 complete). Phase 3 cần **backend service mới** để proxy Claude API, cron job, push notifications.

### Starter Options Considered

| Option | Verdict |
|---|---|
| Dart (dart_frog/shelf) | ❌ Rejected — ecosystem non, community nhỏ, rủi ro cao |
| Supabase Edge Functions (Deno) | ❌ Rejected — FCM không native, cron yếu, thêm 1 platform quản lý |
| **Firebase Functions (Node.js/TS)** | ✅ Selected |

### Selected Stack: Firebase Functions + TypeScript

**Rationale:**
- Node.js/TS ecosystem mature, Claude SDK chính thức (`@anthropic-ai/sdk`)
- Firebase ecosystem thống nhất: Functions + Firestore + FCM + Cloud Scheduler + Crashlytics (đã dùng)
- Serverless — solo developer không cần quản lý server
- Cron job native qua Cloud Scheduler (Morning Brief FR4)
- FCM push notification native (FR14)

**Initialization Command:**
```bash
firebase init functions --typescript
npm install @anthropic-ai/sdk firebase-admin
```

**Backend Stack:**
- Runtime: Node.js 20 + TypeScript
- Functions: Firebase Cloud Functions (2nd gen)
- Database: Firestore (feedback, accuracy, cost tracking, user entitlements)
- Cron: Cloud Scheduler → trigger Cloud Function
- Push: Firebase Cloud Messaging (FCM)
- AI: `@anthropic-ai/sdk` (Claude API)
- Cache: Firestore + CDN (Firebase Hosting) cho Morning Brief

**Note:** Flutter app giữ nguyên stack hiện tại (Riverpod + Freezed + fpdart + Hive). Không thay đổi Phase 1-2 code.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Backend stack: Firebase Functions + TypeScript ✅
- Database: Firestore ✅
- AI provider: Claude API via `@anthropic-ai/sdk` ✅
- Auth: Firebase Auth (Anonymous → upgrade for Premium) ✅
- Morning Brief data flow: Cron → Claude → Firestore → CDN → App ✅

**Important Decisions (Shape Architecture):**
- API pattern: REST (Firebase HTTP triggers) ✅
- Caching: Firestore + CDN (4h TTL) + Hive (offline) ✅
- Admin: Firebase Console + custom Firestore queries (no separate UI for MVP) ✅
- CI/CD: GitHub Actions → firebase deploy ✅

**Deferred Decisions (Post-MVP):**
- Custom admin dashboard UI (use Firebase Console for MVP)
- Advanced analytics pipeline
- B2B2C API layer
- Personalized AI analysis per user

### Data Architecture

**Morning Brief Data Flow:**
```
Cloud Scheduler (7h sáng)
  → Firebase Function (generateMorningBrief)
    → Collect news (Vietstock RSS)
    → Call Claude API (tóm tắt + phân tích ngành)
    → Validate output (filter ngôn ngữ tư vấn)
    → Save to Firestore (morning_briefs collection)
    → Cache via Firebase Hosting CDN (4h TTL)
    → Trigger FCM push ("Morning Brief đã sẵn sàng")
  → App fetch brief từ CDN/Firestore
  → Hive cache brief cuối cùng cho offline (FR5)
```

**Firestore Collections:**

| Collection | Mục đích | Document Structure |
|---|---|---|
| `morning_briefs` | Brief hàng ngày | 1 doc/ngày, chứa toàn bộ brief JSON (sectors, stocks, summary) |
| `feedback` | User feedback (FR7) | 1 doc/feedback action (userId, sectorId, briefDate, isAccurate) |
| `accuracy_logs` | Dự báo vs thực tế (FR9) | 1 doc/sector/ngày (predicted direction, actual change %) |
| `users` | User tier, preferences | 1 doc/user (tier, fcmToken, notificationPrefs, tosAccepted) |
| `api_costs` | Cost tracking (FR21) | 1 doc/API call (timestamp, tokens, cost, function) |
| `system_config` | System prompt, settings (FR23) | Singleton docs (system_prompt, feature_flags) |

**Caching Strategy:**
- Morning Brief: Firestore → Firebase Hosting CDN (4h TTL) → Hive (offline)
- Market data, news: Giữ nguyên Phase 1-2 caching (Hive local)

### Authentication & Security

- **Auth provider**: Firebase Auth
- **Free tier**: Anonymous auth (không cần đăng ký, giảm friction onboard)
- **Premium tier**: Require email/Google sign-in trước khi mua IAP
- **API key security**: Claude API key chỉ trong Firebase Functions environment config, không trong app binary (NFR6)
- **Transport**: HTTPS/TLS 1.2+ cho mọi app ↔ backend communication (NFR7)
- **Rate limiting**: Custom middleware trên Firebase Functions — 100 requests/phút/user (NFR10)
- **Payment security**: IAP validation server-side qua Apple/Google receipt verification (NFR8)
- **Admin auth**: Firebase Auth với custom claims (role: admin) cho admin endpoints (NFR9)

### API & Communication Patterns

**REST API Endpoints (Firebase HTTP Triggers):**

| Method | Endpoint | Auth | Mục đích |
|---|---|---|---|
| GET | `/api/morning-brief` | Anonymous | Fetch brief mới nhất |
| GET | `/api/morning-brief/:date` | Anonymous | Fetch brief theo ngày |
| POST | `/api/feedback` | Authenticated | Submit accuracy feedback |
| GET | `/api/user/entitlements` | Authenticated | Check Free/Premium tier |
| POST | `/api/user/register-fcm` | Authenticated | Register FCM token |
| POST | `/api/iap/verify` | Authenticated | Verify IAP receipt |
| GET | `/admin/costs` | Admin | API cost dashboard |
| GET | `/admin/accuracy` | Admin | Accuracy metrics |
| PUT | `/admin/system-prompt` | Admin | Update Claude system prompt |

**Error Handling Standards:**
- Claude API fail → retry 3x exponential backoff (1s, 4s, 16s) → fallback brief ngày trước (NFR16, NFR17)
- AI output validation: Regex check "nên mua", "khuyến nghị", "đề xuất mua/bán" → reject và retry với adjusted prompt (FR18, FR20)
- All errors return structured JSON: `{ error: string, code: string, fallback?: data }`

### Frontend Architecture (Flutter — Additions to Phase 1-2)

**New Riverpod Providers:**
- `morningBriefProvider` — fetch + cache brief
- `userEntitlementProvider` — Free/Premium state
- `feedbackProvider` — submit feedback actions
- `fcmProvider` — notification management

**New Packages:**
- `firebase_messaging` — FCM push notifications
- `in_app_purchase` — IAP subscription
- `firebase_auth` — Authentication
- `dio` or `http` — REST API calls to Firebase Functions

**New Hive Boxes:**
- `morning_brief_cache` — cached brief cuối cùng cho offline

### Infrastructure & Deployment

- **Firebase project**: 1 project, 2 environments (dev + prod) via Firebase project aliases
- **CI/CD**: GitHub Actions → `firebase deploy --only functions` on push to main
- **Monitoring**: Firebase Console (Cloud Functions logs, error reporting, Firestore usage)
- **Cost monitoring**: Firebase budget alerts + custom `api_costs` collection
- **Admin dashboard (MVP)**: Firebase Console + Firestore queries (không build UI riêng)
- **Scaling**: Firebase auto-scales Cloud Functions. Morning Brief CDN handles 10K concurrent (NFR11)

### Decision Impact Analysis

**Implementation Sequence:**
1. Firebase project setup + Auth + Firestore collections
2. Claude API proxy function + output validation
3. Morning Brief cron job + CDN caching
4. Flutter: Morning Brief screen + API integration
5. FCM push notification
6. Free/Premium gating + IAP
7. Feedback system
8. Admin queries + cost tracking

**Cross-Component Dependencies:**
- IAP verification depends on Firebase Auth (need user identity)
- FCM depends on Firebase Auth (need FCM token per user)
- Feedback depends on Morning Brief (need briefId, sectorId)
- Free/Premium gating depends on IAP verification + Firestore user doc

## Implementation Patterns & Consistency Rules

### Naming Patterns

**Firestore Collections:** snake_case, plural
```
morning_briefs, feedback, accuracy_logs, users, api_costs, system_config
```

**Firestore Fields:** camelCase
```
userId, briefDate, sectorName, isAccurate, createdAt
```

**Firebase Functions:** camelCase
```
generateMorningBrief, verifyIapReceipt, submitFeedback
```

**REST API Endpoints:** kebab-case, plural nouns
```
GET  /api/morning-briefs
POST /api/feedback
GET  /api/user/entitlements
```

**TypeScript Files (Firebase Functions):** kebab-case
```
morning-brief.ts, iap-verify.ts, feedback.ts, claude-client.ts
```

**TypeScript Code:**
- Functions: camelCase (`generateMorningBrief`)
- Interfaces: PascalCase (`IMorningBrief`)
- Constants: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)

**Flutter (giữ nguyên Phase 1-2 conventions):**
- Files: snake_case (`morning_brief_screen.dart`)
- Classes: PascalCase (`MorningBriefProvider`)
- Variables/functions: camelCase (`fetchBrief()`)
- Freezed models: PascalCase (`MorningBrief`)

### API Response Format

**Success Response:**
```json
{
  "success": true,
  "data": { ... }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "BRIEF_NOT_FOUND",
    "message": "Morning brief for today is not available yet"
  }
}
```

### Date/Time Format

- API JSON: ISO 8601 string (`"2026-03-30T07:30:00+07:00"`)
- Firestore: Timestamp native type
- Flutter display: Format tiếng Việt (`"30/03/2026 07:30"`)

### Error Handling Patterns

**Firebase Functions:**
- Business errors: return HTTP 4xx + error JSON
- Claude API fail: retry 3x exponential backoff (1s, 4s, 16s) → fallback brief cũ
- Unexpected errors: log to Cloud Logging + return HTTP 500

**Flutter:**
- Dùng fpdart `Either<Failure, T>` (giữ nguyên pattern Phase 1-2)
- Network errors → show cached data + offline banner
- Morning Brief fail → show brief cuối cùng từ Hive

### State Management (Flutter)

- `AsyncValue<T>` từ Riverpod cho loading/error/data states
- Không dùng global loading state — mỗi provider tự quản lý
- Giữ nguyên pattern Phase 1-2

### Logging

**Firebase Functions:**
```typescript
functions.logger.info("Morning brief generated", { sectors: 5, cost: 0.04 });
functions.logger.error("Claude API failed", { attempt: 3, error: err.message });
```

**Flutter:** Giữ nguyên logging pattern Phase 1-2

### Enforcement Guidelines

**All AI Agents MUST:**
- Follow naming conventions exactly as defined above
- Use `Either<Failure, T>` for all Flutter data operations
- Use structured error JSON for all Firebase Functions responses
- Never embed API keys in Flutter code — always via Firebase Functions
- Always include disclaimer text in any AI-generated content display
- Validate Claude API output before storing to Firestore

## Project Structure & Boundaries

### Flutter App (Existing + Phase 3 Additions)

```
FTrade/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── error/
│   │   ├── extensions/
│   │   ├── network/
│   │   ├── router/
│   │   ├── services/
│   │   ├── storage/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   └── features/
│       ├── corporate/          ← Phase 1-2 (existing)
│       ├── fundamental/        ← Phase 1-2 (existing)
│       ├── home/               ← Phase 1-2 (existing)
│       ├── market/             ← Phase 1-2 (existing)
│       ├── money_flow/         ← Phase 1-2 (existing)
│       ├── news/               ← Phase 1-2 (existing)
│       ├── settings/           ← Phase 1-2 (existing)
│       ├── watchlist/          ← Phase 1-2 (existing)
│       │
│       ├── morning_brief/      ← NEW (FR1-FR6)
│       │   ├── data/
│       │   │   ├── datasources/    (api_datasource.dart)
│       │   │   ├── models/         (morning_brief_model.dart, sector_model.dart)
│       │   │   └── repositories/   (morning_brief_repository_impl.dart)
│       │   ├── domain/
│       │   │   ├── entities/       (morning_brief.dart, sector_analysis.dart)
│       │   │   ├── repositories/   (morning_brief_repository.dart)
│       │   │   └── usecases/       (get_morning_brief.dart)
│       │   └── presentation/
│       │       ├── providers/      (morning_brief_provider.dart)
│       │       ├── screens/        (morning_brief_screen.dart)
│       │       └── widgets/        (sector_card.dart, stock_list.dart, disclaimer.dart)
│       │
│       ├── feedback/            ← NEW (FR7)
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── subscription/        ← NEW (FR10-FR13)
│       │   ├── data/              (iap_datasource.dart, entitlement_repository_impl.dart)
│       │   ├── domain/            (user_entitlement.dart, check_entitlement.dart)
│       │   └── presentation/      (paywall_screen.dart, upgrade_prompt.dart)
│       │
│       └── auth/                ← NEW (Firebase Auth)
│           ├── data/
│           ├── domain/
│           └── presentation/
```

### Firebase Functions Backend (NEW)

```
FTrade/
├── functions/
│   ├── package.json
│   ├── tsconfig.json
│   ├── .eslintrc.js
│   ├── src/
│   │   ├── index.ts                 (function exports)
│   │   ├── morning-brief/
│   │   │   ├── generate.ts          (cron: collect → Claude → validate → save)
│   │   │   ├── serve.ts             (HTTP: GET /api/morning-briefs)
│   │   │   └── validate-output.ts   (AI output compliance check)
│   │   ├── feedback/
│   │   │   └── submit.ts            (HTTP: POST /api/feedback)
│   │   ├── auth/
│   │   │   └── on-create.ts         (Firestore trigger: init user doc)
│   │   ├── iap/
│   │   │   └── verify.ts            (HTTP: POST /api/iap/verify)
│   │   ├── notifications/
│   │   │   └── send-brief-ready.ts  (FCM push after brief generated)
│   │   ├── admin/
│   │   │   ├── costs.ts             (HTTP: GET /admin/costs)
│   │   │   ├── accuracy.ts          (HTTP: GET /admin/accuracy)
│   │   │   └── system-prompt.ts     (HTTP: PUT /admin/system-prompt)
│   │   ├── shared/
│   │   │   ├── claude-client.ts     (Anthropic SDK wrapper)
│   │   │   ├── firestore.ts         (Firestore helpers)
│   │   │   ├── middleware.ts        (auth, rate-limit, admin check)
│   │   │   └── types.ts             (shared TypeScript interfaces)
│   │   └── config/
│   │       └── constants.ts         (retry counts, TTL, rate limits)
│   └── tests/
│       ├── morning-brief.test.ts
│       ├── feedback.test.ts
│       └── iap.test.ts
```

### Shared Project Files

```
FTrade/
├── .github/
│   └── workflows/
│       └── deploy-functions.yml     (CI/CD: deploy Firebase Functions)
├── firebase.json                    (Firebase project config)
├── .firebaserc                      (project aliases: dev/prod)
├── firestore.rules                  (Firestore security rules)
├── firestore.indexes.json           (composite indexes)
├── docs/                            (planning artifacts)
├── PROGRESS.md
└── README.md
```

### Architectural Boundaries

**API Boundary (Flutter ↔ Firebase Functions):**
- Flutter app calls Firebase Functions via HTTPS REST
- No direct Firestore access from Flutter for Phase 3 data
- Morning Brief served via CDN cache, fallback to Firestore

**Data Boundary:**
- Phase 1-2 data: Hive local only (market, news, watchlist, TA/FA)
- Phase 3 data: Firestore (briefs, feedback, users, costs) + Hive cache (offline brief)
- No data migration needed — Phase 3 adds new collections, doesn't modify existing

**Auth Boundary:**
- Phase 1-2 features: No auth required (local-only features)
- Phase 3 features: Firebase Auth (anonymous for free, signed-in for premium)

### FR → Structure Mapping

| FR Group | Flutter Feature | Firebase Function |
|---|---|---|
| Morning Brief (FR1-6) | `features/morning_brief/` | `src/morning-brief/` |
| Feedback (FR7-9) | `features/feedback/` | `src/feedback/` |
| Free/Premium (FR10-13) | `features/subscription/` | `src/iap/` |
| Notifications (FR14-16) | `core/services/` (FCM) | `src/notifications/` |
| Compliance (FR17-20) | `morning_brief/widgets/disclaimer.dart` | `src/morning-brief/validate-output.ts` |
| Admin (FR21-25) | N/A (Firebase Console) | `src/admin/` |
| Auth | `features/auth/` | `src/auth/` |

### Data Flow

```
[Vietstock RSS] → [Cloud Scheduler 7h] → [generateMorningBrief Function]
  → [Claude API] → [validate-output] → [Firestore morning_briefs]
  → [Firebase Hosting CDN] → [Flutter app GET /api/morning-briefs]
  → [Hive cache] → [Morning Brief Screen]
```

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:**
- Firebase Functions (Node.js/TS) + Firestore + FCM + Cloud Scheduler — cùng ecosystem, không conflict
- Flutter app giữ nguyên Phase 1-2 stack, Phase 3 chỉ thêm features mới — không breaking changes
- `@anthropic-ai/sdk` chạy native trên Node.js — tương thích hoàn toàn

**Pattern Consistency:**
- Naming conventions rõ ràng cho cả 2 codebases (Flutter snake_case files, TS kebab-case files)
- API response format thống nhất (`success/data/error`)
- Error handling consistent: Either trên Flutter, structured JSON trên Functions

**Structure Alignment:**
- Flutter features theo Clean Architecture (data/domain/presentation) — giống Phase 1-2
- Firebase Functions theo feature folders — mapping rõ ràng với FR groups

### Requirements Coverage ✅

**Functional Requirements:**

| FR Group | Architecture Support | Status |
|---|---|---|
| Morning Brief (FR1-6) | Cron → Claude → Firestore → CDN → Flutter | ✅ Covered |
| Feedback (FR7-9) | Flutter POST → Functions → Firestore | ✅ Covered |
| Free/Premium (FR10-13) | Firebase Auth + IAP + Firestore entitlements | ✅ Covered |
| Notifications (FR14-16) | FCM + Cloud Functions trigger | ✅ Covered |
| Compliance (FR17-20) | validate-output.ts + disclaimer widget | ✅ Covered |
| Admin (FR21-25) | Admin endpoints + Firebase Console | ✅ Covered |
| Data/Connectivity (FR26-28) | Hive cache + offline brief | ✅ Covered |
| Existing Phase 1-2 (FR29-35) | No changes needed | ✅ Done |

**Non-Functional Requirements:**

| NFR | Architecture Support | Status |
|---|---|---|
| NFR1 (cron < 30min) | Cloud Scheduler + Functions timeout config | ✅ |
| NFR6 (API key backend) | Functions environment config | ✅ |
| NFR11 (10K concurrent) | CDN + Firestore auto-scale | ✅ |
| NFR12 (shared content) | 1 brief/day in Firestore, CDN serve | ✅ |
| NFR15 (99% uptime) | Firebase managed infrastructure | ✅ |
| NFR16 (retry 3x) | Documented retry pattern in generate.ts | ✅ |

### Implementation Readiness ✅

**Decision Completeness:** All critical decisions documented with rationale
**Structure Completeness:** Full directory tree for both Flutter and Functions
**Pattern Completeness:** Naming, API format, error handling, logging all defined

### Gap Analysis

**No critical gaps.**

**Important (non-blocking, resolve during implementation):**
1. ⚠️ Morning Brief JSON schema — define concrete response structure before implementing Flutter model + Functions output
2. ⚠️ Claude system prompt template — draft before testing output quality
3. ⚠️ Firestore security rules — write before first deploy

**Deferred (post-MVP):**
- Custom admin dashboard UI
- Advanced analytics pipeline
- Personalized AI per user
- B2B2C API layer

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**✅ Architectural Decisions**
- [x] Critical decisions documented with rationale
- [x] Technology stack fully specified (Flutter + Firebase + Claude)
- [x] Integration patterns defined (REST, CDN, FCM)
- [x] Performance considerations addressed (caching, CDN, shared brief)

**✅ Implementation Patterns**
- [x] Naming conventions established (both codebases)
- [x] Structure patterns defined (Clean Architecture + feature folders)
- [x] API format patterns specified (success/error JSON)
- [x] Process patterns documented (error handling, retry, logging)

**✅ Project Structure**
- [x] Complete directory structure defined
- [x] Component boundaries established (API, data, auth)
- [x] Integration points mapped (data flow diagram)
- [x] FR → structure mapping complete

### Architecture Readiness Assessment

**Overall Status:** ✅ READY FOR IMPLEMENTATION

**Confidence Level:** High

**Key Strengths:**
- Clean separation: Flutter app unchanged, backend entirely new
- Firebase ecosystem eliminates integration complexity
- Shared Morning Brief model keeps costs predictable
- Clean Architecture in Flutter ensures consistent feature development

**First Implementation Priority:**
1. `firebase init` — project setup + Firestore + Functions
2. `functions/src/morning-brief/generate.ts` — core cron job
3. `lib/features/morning_brief/` — Flutter feature module

---

*Architecture document completed: 2026-03-30*
