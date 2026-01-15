// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaApplyAllyInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaApplyAllyInfo
  {
    public int ID { get; set; }

    public int Consortia1ID { get; set; }

    public int Consortia2ID { get; set; }

    public DateTime Date { get; set; }

    public string Remark { get; set; }

    public bool IsExist { get; set; }

    public int State { get; set; }

    public string ConsortiaName { get; set; }

    public int Repute { get; set; }

    public string ChairmanName { get; set; }

    public int Count { get; set; }

    public int CelebCount { get; set; }

    public int Honor { get; set; }

    public int Level { get; set; }

    public string Description { get; set; }
  }
}
