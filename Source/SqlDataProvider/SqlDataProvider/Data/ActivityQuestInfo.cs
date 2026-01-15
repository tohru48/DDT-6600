// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ActivityQuestInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ActivityQuestInfo
  {
    public int ID { get; set; }

    public int QuestType { get; set; }

    public string Title { get; set; }

    public string Detail { get; set; }

    public string Objective { get; set; }

    public int NeedMinLevel { get; set; }

    public int NeedMaxLevel { get; set; }

    public int Period { get; set; }
  }
}
