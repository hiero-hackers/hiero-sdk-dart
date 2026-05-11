import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:hiero_sdk_dart/src/crypto/public_key.dart';
import 'package:hiero_sdk_dart/src/crypto/private_key.dart';

Future<void> exampleLoadEd25519PublicKey() async {
  String hexStr =
      '8baa5f735dbf40f275283bed504cb752b1ce58a7118476d28f528ecd265c5f58';
  Uint8List rawPub = Uint8List.fromList(hex.decode(hexStr));
  final pubkObj = PublicKey.fromBytesEd25519(rawPub);
  print('Loaded Ed25519 public key: $pubkObj');

  final backToHex = pubkObj.toStringEd25519();
  print('Converted back to hexadecimal: $backToHex');
}

Future<void> exampleLoadEd25519PublicKeyFromHex() async {
  String hexStr =
      '09fe6e485c1fb4e24c80b591fc79103c28006d549428a0d3ccb2a88412f2bda8';
  final pubkObj = PublicKey.fromStringEd25519(hexStr);
  print('Loaded Ed25519 public key from hex string: $pubkObj');
}

Future<void> exampleVerifyEd25519Signature() async {
  final privKey = await PrivateKey.generateEd25519();
  final pubkObj = await privKey.publicKey();

  final data = Uint8List.fromList('Hello, World!'.codeUnits);
  final signature = await privKey.sign(data);

  try {
    await pubkObj.verifyEd25519(data, signature);
    print('ED25519 Signature is valid!');
  } catch (e) {
    print('ED25519 Signature is invalid!, $e');
  }
}

Future<void> main() async {
  await exampleLoadEd25519PublicKey();
  print("------------------------------------");
  await exampleLoadEd25519PublicKeyFromHex();
  print("------------------------------------");
  await exampleVerifyEd25519Signature();
}
