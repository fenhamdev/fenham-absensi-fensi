import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Ganti dengan URL & Anon Key Supabase Project Anda
  static const String supabaseUrl = 'https://gpbspxcvasnpcggektes.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdwYnNweGN2YXNucGNnZ2VrdGVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY2NjY2MjMsImV4cCI6MjEwMjI0MjYyM30.ebr52g2ZCu47cxUP7LaTCg0Di7Qv9IkZPbeUDUPMn5o';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
