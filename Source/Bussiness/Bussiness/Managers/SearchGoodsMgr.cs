// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.SearchGoodsMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Bussiness.Managers
{
  public class SearchGoodsMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, SearchGoodsPayMoneyInfo> dictionary_0;
    private static Dictionary<int, SearchGoodsTempInfo> dictionary_1;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        SearchGoodsPayMoneyInfo[] SearchGoodsPayMoney = SearchGoodsMgr.LoadSearchGoodsPayMoneyDb();
        Dictionary<int, SearchGoodsPayMoneyInfo> dictionary1 = SearchGoodsMgr.LoadSearchGoodsPayMoneys(SearchGoodsPayMoney);
        if (SearchGoodsPayMoney.Length > 0)
          Interlocked.Exchange<Dictionary<int, SearchGoodsPayMoneyInfo>>(ref SearchGoodsMgr.dictionary_0, dictionary1);
        SearchGoodsTempInfo[] SearchGoodsTemp = SearchGoodsMgr.LoadSearchGoodsTempDb();
        Dictionary<int, SearchGoodsTempInfo> dictionary2 = SearchGoodsMgr.LoadSearchGoodsTemps(SearchGoodsTemp);
        if (SearchGoodsTemp.Length > 0)
          Interlocked.Exchange<Dictionary<int, SearchGoodsTempInfo>>(ref SearchGoodsMgr.dictionary_1, dictionary2);
        return true;
      }
      catch (Exception ex)
      {
        if (SearchGoodsMgr.ilog_0.IsErrorEnabled)
          SearchGoodsMgr.ilog_0.Error((object) "ReLoad SearchGoods", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => SearchGoodsMgr.ReLoad();

    public static SearchGoodsTempInfo GetSearchGoodsTempInfo(int starId)
    {
      return SearchGoodsMgr.dictionary_1.ContainsKey(starId) ? SearchGoodsMgr.dictionary_1[starId] : (SearchGoodsTempInfo) null;
    }

    public static int MaxStar() => SearchGoodsMgr.dictionary_1.Count;

    public static SearchGoodsTempInfo[] LoadSearchGoodsTempDb()
    {
      SearchGoodsTempInfo[] allSearchGoodsTemp;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allSearchGoodsTemp = produceBussiness.GetAllSearchGoodsTemp();
      return allSearchGoodsTemp;
    }

    public static Dictionary<int, SearchGoodsTempInfo> LoadSearchGoodsTemps(
      SearchGoodsTempInfo[] SearchGoodsTemp)
    {
      Dictionary<int, SearchGoodsTempInfo> dictionary = new Dictionary<int, SearchGoodsTempInfo>();
      for (int index = 0; index < SearchGoodsTemp.Length; ++index)
      {
        SearchGoodsTempInfo searchGoodsTempInfo = SearchGoodsTemp[index];
        if (!dictionary.Keys.Contains<int>(searchGoodsTempInfo.StarID))
          dictionary.Add(searchGoodsTempInfo.StarID, searchGoodsTempInfo);
      }
      return dictionary;
    }

    public static SearchGoodsTempInfo FindSearchGoodsTemp(int ID)
    {
      return SearchGoodsMgr.dictionary_1.ContainsKey(ID) ? SearchGoodsMgr.dictionary_1[ID] : (SearchGoodsTempInfo) null;
    }

    public static SearchGoodsPayMoneyInfo[] LoadSearchGoodsPayMoneyDb()
    {
      SearchGoodsPayMoneyInfo[] searchGoodsPayMoney;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        searchGoodsPayMoney = produceBussiness.GetAllSearchGoodsPayMoney();
      return searchGoodsPayMoney;
    }

    public static Dictionary<int, SearchGoodsPayMoneyInfo> LoadSearchGoodsPayMoneys(
      SearchGoodsPayMoneyInfo[] SearchGoodsPayMoney)
    {
      Dictionary<int, SearchGoodsPayMoneyInfo> dictionary = new Dictionary<int, SearchGoodsPayMoneyInfo>();
      for (int index = 0; index < SearchGoodsPayMoney.Length; ++index)
      {
        SearchGoodsPayMoneyInfo goodsPayMoneyInfo = SearchGoodsPayMoney[index];
        if (!dictionary.Keys.Contains<int>(goodsPayMoneyInfo.Number))
          dictionary.Add(goodsPayMoneyInfo.Number, goodsPayMoneyInfo);
      }
      return dictionary;
    }

    public static SearchGoodsPayMoneyInfo FindSearchGoodsPayMoney(int ID)
    {
      return SearchGoodsMgr.dictionary_0.ContainsKey(ID) ? SearchGoodsMgr.dictionary_0[ID] : (SearchGoodsPayMoneyInfo) null;
    }
  }
}
