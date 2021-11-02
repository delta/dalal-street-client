import 'package:dalal_street_client/proto_build/DalalMessage.pbgrpc.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'stub.dart'
    if (dart.library.io) 'channel/channel.dart'
    if (dart.library.js) 'channel/web_channel.dart';

late ClientChannelBase _channel;

late DalalActionServiceClient actionClient;
late DalalStreamServiceClient streamClient;

Future<void> initClients() async {
  _channel = await getChannel();
  actionClient = DalalActionServiceClient(_channel);
  streamClient = DalalStreamServiceClient(_channel);
}

Future<void> testGrpc() async {
  final resp = await actionClient.login(LoginRequest(email: '', password: ''));
  print('testGrpc: Resp = ${resp.statusCode}');
}
