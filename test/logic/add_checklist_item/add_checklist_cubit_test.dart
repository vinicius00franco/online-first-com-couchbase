import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/logic/add_checklist_item/add_checklist_cubit.dart';
import 'package:checklist/app/logic/add_checklist_item/add_checklist_state.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:checklist/app/utils/uuid_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockChecklistRepository extends Mock implements ChecklistRepository {}

class MockUuidHelper extends Mock implements UuidHelper {}

void main() {
  late AddChecklistCubit cubit;
  late MockChecklistRepository mockRepository;
  late MockUuidHelper mockUuidHelper;

  setUpAll(() {
    registerFallbackValue(ShoppingItemEntity(
      uuid: 'fallback-uuid',
      userId: 'fallback-user',
      title: 'Fallback Item',
      isCompleted: false,
      price: 0.0,
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockRepository = MockChecklistRepository();
    mockUuidHelper = MockUuidHelper();
    cubit = AddChecklistCubit(mockRepository, mockUuidHelper);
  });

  tearDown(() {
    cubit.close();
  });

  group('AddChecklistCubit', () {
    const userId = 'user123';
    const generatedUuid = 'generated-uuid';

    blocTest<AddChecklistCubit, AddChecklistState>(
      'emits [AddChecklistSuccess] when addItem succeeds',
      build: () => cubit,
      setUp: () {
        when(() => mockUuidHelper.generate()).thenReturn(generatedUuid);
        when(() => mockRepository.addItem(any()))
            .thenAnswer((_) async => 'doc-id');
      },
      act: (cubit) => cubit.addItem(
        userId: userId,
        title: 'Test Item',
        price: 15.0,
      ),
      expect: () => [
        isA<AddChecklistSuccess>(),
      ],
      verify: (_) {
        verify(() => mockUuidHelper.generate()).called(1);
        verify(() => mockRepository.addItem(any())).called(1);
      },
    );

    blocTest<AddChecklistCubit, AddChecklistState>(
      'emits [AddChecklistError] when addItem fails',
      build: () => cubit,
      setUp: () {
        when(() => mockUuidHelper.generate()).thenReturn(generatedUuid);
        when(() => mockRepository.addItem(any()))
            .thenThrow(Exception('Database error'));
      },
      act: (cubit) => cubit.addItem(
        userId: userId,
        title: 'Test Item',
        price: 15.0,
      ),
      expect: () => [
        isA<AddChecklistError>(),
      ],
      verify: (_) {
        verify(() => mockUuidHelper.generate()).called(1);
        verify(() => mockRepository.addItem(any())).called(1);
      },
    );
  });
}
