final faq = {
  'What time does the stock market open and close ?':
      'The market opens at ```20:00 (IST)``` and closes at ```24:00 (IST)```',
  'Help! I don\'t know what Market, Limit and Stoploss orders are!': '''
These are the 3 types of orders that you can place. The type of order you select can change the trade price as well as how soon your order gets filled.

 - `Market Orders`: If your primary concern is to have your order filled ASAP, and you’re not too worried about the price at which the transaction is carried out, you should use a Market Order. Once you place a Market Buy Order for a certain company, we will find the least priced Market Sell Order (for the same company) and execute the transaction. (vice-versa for Market Sell)

- `Limit Orders` : Limit Orders allow you to specify a maximum trade price in case of a Limit Buy, and a minimum trade price in case of a Limit Sell. While these may take more time to be filled than a Market Order, they provide you with more control over the price at which the transaction is executed a.k.a trade price.

- `Stoploss Orders` : Stoploss orders are converted to Market Orders once the price crosses the Stoploss price that you set
    - Stopless Buys are converted to Market Buys as soon as the stocks price rises above the Stoploss price that you set.
    - Stopless Sells are converted to Market Sells as soon as the stocks price falls below the Stoploss price that you set.

*Pro Tip*: Since the market is open for four hours, Stoploss orders can be very useful in case the market fluctuates wildly when you're not online! You can use Stopless Buy Orders to jump on a rising trend and you can use Stoploss Sell Orders to lock in a profit/limit your losses.
''',
  'What exactly is this trade price and how is it determined?':
      'The trade price is the price at which a transaction is executed. Our algorithm uses a best match approach to match Buy Orders to Sell orders as well as to determine the price at which the trade is executed. You can view the trade price of all of your executed transactions on the Portfolio Page.',
  'How is the winner determined?': '''
The player with the highest Total Net Worth at the end of 7 days is declared as the winner. 

Your Total Net Worth is calculated by adding
- Cash in hand
- Stock worth
- Reserved cash
- Reserved stock worth
''',
  'What is this Order Fee shown when I place orders?':
      'You have to pay a small fee whenever you place an order, called the order fee. Once the order has been placed and you have paid the order fee from the cash in hand, even if you cancel the order, this fee will *not* be returned.',
  'Where are my Reserved Assets shown?': '''
When you place a Bid order, cash is reserved. When you place a Sell order, stocks are reserved. You can check how much cash is reserved in the Portfolio Page. If you cancel the Bid order, the cash reserved will be returned to you. Similarly, cancelling a Sell order will return your stocks.

Please note that Order fee for placing these orders will NOT be returned.
''',
  'What is this short selling you speak of?': '''
While you will buy a company's stock if you expect its price to go up, you can short sell a company’s stock if you expect its price to go down. In a nutshell, short selling means to sell stocks that you don’t own so that you can buy them back at a lower price.

To short sell stocks, Broker will lend the total number of stocks to your account, this will increase the total stockworth in the portfolio, These stocks are then placed as `Ask` orders.

Shorting is intra-day, so the stocks lended to you will be taken back, the difference in the stock worth is the Profit/Loss you made in this shorting.

After you short sell a company, if the stock price dips below the price you sold it for, then you will have made a profit and vice-versa.

Note: You can only short sell a maximum of 20 stocks per company per day.
''',
  'What are the different types of transactions on the Portfolio Page?': '''
- `Exchange` - When you buy stocks from the exchange.

- `OrderFill` - Represents a trade between users.

- `Mortgage` - These transactions occur when you mortgage your stocks or retrieve stocks you've already mortgaged.

- `Ipo` - When you bid for IPO stock.

- `Order Fee` - Every order you place has an associated order fee.

- `Tax` : Nothing comes free! So you are charged a small tax whenever you make a profit off of a trade.

- `Reserve Asset` : Represents either cash or stocks being reserved when you place a Bid or Sell order respectively.

- `Cancel Order` : Represents Reserved Assets being returned when you cancel an order.
''',
  'What is the difference between Stocks in Exchange and Stocks in Market?': '''
- `Stock in Exchange` - The number of stocks that the Dalal Street Exchange currently holds.
- `Stock in  Market` - The number of stocks that are currently held by all of the players in the game.

When the game begins, the Stocks in Market will be zero since all stocks are initially held by the exchange. As soon as the market opens on Day 1 and players begin buying from the exchange, the number of Stocks in Market will increase and the number of Stocks in Exchange will decrease.

If the number of Stocks in Exchange is zero, it means that all shares of this company are currently in the hands of the players. Therefore, you can no longer buy shares from the exchange and instead, you'll have to place Buy Orders on the Company page to buy any stock.
''',
  'How does mortgaging work?': '''
Mortgaging is a great tactic to use if you are in need of cash but are not willing to sell your stocks to other players. It consists of 2 steps

- `Mortgage` :  In this step, you will be selling your stocks to the exchange at the Deposit Rate (80% of the Current Stock Price).
- `Retrieval` : Here, you will be retrieving the stocks you initially mortgaged by paying the exchange at the Retrieval Rate (90% of the Mortgaged Price).

*Note* : After you mortgage a stock, it is no longer a part of your portfolio and hence, will not contribute to your stock worth (until you retrieve it). However, at the end of the game, users will be forced to retrieve all of their mortgaged stocks at the Retrieval Price.
''',
  'Can a company give dividends?':
      'During the course of the game, some companies may decide to give out dividends to its shareholders. Dividend is a fixed amount that a company, which has made huge profits, offers you for each stock you own of that company. You\'ll be notified when a company is giving dividends, till then stay tuned to the News Page for the latest updates on the companies.',
  'What are Daily Challenges?': '''
A set of daily challenges will be given for every market day along with an associated reward based on the difficulty of the challenge.

Each challenge constitutes increasing any one of the four following parameters to the specified value, namely, Cash worth, Stock Worth, Net worth, Number of a specific Stock.

The challenge for a specific market day is valid only between the opening and closing of the Daily challenge and user should complete it within that period in order to be able to claim the reward.

The status and progress of a particular challenge is shown adjacent to that particular challenge by the following symbols.

While challenge is open, the current value and the value needed to achieve the challenge will be displayed for users to check their progress. It will either be in green or red showing if the user has reached or has not reached the value.

Daily Challenges are closed at the end of the day.
''',
  'How is the progress in daily challenges calculated?': '''
- `Cash worth`: The change in (cash in hand + Reserved Cash) quantity for that day is computed and displayed as progress.

- `Stock worth`: The change in (worth of stocks owned by you + Reserved Stocks worth) quantity that day is computed and displayed as progress.

- `Specific stock`: The change in (number of stocks owned + number of stocks reserved)(Both the terms relate to the specified stock) quantity that day is computed and displayed as progress.

- `Net Worth`: The change in the Net worth that day is computed and displayed as progress.
''',
  'Help! My account got blocked!':
      'If a user is found breaking the rules of our Code of Conduct, the user will be blocked from playing the game any further. Check out our Action against Malpractice section in Getting Started for more details. Reach out to us on our forum for any further clarification.',
};
