import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/hapi/services/response_code.pb.dart'
    as response_code_pb;
import 'package:hiero_sdk_dart/src/hapi/services/transaction_receipt.pb.dart'
    as transaction_receipt_pb;
import 'package:hiero_sdk_dart/src/transaction/transaction_id.dart';

class TransactionReceipt {
  transaction_receipt_pb.TransactionReceipt recieptProto;
  TransactionId? transactionId;
  List<TransactionReceipt>? children;
  List<TransactionReceipt>? duplicates;
  response_code_pb.ResponseCodeEnum status;

  TransactionReceipt(
    this.recieptProto,
    this.transactionId, {
    this.children = const [],
    this.duplicates = const [],
  }) : status = recieptProto.status;

  AccountId get accountId => AccountId.fromProto(recieptProto.accountID);

  factory TransactionReceipt.fromProto(
    transaction_receipt_pb.TransactionReceipt recieptProto,
    TransactionId? transactionId,
  ) {
    return TransactionReceipt(recieptProto, transactionId);
  }
}
