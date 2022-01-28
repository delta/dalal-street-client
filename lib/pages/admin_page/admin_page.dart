import 'package:dalal_street_client/blocs/admin/tab1/tab1_cubit.dart';
import 'package:dalal_street_client/blocs/admin/tab2/tab2_cubit.dart';
import 'package:dalal_street_client/blocs/admin/tab3/tab3_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/pages/admin_page/components/tab_one.dart';
import 'package:dalal_street_client/pages/admin_page/components/tab_three.dart';
import 'package:dalal_street_client/pages/admin_page/components/tab_two.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pb.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fixnum/fixnum.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: [
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Responsive(
                  mobile: _mobileBody(),
                  tablet: _mobileBody(),
                  desktop: _mobileBody(),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      _onOpenMarket(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onCloseMarket(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onBlockUser(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onInspectUser(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onUnblockAllUsers(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onUnblockUser(),
                    ],
                  ),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      _onUpdateEndOfDayValues(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onUpdateStockPrice(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onAddStocksToExchange(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onAddMarketEvent(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onAddDailyChallenge(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onOpenDailyChallenge(),
                      const SizedBox(
                        height: 30,
                      ),
                      _onCloseDailyChallenge()
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Padding _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          _onSendNews(),
          const SizedBox(
            height: 10,
          ),
          _onSendNotifs(),
          const SizedBox(
            height: 10,
          ),
          _onSetMarketDay(),
          const SizedBox(
            height: 10,
          ),
          _onSendDividends(),
          const SizedBox(
            height: 10,
          ),
          _onSetGivesDividends(),
          const SizedBox(
            height: 10,
          ),
          _onSetBankruptcy(),
          const SizedBox(
            height: 10,
          ),
          _onLoadStocks(),
        ],
      ),
    );
  }

  Widget _onSendNews() {
    String news = ' ';
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SendNewsSuccess) {
        logger.i('sent news successfully');
        showSnackBar(context, 'sent news successfully');
      } else if (state is SendNewsFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SendNewsLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SendNewsFailure) {
        logger.i('unsuccessful');
      }
      return sendNewsUI(context, news, error);
    });
  }

  Widget _onBlockUser() {
    int userId = 0;
    Int64 penalty = Int64(0);
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is BlockUserSuccess) {
        logger.i('blocked user successfully');
        showSnackBar(context, 'blocked user with userId: $userId successfully');
      } else if (state is BlockUserFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is BlockUserLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is BlockUserFailure) {
        logger.i('unsuccessful');
      }
      return blockUserUI(context, userId, penalty, error);
    });
  }

  Widget _onOpenMarket() {
    bool updateDayHighAndLow = true;
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is OpenMarketSuccess) {
        logger.i('Opened Market successfully');
        showSnackBar(context, 'opened market');
      } else if (state is OpenMarketFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is OpenMarketLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is OpenMarketFailure) {
        logger.i('unsuccessful');
      }
      return openMarketUI(context, updateDayHighAndLow, error);
    });
  }

  Widget _onAddDailyChallenge() {
    int marketDay = 0;
    int stockId = 0;
    int reward = 0;
    Int64 values = Int64(0);
    {
      ChallengeType.Cash;
      ChallengeType.NetWorth;
      ChallengeType.SpecificStock;
      ChallengeType.StockWorth;
    }
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is AddDailyChallengeSuccess) {
        logger.i('Added Daily Challenge successfully');
        showSnackBar(context, 'Added Daily Challenge successfully');
      } else if (state is AddDailyChallengeFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is AddDailyChallengeLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is AddDailyChallengeFailure) {
        logger.i('unsuccessful');
      }
      return addDailyChallengeUI(context, marketDay, stockId, reward, values,
          ChallengeType.Cash, error);
    });
  }

  Widget _onSendDividends() {
    int stockId = 0;
    Int64 dividendAmt = Int64(0);
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SendDividendsSuccess) {
        logger.i('Send Dividends successfully');
        showSnackBar(context, 'sent dividends successfully');
      } else if (state is SendDividendsFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SendDividendsLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SendDividendsFailure) {
        logger.i('unsuccessful');
      }
      return sendDividendsUI(context, stockId, dividendAmt, error);
    });
  }

  Widget _onSetMarketDay() {
    int marketDay = 0;
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SetMarketDaySuccess) {
        logger.i('successful');
        showSnackBar(context, 'Set Market Day successfully');
      } else if (state is SetMarketDayFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SetMarketDayLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SetMarketDayFailure) {
        logger.i('unsuccessful');
      }
      return setMarketDayUI(context, marketDay, error);
    });
  }

  Widget _onUpdateStockPrice() {
    int stockId = 0;
    Int64 newPrice = Int64(0);
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is UpdateStockPriceSuccess) {
        logger.i('successful');
        showSnackBar(context, 'updated prices successfully');
      } else if (state is UpdateStockPriceFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is UpdateStockPriceLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is UpdateStockPriceFailure) {
        logger.i('unsuccessful');
      }
      return updateStockPriceUI(context, stockId, newPrice, error);
    });
  }

  Widget _onAddStocksToExchange() {
    int stockId = 0;
    Int64 newStocks = Int64(0);
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is AddStocksToExchangeSuccess) {
        logger.i('successful');
        showSnackBar(context, 'added stocks to exchange successfully');
      } else if (state is AddStocksToExchangeFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is AddStocksToExchangeLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is AddStocksToExchangeFailure) {
        logger.i('unsuccessful');
      }
      return addStocksToExchangeUI(context, stockId, newStocks, error);
    });
  }

  Widget _onAddMarketEvent() {
    int stockId = 0;
    String headline = ' ';
    String text = '';
    String imageUri = '';
    bool isGlobal = true;
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is AddMarketEventSuccess) {
        logger.i('successful');
        showSnackBar(context, 'successfully added market event');
      } else if (state is AddMarketEventFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is AddMarketEventLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is AddMarketEventFailure) {
        logger.i('unsuccessful');
      }
      return addMarketEventUI(
          context, headline, text, imageUri, stockId, isGlobal, error);
    });
  }

  Widget _onSetBankruptcy() {
    int stockId = 0;
    bool isBankrupt = true;
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SetBankruptcySuccess) {
        logger.i('Set Bankruptcy success');
        showSnackBar(context, 'bankrupt F');
      } else if (state is SetBankruptcyFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SetBankruptcyLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SetBankruptcyFailure) {
        logger.i('unsuccessful');
      }
      return setBankruptcyUI(context, stockId, isBankrupt, error);
    });
  }

  Widget _onInspectUser() {
    int userId = 0;
    int day = 0;
    bool transactionType = true;
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is InspectUserSuccess) {
        logger.i('Inspected User successfully');
        showSnackBar(context, 'Inspected User successfully');
      } else if (state is InspectUserFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is InspectUserLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is InspectUserFailure) {
        logger.i('unsuccessful');
      }
      return inspectUserUI(context, userId, day, transactionType, error);
    });
  }

  Widget _onUnblockUser() {
    int userId = 0;
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is UnblockUserSuccess) {
        logger.i('Unblocked User successfully');
        showSnackBar(context, 'Unblocked User successfully');
      } else if (state is UnblockUserFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is UnblockUserLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is UnblockUserFailure) {
        logger.i('unsuccessful');
      }
      return unblockUserUI(context, userId, error);
    });
  }

  Widget _onSetGivesDividends() {
    int stockId = 0;
    bool givesDividends = true;
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SetGivesDividendsSuccess) {
        logger.i('Set Gives Dividends successfully');
        showSnackBar(context, 'Set Gives Dividends successfully');
      } else if (state is SetGivesDividendsFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SetGivesDividendsLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SetGivesDividendsFailure) {
        logger.i('unsuccessful');
      }
      return setGivesDividendsUI(context, stockId, givesDividends, error);
    });
  }

  Widget _onSendNotifs() {
    String notifs = ' ';
    int userId = 0;
    bool isGlobal = true;
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is SendNotificationsSuccess) {
        logger.i('sent notif successfully');
        showSnackBar(context, 'sent notif successfully');
      } else if (state is SendNotificationsFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is SendNotificationsLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is SendNotificationsFailure) {
        logger.i('unsuccessful');
      }
      return sendNotifsUI(context, notifs, userId, isGlobal, error);
    });
  }

  Widget _onCloseMarket() {
    bool updatePrevDayHighAndLow = true;
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is CloseMarketSuccess) {
        logger.i('Opened Market successfully');
        showSnackBar(context, 'Closed Market  successfully');
      } else if (state is CloseMarketFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is CloseMarketLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is CloseMarketFailure) {
        logger.i('unsuccessful');
      }
      return closeMarketUI(context, updatePrevDayHighAndLow, error);
    });
  }

  Widget _onUpdateEndOfDayValues() {
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is UpdateEndOfDayValuesSuccess) {
        logger.i('successful');
        showSnackBar(context, 'updated end of day values successfully');
      } else if (state is UpdateEndOfDayValuesFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is UpdateEndOfDayValuesLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is UpdateEndOfDayValuesFailure) {
        logger.i('unsuccessful');
      }
      return updateEndOfDayValuesUI(context, error);
    });
  }

  Widget _onUnblockAllUsers() {
    bool error = false;
    return BlocConsumer<Tab2Cubit, Tab2State>(listener: (context, state) {
      if (state is UnblockAllUsersSuccess) {
        logger.i('successful');
        showSnackBar(context, 'Unblocked All Users successfully');
      } else if (state is UnblockAllUsersFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is UnblockAllUsersLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is UnblockAllUsersFailure) {
        logger.i('unsuccessful');
      }
      return unblockAllUsersUI(context, error);
    });
  }

  Widget _onLoadStocks() {
    bool error = false;
    return BlocConsumer<Tab1Cubit, Tab1State>(listener: (context, state) {
      if (state is LoadStocksSuccess) {
        logger.i('successful');
        showSnackBar(context, 'loaded stocks successfully');
      } else if (state is LoadStocksFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is LoadStocksLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is LoadStocksFailure) {
        logger.i('unsuccessful');
      }
      return loadStocksUI(context, error);
    });
  }

  Widget _onOpenDailyChallenge() {
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is OpenDailyChallengeSuccess) {
        logger.i('successful');
        showSnackBar(context, 'Opened Daily Challenge successfully');
      } else if (state is OpenDailyChallengeFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is OpenDailyChallengeLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is OpenDailyChallengeFailure) {
        logger.i('unsuccessful');
      }
      return openDailyChallengeUI(context, error);
    });
  }

  Widget _onCloseDailyChallenge() {
    bool error = false;
    return BlocConsumer<Tab3Cubit, Tab3State>(listener: (context, state) {
      if (state is CloseDailyChallengeSuccess) {
        logger.i('successful');
        showSnackBar(context, 'Closed Daily Challenge successfully');
      } else if (state is CloseDailyChallengeFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is CloseDailyChallengeLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is CloseDailyChallengeFailure) {
        logger.i('unsuccessful');
      }
      return closeDailyChallengeUI(context, error);
    });
  }
}
