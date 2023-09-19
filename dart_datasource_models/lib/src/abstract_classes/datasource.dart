import 'package:dart_datasource_models/src/abstract_classes/environnement.dart';

/// Common datasource class
abstract class DatasourceAbstractClass {
  ///
  const DatasourceAbstractClass(this.environnement);

  /// environnement used by datasource
  final EnvironnementAbstractClass environnement;
}

/// Common remote datasource class
abstract class RemoteDatasourceAbstractClass extends DatasourceAbstractClass {
  ///
  const RemoteDatasourceAbstractClass(super.environnement);
}

/// Common local datasource class
abstract class LocalDatasourceAbstractClass extends DatasourceAbstractClass {
  ///
  const LocalDatasourceAbstractClass(super.environnement);
}
