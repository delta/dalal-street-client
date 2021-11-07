import 'package:dalal_street_client/proto_build/DalalMessage.pbgrpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'stub.dart'
    if (dart.library.io) 'channel/channel.dart'
    if (dart.library.js) 'channel/web_channel.dart';

late ClientChannelBase _channel;

/// Action client to dispatch one-time actions to server
late DalalActionServiceClient actionClient;

/// Stream client to get access to live streams of data from server
late DalalStreamServiceClient streamClient;

/// Initialise the client objects
Future<void> initClients() async {
  _channel = await getChannel();
  actionClient = DalalActionServiceClient(_channel);
  streamClient = DalalStreamServiceClient(_channel);
}
