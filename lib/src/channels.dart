import 'package:grpc/grpc.dart';

import 'hapi/services/file_service.pbgrpc.dart';
import 'hapi/services/address_book_service.pbgrpc.dart';
import 'hapi/services/consensus_service.pbgrpc.dart';
import 'hapi/services/crypto_service.pbgrpc.dart';
import 'hapi/services/freeze_service.pbgrpc.dart';
import 'hapi/services/network_service.pbgrpc.dart';
import 'hapi/services/schedule_service.pbgrpc.dart';
import 'hapi/services/smart_contract_service.pbgrpc.dart';
import 'hapi/services/token_service.pbgrpc.dart';
import 'hapi/services/util_service.pbgrpc.dart';

class Channel {
  final ClientChannel channel;

  CryptoServiceClient? _crypto;
  FileServiceClient? _file;
  NetworkServiceClient? _network;
  SmartContractServiceClient? _smartContract;
  TokenServiceClient? _token;
  ConsensusServiceClient? _topic;
  FreezeServiceClient? _freeze;
  ScheduleServiceClient? _schedule;
  UtilServiceClient? _util;
  AddressBookServiceClient? _addressBook;

  Channel(this.channel);

  CryptoServiceClient? get crypto => _crypto ??= CryptoServiceClient(channel);

  FileServiceClient? get file => _file ??= FileServiceClient(channel);

  NetworkServiceClient? get network =>
      _network ??= NetworkServiceClient(channel);

  SmartContractServiceClient? get smartContract =>
      _smartContract ??= SmartContractServiceClient(channel);

  TokenServiceClient? get token => _token ??= TokenServiceClient(channel);

  ConsensusServiceClient? get topic =>
      _topic ??= ConsensusServiceClient(channel);

  FreezeServiceClient? get freeze => _freeze ??= FreezeServiceClient(channel);

  ScheduleServiceClient? get schedule =>
      _schedule ??= ScheduleServiceClient(channel);

  UtilServiceClient? get util => _util ??= UtilServiceClient(channel);

  AddressBookServiceClient? get addressBook =>
      _addressBook ??= AddressBookServiceClient(channel);
}
