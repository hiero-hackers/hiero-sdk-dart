import 'package:hiero_sdk_dart/src/account/account_id.dart';
import 'package:hiero_sdk_dart/src/client/client.dart';
import 'package:hiero_sdk_dart/src/hapi/services/basic_types.pb.dart'
    as basic_types;
import 'package:hiero_sdk_dart/src/hapi/services/custom_fees.pb.dart'
    as custom_fees;
import 'package:hiero_sdk_dart/src/transaction/custom_fixed_fee.dart';

abstract class CustomFee {
  AccountId? feeCollectorAccountId;
  bool allCollectorsAreExempt = false;

  CustomFee(this.feeCollectorAccountId, {this.allCollectorsAreExempt = false});

  CustomFee setFeeCollectorAccountId(AccountId feeCollectorAccountId) {
    this.feeCollectorAccountId = feeCollectorAccountId;
    return this;
  }

  CustomFee setAllCollectorsAreExempt(bool allCollectorsAreExempt) {
    this.allCollectorsAreExempt = allCollectorsAreExempt;
    return this;
  }

  static CustomFee fromProto(custom_fees.CustomFee customFee) {
    final custom_fees.CustomFee_Fee feeCase = customFee.whichFee();
    if (feeCase == custom_fees.CustomFee_Fee.fixedFee) {
      return CustomFixedFee.fromProto(customFee);
    }
    throw ArgumentError('Unsupported fee type');
  }

  basic_types.AccountID? getFeeCollectorAccountIdProtobuf() {
    return feeCollectorAccountId?.toProto();
  }

  custom_fees.CustomFee toProto();

  void validateChecksum(Client client) {
    feeCollectorAccountId?.validateChecksum(client);
  }
}
