// Decompiled with JetBrains decompiler
// Type: Bussiness.OrderBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
  public class OrderBussiness : BaseBussiness
  {
    public bool AddOrder(
      string order,
      double amount,
      string username,
      string payWay,
      string serverId)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[6]
        {
          new SqlParameter("@Order", (object) order),
          new SqlParameter("@Amount", (object) amount),
          new SqlParameter("@Username", (object) username),
          new SqlParameter("@PayWay", (object) payWay),
          new SqlParameter("@ServerId", (object) serverId),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[5].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_Charge_Order", SqlParameters);
        flag = (int) SqlParameters[5].Value == 0;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      return flag;
    }

    public string GetOrderToName(string order, ref string serverId)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@Order", (object) order)
        };
        this.db.GetReader(ref ResultDataReader, "SP_Charge_Order_Single", SqlParameters);
        if (ResultDataReader.Read())
        {
          serverId = ResultDataReader["ServerId"] == null ? "" : ResultDataReader["ServerId"].ToString();
          return ResultDataReader["UserName"] == null ? "" : ResultDataReader["UserName"].ToString();
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return "";
    }
  }
}
