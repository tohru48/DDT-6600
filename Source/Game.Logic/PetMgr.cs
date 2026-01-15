// Decompiled with JetBrains decompiler
// Type: Game.Logic.PetMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class PetMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<string, PetConfig> dictionary_0;
    private static Dictionary<int, PetLevel> dictionary_1;
    private static Dictionary<int, PetSkillElementInfo> dictionary_2;
    private static Dictionary<int, PetSkillInfo> dictionary_3;
    private static Dictionary<int, PetSkillTemplateInfo> dictionary_4;
    private static Dictionary<int, PetTemplateInfo> dictionary_5;
    private static Dictionary<int, PetExpItemPriceInfo> dictionary_6;
    private static Dictionary<int, PetFightPropertyInfo> dictionary_7;
    private static Dictionary<int, PetStarExpInfo> dictionary_8;
    private static Dictionary<int, PetFormDataInfo> dictionary_9 = new Dictionary<int, PetFormDataInfo>();
    private static List<GameNeedPetSkillInfo> list_0 = new List<GameNeedPetSkillInfo>();
    private static ThreadSafeRandom threadSafeRandom_0;

    public static bool Init()
    {
      bool flag;
      try
      {
        PetMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        flag = PetMgr.ReLoad();
      }
      catch (Exception ex)
      {
        if (PetMgr.ilog_0.IsErrorEnabled)
          PetMgr.ilog_0.Error((object) "PetInfoMgr", ex);
        flag = false;
      }
      return flag;
    }

    public static bool ReLoad()
    {
      try
      {
        Dictionary<string, PetConfig> Config = new Dictionary<string, PetConfig>();
        Dictionary<int, PetLevel> Level = new Dictionary<int, PetLevel>();
        Dictionary<int, PetSkillElementInfo> SkillElement = new Dictionary<int, PetSkillElementInfo>();
        Dictionary<int, PetSkillInfo> Skill = new Dictionary<int, PetSkillInfo>();
        Dictionary<int, PetSkillTemplateInfo> SkillTemplate = new Dictionary<int, PetSkillTemplateInfo>();
        Dictionary<int, PetTemplateInfo> dictionary1 = new Dictionary<int, PetTemplateInfo>();
        Dictionary<int, PetTemplateInfo> TemplateId = new Dictionary<int, PetTemplateInfo>();
        Dictionary<int, PetExpItemPriceInfo> PetExpItemPrice = new Dictionary<int, PetExpItemPriceInfo>();
        Dictionary<int, PetFightPropertyInfo> FightProperty = new Dictionary<int, PetFightPropertyInfo>();
        Dictionary<int, PetStarExpInfo> StarExp = new Dictionary<int, PetStarExpInfo>();
        PetFormDataInfo[] PetFormData = PetMgr.LoadPetFormDataDb();
        Dictionary<int, PetFormDataInfo> dictionary2 = PetMgr.LoadPetFormDatas(PetFormData);
        if (PetFormData.Length > 0)
          Interlocked.Exchange<Dictionary<int, PetFormDataInfo>>(ref PetMgr.dictionary_9, dictionary2);
        if (PetMgr.smethod_0(Config, Level, SkillElement, Skill, SkillTemplate, TemplateId, PetExpItemPrice, FightProperty, StarExp))
        {
          try
          {
            PetMgr.dictionary_0 = Config;
            PetMgr.dictionary_1 = Level;
            PetMgr.dictionary_2 = SkillElement;
            PetMgr.dictionary_3 = Skill;
            PetMgr.dictionary_4 = SkillTemplate;
            PetMgr.dictionary_5 = TemplateId;
            PetMgr.dictionary_6 = PetExpItemPrice;
            PetMgr.dictionary_7 = FightProperty;
            PetMgr.dictionary_8 = StarExp;
            List<GameNeedPetSkillInfo> needPetSkillInfoList = PetMgr.LoadGameNeedPetSkill();
            if (needPetSkillInfoList.Count > 0)
              Interlocked.Exchange<List<GameNeedPetSkillInfo>>(ref PetMgr.list_0, needPetSkillInfoList);
            return true;
          }
          catch
          {
          }
        }
      }
      catch (Exception ex)
      {
        if (PetMgr.ilog_0.IsErrorEnabled)
          PetMgr.ilog_0.Error((object) nameof (PetMgr), ex);
      }
      return false;
    }

    public static GameNeedPetSkillInfo[] GetGameNeedPetSkill() => PetMgr.list_0.ToArray();

    public static List<GameNeedPetSkillInfo> LoadGameNeedPetSkill()
    {
      List<GameNeedPetSkillInfo> needPetSkillInfoList = new List<GameNeedPetSkillInfo>();
      List<string> stringList = new List<string>();
      foreach (PetSkillInfo petSkillInfo in PetMgr.dictionary_3.Values)
      {
        string effectPic = petSkillInfo.EffectPic;
        if (!string.IsNullOrEmpty(effectPic) && !stringList.Contains(effectPic))
        {
          needPetSkillInfoList.Add(new GameNeedPetSkillInfo()
          {
            Pic = petSkillInfo.Pic,
            EffectPic = petSkillInfo.EffectPic
          });
          stringList.Add(effectPic);
        }
      }
      foreach (PetSkillElementInfo skillElementInfo in PetMgr.dictionary_2.Values)
      {
        string effectPic = skillElementInfo.EffectPic;
        if (!string.IsNullOrEmpty(effectPic) && !stringList.Contains(effectPic))
        {
          needPetSkillInfoList.Add(new GameNeedPetSkillInfo()
          {
            Pic = skillElementInfo.Pic,
            EffectPic = skillElementInfo.EffectPic
          });
          stringList.Add(effectPic);
        }
      }
      return needPetSkillInfoList;
    }

    public static PetFormDataInfo[] LoadPetFormDataDb()
    {
      PetFormDataInfo[] allPetFormData;
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
        allPetFormData = playerBussiness.GetAllPetFormData();
      return allPetFormData;
    }

    public static Dictionary<int, PetFormDataInfo> LoadPetFormDatas(PetFormDataInfo[] PetFormData)
    {
      Dictionary<int, PetFormDataInfo> dictionary = new Dictionary<int, PetFormDataInfo>();
      for (int index = 0; index < PetFormData.Length; ++index)
      {
        PetFormDataInfo petFormDataInfo = PetFormData[index];
        if (!dictionary.Keys.Contains<int>(petFormDataInfo.TemplateID))
          dictionary.Add(petFormDataInfo.TemplateID, petFormDataInfo);
      }
      return dictionary;
    }

    public static PetFormDataInfo FindPetFormData(int ID)
    {
      return PetMgr.dictionary_9.ContainsKey(ID) ? PetMgr.dictionary_9[ID] : (PetFormDataInfo) null;
    }

    private static bool smethod_0(
      Dictionary<string, PetConfig> Config,
      Dictionary<int, PetLevel> Level,
      Dictionary<int, PetSkillElementInfo> SkillElement,
      Dictionary<int, PetSkillInfo> Skill,
      Dictionary<int, PetSkillTemplateInfo> SkillTemplate,
      Dictionary<int, PetTemplateInfo> TemplateId,
      Dictionary<int, PetExpItemPriceInfo> PetExpItemPrice,
      Dictionary<int, PetFightPropertyInfo> FightProperty,
      Dictionary<int, PetStarExpInfo> StarExp)
    {
      using (PlayerBussiness playerBussiness = new PlayerBussiness())
      {
        PetConfig[] allPetConfig = playerBussiness.GetAllPetConfig();
        PetLevel[] allPetLevel = playerBussiness.GetAllPetLevel();
        PetSkillElementInfo[] skillElementInfo1 = playerBussiness.GetAllPetSkillElementInfo();
        PetSkillInfo[] allPetSkillInfo = playerBussiness.GetAllPetSkillInfo();
        PetSkillTemplateInfo[] skillTemplateInfo1 = playerBussiness.GetAllPetSkillTemplateInfo();
        PetTemplateInfo[] allPetTemplateInfo = playerBussiness.GetAllPetTemplateInfo();
        PetExpItemPriceInfo[] allPetExpItemPrice = playerBussiness.GetAllPetExpItemPrice();
        PetFightPropertyInfo[] petFightProperty = playerBussiness.GetAllPetFightProperty();
        PetStarExpInfo[] allPetStarExp = playerBussiness.GetAllPetStarExp();
        foreach (PetExpItemPriceInfo expItemPriceInfo in allPetExpItemPrice)
        {
          if (!PetExpItemPrice.ContainsKey(expItemPriceInfo.Count))
            PetExpItemPrice.Add(expItemPriceInfo.Count, expItemPriceInfo);
        }
        foreach (PetConfig petConfig in allPetConfig)
        {
          if (!Config.ContainsKey(petConfig.Name))
            Config.Add(petConfig.Name, petConfig);
        }
        foreach (PetLevel petLevel in allPetLevel)
        {
          if (!Level.ContainsKey(petLevel.Level))
            Level.Add(petLevel.Level, petLevel);
        }
        foreach (PetSkillElementInfo skillElementInfo2 in skillElementInfo1)
        {
          if (!SkillElement.ContainsKey(skillElementInfo2.ID))
            SkillElement.Add(skillElementInfo2.ID, skillElementInfo2);
        }
        foreach (PetSkillTemplateInfo skillTemplateInfo2 in skillTemplateInfo1)
        {
          if (!SkillTemplate.ContainsKey(skillTemplateInfo2.SkillID))
            SkillTemplate.Add(skillTemplateInfo2.SkillID, skillTemplateInfo2);
        }
        foreach (PetTemplateInfo petTemplateInfo in allPetTemplateInfo)
        {
          if (!TemplateId.ContainsKey(petTemplateInfo.TemplateID))
            TemplateId.Add(petTemplateInfo.TemplateID, petTemplateInfo);
        }
        foreach (PetSkillInfo petSkillInfo in allPetSkillInfo)
        {
          if (!Skill.ContainsKey(petSkillInfo.ID))
            Skill.Add(petSkillInfo.ID, petSkillInfo);
        }
        foreach (PetFightPropertyInfo fightPropertyInfo in petFightProperty)
        {
          if (!FightProperty.ContainsKey(fightPropertyInfo.ID))
            FightProperty.Add(fightPropertyInfo.ID, fightPropertyInfo);
        }
        foreach (PetStarExpInfo petStarExpInfo in allPetStarExp)
        {
          if (!StarExp.ContainsKey(petStarExpInfo.OldID))
            StarExp.Add(petStarExpInfo.OldID, petStarExpInfo);
        }
      }
      return true;
    }

    public static PetFightPropertyInfo FindFightProperty(int level)
    {
      if (PetMgr.dictionary_7 == null)
        PetMgr.Init();
      return PetMgr.dictionary_7.ContainsKey(level) ? PetMgr.dictionary_7[level] : (PetFightPropertyInfo) null;
    }

    public static int GetEvolutionGP(int level)
    {
      PetFightPropertyInfo fightProperty = PetMgr.FindFightProperty(level + 1);
      return fightProperty != null ? fightProperty.Exp : -1;
    }

    public static int GetEvolutionGrade(int GP)
    {
      int count = PetMgr.dictionary_7.Count;
      if (GP >= PetMgr.FindFightProperty(count).Exp)
        return count;
      for (int level = 1; level <= count; ++level)
      {
        PetFightPropertyInfo fightProperty = PetMgr.FindFightProperty(level);
        if (fightProperty == null)
          return 1;
        if (GP < fightProperty.Exp)
          return level - 1 >= 0 ? level - 1 : 0;
      }
      return 0;
    }

    public static PetExpItemPriceInfo FindPetExpItemPrice(int count)
    {
      if (PetMgr.dictionary_6 == null)
        PetMgr.Init();
      return PetMgr.dictionary_6.ContainsKey(count) ? PetMgr.dictionary_6[count] : (PetExpItemPriceInfo) null;
    }

    public static PetConfig FindConfig(string key)
    {
      if (PetMgr.dictionary_0 == null)
        PetMgr.Init();
      return PetMgr.dictionary_0.ContainsKey(key) ? PetMgr.dictionary_0[key] : (PetConfig) null;
    }

    public static PetLevel FindPetLevel(int level)
    {
      if (PetMgr.dictionary_1 == null)
        PetMgr.Init();
      return PetMgr.dictionary_1.ContainsKey(level) ? PetMgr.dictionary_1[level] : (PetLevel) null;
    }

    public static PetSkillElementInfo FindPetSkillElement(int SkillID)
    {
      if (PetMgr.dictionary_2 == null)
        PetMgr.Init();
      return PetMgr.dictionary_2.ContainsKey(SkillID) ? PetMgr.dictionary_2[SkillID] : (PetSkillElementInfo) null;
    }

    public static PetSkillInfo FindPetSkill(int SkillID)
    {
      if (PetMgr.dictionary_3 == null)
        PetMgr.Init();
      return PetMgr.dictionary_3.ContainsKey(SkillID) ? PetMgr.dictionary_3[SkillID] : (PetSkillInfo) null;
    }

    public static PetSkillInfo[] GetPetSkills()
    {
      List<PetSkillInfo> petSkillInfoList = new List<PetSkillInfo>();
      if (PetMgr.dictionary_3 == null)
        PetMgr.Init();
      foreach (PetSkillInfo petSkillInfo in PetMgr.dictionary_3.Values)
        petSkillInfoList.Add(petSkillInfo);
      return petSkillInfoList.ToArray();
    }

    public static PetSkillTemplateInfo GetPetSkillTemplate(int ID)
    {
      if (PetMgr.dictionary_4 == null)
        PetMgr.Init();
      return PetMgr.dictionary_4.ContainsKey(ID) ? PetMgr.dictionary_4[ID] : (PetSkillTemplateInfo) null;
    }

    public static PetTemplateInfo FindPetTemplate(int TemplateID)
    {
      if (PetMgr.dictionary_5 == null)
        PetMgr.Init();
      return PetMgr.dictionary_5.ContainsKey(TemplateID) ? PetMgr.dictionary_5[TemplateID] : (PetTemplateInfo) null;
    }

    public static List<int> GetPetSkillByKindID(int KindID, int lv, int playerLevel)
    {
      List<int> petSkillByKindId1 = new List<int>();
      List<string> stringList = new List<string>();
      PetSkillTemplateInfo[] petSkillByKindId2 = PetMgr.GetPetSkillByKindID(KindID);
      int num1 = lv > playerLevel ? playerLevel : lv;
      for (int index = 1; index <= num1; ++index)
      {
        foreach (PetSkillTemplateInfo skillTemplateInfo in petSkillByKindId2)
        {
          if (skillTemplateInfo.MinLevel == index)
          {
            string deleteSkillIds = skillTemplateInfo.DeleteSkillIDs;
            char[] chArray = new char[1]{ ',' };
            foreach (string str in deleteSkillIds.Split(chArray))
              stringList.Add(str);
            petSkillByKindId1.Add(skillTemplateInfo.SkillID);
          }
        }
      }
      foreach (string s in stringList)
      {
        if (!string.IsNullOrEmpty(s))
        {
          int num2 = int.Parse(s);
          petSkillByKindId1.Remove(num2);
        }
      }
      petSkillByKindId1.Sort();
      return petSkillByKindId1;
    }

    public static PetSkillTemplateInfo[] GetPetSkillByKindID(int KindID)
    {
      List<PetSkillTemplateInfo> skillTemplateInfoList = new List<PetSkillTemplateInfo>();
      foreach (PetSkillTemplateInfo skillTemplateInfo in PetMgr.dictionary_4.Values)
      {
        if (skillTemplateInfo.KindID == KindID)
          skillTemplateInfoList.Add(skillTemplateInfo);
      }
      return skillTemplateInfoList.ToArray();
    }

    public static List<UsersPetinfo> CreateAdoptList(int userID, int playerLevel)
    {
      int int32 = Convert.ToInt32(PetMgr.FindConfig("AdoptCount").Value);
      List<UsersPetinfo> adoptList = new List<UsersPetinfo>();
      List<PetTemplateInfo> info = (List<PetTemplateInfo>) null;
      int place = 0;
      while (place < int32)
      {
        if (DropInventory.GetPetDrop(613, 1, ref info) && info != null)
        {
          int index = PetMgr.threadSafeRandom_0.Next(info.Count);
          UsersPetinfo pet = PetMgr.CreatePet(info[index], userID, place, playerLevel);
          pet.IsExit = true;
          adoptList.Add(pet);
          ++place;
        }
      }
      return adoptList;
    }

    public static List<UsersPetinfo> CreateFirstAdoptList(int userID, int playerLevel)
    {
      List<int> intList = new List<int>()
      {
        100301,
        110301,
        120301,
        130301
      };
      List<UsersPetinfo> firstAdoptList = new List<UsersPetinfo>();
      for (int index = 0; index < intList.Count; ++index)
      {
        UsersPetinfo pet = PetMgr.CreatePet(PetMgr.FindPetTemplate(intList[index]), userID, index, playerLevel);
        pet.IsExit = true;
        firstAdoptList.Add(pet);
      }
      return firstAdoptList;
    }

    public static string ActiveEquipSkill(int Level)
    {
      string str = "0,0";
      int num = 1;
      if (Level >= 20 && Level < 30)
        ++num;
      if (Level >= 30 && Level < 50)
        num += 2;
      if (Level >= 50 && Level < 60)
        num += 3;
      if (Level == 60)
        num += 4;
      for (int index = 1; index < num; ++index)
        str = str + "|0," + (object) index;
      return str;
    }

    public static int UpdateEvolution(int TemplateID, int lv)
    {
      int TemplateID1 = TemplateID;
      int int32_1 = Convert.ToInt32(PetMgr.FindConfig("EvolutionLevel1").Value);
      int int32_2 = Convert.ToInt32(PetMgr.FindConfig("EvolutionLevel2").Value);
      PetTemplateInfo petTemplate1 = PetMgr.FindPetTemplate(TemplateID1);
      PetTemplateInfo petTemplate2 = PetMgr.FindPetTemplate(TemplateID1 + 1);
      if (PetMgr.FindPetTemplate(TemplateID1 + 2) != null)
      {
        if (lv >= int32_1 && lv < int32_2 && petTemplate2.EvolutionID != 0)
          TemplateID1 = petTemplate1.EvolutionID;
        else if (lv >= int32_2)
          TemplateID1 = petTemplate2.EvolutionID;
      }
      else if (petTemplate2 != null && lv >= int32_2)
        TemplateID1 = petTemplate1.EvolutionID;
      return TemplateID1;
    }

    public static int TemplateReset(int TemplateID)
    {
      int num = TemplateID;
      PetTemplateInfo petTemplate1 = PetMgr.FindPetTemplate(num - 1);
      PetTemplateInfo petTemplate2 = PetMgr.FindPetTemplate(num - 2);
      if (petTemplate1 != null)
        num = petTemplate1.TemplateID;
      else if (petTemplate2 != null)
        num = petTemplate2.TemplateID;
      return num;
    }

    public static string UpdateSkillPet(int Level, int TemplateID, int playerLevel)
    {
      PetTemplateInfo petTemplate = PetMgr.FindPetTemplate(TemplateID);
      if (petTemplate == null)
      {
        PetMgr.ilog_0.Error((object) ("Pet not found: " + (object) TemplateID));
        return "";
      }
      List<int> petSkillByKindId = PetMgr.GetPetSkillByKindID(petTemplate.KindID, Level, playerLevel);
      string str = petSkillByKindId[0].ToString() + ",0";
      for (int index = 1; index < petSkillByKindId.Count; ++index)
        str = str + "|" + (object) petSkillByKindId[index] + "," + (object) index;
      return str;
    }

    public static int GetLevel(int GP, int playerLevel)
    {
      if (GP >= PetMgr.FindPetLevel(playerLevel).GP)
        return playerLevel;
      for (int level = 1; level <= playerLevel; ++level)
      {
        if (GP < PetMgr.FindPetLevel(level).GP)
          return level - 1 != 0 ? level - 1 : 1;
      }
      return 1;
    }

    public static int GetGP(int level, int playerLevel)
    {
      for (int level1 = 1; level1 <= playerLevel; ++level1)
      {
        if (level == PetMgr.FindPetLevel(level1).Level)
          return PetMgr.FindPetLevel(level1).GP;
      }
      return 0;
    }

    public static void PlusPetProp(
      UsersPetinfo pet,
      int min,
      int max,
      ref int blood,
      ref int attack,
      ref int defence,
      ref int agility,
      ref int lucky)
    {
      double num1 = (double) (pet.BloodGrow / 10) * 0.1;
      double num2 = (double) (pet.AttackGrow / 10) * 0.1;
      double num3 = (double) (pet.DefenceGrow / 10) * 0.1;
      double num4 = (double) (pet.AgilityGrow / 10) * 0.1;
      double num5 = (double) (pet.LuckGrow / 10) * 0.1;
      double num6 = 0.0;
      double blood1 = (double) pet.Blood;
      double attack1 = (double) pet.Attack;
      double defence1 = (double) pet.Defence;
      double agility1 = (double) pet.Agility;
      double luck = (double) pet.Luck;
      for (int y = min + 1; y <= max; ++y)
      {
        num6 += (double) (min / 100);
        double x = 0.5;
        blood1 += num1 + Math.Pow(x, (double) y);
        attack1 += num2 + Math.Pow(x, (double) y);
        defence1 += num3 + Math.Pow(x, (double) y);
        agility1 += num4 + Math.Pow(x, (double) y);
        luck += num5 + Math.Pow(x, (double) y);
      }
      blood = (int) (num1 * (blood1 / (num1 + num6)));
      attack = (int) (num2 * (attack1 / (num2 + num6)));
      defence = (int) (num3 * (defence1 / (num3 + num6)));
      agility = (int) (num4 * (agility1 / (num4 + num6)));
      lucky = (int) (num5 * (luck / (num5 + num6)));
    }

    public static UsersPetinfo CreatePet(
      PetTemplateInfo info,
      int userID,
      int place,
      int playerLevel)
    {
      UsersPetinfo pet = new UsersPetinfo();
      int starLevel = info.StarLevel;
      int minValue1 = 200 + 100 * starLevel;
      int maxValue1 = 350 + 100 * starLevel;
      int minValue2 = 1700 + 1000 * starLevel;
      int maxValue2 = 2200 + 2500 * starLevel;
      pet.ID = 0;
      pet.BloodGrow = PetMgr.threadSafeRandom_0.Next(minValue2, maxValue2);
      pet.AttackGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      pet.DefenceGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      pet.AgilityGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      pet.LuckGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      pet.DamageGrow = 0;
      pet.GuardGrow = 0;
      double num1 = (double) PetMgr.threadSafeRandom_0.Next(54, 61) * 0.1;
      double num2 = (double) PetMgr.threadSafeRandom_0.Next(9, 13) * 0.1;
      pet.Blood = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue2, maxValue2) / 10) * 0.1 * num1);
      pet.Attack = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      pet.Defence = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      pet.Agility = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      pet.Luck = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      pet.Damage = 0;
      pet.Guard = 0;
      pet.Hunger = 10000;
      pet.TemplateID = info.TemplateID;
      pet.Name = info.Name;
      pet.UserID = userID;
      pet.Place = place;
      pet.Level = 1;
      pet.Skill = PetMgr.UpdateSkillPet(1, info.TemplateID, playerLevel);
      pet.SkillEquip = PetMgr.ActiveEquipSkill(1);
      return pet;
    }

    public static UsersPetinfo CreateNewPet()
    {
      string[] strArray = PetMgr.FindConfig("NewPet").Value.Split(',');
      int index = PetMgr.threadSafeRandom_0.Next(strArray.Length);
      PetTemplateInfo petTemplate = PetMgr.FindPetTemplate(Convert.ToInt32(strArray[index]));
      UsersPetinfo newPet = new UsersPetinfo();
      int starLevel = petTemplate.StarLevel;
      int minValue1 = 300 + 100 * starLevel;
      int maxValue1 = 450 + 100 * starLevel;
      int minValue2 = 1800 + 1000 * starLevel;
      int maxValue2 = 2300 + 2500 * starLevel;
      newPet.ID = 0;
      newPet.BloodGrow = PetMgr.threadSafeRandom_0.Next(minValue2, maxValue2);
      newPet.AttackGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      newPet.DefenceGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      newPet.AgilityGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      newPet.LuckGrow = PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1);
      newPet.DamageGrow = 0;
      newPet.GuardGrow = 0;
      double num1 = (double) PetMgr.threadSafeRandom_0.Next(54, 61) * 0.1;
      double num2 = (double) PetMgr.threadSafeRandom_0.Next(9, 13) * 0.1;
      newPet.Blood = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue2, maxValue2) / 10) * 0.1 * num1);
      newPet.Attack = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      newPet.Defence = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      newPet.Agility = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      newPet.Luck = (int) ((double) (PetMgr.threadSafeRandom_0.Next(minValue1, maxValue1) / 10) * 0.1 * num2);
      newPet.Damage = 0;
      newPet.Guard = 0;
      newPet.Hunger = 10000;
      newPet.TemplateID = petTemplate.TemplateID;
      newPet.Name = petTemplate.Name;
      newPet.UserID = -1;
      newPet.Place = -1;
      newPet.Level = 60;
      newPet.Skill = PetMgr.UpdateSkillPet(60, petTemplate.TemplateID, 60);
      newPet.SkillEquip = PetMgr.ActiveEquipSkill(1);
      return newPet;
    }
  }
}
