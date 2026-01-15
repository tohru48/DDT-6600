// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ShopInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ShopInfo
  {
    public int ID { get; set; }

    public int ShopID { get; set; }

    public int GoodsID { get; set; }

    public int Count { get; set; }

    public int Sort { get; set; }

    public int IsVouch { get; set; }

    public int IsHot { get; set; }

    public int IsNew { get; set; }

    public int IsLtime { get; set; }

    public int IsSpecial { get; set; }
  }
}
