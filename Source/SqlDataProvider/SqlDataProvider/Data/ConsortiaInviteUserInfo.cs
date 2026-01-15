// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ConsortiaInviteUserInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class ConsortiaInviteUserInfo
  {
    public int ID { get; set; }

    public int ConsortiaID { get; set; }

    public string ConsortiaName { get; set; }

    public int UserID { get; set; }

    public string UserName { get; set; }

    public int InviteID { get; set; }

    public string InviteName { get; set; }

    public DateTime InviteDate { get; set; }

    public string Remark { get; set; }

    public bool IsExist { get; set; }

    public string ChairmanName { get; set; }

    public int CelebCount { get; set; }

    public int Honor { get; set; }

    public int Repute { get; set; }

    public int Count { get; set; }
  }
}
