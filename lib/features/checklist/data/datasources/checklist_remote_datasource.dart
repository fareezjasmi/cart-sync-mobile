import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/checklist/data/models/update_checklist_name_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class ChecklistRemoteDatasource {
  Future<ChecklistModel> createChecklist(ChecklistModel checklist);
  // NOTE: Backend uses POST /checklist/{id} for GET (backend bug - should be GET)
  Future<ChecklistModel> getChecklist(String checklistId);
  Future<ChecklistModel> updateChecklistName(String checklistId, String name);
  Future<void> deleteChecklist(String checklistId);
}

class ChecklistRemoteDatasourceImpl implements ChecklistRemoteDatasource {
  final Dio dio;
  ChecklistRemoteDatasourceImpl(this.dio);

  @override
  Future<ChecklistModel> createChecklist(ChecklistModel checklist) async {
    try {
      final response = await dio.post('/checklist/create', data: checklist.toJson());
      return ChecklistModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<ChecklistModel> getChecklist(String checklistId) async {
    try {
      // Backend maps this as POST (not GET) - see ChecklistController line 34
      final response = await dio.post('/checklist/$checklistId');
      return ChecklistModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 404) throw ServerException(message: 'Checklist not found');
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<ChecklistModel> updateChecklistName(String checklistId, String name) async {
    try {
      final request = UpdateChecklistNameModel(checklistId: checklistId, checklistName: name);
      final response = await dio.post('/checklist/updateName', data: request.toJson());
      return ChecklistModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> deleteChecklist(String checklistId) async {
    try {
      await dio.delete('/checklist/delete/$checklistId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }
}

final checklistRemoteDatasourceProvider = Provider<ChecklistRemoteDatasource>((ref) {
  return ChecklistRemoteDatasourceImpl(ref.watch(dioProvider));
});
