import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/repositories/session_repository_impl.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class UploadReceiptUsecase {
  final SessionRepository repository;
  UploadReceiptUsecase(this.repository);
  Future<Either<Failure, Map<String, dynamic>>> call(String sessionId, File receiptFile) =>
      repository.uploadReceipt(sessionId, receiptFile);
}

final uploadReceiptUsecaseProvider = Provider<UploadReceiptUsecase>((ref) {
  return UploadReceiptUsecase(ref.watch(sessionRepositoryProvider));
});
