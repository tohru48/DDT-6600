// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.MarryRoomInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class MarryRoomInfo
  {
    public int ID { get; set; }

    public string Name { get; set; }

    public int PlayerID { get; set; }

    public string PlayerName { get; set; }

    public int GroomID { get; set; }

    public string GroomName { get; set; }

    public int BrideID { get; set; }

    public string BrideName { get; set; }

    public string Pwd { get; set; }

    public int AvailTime { get; set; }

    public int MaxCount { get; set; }

    public bool GuestInvite { get; set; }

    public int MapIndex { get; set; }

    public DateTime BeginTime { get; set; }

    public DateTime BreakTime { get; set; }

    public string RoomIntroduction { get; set; }

    public int ServerID { get; set; }

    public bool IsHymeneal { get; set; }

    public bool IsGunsaluteUsed { get; set; }
  }
}
