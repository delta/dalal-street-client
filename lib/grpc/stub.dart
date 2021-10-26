/// An import stub to conditionally import platform specific packages

import 'package:grpc/grpc_connection_interface.dart';

Future<ClientChannelBase> getChannel() async =>
    throw UnsupportedError('Cannot create a ClientChannelBase');
