// Decompiled with JetBrains decompiler
// Type: Bussiness.MemberShipBussiness
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
  public class MemberShipBussiness : IDisposable
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected Sql_DbObject db;

    public MemberShipBussiness() => this.db = new Sql_DbObject("AppConfig", "membershipDb");

    public eStoreInfo[] GetAlleStoreSale()
    {
      List<eStoreInfo> eStoreInfoList = new List<eStoreInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_eStore_Desc_Sale");
        while (ResultDataReader.Read())
          eStoreInfoList.Add(new eStoreInfo()
          {
            StoreID = (int) ResultDataReader["StoreID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            PriceValue = (int) ResultDataReader["PriceValue1"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            ValidDate = (int) ResultDataReader["ValidDate"],
            OldPriceValue = (int) ResultDataReader["PriceValue"]
          });
      }
      catch (Exception ex)
      {
        if (MemberShipBussiness.ilog_0.IsErrorEnabled)
          MemberShipBussiness.ilog_0.Error((object) "SP_eStore_Desc_Sale", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return eStoreInfoList.ToArray();
    }

    public eStoreInfo[] GetAlleStoreTopBuy()
    {
      List<eStoreInfo> eStoreInfoList = new List<eStoreInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_eStore_Desc_Buy");
        while (ResultDataReader.Read())
          eStoreInfoList.Add(new eStoreInfo()
          {
            StoreID = (int) ResultDataReader["StoreID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            PriceValue = (int) ResultDataReader["PriceValue"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            ValidDate = (int) ResultDataReader["ValidDate"]
          });
      }
      catch (Exception ex)
      {
        if (MemberShipBussiness.ilog_0.IsErrorEnabled)
          MemberShipBussiness.ilog_0.Error((object) "SP_eStore_Desc_Buy", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return eStoreInfoList.ToArray();
    }

    public eStoreInfo[] GetAlleStoreByDesc()
    {
      List<eStoreInfo> eStoreInfoList = new List<eStoreInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_eStore_Desc");
        while (ResultDataReader.Read())
          eStoreInfoList.Add(new eStoreInfo()
          {
            StoreID = (int) ResultDataReader["StoreID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            PriceValue = (int) ResultDataReader["PriceValue"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            ValidDate = (int) ResultDataReader["ValidDate"]
          });
      }
      catch (Exception ex)
      {
        if (MemberShipBussiness.ilog_0.IsErrorEnabled)
          MemberShipBussiness.ilog_0.Error((object) "eStore", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return eStoreInfoList.ToArray();
    }

    public eStoreInfo[] GetAlleStore()
    {
      List<eStoreInfo> eStoreInfoList = new List<eStoreInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_eStore_All");
        while (ResultDataReader.Read())
          eStoreInfoList.Add(new eStoreInfo()
          {
            StoreID = (int) ResultDataReader["StoreID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            PriceValue = (int) ResultDataReader["PriceValue"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            ValidDate = (int) ResultDataReader["ValidDate"]
          });
      }
      catch (Exception ex)
      {
        if (MemberShipBussiness.ilog_0.IsErrorEnabled)
          MemberShipBussiness.ilog_0.Error((object) "eStore", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return eStoreInfoList.ToArray();
    }

    public bool CheckUsername(string applicationname, string username, string password)
    {
      SqlParameter[] SqlParameters = new SqlParameter[4]
      {
        new SqlParameter("@ApplicationName", (object) applicationname),
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@password", (object) password),
        new SqlParameter("@UserId", SqlDbType.Int)
      };
      SqlParameters[3].Direction = ParameterDirection.Output;
      this.db.RunProcedure("Mem_Users_Accede", SqlParameters);
      int result = 0;
      int.TryParse(SqlParameters[3].Value.ToString(), out result);
      return result > 0;
    }

    public bool CreateUsername(
      string applicationname,
      string username,
      string password,
      string email,
      string passwordformat,
      string passwordsalt,
      bool usersex)
    {
      SqlParameter[] SqlParameters = new SqlParameter[8]
      {
        new SqlParameter("@ApplicationName", (object) applicationname),
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@password", (object) password),
        new SqlParameter("@email", (object) email),
        new SqlParameter("@PasswordFormat", (object) passwordformat),
        new SqlParameter("@PasswordSalt", (object) passwordsalt),
        new SqlParameter("@UserSex", (object) usersex),
        new SqlParameter("@UserId", SqlDbType.Int)
      };
      SqlParameters[7].Direction = ParameterDirection.Output;
      bool username1;
      if (username1 = this.db.RunProcedure("Mem_Users_CreateUser", SqlParameters))
        username1 = (int) SqlParameters[7].Value > 0;
      return username1;
    }

    public void Dispose()
    {
      this.db.Dispose();
      GC.SuppressFinalize((object) this);
    }

    public bool ExistsUsername(string username)
    {
      SqlParameter[] SqlParameters = new SqlParameter[2]
      {
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@UserCOUNT", SqlDbType.Int)
      };
      SqlParameters[1].Direction = ParameterDirection.Output;
      this.db.RunProcedure("Mem_UserInfo_SearchName", SqlParameters);
      return (int) SqlParameters[1].Value > 0;
    }

    public int CheckPoint(string username)
    {
      SqlParameter[] SqlParameters = new SqlParameter[2]
      {
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@Point", SqlDbType.Int)
      };
      SqlParameters[1].Direction = ParameterDirection.Output;
      this.db.RunProcedure("Mem_User_Point", SqlParameters);
      return (int) SqlParameters[1].Value;
    }

    public bool RemovePoint(string username, int Point)
    {
      SqlParameter[] SqlParameters = new SqlParameter[3]
      {
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@Point", (object) Point),
        new SqlParameter("@Result", SqlDbType.Int)
      };
      SqlParameters[2].Direction = ParameterDirection.ReturnValue;
      this.db.RunProcedure("Mem_User_Remove_Point", SqlParameters);
      return (int) SqlParameters[2].Value == 0;
    }

    public bool CheckAdmin(string username)
    {
      SqlParameter[] SqlParameters = new SqlParameter[2]
      {
        new SqlParameter("@UserName", (object) username),
        new SqlParameter("@UserCOUNT", SqlDbType.Int)
      };
      SqlParameters[1].Direction = ParameterDirection.Output;
      this.db.RunProcedure("Mem_UserInfo_Addmin", SqlParameters);
      return (int) SqlParameters[1].Value > 0;
    }
  }
}
