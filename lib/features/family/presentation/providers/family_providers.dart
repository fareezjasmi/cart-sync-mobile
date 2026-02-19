import 'package:cartsync/features/family/domain/usecases/get_all_family_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/domain/usecases/add_family_member_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/create_family_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/get_family_members_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/get_family_usecase.dart';
import 'package:cartsync/features/family/presentation/models/family_page_model.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';

class FamilyNotifier extends StateNotifier<FamilyPageModel> {
  final Ref ref;
  final CreateFamilyUsecase createFamilyUsecase;
  final GetFamilyUsecase getFamilyUsecase;
  final AddFamilyMemberUsecase addFamilyMemberUsecase;
  final GetFamilyMembersUsecase getFamilyMembersUsecase;
  final GetAllFamilyUsecase getAllFamilyUsecase;

  FamilyNotifier(
    this.ref,
    this.createFamilyUsecase,
    this.getFamilyUsecase,
    this.addFamilyMemberUsecase,
    this.getFamilyMembersUsecase,
    this.getAllFamilyUsecase,
  ) : super(FamilyPageInitial());

  Future<bool> createFamily(String name, String adminId) async {
    state = state.copyWith(isLoading: true);
    final family = FamilyModel(adminId: adminId, name: name);
    final result = await createFamilyUsecase(family);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (f) async {
        if (f.familyId != null) {
          await ref.read(saveFamilyIdProvider.notifier).save(f.familyId!);
        }
        state = state.copyWith(isLoading: false, family: f);
        return true;
      },
    );
  }

  Future<void> loadFamily(String userId) async {
    state = state.copyWith(isLoading: true);
    final result = await getAllFamilyUsecase(userId);
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (families) => state = state.copyWith(isLoading: false, familyList: families),
    );
  }

  Future<void> loadMembers(String familyId) async {
    state = state.copyWith(isLoading: true);
    final result = await getFamilyMembersUsecase(familyId);
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (members) => state = state.copyWith(isLoading: false, members: members),
    );
  }

  Future<bool> addMember(String familyId, String userId) async {
    state = state.copyWith(isLoading: true);
    final result = await addFamilyMemberUsecase(familyId, userId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        loadMembers(familyId);
        return true;
      },
    );
  }
}

final familyNotifierProvider =
    StateNotifierProvider<FamilyNotifier, FamilyPageModel>((ref) {
  return FamilyNotifier(
    ref,
    ref.watch(createFamilyUsecaseProvider),
    ref.watch(getFamilyUsecaseProvider),
    ref.watch(addFamilyMemberUsecaseProvider),
    ref.watch(getFamilyMembersUsecaseProvider),
    ref.watch(GetAllFamilyUsecaseProvider),
  );
});
