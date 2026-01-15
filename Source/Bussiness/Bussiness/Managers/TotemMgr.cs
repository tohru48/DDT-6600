// Decompiled with JetBrains decompiler
// Type: Bussiness.Managers.TotemMgr
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Bussiness.Managers
{
  public class TotemMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, TotemInfo> dictionary_0;
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool ReLoad()
    {
      try
      {
        Dictionary<int, TotemInfo> totem = new Dictionary<int, TotemInfo>();
        if (TotemMgr.smethod_0(totem))
        {
          try
          {
            TotemMgr.dictionary_0 = totem;
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (TotemMgr.ilog_0.IsErrorEnabled)
          TotemMgr.ilog_0.Error((object) nameof (TotemMgr), ex);
      }
      return false;
    }

    public static bool Init()
    {
      bool flag;
      try
      {
        TotemMgr.dictionary_0 = new Dictionary<int, TotemInfo>();
        TotemMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = TotemMgr.smethod_0(TotemMgr.dictionary_0);
      }
      catch (Exception ex)
      {
        if (TotemMgr.ilog_0.IsErrorEnabled)
          TotemMgr.ilog_0.Error((object) nameof (TotemMgr), ex);
        flag = false;
      }
      return flag;
    }

    private static bool smethod_0(Dictionary<int, TotemInfo> totem)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        foreach (TotemInfo totemInfo in playerBussiness.GetAllTotem())
        {
          if (!totem.ContainsKey(totemInfo.ID))
            totem.Add(totemInfo.ID, totemInfo);
        }
      }
      return true;
    }

    public static TotemInfo FindTotemInfo(int ID)
    {
      if (ID < 10000)
        ID = 10001;
      return TotemMgr.dictionary_0.ContainsKey(ID) ? TotemMgr.dictionary_0[ID] : (TotemInfo) null;
    }

    public static int GetTotemProp(int id, string typeOf)
    {
      int totemProp = 0;
      for (int ID = 10001; ID <= id; ++ID)
      {
        TotemInfo totemInfo = TotemMgr.FindTotemInfo(ID);
        switch (typeOf)
        {
          case "att":
            totemProp += totemInfo.AddAttack;
            break;
          case "agi":
            totemProp += totemInfo.AddAgility;
            break;
          case "def":
            totemProp += totemInfo.AddDefence;
            break;
          case "luc":
            totemProp += totemInfo.AddLuck;
            break;
          case "blo":
            totemProp += totemInfo.AddBlood;
            break;
          case "dam":
            totemProp += totemInfo.AddDamage;
            break;
          case "gua":
            totemProp += totemInfo.AddGuard;
            break;
        }
      }
      return totemProp;
    }
  }
}
