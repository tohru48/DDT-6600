// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PveInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class PveInfo
  {
    public int ID { get; set; }

    public string Name { get; set; }

    public string SimpleTemplateIds { get; set; }

    public string NormalTemplateIds { get; set; }

    public string HardTemplateIds { get; set; }

    public string TerrorTemplateIds { get; set; }

    public string EpicTemplateIds { get; set; }

    public string NightmareTemplateIds { get; set; }

    public int Type { get; set; }

    public int LevelLimits { get; set; }

    public string Pic { get; set; }

    public string Description { get; set; }

    public int Ordering { get; set; }

    public string AdviceTips { get; set; }

    public string SimpleGameScript { get; set; }

    public string NormalGameScript { get; set; }

    public string HardGameScript { get; set; }

    public string TerrorGameScript { get; set; }

    public string EpicGameScript { get; set; }

    public string NightmareGameScript { get; set; }

    public string BossFightNeedMoney { get; set; }

    public int MinLv { get; set; }

    public int MaxLv { get; set; }

    public int GetPrice(int selectedLevel)
    {
      int price = 1;
      string[] strArray = this.BossFightNeedMoney.Split('|');
      if (strArray.Length > 0)
      {
        switch (selectedLevel)
        {
          case 0:
            price = int.Parse(strArray[0]);
            break;
          case 1:
            price = int.Parse(strArray[1]);
            break;
          case 2:
            price = int.Parse(strArray[2]);
            break;
          case 3:
            price = int.Parse(strArray[3]);
            break;
          case 4:
            price = int.Parse(strArray[4]);
            break;
        }
      }
      return price;
    }
  }
}
