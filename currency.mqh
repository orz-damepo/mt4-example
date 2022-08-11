//+------------------------------------------------------------------+
//|                                                  currency.mqh    |
//|                                     Copyright 2022, Damepo Taro. |
//|                                           https://orz.damepo.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Damepo Taro."
#property link      "https://orz.damepo.net"
#property version   "1.0"
#property strict

//+------------------------------------------------------------------+
//| 通貨クラス                                                         |
//+------------------------------------------------------------------+
class Currency
{
    private:
        int _ivalue;
        string _svalue;
        // double to integer
        int _d2i(double value)
        {
            string tmp = DoubleToString(value, _Digits);
            StringReplace(tmp, ".", "");
            return StringToInteger(tmp);
        }
        // integer to double string
        string _i2s(int value)
        {
            // ドル円仕様なので6桁ゼロ埋めとしている
            string tmpStr = IntegerToString(value, 6, '0');
            int len = StringLen(tmpStr);
            string left = StringSubstr(tmpStr, 0, len - _Digits);
            int tmpInt = StringToInteger(left);
            left = IntegerToString(tmpInt);
            string right = StringSubstr(tmpStr, len - _Digits, _Digits);
            return StringConcatenate(left, ".", right);
        }
        // 小数点以下の値を取得
        int _decimal()
        {
            int len = StringLen(_svalue);
            string right = StringSubstr(_svalue, len - _Digits, _Digits);
            return StringToInteger(right);
        }
    public:
        // コンストラクタ
        Currency()
        {
            _ivalue = 0;
            _svalue = _i2s(_ivalue);
        }
        // コンストラクタ
        Currency(int value)
        {
            _ivalue = value;
            _svalue = _i2s(_ivalue);
        }
        // コンストラクタ
        Currency(double value)
        {
            _ivalue = _d2i(value);
            _svalue = _i2s(_ivalue);
        }
        // コピーコンストラクタ
        Currency(const Currency &src)
        {
            _ivalue = src._ivalue;
            _svalue = src._svalue;
        }
        // int型取得
        int getInteger()
        {
            return _ivalue;
        }
        // double型取得
        double getDouble()
        {
            return StringToDouble(_svalue);
        }
        // string型取得
        string getString()
        {
            return _svalue;
        }
        // 小数部分の値取得
        int getDecimal()
        {
            return _decimal();
        }
        // point加算
        void addPoint(int point)
        {
            _ivalue = _ivalue + point;
            _svalue = _i2s(_ivalue);
        }
};
// 加算
Currency addCurrency(Currency &val1, Currency &val2)
{
    int new_int = val1.getInteger() + val2.getInteger();
    Currency new_currency(new_int);
    return new_currency;
}
// 減算
Currency subCurrency(Currency &val1, Currency &val2)
{
    int new_int = val1.getInteger() - val2.getInteger();
    Currency new_currency(new_int);
    return new_currency;
}
