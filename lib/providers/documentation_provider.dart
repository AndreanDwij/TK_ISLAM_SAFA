import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/documentation.dart';
import '../utils/storage.dart';

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
    state = state.copyWith(isLoading: true);
    final documentation = await StorageService.getDocumentation();
    state = DocumentationState(documentations: documentation);
  }

  Future<void> addDocumentation(Documentation doc) async {
    final updated = [...state.documentations, doc];
    await StorageService.saveDocumentation(updated);
    state = state.copyWith(documentations: updated);
  }

  Future<void> deleteDocumentation(String id) async {
    final updated = state.documentations.where((d) => d.id != id).toList();
    await StorageService.saveDocumentation(updated);
    state = state.copyWith(documentations: updated);
  }

  List<Documentation> getByStudent(String studentId) {
    return state.documentations.where((d) => d.studentId == studentId).toList();
  }
}

final documentationProvider = StateNotifierProvider<DocumentationNotifier, DocumentationState>((ref) {
  return DocumentationNotifier();
});
