import 'package:dalal_street_client/config/config.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

/// [ClientChannel] for web platform
final _webChannel = GrpcWebClientChannel.xhr(Uri.parse(webConfig.url));

Future<ClientChannelBase> getChannel() async => _webChannel;
