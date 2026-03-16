-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor → New Query)

-- 1. Create the poll_votes table
create table if not exists poll_votes (
  id uuid default gen_random_uuid() primary key,
  poll_id text not null,
  option_index integer not null,
  voter_id text not null,
  created_at timestamptz default now()
);

-- 2. Add a unique constraint so each voter can only vote once per poll
alter table poll_votes
  add constraint unique_voter_per_poll unique (poll_id, voter_id);

-- 3. Enable Row Level Security
alter table poll_votes enable row level security;

-- 4. Allow anyone to insert votes (anon key)
create policy "Anyone can vote"
  on poll_votes for insert
  with check (true);

-- 5. Allow anyone to read votes (for live results)
create policy "Anyone can read votes"
  on poll_votes for select
  using (true);

-- 6. Enable Realtime on this table
alter publication supabase_realtime add table poll_votes;

-- Done! Your poll system is ready.
