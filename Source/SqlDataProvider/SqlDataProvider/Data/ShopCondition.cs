// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.ShopCondition
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class ShopCondition
  {
    public static bool isCatchInsect(int type) => type == 90;

    public static bool isSearchGoods(int type) => type == 99;

    public static bool isLabyrinth(int type) => type == 94;

    public static bool isLeague(int type) => type == 93;

    public static bool isPetScrore(int type) => type == 92;

    public static bool isWorldBoss(int type) => type == 91;

    public static bool isOffer(int type)
    {
      switch (type)
      {
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
          return true;
        default:
          return false;
      }
    }

    public static bool isMoney(int type)
    {
      switch (type)
      {
        case 1:
        case 3:
          return true;
        case 2:
          return false;
        default:
          return false;
      }
    }

    public static bool smethod_0(int type) => type == 2;
  }
}
