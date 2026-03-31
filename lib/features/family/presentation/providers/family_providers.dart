import 'package:cartsync/features/family/domain/usecases/delete_family_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/generate_invite_code_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/get_all_family_usecase.dart';
import 'package:cartsync/features/family/domain/usecases/join_family_usecase.dart';
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
  final GenerateInviteCodeUsecase generateInviteCodeUsecase;
  final JoinFamilyUsecase joinFamilyUsecase;
  final DeleteFamilyUsecase deleteFamilyUsecase;

  FamilyNotifier(
    this.ref,
    this.createFamilyUsecase,
    this.getFamilyUsecase,
    this.addFamilyMemberUsecase,
    this.getFamilyMembersUsecase,
    this.getAllFamilyUsecase,
    this.generateInviteCodeUsecase,
    this.joinFamilyUsecase,
    this.deleteFamilyUsecase,
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
    result.fold((failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage), (families) {
      final updatedFamilies = families.map((e) => e.copyWith(isAdmin: e.adminId == userId)).toList();
      state = state.copyWith(isLoading: false, familyList: updatedFamilies);
    });
  }

  Future<void> loadMembers(String familyId) async {
    state = state.copyWith(isLoading: true);
    final result = await getFamilyMembersUsecase(familyId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
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

  Future<FamilyModel?> generateInviteCode(String familyId) async {
    state = state.copyWith(isLoading: true);
    final result = await generateInviteCodeUsecase(familyId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return null;
      },
      (updatedFamily) {
        state = state.copyWith(isLoading: false, family: updatedFamily);
        return updatedFamily;
      },
    );
  }

  Future<bool> joinFamily(String inviteCode, String userId) async {
    state = state.copyWith(isLoading: true);
    final result = await joinFamilyUsecase(inviteCode, userId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<bool> deleteFamily(String familyId) async {
    state = state.copyWith(isLoading: true);
    final result = await deleteFamilyUsecase(familyId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        final updated = (state.familyList ?? []).where((f) => f.familyId != familyId).toList();
        state = state.copyWith(isLoading: false, familyList: updated);
        return true;
      },
    );
  }
}

final familyNotifierProvider = StateNotifierProvider<FamilyNotifier, FamilyPageModel>((ref) {
  return FamilyNotifier(
    ref,
    ref.watch(createFamilyUsecaseProvider),
    ref.watch(getFamilyUsecaseProvider),
    ref.watch(addFamilyMemberUsecaseProvider),
    ref.watch(getFamilyMembersUsecaseProvider),
    ref.watch(GetAllFamilyUsecaseProvider),
    ref.watch(generateInviteCodeUsecaseProvider),
    ref.watch(joinFamilyUsecaseProvider),
    ref.watch(deleteFamilyUsecaseProvider),
  );
});
