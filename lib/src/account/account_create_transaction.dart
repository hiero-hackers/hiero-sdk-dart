import 'package:fixnum/fixnum.dart';
import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/channels.dart';
import 'package:hiero_sdk_dart/src/crypto/public_key.dart';
import 'package:hiero_sdk_dart/src/excecutable.dart';
import 'package:hiero_sdk_dart/src/hbar.dart';
import 'package:hiero_sdk_dart/src/transaction/transaction.dart';

import '../hapi/services/crypto_create.pb.dart' as crypto_create_pb;
import '../hapi/services/duration.pb.dart' as duration_pb;
import '../hapi/services/transaction.pb.dart' as transaction_pb;

class AccountCreateTransaction extends Transaction {
  PublicKey? key;
  Hbar initialBalance = Hbar(0);
  bool? receiverSignatureRequired;
  Duration autoRenewPeriod = const Duration(seconds: 7890000);
  String? accountMemo;
  int? maxAutomaticTokenAssociations = 0;
  //TODO: EvmAddress implementation
  AccountId? stakedAccountId;
  int? stakedNodeId;
  bool declineStakingReward = false;

  AccountCreateTransaction() {
    defaultTransactionFee = Hbar.fromTinybars(300000000);
  }

  AccountCreateTransaction setKey(PublicKey key) {
    requireNotFrozen();
    this.key = key;
    return this;
  }

  AccountCreateTransaction setInitialBalance(Hbar balance) {
    requireNotFrozen();
    initialBalance = balance;
    return this;
  }

  AccountCreateTransaction setReceiverSignatureRequired(bool required) {
    requireNotFrozen();
    receiverSignatureRequired = required;
    return this;
  }

  AccountCreateTransaction setAutoRenewPeriod(Duration period) {
    requireNotFrozen();
    autoRenewPeriod = period;
    return this;
  }

  AccountCreateTransaction setAccountMemo(String memo) {
    requireNotFrozen();
    accountMemo = memo;
    return this;
  }

  AccountCreateTransaction setMaxAutomaticTokenAssociations(int maxAssoc) {
    requireNotFrozen();
    if (maxAssoc < -1) {
      throw ArgumentError(
        "maxAutomaticTokenAssociations must be -1 (unlimited) or a non-negative integer.",
      );
    }
    maxAutomaticTokenAssociations = maxAssoc;
    return this;
  }

  AccountCreateTransaction setStakedAccountId(AccountId accountId) {
    requireNotFrozen();
    stakedAccountId = accountId;
    stakedNodeId = null;
    return this;
  }

  AccountCreateTransaction setStakedNodeId(int nodeId) {
    requireNotFrozen();
    stakedNodeId = nodeId;
    stakedAccountId = null;
    return this;
  }

  AccountCreateTransaction setDeclineStakingReward(bool decline) {
    requireNotFrozen();
    declineStakingReward = decline;
    return this;
  }

  Future<crypto_create_pb.CryptoCreateTransactionBody> _buildProtoBody() async {
    final protoBody = crypto_create_pb.CryptoCreateTransactionBody();

    if (key != null) {
      protoBody.key = await key!.toProtoKey();
    }

    protoBody.initialBalance = Int64(initialBalance.toTinybars().toInt());

    if (receiverSignatureRequired != null) {
      protoBody.receiverSigRequired = receiverSignatureRequired!;
    }

    protoBody.autoRenewPeriod = duration_pb.Duration(
      seconds: Int64(autoRenewPeriod.inSeconds),
    );

    if (accountMemo != null) {
      protoBody.memo = accountMemo!;
    }

    if (maxAutomaticTokenAssociations != null) {
      protoBody.maxAutomaticTokenAssociations = maxAutomaticTokenAssociations!;
    }

    protoBody.declineReward = declineStakingReward;

    if (stakedNodeId != null && stakedAccountId != null) {
      throw StateError(
        "Specify either stakedNodeId or stakedAccountId, not both.",
      );
    }

    if (stakedAccountId != null) {
      protoBody.stakedAccountId = stakedAccountId!.toProto();
    } else if (stakedNodeId != null) {
      protoBody.stakedNodeId = Int64(stakedNodeId!);
    }
    return protoBody;
  }

  @override
  Future<transaction_pb.TransactionBody> buildTransactionBody() async {
    final cryptoCreateBody = await _buildProtoBody();
    final transactionBody = buildBaseTransactionBody();
    transactionBody.cryptoCreateAccount = cryptoCreateBody;
    return transactionBody;
  }

  @override
  Method getMethod(Channel channel) {
    return Method(transaction: channel.crypto!.createAccount, query: null);
  }
}
