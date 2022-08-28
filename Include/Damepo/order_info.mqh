//+------------------------------------------------------------------+
//|                                                order_info.mqh    |
//|                                     Copyright 2022, Damepo Taro. |
//|                                           https://orz.damepo.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Damepo Taro."
#property link      "https://orz.damepo.net"
#property version   "1.0"
#property strict

#include <Damepo/currency.mqh>

#define DA_ORDER_TYPE_NONE 0        //未設定
#define DA_ORDER_TYPE_BUY 1         //買い注文
#define DA_ORDER_TYPE_SELL 2        //売り注文

//+------------------------------------------------------------------+
//| 注文情報クラス                                                      |
//+------------------------------------------------------------------+
class OrderInfo
{
    private:
        int _ticketNo;
        int _orderType;
        int _orderDetail;
        Currency _openPrice;    //注文約定金額
        Currency _stopLoss;     //損切（逆指値）金額
        Currency _takeProfit;   //利確（決済）金額
        // 注文情報設定
        void _init(int ticketNo)
        {
            bool result = OrderSelect(ticketNo, SELECT_BY_TICKET , MODE_TRADES);
            if (!result)
                return;
            // 選択した注文情報で初期化
            resetSelectedOrder();
        }
    public:
        // コンストラクタ
        void OrderInfo()
        {
            _orderType = DA_ORDER_TYPE_NONE;
        }
        // コンストラクタ
        void OrderInfo(int ticketNo)
        {
            _init(ticketNo);
        }
        // コピーコンストラクタ
        OrderInfo(const OrderInfo &src)
        {
            _ticketNo = src._ticketNo;
            _orderType = src._orderType;
            _orderDetail = src._orderDetail;
            _stopLoss = src._stopLoss;
            _takeProfit = src._takeProfit;
            _openPrice = src._openPrice;
        }
        // 現在選択されている注文情報で値をリセット
        void resetSelectedOrder()
        {
            _ticketNo = OrderTicket();
            _openPrice = Currency(OrderOpenPrice());
            _stopLoss = Currency(OrderStopLoss());
            _takeProfit = Currency(OrderTakeProfit());
            _orderDetail = OrderType();
            if (OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP)
            {
                _orderType = DA_ORDER_TYPE_BUY;
            }
            if (OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP)
            {
                _orderType = DA_ORDER_TYPE_SELL;
            }
        }
        // チケット番号取得
        int getTicketNo()
        {
            return _ticketNo;
        }
        // 注文種別（DA_ORDER_TYPE_NONE/DA_ORDER_TYPE_BUY/DA_ORDER_TYPE_SELL）
        int getOrderType()
        {
            return _orderType;
        }
        // 注文種別詳細（OP_BUY/OP_BUYLIMIT/OP_BUYSTOP/OP_SELL/OP_SELLLIMIT/OP_SELLSTOP）
        int getOrderDetail()
        {
            return _orderDetail;
        }
        // 注文約定金額取得
        Currency getOpenPrice()
        {
            return _openPrice;
        }
        // 逆指値取得
        Currency getStopLoss()
        {
            return _stopLoss;
        }
        // 利確値取得
        Currency getTakeProfit()
        {
            return _takeProfit;
        }
};