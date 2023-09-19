/// Annotation for repository generation
class DartGeneratorRepository<A, B> {
  ///
  const DartGeneratorRepository();
}

/// Annotation for repository function generation
class DartRepositoryFunction {
  ///
  const DartRepositoryFunction({
    required this.remote,
    required this.local,
    this.saveLocal,
  });

  /// remote function to fetch ressource
  final String remote;

  /// local function to fetch ressource
  final String local;

  /// local function to save remote ressource
  final String? saveLocal;
}
