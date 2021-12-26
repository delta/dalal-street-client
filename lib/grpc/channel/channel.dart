import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/grpc/read_cert.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

/// [ClientChannel] for non-web platforms
Future<ClientChannel> _makeChannel() async => ClientChannel(
      mobileConfig.host,
      port: mobileConfig.port,
      options: ChannelOptions(
        credentials: ChannelCredentials.secure(
          certificates: await readServerCert(),
          onBadCertificate: (cert, str) => true,
        ),
      ),
    );

Future<ClientChannelBase> getChannel() async => _makeChannel();
