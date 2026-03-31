# Implementation Readiness Assessment Report

**Date:** 2026-03-29
**Project:** FTrade

## Document Inventory

### Documents Found
| Document Type | File | Status |
|---|---|---|
| PRD | `docs/prd.md` | ✅ Found |
| Product Brief | `docs/product-brief-ftrade.md` | ✅ Found (supplemental) |
| Detail Pack | `docs/product-brief-ftrade-distillate.md` | ✅ Found (supplemental) |
| Architecture | — | ⚠️ Missing |
| Epics/Stories | — | ⚠️ Missing |
| UX Design | — | ⚠️ Missing |

### Issues
- No duplicate documents found
- Architecture, Epics/Stories, and UX Design documents are missing

## PRD Analysis

### Functional Requirements (35 total)

#### AI Morning Brief (FR1-FR6)
- **FR1**: User can xem AI Morning Brief tóm tắt 3-5 tin quan trọng nhất hôm nay
- **FR2**: User can xem phân tích tác động của từng tin đến nhóm ngành cụ thể
- **FR3**: User can xem danh sách mã đáng chú ý trong mỗi nhóm ngành được phân tích
- **FR4**: System tự động tạo Morning Brief mỗi ngày trước 8h sáng
- **FR5**: System cache Morning Brief và hiển thị brief cuối cùng khi user offline
- **FR6**: User can xem timestamp cập nhật của Morning Brief

#### Feedback & Accuracy (FR7-FR9)
- **FR7**: User can đánh giá mỗi dự báo ngành là "Chính xác" hoặc "Không chính xác"
- **FR8**: Admin can xem accuracy rate tổng hợp theo tuần và theo nhóm ngành
- **FR9**: System log mọi dự báo ngành và so sánh với biến động thực tế

#### Free/Premium Gating (FR10-FR13)
- **FR10**: Free user can xem 1 nhóm ngành/ngày trong Morning Brief
- **FR11**: Premium user can xem tất cả nhóm ngành trong Morning Brief
- **FR12**: User can nâng cấp từ Free lên Premium qua in-app purchase
- **FR13**: System hiển thị upgrade prompt khi Free user đạt giới hạn

#### Notifications (FR14-FR16)
- **FR14**: User nhận push notification khi Morning Brief đã sẵn sàng
- **FR15**: User can bật/tắt từng loại notification trong Settings
- **FR16**: User nhận push notification khi price alert triggered (đã có Phase 2)

#### Compliance & Disclaimer (FR17-FR20)
- **FR17**: System hiển thị disclaimer dưới mỗi phân tích AI
- **FR18**: AI output không chứa ngôn ngữ khuyến nghị mua/bán trực tiếp
- **FR19**: User phải đồng ý Terms of Service trước khi sử dụng AI features lần đầu
- **FR20**: System validate AI response trước khi hiển thị (filter ngôn ngữ tư vấn)

#### Admin & Monitoring (FR21-FR25)
- **FR21**: Admin can xem API cost tổng hợp theo ngày/tháng
- **FR22**: Admin can xem accuracy tracking theo nhóm ngành
- **FR23**: Admin can chỉnh sửa system prompt cho Claude API
- **FR24**: Admin nhận notification khi cron job hoàn thành hoặc thất bại
- **FR25**: Admin can xem conversion rate free→paid

#### Data & Connectivity (FR26-FR28)
- **FR26**: System hiển thị trạng thái kết nối (online/offline)
- **FR27**: System cảnh báo khi dữ liệu delay > 5 phút
- **FR28**: System cache market data, news, và Morning Brief cho offline access

#### Existing Capabilities Phase 1-2 (FR29-FR35)
- **FR29**: User can xem giá cổ phiếu realtime
- **FR30**: User can xem tin tức thị trường
- **FR31**: User can tạo và quản lý watchlist
- **FR32**: User can đặt price alerts
- **FR33**: User can xem biểu đồ TA (MACD, RSI, MA)
- **FR34**: User can xem phân tích FA (Piotroski, Altman Z, DuPont)
- **FR35**: User can chuyển đổi dark/light theme

### Non-Functional Requirements (19 total)

#### Performance (NFR1-NFR5)
- **NFR1**: Morning Brief cron job hoàn thành trong 30 phút (7h → 7h30)
- **NFR2**: Morning Brief screen load trong < 2 giây (warm cache)
- **NFR3**: Market data realtime (MQTT) delay < 3 giây so với source
- **NFR4**: Push notification gửi trong < 1 phút sau khi brief sẵn sàng
- **NFR5**: App cold start < 4 giây trên thiết bị mid-range

#### Security (NFR6-NFR10)
- **NFR6**: Claude API key lưu trên backend, không embed trong app binary
- **NFR7**: App ↔ backend communication qua HTTPS/TLS 1.2+
- **NFR8**: Payment qua Apple/Google IAP — app không lưu thông tin thanh toán
- **NFR9**: Admin dashboard yêu cầu authentication
- **NFR10**: API rate limiting: 100 requests/phút/user

#### Scalability (NFR11-NFR14)
- **NFR11**: Backend hỗ trợ 10,000 concurrent users đọc Morning Brief
- **NFR12**: Morning Brief là shared content (tạo 1 lần, serve tất cả)
- **NFR13**: Cache layer (CDN/edge cache) cho Morning Brief
- **NFR14**: Database feedback/accuracy hỗ trợ 1M+ records

#### Reliability (NFR15-NFR19)
- **NFR15**: Available ≥ 99% trong giờ giao dịch (9h-15h, T2-T6)
- **NFR16**: Morning Brief cron có retry — Claude API fail → retry 3 lần, exponential backoff
- **NFR17**: Morning Brief thất bại → hiển thị brief ngày trước kèm thông báo
- **NFR18**: MQTT auto-reconnect với exponential backoff (đã có Phase 2)
- **NFR19**: Crash rate < 1% sessions (Firebase Crashlytics)

### Additional Requirements

- **Compliance**: Luật Chứng khoán 2019, Nghị định 158/2020/NĐ-CP, ToS, disclaimer, tham vấn luật sư trước launch
- **Integration**: Claude API qua backend proxy, Vietstock RSS, SSI MQTT, VNDirect REST, FCM, IAP (StoreKit 2 / Google Play Billing)
- **Platform**: iOS 14+, Android 8.0+, Flutter, app size < 50MB
- **Offline**: Cache brief cuối cùng, watchlist, news, market data
- **Constraints**: Solo developer, unofficial APIs (không có SLA), Claude API cost management

### PRD Completeness Assessment

**Strengths:**
- FRs được đánh số rõ ràng, phân nhóm theo capability area (8 nhóm)
- NFRs có metric cụ thể và đo lường được (thời gian, %, số lượng)
- User journeys rõ ràng (3 journeys: happy path, edge case, admin)
- Risk matrix đầy đủ (10 risks) với xác suất, tác động, và giải pháp
- Phân tách rõ MVP vs Phase 2 vs Phase 3
- Compliance requirements chi tiết cho thị trường VN

**Gaps identified:**
- ⚠️ Thiếu Architecture document — không có chi tiết kiến trúc backend, data flow, API contracts
- ⚠️ Thiếu Epics/Stories — FRs chưa được phân tách thành epics và user stories có thể implement
- ⚠️ Thiếu UX Design — không có wireframes hoặc screen flows
- ⚠️ FR21-FR25 (Admin) chưa rõ admin dashboard là web hay mobile
- ⚠️ Chưa có API contracts/schema cho Morning Brief response format

## Epic Coverage Validation

### Status: ❌ NO EPICS/STORIES DOCUMENT FOUND

Không tìm thấy tài liệu Epics/Stories trong `docs/`. Không thể validate FR coverage.

### Coverage Matrix

| FR Group | FRs | Epic Coverage | Status |
|---|---|---|---|
| AI Morning Brief | FR1-FR6 | **NOT FOUND** | ❌ No Epic |
| Feedback & Accuracy | FR7-FR9 | **NOT FOUND** | ❌ No Epic |
| Free/Premium Gating | FR10-FR13 | **NOT FOUND** | ❌ No Epic |
| Notifications | FR14-FR16 | **NOT FOUND** | ❌ No Epic |
| Compliance & Disclaimer | FR17-FR20 | **NOT FOUND** | ❌ No Epic |
| Admin & Monitoring | FR21-FR25 | **NOT FOUND** | ❌ No Epic |
| Data & Connectivity | FR26-FR28 | **NOT FOUND** | ❌ No Epic |
| Existing Phase 1-2 | FR29-FR35 | N/A (already implemented) | ✅ Done |

### Coverage Statistics

- Total PRD FRs: 35
- FRs requiring new epics (Phase 3): 28 (FR1-FR28)
- FRs covered in epics: 0
- FRs already implemented (Phase 1-2): 7 (FR29-FR35)
- **Coverage percentage: 0%** (0/28 Phase 3 FRs have epics)

### Recommended Epic Structure

Based on PRD analysis, the following epics should be created:

1. **Epic 1: Backend Infrastructure** — Claude API proxy, cron job, caching (FR4, FR5, FR6, FR28, NFR1, NFR6, NFR11-13, NFR16-17)
2. **Epic 2: Morning Brief UI** — Brief screen, sector grouping, stock list (FR1, FR2, FR3, NFR2)
3. **Epic 3: Free/Premium Gating & IAP** — Tier limits, upgrade flow, IAP integration (FR10, FR11, FR12, FR13, NFR8)
4. **Epic 4: Feedback & Accuracy System** — User feedback, accuracy logging, comparison (FR7, FR8, FR9)
5. **Epic 5: Compliance & Safety** — Disclaimer, AI validation, ToS (FR17, FR18, FR19, FR20)
6. **Epic 6: Push Notifications** — FCM integration, notification settings (FR14, FR15)
7. **Epic 7: Data Resilience** — Offline mode, connectivity status, delay warnings (FR26, FR27, FR28)
8. **Epic 8: Admin Dashboard** — Cost monitoring, accuracy dashboard, prompt management (FR21, FR22, FR23, FR24, FR25, NFR9)

## UX Alignment Assessment

### UX Document Status: ❌ NOT FOUND

Không tìm thấy tài liệu UX/wireframes/screen flows trong `docs/`.

### UX Implied: ✅ YES (Critical)

FTrade là Flutter mobile app user-facing. PRD mentions nhiều UI components cần thiết kế:

| UI Component (từ PRD) | FR liên quan | UX cần thiết |
|---|---|---|
| Morning Brief screen | FR1, FR2, FR3 | Layout brief, sector cards, stock list |
| Sector grouping UI | FR2, FR3 | Card design, navigation, stock detail |
| Free/Premium gate UI | FR10, FR13 | Paywall screen, upgrade prompt |
| Feedback buttons | FR7 | "Chính xác / Không chính xác" UX |
| Disclaimer display | FR17 | Vị trí, style, khả năng dismiss |
| ToS consent flow | FR19 | First-time AI usage consent |
| Notification settings | FR15 | Toggle UI per notification type |
| Offline indicators | FR26 | Banner/badge "Offline" |
| Data delay warning | FR27 | Alert style khi delay > 5 phút |
| Admin dashboard | FR21-FR25 | Web hay mobile? Chưa rõ |

### Warnings

- ⚠️ **CRITICAL**: Mobile app không có wireframes hoặc screen flows → developer phải tự quyết UI/UX khi implement
- ⚠️ **Morning Brief screen** là core screen MVP nhưng chưa có mockup layout
- ⚠️ **Free→Premium upgrade flow** cần careful UX design để maximize conversion nhưng chưa được thiết kế
- ⚠️ **Admin dashboard** chưa xác định platform (web vs mobile) — ảnh hưởng lớn đến scope implementation
- ℹ️ Phase 1-2 đã có UI patterns (Riverpod + existing screens) có thể dùng làm base reference

## Epic Quality Review

### Status: ❌ NOT APPLICABLE — No Epics/Stories Document

Không thể thực hiện epic quality review vì chưa có tài liệu Epics/Stories.

### What Needs to Be Created

Khi tạo Epics/Stories, cần tuân thủ các best practices sau:

**Epic-level requirements:**
- Mỗi epic phải deliver **user value** (không phải technical milestone)
- Epics phải **independent** — Epic N không phụ thuộc Epic N+1
- Epics phải traceable về PRD FRs

**Story-level requirements:**
- Stories phải có **acceptance criteria** dạng Given/When/Then
- Stories phải **independently completable**
- Không có **forward dependencies** (story 1.2 không phụ thuộc story 1.4)
- Database/tables tạo **khi cần** (không tạo hết upfront)

**Brownfield-specific (FTrade):**
- Cần stories cho integration với existing Phase 1-2 code
- Cần migration/compatibility stories nếu thay đổi data model
- Tận dụng existing Riverpod providers, Hive boxes, MQTT infrastructure

## Summary and Recommendations

### Overall Readiness Status: 🟡 NEEDS WORK

PRD chất lượng tốt, nhưng **thiếu 3 tài liệu quan trọng** (Architecture, Epics/Stories, UX) để bắt đầu implementation một cách có hệ thống.

### Findings Summary

| Category | Status | Issues |
|---|---|---|
| PRD Quality | ✅ Strong | 35 FRs, 19 NFRs, 3 user journeys, 10 risks — đầy đủ và rõ ràng |
| Epic Coverage | ❌ Missing | 0/28 Phase 3 FRs có epics. Cần tạo mới hoàn toàn |
| UX Design | ❌ Missing | Mobile app không có wireframes/screen flows. MVP screen chưa thiết kế |
| Architecture | ❌ Missing | Không có tài liệu kiến trúc backend, data flow, API contracts |
| Epic Quality | N/A | Không thể review — chưa có epics |

### Critical Issues Requiring Immediate Action

1. **🔴 Thiếu Architecture Document** — Không rõ backend proxy (Firebase Functions vs Supabase Edge Functions), data flow Claude API → cache → app, API contracts cho Morning Brief response format. Developer không biết build cái gì trước.

2. **🔴 Thiếu Epics/Stories** — 28 FRs chưa được phân tách thành implementable stories. Solo developer cần roadmap rõ ràng để build MVP hiệu quả.

3. **🟠 Thiếu UX/Wireframes** — Morning Brief screen là core MVP nhưng chưa có mockup. Free→Premium upgrade flow cần careful UX design nhưng chưa được thiết kế.

4. **🟠 Admin Dashboard chưa rõ scope** — FR21-FR25 yêu cầu admin dashboard nhưng chưa xác định web hay mobile, MVP hay post-MVP.

5. **🟡 API contracts chưa defined** — Morning Brief response JSON schema, Claude system prompt structure, caching strategy chưa được document.

### Recommended Next Steps

Thứ tự ưu tiên:

1. **Tạo Architecture Document** — Xác định: backend stack (Firebase Functions vs Supabase), data flow, API contracts, deployment architecture, caching strategy. Đây là blocker lớn nhất.

2. **Tạo Epics & Stories** — Phân tách 28 FRs thành ~8 epics với user stories có acceptance criteria. Ưu tiên MVP scope (FR1-FR7, FR10-FR14, FR17-FR20, FR26-FR28).

3. **Tạo UX wireframes (lightweight)** — Ít nhất mockup cho: Morning Brief screen, sector detail, Free/Premium gate, feedback UI. Không cần high-fidelity — low-fi wireframes đủ cho solo developer.

4. **Clarify Admin scope** — Quyết định admin dashboard là: (a) Firebase Console + custom logging, (b) web dashboard riêng, hay (c) admin screens trong app. Ảnh hưởng lớn đến effort.

### What's Ready Now

- ✅ PRD hoàn chỉnh, FRs/NFRs rõ ràng, có thể dùng ngay để tạo architecture và epics
- ✅ Product Brief + Detail Pack cung cấp đầy đủ business context
- ✅ Phase 1-2 codebase stable (98 Dart files, 8 feature modules) — foundation vững
- ✅ Risk matrix đã identify và có mitigation plan cho 10 risks

### Final Note

Assessment này tìm thấy **5 issues** across **4 categories**. PRD là điểm mạnh lớn nhất — chất lượng cao, FRs đo lường được, compliance requirements chi tiết. Tuy nhiên, 3 tài liệu thiếu (Architecture, Epics, UX) là blockers cho implementation có hệ thống. Recommend tạo Architecture document trước (1-2 ngày), sau đó Epics/Stories (1 ngày), và lightweight wireframes song song.

---

*Assessment completed: 2026-03-29 by Implementation Readiness Checker*
