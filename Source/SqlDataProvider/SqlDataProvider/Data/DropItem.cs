// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.DropItem
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class DropItem
  {
    public int Id { get; set; }

    public int DropId { get; set; }

    public int ItemId { get; set; }

    public int ValueDate { get; set; }

    public bool IsBind { get; set; }

    public int Random { get; set; }

    public int BeginData { get; set; }

    public int EndData { get; set; }

    public bool IsTips { get; set; }

    public bool IsLogs { get; set; }
  }
}
