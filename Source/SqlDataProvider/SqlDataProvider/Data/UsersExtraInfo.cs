// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UsersExtraInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UsersExtraInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;
    private int int_7;
    private bool bool_0;
    private string string_0;
    private int int_8;
    private int gIwaIsMhjt;
    private int int_9;
    private bool bool_1;
    private string string_1;
    private int int_10;
    private int int_11;
    private int int_12;
    private int int_13;
    private int int_14;
    private int int_15;
    private int int_16;
    private string string_2;
    private string string_3;
    private DateTime yisaEcmjFm;
    private int int_17;
    private string string_4;
    private DateTime dateTime_0;
    private int int_18;
    private int int_19;
    private string string_5;

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

    public int starlevel
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int nowPosition
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int FreeCount
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int Score
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int SummerScore
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int PrizeStatus
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public bool CakeStatus
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public string CatchInsectGetPrize
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public int ScoreMagicstone
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int NormalFightNum
    {
      get => this.gIwaIsMhjt;
      set
      {
        this.gIwaIsMhjt = value;
        this._isDirty = true;
      }
    }

    public int HardFightNum
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public bool IsDoubleScore
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public string MagpieBridgeItems
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public int NowPositionMB
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int LastNum
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int MagpieNum
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public int FreeSendMailCount
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public int FreeAddAutionCount
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public int MissionEnergy
    {
      get => this.int_15;
      set
      {
        this.int_15 = value;
        this._isDirty = true;
      }
    }

    public int buyEnergyCount
    {
      get => this.int_16;
      set
      {
        this.int_16 = value;
        this._isDirty = true;
      }
    }

    public string SearchGoodItems
    {
      get => this.string_2;
      set
      {
        this.string_2 = value;
        this._isDirty = true;
      }
    }

    public string KingBlessInfo
    {
      get => this.string_3;
      set
      {
        this.string_3 = value;
        this._isDirty = true;
      }
    }

    public DateTime KingBlessEnddate
    {
      get => this.yisaEcmjFm;
      set
      {
        this.yisaEcmjFm = value;
        this._isDirty = true;
      }
    }

    public int KingBlessIndex
    {
      get => this.int_17;
      set
      {
        this.int_17 = value;
        this._isDirty = true;
      }
    }

    public string DeedInfo
    {
      get => this.string_4;
      set
      {
        this.string_4 = value;
        this._isDirty = true;
      }
    }

    public DateTime DeedEnddate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int DeedIndex
    {
      get => this.int_18;
      set
      {
        this.int_18 = value;
        this._isDirty = true;
      }
    }

    public int CurentDressModel
    {
      get => this.int_19;
      set
      {
        this.int_19 = value;
        this._isDirty = true;
      }
    }

    public string DressModelArr
    {
      get => this.string_5;
      set
      {
        this.string_5 = value;
        this._isDirty = true;
      }
    }

    public bool KingBlessRenevalDays(int value, int index)
    {
      if (index < this.int_17)
        return false;
      if (this.yisaEcmjFm < DateTime.Now)
        this.yisaEcmjFm = DateTime.Now;
      this.yisaEcmjFm = this.yisaEcmjFm.AddDays((double) value);
      this.int_17 = index;
      return true;
    }

    public bool DeedRenevalDays(int value, int index)
    {
      if (this.dateTime_0 < DateTime.Now)
        this.dateTime_0 = DateTime.Now;
      this.dateTime_0 = this.dateTime_0.AddDays((double) value);
      this.int_18 = index;
      return true;
    }
  }
}
