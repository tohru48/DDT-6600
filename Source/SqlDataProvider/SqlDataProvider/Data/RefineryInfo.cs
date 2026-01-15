// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.RefineryInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class RefineryInfo
  {
    public List<int> m_Equip;
    public List<int> m_Reward;

    public int RefineryID { get; set; }

    public int Item1 { get; set; }

    public int Int32_0 { get; set; }

    public int Item2 { get; set; }

    public int Int32_1 { get; set; }

    public int Item3 { get; set; }

    public int Int32_2 { get; set; }

    public int Item4 { get; set; }

    public int Int32_3 { get; set; }

    public RefineryInfo()
    {
      this.m_Equip = new List<int>();
      this.m_Reward = new List<int>();
    }
  }
}
