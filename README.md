# ADRA Global UN Engagement Calendar


## Features
- Public meeting list on the landing page, month calendar, search and filters, default year 2027
- Create/edit events, UN agency, city/country, venue, meeting format, official URL, registration deadline, topic and description
- Nominate an ADRA representative, office and attendance status
- CSV export; UTC dates to avoid international ambiguity
- Responsive mobile/desktop UI and Supabase real-time updates

## 1. Create Supabase project
1. Go to https://supabase.com/dashboard and create a project.
2. Open **SQL Editor** and run all of `supabase/schema.sql`.
3. In **Project Settings > API**, copy the Project URL and public anon/publishable key.
5. For each staff user, copy their UUID from Authentication > Users. In SQL Editor run:

```sql
insert into public.staff_profiles (user_id,full_name,office,role)
values ('AUTH-USER-UUID','Staff Name','ADRA International','admin');
```


## 2. Configure locally

Requires Node.js 20 or later.

```bash
npm install
cp .env.example .env.local
npm run dev
```

Set `.env.local`:

- `NEXT_PUBLIC_SUPABASE_URL`: Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Supabase public/publishable key


## 3. GitHub and Vercel deployment
1. Create a new GitHub repository and upload these project files, **not** `.env.local` or `node_modules`.
2. On https://vercel.com, select **Add New > Project**, import the GitHub repository, framework **Next.js**.
4. Deploy. The homepage is public; `/login` is for staff.

## Security and operational notes
- All date/time inputs are interpreted as UTC. Coordinate timezone conversion for local meeting times.
- Realtime works when Supabase Realtime is enabled for `public.events`; otherwise users see changes after reloading.
- Before production use, implement organizational SSO if needed, audit logging, rate limiting, regular backups and privacy review.

## Test checklist
1. Visit the homepage while signed out: events visible, editing disabled.
3. Sign in with an authorized editor: create an event, nominate someone, change status.
4. Open another browser: new event visible publicly.
5. Test search, year, agency and status filters; month calendar; CSV export.
7. Verify an editor cannot delete; an admin can delete.

## Technical stack
