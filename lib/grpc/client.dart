import 'package:dalal_street_client/proto_build/DalalMessage.pbgrpc.dart';
import 'stub.dart'
    if (dart.library.io) 'channel/channel.dart'
    if (dart.library.js) 'channel/web_channel.dart';

final _channel = getChannel();

final actionClient = DalalActionServiceClient(_channel);
final streamClient = DalalStreamServiceClient(_channel);
