import 'package:fixnum/fixnum.dart';
import 'package:hiero_sdk_dart/hiero_sdk_dart.dart';
import 'package:hiero_sdk_dart/src/hapi/services/basic_types.pb.dart'
    as basic_types;
import 'package:hiero_sdk_dart/src/utils/entity_id_helper.dart'
    as entity_id_helper;

class TopicId {
  int shard = 0;
  int realm = 0;
  int topic = 0;
  String? checksum;

  TopicId();

  factory TopicId.froProto(basic_types.TopicID topicIdProto) {
    return TopicId()
      ..shard = topicIdProto.shardNum.toInt()
      ..realm = topicIdProto.realmNum.toInt()
      ..topic = topicIdProto.topicNum.toInt();
  }

  basic_types.TopicID toProto() {
    return basic_types.TopicID()
      ..shardNum = Int64(shard)
      ..realmNum = Int64(realm)
      ..topicNum = Int64(topic);
  }

  factory TopicId.fromString(String topicIdStr) {
    final parts = topicIdStr.split('.');
    if (parts.length != 3) {
      throw ArgumentError(
        'Invalid TopicId format. Expected format: shard.realm.topic',
      );
    }
    return TopicId()
      ..shard = int.parse(parts[0])
      ..realm = int.parse(parts[1])
      ..topic = int.parse(parts[2]);
  }

  void validateChecksum(Client client) {
    entity_id_helper.validateChecksum(shard, realm, topic, checksum, client);
  }
}
