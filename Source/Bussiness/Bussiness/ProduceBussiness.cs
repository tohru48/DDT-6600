// Decompiled with JetBrains decompiler
// Type: Bussiness.ProduceBussiness
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
  public class ProduceBussiness : BaseBussiness
  {
    public MysteryShopInfo[] GetAllMysteryShop()
    {
      List<MysteryShopInfo> mysteryShopInfoList = new List<MysteryShopInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Mystery_Shop_Items_All");
        while (ResultDataReader.Read())
          mysteryShopInfoList.Add(this.InitMysteryShopInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitMysteryShopInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return mysteryShopInfoList.ToArray();
    }

    public MysteryShopInfo InitMysteryShopInfo(SqlDataReader dr)
    {
      return new MysteryShopInfo()
      {
        ID = (int) dr["ID"],
        LableType = (int) dr["LableType"],
        InfoID = (int) dr["InfoID"],
        Unit = (int) dr["Unit"],
        Num = (int) dr["Num"],
        Price = (int) dr["Price"],
        CanBuy = (int) dr["CanBuy"],
        Random = (int) dr["Random"]
      };
    }

    public BoguAdventureRewardInfo[] GetAllBoguAdventureReward()
    {
      List<BoguAdventureRewardInfo> adventureRewardInfoList = new List<BoguAdventureRewardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_BoguAdventure_Reward_All");
        while (ResultDataReader.Read())
          adventureRewardInfoList.Add(this.InitBoguAdventureRewardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitBoguAdventureRewardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return adventureRewardInfoList.ToArray();
    }

    public BoguAdventureRewardInfo InitBoguAdventureRewardInfo(SqlDataReader dr)
    {
      return new BoguAdventureRewardInfo()
      {
        AwardID = (int) dr["AwardID"],
        TemplateID = (int) dr["TemplateID"],
        Count = (int) dr["Count"],
        ValidDate = (int) dr["ValidDate"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"],
        IsBinds = (bool) dr["IsBinds"]
      };
    }

    public TreasurePuzzleRewardInfo[] GetAllTreasurePuzzleReward()
    {
      List<TreasurePuzzleRewardInfo> puzzleRewardInfoList = new List<TreasurePuzzleRewardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Treasure_Puzzle_Reward_All");
        while (ResultDataReader.Read())
          puzzleRewardInfoList.Add(this.InitTreasurePuzzleRewardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitTreasurePuzzleRewardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return puzzleRewardInfoList.ToArray();
    }

    public TreasurePuzzleRewardInfo InitTreasurePuzzleRewardInfo(SqlDataReader dr)
    {
      return new TreasurePuzzleRewardInfo()
      {
        PuzzleID = (int) dr["PuzzleID"],
        TemplateID = (int) dr["TemplateID"],
        Count = (int) dr["Count"],
        ValidDate = (int) dr["ValidDate"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"],
        IsBinds = (bool) dr["IsBinds"]
      };
    }

    public MountDrawTemplateInfo[] GetAllMountDrawTemplate()
    {
      List<MountDrawTemplateInfo> drawTemplateInfoList = new List<MountDrawTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Mount_Draw_Template_All");
        while (ResultDataReader.Read())
          drawTemplateInfoList.Add(this.InitMountDrawTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitMountDrawTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return drawTemplateInfoList.ToArray();
    }

    public MountDrawTemplateInfo InitMountDrawTemplateInfo(SqlDataReader dr)
    {
      return new MountDrawTemplateInfo()
      {
        ID = (int) dr["ID"],
        TemplateId = (int) dr["TemplateId"],
        AddHurt = (int) dr["AddHurt"],
        AddGuard = (int) dr["AddGuard"],
        MagicAttack = (int) dr["MagicAttack"],
        MagicDefence = (int) dr["MagicDefence"],
        AddBlood = (int) dr["AddBlood"],
        Name = (string) dr["Name"]
      };
    }

    public MountSkillElementTemplateInfo[] GetAllMountSkillElementTemplateInfo()
    {
      List<MountSkillElementTemplateInfo> elementTemplateInfoList = new List<MountSkillElementTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MountSkillElementTemplate_All");
        while (ResultDataReader.Read())
          elementTemplateInfoList.Add(new MountSkillElementTemplateInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"].ToString(),
            EffectPic = ResultDataReader["EffectPic"].ToString(),
            Description = ResultDataReader["Description"].ToString(),
            Pic = (int) ResultDataReader["Pic"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetMountSkillElementTemplate", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return elementTemplateInfoList.ToArray();
    }

    public MountSkillGetTemplateInfo[] GetAllMountSkillGetTemplateInfo()
    {
      List<MountSkillGetTemplateInfo> skillGetTemplateInfoList = new List<MountSkillGetTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MountSkillGetTemplate_All");
        while (ResultDataReader.Read())
          skillGetTemplateInfoList.Add(new MountSkillGetTemplateInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Level = (int) ResultDataReader["Level"],
            SkillID = (int) ResultDataReader["SkillID"],
            NextID = (int) ResultDataReader["NextID"],
            Type = (int) ResultDataReader["Type"],
            Exp = (int) ResultDataReader["Exp"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetMountSkillGetTemplate", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return skillGetTemplateInfoList.ToArray();
    }

    public MountSkillTemplateInfo[] GetAllMountSkillTemplateInfo()
    {
      List<MountSkillTemplateInfo> skillTemplateInfoList = new List<MountSkillTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MountSkillTemplate_All");
        while (ResultDataReader.Read())
          skillTemplateInfoList.Add(new MountSkillTemplateInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"].ToString(),
            String_0 = ResultDataReader["ElementIDs"].ToString(),
            Description = ResultDataReader["Description"].ToString(),
            BallType = (int) ResultDataReader["BallType"],
            NewBallID = (int) ResultDataReader["NewBallID"],
            CostMP = (int) ResultDataReader["CostMP"],
            Pic = (int) ResultDataReader["Pic"],
            Action = ResultDataReader["Action"].ToString(),
            EffectPic = ResultDataReader["EffectPic"].ToString(),
            Delay = (int) ResultDataReader["Delay"],
            ColdDown = (int) ResultDataReader["ColdDown"],
            GameType = (int) ResultDataReader["GameType"],
            Probability = (int) ResultDataReader["Probability"],
            CostEnergy = (int) ResultDataReader["CostEnergy"],
            UseCount = (int) ResultDataReader["UseCount"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetMountSkillTemplate", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return skillTemplateInfoList.ToArray();
    }

    public MountTemplateInfo[] GetAllMountTemplateInfo()
    {
      List<MountTemplateInfo> mountTemplateInfoList = new List<MountTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MountTemplate_All");
        while (ResultDataReader.Read())
          mountTemplateInfoList.Add(new MountTemplateInfo()
          {
            Grade = (int) ResultDataReader["Grade"],
            Experience = (int) ResultDataReader["Experience"],
            SkillID = (int) ResultDataReader["SkillID"],
            AddDamage = (int) ResultDataReader["AddDamage"],
            AddGuard = (int) ResultDataReader["AddGuard"],
            MagicAttack = (int) ResultDataReader["MagicAttack"],
            MagicDefence = (int) ResultDataReader["MagicDefence"],
            AddBlood = (int) ResultDataReader["AddBlood"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetMountTemplate", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return mountTemplateInfoList.ToArray();
    }

    public ActivitySystemItemInfo[] GetAllActivitySystemItem()
    {
      List<ActivitySystemItemInfo> activitySystemItemInfoList = new List<ActivitySystemItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ActivitySystemItem_All");
        while (ResultDataReader.Read())
          activitySystemItemInfoList.Add(new ActivitySystemItemInfo()
          {
            ID = (int) ResultDataReader["ID"],
            ActivityType = (int) ResultDataReader["ActivityType"],
            Quality = (int) ResultDataReader["Quality"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            Count = (int) ResultDataReader["Count"],
            ValidDate = (int) ResultDataReader["ValidDate"],
            IsBind = (bool) ResultDataReader["IsBind"],
            StrengthLevel = (int) ResultDataReader["StrengthLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            Probability = (int) ResultDataReader["Probability"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllActivitySystemItem), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activitySystemItemInfoList.ToArray();
    }

    public TreeTemplateInfo[] GetAllTreeTemplate()
    {
      List<TreeTemplateInfo> treeTemplateInfoList = new List<TreeTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Tree_Template_All");
        while (ResultDataReader.Read())
          treeTemplateInfoList.Add(this.InitTreeTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitTreeTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return treeTemplateInfoList.ToArray();
    }

    public TreeTemplateInfo InitTreeTemplateInfo(SqlDataReader dr)
    {
      return new TreeTemplateInfo()
      {
        Level = (int) dr["Level"],
        AwardID = (int) dr["AwardID"],
        CostExp = (int) dr["CostExp"],
        MonsterExp = (int) dr["MonsterExp"],
        MonsterID = (int) dr["MonsterID"],
        MonsterName = (string) dr["MonsterName"],
        Exp = (int) dr["Exp"]
      };
    }

    public SuitTemplateInfo[] GetAllSuitTemplate()
    {
      List<SuitTemplateInfo> suitTemplateInfoList = new List<SuitTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Suit_Template_All");
        while (ResultDataReader.Read())
          suitTemplateInfoList.Add(this.InitSuitTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitSuitTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return suitTemplateInfoList.ToArray();
    }

    public SuitTemplateInfo InitSuitTemplateInfo(SqlDataReader dr)
    {
      return new SuitTemplateInfo()
      {
        SuitId = (int) dr["SuitId"],
        SuitName = (string) dr["SuitName"],
        EqipCount1 = (int) dr["EqipCount1"],
        SkillDescribe1 = (string) dr["SkillDescribe1"],
        Skill1 = (string) dr["Skill1"],
        EqipCount2 = (int) dr["EqipCount2"],
        SkillDescribe2 = (string) dr["SkillDescribe2"],
        Skill2 = (string) dr["Skill2"],
        EqipCount3 = (int) dr["EqipCount3"],
        SkillDescribe3 = (string) dr["SkillDescribe3"],
        Skill3 = (string) dr["Skill3"],
        EqipCount4 = (int) dr["EqipCount4"],
        SkillDescribe4 = (string) dr["SkillDescribe4"],
        Skill4 = (string) dr["Skill4"],
        EqipCount5 = (int) dr["EqipCount5"],
        SkillDescribe5 = (string) dr["SkillDescribe5"],
        Skill5 = (string) dr["Skill5"]
      };
    }

    public SuitPartEquipInfo[] GetAllSuitPartEquip()
    {
      List<SuitPartEquipInfo> suitPartEquipInfoList = new List<SuitPartEquipInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Suit_Part_Equip_All");
        while (ResultDataReader.Read())
          suitPartEquipInfoList.Add(this.InitSuitPartEquipInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitSuitPartEquipInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return suitPartEquipInfoList.ToArray();
    }

    public SuitPartEquipInfo InitSuitPartEquipInfo(SqlDataReader dr)
    {
      return new SuitPartEquipInfo()
      {
        ID = (int) dr["ID"],
        ContainEquip = (string) dr["ContainEquip"],
        PartName = (string) dr["PartName"]
      };
    }

    public SearchGoodsPayMoneyInfo[] GetAllSearchGoodsPayMoney()
    {
      List<SearchGoodsPayMoneyInfo> goodsPayMoneyInfoList = new List<SearchGoodsPayMoneyInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Search_Goods_Pay_Money_All");
        while (ResultDataReader.Read())
          goodsPayMoneyInfoList.Add(this.InitSearchGoodsPayMoneyInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitSearchGoodsPayMoneyInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return goodsPayMoneyInfoList.ToArray();
    }

    public SearchGoodsPayMoneyInfo InitSearchGoodsPayMoneyInfo(SqlDataReader dr)
    {
      return new SearchGoodsPayMoneyInfo()
      {
        Number = (int) dr["Number"],
        NeedMoney = (int) dr["NeedMoney"]
      };
    }

    public RankTemplateInfo[] GetAllRankTemplate()
    {
      List<RankTemplateInfo> rankTemplateInfoList = new List<RankTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Rank_Template_All");
        while (ResultDataReader.Read())
          rankTemplateInfoList.Add(this.InitRankTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitRankTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return rankTemplateInfoList.ToArray();
    }

    public RankTemplateInfo InitRankTemplateInfo(SqlDataReader dr)
    {
      return new RankTemplateInfo()
      {
        Rank = (string) dr["Rank"],
        Attack = (int) dr["Attack"],
        Defend = (int) dr["Defend"],
        Agility = (int) dr["Agility"],
        Lucky = (int) dr["Lucky"]
      };
    }

    public PetMoePropertyInfo[] GetAllPetMoeProperty()
    {
      List<PetMoePropertyInfo> petMoePropertyInfoList = new List<PetMoePropertyInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Pet_Moe_Property_All");
        while (ResultDataReader.Read())
          petMoePropertyInfoList.Add(this.InitPetMoePropertyInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitPetMoePropertyInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return petMoePropertyInfoList.ToArray();
    }

    public PetMoePropertyInfo InitPetMoePropertyInfo(SqlDataReader dr)
    {
      return new PetMoePropertyInfo()
      {
        Level = (int) dr["Level"],
        Attack = (int) dr["Attack"],
        Lucky = (int) dr["Lucky"],
        Agility = (int) dr["Agility"],
        Blood = (int) dr["Blood"],
        Defence = (int) dr["Defence"],
        Guard = (int) dr["Guard"],
        Exp = (int) dr["Exp"]
      };
    }

    public NewTitleInfo[] GetAllNewTitle()
    {
      List<NewTitleInfo> newTitleInfoList = new List<NewTitleInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_New_Title_All");
        while (ResultDataReader.Read())
          newTitleInfoList.Add(this.InitNewTitleInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitNewTitleInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return newTitleInfoList.ToArray();
    }

    public NewTitleInfo InitNewTitleInfo(SqlDataReader dr)
    {
      return new NewTitleInfo()
      {
        ID = (int) dr["ID"],
        Show = (int) dr["Show"],
        Name = (string) dr["Name"],
        Pic = (int) dr["Pic"],
        Att = (int) dr["Att"],
        Def = (int) dr["Def"],
        Agi = (int) dr["Agi"],
        Luck = (int) dr["Luck"]
      };
    }

    public LotteryShowTemplateInfo[] GetAllLotteryShowTemplate()
    {
      List<LotteryShowTemplateInfo> showTemplateInfoList = new List<LotteryShowTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Lottery_Show_Template_All");
        while (ResultDataReader.Read())
          showTemplateInfoList.Add(this.InitLotteryShowTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitLotteryShowTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return showTemplateInfoList.ToArray();
    }

    public LotteryShowTemplateInfo InitLotteryShowTemplateInfo(SqlDataReader dr)
    {
      return new LotteryShowTemplateInfo()
      {
        BoxType = (int) dr["BoxType"],
        SortID = (int) dr["SortID"],
        TemplateID = (int) dr["TemplateID"],
        Count = (int) dr["Count"]
      };
    }

    public LoginAwardItemTemplateInfo[] GetAllLoginAwardItemTemplate()
    {
      List<LoginAwardItemTemplateInfo> itemTemplateInfoList = new List<LoginAwardItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Login_Award_Item_Template_All");
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitLoginAwardItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitLoginAwardItemTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public LoginAwardItemTemplateInfo InitLoginAwardItemTemplateInfo(SqlDataReader dr)
    {
      return new LoginAwardItemTemplateInfo()
      {
        ID = (int) dr["ID"],
        Count = (int) dr["Count"],
        RewardItemID = (int) dr["RewardItemID"],
        IsSelect = (bool) dr["IsSelect"],
        IsBind = (bool) dr["IsBind"],
        RewardItemValid = (int) dr["RewardItemValid"],
        RewardItemCount = (int) dr["RewardItemCount"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"]
      };
    }

    public MagicItemTemplateInfo[] GetAllMagicItemTemplate()
    {
      List<MagicItemTemplateInfo> itemTemplateInfoList = new List<MagicItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Magic_Item_Template_All");
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitMagicItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitMagicItemTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public MagicItemTemplateInfo InitMagicItemTemplateInfo(SqlDataReader dr)
    {
      return new MagicItemTemplateInfo()
      {
        Lv = (int) dr["Lv"],
        Exp = (int) dr["Exp"],
        MagicAttack = (int) dr["MagicAttack"],
        MagicDefence = (int) dr["MagicDefence"]
      };
    }

    public ChargeActiveTemplateInfo[] GetAllChargeActiveTemplate()
    {
      List<ChargeActiveTemplateInfo> activeTemplateInfoList = new List<ChargeActiveTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Charge_Active_Template_All");
        while (ResultDataReader.Read())
          activeTemplateInfoList.Add(this.InitChargeActiveTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitChargeActiveTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeTemplateInfoList.ToArray();
    }

    public ChargeActiveTemplateInfo InitChargeActiveTemplateInfo(SqlDataReader dr)
    {
      return new ChargeActiveTemplateInfo()
      {
        ID = (int) dr["ID"],
        Condition = (int) dr["Condition"],
        Description = (string) dr["Description"],
        RegetType = (int) dr["RegetType"],
        TypeID = (int) dr["TypeID"]
      };
    }

    public AllQuestionsInfo[] GetAllAllQuestions()
    {
      List<AllQuestionsInfo> allQuestionsInfoList = new List<AllQuestionsInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_All_Questions_All");
        while (ResultDataReader.Read())
          allQuestionsInfoList.Add(this.InitAllQuestionsInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitAllQuestionsInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return allQuestionsInfoList.ToArray();
    }

    public AllQuestionsInfo InitAllQuestionsInfo(SqlDataReader dr)
    {
      return new AllQuestionsInfo()
      {
        QuestionCatalogID = (int) dr["QuestionCatalogID"],
        QuestionID = (int) dr["QuestionID"],
        QuestionContent = (string) dr["QuestionContent"],
        Option1 = (string) dr["Option1"],
        Option2 = (string) dr["Option2"],
        Option3 = (string) dr["Option3"],
        Option4 = (string) dr["Option4"]
      };
    }

    public HelpGameRewardInfo[] GetAllHelpGameReward()
    {
      List<HelpGameRewardInfo> helpGameRewardInfoList = new List<HelpGameRewardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Help_Game_Reward_All");
        while (ResultDataReader.Read())
          helpGameRewardInfoList.Add(this.InitHelpGameRewardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitHelpGameRewardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return helpGameRewardInfoList.ToArray();
    }

    public HelpGameRewardInfo InitHelpGameRewardInfo(SqlDataReader dr)
    {
      return new HelpGameRewardInfo()
      {
        MissionID = (int) dr["MissionID"],
        Star = (int) dr["Star"],
        TemplateID = (int) dr["TemplateID"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"],
        Count = (int) dr["Count"],
        IsBind = (bool) dr["IsBind"],
        IsTime = (bool) dr["IsTime"],
        ValidDate = (int) dr["ValidDate"]
      };
    }

    public GmActiveRewardInfo[] GetAllGmActiveReward()
    {
      List<GmActiveRewardInfo> activeRewardInfoList = new List<GmActiveRewardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GM_Active_Reward_All");
        while (ResultDataReader.Read())
          activeRewardInfoList.Add(this.InitGmActiveRewardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitGmActiveRewardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeRewardInfoList.ToArray();
    }

    public GmActiveRewardInfo InitGmActiveRewardInfo(SqlDataReader dr)
    {
      return new GmActiveRewardInfo()
      {
        giftId = (string) dr["giftId"],
        templateId = (int) dr["templateId"],
        count = (int) dr["count"],
        isBind = (int) dr["isBind"],
        occupationOrSex = (int) dr["occupationOrSex"],
        rewardType = (int) dr["rewardType"],
        validDate = (int) dr["validDate"],
        property = (string) dr["property"],
        remain1 = (string) dr["remain1"]
      };
    }

    public GmActiveConditionInfo[] GetAllGmActiveCondition()
    {
      List<GmActiveConditionInfo> activeConditionInfoList = new List<GmActiveConditionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GM_Active_Condition_All");
        while (ResultDataReader.Read())
          activeConditionInfoList.Add(this.InitGmActiveConditionInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitGmActiveConditionInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeConditionInfoList.ToArray();
    }

    public GmActiveConditionInfo InitGmActiveConditionInfo(SqlDataReader dr)
    {
      return new GmActiveConditionInfo()
      {
        giftbagId = (string) dr["giftbagId"],
        conditionIndex = (int) dr["conditionIndex"],
        conditionValue = (int) dr["conditionValue"],
        remain1 = (int) dr["remain1"],
        remain2 = (string) dr["remain2"]
      };
    }

    public GmGiftInfo[] GetAllGmGift()
    {
      List<GmGiftInfo> gmGiftInfoList = new List<GmGiftInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GM_Gift_All");
        while (ResultDataReader.Read())
          gmGiftInfoList.Add(this.InitGmGiftInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitGmGiftInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return gmGiftInfoList.ToArray();
    }

    public GmGiftInfo InitGmGiftInfo(SqlDataReader dr)
    {
      return new GmGiftInfo()
      {
        giftbagId = (string) dr["giftbagId"],
        activityId = (string) dr["activityId"],
        rewardMark = (int) dr["rewardMark"],
        giftbagOrder = (int) dr["giftbagOrder"]
      };
    }

    public GmActivityInfo[] GetAllGmActivity()
    {
      List<GmActivityInfo> gmActivityInfoList = new List<GmActivityInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GM_Activity_All");
        while (ResultDataReader.Read())
          gmActivityInfoList.Add(this.InitGmActivityInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitGmActivityInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return gmActivityInfoList.ToArray();
    }

    public GmActivityInfo InitGmActivityInfo(SqlDataReader dr)
    {
      return new GmActivityInfo()
      {
        activityId = (string) dr["activityId"],
        activityName = (string) dr["activityName"],
        activityType = (string) dr["activityType"],
        activityChildType = (int) dr["activityChildType"],
        getWay = (int) dr["getWay"],
        desc = (string) dr["desc"],
        rewardDesc = (string) dr["rewardDesc"],
        beginTime = (DateTime) dr["beginTime"],
        beginShowTime = (DateTime) dr["beginShowTime"],
        endTime = (DateTime) dr["endTime"],
        endShowTime = (DateTime) dr["endShowTime"],
        icon = (int) dr["icon"],
        isContinue = (int) dr["isContinue"],
        status = (int) dr["status"],
        remain1 = (int) dr["remain1"],
        remain2 = (int) dr["remain2"]
      };
    }

    public FightLabDropItemInfo[] GetAllFightLabDropItem()
    {
      List<FightLabDropItemInfo> fightLabDropItemInfoList = new List<FightLabDropItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Fight_Lab_Drop_Item_All");
        while (ResultDataReader.Read())
          fightLabDropItemInfoList.Add(this.InitFightLabDropItemInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitFightLabDropItemInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return fightLabDropItemInfoList.ToArray();
    }

    public FightLabDropItemInfo InitFightLabDropItemInfo(SqlDataReader dr)
    {
      return new FightLabDropItemInfo()
      {
        ID = (int) dr["ID"],
        Easy = (int) dr["Easy"],
        AwardItem = (int) dr["AwardItem"],
        Count = (int) dr["Count"]
      };
    }

    public EveryDayActiveRewardTemplateInfo[] GetAllEveryDayActiveRewardTemplate()
    {
      List<EveryDayActiveRewardTemplateInfo> rewardTemplateInfoList = new List<EveryDayActiveRewardTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Every_Day_Active_Reward_Template_All");
        while (ResultDataReader.Read())
          rewardTemplateInfoList.Add(this.InitEveryDayActiveRewardTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitEveryDayActiveRewardTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return rewardTemplateInfoList.ToArray();
    }

    public EveryDayActiveRewardTemplateInfo InitEveryDayActiveRewardTemplateInfo(SqlDataReader dr)
    {
      return new EveryDayActiveRewardTemplateInfo()
      {
        ID = (int) dr["ID"],
        RewardID = (int) dr["RewardID"],
        RewardItemID = (string) dr["RewardItemID"],
        IsSelect = (bool) dr["IsSelect"],
        RewardItemValid = (int) dr["RewardItemValid"],
        RewardItemCount = (int) dr["RewardItemCount"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"],
        IsBind = (bool) dr["IsBind"]
      };
    }

    public EveryDayActiveProgressInfo[] GetAllEveryDayActiveProgress()
    {
      List<EveryDayActiveProgressInfo> activeProgressInfoList = new List<EveryDayActiveProgressInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Every_Day_Active_Progress_All");
        while (ResultDataReader.Read())
          activeProgressInfoList.Add(this.InitEveryDayActiveProgressInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitEveryDayActiveProgressInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activeProgressInfoList.ToArray();
    }

    public EveryDayActiveProgressInfo InitEveryDayActiveProgressInfo(SqlDataReader dr)
    {
      return new EveryDayActiveProgressInfo()
      {
        ID = (int) dr["ID"],
        ActiveName = (string) dr["ActiveName"],
        ActiveTime = (string) dr["ActiveTime"],
        Count = (string) dr["Count"],
        Description = (string) dr["Description"],
        JumpType = (int) dr["JumpType"],
        LevelLimit = (int) dr["LevelLimit"],
        DayOfWeek = (string) dr["DayOfWeek"]
      };
    }

    public EveryDayActivePointTemplateInfo[] GetAllEveryDayActivePointTemplate()
    {
      List<EveryDayActivePointTemplateInfo> pointTemplateInfoList = new List<EveryDayActivePointTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Every_Day_Active_Point_Template_All");
        while (ResultDataReader.Read())
          pointTemplateInfoList.Add(this.InitEveryDayActivePointTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitEveryDayActivePointTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return pointTemplateInfoList.ToArray();
    }

    public EveryDayActivePointTemplateInfo InitEveryDayActivePointTemplateInfo(SqlDataReader dr)
    {
      return new EveryDayActivePointTemplateInfo()
      {
        ID = (int) dr["ID"],
        MinLevel = (int) dr["MinLevel"],
        MaxLevel = (int) dr["MaxLevel"],
        ActivityType = (int) dr["ActivityType"],
        JumpType = (int) dr["JumpType"],
        Description = (string) dr["Description"],
        Count = (int) dr["Count"],
        ActivePoint = (int) dr["ActivePoint"],
        MoneyPoint = (int) dr["MoneyPoint"]
      };
    }

    public DiceGameAwardInfo[] GetAllDiceGameAward()
    {
      List<DiceGameAwardInfo> diceGameAwardInfoList = new List<DiceGameAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Dice_Game_Award_All");
        while (ResultDataReader.Read())
          diceGameAwardInfoList.Add(this.InitDiceGameAwardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitDiceGameAwardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return diceGameAwardInfoList.ToArray();
    }

    public DiceGameAwardInfo InitDiceGameAwardInfo(SqlDataReader dr)
    {
      return new DiceGameAwardInfo()
      {
        rank = (int) dr["rank"],
        template = (int) dr["template"],
        count = (int) dr["count"]
      };
    }

    public DailyLeagueAwardInfo[] GetAllDailyLeagueAward()
    {
      List<DailyLeagueAwardInfo> dailyLeagueAwardInfoList = new List<DailyLeagueAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Daily_League_Award_All");
        while (ResultDataReader.Read())
          dailyLeagueAwardInfoList.Add(this.InitDailyLeagueAwardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitDailyLeagueAwardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return dailyLeagueAwardInfoList.ToArray();
    }

    public DailyLeagueAwardInfo InitDailyLeagueAwardInfo(SqlDataReader dr)
    {
      return new DailyLeagueAwardInfo()
      {
        Level = (int) dr["Level"],
        Class = (int) dr["Class"],
        Count = (int) dr["Count"],
        TemplateID = (int) dr["TemplateID"],
        RewardID = (int) dr["RewardID"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        ItemValid = (int) dr["ItemValid"],
        IsBind = (bool) dr["IsBind"],
        AgilityCompose = (int) dr["AgilityCompose"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        LuckCompose = (int) dr["LuckCompose"],
        Hole1 = (int) dr["Hole1"],
        Hole2 = (int) dr["Hole2"],
        Hole3 = (int) dr["Hole3"],
        Hole4 = (int) dr["Hole4"],
        Hole5 = (int) dr["Hole5"],
        Hole5Exp = (int) dr["Hole5Exp"],
        Int32_0 = (int) dr["Hole5Level"],
        Hole6 = (int) dr["Hole6"],
        Hole6Exp = (int) dr["Hole6Exp"],
        Int32_1 = (int) dr["Hole6Level"]
      };
    }

    public CommunalActiveInfo[] GetAllCommunalActive()
    {
      List<CommunalActiveInfo> communalActiveInfoList = new List<CommunalActiveInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_CommunalActive_All");
        while (ResultDataReader.Read())
          communalActiveInfoList.Add(new CommunalActiveInfo()
          {
            ActiveID = (int) ResultDataReader["ActiveID"],
            BeginTime = (DateTime) ResultDataReader["BeginTime"],
            EndTime = (DateTime) ResultDataReader["EndTime"],
            LimitGrade = (int) ResultDataReader["LimitGrade"],
            DayMaxScore = (int) ResultDataReader["DayMaxScore"],
            MinScore = (int) ResultDataReader["MinScore"],
            AddPropertyByMoney = (string) ResultDataReader["AddPropertyByMoney"],
            AddPropertyByProp = (string) ResultDataReader["AddPropertyByProp"],
            IsReset = (bool) ResultDataReader["IsReset"],
            IsSendAward = (bool) ResultDataReader["IsSendAward"],
            IsOpen = (bool) ResultDataReader["IsOpen"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllCommunalActive), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return communalActiveInfoList.ToArray();
    }

    public CommunalActiveAwardInfo[] GetAllCommunalActiveAward()
    {
      List<CommunalActiveAwardInfo> communalActiveAwardInfoList = new List<CommunalActiveAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_CommunalActiveAward_All");
        while (ResultDataReader.Read())
          communalActiveAwardInfoList.Add(new CommunalActiveAwardInfo()
          {
            ID = (int) ResultDataReader["ID"],
            ActiveID = (int) ResultDataReader["ActiveID"],
            IsArea = (int) ResultDataReader["IsArea"],
            RandID = (int) ResultDataReader["RandID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            Count = (int) ResultDataReader["Count"],
            IsBind = (bool) ResultDataReader["IsBind"],
            IsTime = (bool) ResultDataReader["IsTime"],
            ValidDate = (int) ResultDataReader["ValidDate"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllCommunalActiveAward), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return communalActiveAwardInfoList.ToArray();
    }

    public CommunalActiveExpInfo[] GetAllCommunalActiveExp()
    {
      List<CommunalActiveExpInfo> communalActiveExpInfoList = new List<CommunalActiveExpInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_CommunalActiveExp_All");
        while (ResultDataReader.Read())
          communalActiveExpInfoList.Add(new CommunalActiveExpInfo()
          {
            ActiveID = (int) ResultDataReader["ActiveID"],
            Grade = (int) ResultDataReader["Grade"],
            Exp = (int) ResultDataReader["Exp"],
            AddExpPlus = (int) ResultDataReader["AddExpPlus"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllCommunalActiveExp), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return communalActiveExpInfoList.ToArray();
    }

    public ChargeSpendRewardTemplateInfo[] GetAllChargeSpendRewardTemplate()
    {
      List<ChargeSpendRewardTemplateInfo> rewardTemplateInfoList = new List<ChargeSpendRewardTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Charge_Spend_Reward_Template_All");
        while (ResultDataReader.Read())
          rewardTemplateInfoList.Add(this.InitChargeSpendRewardTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitChargeSpendRewardTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return rewardTemplateInfoList.ToArray();
    }

    public ChargeSpendRewardTemplateInfo InitChargeSpendRewardTemplateInfo(SqlDataReader dr)
    {
      return new ChargeSpendRewardTemplateInfo()
      {
        ID = (int) dr["ID"],
        RewardID = (int) dr["RewardID"],
        RewardItemID = (int) dr["RewardItemID"],
        IsSelect = (bool) dr["IsSelect"],
        IsBind = (bool) dr["IsBind"],
        RewardItemValid = (int) dr["RewardItemValid"],
        RewardItemCount = (int) dr["RewardItemCount"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        AttackCompose = (int) dr["AttackCompose"],
        DefendCompose = (int) dr["DefendCompose"],
        AgilityCompose = (int) dr["AgilityCompose"],
        LuckCompose = (int) dr["LuckCompose"]
      };
    }

    public CardBuffInfo[] GetAllCardBuff()
    {
      List<CardBuffInfo> cardBuffInfoList = new List<CardBuffInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Card_Buff_All");
        while (ResultDataReader.Read())
          cardBuffInfoList.Add(this.InitCardBuffInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitCardBuffInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return cardBuffInfoList.ToArray();
    }

    public CardBuffInfo InitCardBuffInfo(SqlDataReader dr)
    {
      return new CardBuffInfo()
      {
        condition = (int) dr["condition"],
        PropertiesDscripID = (int) dr["PropertiesDscripID"],
        value = (string) dr["value"],
        Description = (string) dr["Description"]
      };
    }

    public CardInfo[] GetAllCard()
    {
      List<CardInfo> cardInfoList = new List<CardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Card_Info_All");
        while (ResultDataReader.Read())
          cardInfoList.Add(this.InitCardInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitCardInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return cardInfoList.ToArray();
    }

    public CardInfo InitCardInfo(SqlDataReader dr)
    {
      return new CardInfo()
      {
        ID = (int) dr["ID"],
        SuitID = (int) dr["SuitID"],
        Name = (string) dr["Name"],
        Description = (string) dr["Description"]
      };
    }

    public CardGrooveUpdateInfo[] GetAllCardGrooveUpdate()
    {
      List<CardGrooveUpdateInfo> grooveUpdateInfoList = new List<CardGrooveUpdateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_CardGrooveUpdate_All");
        while (ResultDataReader.Read())
          grooveUpdateInfoList.Add(this.InitCardGrooveUpdate(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllCardGrooveUpdate), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return grooveUpdateInfoList.ToArray();
    }

    public CardGrooveUpdateInfo InitCardGrooveUpdate(SqlDataReader reader)
    {
      return new CardGrooveUpdateInfo()
      {
        ID = (int) reader["ID"],
        Attack = (int) reader["Attack"],
        Defend = (int) reader["Defend"],
        Agility = (int) reader["Agility"],
        Lucky = (int) reader["Lucky"],
        Damage = (int) reader["Damage"],
        Guard = (int) reader["Guard"],
        Level = (int) reader["Level"],
        Type = (int) reader["Type"],
        Exp = (int) reader["Exp"]
      };
    }

    public CardTemplateInfo[] GetAllCardTemplate()
    {
      List<CardTemplateInfo> cardTemplateInfoList = new List<CardTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_CardTemplate_All");
        while (ResultDataReader.Read())
          cardTemplateInfoList.Add(this.InitCardTemplate(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllCardTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return cardTemplateInfoList.ToArray();
    }

    public CardTemplateInfo InitCardTemplate(SqlDataReader reader)
    {
      return new CardTemplateInfo()
      {
        ID = (int) reader["ID"],
        CardID = (int) reader["CardID"],
        CardType = (int) reader["CardType"],
        probability = (int) reader["probability"],
        AttackRate = (int) reader["AttackRate"],
        AddAttack = (int) reader["AddAttack"],
        DefendRate = (int) reader["DefendRate"],
        AddDefend = (int) reader["AddDefend"],
        AgilityRate = (int) reader["AgilityRate"],
        AddAgility = (int) reader["AddAgility"],
        LuckyRate = (int) reader["LuckyRate"],
        AddLucky = (int) reader["AddLucky"],
        DamageRate = (int) reader["DamageRate"],
        AddDamage = (int) reader["AddDamage"],
        GuardRate = (int) reader["GuardRate"],
        AddGuard = (int) reader["AddGuard"]
      };
    }

    public ItemStrengThenDataInfo[] GetAllItemStrengThenData()
    {
      List<ItemStrengThenDataInfo> strengThenDataInfoList = new List<ItemStrengThenDataInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_Streng_Then_Data_All");
        while (ResultDataReader.Read())
          strengThenDataInfoList.Add(this.InitItemStrengThenDataInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitItemStrengThenDataInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return strengThenDataInfoList.ToArray();
    }

    public ItemStrengThenDataInfo InitItemStrengThenDataInfo(SqlDataReader dr)
    {
      return new ItemStrengThenDataInfo()
      {
        TemplateID = (int) dr["TemplateID"],
        StrengthenLevel = (int) dr["StrengthenLevel"],
        Data = (int) dr["Data"]
      };
    }

    public DiceLevelAwardInfo[] GetDiceLevelAwardInfos()
    {
      List<DiceLevelAwardInfo> diceLevelAwardInfoList = new List<DiceLevelAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_DiceLevelAward_All");
        while (ResultDataReader.Read())
          diceLevelAwardInfoList.Add(new DiceLevelAwardInfo()
          {
            ID = (int) ResultDataReader["ID"],
            DiceLevel = (int) ResultDataReader["DiceLevel"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            Count = (int) ResultDataReader["Count"],
            ValidDate = (int) ResultDataReader["ValidDate"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            Random = (int) ResultDataReader["Random"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllDiceLevelAward", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return diceLevelAwardInfoList.ToArray();
    }

    public ClothPropertyTemplateInfo[] GetAllClothPropertyTemplateInfos()
    {
      List<ClothPropertyTemplateInfo> propertyTemplateInfoList = new List<ClothPropertyTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ClothPropertyTemplate_All");
        while (ResultDataReader.Read())
          propertyTemplateInfoList.Add(new ClothPropertyTemplateInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Sex = (int) ResultDataReader["Sex"],
            Name = ResultDataReader["Name"] == null ? "" : ResultDataReader["Name"].ToString(),
            Attack = (int) ResultDataReader["Attack"],
            Defend = (int) ResultDataReader["Defend"],
            Agility = (int) ResultDataReader["Agility"],
            Luck = (int) ResultDataReader["Luck"],
            Blood = (int) ResultDataReader["Blood"],
            Damage = (int) ResultDataReader["Damage"],
            Guard = (int) ResultDataReader["Guard"],
            Cost = (int) ResultDataReader["Cost"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllClothPropertyTemplateInfos), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return propertyTemplateInfoList.ToArray();
    }

    public ClothGroupTemplateInfo[] GetAllClothGroupTemplateInfos()
    {
      List<ClothGroupTemplateInfo> groupTemplateInfoList = new List<ClothGroupTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ClothGroupTemplate_All");
        while (ResultDataReader.Read())
          groupTemplateInfoList.Add(new ClothGroupTemplateInfo()
          {
            ID = (int) ResultDataReader["ID"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            Sex = (int) ResultDataReader["Sex"],
            Description = (int) ResultDataReader["Description"],
            Cost = (int) ResultDataReader["Cost"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllClothGroupTemplateInfos), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return groupTemplateInfoList.ToArray();
    }

    public void addClothDb(int groupId, int template, int sex)
    {
      this.db.RunProcedure("AddCloath", new SqlParameter[3]
      {
        new SqlParameter("@ID", (object) groupId),
        new SqlParameter("@templateId", (object) template),
        new SqlParameter("@sex", (object) sex)
      });
    }

    public EventAwardInfo[] GetEventAwardInfos()
    {
      List<EventAwardInfo> eventAwardInfoList = new List<EventAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_EventAwardItem_All");
        while (ResultDataReader.Read())
          eventAwardInfoList.Add(new EventAwardInfo()
          {
            ID = (int) ResultDataReader["ID"],
            ActivityType = (int) ResultDataReader["ActivityType"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            Count = (int) ResultDataReader["Count"],
            ValidDate = (int) ResultDataReader["ValidDate"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"],
            Random = (int) ResultDataReader["Random"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllEventAward", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return eventAwardInfoList.ToArray();
    }

    public LoadUserBoxInfo[] GetAllTimeBoxAward()
    {
      List<LoadUserBoxInfo> loadUserBoxInfoList = new List<LoadUserBoxInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_TimeBox_Award_All");
        while (ResultDataReader.Read())
          loadUserBoxInfoList.Add(new LoadUserBoxInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Type = (int) ResultDataReader["Type"],
            Level = (int) ResultDataReader["Level"],
            Condition = (int) ResultDataReader["Condition"],
            TemplateID = (int) ResultDataReader["TemplateID"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllDaily", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return loadUserBoxInfoList.ToArray();
    }

    public GClass1[] GetAllQQtipsMessagesLoad()
    {
      List<GClass1> gclass1List = new List<GClass1>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_QQtipsMessages_All");
        while (ResultDataReader.Read())
          gclass1List.Add(this.InitQQtipsMessagesLoad(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllQQtipsMessagesLoad), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return gclass1List.ToArray();
    }

    public GClass1 InitQQtipsMessagesLoad(SqlDataReader reader)
    {
      return new GClass1()
      {
        ID = (int) reader["ID"],
        title = reader["title"] == null ? "QQTips" : reader["title"].ToString(),
        content = reader["content"] == null ? "Thông báo, gợi ý hệ thống" : reader["content"].ToString(),
        maxLevel = (int) reader["maxLevel"],
        minLevel = (int) reader["minLevel"],
        outInType = (int) reader["outInType"],
        moduleType = (int) reader["moduleType"],
        inItemID = (int) reader["inItemID"],
        url = reader["url"] == null ? "http://gunny.zing.vn" : reader["url"].ToString()
      };
    }

    public MagicStoneInfo[] GetAllMagicStoneTemplate()
    {
      List<MagicStoneInfo> magicStoneInfoList = new List<MagicStoneInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MagicStone_All");
        while (ResultDataReader.Read())
          magicStoneInfoList.Add(this.InitMagicStoneTemplate(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Get All MagicStone", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return magicStoneInfoList.ToArray();
    }

    public MagicStoneInfo InitMagicStoneTemplate(SqlDataReader reader)
    {
      return new MagicStoneInfo()
      {
        ID = (int) reader["ID"],
        TemplateID = (int) reader["TemplateID"],
        Level = (int) reader["Level"],
        Exp = (int) reader["Exp"],
        Attack = (int) reader["Attack"],
        Defence = (int) reader["Defence"],
        Agility = (int) reader["Agility"],
        Luck = (int) reader["Luck"],
        MagicAttack = (int) reader["MagicAttack"],
        MagicDefence = (int) reader["MagicDefence"]
      };
    }

    public GoldEquipTemplateInfo[] GetAllGoldEquipTemplateLoad()
    {
      List<GoldEquipTemplateInfo> equipTemplateInfoList = new List<GoldEquipTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_GoldEquipTemplateLoad_All");
        while (ResultDataReader.Read())
          equipTemplateInfoList.Add(this.InitGoldEquipTemplateLoad(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllGoldEquipTemplateLoad), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return equipTemplateInfoList.ToArray();
    }

    public GoldEquipTemplateInfo InitGoldEquipTemplateLoad(SqlDataReader reader)
    {
      return new GoldEquipTemplateInfo()
      {
        ID = (int) reader["ID"],
        OldTemplateId = (int) reader["OldTemplateId"],
        NewTemplateId = (int) reader["NewTemplateId"],
        CategoryID = (int) reader["CategoryID"],
        Strengthen = (int) reader["Strengthen"],
        Attack = (int) reader["Attack"],
        Defence = (int) reader["Defence"],
        Agility = (int) reader["Agility"],
        Luck = (int) reader["Luck"],
        Damage = (int) reader["Damage"],
        Guard = (int) reader["Guard"],
        Boold = (int) reader["Boold"],
        BlessID = (int) reader["BlessID"],
        Pic = reader["pic"] == null ? "" : reader["pic"].ToString()
      };
    }

    public AchievementInfo[] GetALlAchievement()
    {
      List<AchievementInfo> achievementInfoList = new List<AchievementInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Achievement_All");
        while (ResultDataReader.Read())
          achievementInfoList.Add(this.InitAchievement(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetALlAchievement:", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return achievementInfoList.ToArray();
    }

    public AchievementConditionInfo[] GetALlAchievementCondition()
    {
      List<AchievementConditionInfo> achievementConditionInfoList = new List<AchievementConditionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Achievement_Condition_All");
        while (ResultDataReader.Read())
          achievementConditionInfoList.Add(this.InitAchievementCondition(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetALlAchievementCondition:", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return achievementConditionInfoList.ToArray();
    }

    public AchievementRewardInfo[] GetALlAchievementReward()
    {
      List<AchievementRewardInfo> achievementRewardInfoList = new List<AchievementRewardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Achievement_Reward_All");
        while (ResultDataReader.Read())
          achievementRewardInfoList.Add(this.InitAchievementReward(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetALlAchievementReward), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return achievementRewardInfoList.ToArray();
    }

    public List<BigBugleInfo> GetAllAreaBigBugleRecord()
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      List<BigBugleInfo> areaBigBugleRecord = new List<BigBugleInfo>();
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Get_AreaBigBugle_Record");
        while (ResultDataReader.Read())
        {
          BigBugleInfo bigBugleInfo = new BigBugleInfo()
          {
            ID = (int) ResultDataReader["ID"],
            UserID = (int) ResultDataReader["UserID"],
            AreaID = (int) ResultDataReader["AreaID"],
            NickName = ResultDataReader["NickName"] == null ? "" : ResultDataReader["NickName"].ToString(),
            Message = ResultDataReader["Message"] == null ? "" : ResultDataReader["Message"].ToString(),
            State = (bool) ResultDataReader["State"],
            IP = ResultDataReader["IP"] == null ? "" : ResultDataReader["IP"].ToString()
          };
          areaBigBugleRecord.Add(bigBugleInfo);
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllAreaBigBugleRecord), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return areaBigBugleRecord;
    }

    public AchievementInfo InitAchievement(SqlDataReader reader)
    {
      return new AchievementInfo()
      {
        ID = (int) reader["ID"],
        PlaceID = (int) reader["PlaceID"],
        Title = reader["Title"] == null ? "" : reader["Title"].ToString(),
        Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString(),
        NeedMinLevel = (int) reader["NeedMinLevel"],
        NeedMaxLevel = (int) reader["NeedMaxLevel"],
        PreAchievementID = reader["PreAchievementID"] == null ? "" : reader["PreAchievementID"].ToString(),
        IsOther = (int) reader["IsOther"],
        AchievementType = (int) reader["AchievementType"],
        CanHide = (bool) reader["CanHide"],
        StartDate = (DateTime) reader["StartDate"],
        EndDate = (DateTime) reader["EndDate"],
        AchievementPoint = (int) reader["AchievementPoint"],
        IsActive = (int) reader["IsActive"],
        PicID = (int) reader["PicID"],
        IsShare = (bool) reader["IsShare"]
      };
    }

    public AchievementConditionInfo InitAchievementCondition(SqlDataReader reader)
    {
      return new AchievementConditionInfo()
      {
        AchievementID = (int) reader["AchievementID"],
        CondictionID = (int) reader["CondictionID"],
        CondictionType = (int) reader["CondictionType"],
        Condiction_Para1 = reader["Condiction_Para1"] == null ? "" : reader["Condiction_Para1"].ToString(),
        Condiction_Para2 = (int) reader["Condiction_Para2"]
      };
    }

    public AchievementRewardInfo InitAchievementReward(SqlDataReader reader)
    {
      return new AchievementRewardInfo()
      {
        AchievementID = (int) reader["AchievementID"],
        RewardType = (int) reader["RewardType"],
        RewardPara = reader["RewardPara"] == null ? "" : reader["RewardPara"].ToString(),
        RewardValueId = (int) reader["RewardValueId"],
        RewardCount = (int) reader["RewardCount"]
      };
    }

    public ItemRecordTypeInfo[] GetAllItemRecordType()
    {
      List<ItemRecordTypeInfo> itemRecordTypeInfoList = new List<ItemRecordTypeInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_Record_Type_All");
        while (ResultDataReader.Read())
          itemRecordTypeInfoList.Add(this.InitItemRecordType(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllItemRecordType:", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemRecordTypeInfoList.ToArray();
    }

    public ItemRecordTypeInfo InitItemRecordType(SqlDataReader reader)
    {
      return new ItemRecordTypeInfo()
      {
        RecordID = (int) reader["RecordID"],
        Name = reader["Name"] == null ? "" : reader["Name"].ToString(),
        Description = reader["Description"] == null ? "" : reader["Description"].ToString()
      };
    }

    public ItemTemplateInfo[] GetAllGoodsASC()
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Items_All_ASC");
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public ItemTemplateInfo[] GetAllGoods()
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Items_All");
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public ShopGoodsShowListInfo InitShopGoodsShowListInfo(SqlDataReader reader)
    {
      return new ShopGoodsShowListInfo()
      {
        Type = (int) reader["Type"],
        ShopId = (int) reader["ShopId"]
      };
    }

    public ShopGoodsShowListInfo[] GetAllShopGoodsShowList()
    {
      List<ShopGoodsShowListInfo> goodsShowListInfoList = new List<ShopGoodsShowListInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ShopGoodsShowList_All");
        while (ResultDataReader.Read())
          goodsShowListInfoList.Add(this.InitShopGoodsShowListInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return goodsShowListInfoList.ToArray();
    }

    public ItemBoxInfo[] GetSingleItemsBox(int DataID)
    {
      List<ItemBoxInfo> itemBoxInfoList = new List<ItemBoxInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) DataID;
        this.db.GetReader(ref ResultDataReader, "SP_ItemsBox_Single", SqlParameters);
        while (ResultDataReader.Read())
          itemBoxInfoList.Add(this.InitItemBoxInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemBoxInfoList.ToArray();
    }

    public ItemTemplateInfo GetSingleGoods(int goodsID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@ID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) goodsID;
        this.db.GetReader(ref ResultDataReader, "SP_Items_Single", SqlParameters);
        if (ResultDataReader.Read())
          return this.InitItemTemplateInfo(ResultDataReader);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (ItemTemplateInfo) null;
    }

    public ItemTemplateInfo[] GetSingleCategory(int CategoryID)
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@CategoryID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) CategoryID;
        this.db.GetReader(ref ResultDataReader, "SP_Items_Category_Single", SqlParameters);
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public ItemTemplateInfo[] GetFusionType()
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Items_FusionType");
        while (ResultDataReader.Read())
          itemTemplateInfoList.Add(this.InitItemTemplateInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemTemplateInfoList.ToArray();
    }

    public ItemTemplateInfo InitItemTemplateInfo(SqlDataReader reader)
    {
      ItemTemplateInfo itemTemplateInfo = new ItemTemplateInfo();
      itemTemplateInfo.AddTime = reader["AddTime"].ToString();
      itemTemplateInfo.Agility = (int) reader["Agility"];
      itemTemplateInfo.Attack = (int) reader["Attack"];
      itemTemplateInfo.CanDelete = (bool) reader["CanDelete"];
      itemTemplateInfo.CanDrop = (bool) reader["CanDrop"];
      itemTemplateInfo.CanEquip = (bool) reader["CanEquip"];
      itemTemplateInfo.CanUse = (bool) reader["CanUse"];
      itemTemplateInfo.CategoryID = (int) reader["CategoryID"];
      itemTemplateInfo.Colors = reader["Colors"].ToString();
      itemTemplateInfo.Defence = (int) reader["Defence"];
      itemTemplateInfo.Description = reader["Description"].ToString();
      itemTemplateInfo.Level = (int) reader["Level"];
      itemTemplateInfo.Luck = (int) reader["Luck"];
      itemTemplateInfo.MaxCount = (int) reader["MaxCount"];
      itemTemplateInfo.Name = reader["Name"].ToString();
      itemTemplateInfo.NeedSex = (int) reader["NeedSex"];
      itemTemplateInfo.Pic = reader["Pic"].ToString();
      itemTemplateInfo.Data = reader["Data"] == null ? "" : reader["Data"].ToString();
      itemTemplateInfo.Property1 = (int) reader["Property1"];
      itemTemplateInfo.Property2 = (int) reader["Property2"];
      itemTemplateInfo.Property3 = (int) reader["Property3"];
      itemTemplateInfo.Property4 = (int) reader["Property4"];
      itemTemplateInfo.Property5 = (int) reader["Property5"];
      itemTemplateInfo.Property6 = (int) reader["Property6"];
      itemTemplateInfo.Property7 = (int) reader["Property7"];
      itemTemplateInfo.Property8 = (int) reader["Property8"];
      itemTemplateInfo.Quality = (int) reader["Quality"];
      itemTemplateInfo.Script = reader["Script"].ToString();
      itemTemplateInfo.TemplateID = (int) reader["TemplateID"];
      itemTemplateInfo.CanCompose = (bool) reader["CanCompose"];
      itemTemplateInfo.CanStrengthen = (bool) reader["CanStrengthen"];
      itemTemplateInfo.NeedLevel = (int) reader["NeedLevel"];
      itemTemplateInfo.BindType = (int) reader["BindType"];
      itemTemplateInfo.FusionType = (int) reader["FusionType"];
      itemTemplateInfo.FusionRate = (int) reader["FusionRate"];
      itemTemplateInfo.FusionNeedRate = (int) reader["FusionNeedRate"];
      itemTemplateInfo.Hole = reader["Hole"] == null ? "" : reader["Hole"].ToString();
      itemTemplateInfo.RefineryLevel = (int) reader["RefineryLevel"];
      itemTemplateInfo.ReclaimValue = (int) reader["ReclaimValue"];
      itemTemplateInfo.ReclaimType = (int) reader["ReclaimType"];
      itemTemplateInfo.CanRecycle = (int) reader["CanRecycle"];
      itemTemplateInfo.SuitId = (int) reader["SuitId"];
      itemTemplateInfo.FloorPrice = (int) reader["FloorPrice"];
      itemTemplateInfo.CanTransfer = (int) reader["CanTransfer"];
      itemTemplateInfo.IsDirty = false;
      return itemTemplateInfo;
    }

    public AccumulAtiveLoginAwardInfo[] GetAccumulAtiveLoginAwardInfos()
    {
      List<AccumulAtiveLoginAwardInfo> ativeLoginAwardInfoList = new List<AccumulAtiveLoginAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_AccumulAtiveLoginAward_All");
        while (ResultDataReader.Read())
          ativeLoginAwardInfoList.Add(new AccumulAtiveLoginAwardInfo()
          {
            ID = (int) ResultDataReader["ID"],
            RewardItemID = (int) ResultDataReader["RewardItemID"],
            Count = (int) ResultDataReader["Count"],
            IsSelect = (bool) ResultDataReader["IsSelect"],
            IsBind = (bool) ResultDataReader["IsBind"],
            RewardItemValid = (int) ResultDataReader["RewardItemValid"],
            RewardItemCount = (int) ResultDataReader["RewardItemCount"],
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            AttackCompose = (int) ResultDataReader["AttackCompose"],
            DefendCompose = (int) ResultDataReader["DefendCompose"],
            AgilityCompose = (int) ResultDataReader["AgilityCompose"],
            LuckCompose = (int) ResultDataReader["LuckCompose"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) ("Accumul_Ative_Login_Award：" + (object) ex));
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return ativeLoginAwardInfoList.ToArray();
    }

    public ItemBoxInfo[] GetItemBoxInfos()
    {
      List<ItemBoxInfo> itemBoxInfoList = new List<ItemBoxInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_ItemsBox_All");
        while (ResultDataReader.Read())
          itemBoxInfoList.Add(this.InitItemBoxInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) ("Init@Shop_Goods_Box：" + (object) ex));
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return itemBoxInfoList.ToArray();
    }

    public ItemBoxInfo InitItemBoxInfo(SqlDataReader reader)
    {
      return new ItemBoxInfo()
      {
        ID = (int) reader["ID"],
        TemplateId = (int) reader["TemplateId"],
        IsSelect = (bool) reader["IsSelect"],
        IsBind = (bool) reader["IsBind"],
        ItemValid = (int) reader["ItemValid"],
        ItemCount = (int) reader["ItemCount"],
        StrengthenLevel = (int) reader["StrengthenLevel"],
        AttackCompose = (int) reader["AttackCompose"],
        DefendCompose = (int) reader["DefendCompose"],
        AgilityCompose = (int) reader["AgilityCompose"],
        LuckCompose = (int) reader["LuckCompose"],
        Random = (int) reader["Random"],
        IsTips = (int) reader["IsTips"],
        IsLogs = (bool) reader["IsLogs"]
      };
    }

    public bool UpdatePlayerInfoHistory(PlayerInfoHistory info)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[4]
        {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@LastQuestsTime", (object) info.LastQuestsTime),
          new SqlParameter("@LastTreasureTime", (object) info.LastTreasureTime),
          new SqlParameter("@OutPut", SqlDbType.Int)
        };
        SqlParameters[3].Direction = ParameterDirection.Output;
        this.db.RunProcedure("SP_User_Update_History", SqlParameters);
        flag = (int) SqlParameters[6].Value == 1;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "User_Update_BoxProgression", ex);
      }
      return flag;
    }

    public CategoryInfo[] GetAllCategory()
    {
      List<CategoryInfo> categoryInfoList = new List<CategoryInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Items_Category_All");
        while (ResultDataReader.Read())
          categoryInfoList.Add(new CategoryInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"] == null ? "" : ResultDataReader["Name"].ToString(),
            Place = (int) ResultDataReader["Place"],
            Remark = ResultDataReader["Remark"] == null ? "" : ResultDataReader["Remark"].ToString()
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return categoryInfoList.ToArray();
    }

    public PropInfo[] GetAllProp()
    {
      List<PropInfo> propInfoList = new List<PropInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Prop_All");
        while (ResultDataReader.Read())
          propInfoList.Add(new PropInfo()
          {
            AffectArea = (int) ResultDataReader["AffectArea"],
            AffectTimes = (int) ResultDataReader["AffectTimes"],
            AttackTimes = (int) ResultDataReader["AttackTimes"],
            BoutTimes = (int) ResultDataReader["BoutTimes"],
            BuyGold = (int) ResultDataReader["BuyGold"],
            BuyMoney = (int) ResultDataReader["BuyMoney"],
            Category = (int) ResultDataReader["Category"],
            Delay = (int) ResultDataReader["Delay"],
            Description = ResultDataReader["Description"].ToString(),
            Icon = ResultDataReader["Icon"].ToString(),
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"].ToString(),
            Parameter = (int) ResultDataReader["Parameter"],
            Pic = ResultDataReader["Pic"].ToString(),
            Property1 = (int) ResultDataReader["Property1"],
            Property2 = (int) ResultDataReader["Property2"],
            Property3 = (int) ResultDataReader["Property3"],
            Random = (int) ResultDataReader["Random"],
            Script = ResultDataReader["Script"].ToString()
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return propInfoList.ToArray();
    }

    public BallInfo[] GetAllBall()
    {
      List<BallInfo> ballInfoList = new List<BallInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Ball_All");
        while (ResultDataReader.Read())
          ballInfoList.Add(new BallInfo()
          {
            Amount = (int) ResultDataReader["Amount"],
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"].ToString(),
            Crater = ResultDataReader["Crater"] == null ? "" : ResultDataReader["Crater"].ToString(),
            Power = (double) ResultDataReader["Power"],
            Radii = (int) ResultDataReader["Radii"],
            AttackResponse = (int) ResultDataReader["AttackResponse"],
            BombPartical = ResultDataReader["BombPartical"].ToString(),
            FlyingPartical = ResultDataReader["FlyingPartical"].ToString(),
            IsSpin = (bool) ResultDataReader["IsSpin"],
            Mass = (int) ResultDataReader["Mass"],
            SpinV = (int) ResultDataReader["SpinV"],
            SpinVA = (double) ResultDataReader["SpinVA"],
            Wind = (int) ResultDataReader["Wind"],
            DragIndex = (int) ResultDataReader["DragIndex"],
            Weight = (int) ResultDataReader["Weight"],
            Shake = (bool) ResultDataReader["Shake"],
            Delay = (int) ResultDataReader["Delay"],
            ShootSound = ResultDataReader["ShootSound"] == null ? "" : ResultDataReader["ShootSound"].ToString(),
            BombSound = ResultDataReader["BombSound"] == null ? "" : ResultDataReader["BombSound"].ToString(),
            ActionType = (int) ResultDataReader["ActionType"],
            HasTunnel = (bool) ResultDataReader["HasTunnel"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return ballInfoList.ToArray();
    }

    public LuckstarActivityRankInfo[] GetAllLuckstarActivityRank()
    {
      List<LuckstarActivityRankInfo> activityRankInfoList = new List<LuckstarActivityRankInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Luckstar_Activity_Rank_All");
        int num = 1;
        while (ResultDataReader.Read())
        {
          activityRankInfoList.Add(new LuckstarActivityRankInfo()
          {
            rank = num,
            UserID = (int) ResultDataReader["UserID"],
            useStarNum = (int) ResultDataReader["useStarNum"],
            isVip = (int) ResultDataReader["isVip"],
            nickName = (string) ResultDataReader["nickName"]
          });
          ++num;
        }
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return activityRankInfoList.ToArray();
    }

    public BallConfigInfo[] GetAllBallConfig()
    {
      List<BallConfigInfo> ballConfigInfoList = new List<BallConfigInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Ball_Config_All");
        while (ResultDataReader.Read())
          ballConfigInfoList.Add(new BallConfigInfo()
          {
            Common = (int) ResultDataReader["Common"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            CommonAddWound = (int) ResultDataReader["CommonAddWound"],
            CommonMultiBall = (int) ResultDataReader["CommonMultiBall"],
            Special = (int) ResultDataReader["Special"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return ballConfigInfoList.ToArray();
    }

    public ShopCheapItemsInfo[] GetAllShopCheapItems()
    {
      List<ShopCheapItemsInfo> shopCheapItemsInfoList = new List<ShopCheapItemsInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Shop_Cheap_Items_All");
        while (ResultDataReader.Read())
          shopCheapItemsInfoList.Add(this.InitShopCheapItemsInfo(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "InitShopCheapItemsInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return shopCheapItemsInfoList.ToArray();
    }

    public ShopCheapItemsInfo InitShopCheapItemsInfo(SqlDataReader dr)
    {
      return new ShopCheapItemsInfo()
      {
        ID = (int) dr["ID"],
        TemplateID = (int) dr["TemplateID"],
        LableType = (int) dr["LableType"],
        LimitGrade = (int) dr["LimitGrade"],
        AUnit = (int) dr["AUnit"],
        APrice = (int) dr["APrice"],
        AValue = (int) dr["AValue"],
        BUnit = (int) dr["BUnit"],
        BPrice = (int) dr["BPrice"],
        BValue = (int) dr["BValue"],
        CUnit = (int) dr["CUnit"],
        CPrice = (int) dr["CPrice"],
        CValue = (int) dr["CValue"],
        StartDate = (DateTime) dr["StartDate"],
        EndDate = (DateTime) dr["EndDate"],
        BuyType = (int) dr["BuyType"]
      };
    }

    public ShopItemInfo[] method_0()
    {
      List<ShopItemInfo> shopItemInfoList = new List<ShopItemInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Shop_All");
        while (ResultDataReader.Read())
          shopItemInfoList.Add(new ShopItemInfo()
          {
            ID = int.Parse(ResultDataReader["ID"].ToString()),
            ShopID = int.Parse(ResultDataReader["ShopID"].ToString()),
            GroupID = int.Parse(ResultDataReader["GroupID"].ToString()),
            TemplateID = int.Parse(ResultDataReader["TemplateID"].ToString()),
            BuyType = int.Parse(ResultDataReader["BuyType"].ToString()),
            Label = int.Parse(ResultDataReader["Label"].ToString()),
            Beat = Decimal.Parse(ResultDataReader["Beat"].ToString()),
            AUnit = int.Parse(ResultDataReader["AUnit"].ToString()),
            APrice1 = int.Parse(ResultDataReader["APrice1"].ToString()),
            AValue1 = int.Parse(ResultDataReader["AValue1"].ToString()),
            APrice2 = int.Parse(ResultDataReader["APrice2"].ToString()),
            AValue2 = int.Parse(ResultDataReader["AValue2"].ToString()),
            APrice3 = int.Parse(ResultDataReader["APrice3"].ToString()),
            AValue3 = int.Parse(ResultDataReader["AValue3"].ToString()),
            BUnit = int.Parse(ResultDataReader["BUnit"].ToString()),
            BPrice1 = int.Parse(ResultDataReader["BPrice1"].ToString()),
            BValue1 = int.Parse(ResultDataReader["BValue1"].ToString()),
            BPrice2 = int.Parse(ResultDataReader["BPrice2"].ToString()),
            BValue2 = int.Parse(ResultDataReader["BValue2"].ToString()),
            BPrice3 = int.Parse(ResultDataReader["BPrice3"].ToString()),
            BValue3 = int.Parse(ResultDataReader["BValue3"].ToString()),
            CUnit = int.Parse(ResultDataReader["CUnit"].ToString()),
            CPrice1 = int.Parse(ResultDataReader["CPrice1"].ToString()),
            CValue1 = int.Parse(ResultDataReader["CValue1"].ToString()),
            CPrice2 = int.Parse(ResultDataReader["CPrice2"].ToString()),
            CValue2 = int.Parse(ResultDataReader["CValue2"].ToString()),
            CPrice3 = int.Parse(ResultDataReader["CPrice3"].ToString()),
            CValue3 = int.Parse(ResultDataReader["CValue3"].ToString()),
            IsContinue = bool.Parse(ResultDataReader["IsContinue"].ToString()),
            IsCheap = bool.Parse(ResultDataReader["IsCheap"].ToString()),
            LimitCount = int.Parse(ResultDataReader["LimitCount"].ToString()),
            StartDate = DateTime.Parse(ResultDataReader["StartDate"].ToString()),
            EndDate = DateTime.Parse(ResultDataReader["EndDate"].ToString())
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return shopItemInfoList.ToArray();
    }

    public FusionInfo[] GetAllFusionDesc()
    {
      List<FusionInfo> fusionInfoList = new List<FusionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Fusion_All_Desc");
        while (ResultDataReader.Read())
          fusionInfoList.Add(new FusionInfo()
          {
            FusionID = (int) ResultDataReader["FusionID"],
            Item1 = (int) ResultDataReader["Item1"],
            Item2 = (int) ResultDataReader["Item2"],
            Item3 = (int) ResultDataReader["Item3"],
            Item4 = (int) ResultDataReader["Item4"],
            Formula = (int) ResultDataReader["Formula"],
            Reward = (int) ResultDataReader["Reward"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllFusion", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return fusionInfoList.ToArray();
    }

    public FusionInfo[] GetAllFusion()
    {
      List<FusionInfo> fusionInfoList = new List<FusionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Fusion_All");
        while (ResultDataReader.Read())
          fusionInfoList.Add(new FusionInfo()
          {
            FusionID = (int) ResultDataReader["FusionID"],
            Item1 = (int) ResultDataReader["Item1"],
            Item2 = (int) ResultDataReader["Item2"],
            Item3 = (int) ResultDataReader["Item3"],
            Item4 = (int) ResultDataReader["Item4"],
            Count1 = (int) ResultDataReader["Count1"],
            Count2 = (int) ResultDataReader["Count2"],
            Count3 = (int) ResultDataReader["Count3"],
            Count4 = (int) ResultDataReader["Count4"],
            Formula = (int) ResultDataReader["Formula"],
            FusionRate = (int) ResultDataReader["FusionRate"],
            FusionType = (int) ResultDataReader["FusionType"],
            Reward = (int) ResultDataReader["Reward"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllFusion), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return fusionInfoList.ToArray();
    }

    public StrengthenInfo[] GetAllStrengthen()
    {
      List<StrengthenInfo> strengthenInfoList = new List<StrengthenInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_Strengthen_All");
        while (ResultDataReader.Read())
          strengthenInfoList.Add(new StrengthenInfo()
          {
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            Random = (int) ResultDataReader["Random"],
            Rock = (int) ResultDataReader["Rock"],
            Rock1 = (int) ResultDataReader["Rock1"],
            Rock2 = (int) ResultDataReader["Rock2"],
            Rock3 = (int) ResultDataReader["Rock3"],
            StoneLevelMin = (int) ResultDataReader["StoneLevelMin"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllStrengthen), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return strengthenInfoList.ToArray();
    }

    public RuneTemplateInfo[] GetAllRuneTemplate()
    {
      List<RuneTemplateInfo> runeTemplateInfoList = new List<RuneTemplateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_RuneTemplate_All");
        while (ResultDataReader.Read())
          runeTemplateInfoList.Add(new RuneTemplateInfo()
          {
            TemplateID = (int) ResultDataReader["TemplateID"],
            NextTemplateID = (int) ResultDataReader["NextTemplateID"],
            Name = (string) ResultDataReader["Name"],
            BaseLevel = (int) ResultDataReader["BaseLevel"],
            MaxLevel = (int) ResultDataReader["MaxLevel"],
            Type1 = (int) ResultDataReader["Type1"],
            Attribute1 = (string) ResultDataReader["Attribute1"],
            Turn1 = (int) ResultDataReader["Turn1"],
            Rate1 = (int) ResultDataReader["Rate1"],
            Type2 = (int) ResultDataReader["Type2"],
            Attribute2 = (string) ResultDataReader["Attribute2"],
            Turn2 = (int) ResultDataReader["Turn2"],
            Rate2 = (int) ResultDataReader["Rate2"],
            Type3 = (int) ResultDataReader["Type3"],
            Attribute3 = (string) ResultDataReader["Attribute3"],
            Turn3 = (int) ResultDataReader["Turn3"],
            Rate3 = (int) ResultDataReader["Rate3"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetRuneTemplateInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return runeTemplateInfoList.ToArray();
    }

    public StrengThenExpInfo[] GetAllStrengThenExp()
    {
      List<StrengThenExpInfo> strengThenExpInfoList = new List<StrengThenExpInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_StrengThenExp_All");
        while (ResultDataReader.Read())
          strengThenExpInfoList.Add(new StrengThenExpInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Level = (int) ResultDataReader["Level"],
            Exp = (int) ResultDataReader["Exp"],
            NecklaceStrengthExp = (int) ResultDataReader["NecklaceStrengthExp"],
            NecklaceStrengthPlus = (int) ResultDataReader["NecklaceStrengthPlus"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetStrengThenExpInfo", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return strengThenExpInfoList.ToArray();
    }

    public StrengthenGoodsInfo[] GetAllStrengthenGoodsInfo()
    {
      List<StrengthenGoodsInfo> strengthenGoodsInfoList = new List<StrengthenGoodsInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_StrengthenGoodsInfo_All");
        while (ResultDataReader.Read())
          strengthenGoodsInfoList.Add(new StrengthenGoodsInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Level = (int) ResultDataReader["Level"],
            CurrentEquip = (int) ResultDataReader["CurrentEquip"],
            GainEquip = (int) ResultDataReader["GainEquip"],
            OriginalEquip = (int) ResultDataReader["OriginalEquip"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllStrengthenGoodsInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return strengthenGoodsInfoList.ToArray();
    }

    public StrengthenInfo[] GetAllRefineryStrengthen()
    {
      List<StrengthenInfo> strengthenInfoList = new List<StrengthenInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_Refinery_Strengthen_All");
        while (ResultDataReader.Read())
          strengthenInfoList.Add(new StrengthenInfo()
          {
            StrengthenLevel = (int) ResultDataReader["StrengthenLevel"],
            Rock = (int) ResultDataReader["Rock"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllRefineryStrengthen), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return strengthenInfoList.ToArray();
    }

    public List<RefineryInfo> GetAllRefineryInfo()
    {
      List<RefineryInfo> allRefineryInfo = new List<RefineryInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Item_Refinery_All");
        while (ResultDataReader.Read())
          allRefineryInfo.Add(new RefineryInfo()
          {
            RefineryID = (int) ResultDataReader["RefineryID"],
            m_Equip = {
              (int) ResultDataReader["Equip1"],
              (int) ResultDataReader["Equip2"],
              (int) ResultDataReader["Equip3"],
              (int) ResultDataReader["Equip4"]
            },
            Item1 = (int) ResultDataReader["Item1"],
            Item2 = (int) ResultDataReader["Item2"],
            Item3 = (int) ResultDataReader["Item3"],
            Int32_0 = (int) ResultDataReader["Item1Count"],
            Int32_1 = (int) ResultDataReader["Item2Count"],
            Int32_2 = (int) ResultDataReader["Item3Count"],
            m_Reward = {
              (int) ResultDataReader["Material1"],
              (int) ResultDataReader["Operate1"],
              (int) ResultDataReader["Reward1"],
              (int) ResultDataReader["Material2"],
              (int) ResultDataReader["Operate2"],
              (int) ResultDataReader["Reward2"],
              (int) ResultDataReader["Material3"],
              (int) ResultDataReader["Operate3"],
              (int) ResultDataReader["Reward3"],
              (int) ResultDataReader["Material4"],
              (int) ResultDataReader["Operate4"],
              (int) ResultDataReader["Reward4"]
            }
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllRefineryInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return allRefineryInfo;
    }

    public QuestInfo[] method_1()
    {
      List<QuestInfo> questInfoList = new List<QuestInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Quest_All");
        while (ResultDataReader.Read())
          questInfoList.Add(this.InitQuest(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return questInfoList.ToArray();
    }

    public QuestAwardInfo[] GetAllQuestGoods()
    {
      List<QuestAwardInfo> questAwardInfoList = new List<QuestAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Quest_Goods_All");
        while (ResultDataReader.Read())
          questAwardInfoList.Add(this.InitQuestGoods(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return questAwardInfoList.ToArray();
    }

    public QuestConditionInfo[] GetAllQuestCondiction()
    {
      List<QuestConditionInfo> questConditionInfoList = new List<QuestConditionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Quest_Condiction_All");
        while (ResultDataReader.Read())
          questConditionInfoList.Add(this.InitQuestCondiction(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return questConditionInfoList.ToArray();
    }

    public QuestRateInfo[] GetAllQuestRate()
    {
      List<QuestRateInfo> questRateInfoList = new List<QuestRateInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Quest_Rate_All");
        while (ResultDataReader.Read())
          questRateInfoList.Add(this.InitQuestRate(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return questRateInfoList.ToArray();
    }

    public QuestInfo GetSingleQuest(int questID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@QuestID", SqlDbType.Int, 4)
        };
        SqlParameters[0].Value = (object) questID;
        this.db.GetReader(ref ResultDataReader, "SP_Quest_Single", SqlParameters);
        if (ResultDataReader.Read())
          return this.InitQuest(ResultDataReader);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (QuestInfo) null;
    }

    public QuestInfo InitQuest(SqlDataReader reader)
    {
      return new QuestInfo()
      {
        ID = (int) reader["ID"],
        QuestID = (int) reader["QuestID"],
        Title = reader["Title"] == null ? "" : reader["Title"].ToString(),
        Detail = reader["Detail"] == null ? "" : reader["Detail"].ToString(),
        Objective = reader["Objective"] == null ? "" : reader["Objective"].ToString(),
        NeedMinLevel = (int) reader["NeedMinLevel"],
        NeedMaxLevel = (int) reader["NeedMaxLevel"],
        PreQuestID = reader["PreQuestID"] == null ? "" : reader["PreQuestID"].ToString(),
        NextQuestID = reader["NextQuestID"] == null ? "" : reader["NextQuestID"].ToString(),
        IsOther = (int) reader["IsOther"],
        CanRepeat = (bool) reader["CanRepeat"],
        RepeatInterval = (int) reader["RepeatInterval"],
        RepeatMax = (int) reader["RepeatMax"],
        RewardGP = (int) reader["RewardGP"],
        RewardGold = (int) reader["RewardGold"],
        RewardBindMoney = (int) reader["RewardBindMoney"],
        RewardOffer = (int) reader["RewardOffer"],
        RewardRiches = (int) reader["RewardRiches"],
        RewardBuffID = (int) reader["RewardBuffID"],
        RewardBuffDate = (int) reader["RewardBuffDate"],
        RewardMoney = (int) reader["RewardMoney"],
        Rands = (Decimal) reader["Rands"],
        RandDouble = (int) reader["RandDouble"],
        TimeMode = (bool) reader["TimeMode"],
        StartDate = (DateTime) reader["StartDate"],
        EndDate = (DateTime) reader["EndDate"],
        MapID = (int) reader["MapID"],
        AutoEquip = (bool) reader["AutoEquip"],
        OneKeyFinishNeedMoney = (int) reader["OneKeyFinishNeedMoney"],
        Rank = reader["Rank"] == null ? "" : reader["Rank"].ToString(),
        StarLev = (int) reader["StarLev"],
        NotMustCount = (int) reader["NotMustCount"],
        Level2NeedMoney = (int) reader["Level2NeedMoney"],
        Level3NeedMoney = (int) reader["Level3NeedMoney"],
        Level4NeedMoney = (int) reader["Level4NeedMoney"],
        Level5NeedMoney = (int) reader["Level5NeedMoney"],
        CollocationCost = (int) reader["CollocationCost"],
        CollocationColdTime = (int) reader["CollocationColdTime"]
      };
    }

    public QuestAwardInfo InitQuestGoods(SqlDataReader reader)
    {
      return new QuestAwardInfo()
      {
        QuestID = (int) reader["QuestID"],
        RewardItemID = (int) reader["RewardItemID"],
        IsSelect = (bool) reader["IsSelect"],
        RewardItemValid = (int) reader["RewardItemValid"],
        RewardItemCount1 = (int) reader["RewardItemCount1"],
        RewardItemCount2 = (int) reader["RewardItemCount2"],
        RewardItemCount3 = (int) reader["RewardItemCount3"],
        RewardItemCount4 = (int) reader["RewardItemCount4"],
        RewardItemCount5 = (int) reader["RewardItemCount5"],
        StrengthenLevel = (int) reader["StrengthenLevel"],
        AttackCompose = (int) reader["AttackCompose"],
        DefendCompose = (int) reader["DefendCompose"],
        AgilityCompose = (int) reader["AgilityCompose"],
        LuckCompose = (int) reader["LuckCompose"],
        IsCount = (bool) reader["IsCount"],
        IsBind = (bool) reader["IsBind"]
      };
    }

    public QuestConditionInfo InitQuestCondiction(SqlDataReader reader)
    {
      return new QuestConditionInfo()
      {
        QuestID = (int) reader["QuestID"],
        CondictionID = (int) reader["CondictionID"],
        CondictionTitle = reader["CondictionTitle"] == null ? "" : reader["CondictionTitle"].ToString(),
        CondictionType = (int) reader["CondictionType"],
        Para1 = (int) reader["Para1"],
        Para2 = (int) reader["Para2"],
        isOpitional = (bool) reader["isOpitional"]
      };
    }

    public QuestRateInfo InitQuestRate(SqlDataReader reader)
    {
      return new QuestRateInfo()
      {
        BindMoneyRate = reader["BindMoneyRate"] == null ? "" : reader["BindMoneyRate"].ToString(),
        ExpRate = reader["ExpRate"] == null ? "" : reader["ExpRate"].ToString(),
        GoldRate = reader["GoldRate"] == null ? "" : reader["GoldRate"].ToString(),
        ExploitRate = reader["ExploitRate"] == null ? "" : reader["ExploitRate"].ToString(),
        CanOneKeyFinishTime = (int) reader["CanOneKeyFinishTime"]
      };
    }

    public DropCondiction[] GetAllDropCondictions()
    {
      List<DropCondiction> dropCondictionList = new List<DropCondiction>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Drop_Condiction_All");
        while (ResultDataReader.Read())
          dropCondictionList.Add(this.InitDropCondiction(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return dropCondictionList.ToArray();
    }

    public DropItem[] GetAllDropItems()
    {
      List<DropItem> dropItemList = new List<DropItem>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Drop_Item_All");
        while (ResultDataReader.Read())
          dropItemList.Add(this.InitDropItem(ResultDataReader));
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "Init", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return dropItemList.ToArray();
    }

    public DropCondiction InitDropCondiction(SqlDataReader reader)
    {
      return new DropCondiction()
      {
        DropId = (int) reader["DropID"],
        CondictionType = (int) reader["CondictionType"],
        Para1 = (string) reader["Para1"],
        Para2 = (string) reader["Para2"]
      };
    }

    public DropItem InitDropItem(SqlDataReader reader)
    {
      return new DropItem()
      {
        Id = (int) reader["Id"],
        DropId = (int) reader["DropId"],
        ItemId = (int) reader["ItemId"],
        ValueDate = (int) reader["ValueDate"],
        IsBind = (bool) reader["IsBind"],
        Random = (int) reader["Random"],
        BeginData = (int) reader["BeginData"],
        EndData = (int) reader["EndData"],
        IsLogs = (bool) reader["IsLogs"],
        IsTips = (bool) reader["IsTips"]
      };
    }

    public AASInfo[] GetAllAASInfo()
    {
      List<AASInfo> aasInfoList = new List<AASInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_AASInfo_All");
        while (ResultDataReader.Read())
          aasInfoList.Add(new AASInfo()
          {
            UserID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"].ToString(),
            IDNumber = ResultDataReader["IDNumber"].ToString(),
            State = (int) ResultDataReader["State"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllAASInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return aasInfoList.ToArray();
    }

    public bool method_2(AASInfo info)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[5]
        {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Name", (object) info.Name),
          new SqlParameter("@IDNumber", (object) info.IDNumber),
          new SqlParameter("@State", (object) info.State),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[4].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_ASSInfo_Add", SqlParameters);
        flag = (int) SqlParameters[4].Value == 0;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "UpdateAASInfo", ex);
      }
      return flag;
    }

    public string GetASSInfoSingle(int UserID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", (object) UserID)
        };
        this.db.GetReader(ref ResultDataReader, "SP_ASSInfo_Single", SqlParameters);
        if (ResultDataReader.Read())
          return ResultDataReader["IDNumber"].ToString();
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetASSInfoSingle), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return "";
    }

    public bool AddDailyLogList(DailyLogListInfo info)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[5]
        {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@UserAwardLog", (object) info.UserAwardLog),
          new SqlParameter("@DayLog", (object) info.DayLog),
          new SqlParameter("@Result", SqlDbType.Int),
          null
        };
        SqlParameters[3].Direction = ParameterDirection.ReturnValue;
        this.db.RunProcedure("SP_DailyLogList_Add", SqlParameters);
        flag = (int) SqlParameters[3].Value == 0;
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "UpdateAASInfo", ex);
      }
      return flag;
    }

    public bool UpdateDailyLogList(DailyLogListInfo info)
    {
      bool flag = false;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[5]
        {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@UserAwardLog", (object) info.UserAwardLog),
          new SqlParameter("@DayLog", (object) info.DayLog),
          new SqlParameter("@LastDate", (object) info.LastDate.ToString()),
          new SqlParameter("@Result", SqlDbType.Int)
        };
        SqlParameters[4].Direction = ParameterDirection.ReturnValue;
        flag = this.db.RunProcedure("SP_DailyLogList_Update", SqlParameters);
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "User_Update_BoxProgression", ex);
      }
      return flag;
    }

    public DailyLogListInfo GetDailyLogListSingle(int UserID)
    {
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        SqlParameter[] SqlParameters = new SqlParameter[1]
        {
          new SqlParameter("@UserID", (object) UserID)
        };
        this.db.GetReader(ref ResultDataReader, "SP_DailyLogList_Single", SqlParameters);
        if (ResultDataReader.Read())
          return new DailyLogListInfo()
          {
            ID = (int) ResultDataReader["ID"],
            UserID = (int) ResultDataReader[nameof (UserID)],
            UserAwardLog = (int) ResultDataReader["UserAwardLog"],
            DayLog = (string) ResultDataReader["DayLog"],
            LastDate = (DateTime) ResultDataReader["LastDate"]
          };
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "DailyLogList", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return (DailyLogListInfo) null;
    }

    public SearchGoodsTempInfo[] GetAllSearchGoodsTemp()
    {
      List<SearchGoodsTempInfo> searchGoodsTempInfoList = new List<SearchGoodsTempInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_SearchGoodsTemp_All");
        while (ResultDataReader.Read())
          searchGoodsTempInfoList.Add(new SearchGoodsTempInfo()
          {
            StarID = (int) ResultDataReader["StarID"],
            NeedMoney = (int) ResultDataReader["NeedMoney"],
            DestinationReward = (int) ResultDataReader["DestinationReward"],
            VIPLevel = (int) ResultDataReader["VIPLevel"],
            ExtractNumber = ResultDataReader["ExtractNumber"] == null ? "" : ResultDataReader["ExtractNumber"].ToString()
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllDaily", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return searchGoodsTempInfoList.ToArray();
    }

    public DailyAwardInfo[] GetAllDailyAward()
    {
      List<DailyAwardInfo> dailyAwardInfoList = new List<DailyAwardInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Daily_Award_All");
        while (ResultDataReader.Read())
          dailyAwardInfoList.Add(new DailyAwardInfo()
          {
            Count = (int) ResultDataReader["Count"],
            ID = (int) ResultDataReader["ID"],
            IsBinds = (bool) ResultDataReader["IsBinds"],
            TemplateID = (int) ResultDataReader["TemplateID"],
            Type = (int) ResultDataReader["Type"],
            ValidDate = (int) ResultDataReader["ValidDate"],
            Sex = (int) ResultDataReader["Sex"],
            Remark = ResultDataReader["Remark"] == null ? "" : ResultDataReader["Remark"].ToString(),
            CountRemark = ResultDataReader["CountRemark"] == null ? "" : ResultDataReader["CountRemark"].ToString(),
            GetWay = (int) ResultDataReader["GetWay"],
            AwardDays = (int) ResultDataReader["AwardDays"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) "GetAllDaily", ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return dailyAwardInfoList.ToArray();
    }

    public NpcInfo[] GetAllNPCInfo()
    {
      List<NpcInfo> npcInfoList = new List<NpcInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_NPC_Info_All");
        while (ResultDataReader.Read())
          npcInfoList.Add(new NpcInfo()
          {
            ID = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"] == null ? "" : ResultDataReader["Name"].ToString(),
            Level = (int) ResultDataReader["Level"],
            Camp = (int) ResultDataReader["Camp"],
            Type = (int) ResultDataReader["Type"],
            Blood = (int) ResultDataReader["Blood"],
            X = (int) ResultDataReader["X"],
            Y = (int) ResultDataReader["Y"],
            Width = (int) ResultDataReader["Width"],
            Height = (int) ResultDataReader["Height"],
            MoveMin = (int) ResultDataReader["MoveMin"],
            MoveMax = (int) ResultDataReader["MoveMax"],
            BaseDamage = (int) ResultDataReader["BaseDamage"],
            BaseGuard = (int) ResultDataReader["BaseGuard"],
            Attack = (int) ResultDataReader["Attack"],
            Defence = (int) ResultDataReader["Defence"],
            Agility = (int) ResultDataReader["Agility"],
            Lucky = (int) ResultDataReader["Lucky"],
            ModelID = ResultDataReader["ModelID"] == null ? "" : ResultDataReader["ModelID"].ToString(),
            ResourcesPath = ResultDataReader["ResourcesPath"] == null ? "" : ResultDataReader["ResourcesPath"].ToString(),
            DropRate = ResultDataReader["DropRate"] == null ? "" : ResultDataReader["DropRate"].ToString(),
            Experience = (int) ResultDataReader["Experience"],
            Delay = (int) ResultDataReader["Delay"],
            Immunity = (int) ResultDataReader["Immunity"],
            Alert = (int) ResultDataReader["Alert"],
            Range = (int) ResultDataReader["Range"],
            Preserve = (int) ResultDataReader["Preserve"],
            Script = ResultDataReader["Script"] == null ? "" : ResultDataReader["Script"].ToString(),
            FireX = (int) ResultDataReader["FireX"],
            FireY = (int) ResultDataReader["FireY"],
            DropId = (int) ResultDataReader["DropId"],
            MagicAttack = (int) ResultDataReader["MagicAttack"],
            MagicDefence = (int) ResultDataReader["MagicDefence"],
            CurrentBallId = (int) ResultDataReader["CurrentBallId"],
            speed = (int) ResultDataReader["speed"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllNPCInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return npcInfoList.ToArray();
    }

    public MissionEnergyInfo[] GetAllMissionEnergyInfo()
    {
      List<MissionEnergyInfo> missionEnergyInfoList = new List<MissionEnergyInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_MissionEnergyInfo_All");
        while (ResultDataReader.Read())
          missionEnergyInfoList.Add(new MissionEnergyInfo()
          {
            Count = (int) ResultDataReader["Count"],
            Money = (int) ResultDataReader["Money"],
            Energy = (int) ResultDataReader["Energy"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllMissionEnergyInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return missionEnergyInfoList.ToArray();
    }

    public MissionInfo[] GetAllMissionInfo()
    {
      List<MissionInfo> missionInfoList = new List<MissionInfo>();
      SqlDataReader ResultDataReader = (SqlDataReader) null;
      try
      {
        this.db.GetReader(ref ResultDataReader, "SP_Mission_Info_All");
        while (ResultDataReader.Read())
          missionInfoList.Add(new MissionInfo()
          {
            Id = (int) ResultDataReader["ID"],
            Name = ResultDataReader["Name"] == null ? "" : ResultDataReader["Name"].ToString(),
            TotalCount = (int) ResultDataReader["TotalCount"],
            TotalTurn = (int) ResultDataReader["TotalTurn"],
            Script = ResultDataReader["Script"] == null ? "" : ResultDataReader["Script"].ToString(),
            Success = ResultDataReader["Success"] == null ? "" : ResultDataReader["Success"].ToString(),
            Failure = ResultDataReader["Failure"] == null ? "" : ResultDataReader["Failure"].ToString(),
            Description = ResultDataReader["Description"] == null ? "" : ResultDataReader["Description"].ToString(),
            IncrementDelay = (int) ResultDataReader["IncrementDelay"],
            Delay = (int) ResultDataReader["Delay"],
            Title = ResultDataReader["Title"] == null ? "" : ResultDataReader["Title"].ToString(),
            Param1 = (int) ResultDataReader["Param1"],
            Param2 = (int) ResultDataReader["Param2"]
          });
      }
      catch (Exception ex)
      {
        if (BaseBussiness.log.IsErrorEnabled)
          BaseBussiness.log.Error((object) nameof (GetAllMissionInfo), ex);
      }
      finally
      {
        if (ResultDataReader != null && !ResultDataReader.IsClosed)
          ResultDataReader.Close();
      }
      return missionInfoList.ToArray();
    }
  }
}
