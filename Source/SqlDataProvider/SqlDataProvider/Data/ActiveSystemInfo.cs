using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ActiveSystemInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private string string_0;
    private int int_3;
    private string string_1;
    private int int_4;
    private int int_5;
    private int VcsoHniUvc;
    private int int_6;
    private bool bool_0;
    private int int_7;
    private int int_8;
    private int int_9;
    private DateTime dateTime_0;
    private bool bool_1;
    private int int_10;
    private int int_11;
    private int int_12;
    private int int_13;
    private int int_14;
    private int int_15;
    private int int_16;
    private DateTime dateTime_1;
    private string string_2;
    private string string_3;
    private int int_17;
    private DateTime dateTime_2;
    private int int_18;
    private int int_19;
    private int int_20;
    private int int_21;
    private int int_22;
    private DateTime dateTime_3;
    private int int_23;
    private string string_4;

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

    public int myRank
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public string NickName
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public int ZoneID
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public string ZoneName
    {
      get => this.string_1;
      set
      {
        this.string_1 = value;
        this._isDirty = true;
      }
    }

    public int totalScore
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int useableScore
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int EntertamentPoint
    {
      get => this.VcsoHniUvc;
      set
      {
        this.VcsoHniUvc = value;
        this._isDirty = true;
      }
    }

    public int dayScore
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public bool CanGetGift
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int AvailTime
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int canOpenCounts
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int canEagleEyeCounts
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public DateTime lastFlushTime
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public bool isShowAll
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public int isBuy
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public int ActiveMoney
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int activityTanabataNum
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public int ChallengeNum
    {
      get => this.int_13;
      set
      {
        this.int_13 = value;
        this._isDirty = true;
      }
    }

    public int BuyBuffNum
    {
      get => this.int_14;
      set
      {
        this.int_14 = value;
        this._isDirty = true;
      }
    }

    public int DamageNum
    {
      get => this.int_15;
      set
      {
        this.int_15 = value;
        this._isDirty = true;
      }
    }

    public int LuckystarCoins
    {
      get => this.int_16;
      set
      {
        this.int_16 = value;
        this._isDirty = true;
      }
    }

    public DateTime lastEnterYearMonter
    {
      get => this.dateTime_1;
      set
      {
        this.dateTime_1 = value;
        this._isDirty = true;
      }
    }

    public string BoxState
    {
      get => this.string_2;
      set
      {
        this.string_2 = value;
        this._isDirty = true;
      }
    }

    public string CryptBoss
    {
      get => this.string_3;
      set
      {
        this.string_3 = value;
        this._isDirty = true;
      }
    }

    public int Int32_0
    {
      get => this.int_17;
      set
      {
        this.int_17 = value;
        this._isDirty = true;
      }
    }

    public DateTime lastEnterWorshiped
    {
      get => this.dateTime_2;
      set
      {
        this.dateTime_2 = value;
        this._isDirty = true;
      }
    }

    public int updateFreeCounts
    {
      get => this.int_18;
      set
      {
        this.int_18 = value;
        this._isDirty = true;
      }
    }

    public int updateWorshipedCounts
    {
      get => this.int_19;
      set
      {
        this.int_19 = value;
        this._isDirty = true;
      }
    }

    public int update200State
    {
      get => this.int_20;
      set
      {
        this.int_20 = value;
        this._isDirty = true;
      }
    }

    public int luckCount
    {
      get => this.int_21;
      set
      {
        this.int_21 = value;
        this._isDirty = true;
      }
    }

    public int remainTimes
    {
      get => this.int_22;
      set
      {
        this.int_22 = value;
        this._isDirty = true;
      }
    }

    public DateTime LastRefresh
    {
      get => this.dateTime_3;
      set
      {
        this.dateTime_3 = value;
        this._isDirty = true;
      }
    }

    public int CurRefreshedTimes
    {
      get => this.int_23;
      set
      {
        this.int_23 = value;
        this._isDirty = true;
      }
    }

    public string ChickActiveData
    {
      get => this.string_4;
      set
      {
        this.string_4 = value;
        this._isDirty = true;
      }
    }
  }
}
