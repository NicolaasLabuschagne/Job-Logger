-- Job Logger schema: every table is owned by a single auth user (the app owner)
-- and locked down with RLS so only that authenticated user can read or write rows.
-- There is no anon/public policy on any of these tables — unauthenticated
-- visitors get zero access at the database level, not just a hidden UI.

create table if not exists public.settings (
  user_id uuid primary key references auth.users(id) on delete cascade default auth.uid(),
  name text not null default '',
  tagline text not null default '',
  address_lines jsonb not null default '[]'::jsonb,
  phone text not null default '',
  email text not null default '',
  bank jsonb not null default '{}'::jsonb,
  next_invoice_number integer not null default 1,
  updated_at timestamptz not null default now()
);

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  name text not null,
  contact_person text not null default '',
  address_lines jsonb not null default '[]'::jsonb,
  phone text not null default '',
  currency text not null default 'R',
  rate numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.invoices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  client_id uuid not null references public.clients(id) on delete cascade,
  number text not null,
  date date not null,
  rate numeric not null default 0,
  currency text not null default 'R',
  status text not null default 'unpaid' check (status in ('unpaid','paid')),
  created_at timestamptz not null default now()
);

create table if not exists public.entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  client_id uuid not null references public.clients(id) on delete cascade,
  invoice_id uuid references public.invoices(id) on delete set null,
  date date not null,
  start_time time not null,
  end_time time not null,
  category text not null default 'Coding',
  description text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists entries_user_idx on public.entries(user_id);
create index if not exists entries_client_idx on public.entries(client_id);
create index if not exists entries_invoice_idx on public.entries(invoice_id);
create index if not exists clients_user_idx on public.clients(user_id);
create index if not exists invoices_user_idx on public.invoices(user_id);

alter table public.settings enable row level security;
alter table public.clients enable row level security;
alter table public.invoices enable row level security;
alter table public.entries enable row level security;

create policy "owner full access" on public.settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner full access" on public.clients
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner full access" on public.invoices
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner full access" on public.entries
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
