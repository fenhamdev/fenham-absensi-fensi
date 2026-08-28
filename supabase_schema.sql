-- ====================================================================
-- SKEMA DATABASE SUPABASE / POSTGRESQL UNTUK FENSI (FENHAM ABSENSI)
-- ====================================================================

-- GRANT PERMISSIONS UNTUK SCHEMA PUBLIC SUPABASE
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

-- 1. TABEL PROFILES (DAPAT TERINTEGRASI DENGAN SUPABASE AUTH)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT,
    role TEXT NOT NULL DEFAULT 'employee' CHECK (role IN ('employee', 'admin', 'hr')),
    department TEXT DEFAULT 'General',
    quota_cuti INT NOT NULL DEFAULT 12,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABEL COMPANIES (PENGATURAN KANTOR & GEOFENCING)
CREATE TABLE IF NOT EXISTS public.companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT NOT NULL DEFAULT 'PT. Fenham Indonesia Utama',
    address TEXT DEFAULT 'Jl. Pogung Raya No. 171 B, Pogung Kidul, Sinduadi, Mlati, Sleman, DI Yogyakarta',
    office_lat DOUBLE PRECISION NOT NULL DEFAULT -7.7542585,
    office_lng DOUBLE PRECISION NOT NULL DEFAULT 110.3762106,
    radius_meters DOUBLE PRECISION NOT NULL DEFAULT 150.0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABEL ATTENDANCES (PRESENSI MASUK & KELUAR)
CREATE TABLE IF NOT EXISTS public.attendances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    clock_in_time TIMESTAMPTZ DEFAULT NOW(),
    clock_out_time TIMESTAMPTZ,
    clock_in_lat DOUBLE PRECISION,
    clock_in_lng DOUBLE PRECISION,
    clock_out_lat DOUBLE PRECISION,
    clock_out_lng DOUBLE PRECISION,
    clock_in_photo TEXT,
    clock_out_photo TEXT,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'Hadir' CHECK (status IN ('Hadir', 'Terlambat', 'Izin', 'Sakit', 'Cuti')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABEL LEAVES (PENGAJUAN CUTI & IZIN)
CREATE TABLE IF NOT EXISTS public.leaves (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('Cuti Tahunan', 'Izin Sakit', 'Izin Khusus')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT NOT NULL,
    attachment_url TEXT,
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    approved_by UUID REFERENCES public.profiles(id),
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TABEL SCHEDULES (JADWAL SHIFT KARYAWAN)
CREATE TABLE IF NOT EXISTS public.schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    shift_name TEXT NOT NULL DEFAULT 'Regular Shift',
    start_time TEXT NOT NULL DEFAULT '08:00',
    end_time TEXT NOT NULL DEFAULT '17:00',
    date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. TABEL ANNOUNCEMENTS (PAPAN PENGUMUMAN)
CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- GRANT ALL PERMISSIONS TO TABLES
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role, anon, authenticated;

-- ====================================================================
-- SEED DATA AWAL UNTUK PERUSAHAAN (DEFAULT GEOFENCE KANTOR)
-- ====================================================================
INSERT INTO public.companies (company_name, address, office_lat, office_lng, radius_meters)
VALUES ('PT. Fenham Indonesia Utama', 'Jl. Pogung Raya No. 171 B, Pogung Kidul, Sinduadi, Mlati, Sleman, DI Yogyakarta', -7.7542585, 110.3762106, 150.0)
ON CONFLICT DO NOTHING;

-- ====================================================================
-- TRIGGER SUPABASE AUTH: OTOMATIS BUAT PROFILES SAAT USER SIGNUP
-- ====================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, email, role, quota_cuti)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email, 'Karyawan Fenham'),
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'role', 'employee'),
        12
    ) ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ====================================================================
-- TRIGGER UNTUK UPDATE AUTOMATIS QUOTA CUTI KARYAWAN SAAT APPROVED
-- ====================================================================
CREATE OR REPLACE FUNCTION public.handle_leave_approval()
RETURNS TRIGGER AS $$
DECLARE
    days_count INT;
BEGIN
    IF NEW.status = 'Approved' AND (OLD.status IS NULL OR OLD.status != 'Approved') AND NEW.type = 'Cuti Tahunan' THEN
        days_count := (NEW.end_date - NEW.start_date) + 1;
        UPDATE public.profiles
        SET quota_cuti = GREATEST(0, quota_cuti - days_count)
        WHERE id = NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_deduct_leave_quota ON public.leaves;
CREATE TRIGGER trigger_deduct_leave_quota
AFTER UPDATE ON public.leaves
FOR EACH ROW
EXECUTE FUNCTION public.handle_leave_approval();

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES & CLEANUP
-- ====================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendances ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaves ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

-- 1. Policies for PROFILES
DROP POLICY IF EXISTS "Public read profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Admins full access profiles" ON public.profiles;

CREATE POLICY "Public read profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins full access profiles" ON public.profiles FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);

-- 2. Policies for COMPANIES
DROP POLICY IF EXISTS "Anyone can view company settings" ON public.companies;
DROP POLICY IF EXISTS "Admins update company settings" ON public.companies;

CREATE POLICY "Anyone can view company settings" ON public.companies FOR SELECT USING (true);
CREATE POLICY "Admins update company settings" ON public.companies FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);

-- 3. Policies for ATTENDANCES
DROP POLICY IF EXISTS "Users view own attendances" ON public.attendances;
DROP POLICY IF EXISTS "Users insert own attendances" ON public.attendances;
DROP POLICY IF EXISTS "Users update own attendances" ON public.attendances;
DROP POLICY IF EXISTS "Admins full access attendances" ON public.attendances;

CREATE POLICY "Users view own attendances" ON public.attendances FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own attendances" ON public.attendances FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own attendances" ON public.attendances FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Admins full access attendances" ON public.attendances FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);

-- 4. Policies for LEAVES
DROP POLICY IF EXISTS "Users view own leaves" ON public.leaves;
DROP POLICY IF EXISTS "Users insert own leaves" ON public.leaves;
DROP POLICY IF EXISTS "Admins full access leaves" ON public.leaves;

CREATE POLICY "Users view own leaves" ON public.leaves FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own leaves" ON public.leaves FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins full access leaves" ON public.leaves FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);

-- 5. Policies for SCHEDULES
DROP POLICY IF EXISTS "Users view own schedules" ON public.schedules;
DROP POLICY IF EXISTS "Admins full access schedules" ON public.schedules;

CREATE POLICY "Users view own schedules" ON public.schedules FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins full access schedules" ON public.schedules FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);

-- 6. Policies for ANNOUNCEMENTS
DROP POLICY IF EXISTS "Everyone can read announcements" ON public.announcements;
DROP POLICY IF EXISTS "Admins full access announcements" ON public.announcements;

CREATE POLICY "Everyone can read announcements" ON public.announcements FOR SELECT USING (true);
CREATE POLICY "Admins full access announcements" ON public.announcements FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'hr'))
);
