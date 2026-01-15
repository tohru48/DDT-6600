// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.AchievementDataInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class AchievementDataInfo : DataObject
  {
    private int int_0;
    private DateTime dateTime_0;
    private bool bool_0;
    private int int_1;

    public int AchievementID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public DateTime CompletedDate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public bool IsComplete
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int UserID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }
  }
}
