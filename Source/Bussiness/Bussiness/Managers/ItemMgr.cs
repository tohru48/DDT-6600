// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.ItemMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class ItemMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, ItemTemplateInfo> dictionary_0;
    private static Dictionary<int, LoadUserBoxInfo> dictionary_1;
    private static Dictionary<int, List<ItemTemplateInfo>> dictionary_2;
    private static Dictionary<int, List<ItemTemplateInfo>> dictionary_3;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, ItemTemplateInfo> infos = new Dictionary<int, ItemTemplateInfo>();
        Dictionary<int, LoadUserBoxInfo> userBoxs = new Dictionary<int, LoadUserBoxInfo>();
        if (ItemMgr.LoadItem(infos, userBoxs))
        {
          try
          {
            ItemMgr.dictionary_0 = infos;
            ItemMgr.dictionary_1 = userBoxs;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (ItemMgr.ilog_0.IsErrorEnabled)
          ItemMgr.ilog_0.Error((object) nameof (ReLoad), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        ItemMgr.dictionary_0 = new Dictionary<int, ItemTemplateInfo>();
        ItemMgr.dictionary_1 = new Dictionary<int, LoadUserBoxInfo>();
        flag = ItemMgr.LoadItem(ItemMgr.dictionary_0, ItemMgr.dictionary_1);
      }
      catch (Exception ex)
      {
        if (ItemMgr.ilog_0.IsErrorEnabled)
          ItemMgr.ilog_0.Error((object) nameof (Init), ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadMagicStones(List<ItemTemplateInfo> items)
    {
      ItemMgr.dictionary_2 = new Dictionary<int, List<ItemTemplateInfo>>();
      foreach (ItemTemplateInfo itemTemplateInfo in items)
      {
        ItemTemplateInfo info = itemTemplateInfo;
        if (!ItemMgr.dictionary_2.Keys.Contains<int>(info.Property2))
        {
          IEnumerable<ItemTemplateInfo> source = Enumerable.Where<ItemTemplateInfo>((IEnumerable<ItemTemplateInfo>) items, (Func<ItemTemplateInfo, bool>) (s => s.Property2 == info.Property2 && info.Property3 == 1));
          ItemMgr.dictionary_2.Add(info.Property2, source.ToList<ItemTemplateInfo>());
        }
      }
      return true;
    }

    public static bool LoadRunes(List<ItemTemplateInfo> items)
    {
      ItemMgr.dictionary_3 = new Dictionary<int, List<ItemTemplateInfo>>();
      foreach (ItemTemplateInfo itemTemplateInfo in items)
      {
        ItemTemplateInfo info = itemTemplateInfo;
        if (!ItemMgr.dictionary_3.Keys.Contains<int>(info.Property3))
        {
          IEnumerable<ItemTemplateInfo> source = Enumerable.Where<ItemTemplateInfo>((IEnumerable<ItemTemplateInfo>) items, (Func<ItemTemplateInfo, bool>) (s => s.Property3 == info.Property3 && info.Property1 == 31));
          ItemMgr.dictionary_3.Add(info.Property3, source.ToList<ItemTemplateInfo>());
        }
      }
      return true;
    }

    public static bool LoadItem(
      Dictionary<int, ItemTemplateInfo> infos,
      Dictionary<int, LoadUserBoxInfo> userBoxs)
    {
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
      {
        ItemTemplateInfo[] allGoods = produceBussiness.GetAllGoods();
        List<ItemTemplateInfo> items1 = new List<ItemTemplateInfo>();
        List<ItemTemplateInfo> items2 = new List<ItemTemplateInfo>();
        foreach (ItemTemplateInfo itemTemplateInfo in allGoods)
        {
          if (!infos.Keys.Contains<int>(itemTemplateInfo.TemplateID))
            infos.Add(itemTemplateInfo.TemplateID, itemTemplateInfo);
          if (Equip.isMagicStone(itemTemplateInfo.CategoryID))
            items1.Add(itemTemplateInfo);
          if (itemTemplateInfo.Property1 == 31)
            items2.Add(itemTemplateInfo);
        }
        ItemMgr.LoadMagicStones(items1);
        ItemMgr.LoadRunes(items2);
        foreach (LoadUserBoxInfo loadUserBoxInfo in produceBussiness.GetAllTimeBoxAward())
        {
          if (!userBoxs.Keys.Contains<int>(loadUserBoxInfo.ID))
            userBoxs.Add(loadUserBoxInfo.ID, loadUserBoxInfo);
        }
      }
      return true;
    }

    public static List<ItemTemplateInfo> FindRuneTemplate(int Property3)
    {
      if (ItemMgr.dictionary_3 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_3.Keys.Contains<int>(Property3) ? ItemMgr.dictionary_3[Property3] : (List<ItemTemplateInfo>) null;
    }

    public static LoadUserBoxInfo FindItemBoxTypeAndLv(int type, int lv)
    {
      if (ItemMgr.dictionary_1 == null)
        ItemMgr.Init();
      foreach (LoadUserBoxInfo itemBoxTypeAndLv in ItemMgr.dictionary_1.Values)
      {
        if (itemBoxTypeAndLv.Type == type && itemBoxTypeAndLv.Level == lv)
          return itemBoxTypeAndLv;
      }
      return (LoadUserBoxInfo) null;
    }

    public static List<ItemTemplateInfo> FindMagicStoneTemplate(int Group)
    {
      if (ItemMgr.dictionary_2 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_2.Keys.Contains<int>(Group) ? ItemMgr.dictionary_2[Group] : (List<ItemTemplateInfo>) null;
    }

    public static LoadUserBoxInfo FindItemBoxTemplate(int Id)
    {
      if (ItemMgr.dictionary_1 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_1.Keys.Contains<int>(Id) ? ItemMgr.dictionary_1[Id] : (LoadUserBoxInfo) null;
    }

    public static ItemTemplateInfo FindItemTemplate(int templateId)
    {
      if (ItemMgr.dictionary_0 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_0.Keys.Contains<int>(templateId) ? ItemMgr.dictionary_0[templateId] : (ItemTemplateInfo) null;
    }

    public static ItemTemplateInfo[] GetAllItemTemplate()
    {
      if (ItemMgr.dictionary_0 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_0.Values.ToArray<ItemTemplateInfo>();
    }

    public static ItemTemplateInfo FindGoldItemTemplate(int templateId, bool IsGold)
    {
      if (!IsGold)
        return (ItemTemplateInfo) null;
      GoldEquipTemplateInfo goldEquipByTemplate = GoldEquipMgr.FindGoldEquipByTemplate(templateId);
      if (goldEquipByTemplate == null)
        return (ItemTemplateInfo) null;
      if (ItemMgr.dictionary_0 == null)
        ItemMgr.Init();
      return ItemMgr.dictionary_0.Keys.Contains<int>(goldEquipByTemplate.NewTemplateId) ? ItemMgr.dictionary_0[goldEquipByTemplate.NewTemplateId] : (ItemTemplateInfo) null;
    }

    public static ItemTemplateInfo GetGoodsbyFusionTypeandQuality(int fusionType, int quality)
    {
      if (ItemMgr.dictionary_0 == null)
        ItemMgr.Init();
      foreach (ItemTemplateInfo fusionTypeandQuality in ItemMgr.dictionary_0.Values)
      {
        if (fusionTypeandQuality.FusionType == fusionType && fusionTypeandQuality.Quality == quality)
          return fusionTypeandQuality;
      }
      return (ItemTemplateInfo) null;
    }

    public static ItemTemplateInfo GetGoodsbyFusionTypeandLevel(int fusionType, int level)
    {
      if (ItemMgr.dictionary_0 == null)
        ItemMgr.Init();
      foreach (ItemTemplateInfo fusionTypeandLevel in ItemMgr.dictionary_0.Values)
      {
        if (fusionTypeandLevel.FusionType == fusionType && fusionTypeandLevel.Level == level)
          return fusionTypeandLevel;
      }
      return (ItemTemplateInfo) null;
    }

    public static List<SqlDataProvider.Data.ItemInfo> SpiltGoodsMaxCount(SqlDataProvider.Data.ItemInfo itemInfo)
    {
      List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
      for (int index = 0; index < itemInfo.Count; index += itemInfo.Template.MaxCount)
      {
        int num = itemInfo.Count < itemInfo.Template.MaxCount ? itemInfo.Count : itemInfo.Template.MaxCount;
        SqlDataProvider.Data.ItemInfo itemInfo1 = itemInfo.Clone();
        itemInfo1.Count = num;
        itemInfoList.Add(itemInfo1);
      }
      return itemInfoList;
    }
  }
}
