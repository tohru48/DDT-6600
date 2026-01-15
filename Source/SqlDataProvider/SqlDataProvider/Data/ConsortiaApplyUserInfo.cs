// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaApplyUserInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaApplyUserInfo
  {
    public int ID { get; set; }

    public int ConsortiaID { get; set; }

    public string ConsortiaName { get; set; }

    public int ChairmanID { get; set; }

    public string ChairmanName { get; set; }

    public int UserID { get; set; }

    public string UserName { get; set; }

    public DateTime ApplyDate { get; set; }

    public string Remark { get; set; }

    public bool IsExist { get; set; }

    public int UserLevel { get; set; }

    public int Win { get; set; }

    public int Total { get; set; }

    public int Repute { get; set; }

    public int FightPower { get; set; }

    public int typeVIP { get; set; }

    public bool IsOld { get; set; }

    public int Offer { get; set; }
  }
}
