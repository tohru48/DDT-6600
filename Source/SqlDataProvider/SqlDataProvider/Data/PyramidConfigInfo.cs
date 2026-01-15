// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PyramidConfigInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class PyramidConfigInfo
  {
    private int int_0;
    private bool bool_0;
    private bool bool_1;
    private DateTime dateTime_0;
    private DateTime dateTime_1;
    private int int_1;
    private int int_2;
    private int[] int_3;

    public int UserID
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    public bool isOpen
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public bool isScoreExchange
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }

    public DateTime beginTime
    {
      get => this.dateTime_0;
      set => this.dateTime_0 = value;
    }

    public DateTime endTime
    {
      get => this.dateTime_1;
      set => this.dateTime_1 = value;
    }

    public int freeCount
    {
      get => this.int_1;
      set => this.int_1 = value;
    }

    public int turnCardPrice
    {
      get => this.int_2;
      set => this.int_2 = value;
    }

    public int[] revivePrice
    {
      get => this.int_3;
      set => this.int_3 = value;
    }
  }
}
