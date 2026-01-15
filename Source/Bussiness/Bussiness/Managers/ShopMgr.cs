// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ShopMgr
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
  public static class ShopMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ShopItemInfo> dictionary_0 = new Dictionary<int, ShopItemInfo>();
    private static Dictionary<int, ShopGoodsShowListInfo> dictionary_1 = new Dictionary<int, ShopGoodsShowListInfo>();
    private static Dictionary<int, List<ShopGoodsShowListInfo>> dictionary_2 = new Dictionary<int, List<ShopGoodsShowListInfo>>();
    private static Dictionary<int, ShopCheapItemsInfo> dictionary_3 = new Dictionary<int, ShopCheapItemsInfo>();

    public static bool Init() => ShopMgr.ReLoad();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ShopItemInfo> dictionary1 = ShopMgr.smethod_0();
        Dictionary<int, ShopGoodsShowListInfo> dictionary2 = ShopMgr.smethod_1();
        if (dictionary1.Count > 0)
          Interlocked.Exchange<Dictionary<int, ShopItemInfo>>(ref ShopMgr.dictionary_0, dictionary1);
        if (dictionary2.Count > 0)
          Interlocked.Exchange<Dictionary<int, ShopGoodsShowListInfo>>(ref ShopMgr.dictionary_1, dictionary2);
        ShopGoodsShowListInfo[] ShopGoodsShowList = ShopMgr.LoadShopGoodsShowListDb();
        Dictionary<int, List<ShopGoodsShowListInfo>> dictionary3 = ShopMgr.LoadShopGoodsShowLists(ShopGoodsShowList);
        if (ShopGoodsShowList.Length > 0)
          Interlocked.Exchange<Dictionary<int, List<ShopGoodsShowListInfo>>>(ref ShopMgr.dictionary_2, dictionary3);
        ShopCheapItemsInfo[] ShopCheapItems = ShopMgr.LoadShopCheapItemsDb();
        Dictionary<int, ShopCheapItemsInfo> dictionary4 = ShopMgr.LoadShopCheapItemss(ShopCheapItems);
        if (ShopCheapItems.Length > 0)
          Interlocked.Exchange<Dictionary<int, ShopCheapItemsInfo>>(ref ShopMgr.dictionary_3, dictionary4);
        return true;
      }
      catch (Exception ex)
      {
        ShopMgr.ilog_0.Error((object) "ShopInfoMgr", ex);
      }
      return false;
    }

    public static ShopCheapItemsInfo[] LoadShopCheapItemsDb()
    {
      ShopCheapItemsInfo[] allShopCheapItems;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allShopCheapItems = produceBussiness.GetAllShopCheapItems();
      return allShopCheapItems;
    }

    public static Dictionary<int, ShopCheapItemsInfo> LoadShopCheapItemss(
      ShopCheapItemsInfo[] ShopCheapItems)
    {
      Dictionary<int, ShopCheapItemsInfo> dictionary = new Dictionary<int, ShopCheapItemsInfo>();
      for (int index = 0; index < ShopCheapItems.Length; ++index)
      {
        ShopCheapItemsInfo shopCheapItem = ShopCheapItems[index];
        if (!dictionary.Keys.Contains<int>(shopCheapItem.ID))
          dictionary.Add(shopCheapItem.ID, shopCheapItem);
      }
      return dictionary;
    }

    public static ShopCheapItemsInfo FindShopCheapItems(int ID)
    {
      return ShopMgr.dictionary_3.ContainsKey(ID) ? ShopMgr.dictionary_3[ID] : (ShopCheapItemsInfo) null;
    }

    public static ShopCheapItemsInfo[] GetAllShopCheapItems()
    {
      return ShopMgr.dictionary_3.Values.ToArray<ShopCheapItemsInfo>();
    }

    public static ShopGoodsShowListInfo[] LoadShopGoodsShowListDb()
    {
      ShopGoodsShowListInfo[] shopGoodsShowList;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        shopGoodsShowList = produceBussiness.GetAllShopGoodsShowList();
      return shopGoodsShowList;
    }

    public static Dictionary<int, List<ShopGoodsShowListInfo>> LoadShopGoodsShowLists(
      ShopGoodsShowListInfo[] ShopGoodsShowList)
    {
      Dictionary<int, List<ShopGoodsShowListInfo>> dictionary = new Dictionary<int, List<ShopGoodsShowListInfo>>();
      for (int index = 0; index < ShopGoodsShowList.Length; ++index)
      {
        ShopGoodsShowListInfo info = ShopGoodsShowList[index];
        if (!dictionary.Keys.Contains<int>(info.Type))
        {
          IEnumerable<ShopGoodsShowListInfo> source = Enumerable.Where<ShopGoodsShowListInfo>((IEnumerable<ShopGoodsShowListInfo>) ShopGoodsShowList, (Func<ShopGoodsShowListInfo, bool>) (s => s.Type == info.Type));
          dictionary.Add(info.Type, source.ToList<ShopGoodsShowListInfo>());
        }
      }
      return dictionary;
    }

    public static List<ShopGoodsShowListInfo> FindShopGoodsShowList(int type)
    {
      return ShopMgr.dictionary_2.ContainsKey(type) ? ShopMgr.dictionary_2[type] : (List<ShopGoodsShowListInfo>) null;
    }

    private static Dictionary<int, ShopItemInfo> smethod_0()
    {
      Dictionary<int, ShopItemInfo> dictionary = new Dictionary<int, ShopItemInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ShopItemInfo shopItemInfo in produceBussiness.method_0())
        {
          if (!dictionary.ContainsKey(shopItemInfo.ID))
            dictionary.Add(shopItemInfo.ID, shopItemInfo);
        }
      }
      return dictionary;
    }

    private static Dictionary<int, ShopGoodsShowListInfo> smethod_1()
    {
      Dictionary<int, ShopGoodsShowListInfo> dictionary = new Dictionary<int, ShopGoodsShowListInfo>();
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        foreach (ShopGoodsShowListInfo allShopGoodsShow in produceBussiness.GetAllShopGoodsShowList())
        {
          if (!dictionary.ContainsKey(allShopGoodsShow.ShopId))
            dictionary.Add(allShopGoodsShow.ShopId, allShopGoodsShow);
        }
      }
      return dictionary;
    }

    public static bool IsOnShop(int Id)
    {
      if (ShopMgr.dictionary_1 == null)
        ShopMgr.ReLoad();
      if (ShopMgr.IsSpecialItem(Id))
        return true;
      return ShopMgr.dictionary_3.ContainsKey(Id) ? ShopMgr.dictionary_3[Id].EndDate > DateTime.Now : ShopMgr.dictionary_1.ContainsKey(Id);
    }

    public static bool IsSpecialItem(int Id)
    {
      if (Id <= 1100801)
      {
        if (Id == 1100401 || Id == 1100801)
          return true;
      }
      else if (Id == 1101201 || Id == 1101601)
        return true;
      return false;
    }

    public static ShopItemInfo GetShopItemInfoById(int ID)
    {
      return ShopMgr.dictionary_0.ContainsKey(ID) ? ShopMgr.dictionary_0[ID] : (ShopItemInfo) null;
    }

    public static ShopItemInfo GetShopItemDisCountById(int ID)
    {
      if (!ShopMgr.dictionary_3.ContainsKey(ID))
        return (ShopItemInfo) null;
      ShopCheapItemsInfo shopCheapItemsInfo = ShopMgr.dictionary_3[ID];
      return new ShopItemInfo()
      {
        ID = shopCheapItemsInfo.ID,
        ShopID = 3,
        TemplateID = shopCheapItemsInfo.TemplateID,
        Label = shopCheapItemsInfo.LableType,
        AUnit = shopCheapItemsInfo.AUnit,
        APrice1 = shopCheapItemsInfo.APrice,
        AValue1 = shopCheapItemsInfo.AValue,
        BUnit = shopCheapItemsInfo.BUnit,
        BPrice1 = shopCheapItemsInfo.BPrice,
        BValue1 = shopCheapItemsInfo.BValue,
        CUnit = shopCheapItemsInfo.CUnit,
        CPrice1 = shopCheapItemsInfo.CPrice,
        CValue1 = shopCheapItemsInfo.CValue,
        APrice3 = shopCheapItemsInfo.APrice,
        APrice2 = shopCheapItemsInfo.APrice,
        BPrice3 = shopCheapItemsInfo.BPrice,
        BPrice2 = shopCheapItemsInfo.BPrice,
        CPrice3 = shopCheapItemsInfo.CPrice,
        CPrice2 = shopCheapItemsInfo.CPrice,
        Beat = 1M
      };
    }

    public static bool CanBuy(
      int shopID,
      int consortiaShopLevel,
      ref bool isBinds,
      int cousortiaID,
      int playerRiches)
    {
      bool flag = false;
      using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
      {
        switch (shopID)
        {
          case 1:
            flag = true;
            isBinds = false;
            goto label_20;
          case 2:
          case 3:
          case 4:
            flag = true;
            isBinds = true;
            goto label_20;
          case 11:
            ConsortiaEquipControlInfo consortiaEuqipRiches1 = consortiaBussiness.GetConsortiaEuqipRiches(cousortiaID, 1, 1);
            if (consortiaShopLevel >= consortiaEuqipRiches1.Level && playerRiches >= consortiaEuqipRiches1.Riches)
            {
              flag = true;
              isBinds = true;
              goto label_20;
            }
            else
              goto label_20;
          case 12:
            ConsortiaEquipControlInfo consortiaEuqipRiches2 = consortiaBussiness.GetConsortiaEuqipRiches(cousortiaID, 2, 1);
            if (consortiaShopLevel >= consortiaEuqipRiches2.Level && playerRiches >= consortiaEuqipRiches2.Riches)
            {
              flag = true;
              isBinds = true;
              goto label_20;
            }
            else
              goto label_20;
          case 13:
            ConsortiaEquipControlInfo consortiaEuqipRiches3 = consortiaBussiness.GetConsortiaEuqipRiches(cousortiaID, 3, 1);
            if (consortiaShopLevel >= consortiaEuqipRiches3.Level && playerRiches >= consortiaEuqipRiches3.Riches)
            {
              flag = true;
              isBinds = true;
              goto label_20;
            }
            else
              goto label_20;
          case 14:
            ConsortiaEquipControlInfo consortiaEuqipRiches4 = consortiaBussiness.GetConsortiaEuqipRiches(cousortiaID, 4, 1);
            if (consortiaShopLevel >= consortiaEuqipRiches4.Level && playerRiches >= consortiaEuqipRiches4.Riches)
            {
              flag = true;
              isBinds = true;
              goto label_20;
            }
            else
              goto label_20;
          case 15:
            ConsortiaEquipControlInfo consortiaEuqipRiches5 = consortiaBussiness.GetConsortiaEuqipRiches(cousortiaID, 5, 1);
            if (consortiaShopLevel >= consortiaEuqipRiches5.Level && playerRiches >= consortiaEuqipRiches5.Riches)
            {
              flag = true;
              isBinds = true;
              goto label_20;
            }
            else
              goto label_20;
          case 72:
          case 90:
          case 91:
          case 92:
          case 93:
          case 94:
          case 95:
          case 98:
          case 99:
          case 100:
          case 110:
            flag = true;
            isBinds = true;
            goto label_20;
        }
        Console.WriteLine("CanBuy: {0}", (object) shopID);
      }
label_20:
      return flag;
    }

    public static bool FindSpecialItemInfo(SqlDataProvider.Data.ItemInfo info, ref SpecialItemBoxInfo specialValue)
    {
      switch (info.TemplateID)
      {
        case -1800:
          specialValue.EquestrianScore += info.Count;
          return true;
        case -1700:
          specialValue.LaurelScore += info.Count;
          return true;
        case -1600:
          specialValue.SummerScore += info.Count;
          return true;
        case -1500:
          specialValue.LoveScore += info.Count;
          return true;
        case -1400:
          specialValue.MagicstoneScore += info.Count;
          return true;
        case -1300:
          specialValue.Prestge += info.Count;
          return true;
        case -1200:
          specialValue.UseableScore += info.Count;
          return true;
        case -1100:
          specialValue.DDTMoney += info.Count;
          return true;
        case -1000:
          specialValue.LeagueMoney += info.Count;
          return true;
        case -900:
          specialValue.HardCurrency += info.Count;
          return true;
        case -800:
          specialValue.Honor += info.Count;
          return true;
        case -300:
          specialValue.Medal += info.Count;
          return true;
        case -200:
          specialValue.Money += info.Count;
          return true;
        case -100:
          specialValue.Gold += info.Count;
          return true;
        default:
          return false;
      }
    }

    public static bool SetItemType(
      ShopItemInfo shop,
      int type,
      ref SpecialItemBoxInfo specialValue)
    {
      if (type == 1)
      {
        ShopMgr.GetItemPrice(shop.APrice1, shop.AValue1, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.APrice2, shop.AValue2, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.APrice3, shop.AValue3, shop.Beat, ref specialValue);
      }
      if (type == 2)
      {
        ShopMgr.GetItemPrice(shop.BPrice1, shop.BValue1, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.BPrice2, shop.BValue2, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.BPrice3, shop.BValue3, shop.Beat, ref specialValue);
      }
      if (type == 3)
      {
        ShopMgr.GetItemPrice(shop.CPrice1, shop.CValue1, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.CPrice2, shop.CValue2, shop.Beat, ref specialValue);
        ShopMgr.GetItemPrice(shop.CPrice3, shop.CValue3, shop.Beat, ref specialValue);
      }
      return true;
    }

    public static void GetItemPrice(
      int Prices,
      int Values,
      Decimal beat,
      ref SpecialItemBoxInfo specialValue)
    {
      switch (Prices)
      {
        case -1800:
          specialValue.EquestrianScore += (int) ((Decimal) Values * beat);
          break;
        case -1700:
          specialValue.LaurelScore += (int) ((Decimal) Values * beat);
          break;
        case -1600:
          specialValue.SummerScore += (int) ((Decimal) Values * beat);
          break;
        case -1500:
          specialValue.LoveScore += (int) ((Decimal) Values * beat);
          break;
        case -1400:
          specialValue.MagicstoneScore += (int) ((Decimal) Values * beat);
          break;
        case -1300:
          specialValue.Prestge += (int) ((Decimal) Values * beat);
          break;
        case -1200:
          specialValue.UseableScore += (int) ((Decimal) Values * beat);
          break;
        case -1000:
          specialValue.LeagueMoney += (int) ((Decimal) Values * beat);
          break;
        case -900:
          specialValue.HardCurrency += (int) ((Decimal) Values * beat);
          break;
        case -800:
          specialValue.Honor += (int) ((Decimal) Values * beat);
          break;
        case -300:
          specialValue.Medal += (int) ((Decimal) Values * beat);
          break;
        case -8:
          specialValue.PetScore += (int) ((Decimal) Values * beat);
          break;
        case -7:
          specialValue.DamageScore += (int) ((Decimal) Values * beat);
          break;
        case -6:
          break;
        case -4:
          specialValue.Offer += (int) ((Decimal) Values * beat);
          break;
        case -3:
          specialValue.Gold += (int) ((Decimal) Values * beat);
          break;
        case -2:
          specialValue.DDTMoney += (int) ((Decimal) Values * beat);
          break;
        case -1:
          specialValue.Money += (int) ((Decimal) Values * beat);
          break;
        default:
          if (Prices <= 0)
            break;
          specialValue.Int32_0 = Prices;
          specialValue.iCount = Values;
          break;
      }
    }

    public static int FindItemTemplateID(int id)
    {
      return ShopMgr.dictionary_0.ContainsKey(id) ? ShopMgr.dictionary_0[id].TemplateID : 0;
    }

    public static List<ShopItemInfo> FindShopbyTemplatID(int TemplatID)
    {
      List<ShopItemInfo> shopbyTemplatId = new List<ShopItemInfo>();
      foreach (ShopItemInfo shopItemInfo in ShopMgr.dictionary_0.Values)
      {
        if (shopItemInfo.TemplateID == TemplatID)
          shopbyTemplatId.Add(shopItemInfo);
      }
      return shopbyTemplatId;
    }

    public static ShopItemInfo FindShopbyTemplateID(int TemplatID)
    {
      foreach (ShopItemInfo shopbyTemplateId in ShopMgr.dictionary_0.Values)
      {
        if (shopbyTemplateId.TemplateID == TemplatID)
          return shopbyTemplateId;
      }
      return (ShopItemInfo) null;
    }
  }
}
