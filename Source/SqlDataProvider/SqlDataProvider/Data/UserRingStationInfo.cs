// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UserRingStationInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UserRingStationInfo : DataObject
  {
    private PlayerInfo playerInfo_0;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private string string_0;
    private int int_4;
    private int int_5;
    private int int_6;
    private DateTime dateTime_0;
    private DateTime dateTime_1;
    private int int_7;
    private int int_8;
    private int int_9;
    private bool bool_0;

    public PlayerInfo Info
    {
      get => this.playerInfo_0;
      set => this.playerInfo_0 = value;
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

    public int UserID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int Rank
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int WeaponID
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public string signMsg
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public int buyCount
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int Total
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int ChallengeNum
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public DateTime ChallengeTime
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastDate
    {
      get => this.dateTime_1;
      set
      {
        this.dateTime_1 = value;
        this._isDirty = true;
      }
    }

    public int BaseDamage
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int BaseGuard
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int BaseEnergy
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public bool OnFight
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public bool CanChallenge()
    {
      return (600000 - (int) (DateTime.Now - this.dateTime_0).TotalMilliseconds) / 10 / 60 / 1000 <= 0;
    }
  }
}
