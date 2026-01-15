// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PetSkillTemplateInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class PetSkillTemplateInfo
  {
    public int PetTemplateID { get; set; }

    public int KindID { get; set; }

    public int Type { get; set; }

    public int SkillID { get; set; }

    public int SkillBookID { get; set; }

    public int MinLevel { get; set; }

    public string DeleteSkillIDs { get; set; }
  }
}
