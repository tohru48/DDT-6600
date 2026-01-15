// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.NewTitleMgr
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
  public class NewTitleMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, NewTitleInfo> dictionary_0 = new Dictionary<int, NewTitleInfo>();
    private static ThreadSafeRandom threadSafeRandom_0 = new ThreadSafeRandom();

    public static bool ReLoad()
    {
      bool flag;
      try
      {
        NewTitleInfo[] NewTitle = NewTitleMgr.LoadNewTitleDb();
        Dictionary<int, NewTitleInfo> dictionary = NewTitleMgr.LoadNewTitles(NewTitle);
        if (NewTitle.Length > 0)
          Interlocked.Exchange<Dictionary<int, NewTitleInfo>>(ref NewTitleMgr.dictionary_0, dictionary);
        return true;
      }
      catch (Exception ex)
      {
        if (NewTitleMgr.ilog_0.IsErrorEnabled)
          NewTitleMgr.ilog_0.Error((object) "ReLoad NewTitle", ex);
        flag = false;
      }
      return flag;
    }

    public static bool Init() => NewTitleMgr.ReLoad();

    public static NewTitleInfo[] LoadNewTitleDb()
    {
      NewTitleInfo[] allNewTitle;
      using (ProduceBussiness produceBussiness = new ProduceBussiness())
        allNewTitle = produceBussiness.GetAllNewTitle();
      return allNewTitle;
    }

    public static Dictionary<int, NewTitleInfo> LoadNewTitles(NewTitleInfo[] NewTitle)
    {
      Dictionary<int, NewTitleInfo> dictionary = new Dictionary<int, NewTitleInfo>();
      for (int index = 0; index < NewTitle.Length; ++index)
      {
        NewTitleInfo newTitleInfo = NewTitle[index];
        if (!dictionary.Keys.Contains<int>(newTitleInfo.ID))
          dictionary.Add(newTitleInfo.ID, newTitleInfo);
      }
      return dictionary;
    }

    public static NewTitleInfo FindNewTitle(int ID)
    {
      return NewTitleMgr.dictionary_0.ContainsKey(ID) ? NewTitleMgr.dictionary_0[ID] : (NewTitleInfo) null;
    }

    public static NewTitleInfo FindNewTitleByName(string Name)
    {
      foreach (NewTitleInfo newTitleByName in NewTitleMgr.dictionary_0.Values)
      {
        if (newTitleByName.Name == Name)
          return newTitleByName;
      }
      return (NewTitleInfo) null;
    }
  }
}
