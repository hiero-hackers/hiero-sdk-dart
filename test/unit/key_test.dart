import 'dart:typed_data';
import 'package:hiero_sdk_dart/src/crypto/key.dart';
import 'package:hiero_sdk_dart/src/crypto/private_key.dart';
import 'package:hiero_sdk_dart/src/crypto/public_key.dart';
import 'package:hiero_sdk_dart/src/hapi/services/basic_types.pb.dart'
    as basic_types;
import 'package:test/test.dart';

class MockKey extends Key {
  final basic_types.Key _proto;
  MockKey(this._proto);

  @override
  Future<basic_types.Key> toProtoKey() async => _proto;
}

void main() {
  group('Key unit tests', () {
    test('testToBytesSerialization', () async {
      final proto = basic_types.Key()..ed25519 = Uint8List(32);
      final key = MockKey(proto);
      final bytes = await key.toBytes();

      expect(bytes, isA<Uint8List>());
      expect(bytes, equals(proto.writeToBuffer()));
    });

    test('testFromProtoKeyEd25519', () async {
      final priv = await PrivateKey.generateEd25519();
      final pub = await priv.publicKey();

      final proto = await pub.toProtoKey();
      final loaded = Key.fromProtoKey(proto);

      expect(loaded, isA<PublicKey>());
      expect(loaded, equals(pub));
    });

    test('testFromBytesRoundtrip', () async {
      final priv = await PrivateKey.generateEd25519();
      final pub = await priv.publicKey();

      final bytes = await pub.toBytes();
      final loaded = Key.fromBytes(bytes);

      expect(loaded, isA<PublicKey>());
      expect(loaded, equals(pub));
    });

    test('testFromProtoKeyUnsupportedType', () {
      final proto = basic_types.Key();

      expect(
        () => Key.fromProtoKey(proto),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Unsupported key type'),
          ),
        ),
      );
    });

    test('testFromBytesInvalidData', () {
      // Test fromBytes with invalid protobuf data.
      final invalidBytes = Uint8List.fromList([0xFF, 0xFF, 0xFF]);

      // Depending on the protobuf implementation, this might throw or return an empty proto.
      // If it returns an empty proto, fromProtoKey will throw 'Unsupported key type'.
      expect(() => Key.fromBytes(invalidBytes), throwsA(anything));
    });
  });
}
