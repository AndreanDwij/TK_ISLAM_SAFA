class Validators {
  Validators._();

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  static String? nis(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIS wajib diisi';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    return null;
  }

  static String? score(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nilai wajib diisi';
    }
    final score = int.tryParse(value);
    if (score == null || score < 0 || score > 100) {
      return 'Nilai harus antara 0-100';
    }
    return null;
  }

  static bool isDuplicateNis(String nis, List<String> existingNisList) {
    return existingNisList.contains(nis);
  }
}
