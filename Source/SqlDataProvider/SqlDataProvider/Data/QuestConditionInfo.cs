// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.QuestConditionInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class QuestConditionInfo
  {
    public int QuestID { get; set; }

    public int CondictionID { get; set; }

    public string CondictionTitle { get; set; }

    public int CondictionType { get; set; }

    public int Para1 { get; set; }

    public int Para2 { get; set; }

    public bool isOpitional { get; set; }
  }
}
