import 'dart:typed_data';

import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/client/client.dart';
import 'package:hiero_sdk_dart/src/query/transaction_get_receipt_query.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction_id.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction_receipt.dart';

class TransactionResponse {
  TransactionId transactionId = TransactionId();
  AccountId nodeId = AccountId();
  Uint8List hash = Uint8List(0);
  bool validateStatus = false;
  Transaction? transaction;

  TransactionGetReceiptQuery getReceiptQuery(bool validateStatus) {
    return (TransactionGetReceiptQuery()
                .setTransactionId(transactionId)
                .setNodeAccountId(nodeId)
            as TransactionGetReceiptQuery)
        .setValidateStatus(validateStatus);
  }

  Future<TransactionReceipt> getReceipt(
    Client client, {
    num? timeout,
    bool validateStatus = false,
  }) async {
    return await (getReceiptQuery(
      validateStatus,
    )).execute(client, timeout: timeout);
  }
}
