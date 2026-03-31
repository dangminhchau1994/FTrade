---
stepsCompleted: [1, 2, 3, 4, 5, 6]
inputDocuments: ['docs/prd.md', 'docs/product-brief-ftrade.md', 'docs/product-brief-ftrade-distillate.md', 'docs/architecture.md', 'docs/epics.md']
---

# UX Design Specification FTrade

**Author:** Chau
**Date:** 2026-03-31

---

<!-- UX design content will be appended sequentially through collaborative workflow steps -->

## Executive Summary

### Tầm nhìn sản phẩm

FTrade là app phân tích chứng khoán Việt Nam tích hợp AI, nhắm đến NĐT cá nhân mới. Phase 3 UX tập trung vào AI Morning Brief — biến dữ liệu thị trường thành insight hành động bằng tiếng Việt dễ hiểu trong 2 phút mỗi sáng. Tagline UX: "Mở app, hiểu thị trường, tự tin ra quyết định."

### Người dùng mục tiêu

**Primary: NĐT mới (1-3 năm)**
- 25-35 tuổi, nhân viên văn phòng, đầu tư part-time
- Dùng smartphone chủ yếu (iOS/Android), đọc tin buổi sáng trước 9h
- Pain point: quá tải dữ liệu từ 3-5 app, thiếu context để ra quyết định
- Mong muốn: "Ai đó tóm tắt giúp tôi hôm nay cần chú ý gì"

**Secondary: Admin (Founder)**
- Monitor accuracy, cost, system prompt
- Dùng Firebase Console, không cần UI riêng cho MVP

### Thách thức thiết kế chính

1. Morning Brief phải scannable trong 2 phút — hierarchy rõ, không wall of text
2. Free/Premium gating tạo giá trị trước khi lock — "try before buy" UX
3. Disclaimer pháp lý bắt buộc nhưng không phá trải nghiệm đọc
4. Offline experience rõ ràng — phân biệt data cũ vs mới

### Cơ hội thiết kế

1. Tạo thói quen daily — Morning Brief = lý do mở app mỗi sáng
2. Flow liền mạch brief → sector → stock detail (leverage Phase 1-2 screens)
3. Feedback 1-tap tăng engagement và cải thiện AI quality

## Core User Experience

### Trải nghiệm cốt lõi

**Core Action:** Đọc Morning Brief mỗi sáng trước 9h.
User mở app → scan summary → tap sector quan tâm → xem mã đáng chú ý → tap vào mã → xem StockDetail. Toàn bộ flow < 2 phút.

**Core Loop hàng ngày:**
1. 7h30: Nhận push notification "Bản tin sáng đã sẵn sàng"
2. 7h45: Mở app → đọc summary (30 giây)
3. Tap sector quan tâm → xem phân tích + mã (60 giây)
4. Tap mã → StockDetail → quyết định có theo dõi không (30 giây)
5. Cuối phiên: đánh giá "Chính xác / Không chính xác" (5 giây)

### Chiến lược nền tảng

- **Mobile-first:** Flutter cross-platform (iOS 14+ / Android 8.0+)
- **Touch-optimized:** Tap to expand sector cards, swipe between sections
- **Offline-ready:** Cache brief cuối cùng, banner rõ ràng khi offline
- **Performance:** Brief screen load < 2 giây, app cold start < 4 giây
- **Existing screens:** Leverage StockDetail, News, Watchlist từ Phase 1-2

### Tương tác không cần suy nghĩ

1. **Mở app = thấy brief ngay** — không cần navigate, Morning Brief là landing screen hoặc tab nổi bật
2. **Tap sector = expand chi tiết** — accordion/card pattern, không chuyển screen
3. **Tap mã = đến StockDetail** — flow liền mạch, back button quay lại brief
4. **Feedback 1-tap** — "Chính xác ✓" / "Không chính xác ✗" ngay dưới mỗi sector
5. **Offline tự động** — không cần user làm gì, cache background, hiển thị data cũ khi mất mạng

### Khoảnh khắc quyết định thành bại

1. **"Aha moment":** Đọc brief sáng → cuối phiên thấy dự báo đúng → "App này nghĩ hộ mình thật" (Journey 1 - Minh)
2. **First-time success:** Lần đầu mở app → thấy brief tóm tắt rõ ràng → không cần mở CafeF/SSI nữa
3. **Upgrade trigger:** Free user thấy 1 nhóm ngành hay → muốn xem thêm nhưng bị lock → upgrade
4. **Trust builder:** Brief sai → user feedback → thấy accuracy rate minh bạch → vẫn tin tưởng app

### Nguyên tắc trải nghiệm

1. **"2 phút hoặc ít hơn"** — Mọi thông tin quan trọng phải accessible trong 2 phút đầu
2. **"Hiển thị, không giải thích"** — Dùng visual hierarchy, màu sắc, icon thay vì text dài
3. **"Giá trị trước, paywall sau"** — Free user phải thấy đủ giá trị 1 sector trước khi bị prompt upgrade
4. **"Tin cậy qua minh bạch"** — Luôn có disclaimer, timestamp, accuracy rate — không giấu giới hạn
5. **"Không có dead end"** — Mọi element đều tappable, mọi screen đều có action tiếp theo

## Desired Emotional Response

### Mục tiêu cảm xúc chính

**Primary:** "Tự tin & được hỗ trợ" — User cảm thấy có "cố vấn thông minh" bên cạnh, không phải tự mò mẫm một mình nữa.

**Secondary:**
- **Hiệu quả:** "2 phút là xong" — tiết kiệm 30 phút so với đọc 5 app
- **Tin tưởng:** "App này minh bạch" — disclaimer, accuracy rate, timestamp rõ ràng
- **Tò mò:** "Hôm nay có gì mới?" — tạo thói quen mở app mỗi sáng

**Cảm xúc cần tránh:**
- Hoang mang: "Quá nhiều thông tin, không biết bắt đầu từ đâu"
- Bị lừa: "App cho xem miễn phí rồi khóa hết" (paywall aggressive)
- Nghi ngờ: "AI bịa ra số liệu" (hallucination không kiểm soát)

### Emotional Journey Mapping

| Giai đoạn | Cảm xúc mong muốn | Thiết kế hỗ trợ |
|---|---|---|
| Lần đầu mở app | Tò mò + ấn tượng | Brief ngay lập tức, không onboarding dài |
| Đọc Morning Brief | Tự tin + "a-ha" | Hierarchy rõ, summary → detail, ngôn ngữ dễ hiểu |
| Tap sector bị lock (Free) | Tiếc nuối nhẹ, không frustrated | Thấy title + blur preview, biết giá trị bên trong |
| Dự báo đúng cuối phiên | Tự hào + tin tưởng | Feedback "Chính xác" → reinforcement message |
| Dự báo sai | Thông cảm, không mất niềm tin | Disclaimer + feedback mechanism + accuracy rate minh bạch |
| Offline | Bình tĩnh | Brief cũ hiển thị rõ ràng, banner "Cập nhật lúc..." |
| Quay lại ngày hôm sau | Mong đợi + thói quen | Push notification nhẹ nhàng, brief mới mỗi sáng |

### Micro-Emotions

- **Confidence > Confusion:** UI hierarchy rõ, không có menu ẩn, mọi thứ 1-2 tap
- **Trust > Skepticism:** Timestamp mọi data, disclaimer rõ, accuracy rate public
- **Accomplishment > Frustration:** Đọc xong brief = cảm giác "mình đã nắm được thị trường"
- **Delight > Indifference:** Dự báo đúng = micro-celebration (subtle animation/message)

### Design Implications

| Cảm xúc | Quyết định thiết kế |
|---|---|
| Tự tin | Typography lớn, hierarchy rõ, summary bold trước detail |
| Tin tưởng | Disclaimer không ẩn, timestamp visible, "AI phân tích" badge |
| Hiệu quả | Scannable cards, no scrolling walls, expand-on-tap |
| Tò mò (upgrade) | Blur + lock icon cho sector bị khóa, preview title vẫn visible |
| Bình tĩnh (offline) | Soft yellow banner, không popup alert, data cũ vẫn useful |

### Nguyên tắc thiết kế cảm xúc

1. **"Rõ ràng trước, đẹp sau"** — Thông tin phải dễ hiểu ngay lập tức, aesthetic là secondary
2. **"Không bao giờ để user đoán"** — Mọi trạng thái (loading, offline, error, locked) đều có visual indicator
3. **"Paywall = lời mời, không phải rào cản"** — Tone upgrade prompt là "Mở khóa thêm", không phải "Bạn không đủ quyền"
4. **"Sai thì nhận"** — Khi AI sai, thể hiện minh bạch thay vì giấu → tạo trust dài hạn

## UX Pattern Analysis & Inspiration

### Phân tích sản phẩm tham khảo

**1. SSI iBoard (đối thủ trực tiếp)**
- Mạnh: Data realtime nhanh, bảng giá compact, chart chuyên nghiệp
- Yếu: Quá tải thông tin, không có tóm tắt/insight, UX cho pro trader không phải NĐT mới
- Học được: Bảng giá compact layout, color coding chuẩn TTCK VN (tím/xanh/vàng/đỏ/xanh dương)

**2. Simplize**
- Mạnh: UI modern, FA/TA tích hợp, dark mode đẹp, onboarding ngắn
- Yếu: Nhiều tab/section, mất thời gian tìm thông tin, không có AI digest
- Học được: Card-based layout cho financial data, clean typography, bottom navigation

**3. Morning Brew (newsletter app — khác ngành nhưng cùng UX pattern)**
- Mạnh: Daily digest format scannable, tone casual dễ đọc, CTA rõ ràng
- Yếu: Không interactive, chỉ text
- Học được: **Digest format** (headline → 1 đoạn tóm tắt → "đọc thêm"), daily habit UX

**4. Robinhood (global fintech)**
- Mạnh: Onboarding frictionless, UI minimalist cho retail investor, stock detail clean
- Yếu: Quá đơn giản cho thị trường phức tạp
- Học được: **Progressive disclosure** — show summary trước, chi tiết khi tap. Paywall UX mượt.

### Transferable UX Patterns

**Navigation:**
- Bottom tab bar (Simplize style) — Morning Brief tab nổi bật nhất (first tab hoặc center)
- Pull-to-refresh cho Morning Brief

**Interaction:**
- **Expandable sector cards** (Morning Brew digest style) — title + 1 dòng summary → tap expand → full analysis + stock list
- **Tap stock chip → StockDetail** (SSI style) — stock chip trong sector card, tap = navigate
- **Blur + lock overlay** (Robinhood Premium style) — free user thấy content bị blur, lock icon + "Nâng cấp"

**Visual:**
- Color coding chuẩn TTCK VN (đã có Phase 1-2) — tím trần, xanh tăng, đỏ giảm, xanh dương sàn
- Card-based layout với rounded corners + subtle shadow (Simplize style)
- "AI phân tích" badge nhỏ trên mỗi sector card — tạo trust + differentiation

### Anti-Patterns cần tránh

1. **Wall of text** (CafeF style) — NĐT mới không đọc bài dài, cần scannable cards
2. **Tab hell** (SSI style) — quá nhiều tab/sub-tab, user mới bị lạc
3. **Aggressive paywall popup** — không popup full-screen "Mua Premium ngay!", chỉ inline blur + gentle prompt
4. **Onboarding carousel dài** — user muốn thấy brief ngay, không muốn swipe 5 slides "chào mừng"
5. **Hidden disclaimer** — đặt disclaimer footer nhỏ xíu → user không thấy → rủi ro pháp lý

### Chiến lược thiết kế

**Adopt (dùng nguyên):**
- Bottom tab navigation (Simplize) — đã có Phase 1-2
- Color coding TTCK VN (SSI) — đã có Phase 1-2
- Pull-to-refresh pattern

**Adapt (điều chỉnh):**
- Morning Brew digest format → thành expandable sector cards cho mobile
- Robinhood blur paywall → thêm "preview title" visible để tạo FOMO nhẹ
- Simplize card layout → thêm "AI badge" + feedback buttons

**Avoid (không dùng):**
- CafeF wall of text
- SSI multi-tab complexity
- Full-screen paywall popups
- Long onboarding flows
