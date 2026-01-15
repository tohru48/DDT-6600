// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.EventAwardInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class EventAwardInfo
  {
    public int ID;
    public int ActivityType;
    public int TemplateID;
    public int Count;
    public int ValidDate;
    public bool IsBinds;
    public int StrengthenLevel;
    public int AttackCompose;
    public int DefendCompose;
    public int AgilityCompose;
    public int LuckCompose;
    public int Random;

    public int Position { get; set; }
  }
}
