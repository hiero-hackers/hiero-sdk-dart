import 'package:fixnum/fixnum.dart';
import 'package:hiero_sdk_dart/src/client/client.dart';
import 'package:hiero_sdk_dart/src/hapi/services/basic_types.pb.dart'
    as basic_types;
import 'package:hiero_sdk_dart/src/utils/entity_id_helper.dart' as utils;

class TokenId {
  int shard;
  int realm;
  int number;
  String? checksum;

  TokenId(this.shard, this.realm, this.number);

  factory TokenId.fromString(String id) {
    final (shard, realm, number, checksum) = utils.parseFromString(id);
    TokenId tokenId = TokenId(
      int.parse(shard),
      int.parse(realm),
      int.parse(number),
    );
    tokenId.checksum = checksum;
    return tokenId;
  }

  factory TokenId.fromProto(basic_types.TokenID proto) {
    return TokenId(
      proto.shardNum.toInt(),
      proto.realmNum.toInt(),
      proto.tokenNum.toInt(),
    );
  }

  basic_types.TokenID toProto() {
    return basic_types.TokenID(
      shardNum: Int64(shard),
      realmNum: Int64(realm),
      tokenNum: Int64(number),
    );
  }

  void validateChecksum(Client client) {
    utils.validateChecksum(shard, realm, number, checksum, client);
  }

  String toStringWithChecksum(Client client) {
    return utils.formatToStringWithChecksum(shard, realm, number, client);
  }

  @override
  String toString() {
    return utils.formatToString(shard, realm, number);
  }
}
