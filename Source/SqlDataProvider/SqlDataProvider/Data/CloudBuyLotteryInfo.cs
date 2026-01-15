// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.CloudBuyLotteryInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class CloudBuyLotteryInfo
  {
    public int ID { get; set; }

    public int GroupId { get; set; }

    public int templateId { get; set; }

    public int templatedIdCount { get; set; }

    public int validDate { get; set; }

    public string property { get; set; }

    public string buyItemsArr { get; set; }

    public int buyMoney { get; set; }

    public int maxNum { get; set; }

    public int currentNum { get; set; }
  }
}
