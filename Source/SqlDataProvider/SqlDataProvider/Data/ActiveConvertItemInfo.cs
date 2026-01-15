// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ActiveConvertItemInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ActiveConvertItemInfo
  {
    public int ActiveID { get; set; }

    public int TemplateID { get; set; }

    public int ItemType { get; set; }

    public int ItemCount { get; set; }

    public int LimitValue { get; set; }

    public bool IsBind { get; set; }

    public int ValidDate { get; set; }
  }
}
