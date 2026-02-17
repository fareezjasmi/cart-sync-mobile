import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/data/models/family_relationship_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class FamilyRemoteDatasource {
  Future<FamilyModel> createFamily(FamilyModel family);
  Future<FamilyModel> getFamily(String familyId);
  Future<FamilyRelationshipModel> addMember(String familyId, String userId);
  // NOTE: GET /family/{id} and GET /family/{familyId} are the same path in the backend.
  // This call uses the same endpoint but expects a List response.
  Future<List<FamilyRelationshipModel>> getFamilyMembers(String familyId);
}

class FamilyRemoteDatasourceImpl implements FamilyRemoteDatasource {
  final Dio dio;
  FamilyRemoteDatasourceImpl(this.dio);

  @override
  Future<FamilyModel> createFamily(FamilyModel family) async {
    try {
      final response = await dio.post('/family/create', data: family.toJson());
      return FamilyModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<FamilyModel> getFamily(String familyId) async {
    try {
      final response = await dio.get('/family/$familyId');
      return FamilyModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 404) throw ServerException(message: 'Family not found');
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<FamilyRelationshipModel> addMember(String familyId, String userId) async {
    try {
      final response = await dio.post('/family/addMember', data: {
        'family_id': familyId,
        'user_id': userId,
      });
      return FamilyRelationshipModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<List<FamilyRelationshipModel>> getFamilyMembers(String familyId) async {
    try {
      final response = await dio.get('/family/$familyId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => FamilyRelationshipModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }
}

final familyRemoteDatasourceProvider = Provider<FamilyRemoteDatasource>((ref) {
  return FamilyRemoteDatasourceImpl(ref.watch(dioProvider));
});
