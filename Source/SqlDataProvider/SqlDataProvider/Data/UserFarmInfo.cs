// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UserFarmInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UserFarmInfo : DataObject
  {
    private UserFieldInfo userFieldInfo_0;
    private int int_0;
    private int int_1;
    private string string_0;
    private string string_1;
    private DateTime dateTime_0;
    private int ScveIljHuL;
    private int ewfeFgCrnp;
    private string string_2;
    private int zBjehlucUh;
    private int int_2;
    private int int_3;
    private int int_4;
    private bool bool_0;
    private int int_5;
    private bool bool_1;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;
    private int int_10;
    private DateTime dateTime_1;
    private int int_11;

    public UserFieldInfo Field
    {
      get => this.userFieldInfo_0;
      set
      {
        this.userFieldInfo_0 = value;
        this._isDirty = true;
      }
    }

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

    public string PayFieldMoney
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public string PayAutoMoney
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public DateTime AutoPayTime
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int AutoValidDate
    {
      get => this.ScveIljHuL;
      set
      {
        this.ScveIljHuL = value;
        this._isDirty = true;
      }
    }

    public int VipLimitLevel
    {
      get => this.ewfeFgCrnp;
      set
      {
        this.ewfeFgCrnp = value;
        this._isDirty = true;
      }
    }

    public string FarmerName
    {
      get => this.string_2;
      set
      {
        this.string_2 = value;
        this._isDirty = true;
      }
    }

    public int GainFieldId
    {
      get => this.zBjehlucUh;
      set
      {
        this.zBjehlucUh = value;
        this._isDirty = true;
      }
    }

    public int MatureId
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int KillCropId
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int isAutoId
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public bool isFarmHelper
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int buyExpRemainNum
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public bool isArrange
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public int TreeLevel
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int TreeExp
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int LoveScore
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int MonsterExp
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int PoultryState
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public DateTime CountDownTime
    {
      get => this.dateTime_1;
      set
      {
        this.dateTime_1 = value;
        this._isDirty = true;
      }
    }

    public int TreeCostExp
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public bool isFeed()
    {
      return (3600000 - (int) (DateTime.Now - this.dateTime_1).TotalMilliseconds) / 60 / 60 / 1000 <= 0;
    }
  }
}
