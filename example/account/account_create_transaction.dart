import 'dart:io';

import 'package:grpc/grpc.dart' as grpc;
import 'package:hiero_sdk_dart/hiero_sdk_dart.dart';
import 'package:hiero_sdk_dart/src/account/account_create_transaction.dart';
import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/crypto/private_key.dart';
import 'package:hiero_sdk_dart/src/hbar.dart';
import 'package:hiero_sdk_dart/src/client/client.dart';
import 'package:hiero_sdk_dart/src/response_code.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction_receipt.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction_response.dart';

Future<void> createNewAccount(Client client) async {
  try {
    final newAccountPrivateKey = await PrivateKey.generateEd25519();
    final newAccountPublicKey = await newAccountPrivateKey.publicKey();

    final operatorKey = client.operatorPrivateKey;

    final transaction = AccountCreateTransaction()
        .setKey(newAccountPublicKey)
        .setInitialBalance(Hbar.fromTinybars(100000000))
        .setAccountMemo("My new account");

    print("Executing account create transaction...");

    await transaction.freezeWith(client);
    await transaction.sign(client.operatorPrivateKey!);

    final receipt = await transaction.execute(client, timeout: 20);

    if ((receipt as TransactionReceipt).status.value != ResponseCode.SUCCESS) {
      throw Exception("Transaction failed with status: ${receipt.status}");
    }

    final newAccountId = receipt.accountId;
    print("Account creation successful. New Account ID: $newAccountId");
    print(
      "   New Account Private Key: ${await newAccountPrivateKey.toStringEd25519Raw()}",
    );
    print(
      "   New Account Public Key: ${newAccountPublicKey.toStringEd25519()}",
    );
  } catch (e) {
    print("Account creation failed: $e");
    exit(1);
  }
}

Future<void> main() async {
  try {
    final client = await Client.fromEnv();
    await createNewAccount(client);
    client.close();
  } catch (e) {
    print("Failed to initialize or run client: $e");
    rethrow;
  }
}
