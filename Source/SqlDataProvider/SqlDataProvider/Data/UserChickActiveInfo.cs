// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UserChickActiveInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class UserChickActiveInfo
  {
    public int IsKeyOpened { get; set; }

    public int KeyOpenedType { get; set; }

    public DateTime KeyOpenedTime { get; set; }

    public DateTime EveryDay { get; set; }

    public DateTime Weekly { get; set; }

    public DateTime AfterThreeDays { get; set; }

    public int CurrentLvAward { get; set; }

    public DateTime StartOfWeek(DateTime dt, DayOfWeek startOfWeek)
    {
      int num = dt.DayOfWeek - startOfWeek;
      if (num < 0)
        num += 7;
      return dt.AddDays((double) (-1 * num)).Date;
    }

    public void Active(int type)
    {
      this.IsKeyOpened = 1;
      this.KeyOpenedType = type;
      this.KeyOpenedTime = DateTime.Now;
      this.EveryDay = DateTime.Now.AddDays(-1.0);
      this.AfterThreeDays = DateTime.Now.AddDays(-1.0);
      this.Weekly = this.StartOfWeek(DateTime.Now, DayOfWeek.Saturday).AddDays(-7.0);
    }

    public bool OnThreeDay(DateTime dt)
    {
      return dt.DayOfWeek == DayOfWeek.Friday || dt.DayOfWeek == DayOfWeek.Saturday || dt.DayOfWeek == DayOfWeek.Sunday;
    }
  }
}
