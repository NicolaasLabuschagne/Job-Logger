# Job Logger

Time tracking and invoicing app with auto-generated invoices and job logs, Supabase-backed auth, and a safe public demo mode.

## Case Study

### 1. The Business Pain Point

Time tracking and invoicing ran entirely out of a single, fragile Excel workbook — 638+ rows deep, held together by absolute-cell formulas and a manual "Paid" flag to close out a pay period. Every invoice meant hand-copying totals into a separate sheet, and because the rate formula only ever pointed at the current hourly rate, historical invoices silently drifted from what was actually billed. Auditing it later turned up real damage: duplicate invoice numbers, stale dates carried over from the previous invoice, and a ~7.8-hour gap between what the sheet showed and what ten real invoices had actually billed across 15 months. None of it was usable outside a desktop copy of Excel.

### 2. The Engineered Solution

Replaced the spreadsheet with a single-page web app backed by a real authenticated database (Supabase/Postgres with Row Level Security), so time is logged once, hours are computed directly from start/end timestamps instead of copy-pasted formulas, and invoices generate themselves as a clean, single-line professional document — while a separate day-by-day Job Log stays available for any client who wants the detail. Rather than rebuild the spreadsheet's brittle mental model, the fix was structural: entries, clients, and invoices became real linked records instead of rows and cell references, so "what's owed" and "what's already been paid" can never drift apart again. A public demo mode (entirely fabricated data, RLS-enforced at the database level) lets the tool be shown off without ever exposing real client or financial data.

### 3. Measurable Impact (The ROI)

Reconstructed and reconciled 15+ months of real billing history — 126 logged sessions across 10 invoices spanning four rate changes (R120 → R350/hr) — catching a genuine 7.8-hour discrepancy the spreadsheet had silently accumulated. Invoice generation went from a multi-step manual edit-and-verify process to a single click, with hours calculated automatically and zero manual-formula risk going forward. The tool is now fully usable from a phone, where before it was desktop-Excel-only.

### 4. Tech Stack & Architecture

HTML5 / vanilla JavaScript (ES modules), Supabase (PostgreSQL, Auth, Row Level Security), static hosting on GitHub Pages, client-side PDF generation.
