// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.EventAwardMgr
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
  public class EventAwardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static EventAwardInfo[] eventAwardInfo_0;
    private static Dictionary<int, List<EventAwardInfo>> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        EventAwardInfo[] EventAwards = EventAwardMgr.LoadEventAwardDb();
        Dictionary<int, List<EventAwardInfo>> dictionary = EventAwardMgr.LoadEventAwards(EventAwards);
        if (EventAwards != null)
        {
          Interlocked.Exchange<EventAwardInfo[]>(ref EventAwardMgr.eventAwardInfo_0, EventAwards);
          Interlocked.Exchange<Dictionary<int, List<EventAwardInfo>>>(ref EventAwardMgr.dictionary_0, dictionary);
        }
        return true;
      }
      catch (Exception ex)
      {
        if (EventAwardMgr.ilog_0.IsErrorEnabled)
          EventAwardMgr.ilog_0.Error((object) nameof (ReLoad), ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => EventAwardMgr.ReLoad();

    public static EventAwardInfo[] LoadEventAwardDb()
    {
      EventAwardInfo[] eventAwardInfos;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        eventAwardInfos = produceBussiness.GetEventAwardInfos();
      return eventAwardInfos;
    }

    public static Dictionary<int, List<EventAwardInfo>> LoadEventAwards(EventAwardInfo[] EventAwards)
    {
      Dictionary<int, List<EventAwardInfo>> dictionary = new Dictionary<int, List<EventAwardInfo>>();
      for (int index = 0; index < EventAwards.Length; ++index)
      {
        EventAwardInfo info = EventAwards[index];
        if (!dictionary.Keys.Contains<int>(info.ActivityType))
        {
          IEnumerable<EventAwardInfo> source = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) EventAwards, (Func<EventAwardInfo, bool>) (s => s.ActivityType == info.ActivityType));
          dictionary.Add(info.ActivityType, source.ToList<EventAwardInfo>());
        }
      }
      return dictionary;
    }

    public static List<EventAwardInfo> FindEventAward(eEventType DataId)
    {
      return EventAwardMgr.dictionary_0.ContainsKey((int) DataId) ? EventAwardMgr.dictionary_0[(int) DataId] : (List<EventAwardInfo>) null;
    }

    public static List<SqlDataProvider.Data.ItemInfo> GetEventAwardByType(eEventType DataId)
    {
      List<SqlDataProvider.Data.ItemInfo> eventAwardByType = new List<SqlDataProvider.Data.ItemInfo>();
      List<EventAwardInfo> eventAwardInfoList = new List<EventAwardInfo>();
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(DataId);
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<EventAwardInfo, int>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, int>) (eventAwardInfo_1 => eventAwardInfo_1.Random)).Max());
      List<EventAwardInfo> list = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<EventAwardInfo>();
      int num2 = list.Count<EventAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in EventAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          EventAwardInfo eventAwardInfo = list[randomUnrepeat];
          eventAwardInfoList.Add(eventAwardInfo);
        }
      }
      foreach (EventAwardInfo eventAwardInfo in eventAwardInfoList)
      {
        SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(eventAwardInfo.TemplateID), eventAwardInfo.Count, 105);
        fromTemplate.TemplateID = eventAwardInfo.TemplateID;
        fromTemplate.IsBinds = eventAwardInfo.IsBinds;
        fromTemplate.ValidDate = eventAwardInfo.ValidDate;
        fromTemplate.Count = eventAwardInfo.Count;
        fromTemplate.StrengthenLevel = eventAwardInfo.StrengthenLevel;
        fromTemplate.AttackCompose = eventAwardInfo.AttackCompose;
        fromTemplate.DefendCompose = eventAwardInfo.DefendCompose;
        fromTemplate.AgilityCompose = eventAwardInfo.AgilityCompose;
        fromTemplate.LuckCompose = eventAwardInfo.LuckCompose;
        eventAwardByType.Add(fromTemplate);
      }
      return eventAwardByType;
    }

    public static List<SqlDataProvider.Data.ItemInfo> GetAllEventAwardAward(eEventType DataId)
    {
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(DataId);
      List<SqlDataProvider.Data.ItemInfo> allEventAwardAward = new List<SqlDataProvider.Data.ItemInfo>();
      foreach (EventAwardInfo eventAwardInfo in eventAward)
      {
        SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(eventAwardInfo.TemplateID), eventAwardInfo.Count, 105);
        fromTemplate.IsBinds = eventAwardInfo.IsBinds;
        fromTemplate.ValidDate = eventAwardInfo.ValidDate;
        allEventAwardAward.Add(fromTemplate);
      }
      return allEventAwardAward;
    }

    public static void CreateEventAward(eEventType DateId)
    {
    }

    public static EventAwardInfo[] CreateSearchGoodsAward(int count)
    {
      Dictionary<int, EventAwardInfo> dictionary = new Dictionary<int, EventAwardInfo>();
      for (int index = 0; index < count; ++index)
      {
        EventAwardInfo[] randomAward = EventAwardMgr.GetRandomAward(eEventType.SEARCH_GOODS);
        if (randomAward.Length > 0)
        {
          EventAwardInfo eventAwardInfo = randomAward[0];
          if (!dictionary.ContainsKey(eventAwardInfo.TemplateID))
            dictionary.Add(eventAwardInfo.TemplateID, eventAwardInfo);
        }
      }
      return dictionary.Values.ToArray<EventAwardInfo>();
    }

    public static EventAwardInfo[] CreateMagpieBridgeAward(int count)
    {
      Dictionary<int, EventAwardInfo> dictionary = new Dictionary<int, EventAwardInfo>();
      for (int index = 0; index < count; ++index)
      {
        EventAwardInfo[] randomAward = EventAwardMgr.GetRandomAward(eEventType.MAGPIE_BRIDGE);
        if (randomAward.Length > 0)
        {
          EventAwardInfo eventAwardInfo = randomAward[0];
          if (!dictionary.ContainsKey(eventAwardInfo.TemplateID))
            dictionary.Add(eventAwardInfo.TemplateID, eventAwardInfo);
        }
      }
      return dictionary.Values.ToArray<EventAwardInfo>();
    }

    public static EventAwardInfo[] GetRandomAward(eEventType type)
    {
      List<EventAwardInfo> eventAwardInfoList = new List<EventAwardInfo>();
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(eEventType.SEARCH_GOODS);
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<EventAwardInfo, int>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, int>) (eventAwardInfo_1 => eventAwardInfo_1.Random)).Max());
      List<EventAwardInfo> list = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<EventAwardInfo>();
      int num2 = list.Count<EventAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in EventAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          EventAwardInfo eventAwardInfo = list[randomUnrepeat];
          eventAwardInfoList.Add(eventAwardInfo);
        }
      }
      return eventAwardInfoList.ToArray();
    }

    public static List<NewChickenBoxItemInfo> GetNewChickenBoxAward(eEventType DataId)
    {
      List<NewChickenBoxItemInfo> newChickenBoxAward = new List<NewChickenBoxItemInfo>();
      List<EventAwardInfo> eventAwardInfoList = new List<EventAwardInfo>();
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(DataId);
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<EventAwardInfo, int>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, int>) (eventAwardInfo_1 => eventAwardInfo_1.Random)).Max());
      List<EventAwardInfo> list = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<EventAwardInfo>();
      int num2 = list.Count<EventAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in EventAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          EventAwardInfo eventAwardInfo = list[randomUnrepeat];
          eventAwardInfoList.Add(eventAwardInfo);
        }
      }
      foreach (EventAwardInfo eventAwardInfo in eventAwardInfoList)
      {
        NewChickenBoxItemInfo chickenBoxItemInfo = new NewChickenBoxItemInfo();
        chickenBoxItemInfo.TemplateID = eventAwardInfo.TemplateID;
        chickenBoxItemInfo.IsBinds = eventAwardInfo.IsBinds;
        chickenBoxItemInfo.ValidDate = eventAwardInfo.ValidDate;
        chickenBoxItemInfo.Count = eventAwardInfo.Count;
        chickenBoxItemInfo.StrengthenLevel = eventAwardInfo.StrengthenLevel;
        chickenBoxItemInfo.AttackCompose = 0;
        chickenBoxItemInfo.DefendCompose = 0;
        chickenBoxItemInfo.AgilityCompose = 0;
        chickenBoxItemInfo.LuckCompose = 0;
        ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(eventAwardInfo.TemplateID);
        chickenBoxItemInfo.Quality = itemTemplate == null ? 2 : itemTemplate.Quality;
        chickenBoxItemInfo.IsSelected = false;
        chickenBoxItemInfo.IsSeeded = false;
        newChickenBoxAward.Add(chickenBoxItemInfo);
      }
      return newChickenBoxAward;
    }

    public static List<EventAwardInfo> GetDiceAward(eEventType DataId)
    {
      List<EventAwardInfo> diceAward = new List<EventAwardInfo>();
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(DataId);
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<EventAwardInfo, int>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, int>) (eventAwardInfo_1 => eventAwardInfo_1.Random)).Max());
      List<EventAwardInfo> list = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<EventAwardInfo>();
      int num2 = list.Count<EventAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in EventAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          EventAwardInfo eventAwardInfo = list[randomUnrepeat];
          diceAward.Add(eventAwardInfo);
        }
      }
      return diceAward;
    }

    public static List<CardsTakeOutInfo> GetFightFootballTimeAward(eEventType DataId)
    {
      List<CardsTakeOutInfo> footballTimeAward = new List<CardsTakeOutInfo>();
      List<EventAwardInfo> eventAwardInfoList = new List<EventAwardInfo>();
      List<EventAwardInfo> eventAward = EventAwardMgr.FindEventAward(DataId);
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<EventAwardInfo, int>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, int>) (eventAwardInfo_1 => eventAwardInfo_1.Random)).Max());
      List<EventAwardInfo> list = Enumerable.Where<EventAwardInfo>((IEnumerable<EventAwardInfo>) eventAward, (Func<EventAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<EventAwardInfo>();
      int num2 = list.Count<EventAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in EventAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          EventAwardInfo eventAwardInfo = list[randomUnrepeat];
          eventAwardInfoList.Add(eventAwardInfo);
        }
      }
      foreach (EventAwardInfo eventAwardInfo in eventAwardInfoList)
        footballTimeAward.Add(new CardsTakeOutInfo()
        {
          templateID = eventAwardInfo.TemplateID,
          count = eventAwardInfo.Count
        });
      return footballTimeAward;
    }

    public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
    {
      int[] randomUnrepeatArray = new int[count];
      for (int index1 = 0; index1 < count; ++index1)
      {
        int num1 = EventAwardMgr.threadSafeRandom_0.Next(minValue, maxValue + 1);
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
