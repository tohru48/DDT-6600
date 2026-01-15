// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ServerInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ServerInfo
  {
    public int ID { get; set; }

    public string Name { get; set; }

    public string IP { get; set; }

    public int Port { get; set; }

    public int State { get; set; }

    public int Online { get; set; }

    public int Total { get; set; }

    public int Room { get; set; }

    public string Remark { get; set; }

    public string RSA { get; set; }

    public int MustLevel { get; set; }

    public int LowestLevel { get; set; }

    public bool NewerServer { get; set; }

    public int AreaId { get; set; }

    public string AreaName { get; set; }
  }
}
