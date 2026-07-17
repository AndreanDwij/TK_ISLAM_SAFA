import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL']!;
  static String get publishableKey => dotenv.env['SUPABASE_ANON_KEY']!;

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
