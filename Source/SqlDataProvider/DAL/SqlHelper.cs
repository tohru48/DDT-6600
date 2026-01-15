// Decompiled with JetBrains decompiler
// Type: DAL.SqlHelper
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

#nullable disable
namespace DAL
{
  public sealed class SqlHelper
  {
    private SqlHelper()
    {
    }

    private static void smethod_0(SqlCommand sqlCommand_0, SqlParameter[] sqlParameter_0)
    {
      for (int index = 0; index < sqlParameter_0.Length; ++index)
      {
        SqlParameter sqlParameter = sqlParameter_0[index];
        if (sqlParameter.Direction == ParameterDirection.InputOutput && sqlParameter.Value == null)
          sqlParameter.Value = (object) DBNull.Value;
        sqlCommand_0.Parameters.Add(sqlParameter);
      }
    }

    public static void AssignParameterValues(
      SqlParameter[] commandParameters,
      params object[] parameterValues)
    {
      if (commandParameters == null || parameterValues == null)
        return;
      if (commandParameters.Length != parameterValues.Length)
        throw new ArgumentException("Parameter count does not match Parameter Value count.");
      int index = 0;
      for (int length = commandParameters.Length; index < length; ++index)
      {
        if (parameterValues[index] != null && (commandParameters[index].Direction == ParameterDirection.Input || commandParameters[index].Direction == ParameterDirection.InputOutput))
          commandParameters[index].Value = parameterValues[index];
      }
    }

    public static void AssignParameterValues(
      SqlParameter[] commandParameters,
      Hashtable parameterValues)
    {
      if (commandParameters == null || parameterValues == null)
        return;
      if (commandParameters.Length != parameterValues.Count)
        throw new ArgumentException("Parameter count does not match Parameter Value count.");
      int index = 0;
      for (int length = commandParameters.Length; index < length; ++index)
      {
        if (parameterValues[(object) commandParameters[index].ParameterName] != null && (commandParameters[index].Direction == ParameterDirection.Input || commandParameters[index].Direction == ParameterDirection.InputOutput))
          commandParameters[index].Value = parameterValues[(object) commandParameters[index].ParameterName];
      }
    }

    private static void smethod_1(
      SqlCommand sqlCommand_0,
      SqlConnection sqlConnection_0,
      SqlTransaction sqlTransaction_0,
      CommandType commandType_0,
      string string_0,
      SqlParameter[] sqlParameter_0)
    {
      if (sqlConnection_0.State != ConnectionState.Open)
        sqlConnection_0.Open();
      sqlCommand_0.Connection = sqlConnection_0;
      sqlCommand_0.CommandText = string_0;
      if (sqlTransaction_0 != null)
        sqlCommand_0.Transaction = sqlTransaction_0;
      sqlCommand_0.CommandType = commandType_0;
      if (sqlParameter_0 == null)
        return;
      SqlHelper.smethod_0(sqlCommand_0, sqlParameter_0);
    }

    public static int ExecuteNonQuery(
      string connectionString,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteNonQuery(connectionString, commandType, commandText, (SqlParameter[]) null);
    }

    public static int ExecuteNonQuery(
      string connectionString,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      int num;
      using (SqlConnection connection = new SqlConnection(connectionString))
      {
        connection.Open();
        num = SqlHelper.ExecuteNonQuery(connection, commandType, commandText, commandParameters);
      }
      return num;
    }

    public static int ExecuteNonQuery(
      string connectionString,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static int ExecuteNonQuery(
      string connectionString,
      string spName,
      Hashtable parameterValues)
    {
      if (parameterValues == null || parameterValues.Count <= 0)
        return SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static int ExecuteNonQuery(
      SqlConnection connection,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteNonQuery(connection, commandType, commandText, (SqlParameter[]) null);
    }

    public static int ExecuteNonQuery(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, connection, (SqlTransaction) null, commandType, commandText, commandParameters);
      int num = sqlCommand_0.ExecuteNonQuery();
      sqlCommand_0.Parameters.Clear();
      return num;
    }

    public static int ExecuteNonQuery(
      SqlConnection connection,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static int ExecuteNonQuery(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, transaction.Connection, transaction, commandType, commandText, commandParameters);
      int num = sqlCommand_0.ExecuteNonQuery();
      sqlCommand_0.Parameters.Clear();
      return num;
    }

    public static int ExecuteNonQuery(
      SqlTransaction transaction,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static DataSet ExecuteDataset(
      string connectionString,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteDataset(connectionString, commandType, commandText, (SqlParameter[]) null);
    }

    public static DataSet ExecuteDataset(
      string connectionString,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      DataSet dataSet;
      using (SqlConnection connection = new SqlConnection(connectionString))
      {
        connection.Open();
        dataSet = SqlHelper.ExecuteDataset(connection, commandType, commandText, commandParameters);
      }
      return dataSet;
    }

    public static DataSet ExecuteDataset(
      string connectionString,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteDataset(connectionString, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteDataset(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static DataSet ExecuteDataset(
      SqlConnection connection,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteDataset(connection, commandType, commandText, (SqlParameter[]) null);
    }

    public static DataSet ExecuteDataset(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand, connection, (SqlTransaction) null, commandType, commandText, commandParameters);
      SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
      DataSet dataSet = new DataSet();
      sqlDataAdapter.Fill(dataSet);
      sqlCommand.Parameters.Clear();
      return dataSet;
    }

    public static DataSet ExecuteDataset(
      SqlConnection connection,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteDataset(connection, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteDataset(connection, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static DataSet ExecuteDataset(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteDataset(transaction, commandType, commandText, (SqlParameter[]) null);
    }

    public static DataSet ExecuteDataset(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters);
      SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
      DataSet dataSet = new DataSet();
      sqlDataAdapter.Fill(dataSet);
      sqlCommand.Parameters.Clear();
      return dataSet;
    }

    public static DataSet ExecuteDataset(
      SqlTransaction transaction,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteDataset(transaction, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteDataset(transaction, CommandType.StoredProcedure, spName, spParameterSet);
    }

    private static SqlDataReader smethod_2(
      SqlConnection sqlConnection_0,
      SqlTransaction sqlTransaction_0,
      CommandType commandType_0,
      string string_0,
      SqlParameter[] sqlParameter_0,
      SqlHelper.Enum3 enum3_0)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, sqlConnection_0, sqlTransaction_0, commandType_0, string_0, sqlParameter_0);
      SqlDataReader sqlDataReader = enum3_0 != (SqlHelper.Enum3) 1 ? sqlCommand_0.ExecuteReader(CommandBehavior.CloseConnection) : sqlCommand_0.ExecuteReader();
      sqlCommand_0.Parameters.Clear();
      return sqlDataReader;
    }

    public static SqlDataReader ExecuteReader(
      string connectionString,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteReader(connectionString, commandType, commandText, (SqlParameter[]) null);
    }

    public static SqlDataReader ExecuteReader(
      string connectionString,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlConnection sqlConnection_0 = new SqlConnection(connectionString);
      sqlConnection_0.Open();
      SqlDataReader sqlDataReader;
      try
      {
        sqlDataReader = SqlHelper.smethod_2(sqlConnection_0, (SqlTransaction) null, commandType, commandText, commandParameters, (SqlHelper.Enum3) 0);
      }
      catch
      {
        sqlConnection_0.Close();
        throw;
      }
      return sqlDataReader;
    }

    public static SqlDataReader ExecuteReader(
      string connectionString,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteReader(connectionString, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteReader(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static SqlDataReader ExecuteReader(
      SqlConnection connection,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteReader(connection, commandType, commandText, (SqlParameter[]) null);
    }

    public static SqlDataReader ExecuteReader(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      return SqlHelper.smethod_2(connection, (SqlTransaction) null, commandType, commandText, commandParameters, (SqlHelper.Enum3) 1);
    }

    public static SqlDataReader ExecuteReader(
      SqlConnection connection,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteReader(connection, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteReader(connection, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static SqlDataReader ExecuteReader(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteReader(transaction, commandType, commandText, (SqlParameter[]) null);
    }

    public static SqlDataReader ExecuteReader(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      return SqlHelper.smethod_2(transaction.Connection, transaction, commandType, commandText, commandParameters, (SqlHelper.Enum3) 1);
    }

    public static SqlDataReader ExecuteReader(
      SqlTransaction transaction,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteReader(transaction, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteReader(transaction, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static object ExecuteScalar(
      string connectionString,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteScalar(connectionString, commandType, commandText, (SqlParameter[]) null);
    }

    public static object ExecuteScalar(
      string connectionString,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      object obj;
      using (SqlConnection connection = new SqlConnection(connectionString))
      {
        connection.Open();
        obj = SqlHelper.ExecuteScalar(connection, commandType, commandText, commandParameters);
      }
      return obj;
    }

    public static object ExecuteScalar(
      string connectionString,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static object ExecuteScalar(
      SqlConnection connection,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteScalar(connection, commandType, commandText, (SqlParameter[]) null);
    }

    public static object ExecuteScalar(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, connection, (SqlTransaction) null, commandType, commandText, commandParameters);
      object obj = sqlCommand_0.ExecuteScalar();
      sqlCommand_0.Parameters.Clear();
      return obj;
    }

    public static object ExecuteScalar(
      SqlConnection connection,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteScalar(connection, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteScalar(connection, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static object ExecuteScalar(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteScalar(transaction, commandType, commandText, (SqlParameter[]) null);
    }

    public static object ExecuteScalar(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, transaction.Connection, transaction, commandType, commandText, commandParameters);
      object obj = sqlCommand_0.ExecuteScalar();
      sqlCommand_0.Parameters.Clear();
      return obj;
    }

    public static object ExecuteScalar(
      SqlTransaction transaction,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteScalar(transaction, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteScalar(transaction, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static XmlReader ExecuteXmlReader(
      SqlConnection connection,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteXmlReader(connection, commandType, commandText, (SqlParameter[]) null);
    }

    public static XmlReader ExecuteXmlReader(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, connection, (SqlTransaction) null, commandType, commandText, commandParameters);
      XmlReader xmlReader = sqlCommand_0.ExecuteXmlReader();
      sqlCommand_0.Parameters.Clear();
      return xmlReader;
    }

    public static XmlReader ExecuteXmlReader(
      SqlConnection connection,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteXmlReader(connection, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteXmlReader(connection, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static XmlReader ExecuteXmlReader(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText)
    {
      return SqlHelper.ExecuteXmlReader(transaction, commandType, commandText, (SqlParameter[]) null);
    }

    public static XmlReader ExecuteXmlReader(
      SqlTransaction transaction,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, transaction.Connection, transaction, commandType, commandText, commandParameters);
      XmlReader xmlReader = sqlCommand_0.ExecuteXmlReader();
      sqlCommand_0.Parameters.Clear();
      return xmlReader;
    }

    public static XmlReader ExecuteXmlReader(
      SqlTransaction transaction,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues == null || parameterValues.Length <= 0)
        return SqlHelper.ExecuteXmlReader(transaction, CommandType.StoredProcedure, spName);
      SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(transaction.Connection.ConnectionString, spName);
      SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
      return SqlHelper.ExecuteXmlReader(transaction, CommandType.StoredProcedure, spName, spParameterSet);
    }

    public static void BeginExecuteNonQuery(
      SqlConnection connection,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      SqlCommand sqlCommand_0 = new SqlCommand();
      SqlHelper.smethod_1(sqlCommand_0, connection, (SqlTransaction) null, commandType, commandText, commandParameters);
      sqlCommand_0.BeginExecuteNonQuery();
      sqlCommand_0.Parameters.Clear();
    }

    public static void BeginExecuteNonQuery(
      string connectionString,
      CommandType commandType,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      using (SqlConnection connection = new SqlConnection(connectionString))
      {
        connection.Open();
        SqlHelper.ExecuteNonQuery(connection, commandType, commandText, commandParameters);
      }
    }

    public static void BeginExecuteNonQuery(
      string connectionString,
      string spName,
      params object[] parameterValues)
    {
      if (parameterValues != null && parameterValues.Length > 0)
      {
        SqlParameter[] spParameterSet = SqlHelperParameterCache.GetSpParameterSet(connectionString, spName);
        SqlHelper.AssignParameterValues(spParameterSet, parameterValues);
        SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, spParameterSet);
      }
      else
        SqlHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName);
    }

    private enum Enum3
    {
    }
  }
}
