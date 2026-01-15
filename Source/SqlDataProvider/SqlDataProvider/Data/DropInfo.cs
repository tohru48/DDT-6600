// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.DropInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class DropInfo
  {
    public int ID { get; set; }

    public int Time { get; set; }

    public int Count { get; set; }

    public int MaxCount { get; set; }

    public DropInfo(int id, int time, int count, int maxCount)
    {
      this.ID = id;
      this.Time = time;
      this.Count = count;
      this.MaxCount = maxCount;
    }
  }
}
