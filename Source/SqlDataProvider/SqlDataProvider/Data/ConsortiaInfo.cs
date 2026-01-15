// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaInfo : DataObject
  {
    public long TotalAllMemberDame;
    public long MaxBlood;
    private Dictionary<string, RankingPersonInfo> dictionary_0;
    private int int_0;
    private int int_1;
    private int int_2;
    private string string_0;
    private int int_3;
    private int int_4;
    private string string_1;
    private int int_5;
    private int int_6;
    private byte byte_0;
    private int int_7;
    private string string_2;
    private string string_3;
    private string string_4;
    private int int_8;
    private int int_9;
    private int int_10;
    private DateTime dateTime_0;
    private int int_11;
    private int int_12;
    private string string_5;
    private int int_13;
    private bool bool_0;
    private int int_14;
    private DateTime dateTime_1;

    public int ZoneID { get; set; }

    public string ZoneName { get; set; }

    public string BadgeBuyTime { get; set; }

    public int ValidDate { get; set; }

    public bool IsVoting { get; set; }

    public int VoteRemainDay { get; set; }

    public int BadgeType { get; set; }

    public string BadgeName { get; set; }

    public int bossState { get; set; }

    public int callBossLevel { get; set; }

    public DateTime endTime { get; set; }

    public DateTime LastOpenBoss { get; set; }

    public bool IsSendAward { get; set; }

    public bool IsBossDie { get; set; }

    public bool SendToClient { get; set; }

    public Dictionary<string, RankingPersonInfo> RankList
    {
      get => this.dictionary_0;
      set => this.dictionary_0 = value;
    }

    public int extendAvailableNum
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int BadgeID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int ConsortiaID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public string ConsortiaName
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public int Honor
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int CreatorID
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public string CreatorName
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public int FightPower
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int ChairmanVIPLevel
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public byte ChairmanTypeVIP
    {
      get => this.byte_0;
      set
      {
        this.byte_0 = value;
        this._isDirty = true;
      }
    }

    public int ChairmanID
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public string ChairmanName
    {
      get => this.string_2;
      set
      {
        this.string_2 = value;
        this._isDirty = true;
      }
    }

    public string Description
    {
      get => this.string_3;
      set
      {
        this.string_3 = value;
        this._isDirty = true;
      }
    }

    public string Placard
    {
      get => this.string_4;
      set
      {
        this.string_4 = value;
        this._isDirty = true;
      }
    }

    public int Level
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int MaxCount
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int CelebCount
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public DateTime BuildDate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int Repute
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int Count
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public string IP
    {
      get => this.string_5;
      set
      {
        this.string_5 = value;
        this._isDirty = true;
      }
    }

    public int Port
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public bool IsExist
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int Riches
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public DateTime DeductDate
    {
      get => this.dateTime_1;
      set
      {
        this.dateTime_1 = value;
        this._isDirty = true;
      }
    }

    public int AddDayRiches { get; set; }

    public int AddWeekRiches { get; set; }

    public int AddDayHonor { get; set; }

    public int AddWeekHonor { get; set; }

    public int LastDayRiches { get; set; }

    public bool OpenApply { get; set; }

    public int ShopLevel { get; set; }

    public int SmithLevel { get; set; }

    public int StoreLevel { get; set; }

    public int SkillLevel { get; set; }

    public int ConsortiaGiftGp { get; set; }

    public int ConsortiaAddDayGiftGp { get; set; }

    public int ConsortiaAddWeekGiftGp { get; set; }

    public int CharmGP { get; set; }
  }
}
