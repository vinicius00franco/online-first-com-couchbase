import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:checklist/app/logic/checklist/checklist_state.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockChecklistRepository extends Mock implements ChecklistRepository {}

void main() {
  late FetchChecklistCubit cubit;
  late MockChecklistRepository mockRepository;

  setUp(() {
    mockRepository = MockChecklistRepository();
    cubit = FetchChecklistCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('FetchChecklistCubit', () {
    const userId = 'user123';

    blocTest<FetchChecklistCubit, FetchChecklistState>(
      'emits [FetchChecklistLoaded] when fetchItems succeeds',
      build: () => cubit,
      setUp: () {
        final items = [
          ShoppingItemEntity(
            uuid: 'uuid1',
            userId: userId,
            title: 'Item 1',
            isCompleted: false,
            price: 10.0,
            createdAt: DateTime.now(),
          ),
        ];
        when(() => mockRepository.fetchAll(userId: userId))
            .thenAnswer((_) async => items);
      },
      act: (cubit) => cubit.fetchItems(userId: userId),
      expect: () => [
        isA<FetchChecklistLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.fetchAll(userId: userId)).called(1);
      },
    );

    blocTest<FetchChecklistCubit, FetchChecklistState>(
      'emits [FetchChecklistError] when fetchItems fails',
      build: () => cubit,
      setUp: () {
        when(() => mockRepository.fetchAll(userId: userId))
            .thenThrow(Exception('Database error'));
      },
      act: (cubit) => cubit.fetchItems(userId: userId),
      expect: () => [
        isA<FetchChecklistError>(),
      ],
      verify: (_) {
        verify(() => mockRepository.fetchAll(userId: userId)).called(1);
      },
    );
  });
}
