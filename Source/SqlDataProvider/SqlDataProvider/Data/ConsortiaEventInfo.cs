// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaEventInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaEventInfo
  {
    public int ID { get; set; }

    public int ConsortiaID { get; set; }

    public string Remark { get; set; }

    public DateTime Date { get; set; }

    public bool IsExist { get; set; }

    public int Type { get; set; }
  }
}
