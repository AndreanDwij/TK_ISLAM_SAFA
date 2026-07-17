-- ============================================
-- SQL Migration untuk TK Islam Safa
-- Jalankan di Supabase SQL Editor
-- ============================================

-- 1. Tabel profiles (linked ke auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  role INTEGER NOT NULL DEFAULT 0,
  photo_url TEXT,
  child_id TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Tabel students
CREATE TABLE IF NOT EXISTS students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nis TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  gender TEXT NOT NULL,
  birth_date DATE NOT NULL,
  class_name TEXT NOT NULL,
  parent_name TEXT NOT NULL,
  parent_phone TEXT NOT NULL,
  photo_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Tabel assessments
CREATE TABLE IF NOT EXISTS assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT NOT NULL,
  aspect TEXT NOT NULL,
  score INTEGER NOT NULL,
  note TEXT NOT NULL DEFAULT '',
  photo_urls TEXT[] NOT NULL DEFAULT '{}',
  semester TEXT NOT NULL,
  teacher_id UUID NOT NULL REFERENCES profiles(id),
  teacher_name TEXT NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Tabel documentation
CREATE TABLE IF NOT EXISTS documentation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT NOT NULL,
  photo_url TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  date DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- Row Level Security (RLS)
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE documentation ENABLE ROW LEVEL SECURITY;

-- Profiles: user bisa baca semua profil, tapi hanya edit profil sendiri
CREATE POLICY "Profiles are viewable by authenticated users"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Students: semua authenticated user bisa CRUD
CREATE POLICY "Students are viewable by authenticated users"
  ON students FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert students"
  ON students FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update students"
  ON students FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete students"
  ON students FOR DELETE
  TO authenticated
  USING (true);

-- Assessments: semua authenticated user bisa CRUD
CREATE POLICY "Assessments are viewable by authenticated users"
  ON assessments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert assessments"
  ON assessments FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update assessments"
  ON assessments FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete assessments"
  ON assessments FOR DELETE
  TO authenticated
  USING (true);

-- Documentation: semua authenticated user bisa CRUD
CREATE POLICY "Documentation is viewable by authenticated users"
  ON documentation FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert documentation"
  ON documentation FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update documentation"
  ON documentation FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete documentation"
  ON documentation FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- Storage Bucket untuk foto
-- ============================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('photos', 'photos', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Authenticated users can upload photos"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'photos');

CREATE POLICY "Anyone can view photos"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'photos');

CREATE POLICY "Authenticated users can delete photos"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'photos');

-- ============================================
-- Trigger auto-create profile on signup
-- ============================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', ''),
    NEW.email,
    COALESCE((NEW.raw_user_meta_data->>'role')::INTEGER, 0)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- Indexes
-- ============================================

CREATE INDEX IF NOT EXISTS idx_students_class_name ON students(class_name);
CREATE INDEX IF NOT EXISTS idx_students_nis ON students(nis);
CREATE INDEX IF NOT EXISTS idx_assessments_student_id ON assessments(student_id);
CREATE INDEX IF NOT EXISTS idx_assessments_teacher_id ON assessments(teacher_id);
CREATE INDEX IF NOT EXISTS idx_assessments_semester ON assessments(semester);
CREATE INDEX IF NOT EXISTS idx_documentation_student_id ON documentation(student_id);

-- ============================================
-- Seed data (optional - untuk testing)
-- ============================================

-- Seed students
INSERT INTO students (id, nis, name, gender, birth_date, class_name, parent_name, parent_phone) VALUES
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', '2024001', 'Ahmad Rizki', 'Laki-laki', '2020-05-15', 'A', 'Pak Ahmad', '081234567890'),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', '2024002', 'Siti Nurhaliza', 'Perempuan', '2020-08-20', 'A', 'Pak Budi', '081234567891'),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', '2024003', 'Muhammad Fadil', 'Laki-laki', '2021-03-10', 'B', 'Pak Doni', '081234567892')
ON CONFLICT (nis) DO NOTHING;
