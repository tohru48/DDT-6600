// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.Equip
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class Equip
  {
    public static bool isAvatar(ItemTemplateInfo info)
    {
      switch (info.TemplateID)
      {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 13:
        case 15:
          return true;
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 14:
          return false;
        default:
          return false;
      }
    }

    public static bool isShowImp(ItemTemplateInfo info)
    {
      switch (info.CategoryID)
      {
        case 1:
          return true;
        case 5:
        case 7:
          return true;
        case 6:
          return false;
        default:
          return false;
      }
    }

    public static bool isWeddingRing(ItemTemplateInfo info)
    {
      int templateId = info.TemplateID;
      if (templateId <= 9222)
      {
        if (templateId == 9022 || templateId == 9122 || templateId == 9222)
          return true;
      }
      else if (templateId == 9322 || templateId == 9422 || templateId == 9522)
        return true;
      return false;
    }

    public static bool isMagicStone(int CategoryID) => CategoryID == 61;
  }
}
