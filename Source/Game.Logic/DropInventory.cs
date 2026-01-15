// Decompiled with JetBrains decompiler
// Type: Game.Logic.DropInventory
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Game.Logic
{
  public class DropInventory
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    public static int roundDate = 0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static List<SqlDataProvider.Data.ItemInfo> CopySystemDrop(int copyId, int OpenCount)
    {
      int int32_1 = Convert.ToInt32((double) OpenCount * 0.1);
      int int32_2 = Convert.ToInt32((double) OpenCount * 0.3);
      int num = OpenCount - int32_1 - int32_2;
      List<SqlDataProvider.Data.ItemInfo> list = new List<SqlDataProvider.Data.ItemInfo>();
      List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
      int int_0_1 = DropInventory.smethod_0(eDropType.Copy, copyId.ToString(), "2");
      if (int_0_1 > 0)
      {
        for (int index = 0; index < int32_1; ++index)
        {
          if (DropInventory.smethod_2(eDropType.Copy, int_0_1, ref list_0) && list_0 != null)
          {
            list.Add(list_0[0]);
            list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
          }
        }
      }
      int int_0_2 = DropInventory.smethod_0(eDropType.Copy, copyId.ToString(), "3");
      if (int_0_2 > 0)
      {
        for (int index = 0; index < int32_2; ++index)
        {
          if (DropInventory.smethod_2(eDropType.Copy, int_0_2, ref list_0) && list_0 != null)
          {
            list.Add(list_0[0]);
            list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
          }
        }
      }
      int int_0_3 = DropInventory.smethod_0(eDropType.Copy, copyId.ToString(), "4");
      if (int_0_3 > 0)
      {
        for (int index = 0; index < num; ++index)
        {
          if (DropInventory.smethod_2(eDropType.Copy, int_0_3, ref list_0) && list_0 != null)
          {
            list.Add(list_0[0]);
            list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
          }
        }
      }
      return DropInventory.RandomSortList(list);
    }

    public static List<SqlDataProvider.Data.ItemInfo> RandomSortList(List<SqlDataProvider.Data.ItemInfo> list)
    {
      return Enumerable.OrderBy<SqlDataProvider.Data.ItemInfo, int>((IEnumerable<SqlDataProvider.Data.ItemInfo>) list, (Func<SqlDataProvider.Data.ItemInfo, int>) (itemInfo_0 => DropInventory.threadSafeRandom_0.Next())).ToList<SqlDataProvider.Data.ItemInfo>();
    }

    public static bool CardDrop(eRoomType e, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Cards, ((int) e).ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Cards, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool BoxDrop(eRoomType e, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Box, ((int) e).ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Box, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool NPCDrop(int dropId, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      if (dropId > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.NPC, dropId, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool BossDrop(int missionId, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Boss, missionId.ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Boss, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool CopyDrop(int copyId, int user, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Copy, copyId.ToString(), user.ToString());
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Copy, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool SpecialDrop(int missionId, int boxType, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Special, missionId.ToString(), boxType.ToString());
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Special, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool PvPQuestsDrop(eRoomType e, bool playResult, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.PvpQuests, ((int) e).ToString(), Convert.ToInt16(playResult).ToString());
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.PvpQuests, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool FireDrop(eRoomType e, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Fire, ((int) e).ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Fire, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool PvEQuestsDrop(int npcId, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.PveQuests, npcId.ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.PveQuests, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool AnswerDrop(int answerId, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Answer, answerId.ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Answer, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool RetrieveDrop(int user, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Retrieve, user.ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Retrieve, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool GetDrop(int copyId, int user, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Trminhpc, copyId.ToString(), user.ToString());
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_2(eDropType.Trminhpc, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    public static bool GetPetDrop(int copyId, int user, ref List<PetTemplateInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Trminhpc, copyId.ToString(), user.ToString());
      if (int_0 > 0)
      {
        List<PetTemplateInfo> list_0 = (List<PetTemplateInfo>) null;
        if (DropInventory.smethod_3(eDropType.Trminhpc, int_0, ref list_0))
        {
          info = list_0 ?? (List<PetTemplateInfo>) null;
          return true;
        }
      }
      return false;
    }

    private static int smethod_0(eDropType eDropType_0, string string_0, string string_1)
    {
      try
      {
        return DropMgr.FindCondiction(eDropType_0, string_0, string_1);
      }
      catch (Exception ex)
      {
        if (DropInventory.ilog_0.IsErrorEnabled)
          DropInventory.ilog_0.Error((object) ("Drop Error：" + (object) eDropType_0 + " @ " + (object) ex));
      }
      return 0;
    }

    public static bool CopyAllDrop(int copyId, ref List<SqlDataProvider.Data.ItemInfo> info)
    {
      int int_0 = DropInventory.smethod_0(eDropType.Copy, copyId.ToString(), "0");
      if (int_0 > 0)
      {
        List<SqlDataProvider.Data.ItemInfo> list_0 = (List<SqlDataProvider.Data.ItemInfo>) null;
        if (DropInventory.smethod_1(eDropType.Copy, int_0, ref list_0))
        {
          info = list_0 ?? (List<SqlDataProvider.Data.ItemInfo>) null;
          return true;
        }
      }
      return false;
    }

    private static bool smethod_1(eDropType eDropType_0, int int_0, ref List<SqlDataProvider.Data.ItemInfo> list_0)
    {
      if (int_0 == 0)
        return false;
      try
      {
        int num1 = 1;
        List<DropItem> dropItem1 = DropMgr.FindDropItem(int_0);
        int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<DropItem, int>((IEnumerable<DropItem>) dropItem1, (Func<DropItem, int>) (dropItem_0 => dropItem_0.Random)).Max());
        int num2 = Enumerable.Where<DropItem>((IEnumerable<DropItem>) dropItem1, (Func<DropItem, bool>) (s => s.Random >= maxRound)).ToList<DropItem>().Count<DropItem>();
        if (num2 == 0)
          return false;
        int count1 = num1 > num2 ? num2 : num1;
        DropInventory.GetRandomUnrepeatArray(0, num2 - 1, count1);
        foreach (DropItem dropItem2 in dropItem1)
        {
          int count2 = ThreadSafeRandom.NextStatic(dropItem2.BeginData, dropItem2.EndData);
          ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(dropItem2.ItemId);
          SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, count2, 101);
          if (fromTemplate != null)
          {
            fromTemplate.IsBinds = dropItem2.IsBind;
            fromTemplate.ValidDate = dropItem2.ValueDate;
            fromTemplate.IsTips = dropItem2.IsTips;
            fromTemplate.IsLogs = dropItem2.IsLogs;
            if (list_0 == null)
              list_0 = new List<SqlDataProvider.Data.ItemInfo>();
            if (DropInfoMgr.CanDrop(itemTemplate.TemplateID))
              list_0.Add(fromTemplate);
          }
        }
        return true;
      }
      catch
      {
        if (DropInventory.ilog_0.IsErrorEnabled)
          DropInventory.ilog_0.Error((object) ("Drop Error：" + (object) eDropType_0 + " dropId " + (object) int_0));
      }
      return false;
    }

    private static bool smethod_2(eDropType eDropType_0, int int_0, ref List<SqlDataProvider.Data.ItemInfo> list_0)
    {
      if (int_0 == 0)
        return false;
      try
      {
        int num1 = 1;
        List<DropItem> dropItem = DropMgr.FindDropItem(int_0);
        int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<DropItem, int>((IEnumerable<DropItem>) dropItem, (Func<DropItem, int>) (dropItem_0 => dropItem_0.Random)).Max());
        List<DropItem> list = Enumerable.Where<DropItem>((IEnumerable<DropItem>) dropItem, (Func<DropItem, bool>) (s => s.Random >= maxRound)).ToList<DropItem>();
        int num2 = list.Count<DropItem>();
        if (num2 == 0)
          return false;
        int count1 = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in DropInventory.GetRandomUnrepeatArray(0, num2 - 1, count1))
        {
          int count2 = ThreadSafeRandom.NextStatic(list[randomUnrepeat].BeginData, list[randomUnrepeat].EndData);
          ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(list[randomUnrepeat].ItemId);
          SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, count2, 101);
          if (fromTemplate != null)
          {
            fromTemplate.IsBinds = list[randomUnrepeat].IsBind;
            fromTemplate.ValidDate = list[randomUnrepeat].ValueDate;
            fromTemplate.IsTips = list[randomUnrepeat].IsTips;
            fromTemplate.IsLogs = list[randomUnrepeat].IsLogs;
            if (list_0 == null)
              list_0 = new List<SqlDataProvider.Data.ItemInfo>();
            if (DropInfoMgr.CanDrop(itemTemplate.TemplateID))
              list_0.Add(fromTemplate);
          }
        }
        return true;
      }
      catch
      {
        if (DropInventory.ilog_0.IsErrorEnabled)
          DropInventory.ilog_0.Error((object) ("Drop Error：" + (object) eDropType_0 + " dropId " + (object) int_0));
      }
      return false;
    }

    private static bool smethod_3(
      eDropType eDropType_0,
      int int_0,
      ref List<PetTemplateInfo> list_0)
    {
      if (int_0 == 0)
        return false;
      try
      {
        int num1 = 1;
        List<DropItem> dropItem = DropMgr.FindDropItem(int_0);
        int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<DropItem, int>((IEnumerable<DropItem>) dropItem, (Func<DropItem, int>) (dropItem_0 => dropItem_0.Random)).Max());
        List<DropItem> list = Enumerable.Where<DropItem>((IEnumerable<DropItem>) dropItem, (Func<DropItem, bool>) (s => s.Random >= maxRound)).ToList<DropItem>();
        int num2 = list.Count<DropItem>();
        if (num2 == 0)
          return false;
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in DropInventory.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          ThreadSafeRandom.NextStatic(list[randomUnrepeat].BeginData, list[randomUnrepeat].EndData);
          PetTemplateInfo petTemplate = PetMgr.FindPetTemplate(list[randomUnrepeat].ItemId);
          if (petTemplate != null)
          {
            if (list_0 == null)
              list_0 = new List<PetTemplateInfo>();
            if (DropInfoMgr.CanDrop(petTemplate.TemplateID))
              list_0.Add(petTemplate);
          }
        }
        return true;
      }
      catch (Exception ex)
      {
        if (DropInventory.ilog_0.IsErrorEnabled)
          DropInventory.ilog_0.Error((object) ("Drop Error：" + (object) eDropType_0 + " @ " + (object) ex));
      }
      return false;
    }

    public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
    {
      int[] randomUnrepeatArray = new int[count];
      for (int index1 = 0; index1 < count; ++index1)
      {
        int num1 = ThreadSafeRandom.NextStatic(minValue, maxValue + 1);
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
