import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/documentation.dart';
import '../services/supabase_service.dart';

class DocumentationState {
  final List<Documentation> documentations;
  final bool isLoading;
  final String? error;

  DocumentationState({
    this.documentations = const [],
    this.isLoading = false,
    this.error,
  });

  DocumentationState copyWith({
    List<Documentation>? documentations,
    bool? isLoading,
    String? error,
  }) {
    return DocumentationState(
      documentations: documentations ?? this.documentations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DocumentationNotifier extends StateNotifier<DocumentationState> {
  DocumentationNotifier() : super(DocumentationState()) {
    loadDocumentation();
  }

  Future<void> loadDocumentation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final documentation = await SupabaseService.getDocumentation();
      state = DocumentationState(documentations: documentation);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat dokumentasi');
    }
  }

  Future<void> addDocumentation(Documentation doc) async {
    try {
      final newDoc = await SupabaseService.addDocumentation(doc);
      state = state.copyWith(documentations: [newDoc, ...state.documentations]);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menambah dokumentasi');
    }
  }

  Future<void> deleteDocumentation(String id) async {
    try {
      await SupabaseService.deleteDocumentation(id);
      final updated = state.documentations.where((d) => d.id != id).toList();
      state = state.copyWith(documentations: updated);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus dokumentasi');
    }
  }

  List<Documentation> getByStudent(String studentId) {
    return state.documentations.where((d) => d.studentId == studentId).toList();
  }
}

final documentationProvider = StateNotifierProvider<DocumentationNotifier, DocumentationState>((ref) {
  return DocumentationNotifier();
});
