// Decompiled with JetBrains decompiler
// Type: Bussiness.ManageBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Bussiness.CenterService;
using SqlDataProvider.Data;
using System;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
  public class ManageBussiness : BaseBussiness
  {
    public int KitoffUserByUserName(string name, string msg)
    {
      int num = 1;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        PlayerInfo singleByUserName = playerBussiness.GetUserSingleByUserName(name);
        if (singleByUserName == null)
          return 2;
        num = this.KitoffUser(singleByUserName.ID, msg);
      }
      return num;
    }

    public int KitoffUserByNickName(string name, string msg)
    {
      int num = 1;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        PlayerInfo singleByNickName = playerBussiness.GetUserSingleByNickName(name);
        if (singleByNickName == null)
          return 2;
        num = this.KitoffUser(singleByNickName.ID, msg);
      }
      return num;
    }

    public int KitoffUser(int id, string msg)
    {
      int num;
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          num = !centerServiceClient.KitoffUser(id, msg) ? 3 : 0;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (KitoffUser), ex);
        num = 1;
      }
      return num;
    }

    public bool SystemNotice(string msg)
    {
      bool flag = false;
      try
      {
        if (!string.IsNullOrEmpty(msg))
        {
          using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          {
            if (centerServiceClient.SystemNotice(msg))
              flag = true;
          }
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (SystemNotice), ex);
      }
      return flag;
    }

    private bool method_0(
      string string_0,
      string string_1,
      int int_0,
      DateTime dateTime_0,
      bool bool_0)
    {
      return this.method_1(string_0, string_1, int_0, dateTime_0, bool_0, "");
    }

    private bool method_1(
      string string_0,
      string string_1,
      int int_0,
      DateTime dateTime_0,
      bool bool_0,
      string string_2)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[6]
        {
          new SqlParameter("@UserName", (object) string_0),
          new SqlParameter("@NickName", (object) string_1),
          new SqlParameter("@UserID", (object) int_0),
          null,
          null,
          null
        };
        SqlParameters[2].Direction = ParameterDirection.InputOutput;
        SqlParameters[3] = new SqlParameter("@ForbidDate", (object) dateTime_0);
        SqlParameters[4] = new SqlParameter("@IsExist", (object) bool_0);
        SqlParameters[5] = new SqlParameter("@ForbidReason", (object) string_2);
        this.db.RunProcedure("SP_Admin_ForbidUser", SqlParameters);
        int_0 = (int) SqlParameters[2].Value;
        if (int_0 > 0)
        {
          flag = true;
          if (!bool_0)
            this.KitoffUser(int_0, "You are kicking out by GM!!");
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      return flag;
    }

    public bool ForbidPlayerByUserName(string userName, DateTime date, bool isExist)
    {
      return this.method_0(userName, "", 0, date, isExist);
    }

    public bool ForbidPlayerByNickName(string nickName, DateTime date, bool isExist)
    {
      return this.method_0("", nickName, 0, date, isExist);
    }

    public bool ForbidPlayerByUserID(int userID, DateTime date, bool isExist)
    {
      return this.method_0("", "", userID, date, isExist);
    }

    public bool ForbidPlayerByUserName(
      string userName,
      DateTime date,
      bool isExist,
      string ForbidReason)
    {
      return this.method_1(userName, "", 0, date, isExist, ForbidReason);
    }

    public bool ForbidPlayerByNickName(
      string nickName,
      DateTime date,
      bool isExist,
      string ForbidReason)
    {
      return this.method_1("", nickName, 0, date, isExist, ForbidReason);
    }

    public bool ForbidPlayerByUserID(int userID, DateTime date, bool isExist, string ForbidReason)
    {
      return this.method_1("", "", userID, date, isExist, ForbidReason);
    }

    public bool ReLoadServerList()
    {
      bool flag = false;
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
        {
          if (centerServiceClient.ReLoadServerList())
            flag = true;
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (ReLoadServerList), ex);
      }
      return flag;
    }

    public int GetConfigState(int type)
    {
      int configState = 2;
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.GetConfigState(type);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetConfigState), ex);
      }
      return configState;
    }

    public bool UpdateConfigState(int type, bool state)
    {
      bool flag = false;
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.UpdateConfigState(type, state);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (UpdateConfigState), ex);
      }
      return flag;
    }

    public bool Reload(string type)
    {
      bool flag = false;
      try
      {
        using (CenterServiceClient centerServiceClient = new CenterServiceClient())
          return centerServiceClient.Reload(type);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (Reload), ex);
      }
      return flag;
    }
  }
}
