-- Invoices show one summarized line item (e.g. "Software Services") rather
-- than a day-by-day breakdown — that detail lives in the separate Job Log
-- document instead. This column stores the text billed on that single line.
alter table public.invoices
  add column if not exists description text not null default 'Software Services';
