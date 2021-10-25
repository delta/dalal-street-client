import 'package:dalal_street_client/proto_build/DalalMessage.pbgrpc.dart';
import 'stub.dart'
    if (dart.library.io) 'channel.dart'
    if (dart.library.js) 'web_channel.dart';

var channel = getChannel();

final actionClient = DalalActionServiceClient(channel);
final streamClient = DalalStreamServiceClient(channel);
