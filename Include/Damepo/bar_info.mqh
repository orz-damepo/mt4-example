//+------------------------------------------------------------------+
//|                                                  bar_info.mqh    |
//|                                     Copyright 2022, Damepo Taro. |
//|                                           https://orz.damepo.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Damepo Taro."
#property link      "https://orz.damepo.net"
#property version   "1.0"
#property strict

#include <Damepo/currency.mqh>

#define DA_BARTYPE_WHITE 1           // ローソク足種別陽線
#define DA_BARTYPE_BLACK 2           // ローソク足種別陰線
#define DA_BARTYPE_CROSS 0           // ローソク足種別クロス

//+------------------------------------------------------------------+
//| ローソク足クラス                                                    |
//+------------------------------------------------------------------+
class BarInfo
{
    private:
        int _shift;         // 何本前のローソク足
        int _period;        // ローソク足（1分足など）指定
        Currency _open;     // 始値
        Currency _close;    // 終値
        Currency _high;     // 最高値
        Currency _low;      // 最安値
        int _entity_point;  // 実体point
        int _upper_point;   // 上髭point
        int _lower_point;   // 下髭point
        int _barType;       // ローソク足種別

        // 初期化処理
        void _init()
        {
            _open = Currency(iOpen(_Symbol, _period, _shift));
            _close = Currency(iClose(_Symbol, _period, _shift));
            _high = Currency(iHigh(_Symbol, _period, _shift));
            _low = Currency(iLow(_Symbol, _period, _shift));

            // 陽線
            if (_open.getInteger() < _close.getInteger())
            {
                _entity_point = _close.getInteger() - _open.getInteger();
                _upper_point = _high.getInteger() - _close.getInteger();
                _lower_point = _open.getInteger() - _low.getInteger();
                _barType = DA_BARTYPE_WHITE;
            }
            // 陰線
            else if(_open.getInteger() > _close.getInteger())
            {
                _entity_point = _open.getInteger() - _close.getInteger();
                _upper_point = _high.getInteger() - _open.getInteger();
                _lower_point = _close.getInteger() - _low.getInteger();
                _barType = DA_BARTYPE_BLACK;
            }
            // 十字線（始値・終値が同じ）
            else
            {
                _entity_point = 0;
                _upper_point = _high.getInteger() - _close.getInteger();
                _lower_point = _open.getInteger() - _low.getInteger();
                _barType = DA_BARTYPE_CROSS;
            }
        }
    public:
        // コンストラクタ
        BarInfo()
        {
            _shift = 0;
            _period = PERIOD_M5;
        }
        // コンストラクタ（バー指定有り）
        // @param shift  解析したいバーシフト、何本前
        // @param period 解析したいバーの1分足とか5分足とか
        BarInfo(int shift, int period)
        {
            _shift = shift;
            _period = period;
            _init();
        }
        // データリフレッシュ
        void refresh()
        {
            RefreshRates();
            this._init();
        }
        // 陽線か？
        bool isWhite()
        {
            return (_barType == DA_BARTYPE_WHITE);
        }
        // 陰線か？
        bool isBlack()
        {
            return (_barType == DA_BARTYPE_BLACK);
        }
        // 始値取得
        Currency getOpen()
        {
           return _open;
        }
        // 終値取得
        Currency getClose()
        {
            return _close;
        }
        // 最高値取得
        Currency getHigh()
        {
            return _high;
        }
        // 最安値取得
        Currency getLow()
        {
            return _low;
        }
        // 実体取得
        int getEntityPoint()
        {
            return _entity_point;
        }
        // 上髭取得
        int getUpperPoint()
        {
            return _upper_point;
        }
        // 下髭取得
        int getLowerPoint()
        {
            return _lower_point;
        }
        // ローソク足全体の長さ
        int getTotalPips()
        {
            return _entity_point + _upper_point + _lower_point;
        }
};