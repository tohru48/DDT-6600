// Decompiled with JetBrains decompiler
// Type: Bussiness.BaseBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using log4net;
using SqlDataProvider.BaseClass;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

#nullable disable
namespace Bussiness
{
  public class BaseBussiness : IDisposable
  {
    protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    protected Sql_DbObject db;

    public BaseBussiness() => this.db = new Sql_DbObject("AppConfig", "conString");

    public DataTable GetPage(
      string queryStr,
      string queryWhere,
      int pageCurrent,
      int pageSize,
      string fdShow,
      string fdOreder,
      string fdKey,
      ref int total)
    {
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[8]
        {
          new SqlParameter("@QueryStr", (object) queryStr),
          new SqlParameter("@QueryWhere", (object) queryWhere),
          new SqlParameter("@PageSize", (object) pageSize),
          new SqlParameter("@PageCurrent", (object) pageCurrent),
          new SqlParameter("@FdShow", (object) fdShow),
          new SqlParameter("@FdOrder", (object) fdOreder),
          new SqlParameter("@FdKey", (object) fdKey),
          new SqlParameter("@TotalRow", (object) total)
        };
        SqlParameters[7].Direction = ParameterDirection.Output;
        DataTable dataTable = this.db.GetDataTable(queryStr, "SP_CustomPage", SqlParameters, 120);
        total = (int) SqlParameters[7].Value;
        return dataTable;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      return new DataTable(queryStr);
    }

    public void Dispose()
    {
      this.db.Dispose();
      GC.SuppressFinalize((object) this);
    }
  }
}
