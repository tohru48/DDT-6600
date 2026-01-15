package ddt.manager
{
   import ddt.data.ServerConfigInfo;
   import ddt.data.analyze.ServerConfigAnalyz;
   import dragonBoat.DragonBoatManager;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class ServerConfigManager
   {
      
      private static var _instance:ServerConfigManager;
      
      private static var privileges:Dictionary;
      
      public static const MARRT_ROOM_CREATE_MONET:String = "MarryRoomCreateMoney";
      
      public static const PRICE_DIVORCED:String = "DivorcedMoney";
      
      public static const PRICE_DIVORCED_DISCOUNT:String = "DivorcedDiscountMoney";
      
      public static const MISSION_RICHES:String = "MissionRiches";
      
      public static const VIP_RATE_FOR_GP:String = "VIPRateForGP";
      
      public static const VIP_QUEST_STAR:String = "VIPQuestStar";
      
      public static const VIP_LOTTERY_COUNT_MAX_PER_DAY:String = "VIPLotteryCountMaxPerDay";
      
      public static const VIP_TAKE_CARD_DISCOUNT:String = "VIPTakeCardDisCount";
      
      public static const VIP_EXP_NEEDEDFOREACHLV:String = "VIPExpForEachLv";
      
      public static const HOT_SPRING_EXP:String = "HotSpringExp";
      
      public static const VIP_STRENGTHEN_EX:String = "VIPStrengthenEx";
      
      public static const CONSORTIA_STRENGTHEN_EX:String = "ConsortiaStrengthenEx";
      
      public static const VIPEXTTRA_BIND_MOMEYUPPER:String = "VIPExtraBindMoneyUpper";
      
      public static const AWARD_MAX_MONEY:String = "AwardMaxMoney";
      
      public static const VIP_RENEWAL_PRIZE:String = "VIPRenewalPrize";
      
      public static const VIP_DAILY_PACK:String = "VIPDailyPackID";
      
      public static const VIP_PRIVILEGE:String = "VIPPrivilege";
      
      public static const VIP_PAYAIMENERGY:String = "VIPPayAimEnergy";
      
      public static const PAYAIMENERGY:String = "PayAimEnergy";
      
      public static const VIP_QUEST_FINISH_DIRECT:String = "VIPQuestFinishDirect";
      
      public static const CARD_RESETSOUL_VALUE_CARD:String = "CardResetSoulValue";
      
      public static const CARD_GROOVE_REVERT:String = "CardGrooveRevert";
      
      public static const PLAYER_MIN_LEVEL:String = "PlayerMinLevel";
      
      public static const BEAD_UPGRADE_EXP:String = "RuneLevelUpExp";
      
      public static const REQUEST_BEAD_PRICE:String = "OpenRunePackageMoney";
      
      public static const BEAD_HOLE_UP_EXP:String = "HoleLevelUpExpList";
      
      public static const DRAGON_BOAT_BUILD_STAGE:String = "DragonBoatBuildStage";
      
      public static const DRAGON_BOAT_FAST_TIME:String = "DragonBoatFastTime";
      
      public static const CREATE_GUILD:String = "CreateGuild";
      
      public static const TRANSFER_STRENGTHENEX:String = "MustTransferGold";
      
      public static const AUCTION_RATE:String = "Cess";
      
      public static const STORE_MUSTINLAYGOLD:String = "MustInlayGold";
      
      public static const PET_SCORE_ENABLE:String = "IsOpenPetScore";
      
      public static const TAKECARDMONEY:String = "TakeCardMoney";
      
      public static const WARRIORFAMRAIDPRICEPERMIN:String = "WarriorFamRaidPricePerMin";
      
      public static const BUYCARDSOULVALUEMONEY:String = "BuyCardSoulValueMoney";
      
      public static const PYRAMIDTOPPOINT:String = "PyramidTopPoint";
      
      public static const TOTEMPROPMONEYOFFSET:String = "TotemPropMoneyOffset";
      
      public static const PROMOTEPACKAGEPRICE:String = "PromotePackagePrice";
      
      public static const ISPROMOTEPACKAGEOPEN:String = "IsPromotePackageOpen";
      
      public static const ENTERTAINMENT_SCORE:String = "EntertainmentScore";
      
      public static const RECREATIONPVPREFRESHPROP_BINDMONEY:String = "RecreationPvpRefreshPropBindMoney";
      
      public static const RECREATIONPVP_MINLEVEL:String = "RecreationPvpMinLevel";
      
      public static const RECREATIONPK_REMOVE_MONEY:String = "RecreationPkRemoveMoney";
      
      public static const RECREATIONPK_ADD_MONEY:String = "RecreationPkAddMoney";
      
      public static const WORSHIPMOONBEGINDATE:String = "WorshipMoonBeginDate";
      
      public static const WORSHIPMOONENDDATE:String = "WorshipMoonEndDate";
      
      public static const WITCHBLESSDOUBLEGPTIME:String = "WitchBlessDoubleGpTime";
      
      public static const RESCUE_CLEAN_CD_PRICE:String = "HelpGameCleanCDPrice";
      
      public static const RESCUE_SHOPITEM_PRICE:String = "HelpGameBuffPrice";
      
      public static const YEARFOODITEMCOUNT:String = "YearFoodItemsCount";
      
      public static const YEARFOODITEMS:String = "YearFoodItems";
      
      public static const YEARFOODITEMPRICES:String = "YearFoodItemPrices";
      
      public static const VIPREWARDCRYPTCOUNT:String = "VIPRewardCryptCount";
      
      public static const MAGICSTONECOSTITEM:String = "MagicStoneCostItem";
      
      public static const PRIVILEGE_CANBUYFERT:String = "8";
      
      public static const PRIVILEGE_LOTTERYNOTIME:String = "13";
      
      public static const LIGHTROAD_MINLEVEL:String = "GoodsCollectMinLevel";
      
      public static const CONSORTIA_MATCH_START_TIME:String = "ConsortiaMatchStartTime";
      
      public static const CONSORTIA_MATCH_END_TIME:String = "ConsortiaMatchEndTime";
      
      public static const LOCAL_CONSORTIA_MATCH_DAYS:String = "LocalConsortiaMatchDays";
      
      public static const AREA_CONSORTIA_MATCH_DAYS:String = "AreaConsortiaMatchDays";
      
      public static const ISCHICKENACTIVEKEYOPEN:String = "IsChickenActiveKeyOpen";
      
      public static const CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE:String = "ChickenActiveKeyLvAwardNeedPrestige";
      
      public static const DRAGONBOAT_PROP:String = "DragonBoatProp";
      
      public static const DEED_PRICES:String = "DanDanBuffPrice";
      
      public static const HALLOWEEN_MINNUM:String = "HalloweenMinNum";
      
      public static const HALLOWEEN_BEGINDATE:String = "HalloweenBeginDate";
      
      public static const HALLOWEEN_ENDDATE:String = "HalloweenEndDate";
      
      public static const EVERYDAYOPENPRICE:String = "EveryDayOpenPrice";
      
      public static const WITCH_BLESS_GP:String = "WitchBlessGP";
      
      public static const WITCH_BLESS_DOUBLEGP_TIME:String = "WitchBlessDoubleGpTime";
      
      public static const WITCH_BLESS_MONEY:String = "WithcBlessMoney";
      
      public static const HORSERACE_MAXCOUNT:String = "HorseGameEachDayMaxCount";
      
      public static const HORSERACE_PINGZHANGMONEY:String = "HorseGameUsePapawMoney";
      
      public static const HORSEGAMEBUFFCONFIG:String = "HorseGameBuffConfig";
      
      private var _serverConfigInfoList:DictionaryData;
      
      private var _BindMoneyMax:Array;
      
      private var _VIPExtraBindMoneyUpper:Array;
      
      private var _activityEnterNum:int;
      
      private var _consortiaTaskDelayInfo:Array;
      
      private var _dailyRewardIDForMonth:Array;
      
      private var _cryptBossOpenDay:Array;
      
      public function ServerConfigManager()
      {
         super();
      }
      
      public static function get instance() : ServerConfigManager
      {
         if(_instance == null)
         {
            _instance = new ServerConfigManager();
         }
         return _instance;
      }
      
      public function getserverConfigInfo(analyzer:ServerConfigAnalyz) : void
      {
         this._serverConfigInfoList = analyzer.serverConfigInfoList;
         this._BindMoneyMax = this._serverConfigInfoList["BindMoneyMax"].Value.split("|");
         this._VIPExtraBindMoneyUpper = this._serverConfigInfoList["VIPExtraBindMoneyUpper"].Value.split("|");
         this._activityEnterNum = this._serverConfigInfoList["QXGameLimitCount"].Value;
         this._dailyRewardIDForMonth = this._serverConfigInfoList["DailyRewardIDForMonth"].Value.split("|");
         this._cryptBossOpenDay = this._serverConfigInfoList["CryptBossOpenDay"].Value.split("|");
         var tmp:Array = this._serverConfigInfoList["ConsortiaMissionAddTime"].Value.split("|");
         var len:int = int(tmp.length);
         this._consortiaTaskDelayInfo = [];
         for(var i:int = 0; i < len; i++)
         {
            this._consortiaTaskDelayInfo.push(tmp[i].split(","));
         }
      }
      
      public function get cryptBossOpenDay() : Array
      {
         return this._cryptBossOpenDay;
      }
      
      public function get serverConfigInfo() : DictionaryData
      {
         return this._serverConfigInfoList;
      }
      
      public function get consortiaTaskDelayInfo() : Array
      {
         return this._consortiaTaskDelayInfo;
      }
      
      public function getBindBidLimit(level:int, vipLevel:int = 0) : int
      {
         var levelMax:int = level % 10 == 0 ? int(this._BindMoneyMax[int(level / 10) - 1]) : int(this._BindMoneyMax[int(level / 10)]);
         var vipLevelMax:int = 0;
         if(PlayerManager.Instance.Self.IsVIP && vipLevel > 0)
         {
            vipLevelMax = int(this._VIPExtraBindMoneyUpper[vipLevel - 1]);
         }
         return levelMax + vipLevelMax;
      }
      
      public function get PayAimEnergy() : int
      {
         return int(this.findInfoByName(ServerConfigManager.PAYAIMENERGY).Value);
      }
      
      public function get VIPPayAimEnergy() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_PAYAIMENERGY).Value.split("|");
      }
      
      public function get weddingMoney() : Array
      {
         return this.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
      }
      
      public function get divorcedMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.PRICE_DIVORCED).Value;
      }
      
      public function get firstDivorcedMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.PRICE_DIVORCED_DISCOUNT).Value;
      }
      
      public function get MissionRiches() : Array
      {
         return this.findInfoByName(ServerConfigManager.MISSION_RICHES).Value.split("|");
      }
      
      public function get VIPExpNeededForEachLv() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_EXP_NEEDEDFOREACHLV).Value.split("|");
      }
      
      public function get CardRestSoulValue() : String
      {
         return this.findInfoByName(ServerConfigManager.CARD_RESETSOUL_VALUE_CARD).Value;
      }
      
      public function get cardResetCardSoulMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.CARD_GROOVE_REVERT).Value;
      }
      
      public function get VIPExtraBindMoneyUpper() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIPEXTTRA_BIND_MOMEYUPPER).Value.split("|");
      }
      
      public function get HotSpringExp() : Array
      {
         return this.findInfoByName(ServerConfigManager.HOT_SPRING_EXP).Value.split(",");
      }
      
      public function findInfoByName(name:String) : ServerConfigInfo
      {
         return this._serverConfigInfoList[name];
      }
      
      public function get CreateGuild() : int
      {
         return 100000;
      }
      
      public function get TransferStrengthenEx() : String
      {
         return this.findInfoByName(TRANSFER_STRENGTHENEX).Value;
      }
      
      public function get AuctionRate() : String
      {
         return String(Number(this.findInfoByName(AUCTION_RATE).Value) * 100);
      }
      
      public function get VIPStrengthenEx() : Array
      {
         var obj:Object = this.findInfoByName(VIP_STRENGTHEN_EX);
         if(Boolean(obj))
         {
            return this.findInfoByName(VIP_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function ConsortiaStrengthenEx() : Array
      {
         var obj:Object = this.findInfoByName(CONSORTIA_STRENGTHEN_EX);
         if(Boolean(obj))
         {
            return this.findInfoByName(CONSORTIA_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function get RouletteMaxTicket() : String
      {
         return this.findInfoByName(ServerConfigManager.AWARD_MAX_MONEY).Value;
      }
      
      public function get VIPRenewalPrice() : Array
      {
         var obj:Object = this.findInfoByName(VIP_RENEWAL_PRIZE);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function get VIPRateForGP() : Array
      {
         var obj:Object = this.findInfoByName(VIP_RATE_FOR_GP);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestStar() : Array
      {
         var obj:Object = this.findInfoByName(VIP_QUEST_STAR);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function get VIPLotteryCountMaxPerDay() : Array
      {
         var obj:Object = this.findInfoByName(VIP_LOTTERY_COUNT_MAX_PER_DAY);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function get VIPTakeCardDisCount() : Array
      {
         var obj:Object = this.findInfoByName(VIP_TAKE_CARD_DISCOUNT);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestFinishDirect() : Array
      {
         return this.analyzeData(VIP_QUEST_FINISH_DIRECT);
      }
      
      public function analyzeData(field:String) : Array
      {
         var obj:Object = this.findInfoByName(field);
         if(Boolean(obj))
         {
            return String(obj.Value).split("|");
         }
         return null;
      }
      
      public function getPrivilegeString(level:int) : String
      {
         var obj:Object = this.findInfoByName(VIP_PRIVILEGE);
         if(Boolean(obj))
         {
            return String(obj.Value);
         }
         return null;
      }
      
      public function get VIPDailyPack() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_DAILY_PACK).Value.split("|");
      }
      
      public function getPrivilegeMinLevel(type:String) : int
      {
         var obj:Object = null;
         var level:int = 0;
         var arr:Array = null;
         var s:String = null;
         var p:String = null;
         if(privileges == null)
         {
            obj = this.findInfoByName(VIP_PRIVILEGE);
            level = 1;
            arr = String(obj.Value).split("|");
            privileges = new Dictionary();
            for each(s in arr)
            {
               for each(p in s.split(","))
               {
                  privileges[p] = level;
               }
               level++;
            }
         }
         return int(privileges[type]);
      }
      
      public function getBeadUpgradeExp() : DictionaryData
      {
         var o:int = 0;
         var vResultDic:DictionaryData = new DictionaryData();
         var vArray:Array = this.findInfoByName(BEAD_UPGRADE_EXP).Value.split("|");
         var vLv:int = 1;
         for each(o in vArray)
         {
            vResultDic.add(vLv,o);
            vLv++;
         }
         return vResultDic;
      }
      
      public function getRequestBeadPrice() : Array
      {
         return this.findInfoByName(REQUEST_BEAD_PRICE).Value.split("|");
      }
      
      public function getBeadHoleUpExp() : Array
      {
         return this.findInfoByName(BEAD_HOLE_UP_EXP).Value.split("|");
      }
      
      public function get minOpenPetSystemLevel() : int
      {
         var obj:Object = this.findInfoByName(PLAYER_MIN_LEVEL);
         return int(obj.Value);
      }
      
      public function get magicStoneCostItemNum() : int
      {
         var obj:Object = this.findInfoByName(MAGICSTONECOSTITEM);
         return int(obj.Value);
      }
      
      public function get storeMustinlaygold() : int
      {
         return int(this.findInfoByName(STORE_MUSTINLAYGOLD).Value);
      }
      
      public function get petScoreEnable() : Boolean
      {
         var obj:ServerConfigInfo = this.findInfoByName(PET_SCORE_ENABLE);
         if(Boolean(obj))
         {
            return obj.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get TakeCardMoney() : Number
      {
         return Number(this.findInfoByName(TAKECARDMONEY).Value);
      }
      
      public function get WarriorFamRaidPricePerMin() : Number
      {
         return Number(this.findInfoByName(WARRIORFAMRAIDPRICEPERMIN).Value);
      }
      
      public function get buyCardSoulValueMoney() : Number
      {
         var obj:ServerConfigInfo = this.findInfoByName(BUYCARDSOULVALUEMONEY);
         if(Boolean(obj))
         {
            return Number(obj.Value);
         }
         return 500;
      }
      
      public function get pyramidTopMinMaxPoint() : Array
      {
         var tempArr:Array = null;
         var obj:ServerConfigInfo = this.findInfoByName(PYRAMIDTOPPOINT);
         if(Boolean(obj))
         {
            tempArr = obj.Value.split("|");
            return new Array(tempArr[0],tempArr[tempArr.length - 1]);
         }
         return new Array(0,0);
      }
      
      public function get totemSignDiscount() : Number
      {
         var obj:ServerConfigInfo = this.findInfoByName(TOTEMPROPMONEYOFFSET);
         if(Boolean(obj))
         {
            return Number(obj.Value);
         }
         return 40;
      }
      
      public function get growthPackagePrice() : Number
      {
         var obj:ServerConfigInfo = this.findInfoByName(PROMOTEPACKAGEPRICE);
         if(Boolean(obj))
         {
            return Number(obj.Value);
         }
         return 0;
      }
      
      public function get growthPackageIsOpen() : Boolean
      {
         var obj:ServerConfigInfo = this.findInfoByName(ISPROMOTEPACKAGEOPEN);
         if(Boolean(obj))
         {
            return obj.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function entertainmentScore() : Array
      {
         var obj:ServerConfigInfo = this.findInfoByName(ENTERTAINMENT_SCORE);
         return obj.Value.split(",");
      }
      
      public function entertainmentPrice() : int
      {
         var _info:ServerConfigInfo = this.findInfoByName(RECREATIONPVPREFRESHPROP_BINDMONEY);
         if(Boolean(_info))
         {
            return int(_info.Value);
         }
         return 0;
      }
      
      public function entertainmentLevel() : int
      {
         return int(this.findInfoByName(RECREATIONPVP_MINLEVEL).Value);
      }
      
      public function get worshipMoonBeginDate() : String
      {
         return this.findInfoByName(WORSHIPMOONBEGINDATE).Value;
      }
      
      public function get worshipMoonEndDate() : String
      {
         return this.findInfoByName(WORSHIPMOONENDDATE).Value;
      }
      
      public function get witchBlessDoubleGpTime() : int
      {
         return int(this.findInfoByName(WITCHBLESSDOUBLEGPTIME).Value);
      }
      
      public function entertainmentPkCostMoney() : int
      {
         return int(this.findInfoByName(RECREATIONPK_REMOVE_MONEY).Value);
      }
      
      public function entertainmentPkAddMoney() : int
      {
         return int(this.findInfoByName(RECREATIONPK_ADD_MONEY).Value);
      }
      
      public function entertainmentTime() : String
      {
         var _dateOpen:Date = null;
         var _dateEnd:Date = null;
         var day:String = null;
         var str:String = null;
         var infoOpen:ServerConfigInfo = this.findInfoByName("RecreationPvpBeginDate");
         var infoEnd:ServerConfigInfo = this.findInfoByName("RecreationPvpEndDate");
         if(Boolean(infoOpen) && Boolean(infoEnd))
         {
            _dateOpen = DateUtils.getDateByStr(infoOpen.Value);
            _dateEnd = DateUtils.getDateByStr(infoEnd.Value);
            day = infoOpen.Value.split(" ")[0];
            return day + " " + _dateOpen.hours + ":" + (_dateOpen.minutes < 10 ? "0" + String(_dateOpen.minutes) : _dateOpen.minutes) + "-" + _dateEnd.hours + ":" + (_dateEnd.minutes < 10 ? "0" + String(_dateEnd.minutes) : _dateEnd.minutes);
         }
         return " ";
      }
      
      public function get lightRoadLevel() : int
      {
         return int(this.findInfoByName(LIGHTROAD_MINLEVEL).Value);
      }
      
      public function get activityEnterNum() : int
      {
         return this._activityEnterNum;
      }
      
      public function get dailyRewardIDForMonth() : Array
      {
         return this._dailyRewardIDForMonth;
      }
      
      public function get christmasGiftGetTime() : String
      {
         return "";
      }
      
      public function get isMissionEnergyEnable() : Boolean
      {
         var enable:String = null;
         var name:String = null;
         var value:Boolean = false;
         var info:ServerConfigInfo = this.findInfoByName("IsMissionEnergyEnable");
         if(Boolean(info))
         {
            enable = info.Value;
            name = info.Name;
            return String(enable).toLowerCase() == "false" ? false : true;
         }
         return false;
      }
      
      public function get consortiaMatchStartTime() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_START_TIME);
         return info.Value.split(" ")[1].toString().split(":");
      }
      
      public function get consortiaMatchEndTime() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_END_TIME);
         return info.Value.split(" ")[1].toString().split(":");
      }
      
      public function get localConsortiaMatchDays() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(LOCAL_CONSORTIA_MATCH_DAYS);
         return info.Value.split("|");
      }
      
      public function get areaConsortiaMatchDays() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(AREA_CONSORTIA_MATCH_DAYS);
         return info.Value.split("|");
      }
      
      public function get chickActivationIsOpen() : Boolean
      {
         var obj:ServerConfigInfo = this.findInfoByName(ISCHICKENACTIVEKEYOPEN);
         if(Boolean(obj))
         {
            return obj.Value.toLowerCase() == "true";
         }
         return false;
      }
      
      public function get chickenActiveKeyLvAwardNeedPrestige() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE);
         if(Boolean(info))
         {
            return info.Value.split("|");
         }
         return null;
      }
      
      public function get isTanabataTreasure() : Boolean
      {
         var info:ServerConfigInfo = this.findInfoByName("IsTanabataTreasure");
         var enable:String = info.Value;
         var name:String = info.Name;
         return String(enable) == "0" ? false : true;
      }
      
      public function get getDragonboatProp() : int
      {
         var info:ServerConfigInfo = this.findInfoByName(DRAGONBOAT_PROP);
         if(Boolean(info))
         {
            return int(info.Value);
         }
         return DragonBoatManager.DRAGONBOAT_CHIP;
      }
      
      public function get getDeedPrices() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(DEED_PRICES);
         if(Boolean(info))
         {
            return info.Value.split(",");
         }
         return [1399];
      }
      
      public function get getHalloweenMinNum() : String
      {
         var info:ServerConfigInfo = this.findInfoByName(HALLOWEEN_MINNUM);
         if(Boolean(info))
         {
            return String(info.Value);
         }
         return "";
      }
      
      public function get getHalloweenBeginDate() : String
      {
         var info:ServerConfigInfo = this.findInfoByName(HALLOWEEN_BEGINDATE);
         if(Boolean(info))
         {
            return String(info.Value);
         }
         return "";
      }
      
      public function get getHalloweenEndDate() : String
      {
         var info:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(info))
         {
            return String(info.Value);
         }
         return "";
      }
      
      public function get getHalloweenDateEnd() : Date
      {
         var _dateEnd:Date = null;
         var info:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(info))
         {
            return DateUtils.getDateByStr(info.Value);
         }
         return null;
      }
      
      public function get getEveryDayOpenPrice() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(EVERYDAYOPENPRICE);
         if(Boolean(info))
         {
            return info.Value.split("|");
         }
         return [];
      }
      
      public function getDragonBoatBuildStage(type:int) : Array
      {
         return this.findInfoByName(DRAGON_BOAT_BUILD_STAGE + type).Value.split("|");
      }
      
      public function get dragonBoatFastTime() : int
      {
         return int(this.findInfoByName(DRAGON_BOAT_FAST_TIME).Value);
      }
      
      public function get getWitchBlessGP() : Array
      {
         return this.findInfoByName(WITCH_BLESS_GP).Value.split("|");
      }
      
      public function get getWitchBlessItemId() : String
      {
         return this.findInfoByName("WitchBlessTemplateId").Value;
      }
      
      public function get getWitchBlessDoubleGpTime() : String
      {
         return String(this.findInfoByName(WITCH_BLESS_DOUBLEGP_TIME).Value);
      }
      
      public function get magpieBridgeCountPrice() : int
      {
         return int(this.findInfoByName("TanabataActivePrice").Value);
      }
      
      public function get rescueShopItemPrice() : Array
      {
         return this.findInfoByName(RESCUE_SHOPITEM_PRICE).Value.split("|");
      }
      
      public function get getWitchBlessMoney() : int
      {
         return int(this.findInfoByName(WITCH_BLESS_MONEY).Value);
      }
      
      public function get rescueCleanCDPrice() : Array
      {
         return this.findInfoByName(RESCUE_CLEAN_CD_PRICE).Value.split("|");
      }
      
      public function get catchInsectBeginTime() : Array
      {
         return this._serverConfigInfoList["SummerAcitveBeginTime"].Value.split(" ");
      }
      
      public function get catchInsectEndTime() : Array
      {
         return this._serverConfigInfoList["SummerAcitveEndTime"].Value.split(" ");
      }
      
      public function get catchInsectPrizeInfo() : Array
      {
         return this._serverConfigInfoList["SummerAcitveGifts"].Value.split("|");
      }
      
      public function get catchInsectLocalTitle() : Array
      {
         return this._serverConfigInfoList["SummerAcitveTitle"].Value.split("|");
      }
      
      public function get catchInsectAreaTitle() : Array
      {
         return this._serverConfigInfoList["AreaSummerAcitveTitle"].Value.split("|");
      }
      
      public function get magicHouseJuniorAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomJuniorAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseMidAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomMidAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseSeniorAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomSeniorAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseJuniorWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomJuniorWeaponList"].Value.split("|");
      }
      
      public function get magicHouseMidWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomMidWeaponList"].Value.split("|");
      }
      
      public function get magicHouseSeniorWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomSeniorWeaponList"].Value.split("|");
      }
      
      public function get magicHouseBoxNeedMonry() : int
      {
         return this._serverConfigInfoList["MagicRoomBoxNeedMoney"].Value;
      }
      
      public function get magicHouseOpenDepotNeedMoney() : int
      {
         return this._serverConfigInfoList["MagicRoomOpenNeedMoney"].Value.split("|")[0];
      }
      
      public function get magicHouseDepotPromoteNeedMoney() : int
      {
         return this._serverConfigInfoList["MagicRoomOpenNeedMoney"].Value.split("|")[1];
      }
      
      public function get magicHouseLevelUpNumber() : Array
      {
         return this._serverConfigInfoList["MagicRoomLevelUpCount"].Value.split("|");
      }
      
      public function get treasureLostPowerPrice() : Array
      {
         return this._serverConfigInfoList["TreasureHuntEnergyPrice"].Value.split(",");
      }
      
      public function get treasureLostGolidDicePrice() : Array
      {
         return this._serverConfigInfoList["TreasureHuntDicePrice"].Value.split(",");
      }
      
      public function get localYearFoodItemsCount() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(YEARFOODITEMCOUNT);
         return info.Value.split("|");
      }
      
      public function get localYearFoodItems() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(YEARFOODITEMS);
         return info.Value.split(",");
      }
      
      public function get localYearFoodItemsPrices() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(YEARFOODITEMPRICES);
         return info.Value.split(",");
      }
      
      public function get localVIPRewardCryptCount() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(VIPREWARDCRYPTCOUNT);
         return info.Value.split("|");
      }
      
      public function get zodiacAddPrice() : int
      {
         return this._serverConfigInfoList["ConstellationExtraSpendMoney"].Value;
      }
      
      public function get HorseGameEachDayMaxCount() : int
      {
         return this._serverConfigInfoList["HorseGameEachDayMaxCount"].Value;
      }
      
      public function get HorseGameUsePapawMoney() : int
      {
         return this._serverConfigInfoList["HorseGameUsePapawMoney"].Value;
      }
      
      public function get HorseGameCostMoneyCount() : int
      {
         return this._serverConfigInfoList["HorseGameCostMoneyCount"].Value;
      }
      
      public function get horseGameBuffConfig() : Array
      {
         var info:ServerConfigInfo = this.findInfoByName(HORSEGAMEBUFFCONFIG);
         return info.Value.split("|");
      }
   }
}

