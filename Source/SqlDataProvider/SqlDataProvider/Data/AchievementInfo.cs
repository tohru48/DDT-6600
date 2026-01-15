// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.AchievementInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class AchievementInfo : DataObject
  {
    public int ID { get; set; }

    public int AchievementPoint { get; set; }

    public int AchievementType { get; set; }

    public bool CanHide { get; set; }

    public string Detail { get; set; }

    public DateTime EndDate { get; set; }

    public int IsActive { get; set; }

    public int IsOther { get; set; }

    public bool IsShare { get; set; }

    public int NeedMaxLevel { get; set; }

    public int NeedMinLevel { get; set; }

    public int PicID { get; set; }

    public int PlaceID { get; set; }

    public string PreAchievementID { get; set; }

    public DateTime StartDate { get; set; }

    public string Title { get; set; }
  }
}
