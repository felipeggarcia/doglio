/// Metadados de paginação retornados pela API em listas (`meta`).
///
/// Usado para decidir se ainda há páginas a carregar (`hasMore`).
library;

class PageMeta {
  const PageMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final int currentPage;
  final int lastPage;
  final int total;

  /// Existe ao menos mais uma página depois da atual.
  bool get hasMore => currentPage < lastPage;

  /// Meta "vazia" — útil como estado inicial antes do primeiro carregamento.
  static const empty = PageMeta(currentPage: 1, lastPage: 1, total: 0);
}
