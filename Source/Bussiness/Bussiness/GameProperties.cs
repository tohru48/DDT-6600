// Decompiled with JetBrains decompiler
// Type: Bussiness.GameProperties
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using Game.Base.Config;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Bussiness
{
  public abstract class GameProperties
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    [ConfigProperty("Edition", "µ±Ç°ÓÎÏ·°æ±\u00BE", "5498628")]
    public static readonly string EDITION;
    [ConfigProperty("MustComposeGold", "ºÏ\u00B3ÉÏûºÄ\u00BDð±Ò\u00BCÛ¸ñ", 1000)]
    public static readonly int PRICE_COMPOSE_GOLD;
    [ConfigProperty("MustFusionGold", "ÈÛÁ¶ÏûºÄ\u00BDð±Ò\u00BCÛ¸ñ", 400)]
    public static readonly int PRICE_FUSION_GOLD;
    [ConfigProperty("MustStrengthenGold", "Ç¿»¯\u00BDð±ÒÏûºÄ\u00BCÛ¸ñ", 1000)]
    public static readonly int PRICE_STRENGHTN_GOLD;
    [ConfigProperty("CheckRewardItem", "ÑéÖ¤Âë\u00BD±ÀøÎïÆ·", 11001)]
    public static readonly int CHECK_REWARD_ITEM;
    [ConfigProperty("CheckCount", "×î´óÑéÖ¤ÂëÊ§°Ü´ÎÊý", 2)]
    public static readonly int CHECK_MAX_FAILED_COUNT;
    [ConfigProperty("HymenealMoney", "Çó»éµÄ\u00BCÛ¸ñ", 300)]
    public static readonly int PRICE_PROPOSE;
    [ConfigProperty("DivorcedMoney", "Àë»éµÄ\u00BCÛ¸ñ", 1499)]
    public static readonly int PRICE_DIVORCED;
    [ConfigProperty("DivorcedDiscountMoney", "Àë»éµÄ\u00BCÛ¸ñ", 999)]
    public static readonly int PRICE_DIVORCED_DISCOUNT;
    [ConfigProperty("MarryRoomCreateMoney", "\u00BDá»é·¿\u00BCäµÄ\u00BCÛ¸ñ,2Ð¡Ê±¡¢3Ð¡Ê±¡¢4Ð¡Ê±ÓÃ¶ººÅ·Ö¸ô", "2000,2700,3400")]
    public static readonly string PRICE_MARRY_ROOM;
    [ConfigProperty("BoxAppearCondition", "Ïä×ÓÎïÆ·ÌáÊ\u00BEµÄµÈ\u00BC¶", 4)]
    public static readonly int BOX_APPEAR_CONDITION;
    [ConfigProperty("DisableCommands", "\u00BDûÖ\u00B9Ê\u00B9ÓÃµÄÃüÁî", "")]
    public static readonly string DISABLED_COMMANDS;
    [ConfigProperty("AssState", "·À\u00B3ÁÃÔÏµÍ\u00B3µÄ¿ª\u00B9Ø,True´ò¿ª,False\u00B9Ø±Õ", false)]
    public static bool ASS_STATE;
    [ConfigProperty("DailyAwardState", "Ã¿ÈÕ\u00BD±Àø¿ª\u00B9Ø,True´ò¿ª,False\u00B9Ø±Õ", true)]
    public static bool DAILY_AWARD_STATE;
    [ConfigProperty("Cess", "\u00BD»Ò×¿ÛË°", 0.1)]
    public static readonly double Cess;
    [ConfigProperty("BeginAuction", "ÅÄÂòÊ±ÆðÊ\u00BCËæ»úÊ±\u00BCä", 20)]
    public static int BeginAuction;
    [ConfigProperty("EndAuction", "ÅÄÂòÊ±\u00BDáÊøËæ»úÊ±\u00BCä", 40)]
    public static int EndAuction;
    [ConfigProperty("HotSpringExp", "Kinh nghiệm Spa", "1|2")]
    public static readonly string HotSpringExp;
    [ConfigProperty("ConsortiaStrengthenEx", "Kinh nghiệm", "1|2")]
    public static readonly string ConsortiaStrengthenEx;
    [ConfigProperty("RuneLevelUpExp", "Kinh nghiệm châu báu", "1|2")]
    public static readonly string RuneLevelUpExp;
    [ConfigProperty("VIPExpForEachLv", "VIPExpForEachLv", "1|2")]
    public static readonly string VIPExpForEachLv;
    [ConfigProperty("HoleLevelUpExpList", "HoleLevelUpExpList", "1|2")]
    public static readonly string HoleLevelUpExpList;
    [ConfigProperty("VIPStrengthenEx", "VIPStrengthenEx", "1|2")]
    public static readonly string VIPStrengthenEx;
    [ConfigProperty("CustomLimit", "sendattackmail|addaution|PresentGoods|PresentMoney|unknow", "20|20|20|20|20")]
    public static readonly string CustomLimit;
    [ConfigProperty("IsLimitCount", "IsLimitCount", false)]
    public static readonly bool IsLimitCount;
    [ConfigProperty("LimitCount", "LimitCount", 10)]
    public static readonly int LimitCount;
    [ConfigProperty("IsLimitMoney", "IsLimitMoney", false)]
    public static readonly bool IsLimitMoney;
    [ConfigProperty("LimitMoney", "LimitMoney", 999000)]
    public static readonly int LimitMoney;
    [ConfigProperty("IsLimitAuction", "IsLimitAuction", false)]
    public static readonly bool IsLimitAuction;
    [ConfigProperty("LimitAuction", "LimitAuction", 3)]
    public static readonly int LimitAuction;
    [ConfigProperty("IsLimitMail", "IsLimitMail", false)]
    public static readonly bool IsLimitMail;
    [ConfigProperty("LimitMail", "LimitMail", 3)]
    public static readonly int LimitMail;
    [ConfigProperty("TestActive", "TestActive", false)]
    public static readonly bool TestActive;
    [ConfigProperty("WishBeadLimitLv", "WishBeadLimitLv", 12)]
    public static readonly int WishBeadLimitLv;
    [ConfigProperty("IsWishBeadLimit", "IsWishBeadLimit", false)]
    public static readonly bool IsWishBeadLimit;
    [ConfigProperty("BagMailEnable", "BagMailEnable", true)]
    public static readonly bool BagMailEnable;
    [ConfigProperty("FreeMoney", "µ±Ç°ÓÎÏ·°æ±\u00BE", 9990000)]
    public static readonly int FreeMoney;
    [ConfigProperty("FreeExp", "µ±Ç°ÓÎÏ·°æ±\u00BE", "11901|1")]
    public static readonly string FreeExp;
    [ConfigProperty("BigExp", "µ±Ç°ÓÎÏ·°æ±\u00BE", "11906|99")]
    public static readonly string BigExp;
    [ConfigProperty("PetExp", "µ±Ç°ÓÎÏ·°æ±\u00BE", "334103|999")]
    public static readonly string PetExp;
    [ConfigProperty("IsActiveMoney", "IsActiveMoney", true)]
    public static readonly bool IsActiveMoney;
    [ConfigProperty("IsDDTMoneyActive", "IsDDTMoneyActive", false)]
    public static readonly bool IsDDTMoneyActive;
    [ConfigProperty("NewChickenBeginTime", "NewChickenBeginTime", "2013/12/17 0:00:00")]
    public static readonly string NewChickenBeginTime;
    [ConfigProperty("NewChickenEndTime", "NewChickenEndTime", "2013/12/25 0:00:00")]
    public static readonly string NewChickenEndTime;
    [ConfigProperty("NewChickenEagleEyePrice", "NewChickenEagleEyePrice", "3000, 2000, 1000")]
    public static readonly string NewChickenEagleEyePrice;
    [ConfigProperty("NewChickenOpenCardPrice", "NewChickenOpenCardPrice", "2500, 2000, 1500, 1000, 500")]
    public static readonly string NewChickenOpenCardPrice;
    [ConfigProperty("NewChickenFlushPrice", "NewChickenFlushPrice", 10000)]
    public static readonly int NewChickenFlushPrice;
    [ConfigProperty("DiceBeginTime", "DiceBeginTime", "2013/12/17 0:00:00")]
    public static readonly string DiceBeginTime;
    [ConfigProperty("DiceEndTime", "DiceEndTime", "2013/12/25 0:00:00")]
    public static readonly string DiceEndTime;
    [ConfigProperty("DiceRefreshPrice", "DiceRefreshPrice", 40000)]
    public static readonly int DiceRefreshPrice;
    [ConfigProperty("CommonDicePrice", "CommonDicePrice", 30000)]
    public static readonly int CommonDicePrice;
    [ConfigProperty("DoubleDicePrice", "DoubleDicePrice", 40000)]
    public static readonly int DoubleDicePrice;
    [ConfigProperty("BigDicePrice", "BigDicePrice", 50000)]
    public static readonly int BigDicePrice;
    [ConfigProperty("SmallDicePrice", "SmallDicePrice", 60000)]
    public static readonly int SmallDicePrice;
    [ConfigProperty("PyramidBeginTime", "PyramidBeginTime", "2013/12/17 0:00:00")]
    public static readonly string PyramidBeginTime;
    [ConfigProperty("PyramidEndTime", "NewChickenEndTime", "2013/12/25 0:00:00")]
    public static readonly string PyramidEndTime;
    [ConfigProperty("PyramidRevivePrice", "PyramidRevivePrice", "10000, 30000, 50000")]
    public static readonly string PyramidRevivePrice;
    [ConfigProperty("PyramydTurnCardPrice", "PyramydTurnCardPrice", 5000)]
    public static readonly int PyramydTurnCardPrice;
    [ConfigProperty("DragonBoatBeginDate", "DragonBoatBeginDate", "2013/12/19 0:00:00")]
    public static readonly string DragonBoatBeginDate;
    [ConfigProperty("DragonBoatEndDate", "DragonBoatEndDate", "2013/12/26 0:00:00")]
    public static readonly string DragonBoatEndDate;
    [ConfigProperty("FightFootballTime", "FightFootballTime", "19|60")]
    public static readonly string FightFootballTime;
    [ConfigProperty("KingBuffPrice", "KingBuffPrice", "475,1425,2500")]
    public static readonly string KingBuffPrice;
    [ConfigProperty("RunePackageID", "RunePackageID", "311100|311200|311300|311400")]
    public static readonly string RunePackageID;
    [ConfigProperty("OpenRunePackageMoney", "OpenRunePackageMoney", "10|20|50|100")]
    public static readonly string OpenRunePackageMoney;
    [ConfigProperty("OpenRunePackageRange", "OpenRunePackageRange", "1,6|1,5|1,4")]
    public static readonly string OpenRunePackageRange;
    [ConfigProperty("VIPQuestFinishDirect", "VIPQuestFinishDirect", "0|0|0|0|0|2|2|2|2|3|3|4")]
    public static readonly string VIPQuestFinishDirect;
    [ConfigProperty("MustTransferGold", "MustTransferGold", 40000)]
    public static readonly int MustTransferGold;
    [ConfigProperty("LuckStarActivityBeginDate", "LuckStarActivityBeginDate", "2013/12/1 0:00:00")]
    public static readonly string LuckStarActivityBeginDate;
    [ConfigProperty("LuckStarActivityEndDate", "LuckStarActivityEndDate", "2014/12/24 0:00:00")]
    public static readonly string LuckStarActivityEndDate;
    [ConfigProperty("MinUseNum", "MinUseNum", 1000)]
    public static readonly int MinUseNum;
    [ConfigProperty("YearMonsterBeginDate", "YearMonsterBeginDate", "2014/1/17 0:00:00")]
    public static readonly string YearMonsterBeginDate;
    [ConfigProperty("YearMonsterEndDate", "YearMonsterEndDate", "2014/2/25 0:00:00")]
    public static readonly string YearMonsterEndDate;
    [ConfigProperty("YearMonsterBoxInfo", "YearMonsterBoxInfo", "112370,5|112371,30|112372,90|112373,150|112374,300")]
    public static readonly string YearMonsterBoxInfo;
    [ConfigProperty("YearMonsterBuffMoney", "YearMonsterBuffMoney", 300)]
    public static readonly int YearMonsterBuffMoney;
    [ConfigProperty("YearMonsterFightNum", "YearMonsterFightNum", 1)]
    public static readonly int YearMonsterFightNum;
    [ConfigProperty("YearMonsterHP", "YearMonsterHP", 3000000)]
    public static readonly int YearMonsterHP;
    [ConfigProperty("YearMonsterOpenLevel", "YearMonsterOpenLevel", 15)]
    public static readonly int YearMonsterOpenLevel;
    [ConfigProperty("DiceGameAwardAndCount", "DiceGameAwardAndCount", "32|16|8|4|2|1")]
    public static readonly string DiceGameAwardAndCount;
    [ConfigProperty("LightRiddleAnswerScore", "LightRiddleAnswerScore", "29|9")]
    public static readonly string LightRiddleAnswerScore;
    [ConfigProperty("LightRiddleBeginDate", "LightRiddleBeginDate", "2014/2/13 0:00:00")]
    public static readonly string LightRiddleBeginDate;
    [ConfigProperty("LightRiddleEndDate", "LightRiddleEndDate", "2014/2/28 0:00:00")]
    public static readonly string LightRiddleEndDate;
    [ConfigProperty("LightRiddleBeginTime", "LightRiddleBeginTime", "2014/2/13 12:30:00")]
    public static readonly string LightRiddleBeginTime;
    [ConfigProperty("LightRiddleEndTime", "LightRiddleEndTime", "2014/2/13 13:00:00")]
    public static readonly string LightRiddleEndTime;
    [ConfigProperty("LightRiddleFreeHitNum", "LightRiddleFreeHitNum", 2)]
    public static readonly int LightRiddleFreeHitNum;
    [ConfigProperty("LightRiddleFreeComboNum", "LightRiddleFreeComboNum", 2)]
    public static readonly int LightRiddleFreeComboNum;
    [ConfigProperty("LightRiddleComboMoney", "LightRiddleComboMoney", 30)]
    public static readonly int LightRiddleComboMoney;
    [ConfigProperty("LightRiddleHitMoney", "LightRiddleHitMoney", 30)]
    public static readonly int LightRiddleHitMoney;
    [ConfigProperty("LightRiddleAnswerTime", "LightRiddleAnswerTime", 15)]
    public static readonly int LightRiddleAnswerTime;
    [ConfigProperty("LightRiddleOpenLevel", "LightRiddleOpenLevel", 15)]
    public static readonly int LightRiddleOpenLevel;
    [ConfigProperty("WarriorFamRaidPricePerMin", "WarriorFamRaidPricePerMin", 10)]
    public static readonly int WarriorFamRaidPricePerMin;
    [ConfigProperty("WarriorFamRaidPriceSmall", "WarriorFamRaidPriceSmall", 30000)]
    public static readonly int WarriorFamRaidPriceSmall;
    [ConfigProperty("WarriorFamRaidPriceBig", "WarriorFamRaidPriceBig ", 40000)]
    public static readonly int WarriorFamRaidPriceBig;
    [ConfigProperty("WarriorFamRaidDDTPrice", "WarriorFamRaidDDTPrice", 5000)]
    public static readonly int WarriorFamRaidDDTPrice;
    [ConfigProperty("WarriorFamRaidTimeRemain", "WarriorFamRaidTimeRemain", 120)]
    public static readonly int WarriorFamRaidTimeRemain;
    [ConfigProperty("ChristmasBeginDate", "ChristmasBeginDate", "2013/12/17 0:00:00")]
    public static readonly string ChristmasBeginDate;
    [ConfigProperty("ChristmasEndDate", "ChristmasEndDate", "2013/12/25 0:00:00")]
    public static readonly string ChristmasEndDate;
    [ConfigProperty("ChristmasGifts", "ChristmasGifts", "201148,10|201149,35|201150,70|201151,120|201152,220|201153,370|201154,650|201155,1000|201156,100")]
    public static readonly string ChristmasGifts;
    [ConfigProperty("ChristmasGiftsMaxNum", "ChristmasGiftsMaxNum", 1000)]
    public static readonly int ChristmasGiftsMaxNum;
    [ConfigProperty("ChristmasBuildSnowmanDoubleMoney", "ChristmasBuildSnowmanDoubleMoney", 10)]
    public static readonly int ChristmasBuildSnowmanDoubleMoney;
    [ConfigProperty("ChristmasBuyTimeMoney", "ChristmasBuyTimeMoney", 150)]
    public static readonly int ChristmasBuyTimeMoney;
    [ConfigProperty("ChristmasMinute", "ChristmasMinute", 60)]
    public static readonly int ChristmasMinute;
    [ConfigProperty("ChristmasBuyMinute", "ChristmasBuyMinute", 10)]
    public static readonly int ChristmasBuyMinute;
    [ConfigProperty("DragonBoatByMoney", "DragonBoatByMoney", "100:10,10")]
    public static readonly string DragonBoatByMoney;
    [ConfigProperty("DragonBoatByProps", "DragonBoatByProps", "1:10,10")]
    public static readonly string DragonBoatByProps;
    [ConfigProperty("DragonBoatMaxScore", "DragonBoatMaxScore", 30000)]
    public static readonly int DragonBoatMaxScore;
    [ConfigProperty("DragonBoatMinScore", "DragonBoatMinScore", 13000)]
    public static readonly int DragonBoatMinScore;
    [ConfigProperty("DragonBoatAreaMinScore", "DragonBoatAreaMinScore", 20000)]
    public static readonly int DragonBoatAreaMinScore;
    [ConfigProperty("DragonBoatProp", "DragonBoatProp", 11690)]
    public static readonly int DragonBoatProp;
    [ConfigProperty("DragonBoatConvertHours", "DragonBoatConvertHours", 72)]
    public static readonly int DragonBoatConvertHours;
    [ConfigProperty("PromotePackagePrice", "PromotePackagePrice", 3600)]
    public static readonly int PromotePackagePrice;
    [ConfigProperty("IsPromotePackageOpen", "IsPromotePackageOpen", false)]
    public static readonly bool IsPromotePackageOpen;
    [ConfigProperty("SearchGoodsFreeLimit", "SearchGoodsFreeLimit", 0)]
    public static readonly int SearchGoodsFreeLimit;
    [ConfigProperty("SearchGoodsPayMoney", "SearchGoodsPayMoney", 20)]
    public static readonly int SearchGoodsPayMoney;
    [ConfigProperty("SearchGoodsFreeCount", "SearchGoodsFreeCount", 3)]
    public static readonly int SearchGoodsFreeCount;
    [ConfigProperty("SearchGoodsTakeCardMoney", "SearchGoodsTakeCardMoney", "0|50|120")]
    public static readonly string SearchGoodsTakeCardMoney;
    [ConfigProperty("MaxMissionEnergy", "MaxMissionEnergy", 300)]
    public static readonly int MaxMissionEnergy;
    [ConfigProperty("OpenMagicBoxMoney", "OpenMagicBoxMoney", "150,10|350,25|650,50")]
    public static readonly string OpenMagicBoxMoney;
    [ConfigProperty("FastGrowSubTime", "FastGrowSubTime", 30)]
    public static readonly int FastGrowSubTime;
    [ConfigProperty("FastGrowNeedMoney", "FastGrowNeedMoney", 30)]
    public static readonly int FastGrowNeedMoney;
    [ConfigProperty("HalloweenMinNum", "HalloweenMinNum", 5000)]
    public static readonly int HalloweenMinNum;
    [ConfigProperty("HalloweenBeginDate", "HalloweenBeginDate", "2013/12/17 0:00:00")]
    public static readonly string HalloweenBeginDate;
    [ConfigProperty("HalloweenEndDate", "HalloweenEndDate", "2013/12/17 0:00:00")]
    public static readonly string HalloweenEndDate;
    [ConfigProperty("DanDanBuffPrice", "DanDanBuffPrice", 3000)]
    public static readonly int DanDanBuffPrice;
    [ConfigProperty("ArenaChallengeCD", "ArenaChallengeCD", 10)]
    public static readonly int ArenaChallengeCD;
    [ConfigProperty("ArenaRankMaxNum", "ArenaRankMaxNum", 5000)]
    public static readonly int ArenaRankMaxNum;
    [ConfigProperty("ArenaChallengeMaxNum", "ArenaChallengeMaxNum", 10)]
    public static readonly int ArenaChallengeMaxNum;
    [ConfigProperty("ArenaCleanCDMoney", "ArenaCleanCDMoney", 50)]
    public static readonly int ArenaCleanCDMoney;
    [ConfigProperty("ArenaChallengeBuyNum", "ArenaChallengeBuyNum", 10)]
    public static readonly int ArenaChallengeBuyNum;
    [ConfigProperty("ArenaChallengeBuyMoney", "ArenaChallengeBuyMoney", 80)]
    public static readonly int ArenaChallengeBuyMoney;
    [ConfigProperty("ArenaRewardIntervalSecond", "ArenaRewardIntervalSecond", 3)]
    public static readonly int ArenaRewardIntervalSecond;
    [ConfigProperty("ArenaRewardNumPerInterval", "ArenaRewardNumPerInterval", 50)]
    public static readonly int ArenaRewardNumPerInterval;
    [ConfigProperty("CryptBossOpenDay", "CryptBossOpenDay", "1,1|2,2|3,3|4,4|5,5,6,0|6,5,6,0")]
    public static readonly string CryptBossOpenDay;
    [ConfigProperty("MagicRoomJuniorWeaponList", "MagicRoomJuniorWeaponList", "7080,70801,70802,70803,70804|7093,70931,70932,70933,70934|7100,71001,71002,71003,71004")]
    public static readonly string MagicRoomJuniorWeaponList;
    [ConfigProperty("MagicRoomMidWeaponList", "MagicRoomMidWeaponList", "7127,71271,71272,71273,71274|7126,71261,71262,71263,71264|7131,71311,71312,71313,71314")]
    public static readonly string MagicRoomMidWeaponList;
    [ConfigProperty("MagicRoomSeniorWeaponList", "MagicRoomSeniorWeaponList", "7099,70991,70992,70993,70994|7116,71161,71162,71163,71164|7129,71291,71292,71293,71294")]
    public static readonly string MagicRoomSeniorWeaponList;
    [ConfigProperty("MagicRoomJuniorAddAttribute", "MagicRoomJuniorAddAttribute", "3,3,0|1,1,0|1,1,0|1,1,0|2,2,0|2,2,0")]
    public static readonly string MagicRoomJuniorAddAttribute;
    [ConfigProperty("MagicRoomMidAddAttribute", "MagicRoomMidAddAttribute", "0,3,2|0,1,1|0,1,1|0,2,1|0,3,1|0,3,1")]
    public static readonly string MagicRoomMidAddAttribute;
    [ConfigProperty("MagicRoomSeniorAddAttribute", "MagicRoomSeniorAddAttribute", "5,0,2|1,0,1|1,0,1|2,0,1|3,0,1|3,0,1")]
    public static readonly string MagicRoomSeniorAddAttribute;
    [ConfigProperty("MagicRoomBoxNeedMoney", "MagicRoomBoxNeedMoney", 500)]
    public static readonly int MagicRoomBoxNeedMoney;
    [ConfigProperty("MagicRoomLevelUpCount", "MagicRoomLevelUpCount", "800|2400|3200|4800|6400")]
    public static readonly string MagicRoomLevelUpCount;
    [ConfigProperty("MagicRoomOpenNeedMoney", "MagicRoomOpenNeedMoney", "500|10")]
    public static readonly string MagicRoomOpenNeedMoney;
    [ConfigProperty("WorshipMoonBeginDate", "WorshipMoonBeginDate", "2014/11/7 9:00:00")]
    public static readonly string WorshipMoonBeginDate;
    [ConfigProperty("WorshipMoonEndDate", "WorshipMoonEndDate", "2014/11/13 22:30:00")]
    public static readonly string WorshipMoonEndDate;
    [ConfigProperty("WorshipMoonProb", "WorshipMoonProb", "35|35|20|5|3|2")]
    public static readonly string WorshipMoonProb;
    [ConfigProperty("WorshipMoonReward", "WorshipMoonReward", "1120233|1120234|1120235|1120236|1120237|1120238")]
    public static readonly string WorshipMoonReward;
    [ConfigProperty("WorshipMoonGift", "WorshipMoonGift", "300|1120239")]
    public static readonly string WorshipMoonGift;
    [ConfigProperty("WorshipMoonGiftShowList", "WorshipMoonGiftShowList", "11972|11973|11974|11975|11976|11977|11978|7093|7100|7126|13668|17000")]
    public static readonly string WorshipMoonGiftShowList;
    [ConfigProperty("WorshipMoonPriceInfo", "WorshipMoonPriceInfo", "3|100")]
    public static readonly string WorshipMoonPriceInfo;
    [ConfigProperty("SummerAcitveBeginTime", "SummerAcitveBeginTime", "2014/12/11 9:00:00")]
    public static readonly string SummerAcitveBeginTime;
    [ConfigProperty("SummerAcitveEndTime", "SummerAcitveEndTime", "2114/12/28 23:59:59")]
    public static readonly string SummerAcitveEndTime;
    [ConfigProperty("SummerAcitveGifts", "SummerAcitveGifts", "1120179,1000|1120180,3000|1120181,10000|1120182,20000|1120183,50000|1120184,100000|1120185,200000")]
    public static readonly string SummerAcitveGifts;
    [ConfigProperty("AreaSummerAcitveTitle", "AreaSummerAcitveTitle", "626|618|618|629|629|629|629|629|629|629")]
    public static readonly string AreaSummerAcitveTitle;
    [ConfigProperty("SummerAcitveTitle", "SummerAcitveTitle", "620|619|619|621|621|621|621|621|621|621")]
    public static readonly string SummerAcitveTitle;
    [ConfigProperty("SummerAcitveConvertHours", "SummerAcitveConvertHours", 48)]
    public static readonly int SummerAcitveConvertHours;
    [ConfigProperty("SummerAcitveMonsters", "SummerAcitveMonsters", "10012|10013|10014")]
    public static readonly string SummerAcitveMonsters;
    [ConfigProperty("TanabataActiveEventNum", "TanabataActiveEventNum", "17,2,2|19,2,3|19,3,3")]
    public static readonly string TanabataActiveEventNum;
    [ConfigProperty("TanabataActivePrice", "TanabataActivePrice", 100)]
    public static readonly int TanabataActivePrice;
    [ConfigProperty("TanabataActiveDestinationAWardID", "TanabataActiveDestinationAWardID", "1120156|1120157|1120158")]
    public static readonly string TanabataActiveDestinationAWardID;
    [ConfigProperty("TanabataActiveBeginTime", "TanabataActiveBeginTime", "2015/3/19 9:00:00")]
    public static readonly string TanabataActiveBeginTime;
    [ConfigProperty("TanabataActiveEndTime", "TanabataActiveEndTime", "2015/3/22 23:59:59")]
    public static readonly string TanabataActiveEndTime;
    [ConfigProperty("IsTanabataTreasure", "IsTanabataTreasure", 48)]
    public static readonly int IsTanabataTreasure;
    [ConfigProperty("TanabataTreasureLimit", "TanabataTreasureLimit", 25)]
    public static readonly int TanabataTreasureLimit;
    [ConfigProperty("MysteryShopOpenTime", "MysteryShopOpenTime", "12|0")]
    public static readonly string MysteryShopOpenTime;
    [ConfigProperty("MysteryShopFreshTime", "MysteryShopFreshTime", 18)]
    public static readonly int MysteryShopFreshTime;
    [ConfigProperty("HorseGameBuffConfig", "HorseGameBuffConfig", "1,3|2,5|3,5|4,5|5,5|6,5|7,2|8,5")]
    public static readonly string HorseGameBuffConfig;
    [ConfigProperty("HorseGamePlayerCount", "HorseGamePlayerCount", 5)]
    public static readonly int HorseGamePlayerCount;
    [ConfigProperty("HorseGameEachDayMaxCount", "HorseGameEachDayMaxCount", 1)]
    public static readonly int HorseGameEachDayMaxCount;
    [ConfigProperty("HorseGameUsePapawMoney", "HorseGameUsePapawMoney", 100)]
    public static readonly int HorseGameUsePapawMoney;
    [ConfigProperty("HorseGameBeginTime", "HorseGameBeginTime", "2015/01/03 0:00:00")]
    public static readonly string HorseGameBeginTime;
    [ConfigProperty("HorseGameEndTime", "HorseGameEndTime", "2015/06/03 0:00:00")]
    public static readonly string HorseGameEndTime;
    [ConfigProperty("HorseGameCostMoneyCount", "HorseGameCostMoneyCount", 200)]
    public static readonly int HorseGameCostMoneyCount;
    [ConfigProperty("HorseGameEachDayMaxCostCount", "HorseGameEachDayMaxCostCount", 5)]
    public static readonly int HorseGameEachDayMaxCostCount;
    [ConfigProperty("HorseGameBeginWeek", "HorseGameBeginWeek", "1,2,3,4,5,6,0")]
    public static readonly string HorseGameBeginWeek;
    [ConfigProperty("DDPlayBeginDate", "DDPlayBeginDate", "2015/01/03 0:00:00")]
    public static readonly string DDPlayBeginDate;
    [ConfigProperty("DDPlayEndDate", "DDPlayEndDate", "2015/03/03 0:00:00")]
    public static readonly string DDPlayEndDate;
    [ConfigProperty("DDPlayMoney", "DDPlayMoney", 100)]
    public static readonly int int_0;
    [ConfigProperty("ExchangeFold", "ExchangeFold", 1000)]
    public static readonly int ExchangeFold;
    [ConfigProperty("CloudBuyLotteryEndDate", "CloudBuyLotteryEndDate", "2015/03/03 0:00:00")]
    public static readonly string CloudBuyLotteryEndDate;
    [ConfigProperty("CloudBuyLotteryExchangeScore", "CloudBuyLotteryExchangeScore", 50000)]
    public static readonly int CloudBuyLotteryExchangeScore;
    [ConfigProperty("GPRate", "GPRate", 2)]
    public static readonly int GPRate;
    [ConfigProperty("MoneyRateLost", "MoneyRateLost", "100|500")]
    public static readonly string MoneyRateLost;
    [ConfigProperty("DDTMoneyRateLost", "DDTMoneyRateLost", "100|500")]
    public static readonly string DDTMoneyRateLost;
    [ConfigProperty("ExpRateLost", "ExpRateLost", "100|200")]
    public static readonly string ExpRateLost;
    [ConfigProperty("MoneyRateWin", "MoneyRateWin", "500|1000")]
    public static readonly string MoneyRateWin;
    [ConfigProperty("DDTMoneyRateWin", "DDTMoneyRateWin", "500|1000")]
    public static readonly string DDTMoneyRateWin;
    [ConfigProperty("ExpRateWin", "ExpRateWin", "500|1000")]
    public static readonly string ExpRateWin;
    [ConfigProperty("LeagueMoneyLose", "LeagueMoneyLose", 5)]
    public static readonly int LeagueMoneyLose;
    [ConfigProperty("LeagueMoneyWin", "LeagueMoneyWin", 15)]
    public static readonly int LeagueMoneyWin;
    [ConfigProperty("DDTMoneyActive", "DDTMoneyActive", false)]
    public static readonly bool DDTMoneyActive;
    [ConfigProperty("GoldHour", "GoldHour", "20|22,2500")]
    public static readonly string GoldHour;
    [ConfigProperty("DisibleBonusMoneyHour", "DisibleBonusMoneyHour", "00|06")]
    public static readonly string DisibleBonusMoneyHour;
    [ConfigProperty("BonusBaseScore", "BonusBaseScore", 10)]
    public static readonly int BonusBaseScore;
    [ConfigProperty("DoubleMoneyActive", "DoubleMoneyActive", false)]
    public static readonly bool DoubleMoneyActive;
    [ConfigProperty("DoubleMoneyRate", "DoubleMoneyRate", 2)]
    public static readonly int DoubleMoneyRate;
    [ConfigProperty("DoubleDDTMoneyActive", "DoubleDDTMoneyActive", false)]
    public static readonly bool DoubleDDTMoneyActive;
    [ConfigProperty("DoubleDDTMoneyRate", "DoubleDDTMoneyRate", 2)]
    public static readonly int DoubleDDTMoneyRate;
    [ConfigProperty("DoubleExpActive", "DoubleExpActive", false)]
    public static readonly bool DoubleExpActive;
    [ConfigProperty("DoubleExpRate", "DoubleExpRate", 2)]
    public static readonly int DoubleExpRate;
    [ConfigProperty("VirtualName", "VirtualName", "Doraemon,Shrek,WallE,Nobita,Robot,Chibi,Star,Eyeshield")]
    public static readonly string VirtualName;
    [ConfigProperty("RemoteEnable", "RemoteEnable", false)]
    public static readonly bool RemoteEnable;
    [ConfigProperty("NewbieEnable", "NewbieEnable", true)]
    public static readonly bool NewbieEnable;
    [ConfigProperty("BeginLevel", "BeginLevel", 40)]
    public static readonly int BeginLevel;
    [ConfigProperty("NeedBox1GoguAward", "NeedBox1GoguAward", 10)]
    public static readonly int NeedBox1GoguAward;
    [ConfigProperty("NeedBox2GoguAward", "NeedBox2GoguAward", 25)]
    public static readonly int NeedBox2GoguAward;
    [ConfigProperty("NeedBox3GoguAward", "NeedBox3GoguAward", 30)]
    public static readonly int NeedBox3GoguAward;
    [ConfigProperty("FindMinePrice", "FindMinePrice", 1000)]
    public static readonly int FindMinePrice;
    [ConfigProperty("RevivePrice", "RevivePrice", 2500)]
    public static readonly int RevivePrice;
    [ConfigProperty("ResetPrice", "ResetPrice", 5000)]
    public static readonly int ResetPrice;
    [ConfigProperty("resetCount", "resetCount", 5)]
    public static readonly int resetCount;

    private static void smethod_0(Type type_0)
    {
      using (ServiceBussiness serviceBussiness_0 = new ServiceBussiness())
      {
        foreach (FieldInfo field in type_0.GetFields())
        {
          if (field.IsStatic)
          {
            object[] customAttributes = field.GetCustomAttributes(typeof (ConfigPropertyAttribute), false);
            if (customAttributes.Length != 0)
            {
              ConfigPropertyAttribute configPropertyAttribute_0 = (ConfigPropertyAttribute) customAttributes[0];
              field.SetValue((object) null, GameProperties.smethod_2(configPropertyAttribute_0, serviceBussiness_0));
            }
          }
        }
      }
    }

    private static void smethod_1(Type type_0)
    {
      using (ServiceBussiness serviceBussiness_0 = new ServiceBussiness())
      {
        foreach (FieldInfo field in type_0.GetFields())
        {
          if (field.IsStatic)
          {
            object[] customAttributes = field.GetCustomAttributes(typeof (ConfigPropertyAttribute), false);
            if (customAttributes.Length != 0)
              GameProperties.smethod_3((ConfigPropertyAttribute) customAttributes[0], serviceBussiness_0, field.GetValue((object) null));
          }
        }
      }
    }

    private static object smethod_2(
      ConfigPropertyAttribute configPropertyAttribute_0,
      ServiceBussiness serviceBussiness_0)
    {
      string key = configPropertyAttribute_0.Key;
      ServerProperty serverProperty = serviceBussiness_0.GetServerPropertyByKey(key);
      if (serverProperty == null)
      {
        serverProperty = new ServerProperty();
        serverProperty.Name = key;
        serverProperty.Value = configPropertyAttribute_0.DefaultValue.ToString();
        GameProperties.ilog_0.Info((object) ("Cannot find server property " + key + ",keep it default value!"));
        GameProperties.smethod_3(configPropertyAttribute_0, serviceBussiness_0, (object) serverProperty.Value);
      }
      object obj;
      try
      {
        obj = Convert.ChangeType((object) serverProperty.Value, configPropertyAttribute_0.DefaultValue.GetType());
      }
      catch (Exception ex)
      {
        GameProperties.ilog_0.Error((object) "Exception in GameProperties Load: ", ex);
        obj = (object) null;
      }
      return obj;
    }

    private static void smethod_3(
      ConfigPropertyAttribute configPropertyAttribute_0,
      ServiceBussiness serviceBussiness_0,
      object object_0)
    {
      try
      {
        serviceBussiness_0.UpdateServerPropertyByKey(configPropertyAttribute_0.Key, object_0.ToString());
      }
      catch (Exception ex)
      {
        GameProperties.ilog_0.Error((object) "Exception in GameProperties Save: ", ex);
      }
    }

    public static void Refresh()
    {
      GameProperties.ilog_0.Info((object) "Refreshing game properties!");
      GameProperties.smethod_0(typeof (GameProperties));
    }

    public static List<int> getProp(string prop)
    {
      List<int> prop1 = new List<int>();
      string str1 = prop;
      char[] chArray = new char[1]{ '|' };
      foreach (string str2 in str1.Split(chArray))
        prop1.Add(Convert.ToInt32(str2));
      return prop1;
    }

    public static int LimitLevel(int index)
    {
      return Convert.ToInt32(GameProperties.CustomLimit.Split('|')[index]);
    }

    public static List<int> VIPExp() => GameProperties.getProp(GameProperties.VIPExpForEachLv);

    public static List<int> RuneExp() => GameProperties.getProp(GameProperties.RuneLevelUpExp);

    public static int ConsortiaStrengExp(int Lv)
    {
      return GameProperties.getProp(GameProperties.ConsortiaStrengthenEx)[Lv];
    }

    public static int VIPStrengthenExp(int vipLv)
    {
      return GameProperties.getProp(GameProperties.VIPStrengthenEx)[vipLv];
    }

    public static int HoleLevelUpExp(int lv)
    {
      return GameProperties.getProp(GameProperties.HoleLevelUpExpList)[lv];
    }

    public static int[] ConvertStringArrayToIntArray(string str)
    {
      List<int> intList = new List<int>();
      string[] strArray = new string[3]
      {
        "99999",
        "999999",
        "9999999"
      };
      switch (str)
      {
        case null:
          foreach (string str1 in strArray)
            intList.Add(Convert.ToInt32(str1));
          return intList.ToArray();
        case "NewChickenEagleEyePrice":
          strArray = GameProperties.NewChickenEagleEyePrice.Split(',');
          goto default;
        case "NewChickenOpenCardPrice":
          strArray = GameProperties.NewChickenOpenCardPrice.Split(',');
          goto default;
        case "PyramidRevivePrice":
          strArray = GameProperties.PyramidRevivePrice.Split(',');
          goto default;
        default:
          goto case null;
      }
    }

    public static void Save()
    {
      GameProperties.ilog_0.Info((object) "Saving game properties into db!");
    }
  }
}
