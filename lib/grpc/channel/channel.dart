import 'package:dalal_street_client/grpc/read_cert.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

/// Client channel for non-web platforms
Future<ClientChannel> _makeChannel() async => ClientChannel(
      '192.168.29.85',
      port: 8000,
      options: ChannelOptions(
        credentials: ChannelCredentials.secure(
          certificates: await readServerCert(),
        ),
      ),
    );

Future<ClientChannelBase> getChannel() async => _makeChannel();
