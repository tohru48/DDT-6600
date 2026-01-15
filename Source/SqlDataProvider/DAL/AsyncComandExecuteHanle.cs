// Decompiled with JetBrains decompiler
// Type: DAL.AsyncComandExecuteHanle
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Data.SqlClient;

#nullable disable
namespace DAL
{
  public delegate void AsyncComandExecuteHanle(SqlCommand cmd, IAsyncResult result, object state);
}
