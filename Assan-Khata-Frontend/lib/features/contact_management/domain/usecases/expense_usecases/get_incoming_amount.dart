import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetIncomingAmount {
  final ExpenseRepository repository;

  GetIncomingAmount(this.repository);

  Future<Either<DataFailed, int>> call(GetIncomingAmountParams params) async {
    return await repository.getIncomingAmount(params.userId);
  }
}

class GetIncomingAmountParams {
  final String userId;

  GetIncomingAmountParams(this.userId);
}
