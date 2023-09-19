import 'package:dart_datasource_models/src/abstract_classes/environnement.dart';

/// Common repository class
abstract class RepositoryAbstractClass<RemoteDsType, LocalDsType> {
  ///
  const RepositoryAbstractClass({
    required this.remote,
    required this.local,
    required this.environnement,
  });

  /// Environnement provided to datasources
  final EnvironnementAbstractClass environnement;

  /// remote datasource
  final RemoteDsType remote;

  /// local datasource
  final LocalDsType local;
}
