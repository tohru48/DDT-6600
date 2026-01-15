// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.BaseClass.Sql_DbObject
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace SqlDataProvider.BaseClass
{
  public sealed class Sql_DbObject : IDisposable
  {
    private SqlConnection sqlConnection_0;
    private SqlCommand sqlCommand_0;
    private SqlDataAdapter sqlDataAdapter_0;

    public Sql_DbObject() => this.sqlConnection_0 = new SqlConnection();

    public Sql_DbObject(string Path_Source, string Conn_DB)
    {
      switch (Path_Source)
      {
        case "WebConfig":
          this.sqlConnection_0 = new SqlConnection(ConfigurationManager.ConnectionStrings[Conn_DB].ConnectionString);
          break;
        case "File":
          this.sqlConnection_0 = new SqlConnection(Conn_DB);
          break;
        case "AppConfig":
          this.sqlConnection_0 = new SqlConnection(ConfigurationManager.AppSettings[Conn_DB]);
          break;
        default:
          this.sqlConnection_0 = new SqlConnection(Conn_DB);
          break;
      }
    }

    private static bool smethod_0(SqlConnection sqlConnection_1)
    {
      bool flag;
      try
      {
        if (sqlConnection_1.State != ConnectionState.Open)
        {
          sqlConnection_1.Open();
          flag = true;
        }
        else
          flag = true;
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("打开数据库连接错误:" + ex.Message.Trim());
        flag = false;
      }
      return flag;
    }

    public bool Exesqlcomm(string Sqlcomm)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.CommandType = CommandType.Text;
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandText = Sqlcomm;
        this.sqlCommand_0.ExecuteNonQuery();
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行sql语句: " + Sqlcomm + "错误信息为: " + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public int GetRecordCount(string Sqlcomm)
    {
      int recordCount = 0;
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        recordCount = 0;
      }
      else
      {
        try
        {
          this.sqlCommand_0 = new SqlCommand();
          this.sqlCommand_0.Connection = this.sqlConnection_0;
          this.sqlCommand_0.CommandType = CommandType.Text;
          this.sqlCommand_0.CommandText = Sqlcomm;
          recordCount = this.sqlCommand_0.ExecuteScalar() != null ? (int) this.sqlCommand_0.ExecuteScalar() : 0;
        }
        catch (SqlException ex)
        {
          ApplicationLog.WriteError("执行sql语句: " + Sqlcomm + "错误信息为: " + ex.Message.Trim());
        }
        finally
        {
          this.sqlConnection_0.Close();
          this.wGtuivhew(true);
        }
      }
      return recordCount;
    }

    public DataTable GetDataTableBySqlcomm(string TableName, string Sqlcomm)
    {
      DataTable dataTable = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return dataTable;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.Text;
        this.sqlCommand_0.CommandText = Sqlcomm;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataTable);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行sql语句: " + Sqlcomm + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTable;
    }

    public DataSet GetDataSetBySqlcomm(string TableName, string Sqlcomm)
    {
      DataSet dataSet = new DataSet();
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return dataSet;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.Text;
        this.sqlCommand_0.CommandText = Sqlcomm;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataSet);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行Sql语句：" + Sqlcomm + "错误信息为：" + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataSet;
    }

    public bool FillSqlDataReader(ref SqlDataReader Sdr, string SqlComm)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.Text;
        this.sqlCommand_0.CommandText = SqlComm;
        Sdr = this.sqlCommand_0.ExecuteReader(CommandBehavior.CloseConnection);
        return true;
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行Sql语句：" + SqlComm + "错误信息为：" + ex.Message.Trim());
      }
      finally
      {
        this.wGtuivhew(true);
      }
      return false;
    }

    public DataTable GetDataTableBySqlcomm(
      string TableName,
      string Sqlcomm,
      int StartRecordNo,
      int PageSize)
    {
      DataTable dataTableBySqlcomm = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataTableBySqlcomm.Dispose();
        this.wGtuivhew(true);
        return dataTableBySqlcomm;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.Text;
        this.sqlCommand_0.CommandText = Sqlcomm;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(new DataSet()
        {
          Tables = {
            dataTableBySqlcomm
          }
        }, StartRecordNo, PageSize, TableName);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行sql语句: " + Sqlcomm + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTableBySqlcomm;
    }

    public bool RunProcedure(string ProcedureName, SqlParameter[] SqlParameters)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlCommand_0.ExecuteNonQuery();
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public bool RunProcedure(string ProcedureName)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        this.sqlCommand_0.ExecuteNonQuery();
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public bool GetReader(ref SqlDataReader ResultDataReader, string ProcedureName)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      bool reader;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        ResultDataReader = this.sqlCommand_0.ExecuteReader(CommandBehavior.CloseConnection);
        return true;
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        reader = false;
      }
      return reader;
    }

    public bool GetReader(
      ref SqlDataReader ResultDataReader,
      string ProcedureName,
      SqlParameter[] SqlParameters)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      bool reader;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        ResultDataReader = this.sqlCommand_0.ExecuteReader(CommandBehavior.CloseConnection);
        return true;
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        reader = false;
      }
      return reader;
    }

    public DataSet GetDataSet(string ProcedureName, SqlParameter[] SqlParameters)
    {
      DataSet dataSet = new DataSet();
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataSet.Dispose();
        return dataSet;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataSet);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程：" + ProcedureName + "错信信息为：" + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataSet;
    }

    public bool GetDataSet(
      ref DataSet ResultDataSet,
      ref int row_total,
      string TableName,
      string ProcedureName,
      int StartRecordNo,
      int PageSize,
      SqlParameter[] SqlParameters)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        row_total = 0;
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        DataSet dataSet = new DataSet();
        row_total = this.sqlDataAdapter_0.Fill(dataSet);
        this.sqlDataAdapter_0.Fill(ResultDataSet, StartRecordNo, PageSize, TableName);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程：" + ProcedureName + "错误信息为：" + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public DataSet GetDateSet(
      string DatesetName,
      string ProcedureName,
      SqlParameter[] SqlParameters)
    {
      DataSet dataSet = new DataSet(DatesetName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataSet.Dispose();
        return dataSet;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataSet);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程：" + ProcedureName + "错信信息为：" + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataSet;
    }

    public DataTable GetDataTable(
      string TableName,
      string ProcedureName,
      SqlParameter[] SqlParameters)
    {
      return this.GetDataTable(TableName, ProcedureName, SqlParameters, -1);
    }

    public DataTable GetDataTable(
      string TableName,
      string ProcedureName,
      SqlParameter[] SqlParameters,
      int commandTimeout)
    {
      DataTable dataTable = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataTable.Dispose();
        this.wGtuivhew(true);
        return dataTable;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        if (commandTimeout >= 0)
          this.sqlCommand_0.CommandTimeout = commandTimeout;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataTable);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTable;
    }

    public DataTable GetDataTable(string TableName, string ProcedureName)
    {
      DataTable dataTable = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataTable.Dispose();
        this.wGtuivhew(true);
        return dataTable;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(dataTable);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTable;
    }

    public DataTable GetDataTable(
      string TableName,
      string ProcedureName,
      int StartRecordNo,
      int PageSize)
    {
      DataTable dataTable = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataTable.Dispose();
        this.wGtuivhew(true);
        return dataTable;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(new DataSet()
        {
          Tables = {
            dataTable
          }
        }, StartRecordNo, PageSize, TableName);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTable;
    }

    public DataTable GetDataTable(
      string TableName,
      string ProcedureName,
      SqlParameter[] SqlParameters,
      int StartRecordNo,
      int PageSize)
    {
      DataTable dataTable = new DataTable(TableName);
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
      {
        dataTable.Dispose();
        this.wGtuivhew(true);
        return dataTable;
      }
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        this.sqlDataAdapter_0.Fill(new DataSet()
        {
          Tables = {
            dataTable
          }
        }, StartRecordNo, PageSize, TableName);
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return dataTable;
    }

    public bool GetDataTable(
      ref DataTable ResultTable,
      string TableName,
      string ProcedureName,
      int StartRecordNo,
      int PageSize)
    {
      ResultTable = (DataTable) null;
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        DataSet dataSet = new DataSet();
        dataSet.Tables.Add(ResultTable);
        this.sqlDataAdapter_0.Fill(dataSet, StartRecordNo, PageSize, TableName);
        ResultTable = dataSet.Tables[TableName];
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public bool GetDataTable(
      ref DataTable ResultTable,
      string TableName,
      string ProcedureName,
      int StartRecordNo,
      int PageSize,
      SqlParameter[] SqlParameters)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlDataAdapter_0 = new SqlDataAdapter();
        this.sqlDataAdapter_0.SelectCommand = this.sqlCommand_0;
        DataSet dataSet = new DataSet();
        dataSet.Tables.Add(ResultTable);
        this.sqlDataAdapter_0.Fill(dataSet, StartRecordNo, PageSize, TableName);
        ResultTable = dataSet.Tables[TableName];
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
        return false;
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return true;
    }

    public void Dispose()
    {
      this.wGtuivhew(true);
      GC.SuppressFinalize((object) true);
    }

    private void wGtuivhew(bool bool_0)
    {
      if (!bool_0 || this.sqlDataAdapter_0 == null)
        return;
      if (this.sqlDataAdapter_0.SelectCommand != null)
      {
        if (this.sqlCommand_0.Connection != null)
          this.sqlDataAdapter_0.SelectCommand.Connection.Dispose();
        this.sqlDataAdapter_0.SelectCommand.Dispose();
      }
      this.sqlDataAdapter_0.Dispose();
      this.sqlDataAdapter_0 = (SqlDataAdapter) null;
    }

    public void BeginRunProcedure(string ProcedureName, SqlParameter[] SqlParameters)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return;
      try
      {
        this.sqlCommand_0 = new SqlCommand();
        this.sqlCommand_0.Connection = this.sqlConnection_0;
        this.sqlCommand_0.CommandType = CommandType.StoredProcedure;
        this.sqlCommand_0.CommandText = ProcedureName;
        for (int index = 0; index < SqlParameters.Length; ++index)
          this.sqlCommand_0.Parameters.Add(SqlParameters[index]);
        this.sqlCommand_0.BeginExecuteNonQuery();
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行存储过程: " + ProcedureName + "错误信息为: " + ex.Message.Trim());
      }
      finally
      {
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
    }

    public bool SetDataTable(
      DataTable dataTable,
      string desTableName,
      List<SqlBulkCopyColumnMapping> mapping)
    {
      if (!Sql_DbObject.smethod_0(this.sqlConnection_0))
        return false;
      SqlBulkCopy sqlBulkCopy = (SqlBulkCopy) null;
      bool flag;
      try
      {
        sqlBulkCopy = new SqlBulkCopy(this.sqlConnection_0, SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.UseInternalTransaction, (SqlTransaction) null);
        sqlBulkCopy.DestinationTableName = desTableName;
        sqlBulkCopy.NotifyAfter = dataTable.Rows.Count;
        if (mapping != null)
        {
          foreach (SqlBulkCopyColumnMapping bulkCopyColumnMapping in mapping)
            sqlBulkCopy.ColumnMappings.Add(bulkCopyColumnMapping);
        }
        sqlBulkCopy.WriteToServer(dataTable);
        flag = true;
      }
      catch (SqlException ex)
      {
        ApplicationLog.WriteError("执行SqlBulk写入时发生错误，错误信息为: " + ex.Message.Trim());
        flag = false;
      }
      finally
      {
        sqlBulkCopy?.Close();
        this.sqlConnection_0.Close();
        this.wGtuivhew(true);
      }
      return flag;
    }
  }
}
