// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ItemBoxMgr
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
  public class ItemBoxMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static ItemBoxInfo[] itemBoxInfo_0;
    private static Dictionary<int, List<ItemBoxInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        ItemBoxInfo[] itemBoxs = ItemBoxMgr.LoadItemBoxDb();
        Dictionary<int, List<ItemBoxInfo>> dictionary = ItemBoxMgr.LoadItemBoxs(itemBoxs);
        if (itemBoxs != null)
        {
          Interlocked.Exchange<ItemBoxInfo[]>(ref ItemBoxMgr.itemBoxInfo_0, itemBoxs);
          Interlocked.Exchange<Dictionary<int, List<ItemBoxInfo>>>(ref ItemBoxMgr.dictionary_0, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (ItemBoxMgr.ilog_0.IsErrorEnabled)
          ItemBoxMgr.ilog_0.Error((object) nameof (ReLoad), ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => ItemBoxMgr.ReLoad();

    public static ItemBoxInfo[] LoadItemBoxDb()
    {
      ItemBoxInfo[] itemBoxInfos;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        itemBoxInfos = produceBussiness.GetItemBoxInfos();
      return itemBoxInfos;
    }

    public static Dictionary<int, List<ItemBoxInfo>> LoadItemBoxs(ItemBoxInfo[] itemBoxs)
    {
      Dictionary<int, List<ItemBoxInfo>> dictionary = new Dictionary<int, List<ItemBoxInfo>>();
      for (int index = 0; index < itemBoxs.Length; ++index)
      {
        ItemBoxInfo info = itemBoxs[index];
        if (!dictionary.Keys.Contains<int>(info.ID))
        {
          IEnumerable<ItemBoxInfo> source = Enumerable.Where<ItemBoxInfo>((IEnumerable<ItemBoxInfo>) itemBoxs, (Func<ItemBoxInfo, bool>) (s => s.ID == info.ID));
          dictionary.Add(info.ID, source.ToList<ItemBoxInfo>());
        }
      }
      return dictionary;
    }

    public static List<ItemBoxInfo> FindItemBox(int DataId)
    {
      return ItemBoxMgr.dictionary_0.ContainsKey(DataId) ? ItemBoxMgr.dictionary_0[DataId] : (List<ItemBoxInfo>) null;
    }

    public static List<SqlDataProvider.Data.ItemInfo> GetAllItemBoxAward(int DataId)
    {
      List<ItemBoxInfo> itemBox = ItemBoxMgr.FindItemBox(DataId);
      List<SqlDataProvider.Data.ItemInfo> allItemBoxAward = new List<SqlDataProvider.Data.ItemInfo>();
      foreach (ItemBoxInfo itemBoxInfo in itemBox)
      {
        SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(itemBoxInfo.TemplateId), itemBoxInfo.ItemCount, 105);
        fromTemplate.IsBinds = itemBoxInfo.IsBind;
        fromTemplate.ValidDate = itemBoxInfo.ItemValid;
        allItemBoxAward.Add(fromTemplate);
      }
      return allItemBoxAward;
    }

    public static bool CreateItemBox(
      int DateId,
      List<SqlDataProvider.Data.ItemInfo> itemInfos,
      ref SpecialItemBoxInfo specialValue)
    {
      List<ItemBoxInfo> itemBoxInfoList1 = new List<ItemBoxInfo>();
      List<ItemBoxInfo> itemBox = ItemBoxMgr.FindItemBox(DateId);
      if (itemBox == null)
        return false;
      List<ItemBoxInfo> itemBoxInfoList2 = Enumerable.Where<ItemBoxInfo>((IEnumerable<ItemBoxInfo>) itemBox, (Func<ItemBoxInfo, bool>) (itemBoxInfo_1 => itemBoxInfo_1.IsSelect)).ToList<ItemBoxInfo>();
      int num1 = 1;
      int maxRound = 0;
      if (itemBoxInfoList2.Count < itemBox.Count)
        maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<ItemBoxInfo, int>(Enumerable.Where<ItemBoxInfo>((IEnumerable<ItemBoxInfo>) itemBox, (Func<ItemBoxInfo, bool>) (itemBoxInfo_1 => !itemBoxInfo_1.IsSelect)), (Func<ItemBoxInfo, int>) (itemBoxInfo_1 => itemBoxInfo_1.Random)).Max());
      List<ItemBoxInfo> list = Enumerable.Where<ItemBoxInfo>((IEnumerable<ItemBoxInfo>) itemBox, (Func<ItemBoxInfo, bool>) (s => !s.IsSelect && s.Random >= maxRound)).ToList<ItemBoxInfo>();
      int num2 = list.Count<ItemBoxInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in ItemBoxMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          ItemBoxInfo itemBoxInfo = list[randomUnrepeat];
          if (itemBoxInfoList2 == null)
            itemBoxInfoList2 = new List<ItemBoxInfo>();
          itemBoxInfoList2.Add(itemBoxInfo);
        }
      }
      foreach (ItemBoxInfo itemBoxInfo in itemBoxInfoList2)
      {
        if (itemBoxInfo == null)
          return false;
        switch (itemBoxInfo.TemplateId)
        {
          case -1800:
            specialValue.EquestrianScore += itemBoxInfo.ItemCount;
            continue;
          case -1700:
            specialValue.LaurelScore += itemBoxInfo.ItemCount;
            continue;
          case -1600:
            specialValue.SummerScore += itemBoxInfo.ItemCount;
            continue;
          case -1500:
            specialValue.LoveScore += itemBoxInfo.ItemCount;
            continue;
          case -1400:
            specialValue.MagicstoneScore += itemBoxInfo.ItemCount;
            continue;
          case -1300:
            specialValue.Prestge += itemBoxInfo.ItemCount;
            continue;
          case -1200:
            specialValue.UseableScore += itemBoxInfo.ItemCount;
            continue;
          case -1100:
            specialValue.DDTMoney += itemBoxInfo.ItemCount;
            continue;
          case -1000:
            specialValue.LeagueMoney += itemBoxInfo.ItemCount;
            continue;
          case -900:
            specialValue.HardCurrency += itemBoxInfo.ItemCount;
            continue;
          case -800:
            int maxValue = itemBoxInfo.ItemCount;
            if (itemBoxInfo.ItemCount <= 1)
              maxValue = 2;
            specialValue.Honor += ItemBoxMgr.threadSafeRandom_0.Next(1, maxValue);
            continue;
          case -300:
            specialValue.Medal += itemBoxInfo.ItemCount;
            continue;
          case -200:
            specialValue.Money += itemBoxInfo.ItemCount;
            continue;
          case -100:
            specialValue.Gold += itemBoxInfo.ItemCount;
            continue;
          case 11107:
            specialValue.Exp += itemBoxInfo.ItemCount;
            continue;
          default:
            ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(itemBoxInfo.TemplateId);
            SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, itemBoxInfo.ItemCount, 101);
            if (fromTemplate != null)
            {
              if (itemTemplate.CategoryID == 61)
              {
                SqlDataProvider.Data.ItemInfo magicStoneInfo = MagicStoneMgr.GetMagicStoneInfo(itemTemplate, 1);
                if (magicStoneInfo != null)
                {
                  fromTemplate.StrengthenLevel = magicStoneInfo.StrengthenLevel;
                  fromTemplate.StrengthenExp = magicStoneInfo.StrengthenExp;
                  fromTemplate.AttackCompose = magicStoneInfo.AttackCompose;
                  fromTemplate.DefendCompose = magicStoneInfo.DefendCompose;
                  fromTemplate.AgilityCompose = magicStoneInfo.AgilityCompose;
                  fromTemplate.LuckCompose = magicStoneInfo.LuckCompose;
                  fromTemplate.MagicAttack = magicStoneInfo.MagicAttack;
                  fromTemplate.MagicDefence = magicStoneInfo.MagicDefence;
                  fromTemplate.goodsLock = false;
                }
              }
              else
              {
                fromTemplate.StrengthenLevel = itemBoxInfo.StrengthenLevel;
                fromTemplate.AttackCompose = itemBoxInfo.AttackCompose;
                fromTemplate.DefendCompose = itemBoxInfo.DefendCompose;
                fromTemplate.AgilityCompose = itemBoxInfo.AgilityCompose;
                fromTemplate.LuckCompose = itemBoxInfo.LuckCompose;
              }
              fromTemplate.IsBinds = itemBoxInfo.IsBind;
              fromTemplate.ValidDate = itemBoxInfo.ItemValid;
              fromTemplate.Count = itemBoxInfo.ItemCount;
              fromTemplate.IsTips = itemBoxInfo.IsTips != 0;
              fromTemplate.IsLogs = itemBoxInfo.IsLogs;
              if (itemInfos == null)
                itemInfos = new List<SqlDataProvider.Data.ItemInfo>();
              itemInfos.Add(fromTemplate);
            }
            continue;
        }
      }
      return true;
    }

    public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
    {
      int[] randomUnrepeatArray = new int[count];
      for (int index1 = 0; index1 < count; ++index1)
      {
        int num1 = ItemBoxMgr.threadSafeRandom_0.Next(minValue, maxValue + 1);
        int num2 = 0;
        for (int index2 = 0; index2 < index1; ++index2)
        {
          if (randomUnrepeatArray[index2] == num1)
            ++num2;
        }
        if (num2 == 0)
          randomUnrepeatArray[index1] = num1;
        else
          --index1;
      }
      return randomUnrepeatArray;
    }
  }
}
