# FTrade — Epic Implementation Progress

> Cập nhật: 2026-04-08 | DRY_RUN mode sẵn sàng test local emulator

## Epic 1: Nền tảng Backend & Auth — 🟡 80%
- ✅ Firebase packages (firebase_core, firebase_auth, cloud_firestore, google_sign_in)
- ✅ AppUser model + UserRepository (Firestore CRUD + stream)
- ✅ AuthService (anonymous, Google, email, link anonymous→real)
- ✅ Auto anonymous auth on app start
- ✅ ConnectivityBanner (offline detection)
- ✅ TosBottomSheet + MorningBriefScreen ToS guard
- ⬜ `flutterfire configure` (cần Firebase project)
- ⬜ GitHub Actions CI/CD deploy Functions
- ⬜ Device testing

## Epic 2: AI Morning Brief — 🟡 85%
- ✅ Backend Functions: types, claude-client, news-fetcher, generate-morning-brief, api-morning-briefs
- ✅ DRY_RUN mode (fake brief, zero API cost)
- ✅ TypeScript build clean ✅
- ✅ Flutter: MorningBrief model, datasource (Hive cache 7d), provider
- ✅ UI: AiSummaryHeroCard, SectorCard, MorningBriefScreen (Direction 6)
- ⬜ `firebase deploy --only functions` (cần OPENAI_API_KEY / CLAUDE_API_KEY)
- ⬜ Production testing

## Epic 3: Feedback & Accuracy — ✅ 100%
- ✅ Backend: `types.ts` — FeedbackEntry, AccuracyLog, AccuracySummary interfaces
- ✅ Backend: `api-feedback.ts` — POST submit + GET retrieve (per user, per brief date)
- ✅ Backend: `accuracy-tracker.ts` — Cron 15:30 VN, proxy symbols per sector, VNDirect EOD
- ✅ Backend: `api-accuracy.ts` — GET accuracy summary (by sector, weekly trend)
- ✅ Flutter: Datasource — submitFeedback() + getFeedbacksForBrief() + Hive offline cache
- ✅ Flutter: FeedbackNotifier provider (StateNotifier.family per briefDate)
- ✅ Flutter: SectorCard — initialFeedback persistence, didUpdateWidget restore
- ✅ Flutter: MorningBriefScreen — wired feedbackProvider, replaced TODO stub
- ✅ TypeScript build clean ✅ | Flutter analyze clean ✅

## Epic 4: Push Notifications — ⬜ 0%
- ⬜ FCM integration
- ⬜ Morning brief push notification

## Epic 5: Premium & IAP — ⬜ 0%
- ⬜ Paywall UI + blur locked sectors
- ⬜ In-app purchase integration

## Epic 6: FA Dashboard — 🟡 50%
- ✅ FaAnalysis entity (Piotroski, Altman Z, DuPont, Growth, Valuation, Risk)
- ✅ FaCalculator (pure static, isolate-safe)
- ✅ FaAnalysisDatasource (cache 6h + compute isolate)
- ⬜ FaDashboardScreen UI
- ⬜ Route `/fa/:symbol` + wire vào StockDetailScreen

## Bước tiếp theo
1. Test local: `cd functions && firebase emulators:start --only functions`
2. Trigger: `curl -X POST http://127.0.0.1:5001/ftrade-209d5/asia-southeast1/triggerMorningBrief`
3. Khi sẵn sàng production: đổi `DRY_RUN=false` + set `OPENAI_API_KEY` trong `.env`
