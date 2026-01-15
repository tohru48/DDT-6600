// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.FriendInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class FriendInfo : DataObject
  {
    public int ID { get; set; }

    public int UserID { get; set; }

    public int FriendID { get; set; }

    public DateTime AddDate { get; set; }

    public DateTime LastDate { get; set; }

    public string Remark { get; set; }

    public bool IsExist { get; set; }

    public bool IsMarried { get; set; }

    public string NickName { get; set; }

    public string UserName { get; set; }

    public string Style { get; set; }

    public int Sex { get; set; }

    public string DutyName { get; set; }

    public string Colors { get; set; }

    public int Grade { get; set; }

    public int Hide { get; set; }

    public int State { get; set; }

    public int Offer { get; set; }

    public string ConsortiaName { get; set; }

    public int Win { get; set; }

    public int Total { get; set; }

    public int Escape { get; set; }

    public int Relation { get; set; }

    public int Repute { get; set; }

    public byte typeVIP { get; set; }

    public int VIPLevel { get; set; }

    public int Nimbus { get; set; }

    public int FightPower { get; set; }
  }
}
