// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.RingstationBattleFieldInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class RingstationBattleFieldInfo : DataObject
  {
    public int ID { get; set; }

    public int UserID { get; set; }

    public bool DareFlag { get; set; }

    public string UserName { get; set; }

    public bool SuccessFlag { get; set; }

    public int Level { get; set; }

    public DateTime BattleTime { get; set; }
  }
}
