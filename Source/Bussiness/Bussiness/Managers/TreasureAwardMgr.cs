// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.TreasureAwardMgr
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
  public class TreasureAwardMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, TreasureAwardInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, TreasureAwardInfo> treasureAward = new Dictionary<int, TreasureAwardInfo>();
        if (TreasureAwardMgr.smethod_0(treasureAward))
        {
          try
          {
            TreasureAwardMgr.dictionary_0 = treasureAward;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (TreasureAwardMgr.ilog_0.IsErrorEnabled)
          TreasureAwardMgr.ilog_0.Error((object) nameof (TreasureAwardMgr), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        TreasureAwardMgr.dictionary_0 = new Dictionary<int, TreasureAwardInfo>();
        TreasureAwardMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = TreasureAwardMgr.smethod_0(TreasureAwardMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (TreasureAwardMgr.ilog_0.IsErrorEnabled)
          TreasureAwardMgr.ilog_0.Error((object) nameof (TreasureAwardMgr), ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(Dictionary<int, TreasureAwardInfo> treasureAward)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (TreasureAwardInfo treasureAwardInfo in playerBussiness.GetAllTreasureAward())
        {
          if (!treasureAward.ContainsKey(treasureAwardInfo.ID))
            treasureAward.Add(treasureAwardInfo.ID, treasureAwardInfo);
        }
      }
      return true;
    }

    public static TreasureAwardInfo FindTreasureAwardInfo(int ID)
    {
      try
      {
        if (TreasureAwardMgr.dictionary_0.ContainsKey(ID))
          return TreasureAwardMgr.dictionary_0[ID];
      }
      catch
      {
      }
      return (TreasureAwardInfo) null;
    }

    public static List<TreasureAwardInfo> GetTreasureInfos()
    {
      if (TreasureAwardMgr.dictionary_0 == null)
        TreasureAwardMgr.Init();
      List<TreasureAwardInfo> treasureInfos = new List<TreasureAwardInfo>();
      foreach (TreasureAwardInfo treasureAwardInfo in TreasureAwardMgr.dictionary_0.Values)
        treasureInfos.Add(treasureAwardInfo);
      return treasureInfos;
    }

    public static List<TreasureDataInfo> CreateTreasureData(int UserID)
    {
      List<TreasureDataInfo> treasureData1 = new List<TreasureDataInfo>();
      Dictionary<int, TreasureDataInfo> dictionary = new Dictionary<int, TreasureDataInfo>();
      int num = 0;
      while (treasureData1.Count < 16)
      {
        List<TreasureDataInfo> treasureData2 = TreasureAwardMgr.GetTreasureData();
        int index = TreasureAwardMgr.threadSafeRandom_0.Next(treasureData2.Count);
        TreasureDataInfo treasureDataInfo = treasureData2[index];
        treasureDataInfo.UserID = UserID;
        if (!dictionary.Keys.Contains<int>(treasureDataInfo.TemplateID))
        {
          dictionary.Add(treasureDataInfo.TemplateID, treasureDataInfo);
          treasureData1.Add(treasureDataInfo);
        }
        ++num;
      }
      return treasureData1;
    }

    public static List<TreasureDataInfo> GetTreasureData()
    {
      List<TreasureDataInfo> treasureData = new List<TreasureDataInfo>();
      List<TreasureAwardInfo> treasureAwardInfoList = new List<TreasureAwardInfo>();
      List<TreasureAwardInfo> treasureInfos = TreasureAwardMgr.GetTreasureInfos();
      int num1 = 1;
      int maxRound = ThreadSafeRandom.NextStatic(Enumerable.Select<TreasureAwardInfo, int>((IEnumerable<TreasureAwardInfo>) treasureInfos, (Func<TreasureAwardInfo, int>) (treasureAwardInfo_0 => treasureAwardInfo_0.Random)).Max());
      List<TreasureAwardInfo> list = Enumerable.Where<TreasureAwardInfo>((IEnumerable<TreasureAwardInfo>) treasureInfos, (Func<TreasureAwardInfo, bool>) (s => s.Random >= maxRound)).ToList<TreasureAwardInfo>();
      int num2 = list.Count<TreasureAwardInfo>();
      if (num2 > 0)
      {
        int count = num1 > num2 ? num2 : num1;
        foreach (int randomUnrepeat in TreasureAwardMgr.GetRandomUnrepeatArray(0, num2 - 1, count))
        {
          TreasureAwardInfo treasureAwardInfo = list[randomUnrepeat];
          treasureAwardInfoList.Add(treasureAwardInfo);
        }
      }
      foreach (TreasureAwardInfo treasureAwardInfo in treasureAwardInfoList)
        treasureData.Add(new TreasureDataInfo()
        {
          ID = 0,
          UserID = 0,
          TemplateID = treasureAwardInfo.TemplateID,
          Count = treasureAwardInfo.Count,
          ValidDate = treasureAwardInfo.Validate,
          pos = -1,
          BeginDate = DateTime.Now,
          IsExit = true
        });
      return treasureData;
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
