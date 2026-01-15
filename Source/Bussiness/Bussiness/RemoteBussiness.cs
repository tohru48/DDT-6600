// Decompiled with JetBrains decompiler
// Type: Bussiness.RemoteBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

#nullable disable
namespace Bussiness
{
  public class RemoteBussiness : IDisposable
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected Sql_DbObject db;

    public RemoteBussiness() => this.db = new Sql_DbObject("AppConfig", "RemoteDb");

    public RemoteServerInfo GetSingleServer(int id)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) id;
        this.db.GetReader(ref ResultDataReader, "SP_GetSingleServer", SqlParameters);
        if (ResultDataReader.Read())
          return new RemoteServerInfo()
          {
            ID = (int) ResultDataReader["ID"],
            UserID = (int) ResultDataReader["UserID"],
            ServerName = (string) ResultDataReader["ServerName"],
            ServerPath = (string) ResultDataReader["ServerPath"],
            ProcessID = (int) ResultDataReader["ProcessID"],
            ProcessStatus = (int) ResultDataReader["ProcessStatus"],
            Status = (string) ResultDataReader["Status"],
            Port = (int) ResultDataReader["Port"],
            ZoneID = (int) ResultDataReader["ZoneID"]
          };
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "RemoteServerInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (RemoteServerInfo) null;
    }

    public RemoteServerInfo[] GetSingleServerByUserName(string Name)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      List<RemoteServerInfo> remoteServerInfoList = new List<RemoteServerInfo>();
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserName", SqlDbType.NVarChar, 50)
        };
        SqlParameters[0].Value = (object) Name;
        this.db.GetReader(ref ResultDataReader, "SP_GetSingleServerByUserName", SqlParameters);
        while (ResultDataReader.Read())
          remoteServerInfoList.Add(new RemoteServerInfo()
          {
            ID = (int) ResultDataReader["ID"],
            UserID = (int) ResultDataReader["UserID"],
            ServerName = (string) ResultDataReader["ServerName"],
            ServerPath = (string) ResultDataReader["ServerPath"],
            ProcessID = (int) ResultDataReader["ProcessID"],
            ProcessStatus = (int) ResultDataReader["ProcessStatus"],
            Status = (string) ResultDataReader["Status"],
            Port = (int) ResultDataReader["Port"],
            ZoneID = (int) ResultDataReader["ZoneID"]
          });
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_GetSingleServerByUserName", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return remoteServerInfoList.ToArray();
    }

    public RemoteServerInfo[] GetAllRemoteServer()
    {
      List<RemoteServerInfo> remoteServerInfoList = new List<RemoteServerInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_RemoteServer_All");
        while (ResultDataReader.Read())
          remoteServerInfoList.Add(new RemoteServerInfo()
          {
            ID = (int) ResultDataReader["ID"],
            UserID = (int) ResultDataReader["UserID"],
            ServerName = (string) ResultDataReader["ServerName"],
            ServerPath = (string) ResultDataReader["ServerPath"],
            ProcessID = (int) ResultDataReader["ProcessID"],
            ProcessStatus = (int) ResultDataReader["ProcessStatus"],
            Status = (string) ResultDataReader["Status"],
            Port = (int) ResultDataReader["Port"],
            ZoneID = (int) ResultDataReader["ZoneID"]
          });
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "RemoteServerInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return remoteServerInfoList.ToArray();
    }

    public bool ResetStatus()
    {
      bool flag = false;
      try
      {
        flag = this.db.RunProcedure("SP_Reset_Status", new SqlParameter[0]);
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Reset_Status", ex);
      }
      return flag;
    }

    public bool DeleteServer(string id)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[2]
        {
          new SqlParameter("@ID", (object) id),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[1].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_Delete_Server", SqlParameters);
        flag = (int) SqlParameters[1].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Delete_Server", ex);
      }
      return flag;
    }

    public bool AddServer(
      string userid,
      string servername,
      string serverpath,
      string processid,
      string processstatus,
      string status,
      string port,
      string zoneid)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[9]
        {
          new SqlParameter("@UserID", (object) userid),
          new SqlParameter("@ServerName", (object) servername),
          new SqlParameter("@ServerPath", (object) serverpath),
          new SqlParameter("@ProcessID", (object) processid),
          new SqlParameter("@ProcessStatus", (object) processstatus),
          new SqlParameter("@Status", (object) status),
          new SqlParameter("@Port", (object) port),
          new SqlParameter("@ZoneID", (object) zoneid),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[8].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_Add_Server", SqlParameters);
        flag = (int) SqlParameters[8].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Add_Server: ", ex);
      }
      return flag;
    }

    public bool UpdateServer(
      string id,
      string userid,
      string servername,
      string serverpath,
      string processid,
      string processstatus,
      string status,
      string port,
      string zoneid)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[10]
        {
          new SqlParameter("@ID", (object) id),
          new SqlParameter("@UserID", (object) userid),
          new SqlParameter("@ServerName", (object) servername),
          new SqlParameter("@ServerPath", (object) serverpath),
          new SqlParameter("@ProcessID", (object) processid),
          new SqlParameter("@ProcessStatus", (object) processstatus),
          new SqlParameter("@Status", (object) status),
          new SqlParameter("@Port", (object) port),
          new SqlParameter("@ZoneID", (object) zoneid),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[9].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_Update_Server", SqlParameters);
        flag = (int) SqlParameters[9].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Update_Server: ", ex);
      }
      return flag;
    }

    public bool UpdateServer(int Id, int processStatus, string status)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[4]
        {
          new SqlParameter("@ID", (object) Id),
          new SqlParameter("@ProcessStatus", (object) processStatus),
          new SqlParameter("@Status", (object) status),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[3].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_Update_RemoteServer", SqlParameters);
        flag = (int) SqlParameters[3].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Update_RemoteServer: ", ex);
      }
      return flag;
    }

    public bool ChangeSetting(string name, string value)
    {
      if (name == "PrivateKey")
        return false;
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[3]
        {
          new SqlParameter("@Name", (object) name),
          new SqlParameter("@Value", (object) value),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[2].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_ChangeSetting", SqlParameters);
        flag = (int) SqlParameters[2].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_ChangeSetting: ", ex);
      }
      return flag;
    }

    public Dictionary<string, RemoteSettingInfo> GetAllSetting()
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      Dictionary<string, RemoteSettingInfo> allSetting = new Dictionary<string, RemoteSettingInfo>();
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GetAllSetting");
        while (ResultDataReader.Read())
        {
          RemoteSettingInfo remoteSettingInfo = new RemoteSettingInfo();
          remoteSettingInfo.ID = (int) ResultDataReader["ID"];
          remoteSettingInfo.Name = (string) ResultDataReader["Name"];
          remoteSettingInfo.Value = (string) ResultDataReader["Value"];
          allSetting.Add(remoteSettingInfo.Name, remoteSettingInfo);
        }
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_GetAllSetting", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return allSetting;
    }

    public RemoteUserInfo[] GetAllUser()
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      List<RemoteUserInfo> remoteUserInfoList = new List<RemoteUserInfo>();
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GetAllUser");
        while (ResultDataReader.Read())
          remoteUserInfoList.Add(new RemoteUserInfo()
          {
            ID = (int) ResultDataReader["ID"],
            ApplicationID = (int) ResultDataReader["ApplicationID"],
            UserName = (string) ResultDataReader["UserName"]
          });
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_GetAllUser", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return remoteUserInfoList.ToArray();
    }

    public bool ChangePassword(string userName, string password)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[3]
        {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@Password", (object) password),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[2].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_ChangePassword", SqlParameters);
        flag = (int) SqlParameters[2].Value == 0;
      }
      catch (Exception ex)
      {
        if (RemoteBussiness.ilog_0.IsErrorEnabled)
          RemoteBussiness.ilog_0.Error((object) "SP_Update_RemoteServer: ", ex);
      }
      return flag;
    }

    public bool CheckUsername(string username, string password, ref int admin)
    {
      SqlParameter[] SqlParameters = new SqlParameter[4]
      {
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@Password", (object) password),
        new SqlParameter("@ID", SqlDbType.Int),
        new SqlParameter("@ApplicationID", SqlDbType.Int)
      };
      SqlParameters[2].Direction = ParameterDirection.Output;
      SqlParameters[3].Direction = ParameterDirection.Output;
      this.db.RunProcedure("Mem_Users_Accede", SqlParameters);
      int result = 0;
      int.TryParse(SqlParameters[2].Value.ToString(), out result);
      int.TryParse(SqlParameters[3].Value.ToString(), out admin);
      return result > 0;
    }

    public bool CreateUsername(string applicationid, string username, string password)
    {
      SqlParameter[] SqlParameters = new SqlParameter[4]
      {
        new SqlParameter("@ApplicationId", (object) applicationid),
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@Password", (object) password),
        new SqlParameter("@UserId", SqlDbType.Int)
      };
      SqlParameters[3].Direction = ParameterDirection.Output;
      bool username1;
      if (username1 = this.db.RunProcedure("Mem_Users_CreateUser", SqlParameters))
        username1 = (int) SqlParameters[3].Value > 0;
      return username1;
    }

    public void Dispose()
    {
      this.db.Dispose();
      GC.SuppressFinalize((object) this);
    }
  }
}
