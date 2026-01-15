// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.RingstationConfigInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class RingstationConfigInfo
  {
    public int ID { get; set; }

    public int buyCount { get; set; }

    public int buyPrice { get; set; }

    public int cdPrice { get; set; }

    public DateTime AwardTime { get; set; }

    public int AwardNum { get; set; }

    public string AwardFightWin { get; set; }

    public string AwardFightLost { get; set; }

    public string ChampionText { get; set; }

    public int ChallengeNum { get; set; }

    public bool IsFirstUpdateRank { get; set; }

    public bool IsEndTime()
    {
      DateTime dateTime = this.AwardTime;
      DateTime date1 = dateTime.Date;
      dateTime = DateTime.Now;
      DateTime date2 = dateTime.Date;
      return date1 < date2;
    }

    public int AwardNumByRank(int rank)
    {
      if (rank == 0)
        return 0;
      return rank < 30 && rank > 0 ? this.AwardNum - 10 * rank : this.AwardNum - 350;
    }

    public int AwardBattleByRank(int rank, bool isWin)
    {
      if (rank == 0 && isWin)
        return 10;
      if (rank == 0 && !isWin)
        return 5;
      if (string.IsNullOrEmpty(this.AwardFightLost) || string.IsNullOrEmpty(this.AwardFightWin))
        return 0;
      string[] strArray1 = this.AwardFightLost.Split('|');
      if (isWin)
        strArray1 = this.AwardFightWin.Split('|');
      if (strArray1.Length < 3)
        return 0;
      foreach (string str in strArray1)
      {
        char[] chArray = new char[1]{ ',' };
        string[] strArray2 = str.Split(chArray);
        int num1;
        if (strArray2.Length >= 2)
        {
          int num2 = int.Parse(strArray2[0].Split('-')[0]);
          int num3 = int.Parse(strArray2[0].Split('-')[1]);
          if (rank < num2 || rank > num3)
            continue;
          num1 = int.Parse(strArray2[1]);
        }
        else
          num1 = 0;
        return num1;
      }
      return 0;
    }
  }
}
