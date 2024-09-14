import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetOutgoingAmountAmount {
  final ExpenseRepository repository;

  GetOutgoingAmountAmount(this.repository);

  Future<Either<DataFailed, int>> call(
      GetOutgoingAmountAmountParams params) async {
    return await repository.getOutgoingAmount(params.userId);
  }
}

class GetOutgoingAmountAmountParams {
  final String userId;

  GetOutgoingAmountAmountParams(this.userId);
}
