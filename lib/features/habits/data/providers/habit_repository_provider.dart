import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vireo/features/habits/data/datasources/habit_local_data_source_impl.dart';
import 'package:vireo/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:vireo/features/habits/domain/repositories/i_habit_repository.dart';

part 'habit_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<IHabitRepository> habitRepository(HabitRepositoryRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final dataSource = HabitLocalDataSourceImpl(prefs);
  return HabitRepositoryImpl(dataSource);
}
