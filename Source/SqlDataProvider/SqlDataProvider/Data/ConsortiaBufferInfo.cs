// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaBufferInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaBufferInfo
  {
    public int ConsortiaID { get; set; }

    public int BufferID { get; set; }

    public DateTime BeginDate { get; set; }

    public int ValidDate { get; set; }

    public bool IsOpen { get; set; }

    public int Type { get; set; }

    public int Value { get; set; }
  }
}
