import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/hapi/services/state/token/account.pb.dart';
import 'package:hiero_sdk_dart/src/tokens/token_id.dart';
import 'package:hiero_sdk_dart/src/transaction/custom_fee.dart';

class CustomFixedFee extends CustomFee {
  int amount;
  TokenId? denominatingTokenId;
  AccountId? feeCollectorAccountId;
  bool allCollectorsAreExempt = false;

  CustomFixedFee(
    this.amount, {
    this.denominatingTokenId,
    this.feeCollectorAccountId,
    this.allCollectorsAreExempt = false,
  }) : super(
         feeCollectorAccountId,
         allCollectorsAreExempt: allCollectorsAreExempt,
       );
}
