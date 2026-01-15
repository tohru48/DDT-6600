// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ActiveInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ActiveInfo
  {
    public int ActiveID { get; set; }

    public string Title { get; set; }

    public string Description { get; set; }

    public string Content { get; set; }

    public string AwardContent { get; set; }

    public int HasKey { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public int IsOnly { get; set; }

    public int Type { get; set; }

    public string ActionTimeContent { get; set; }

    public bool IsAdvance { get; set; }

    public string GoodsExchangeTypes { get; set; }

    public string GoodsExchangeNum { get; set; }

    public string limitType { get; set; }

    public string limitValue { get; set; }

    public bool IsShow { get; set; }

    public int IconID { get; set; }

    public int ActiveType { get; set; }
  }
}
