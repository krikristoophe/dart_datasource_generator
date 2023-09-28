import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.ddgm.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoStatus {
  done,
  todo,
}

@DartGeneratorModel()
class Todo with _$Todo {
  const factory Todo({
    @DGMId() required int id,
    required String title,
    required String description,
    required TodoStatus status,
    @JsonKey(name: r'$createdAt') required DateTime? createdAt,
  }) = _Todo;
}
