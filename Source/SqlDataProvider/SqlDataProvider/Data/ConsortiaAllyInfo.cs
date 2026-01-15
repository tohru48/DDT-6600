// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaAllyInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaAllyInfo
  {
    public int ID { get; set; }

    public int Consortia1ID { get; set; }

    public int Consortia2ID { get; set; }

    public int State { get; set; }

    public DateTime Date { get; set; }

    public int ValidDate { get; set; }

    public bool IsExist { get; set; }

    public string ConsortiaName1 { get; set; }

    public int Count1 { get; set; }

    public int Repute1 { get; set; }

    public string ConsortiaName2 { get; set; }

    public int Count2 { get; set; }

    public int Repute2 { get; set; }

    public string ChairmanName1 { get; set; }

    public string ChairmanName2 { get; set; }

    public int Level1 { get; set; }

    public int Level2 { get; set; }

    public int Honor1 { get; set; }

    public int Honor2 { get; set; }

    public string Description1 { get; set; }

    public string Description2 { get; set; }

    public int Riches1 { get; set; }

    public int Riches2 { get; set; }

    public bool IsApply { get; set; }
  }
}
