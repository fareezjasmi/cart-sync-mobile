import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';

class FamilyPageModel {
  final bool isLoading;
  final FamilyModel? family;
  final List<FamilyRelationshipModel> members;
  final String? errorMessage;

  FamilyPageModel({
    this.isLoading = false,
    this.family,
    this.members = const [],
    this.errorMessage,
  });

  FamilyPageModel copyWith({
    bool? isLoading,
    FamilyModel? family,
    List<FamilyRelationshipModel>? members,
    String? errorMessage,
  }) {
    return FamilyPageModel(
      isLoading: isLoading ?? this.isLoading,
      family: family ?? this.family,
      members: members ?? this.members,
      errorMessage: errorMessage,
    );
  }
}

class FamilyPageInitial extends FamilyPageModel {
  FamilyPageInitial() : super();
}
