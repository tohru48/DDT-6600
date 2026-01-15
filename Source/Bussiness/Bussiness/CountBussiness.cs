// Decompiled with JetBrains decompiler
// Type: Bussiness.CountBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using DAL;
using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Bussiness
{
  public class CountBussiness
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static string string_0;
    private static int int_0;
    private static int int_1;
    private static int int_2;
    private static bool bool_0;

    public static string ConnectionString => CountBussiness.string_0;

    public static int AppID => CountBussiness.int_0;

    public static int SubID => CountBussiness.int_1;

    public static int ServerID => CountBussiness.int_2;

    public static bool CountRecord => CountBussiness.bool_0;

    public static void SetConfig(
      string connectionString,
      int appID,
      int subID,
      int serverID,
      bool countRecord)
    {
      CountBussiness.string_0 = connectionString;
      CountBussiness.int_0 = appID;
      CountBussiness.int_1 = subID;
      CountBussiness.int_2 = serverID;
      CountBussiness.bool_0 = countRecord;
    }

    public static void InsertGameInfo(
      DateTime begin,
      int mapID,
      int money,
      int gold,
      string users)
    {
      CountBussiness.InsertGameInfo(CountBussiness.int_0, CountBussiness.int_1, CountBussiness.int_2, begin, DateTime.Now, users.Split(',').Length, mapID, money, gold, users);
    }

    public static void InsertGameInfo(
      int appid,
      int subid,
      int serverid,
      DateTime begin,
      DateTime end,
      int usercount,
      int mapID,
      int money,
      int gold,
      string users)
    {
      try
      {
        if (!CountBussiness.bool_0)
          return;
        SqlHelper.BeginExecuteNonQuery(CountBussiness.string_0, "SP_Insert_Count_FightInfo", (object) appid, (object) subid, (object) serverid, (object) begin, (object) end, (object) usercount, (object) mapID, (object) money, (object) gold, (object) users);
      }
      catch (Exception ex)
      {
        CountBussiness.ilog_0.Error((object) "Insert Log Error!", ex);
      }
    }

    public static void InsertServerInfo(int usercount, int gamecount)
    {
      CountBussiness.InsertServerInfo(CountBussiness.int_0, CountBussiness.int_1, CountBussiness.int_2, usercount, gamecount, DateTime.Now);
    }

    public static void InsertServerInfo(
      int appid,
      int subid,
      int serverid,
      int usercount,
      int gamecount,
      DateTime time)
    {
      try
      {
        if (!CountBussiness.bool_0)
          return;
        SqlHelper.BeginExecuteNonQuery(CountBussiness.string_0, "SP_Insert_Count_Server", (object) appid, (object) subid, (object) serverid, (object) usercount, (object) gamecount, (object) time);
      }
      catch (Exception ex)
      {
        CountBussiness.ilog_0.Error((object) "Insert Log Error!!", ex);
      }
    }

    public static void InsertSystemPayCount(
      int consumerid,
      int money,
      int gold,
      int consumertype,
      int subconsumertype)
    {
      CountBussiness.InsertSystemPayCount(CountBussiness.int_0, CountBussiness.int_1, consumerid, money, gold, consumertype, subconsumertype, DateTime.Now);
    }

    public static void InsertSystemPayCount(
      int appid,
      int subid,
      int consumerid,
      int money,
      int gold,
      int consumertype,
      int subconsumertype,
      DateTime datime)
    {
      try
      {
        if (!CountBussiness.bool_0)
          return;
        SqlHelper.BeginExecuteNonQuery(CountBussiness.string_0, "SP_Insert_Count_SystemPay", (object) appid, (object) subid, (object) consumerid, (object) money, (object) gold, (object) consumertype, (object) subconsumertype, (object) datime);
      }
      catch (Exception ex)
      {
        CountBussiness.ilog_0.Error((object) "InsertSystemPayCount Log Error!!!", ex);
      }
    }

    public static void InsertContentCount(Dictionary<string, string> clientInfos)
    {
      try
      {
        if (!CountBussiness.bool_0)
          return;
        SqlHelper.BeginExecuteNonQuery(CountBussiness.string_0, "Modify_Count_Content", (object) clientInfos["Application_Id"], (object) clientInfos["Cpu"], (object) clientInfos["OperSystem"], (object) clientInfos["IP"], (object) clientInfos["IPAddress"], (object) clientInfos["NETCLR"], (object) clientInfos["Browser"], (object) clientInfos["ActiveX"], (object) clientInfos["Cookies"], (object) clientInfos["CSS"], (object) clientInfos["Language"], (object) clientInfos["Computer"], (object) clientInfos["Platform"], (object) clientInfos["Win16"], (object) clientInfos["Win32"], (object) clientInfos["Referry"], (object) clientInfos["Redirect"], (object) clientInfos["TimeSpan"], (object) (clientInfos["ScreenWidth"] + clientInfos["ScreenHeight"]), (object) clientInfos["Color"], (object) clientInfos["Flash"], (object) "Insert");
      }
      catch (Exception ex)
      {
        CountBussiness.ilog_0.Error((object) "Insert Log Error!!!!", ex);
      }
    }
  }
}
