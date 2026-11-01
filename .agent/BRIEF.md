# BRIEF.md — what the owner wants (their words first)

> Owner: Moamen. Writes Arabic; phone-only (no computer); wants short, honest, structured reports; hates false "done" claims.
> Sections 1 and 2 below are **verbatim copies** (unedited) of the two owner documents. Do not summarize or "fix" them here.

## 2026-11-01 — (3) Owner's second message, verbatim (`to sonnet 2 mullky.md`) — NEWEST, narrows the MVP

دائما اقع ف نفس الخطأ ألجأ لاحدهم ليكتب المطالبة بالإنجليزية ويقوم بالهلوسة.
بص انا وجدت ان المشروع أوسع من اللازم لذلك قررت ان اجعل ال mvp الاول بسيط ثم بعد التأسيس ننظر في phase 2, 3

الحلقة الأساسية الوحيدة اللي بتعمل فلوس: العميل → الوحدة → طلب صيانة/تنظيف → صور قبل/بعد → حالة → فاتورة. أي حاجة بره دي = مرحلة تانية.
 
اللي تقطعه دلوقتي (Phase 2+)
الحاجة ليه بنقطعها
موقع إلكتروني + داش بورد ❌ 
عمل أدمن داخل التطبيق بنفسه (فلان  is_admin ) — كفاية لحد ما يزيد العملاء 
API مكتوب يدوياً + سيرفر ❌ 
استخدم Supabase (Postgres + Auth + Storage للصور + Realtime) — مجاني، من غير كود سيرفر، تظبطه من المتصفح على الموبايل 
*قاعدة بيانات المدينة (صيدليات/عيادات/مطاعم) تشتيت — الدليل المحلي مش بيعمل فلوس.❌ Phase 3 
*المساعد الذكي + الاشتراكات❌ Phase 2 
العمال + الصناعي + عملاء متعددين بعمق ❌ 
خلّي العميل = صاحب العقار، والوحدة = الفيلا/الشاليه. العمال = Phase 2 
دفع أونلاين ❌ 
سجّل الفاتورة وحدّدها مدفوعة/غير مدفوعة فقط 
 
اللي تبقي (MVP — 5 شاشات بس)
 
1. تسجيل دخول (Supabase Auth)
​
2. الرئيسية: قائمة الوحدات (فيلا/شاليه + صورة + حالة: شاغرة/مؤجرة)
​
3. تفاصيل الوحدة: سجل كل الطلبات + الصور + الفواتير
​
4. طلب خدمة: نوع (تنظيف/صيانة/فحص/مكافحة) + ملاحظات + صور → حالة (قيد الانتظار/جاري/مكتمل)
​
5. أدمن (داخل التطبيق): كل الطلبات، تغيير الحالة، إضافة فاتورة
 
التخزين:  محلي (offline) اما sync لـ Supabase. الصور → Supabase Storage فخليها phase 2

الان الصورة تقريبا واضحة، انا عملت التطبيق ولقيته كبير عليا مرة واحدة فقررت اقسمه علي مراحل، ولن استعين بأحد للترجمة مني إليك سأتعامل باللغة البيضاء البسيطة معك مباشرة.
لا داعي لفحص كافة مشروع manger assistant ready, بالكامل لديك بالفعل هيكلية فولدر. agent, خد ما تحتاجه فقط لانشاء اول apk, وانشأ ملفات. agent علي نفس النمط مع تطوير البريف وفقا لما فهمته

**Engineering reading of (3) (mine, not the owner's):**
- MVP is cut to 5 screens: login, home (units), unit detail (history + invoices), service request, in-app admin. The only money-making loop: client -> unit -> request -> before/after photos -> status -> invoice.
- Cut: website + dashboard, hand-written API/server (Supabase only), city database, AI assistant + subscriptions (Phase 2), local guide (Phase 3), workers/industrial/multi-client, online payment (invoice = paid/unpaid only).
- Storage: local offline first, then sync to Supabase. "Photos -> Supabase Storage: make it Phase 2" = my reading: photos are picked/kept LOCALLY in the MVP; uploading them to Supabase Storage is Phase 2. (Open decision in DECISIONS.md.)
- Working style: the owner talks to me directly in plain Arabic, no English prompt-writing by other models; do NOT inspect all of manager-assistant-ready, take only what is needed for the first APK; .agent/ in the same pattern.
- Chat instructions: "ثبت flutter, و CI, ال ID mullky" -> pin Flutter, CI, application id `mullky`.

## 2026-11-01 — (1) Owner's brief, verbatim (`Brief 1 mulkcare .md`)

# BRIEF — MulkCare (owner's brief)

## What MulkCare is
Property-care app for vacation-home owners in Hurghada, Egypt (villas / chalets)
who live abroad or in another city. Owners follow their properties, request
services (cleaning, maintenance, inspection, pest control), see photo inspection
reports, review expenses/invoices, and talk to the care team. Arabic (RTL) is the
primary language. The owner works from a phone only — no computer.

## Current state (this repo)
- React 18 + Vite 5 + Tailwind web prototype exported from Accio. Sample data
  only, localStorage, no live backend.
- DESIGN.md is the NORMATIVE design source of truth: colours, type scale, radii,
  spacing, component specs. Tajawal self-hosted font. Primary #084A6F, secondary
  #00A3A3, accent #F4B400. Phone-first, Arabic RTL default.
- 9 web screens exist. README documents entities and a Supabase migration path.

## Target
- Flutter Android app (APK), built CI-only through GitHub Actions (no local
  Flutter SDK in the sandbox). SAME design system — DO NOT redesign.
- Backend: Supabase (Auth + Postgres + Storage for photos + Row Level Security).
  Offline-first: SQLite local cache with sync.
- Reference for .agent/ discipline + CI workflow:
  moamenessamseja-web/manager-assistant-ready, commit d2a17efe.

## MVP scope (build only this; everything else = Phase 2)
KEEP:
1. Auth (sign in / register) via Supabase
2. Home: property list (villa/chalet + photo + status: vacant/rented)
3. Property detail: full history of service requests + photos + invoices
4. Service request: type (cleaning / maintenance / inspection / pest control)
   + notes + photos before/after + status (pending → in-progress → done)
5. Invoices: simple (amount, paid/unpaid) — NO online payment
6. Admin role inside the same app (is_admin flag): view all requests, change
   status, add invoice. NO separate website/dashboard.

CUT (Phase 2+, do NOT build now):
- Local city guide (/local), AI assistant (/assistant), subscriptions/payments,
  push notifications delivery, PDF export, maps/places, workers/technicians
  management, industrial clients, English UI (Arabic first only).

## Non-negotiables (owner gates)
- Never merge to main, change application id, signing, or Play config without
  the owner's explicit say-so.
- Never put secrets (Supabase service-role key, AI keys) in the repo or client.
- Preserve DESIGN.md exactly — colours, typography, layout, RTL. Migration, not
  redesign.
- Report honestly: CI green ≠ works on device. Say what was NOT verified.
- Update .agent/ (HANDOFF, STATE, CHANGELOG) after every green build.

## 2026-11-01 — (2) Task prompt, verbatim (`to sonnet mulk.md`)

You are migrating the MulkCare repo (moamenessamseja-web/mulkcare) from a
React/Vite web prototype (Accio export) to a Flutter Android app. Work CI-only
(GitHub Actions builds the APK; there is no local Flutter SDK in the sandbox).
At start, call skill("engineer-in-charge") and skill("flutter-ci-engineering")
and follow them.

What you are looking at:
- React 18 + Vite 5 + Tailwind web app, 9 screens, sample data, localStorage,
  no live backend.
- DESIGN.md is the NORMATIVE design source of truth (colours, type, radii,
  spacing, components, Tajawal font, Arabic RTL default, phone-first).
  PRESERVE THE DESIGN EXACTLY — this is a migration, NOT a redesign. Do not
  change colours, typography, layout direction, or component shape.
- README documents the data entities and a Supabase migration path. Use it.

Your task:
1. Create the .agent/ folder following the pattern in
   moamenessamseja-web/manager-assistant-ready commit d2a17efe (inspect it and
   its .agent/ folder as reference): BRIEF.md, IMPLEMENTATION_STATE.md,
   HANDOFF.md, CHANGELOG.md, ENGINEERING_RULES.md, implementation.md,
   DECISIONS.md. Record baseline SHA, MVP scope, frozen decisions.
2. Scaffold the Flutter project (offline-first Arabic RTL). Implement the MVP
   scope from BRIEF.md: auth, home (properties), property detail with history,
   service request with photos + status workflow, simple invoices, in-app admin.
   Backend: Supabase (Auth + Postgres + Storage + RLS); local SQLite cache with
   sync. Cut everything listed as Phase 2 in BRIEF.md.
3. Set up GitHub Actions CI (flutter analyze + flutter test + build APK, like
   manager-assistant-ready) and pin the Flutter version. First goal: one green
   build producing an APK.
4. Rewrite README.md to describe the Flutter app (not React). Keep DESIGN.md as
   the design authority.
5. Work on a feature branch; do NOT merge to main. Do not change application
   id/signing. Do not put any secret in the repo. Report honestly what was
   verified (CI only) and what was not (device test). Update .agent/ docs before
   finishing.

Reference for .agent/ + CI pattern:
https://github.com/moamenessamseja-web/manager-assistant-ready/commit/d2a17efe50efb9c715525433aaca44ad8e3e700d
— inspect it and its .agent/ folder, then apply the same discipline here.

## Engineering reading (mine, not the owner's)
- Goal: migrate the React/Vite/Tailwind Accio prototype to a Flutter Android app (APK) with Supabase backend and offline-first SQLite cache. Migration, not redesign: DESIGN.md is normative.
- Hard constraints (stated by the owner): never merge to main; never touch application id / signing / Play config; no secrets in repo or client; preserve DESIGN.md exactly; CI-only builds; report honestly (CI green != works on device); update .agent/ after every green build.
- Priorities in order: 1) .agent/ bootstrap with baseline SHA, MVP scope, frozen decisions; 2) Flutter scaffold + first green CI build producing an APK; 3) MVP features (auth, home, property detail, service request, invoices, in-app admin); 4) README rewrite for Flutter.
- Explicitly NOT now (Phase 2): city guide, AI assistant, subscriptions/payments, push delivery, PDF export, maps/places, workers management, industrial clients, English UI.

## Owner profile and working style
- Language / tone: Arabic; direct, analytical; accepts being corrected; prefers admitting error over justification.
- Technical level: architect by training, not a programmer; explain consequential decisions in plain words.
- Pet peeves: false "done" claims, re-explaining, jumping to simplified solutions that miss the deeper point.
