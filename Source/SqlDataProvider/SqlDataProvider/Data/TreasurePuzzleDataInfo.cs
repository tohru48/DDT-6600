// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.TreasurePuzzleDataInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class TreasurePuzzleDataInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;
    private int int_10;
    private int int_11;
    private int int_12;
    private int int_13;
    private int int_14;
    private bool bool_0;

    public int ID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
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

    public int PuzzleID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int Int32_0
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int Int32_1
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int Int32_2
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int Int32_3
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int Int32_4
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int Int32_5
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int Int32_6
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int Int32_7
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int Int32_8
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int Int32_9
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public int Int32_10
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public int Int32_11
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public bool IsGetAward
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public bool canGetReward()
    {
      return !this.bool_0 && this.int_3 + this.int_5 + this.int_7 + this.int_9 + this.int_11 + this.int_13 == this.int_4 + this.int_6 + this.int_8 + this.int_10 + this.int_12 + this.int_14;
    }
  }
}
