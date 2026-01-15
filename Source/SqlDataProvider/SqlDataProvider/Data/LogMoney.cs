// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.LogMoney
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class LogMoney
  {
    public int ApplicationId { get; set; }

    public int SubId { get; set; }

    public int LineId { get; set; }

    public int MastType { get; set; }

    public int SonType { get; set; }

    public int UserId { get; set; }

    public DateTime EnterTime { get; set; }

    public int Moneys { get; set; }

    public int Gold { get; set; }

    public int GiftToken { get; set; }

    public int Offer { get; set; }

    public string OtherPay { get; set; }

    public string GoodId { get; set; }

    public string GoodsType { get; set; }
  }
}
