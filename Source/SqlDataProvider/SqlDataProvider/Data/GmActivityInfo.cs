// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.GmActivityInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class GmActivityInfo
  {
    public string activityId { get; set; }

    public string activityName { get; set; }

    public string activityType { get; set; }

    public int activityChildType { get; set; }

    public int getWay { get; set; }

    public string desc { get; set; }

    public string rewardDesc { get; set; }

    public DateTime beginTime { get; set; }

    public DateTime beginShowTime { get; set; }

    public DateTime endTime { get; set; }

    public DateTime endShowTime { get; set; }

    public int icon { get; set; }

    public int isContinue { get; set; }

    public int status { get; set; }

    public int remain1 { get; set; }

    public int remain2 { get; set; }
  }
}
