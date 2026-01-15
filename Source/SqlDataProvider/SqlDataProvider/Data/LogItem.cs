// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.LogItem
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class LogItem
  {
    public int ApplicationId { get; set; }

    public int SubId { get; set; }

    public int LineId { get; set; }

    public DateTime EnterTime { get; set; }

    public int UserId { get; set; }

    public int Operation { get; set; }

    public string ItemName { get; set; }

    public int ItemID { get; set; }

    public string BeginProperty { get; set; }

    public string EndProperty { get; set; }

    public int Result { get; set; }
  }
}
