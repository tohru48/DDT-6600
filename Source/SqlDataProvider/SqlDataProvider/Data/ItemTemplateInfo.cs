// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ItemTemplateInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ItemTemplateInfo : DataObject
  {
    public int TemplateID { get; set; }

    public string Name { get; set; }

    public int CategoryID { get; set; }

    public string Description { get; set; }

    public int Attack { get; set; }

    public int Defence { get; set; }

    public int Luck { get; set; }

    public int Agility { get; set; }

    public int Level { get; set; }

    public string Pic { get; set; }

    public string AddTime { get; set; }

    public int Quality { get; set; }

    public int MaxCount { get; set; }

    public string Data { get; set; }

    public int Property1 { get; set; }

    public int Property2 { get; set; }

    public int Property3 { get; set; }

    public int Property4 { get; set; }

    public int Property5 { get; set; }

    public int Property6 { get; set; }

    public int Property7 { get; set; }

    public int Property8 { get; set; }

    public int NeedSex { get; set; }

    public int NeedLevel { get; set; }

    public bool CanDrop { get; set; }

    public bool CanDelete { get; set; }

    public bool CanEquip { get; set; }

    public bool CanUse { get; set; }

    public string Script { get; set; }

    public string Colors { get; set; }

    public bool CanStrengthen { get; set; }

    public bool CanCompose { get; set; }

    public int BindType { get; set; }

    public int FusionType { get; set; }

    public int FusionRate { get; set; }

    public int FusionNeedRate { get; set; }

    public int RefineryType { get; set; }

    public string Hole { get; set; }

    public int RefineryLevel { get; set; }

    public int ReclaimValue { get; set; }

    public int ReclaimType { get; set; }

    public int CanRecycle { get; set; }

    public int FloorPrice { get; set; }

    public int SuitId { get; set; }

    public int CanTransfer { get; set; }

    public eBageType BagType
    {
      get
      {
        switch (this.CategoryID)
        {
          case 10:
          case 11:
          case 12:
          case 20:
          case 34:
          case 35:
          case 62:
          case 80:
            return this.Property1 == 31 && this.CategoryID == 11 ? eBageType.BeadBag : eBageType.PropBag;
          case 32:
            return eBageType.FarmBag;
          case 61:
            return eBageType.MagicStoneBag;
          default:
            return eBageType.EquipBag;
        }
      }
    }
  }
}
