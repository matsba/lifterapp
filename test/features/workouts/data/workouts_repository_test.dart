import 'package:flutter_test/flutter_test.dart';
import '../../../test_helpers/database_for_tests.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';

main() async {
  test('get training with id', () async {
    //ASSEMBLE
    final database = await DatabaseForTests().setup();
    final repo = WorkoutsRepository(db: database);

    //ARRANGE
    final result = await repo.getTraining(1);

    //ASSERT
    expect(result?.id, 1);
  });
}
