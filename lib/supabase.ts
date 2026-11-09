import { createClient } from '@supabase/supabase-js';
export const configured = Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
export const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://placeholder.supabase.co', process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'placeholder');
export type EventRecord = { id:string; title:string; agency:string; start_at:string; end_at:string|null; timezone:string; city:string; country:string; venue:string; format:string; theme:string; description:string; official_url:string; registration_deadline:string|null; status:string; attendance_status:string; representative_name:string; representative_office:string; representative_email:string; notes:string; source:string; created_at:string };
