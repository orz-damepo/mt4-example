//+------------------------------------------------------------------+
//|                                                  currency.mqh    |
//|                                     Copyright 2022, Damepo Taro. |
//|                                           https://orz.damepo.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Damepo Taro."
#property link      "https://orz.damepo.net"
#property version   "1.0"
#property strict

#include <Damepo/bar_info.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // bar_info
    testBarInfo();
    // currency
    testCurrency();

    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
}

void testBarInfo()
{
    // 前日の日足情報
    BarInfo bar(1, PERIOD_D1);
    Print("陰線判定：", bar.isBlack());
    Print("最高値：", bar.getHigh().getString());
    Print("最安値：", bar.getLow().getString());
}
void testCurrency()
{
    double askVal = 134.123;
    double bidVal = 133.118;
    Print("1:ずれる", askVal - bidVal);
    Print("2:ずれない", StringFormat("%.3f", askVal - bidVal));
    Print("3:ずれない", NormalizeDouble(askVal - bidVal, 3));
    Currency cur1(askVal - bidVal);
    Print("4:ずれない", cur1.getDouble());
    Currency ask(askVal);
    Currency bid(bidVal);
    Print("5:ずれない", subCurrency(ask, bid).getDouble());
    Print("6:ずれる", 8.11);
    Print("7:ずれる", 10 - 1.89);
    Print("8:ずれる", NormalizeDouble(8.11, 3));
    Currency cur(8.11);
    Print("9:ずれる", cur.getDouble());
    Print("10:ずれない", cur.getInteger());
    // 1がずれて2がずれない,double型初期化した9がずれて10がずれていない事からdouble型の数値は内部的には正しくPrint時におかしくなっている事が分かる
    // なのでPrintする時はString利用を推奨
    Print("11:ずれない", cur.getString());
    Print("12:ずれない", StringFormat("%.3f", 8.11));
    Print("13:ずれない", StringFormat("%.3f", cur.getDouble()));
}