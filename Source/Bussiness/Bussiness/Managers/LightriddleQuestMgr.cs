// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.LightriddleQuestMgr
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
  public class LightriddleQuestMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, LightriddleQuestInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, LightriddleQuestInfo> infos = new Dictionary<int, LightriddleQuestInfo>();
        if (LightriddleQuestMgr.LoadData(infos))
        {
          try
          {
            LightriddleQuestMgr.dictionary_0 = infos;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (LightriddleQuestMgr.ilog_0.IsErrorEnabled)
          LightriddleQuestMgr.ilog_0.Error((object) nameof (ReLoad), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        LightriddleQuestMgr.dictionary_0 = new Dictionary<int, LightriddleQuestInfo>();
        flag = LightriddleQuestMgr.LoadData(LightriddleQuestMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (LightriddleQuestMgr.ilog_0.IsErrorEnabled)
          LightriddleQuestMgr.ilog_0.Error((object) nameof (Init), ex);
        flag = false;
      }
      return flag;
    }

    public static bool LoadData(Dictionary<int, LightriddleQuestInfo> infos)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (LightriddleQuestInfo lightriddleQuestInfo in playerBussiness.GetAllLightriddleQuestInfo())
        {
          if (!infos.Keys.Contains<int>(lightriddleQuestInfo.QuestionID))
            infos.Add(lightriddleQuestInfo.QuestionID, lightriddleQuestInfo);
        }
      }
      return true;
    }

    public static Dictionary<int, LightriddleQuestInfo> Get30LightriddleQuest()
    {
      if (LightriddleQuestMgr.dictionary_0 == null)
        LightriddleQuestMgr.Init();
      Dictionary<int, LightriddleQuestInfo> dictionary1 = new Dictionary<int, LightriddleQuestInfo>();
      Dictionary<int, LightriddleQuestInfo> dictionary2 = new Dictionary<int, LightriddleQuestInfo>();
      int count = LightriddleQuestMgr.dictionary_0.Count;
      int key1 = 1;
      int num = 0;
      while (dictionary1.Count < 30)
      {
        int key2 = LightriddleQuestMgr.threadSafeRandom_0.Next(1, count);
        LightriddleQuestInfo lightriddleQuestInfo = LightriddleQuestMgr.dictionary_0[key2];
        if (!dictionary2.Keys.Contains<int>(lightriddleQuestInfo.QuestionID))
        {
          dictionary1.Add(key1, lightriddleQuestInfo);
          dictionary2.Add(lightriddleQuestInfo.QuestionID, lightriddleQuestInfo);
          ++key1;
        }
        ++num;
      }
      return dictionary1;
    }
  }
}
