// Decompiled with JetBrains decompiler
// Type: Fighting.Server.GameObjects.ProxyPlayerInfo
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Bussiness.Managers;
using System;

#nullable disable
namespace Fighting.Server.GameObjects
{
  public class ProxyPlayerInfo
  {
    public int ServerId { get; set; }

    public int ZoneId { get; set; }

    public string ZoneName { get; set; }

    public double BaseAttack { get; set; }

    public double BaseDefence { get; set; }

    public double BaseAgility { get; set; }

    public double BaseBlood { get; set; }

    public int TemplateId { get; set; }

    public bool CanUserProp { get; set; }

    public int DragonBoatAddExpPlus { get; set; }

    public bool DragonBoatOpen { get; set; }

    public string TcpEndPoint { get; set; }

    public int SecondWeapon { get; set; }

    public int StrengthLevel { get; set; }

    public int Healstone { get; set; }

    public int HealstoneCount { get; set; }

    public double Double_0 { get; set; }

    public float GMExperienceRate { get; set; }

    public float AuncherExperienceRate { get; set; }

    public double OfferAddPlus { get; set; }

    public float Single_0 { get; set; }

    public float AuncherOfferRate { get; set; }

    public float GMRichesRate { get; set; }

    public float AuncherRichesRate { get; set; }

    public double AntiAddictionRate { get; set; }

    public string RedFootballStyle { get; set; }

    public string BlueFootballStyle { get; set; }

    public int GoldTemplateId { get; set; }

    public int WeaponStrengthLevel { get; set; }

    public DateTime goldBeginTime { get; set; }

    public int goldValidDate { get; set; }

    public SqlDataProvider.Data.ItemInfo GetItemTemplateInfo()
    {
      SqlDataProvider.Data.ItemInfo itemTemplateInfo = (SqlDataProvider.Data.ItemInfo) null;
      if (this.TemplateId != 0)
      {
        itemTemplateInfo = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(this.TemplateId), 1, 1);
        itemTemplateInfo.StrengthenLevel = this.WeaponStrengthLevel;
      }
      if (this.GoldTemplateId != 0)
      {
        itemTemplateInfo.GoldEquip = ItemMgr.FindItemTemplate(this.GoldTemplateId);
        itemTemplateInfo.goldBeginTime = this.goldBeginTime;
        itemTemplateInfo.goldValidDate = this.goldValidDate;
      }
      return itemTemplateInfo;
    }

    public SqlDataProvider.Data.ItemInfo GetItemInfo()
    {
      SqlDataProvider.Data.ItemInfo itemInfo = (SqlDataProvider.Data.ItemInfo) null;
      if (this.SecondWeapon != 0)
      {
        itemInfo = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(this.SecondWeapon), 1, 1);
        itemInfo.StrengthenLevel = this.StrengthLevel;
      }
      return itemInfo;
    }

    public SqlDataProvider.Data.ItemInfo GetHealstone()
    {
      SqlDataProvider.Data.ItemInfo healstone = (SqlDataProvider.Data.ItemInfo) null;
      if (this.Healstone != 0)
      {
        healstone = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(this.Healstone), 1, 1);
        healstone.Count = this.HealstoneCount;
      }
      return healstone;
    }
  }
}
