// Decompiled with JetBrains decompiler
// Type: DAL.SqlHelperParameterCache
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace DAL
{
  public sealed class SqlHelperParameterCache
  {
    private static Hashtable ykejnltkcf = Hashtable.Synchronized(new Hashtable());

    private SqlHelperParameterCache()
    {
    }

    private static SqlParameter[] smethod_0(string string_0, string string_1, bool bool_0)
    {
      SqlParameter[] sqlParameterArray;
      using (SqlConnection connection = new SqlConnection(string_0))
      {
        using (SqlCommand command = new SqlCommand(string_1, connection))
        {
          connection.Open();
          command.CommandType = CommandType.StoredProcedure;
          SqlCommandBuilder.DeriveParameters(command);
          if (!bool_0)
            command.Parameters.RemoveAt(0);
          SqlParameter[] array = new SqlParameter[command.Parameters.Count];
          command.Parameters.CopyTo(array, 0);
          sqlParameterArray = array;
        }
      }
      return sqlParameterArray;
    }

    private static SqlParameter[] smethod_1(SqlParameter[] sqlParameter_0)
    {
      SqlParameter[] sqlParameterArray = new SqlParameter[sqlParameter_0.Length];
      int index = 0;
      for (int length = sqlParameter_0.Length; index < length; ++index)
        sqlParameterArray[index] = (SqlParameter) ((ICloneable) sqlParameter_0[index]).Clone();
      return sqlParameterArray;
    }

    public static void CacheParameterSet(
      string connectionString,
      string commandText,
      params SqlParameter[] commandParameters)
    {
      string key = connectionString + ":" + commandText;
      SqlHelperParameterCache.ykejnltkcf[(object) key] = (object) commandParameters;
    }

    public static SqlParameter[] GetCachedParameterSet(string connectionString, string commandText)
    {
      string key = connectionString + ":" + commandText;
      SqlParameter[] sqlParameter_0 = (SqlParameter[]) SqlHelperParameterCache.ykejnltkcf[(object) key];
      return sqlParameter_0 == null ? (SqlParameter[]) null : SqlHelperParameterCache.smethod_1(sqlParameter_0);
    }

    public static SqlParameter[] GetSpParameterSet(string connectionString, string spName)
    {
      return SqlHelperParameterCache.GetSpParameterSet(connectionString, spName, false);
    }

    public static SqlParameter[] GetSpParameterSet(
      string connectionString,
      string spName,
      bool includeReturnValueParameter)
    {
      string key = connectionString + ":" + spName + (includeReturnValueParameter ? ":include ReturnValue Parameter" : "");
      return SqlHelperParameterCache.smethod_1((SqlParameter[]) SqlHelperParameterCache.ykejnltkcf[(object) key] ?? (SqlParameter[]) (SqlHelperParameterCache.ykejnltkcf[(object) key] = (object) SqlHelperParameterCache.smethod_0(connectionString, spName, includeReturnValueParameter)));
    }
  }
}
