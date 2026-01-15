// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PlayerInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class PlayerInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private DateTime dateTime_0;
    private int int_2;
    private string string_0;
    private int int_3;
    private DateTime dateTime_1;
    private int int_4;
    private string string_1;
    private int int_5;
    private string string_2;
    private bool bool_0;
    private int int_6;
    private int int_7;
    private int int_8;
    private DateTime? nullable_0;
    private int int_9;
    private int int_10;
    private int int_11;
    private int int_12;
    private int int_13;
    private int int_14;
    private int int_15;
    private int int_16;
    private PlayerInfoHistory playerInfoHistory_0;
    private TexpInfo aGyvLqrGce;
    private int int_17;
    private int int_18;
    private int int_19;
    private bool peVvJsbmn3;
    private bool bool_1;
    private int int_20;
    private bool bool_2;
    private bool bool_3;
    private bool bool_4;
    private byte byte_0;
    private bool bool_5;
    private DateTime dateTime_2;
    private DateTime dateTime_3;
    private DateTime dateTime_4;
    private DateTime dateTime_5;
    private int int_21;
    private int int_22;
    private int int_23;
    private int int_24;
    private string string_3;
    private int int_25;
    private int int_26;
    private string string_4;
    private byte[] byte_1;
    private bool bool_6;
    private int int_27;
    private int int_28;
    private int int_29;
    private int int_30;
    private bool bool_7;
    private string string_5;
    private int int_31;
    private string string_6;
    private int int_32;
    private string string_7;
    private Dictionary<string, object> dictionary_0;
    private int int_33;
    private string string_8;
    private int int_34;
    private DateTime dateTime_6;
    private int int_35;
    private int int_36;
    private int int_37;
    private int int_38;
    private int int_39;
    private int int_40;
    private DateTime dateTime_7;
    private int int_41;
    private int int_42;
    private int int_43;
    private int int_44;
    private DateTime dateTime_8;
    private DateTime dateTime_9;
    private int int_45;
    private int int_46;
    private int int_47;
    private string string_9;
    private int int_48;
    private string string_10;
    private int int_49;
    private bool bool_8;
    private bool bool_9;
    private bool bool_10;
    private DateTime dateTime_10;
    private DateTime dateTime_11;
    private DateTime dateTime_12;
    private int int_50;
    private string string_11;
    private string string_12;
    private string string_13;
    private int int_51;
    private int int_52;
    private int int_53;
    private string string_14;
    private int int_54;
    private bool bool_11;
    private string string_15;
    private byte[] byte_2;
    private int int_55;
    private int int_56;
    private int int_57;
    private int int_58;
    private int int_59;
    private bool bool_12;
    private int int_60;
    private int int_61;
    private int int_62;
    private int int_63;
    private bool bool_13;
    private int int_64;
    private int int_65;
    private int int_66;
    private DateTime dateTime_13;
    private int int_67;
    private int int_68;
    private int int_69;
    private int int_70;
    private int int_71;
    private string string_16;
    private int int_72;
    private bool bool_14;
    private DateTime dateTime_14;
    private bool bool_15;
    private int int_73;
    private DateTime dateTime_15;
    private int int_74;
    private int int_75;
    private int int_76;
    private DateTime dateTime_16;
    private int int_77;
    private int int_78;
    private int int_79;
    private int JgxcsdtXu9;
    private int int_80;
    private int int_81;
    private int int_82;
    private int int_83;
    private int int_84;
    private string string_17;
    private int int_85;
    private string string_18;
    private int int_86;
    public bool IsAutoBot;
    public int DameAddPlus;
    public int GuardAddPlus;
    public int AttackAddPlus;
    public int AgiAddPlus;
    public int DefendAddPlus;
    public int LuckAddPlus;
    public int HpAddPlus;
    public int ReduceDamePlus;
    public int StrengthEnchance;

    public TexpInfo Texp
    {
      get => this.aGyvLqrGce;
      set
      {
        this.aGyvLqrGce = value;
        this._isDirty = true;
      }
    }

    public int MaxBuyHonor
    {
      get => this.int_53;
      set
      {
        this.int_53 = value;
        this._isDirty = true;
      }
    }

    public string Password
    {
      get => this.string_14;
      set
      {
        this.string_14 = value;
        this._isDirty = true;
      }
    }

    public int medal
    {
      get => this.int_54;
      set
      {
        this.int_54 = value;
        this._isDirty = true;
      }
    }

    public int hp
    {
      get => this.int_18;
      set
      {
        this.int_18 = value;
        this._isDirty = true;
      }
    }

    public bool IsOldPlayer
    {
      get => this.bool_11;
      set
      {
        this.bool_11 = value;
        this._isDirty = true;
      }
    }

    public string WeaklessGuildProgressStr
    {
      get => this.string_15;
      set
      {
        this.string_15 = value;
        this._isDirty = true;
      }
    }

    public int AchievementPoint
    {
      get => this.int_39;
      set => this.int_39 = value;
    }

    public int AddDayAchievementPoint
    {
      get => this.int_40;
      set => this.int_40 = value;
    }

    public int AddDayGiftGp { get; set; }

    public int AddDayGP { get; set; }

    public int AddDayOffer { get; set; }

    public DateTime AddGPLastDate
    {
      get => this.dateTime_7;
      set => this.dateTime_7 = value;
    }

    public int AddWeekAchievementPoint
    {
      get => this.int_41;
      set => this.int_41 = value;
    }

    public int AddWeekGiftGp { get; set; }

    public int AddWeekGP { get; set; }

    public int AddWeekOffer { get; set; }

    public int ApprenticeshipState { get; set; }

    public int AddWeekLeagueScore { get; set; }

    public int TotalPrestige { get; set; }

    public int MountExp { get; set; }

    public int MountLv { get; set; }

    public int Agility
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int AlreadyGetBox
    {
      get => this.int_42;
      set => this.int_42 = value;
    }

    public int AnswerSite
    {
      get => this.int_43;
      set => this.int_43 = value;
    }

    public int AntiAddiction
    {
      get => this.int_1 + (int) (DateTime.Now - this.dateTime_0).TotalMinutes;
      set
      {
        this.int_1 = value;
        this.dateTime_0 = DateTime.Now;
      }
    }

    public DateTime AntiDate
    {
      get => this.dateTime_0;
      set => this.dateTime_0 = value;
    }

    public int Attack
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int BanChat
    {
      get => this.int_44;
      set => this.int_44 = value;
    }

    public DateTime BanChatEndDate
    {
      get => this.dateTime_8;
      set => this.dateTime_8 = value;
    }

    public DateTime BoxGetDate
    {
      get => this.dateTime_9;
      set => this.dateTime_9 = value;
    }

    public int BoxProgression
    {
      get => this.int_45;
      set => this.int_45 = value;
    }

    public string ChairmanName { get; set; }

    public int ChatCount
    {
      get => this.int_46;
      set => this.int_46 = value;
    }

    public string CheckCode
    {
      get => this.string_0;
      set
      {
        this.dateTime_1 = DateTime.Now;
        this.string_0 = value;
        string.IsNullOrEmpty(this.string_0);
      }
    }

    public int CheckCount
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public DateTime CheckDate => this.dateTime_1;

    public int CheckError
    {
      get => this.int_4;
      set => this.int_4 = value;
    }

    public string Colors
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public int ConsortiaGiftGp { get; set; }

    public int ConsortiaHonor { get; set; }

    public int ConsortiaID
    {
      get => this.int_5;
      set
      {
        if (this.int_5 == 0 || value == 0)
        {
          this.int_29 = 0;
          this.int_28 = 0;
        }
        this.int_5 = value;
      }
    }

    public int ConsortiaLevel { get; set; }

    public string ConsortiaName
    {
      get => this.string_2;
      set => this.string_2 = value;
    }

    public int _badgeID { get; set; }

    public int badgeID
    {
      get => this._badgeID;
      set
      {
        this._badgeID = value;
        this._isDirty = true;
      }
    }

    public bool ConsortiaRename
    {
      get => this.bool_0;
      set
      {
        if (this.bool_0 == value)
          return;
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int ConsortiaRepute { get; set; }

    public int ConsortiaRiches { get; set; }

    public int DayLoginCount
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int Defence
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int DutyLevel { get; set; }

    public string DutyName { get; set; }

    public int Escape
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public DateTime? ExpendDate
    {
      get => this.nullable_0;
      set
      {
        this.nullable_0 = value;
        this._isDirty = true;
      }
    }

    public int FailedPasswordAttemptCount
    {
      get => this.int_47;
      set => this.int_47 = value;
    }

    public string FightLabPermission
    {
      get => this.string_9;
      set => this.string_9 = value;
    }

    public int FightPower
    {
      get => this.int_9;
      set
      {
        if (this.int_9 == value)
          return;
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int GameActiveHide
    {
      get => this.int_48;
      set => this.int_48 = value;
    }

    public string GameActiveStyle
    {
      get => this.string_10;
      set => this.string_10 = value;
    }

    public int GetBoxLevel
    {
      get => this.int_49;
      set => this.int_49 = value;
    }

    public int GiftGp
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int GiftLevel
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int DDTMoney
    {
      get => this.int_12;
      set => this.int_12 = value;
    }

    public int Gold
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public int GP
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public int Grade
    {
      get => this.int_15;
      set
      {
        this.int_15 = value;
        this._isDirty = true;
      }
    }

    public bool HasBagPassword => !string.IsNullOrEmpty(this.string_4);

    public int Hide
    {
      get => this.int_16;
      set
      {
        this.int_16 = value;
        this._isDirty = true;
      }
    }

    public PlayerInfoHistory History
    {
      get => this.playerInfoHistory_0;
      set => this.playerInfoHistory_0 = value;
    }

    public byte[] weaklessGuildProgress
    {
      get => this.byte_2;
      set
      {
        this.byte_2 = value;
        this._isDirty = true;
      }
    }

    public int ID
    {
      get => this.int_17;
      set
      {
        this.int_17 = value;
        this._isDirty = true;
      }
    }

    public int Inviter
    {
      get => this.int_19;
      set => this.int_19 = value;
    }

    public bool IsBanChat { get; set; }

    public bool IsConsortia
    {
      get => this.peVvJsbmn3;
      set => this.peVvJsbmn3 = value;
    }

    public bool IsCreatedMarryRoom
    {
      get => this.bool_1;
      set
      {
        if (this.bool_1 == value)
          return;
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public int IsFirst
    {
      get => this.int_20;
      set => this.int_20 = value;
    }

    public bool IsGotRing
    {
      get => this.bool_2;
      set
      {
        if (this.bool_2 == value)
          return;
        this.bool_2 = value;
        this._isDirty = true;
      }
    }

    public bool IsInSpaPubGoldToday
    {
      get => this.bool_8;
      set => this.bool_8 = value;
    }

    public bool IsInSpaPubMoneyToday
    {
      get => this.bool_9;
      set => this.bool_9 = value;
    }

    public bool IsLocked
    {
      get => this.bool_3;
      set => this.bool_3 = value;
    }

    public bool IsMarried
    {
      get => this.bool_4;
      set
      {
        this.bool_4 = value;
        this._isDirty = true;
      }
    }

    public bool IsOpenGift
    {
      get => this.bool_10;
      set => this.bool_10 = value;
    }

    public byte typeVIP
    {
      get => this.byte_0;
      set
      {
        if ((int) this.byte_0 == (int) value)
          return;
        this.byte_0 = value;
        this._isDirty = true;
      }
    }

    public bool CanTakeVipReward
    {
      get => this.bool_5;
      set
      {
        this.bool_5 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastAuncherAward
    {
      get => this.dateTime_2;
      set => this.dateTime_2 = value;
    }

    public DateTime LastAward
    {
      get => this.dateTime_3;
      set => this.dateTime_3 = value;
    }

    public DateTime LastDate
    {
      get => this.dateTime_10;
      set => this.dateTime_10 = value;
    }

    public DateTime DateTime_0
    {
      get => this.dateTime_11;
      set => this.dateTime_11 = value;
    }

    public DateTime LastSpaDate
    {
      get => this.dateTime_12;
      set => this.dateTime_12 = value;
    }

    public DateTime LastVIPPackTime
    {
      get => this.dateTime_4;
      set
      {
        this.dateTime_4 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastWeekly
    {
      get => this.dateTime_5;
      set => this.dateTime_5 = value;
    }

    public int LastWeeklyVersion
    {
      get => this.int_21;
      set => this.int_21 = value;
    }

    public int Luck
    {
      get => this.int_22;
      set
      {
        this.int_22 = value;
        this._isDirty = true;
      }
    }

    public int MagicAttack
    {
      get => this.int_55;
      set
      {
        this.int_55 = value;
        this._isDirty = true;
      }
    }

    public int MagicDefence
    {
      get => this.int_56;
      set
      {
        this.int_56 = value;
        this._isDirty = true;
      }
    }

    public int evolutionGrade
    {
      get => this.int_57;
      set
      {
        this.int_57 = value;
        this._isDirty = true;
      }
    }

    public int evolutionExp
    {
      get => this.int_58;
      set
      {
        this.int_58 = value;
        this._isDirty = true;
      }
    }

    public int MarryInfoID
    {
      get => this.int_23;
      set
      {
        if (this.int_23 == value)
          return;
        this.int_23 = value;
        this._isDirty = true;
      }
    }

    public int Money
    {
      get => this.int_24;
      set
      {
        this.int_24 = value;
        this._isDirty = true;
      }
    }

    public string NickName
    {
      get => this.string_3;
      set
      {
        this.string_3 = value;
        this._isDirty = true;
      }
    }

    public int Nimbus
    {
      get => this.int_25;
      set
      {
        if (this.int_25 == value)
          return;
        this.int_25 = value;
        this._isDirty = true;
      }
    }

    public int Offer
    {
      get => this.int_26;
      set
      {
        this.int_26 = value;
        this._isDirty = true;
      }
    }

    public int OnlineTime
    {
      get => this.int_50;
      set => this.int_50 = value;
    }

    public string PasswordQuest1
    {
      get => this.string_11;
      set => this.string_11 = value;
    }

    public string PasswordQuest2
    {
      get => this.string_12;
      set => this.string_12 = value;
    }

    public string PasswordTwo
    {
      get => this.string_4;
      set
      {
        this.string_4 = value;
        this._isDirty = true;
      }
    }

    public string PvePermission
    {
      get => this.string_13;
      set => this.string_13 = value;
    }

    public byte[] QuestSite
    {
      get => this.byte_1;
      set => this.byte_1 = value;
    }

    public bool Rename
    {
      get => this.bool_6;
      set
      {
        if (this.bool_6 == value)
          return;
        this.bool_6 = value;
        this._isDirty = true;
      }
    }

    public int Repute
    {
      get => this.int_27;
      set
      {
        this.int_27 = value;
        this._isDirty = true;
      }
    }

    public int ReputeOffer { get; set; }

    public int Riches => this.RichesRob + this.RichesOffer;

    public int LeagueMoney
    {
      get => this.int_59;
      set
      {
        this.int_59 = value;
        this._isDirty = true;
      }
    }

    public int RichesOffer
    {
      get => this.int_28;
      set
      {
        this.int_28 = value;
        this._isDirty = true;
      }
    }

    public int RichesRob
    {
      get => this.int_29;
      set
      {
        this.int_29 = value;
        this._isDirty = true;
      }
    }

    public int Right { get; set; }

    public int SelfMarryRoomID
    {
      get => this.int_30;
      set
      {
        if (this.int_30 == value)
          return;
        this.int_30 = value;
        this._isDirty = true;
      }
    }

    public bool isOpenKingBless
    {
      get => this.bool_12;
      set
      {
        this.bool_12 = value;
        this._isDirty = true;
      }
    }

    public bool Sex
    {
      get => this.bool_7;
      set
      {
        this.bool_7 = value;
        this._isDirty = true;
      }
    }

    public int ShopLevel { get; set; }

    public string Skin
    {
      get => this.string_5;
      set
      {
        this.string_5 = value;
        this._isDirty = true;
      }
    }

    public int SmithLevel { get; set; }

    public int SpaPubGoldRoomLimit
    {
      get => this.int_51;
      set => this.int_51 = value;
    }

    public int SpaPubMoneyRoomLimit
    {
      get => this.int_52;
      set => this.int_52 = value;
    }

    public int SpouseID
    {
      get => this.int_31;
      set
      {
        if (this.int_31 == value)
          return;
        this.int_31 = value;
        this._isDirty = true;
      }
    }

    public string SpouseName
    {
      get => this.string_6;
      set
      {
        if (!(this.string_6 != value))
          return;
        this.string_6 = value;
        this._isDirty = true;
      }
    }

    public int State
    {
      get => this.int_32;
      set
      {
        this.int_32 = value;
        this._isDirty = true;
      }
    }

    public int StoreLevel { get; set; }

    public int SkillLevel { get; set; }

    public string Style
    {
      get => this.string_7;
      set
      {
        this.string_7 = value;
        this._isDirty = true;
      }
    }

    public Dictionary<string, object> TempInfo => this.dictionary_0;

    public int Total
    {
      get => this.int_33;
      set
      {
        this.int_33 = value;
        this._isDirty = true;
      }
    }

    public string UserName
    {
      get => this.string_8;
      set
      {
        this.string_8 = value;
        this._isDirty = true;
      }
    }

    public int VIPExp
    {
      get => this.int_34;
      set
      {
        if (this.int_34 == value)
          return;
        this.int_34 = value;
        this._isDirty = true;
      }
    }

    public DateTime VIPExpireDay
    {
      get => this.dateTime_6;
      set
      {
        this.dateTime_6 = value;
        this._isDirty = true;
      }
    }

    public int VIPLevel
    {
      get => this.int_35;
      set
      {
        if (this.int_35 == value)
          return;
        this.int_35 = value;
        this._isDirty = true;
      }
    }

    public int VIPNextLevelDaysNeeded
    {
      get => this.int_60;
      set
      {
        this.int_60 = value;
        this._isDirty = true;
      }
    }

    public int VIPOfflineDays
    {
      get => this.int_36;
      set => this.int_36 = value;
    }

    public int VIPOnlineDays
    {
      get => this.int_37;
      set => this.int_37 = value;
    }

    public int CardSoul
    {
      get => this.int_61;
      set => this.int_61 = value;
    }

    public int Score
    {
      get => this.int_62;
      set => this.int_62 = value;
    }

    public int OptionOnOff
    {
      get => this.int_63;
      set => this.int_63 = value;
    }

    public bool isOldPlayerHasValidEquitAtLogin
    {
      get => this.bool_13;
      set => this.bool_13 = value;
    }

    public int badLuckNumber
    {
      get => this.int_64;
      set => this.int_64 = value;
    }

    public int lastLuckNum
    {
      get => this.int_65;
      set => this.int_65 = value;
    }

    public int luckyNum
    {
      get => this.int_66;
      set => this.int_66 = value;
    }

    public DateTime lastLuckyNumDate
    {
      get => this.dateTime_13;
      set => this.dateTime_13 = value;
    }

    public int uesedFinishTime
    {
      get => this.int_67;
      set => this.int_67 = value;
    }

    public int totemId
    {
      get => this.int_68;
      set => this.int_68 = value;
    }

    public int damageScores
    {
      get => this.int_69;
      set => this.int_69 = value;
    }

    public int petScore
    {
      get => this.int_70;
      set => this.int_70 = value;
    }

    public int myHonor
    {
      get => this.int_71;
      set => this.int_71 = value;
    }

    public string Honor
    {
      get => this.string_16;
      set => this.string_16 = value;
    }

    public int hardCurrency
    {
      get => this.int_72;
      set => this.int_72 = value;
    }

    public bool IsShowConsortia
    {
      get => this.bool_14;
      set => this.bool_14 = value;
    }

    public DateTime TimeBox
    {
      get => this.dateTime_14;
      set => this.dateTime_14 = value;
    }

    public bool IsFistGetPet
    {
      get => this.bool_15;
      set => this.bool_15 = value;
    }

    public int Win
    {
      get => this.int_38;
      set
      {
        this.int_38 = value;
        this._isDirty = true;
      }
    }

    public int myScore
    {
      get => this.int_73;
      set
      {
        this.int_73 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastRefreshPet
    {
      get => this.dateTime_15;
      set
      {
        this.dateTime_15 = value;
        this._isDirty = true;
      }
    }

    public int receiebox
    {
      get => this.int_74;
      set
      {
        this.int_74 = value;
        this._isDirty = true;
      }
    }

    public int receieGrade
    {
      get => this.int_75;
      set
      {
        this.int_75 = value;
        this._isDirty = true;
      }
    }

    public int needGetBoxTime
    {
      get => this.int_76;
      set
      {
        this.int_76 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastGetEgg
    {
      get => this.dateTime_16;
      set
      {
        this.dateTime_16 = value;
        this._isDirty = true;
      }
    }

    public int necklaceExp
    {
      get => this.int_77;
      set
      {
        this.int_77 = value;
        this._isDirty = true;
      }
    }

    public int necklaceExpAdd
    {
      get => this.int_78;
      set
      {
        this.int_78 = value;
        this._isDirty = true;
      }
    }

    public int GetSoulCount
    {
      get => this.int_79;
      set
      {
        this.int_79 = value;
        this._isDirty = true;
      }
    }

    public int isFirstDivorce
    {
      get => this.JgxcsdtXu9;
      set
      {
        this.JgxcsdtXu9 = value;
        this._isDirty = true;
      }
    }

    public int accumulativeLoginDays
    {
      get => this.int_80;
      set
      {
        this.int_80 = value;
        this._isDirty = true;
      }
    }

    public int accumulativeAwardDays
    {
      get => this.int_81;
      set
      {
        this.int_81 = value;
        this._isDirty = true;
      }
    }

    public int MountsType
    {
      get => this.int_82;
      set
      {
        this.int_82 = value;
        this._isDirty = true;
      }
    }

    public int PetsID
    {
      get => this.int_83;
      set
      {
        this.int_83 = value;
        this._isDirty = true;
      }
    }

    public int horseRaceCanRaceTime
    {
      get => this.int_84;
      set
      {
        this.int_84 = value;
        this._isDirty = true;
      }
    }

    public string PveEpicPermission
    {
      get => this.string_17;
      set
      {
        this.string_17 = value;
        this._isDirty = true;
      }
    }

    public int ZoneID
    {
      get => this.int_85;
      set => this.int_85 = value;
    }

    public string ZoneName
    {
      get => this.string_18;
      set => this.string_18 = value;
    }

    public int honorId
    {
      get => this.int_86;
      set
      {
        this.int_86 = value;
        this._isDirty = true;
      }
    }

    public bool bit(int param1)
    {
      --param1;
      return ((int) this.byte_2[param1 / 8] & 1 << param1 % 8) != 0;
    }

    public bool IsWeakGuildFinish(int id) => id >= 1 && this.bit(id);

    public void openFunction(Step step)
    {
      int num1 = (int) (step - 1);
      int index = num1 / 8;
      int num2 = num1 % 8;
      byte[] weaklessGuildProgress = this.weaklessGuildProgress;
      if (weaklessGuildProgress.Length <= 0)
        return;
      weaklessGuildProgress[index] = (byte) ((uint) weaklessGuildProgress[index] | (uint) (1 << num2));
      this.weaklessGuildProgress = weaklessGuildProgress;
    }

    public void CheckLevelFunction()
    {
      int grade = this.Grade;
      if (grade > 1)
      {
        this.openFunction(Step.POP_WELCOME);
        this.openFunction(Step.CHANNEL_OPEN);
      }
      if (grade > 2)
      {
        this.openFunction(Step.SHOP_OPEN);
        this.openFunction(Step.STORE_OPEN);
        this.openFunction(Step.ENERGY);
        this.openFunction(Step.MAIL_OPEN);
        this.openFunction(Step.SIGN_OPEN);
      }
      if (grade > 3)
        this.openFunction(Step.HP_PROP_OPEN);
      if (grade > 4)
      {
        this.openFunction(Step.MOVE);
        this.openFunction(Step.CIVIL_OPEN);
        this.openFunction(Step.IM_OPEN);
        this.openFunction(Step.PLAY_ONE_GLOW);
      }
      if (grade > 5)
      {
        this.openFunction(Step.BEAT_ROBOT);
        this.openFunction(Step.MASTER_ROOM_OPEN);
        this.openFunction(Step.POP_ANGLE);
      }
      if (grade > 6)
      {
        this.openFunction(Step.POP_THREE_FOUR_FIVE);
        this.openFunction(Step.CONSORTIA_OPEN);
        this.openFunction(Step.SPAWN_SMALL_BOGU);
        this.openFunction(Step.PLANE_PROP_OPEN);
      }
      if (grade > 7)
      {
        this.openFunction(Step.CONSORTIA_SHOW);
        this.openFunction(Step.DUNGEON_OPEN);
        this.openFunction(Step.POP_WIN_II);
      }
      if (grade > 8)
      {
        this.openFunction(Step.DUNGEON_SHOW);
        this.openFunction(Step.BEAT_LIVING_LEFT);
      }
      if (grade > 9)
        this.openFunction(Step.CHURCH_OPEN);
      if (grade > 11)
      {
        this.openFunction(Step.CHURCH_SHOW);
        this.openFunction(Step.TOFF_LIST_OPEN);
      }
      if (grade > 12)
      {
        this.openFunction(Step.TOFF_LIST_SHOW);
        this.openFunction(Step.HOT_WELL_OPEN);
      }
      if (grade > 13)
      {
        this.openFunction(Step.HOT_WELL_SHOW);
        this.openFunction(Step.AUCTION_OPEN);
      }
      if (grade <= 14)
        return;
      this.openFunction(Step.AUCTION_SHOW);
      this.openFunction(Step.CAMPAIGN_LAB_OPEN);
    }

    public void ClearConsortia()
    {
      this.ConsortiaID = 0;
      this.ConsortiaName = "";
      this.RichesOffer = 0;
      this.ConsortiaRepute = 0;
      this.ConsortiaLevel = 0;
      this.StoreLevel = 0;
      this.ShopLevel = 0;
      this.SmithLevel = 0;
      this.ConsortiaHonor = 0;
      this.RichesOffer = 0;
      this.RichesRob = 0;
      this.DutyLevel = 0;
      this.DutyName = "";
      this.Right = 0;
      this.AddDayGP = 0;
      this.AddWeekGP = 0;
      this.AddDayOffer = 0;
      this.AddWeekOffer = 0;
      this.ConsortiaRiches = 0;
    }

    public bool IsLastVIPPackTime() => this.dateTime_4 < DateTime.Now.Date;

    public bool method_0() => this.dateTime_6.Date < DateTime.Now.Date;

    public bool IsValidadteTimeBox() => this.dateTime_14.Date < DateTime.Now.Date;

    public PlayerInfo()
    {
      this.bool_3 = true;
      this.dictionary_0 = new Dictionary<string, object>();
    }
  }
}
