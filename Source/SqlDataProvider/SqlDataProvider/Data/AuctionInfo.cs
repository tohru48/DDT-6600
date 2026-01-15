// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.AuctionInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class AuctionInfo
  {
    public int AuctionID { get; set; }

    public string Name { get; set; }

    public int Category { get; set; }

    public int AuctioneerID { get; set; }

    public string AuctioneerName { get; set; }

    public int ItemID { get; set; }

    public int PayType { get; set; }

    public int Price { get; set; }

    public int Rise { get; set; }

    public int Mouthful { get; set; }

    public DateTime BeginDate { get; set; }

    public int ValidDate { get; set; }

    public int BuyerID { get; set; }

    public string BuyerName { get; set; }

    public bool IsExist { get; set; }

    public int TemplateID { get; set; }

    public int Random { get; set; }

    public int goodsCount { get; set; }
  }
}
