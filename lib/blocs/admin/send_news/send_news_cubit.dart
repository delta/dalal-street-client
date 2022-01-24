import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/SendNews.pb.dart';

part 'send_news_state.dart';

class SendNewsCubit extends Cubit<SendNewsState> {
  SendNewsCubit() : super(SendNewsInitial());

  Future<void> sendNews(
    String news,
  ) async {
    emit(const SendNewsLoading());
    try {
      final resp = await actionClient.sendNews(
          SendNewsRequest(
            news: news,
          ),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SendNewsResponse_StatusCode.OK) {
        emit(SendNewsSuccess(resp.statusMessage));
      } else {
        emit(SendNewsFailure(resp.statusMessage));
        emit(SendNewsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SendNewsFailure(failedToReachServer));
    }
  }

  void add(SendNewsCubit sendNewsCubit) {}
}
