import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Center _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 16,
          color: secondaryColor,
        ),
      ),
    );
  }

  Center _desktopBody() {
    return const Center(
      child: Text(
        'Desktop UI will design soon :)',
        style: TextStyle(
          fontSize: 16,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _mobileBody() {
    String question = '';
    String answer = '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                          image: AssetImage('assets/images/faqPage.png')),
                      Flexible(
                        child: Column(
                          children: const [
                            Text(
                              'Have Questions?',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Mr Bull has got exceptional answers for you!',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'Where are my Reserved Assets shown?',
                    answer =
                        'When you place a Bid order, cash is reserved. When you place a Sell order, stocks are reserved. You can check how much cash is reserved in the Nav Bar at the top. Reserved stocks can be viewed in the Portfolio Page, in the Reserved Stocks tab. If you cancel the Bid order, the cash reserved will be returned to you. Similarly, cancelling a Sell order will return your stocks. Please note that Order fee for placing these orders will NOT be returned.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Where are my Reserved Assets shown?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'When you place a Bid order, cash is reserved. When you place a Sell order, stocks are reserved. You can check how much cash is reserved in the Nav Bar at the top. Reserved stocks can be viewed in the Portfolio Page, in the Reserved Stocks tab. If you cancel the Bid order, the cash reserved will be returned to you. Similarly, cancelling a Sell order will return your stocks. Please note that Order fee for placing these orders will NOT be returned.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question =
                        'What is this Order Fee shown when I place orders?',
                    answer =
                        'You have to pay a small fee whenever you place an order, called the order fee. Once the order has been placed and you have paid the order fee from the cash in hand, even if you cancel the order, this fee will NOT be returned.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'What is this Order Fee shown when I place orders?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'You have to pay a small fee whenever you place an order, called the order fee. Once the order has been placed and you have paid the order fee from the cash in hand, even if you cancel the order, this fee will NOT be returned.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'What is this shortselling you speak of?',
                    answer =
                        'While you will buy a company\'s stock if you expect its price to go up, you can short sell a company’s stock if you expect its price to go down. In a nutshell, short selling means to sell stocks that you don’t own so that you can buy them back at a lower price.\nFor example, short selling 5 shares of a company XYZ is mathematically equivalent to buying -5 shares of XYZ. When you short sell, your Cash In Hand will increase and your Stock Worth will accordingly decrease such that your Net Worth remains the same (Remember: Net Worth = Cash In Hand + Stock Worth)\nAfter you short sell a company, if the stock price dips below the price you sold it for, then you will have made a profit and vice-versa.\nNote: You can only short sell a maximum of 50 stocks per company.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('What is this shortselling you speak of?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'While you will buy a company\'s stock if you expect its price to go up, you can short sell a company’s stock if you expect its price to go down. In a nutshell, short selling means to sell stocks that you don’t own so that you can buy them back at a lower price.\nFor example, short selling 5 shares of a company XYZ is mathematically equivalent to buying -5 shares of XYZ. When you short sell, your Cash In Hand will increase and your Stock Worth will accordingly decrease such that your Net Worth remains the same (Remember: Net Worth = Cash In Hand + Stock Worth)\nAfter you short sell a company, if the stock price dips below the price you sold it for, then you will have made a profit and vice-versa.\nNote: You can only short sell a maximum of 50 stocks per company.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question =
                        'What are the different types of transactions on the Portfolio Page?',
                    answer =
                        'Exchange - When you buy stocks from the exchange.\nOrderFill - Represents a trade between users.\nMortgage - These transactions occur when you mortgage your stocks or retrieve stocks you\'ve already mortgaged.\nOrder Fee - Every order you place has an associated order fee.\nTax - Nothing comes free! So you are charged a small tax whenever you make a profit off of a trade.\nReserve Asset - Represents either cash or stocks being reserved when you place a Bid or Sell order respectively.\nCancel Order - Represents Reserved Assets being returned when you cancel an order.',
                    openBottomSheet(question, answer)
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'What are the different types of transactions on the Portfolio Page?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'Exchange - When you buy stocks from the exchange.\nOrderFill - Represents a trade between users.\nMortgage - These transactions occur when you mortgage your stocks or retrieve stocks you\'ve already mortgaged.\nOrder Fee - Every order you place has an associated order fee.\nTax - Nothing comes free! So you are charged a small tax whenever you make a profit off of a trade.\nReserve Asset - Represents either cash or stocks being reserved when you place a Bid or Sell order respectively.\nCancel Order - Represents Reserved Assets being returned when you cancel an order.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question =
                        'What is the difference between Stocks in Exchange and Stocks in Market?',
                    answer =
                        'In the Companies Page, you\'ll find an entry for Stocks in Exchange as well as an entry for Stocks in Market. Let’s clarify the difference between the two :-\nStocks in Exchange - The number of stocks that the Dalal Street Exchange currently holds. This number will be the same as the number found under the Available column in the Exchange Page.\nStocks in Market - The number of stocks that are currently held by all of the players in the game.\nWhen the game begins, the Stocks in Market will be zero since all stocks are initially held by the exchange. As soon as the market opens on Day 1 and players begin buying from the exchange, the number of Stocks in Market will increase and the number of Stocks in Exchange will decrease.\nIf the number of Stocks in Exchange is zero, it means that all shares of this company are currently in the hands of the players. Therefore, you can no longer buy shares from the exchange and instead, you\'ll have to place Buy Orders on the Trading Page to buy any stock.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'What is the difference between Stocks in Exchange and Stocks in Market?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'In the Companies Page, you\'ll find an entry for Stocks in Exchange as well as an entry for Stocks in Market. Let’s clarify the difference between the two :-\nStocks in Exchange - The number of stocks that the Dalal Street Exchange currently holds. This number will be the same as the number found under the Available column in the Exchange Page.\nStocks in Market - The number of stocks that are currently held by all of the players in the game.\nWhen the game begins, the Stocks in Market will be zero since all stocks are initially held by the exchange. As soon as the market opens on Day 1 and players begin buying from the exchange, the number of Stocks in Market will increase and the number of Stocks in Exchange will decrease.\nIf the number of Stocks in Exchange is zero, it means that all shares of this company are currently in the hands of the players. Therefore, you can no longer buy shares from the exchange and instead, you\'ll have to place Buy Orders on the Trading Page to buy any stock.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'How does mortgaging work?',
                    answer =
                        'Mortgaging is a great tactic to use if you are in need of cash but are not willing to sell your stocks to other players. It consists of 2 steps :-\nMortgage - In this step, you will be selling your stocks to the exchange at the Deposit Rate (80% of the Current Stock Price).\nRetrieval - Here, you will be retrieving the stocks you initially mortgaged by paying the exchange at the Retrieval Rate (90% of the Mortgaged Price).\n\nNote : After you mortgage a stock, it is no longer a part of your portfolio and hence, will not contribute to your stock worth (until you retrieve it). However, at the end of the game, users will be forced to retrieve all of their mortgaged stocks at the Retrieval Price.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('How does mortgaging work?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'Mortgaging is a great tactic to use if you are in need of cash but are not willing to sell your stocks to other players. It consists of 2 steps :-\nMortgage - In this step, you will be selling your stocks to the exchange at the Deposit Rate (80% of the Current Stock Price).\nRetrieval - Here, you will be retrieving the stocks you initially mortgaged by paying the exchange at the Retrieval Rate (90% of the Mortgaged Price).\n\nNote : After you mortgage a stock, it is no longer a part of your portfolio and hence, will not contribute to your stock worth (until you retrieve it). However, at the end of the game, users will be forced to retrieve all of their mortgaged stocks at the Retrieval Price.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question =
                        'Can I expect any new companies to pop up over the course of the game?',
                    answer =
                        'While we don\'t expect any more companies to go public over the course of this game, existing companies may release more shares in the middle. If this happens, then the number of Stocks in Exchange will increase, and you can buy these stocks from the Exchange Page. Stay tuned to the News Page or download the Dalal Street Android App to be the first to know when to expect more shares.\nIf you still have any queries, please feel free to ask it on our Official Forum and we\'ll try to get back to you as soon as possible. Happy Trading!',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'Can I expect any new companies to pop up over the course of the game?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'While we don\'t expect any more companies to go public over the course of this game, existing companies may release more shares in the middle. If this happens, then the number of Stocks in Exchange will increase, and you can buy these stocks from the Exchange Page. Stay tuned to the News Page or download the Dalal Street Android App to be the first to know when to expect more shares.\nIf you still have any queries, please feel free to ask it on our Official Forum and we\'ll try to get back to you as soon as possible. Happy Trading!',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'Can a company give dividends?',
                    answer =
                        'During the course of the game, some companies may decide to give out dividends to its shareholders. Dividend is a fixed amount that a company, which has made huge profits, offers you for each stock you own of that company. You\'ll be notified when a company is giving dividends, till then stay tuned to the News Page for the latest updates on the companies.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Can a company give dividends?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'During the course of the game, some companies may decide to give out dividends to its shareholders. Dividend is a fixed amount that a company, which has made huge profits, offers you for each stock you own of that company. You\'ll be notified when a company is giving dividends, till then stay tuned to the News Page for the latest updates on the companies.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'Can a company go bankrupt at any point?',
                    answer =
                        'Yes. A company might file for bankruptcy depending on their current financial situation. Stay tuned to the News Page for the latest updates about companies. When a company goes bankrupt, you can no longer exchange their stocks and all stocks that you own of this company become worthless.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Can a company go bankrupt at any point?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'Yes. A company might file for bankruptcy depending on their current financial situation. Stay tuned to the News Page for the latest updates about companies. When a company goes bankrupt, you can no longer exchange their stocks and all stocks that you own of this company become worthless.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'What are daily challenges?',
                    answer =
                        'A set of daily challenges will be given for every market day along with an associated reward based on the difficulty of the challenge.\nEach challenge constitutes increasing any one of the four following parameters to the specified value, namely, Cash worth, Stock Worth, Net worth, Number of a specific Stock.\nThe challenge for a specific market day is valid only between the opening and closing of the Daily challenge and user should complete it within that period in order to be able to claim the reward.\n\nWhile challenge is open, the current value and the value needed to achieve the challenge will be displayed for users to check their progress. It will either be in green or red showing if the user has reached or has not reached the value.\nDaily Challenges are closed at the end of the day.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('What are daily challenges?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'A set of daily challenges will be given for every market day along with an associated reward based on the difficulty of the challenge.\nEach challenge constitutes increasing any one of the four following parameters to the specified value, namely, Cash worth, Stock Worth, Net worth, Number of a specific Stock.\nThe challenge for a specific market day is valid only between the opening and closing of the Daily challenge and user should complete it within that period in order to be able to claim the reward.\n\nWhile challenge is open, the current value and the value needed to achieve the challenge will be displayed for users to check their progress. It will either be in green or red showing if the user has reached or has not reached the value.\nDaily Challenges are closed at the end of the day.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question =
                        'How is the progress in daily challenges calculated?',
                    answer =
                        'Cash worth: The change in (cash in hand + Reserved Cash) quantity for that day is computed and displayed as progress.\nStock worth: The change in (worth of stocks owned by you + Reserved Stocks worth) quantity that day is computed and displayed as progress.\nSpecific stock: The change in (number of stocks owned + number of stocks reserved)(Both the terms relate to the specified stock) quantity that day is computed and displayed as progress.\nNet Worth: The change in the Net worth that day is computed and displayed as progress.',
                    openBottomSheet(question, answer),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'How is the progress in daily challenges calculated?',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'Cash worth: The change in (cash in hand + Reserved Cash) quantity for that day is computed and displayed as progress.\nStock worth: The change in (worth of stocks owned by you + Reserved Stocks worth) quantity that day is computed and displayed as progress.\nSpecific stock: The change in (number of stocks owned + number of stocks reserved)(Both the terms relate to the specified stock) quantity that day is computed and displayed as progress.\nNet Worth: The change in the Net worth that day is computed and displayed as progress.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {
                    question = 'Help! My account got blocked',
                    answer =
                        'If a user is found breaking the rules of our Code of Conduct, the user will be blocked from playing the game any further. Reach out to us on our forum for further clarification.',
                    openBottomSheet(question, answer)
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Help! My account got blocked',
                            style: TextStyle(fontSize: 16, color: white),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'If a user is found breaking the rules of our Code of Conduct, the user will be blocked from playing the game any further. Reach out to us on our forum for further clarification.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: whiteWithOpacity75),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  openBottomSheet(String question, String answer) {
    showModalBottomSheet(
        backgroundColor: background2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Wrap(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 150,
                                height: 4.5,
                                decoration: const BoxDecoration(
                                  color: lightGray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                )),
                            const SizedBox(height: 15),
                            Text(
                              question,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              answer,
                              style:
                                  const TextStyle(fontSize: 16, color: white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          );
        });
  }
}
