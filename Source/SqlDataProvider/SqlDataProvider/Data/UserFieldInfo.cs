// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UserFieldInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UserFieldInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private DateTime dateTime_0;
    private int int_4;
    private int int_5;
    private DateTime dateTime_1;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;
    private int int_10;
    private int int_11;
    private int int_12;
    private bool bool_0;
    private bool bool_1;
    private DateTime dateTime_2;

    public int ID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int FarmID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int FieldID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int SeedID
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public DateTime PlantTime
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int AccelerateTime
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int FieldValidDate
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public DateTime PayTime
    {
      get => this.dateTime_1;
      set
      {
        this.dateTime_1 = value;
        this._isDirty = true;
      }
    }

    public int payFieldTime
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int GainCount
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int gainFieldId
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int AutoSeedID
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int AutoFertilizerID
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int AutoSeedIDCount
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int AutoFertilizerCount
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public bool isAutomatic
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public bool IsExit
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public DateTime AutomaticTime
    {
      get => this.dateTime_2;
      set
      {
        this.dateTime_2 = value;
        this._isDirty = true;
      }
    }

    public bool IsValidField()
    {
      return this.int_6 == 0 || DateTime.Compare(this.dateTime_1.AddDays((double) this.int_6), DateTime.Now) > 0;
    }

    public bool isDig()
    {
      return this.int_5 - ((int) (DateTime.Now - this.dateTime_0).TotalMinutes + this.int_4) <= 0;
    }
  }
}
