package consortion
{
   import consortion.data.ConsortiaApplyInfo;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.data.ConsortiaInventData;
   import consortion.data.ConsortiaLevelInfo;
   import consortion.data.ConsortionPollInfo;
   import consortion.data.ConsortionSkillInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaEventInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ConsortionModel extends EventDispatcher
   {
      
      public static const CONSORTION_MAX_LEVEL:int = 10;
      
      public static const SHOP_MAX_LEVEL:int = 5;
      
      public static const STORE_MAX_LEVEL:int = 10;
      
      public static const BANK_MAX_LEVEL:int = 10;
      
      public static const SKILL_MAX_LEVEL:int = 10;
      
      public static const LEVEL:int = 0;
      
      public static const SHOP:int = 1;
      
      public static const STORE:int = 2;
      
      public static const BANK:int = 3;
      
      public static const SKILL:int = 4;
      
      public static const CONSORTION_SKILL:int = 1;
      
      public static const PERSONAL_SKILL:int = 2;
      
      public static const CLUB:String = "consortiaClub";
      
      public static const SELF_CONSORTIA:String = "selfConsortia";
      
      public static const ConsortionListEachPageNum:int = 6;
      
      public var systemDate:String;
      
      private var _memberList:DictionaryData;
      
      private var _consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsListTotalCount:int;
      
      private var _myApplyList:Vector.<ConsortiaApplyInfo>;
      
      public var applyListTotalCount:int;
      
      private var _inventList:Vector.<ConsortiaInventData>;
      
      public var inventListTotalCount:int;
      
      private var _eventList:Vector.<ConsortiaEventInfo>;
      
      private var _useConditionList:Vector.<ConsortiaAssetLevelOffer>;
      
      private var _dutyList:Vector.<ConsortiaDutyInfo>;
      
      private var _pollList:Vector.<ConsortionPollInfo>;
      
      private var _skillInfoList:Vector.<ConsortionSkillInfo>;
      
      private var _levelUpData:Vector.<ConsortiaLevelInfo>;
      
      public function ConsortionModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function get memberList() : DictionaryData
      {
         if(this._memberList == null)
         {
            this._memberList = new DictionaryData();
         }
         return this._memberList;
      }
      
      public function set memberList(value:DictionaryData) : void
      {
         if(this._memberList == value)
         {
            return;
         }
         this._memberList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBERLIST_COMPLETE));
      }
      
      public function addMember(consortiaPlayerInfo:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(consortiaPlayerInfo.ID,consortiaPlayerInfo);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_ADD,consortiaPlayerInfo));
      }
      
      public function removeMember(consortiaPlayerInfo:ConsortiaPlayerInfo) : void
      {
         this._memberList.remove(consortiaPlayerInfo.ID);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_REMOVE,consortiaPlayerInfo));
      }
      
      public function updataMember(consortiaPlayerInfo:ConsortiaPlayerInfo) : void
      {
         this._memberList.add(consortiaPlayerInfo.ID,consortiaPlayerInfo);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_UPDATA,consortiaPlayerInfo));
      }
      
      public function get consortiaInfo() : Array
      {
         var temp:Array = [];
         var onlineTemp:Array = this.onlineConsortiaMemberList;
         var consortiaInfo:ConsortiaPlayerInfo = new ConsortiaPlayerInfo();
         consortiaInfo.type = 0;
         consortiaInfo.isSelected = true;
         consortiaInfo.RatifierName = "Birlik üyesi[" + onlineTemp.length + "/" + this.memberList.length + "]";
         temp.push(consortiaInfo);
         return temp;
      }
      
      public function get onlineConsortiaMemberList() : Array
      {
         var i:ConsortiaPlayerInfo = null;
         var temp:Array = [];
         for each(i in this.memberList)
         {
            if(i.playerState.StateID != PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function getConsortiaMemberInfo(id:int) : ConsortiaPlayerInfo
      {
         var i:ConsortiaPlayerInfo = null;
         for each(i in this.memberList)
         {
            if(i.ID == id)
            {
               return i;
            }
         }
         return null;
      }
      
      public function get offlineConsortiaMemberList() : Array
      {
         var i:ConsortiaPlayerInfo = null;
         var temp:Array = [];
         for each(i in this.memberList)
         {
            if(i.playerState.StateID == PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function consortiaPlayerStateChange(id:int, state:int) : void
      {
         var playerState:PlayerState = null;
         var _clube_member_info:ConsortiaPlayerInfo = this.getConsortiaMemberInfo(id);
         if(_clube_member_info == null)
         {
            return;
         }
         if(Boolean(_clube_member_info))
         {
            playerState = new PlayerState(state);
            _clube_member_info.playerState = playerState;
            this.updataMember(_clube_member_info);
         }
      }
      
      public function set consortionList(result:Vector.<ConsortiaInfo>) : void
      {
         if(this._consortionList == result)
         {
            return;
         }
         this._consortionList = result;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
      }
      
      public function get consortionList() : Vector.<ConsortiaInfo>
      {
         return this._consortionList;
      }
      
      public function set myApplyList(list:Vector.<ConsortiaApplyInfo>) : void
      {
         if(this._myApplyList == list)
         {
            return;
         }
         this._myApplyList = list;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
      }
      
      public function get myApplyList() : Vector.<ConsortiaApplyInfo>
      {
         return this._myApplyList;
      }
      
      public function getapplyListWithPage(page:int, pageCount:int = 10) : Vector.<ConsortiaApplyInfo>
      {
         page = page < 0 ? 1 : (page > Math.ceil(this._myApplyList.length / pageCount) ? int(Math.ceil(this._myApplyList.length / pageCount)) : page);
         return this.myApplyList.slice((page - 1) * pageCount,page * pageCount);
      }
      
      public function deleteOneApplyRecord(id:int) : void
      {
         var len:int = int(this.myApplyList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.myApplyList[i].ID == id)
            {
               this.myApplyList.splice(i,1);
               dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
               break;
            }
         }
      }
      
      public function set inventList(list:Vector.<ConsortiaInventData>) : void
      {
         if(this._inventList == list)
         {
            return;
         }
         this._inventList = list;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.INVENT_LIST_IS_CHANGE));
      }
      
      public function get inventList() : Vector.<ConsortiaInventData>
      {
         return this._inventList;
      }
      
      public function get eventList() : Vector.<ConsortiaEventInfo>
      {
         return this._eventList;
      }
      
      public function set eventList(value:Vector.<ConsortiaEventInfo>) : void
      {
         if(this._eventList == value)
         {
            return;
         }
         this._eventList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.EVENT_LIST_CHANGE));
      }
      
      public function get useConditionList() : Vector.<ConsortiaAssetLevelOffer>
      {
         return this._useConditionList;
      }
      
      public function set useConditionList(value:Vector.<ConsortiaAssetLevelOffer>) : void
      {
         if(this._useConditionList == value)
         {
            return;
         }
         this._useConditionList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.USE_CONDITION_CHANGE));
      }
      
      public function get dutyList() : Vector.<ConsortiaDutyInfo>
      {
         return this._dutyList;
      }
      
      public function set dutyList(value:Vector.<ConsortiaDutyInfo>) : void
      {
         if(this._dutyList == value)
         {
            return;
         }
         this._dutyList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.DUTY_LIST_CHANGE));
      }
      
      public function changeDutyListName(dutyId:int, name:String) : void
      {
         for(var i:int = 0; i < this._dutyList.length; i++)
         {
            if(this._dutyList[i].DutyID == dutyId)
            {
               this._dutyList[i].DutyName = name;
               break;
            }
         }
      }
      
      public function get pollList() : Vector.<ConsortionPollInfo>
      {
         return this._pollList;
      }
      
      public function set pollList(value:Vector.<ConsortionPollInfo>) : void
      {
         if(this._pollList == value)
         {
            return;
         }
         this._pollList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.POLL_LIST_CHANGE));
      }
      
      public function get skillInfoList() : Vector.<ConsortionSkillInfo>
      {
         return this._skillInfoList;
      }
      
      public function set skillInfoList(value:Vector.<ConsortionSkillInfo>) : void
      {
         if(this._skillInfoList == value)
         {
            return;
         }
         this._skillInfoList = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_LIST_CHANGE));
      }
      
      public function getskillInfoWithTypeAndLevel(type:int, level:int) : Vector.<ConsortionSkillInfo>
      {
         var vec:Vector.<ConsortionSkillInfo> = new Vector.<ConsortionSkillInfo>();
         var len:int = int(this.skillInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.skillInfoList[i].type == type && this.skillInfoList[i].level == level)
            {
               vec.push(this.skillInfoList[i]);
            }
         }
         return vec;
      }
      
      public function getSkillInfoByID(id:int) : ConsortionSkillInfo
      {
         var vec:ConsortionSkillInfo = null;
         for(var i:int = 0; i < this.skillInfoList.length; i++)
         {
            if(this.skillInfoList[i].id == id)
            {
               vec = this.skillInfoList[i];
            }
         }
         return vec;
      }
      
      public function updateSkillInfo(id:int, isopen:Boolean, beginDate:Date, validDate:int) : void
      {
         var len:int = int(this.skillInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.skillInfoList[i].id == id)
            {
               this.skillInfoList[i].isOpen = isopen;
               this.skillInfoList[i].beginDate = beginDate;
               this.skillInfoList[i].validDate = validDate;
               break;
            }
         }
      }
      
      public function hasSomeGroupSkill(group:int, id:int) : Boolean
      {
         var len:int = int(this.skillInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.skillInfoList[i].group == group && this.skillInfoList[i].isOpen && this.skillInfoList[i].id != id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set levelUpData(value:Vector.<ConsortiaLevelInfo>) : void
      {
         if(this._levelUpData == value)
         {
            return;
         }
         this._levelUpData = value;
         dispatchEvent(new ConsortionEvent(ConsortionEvent.LEVEL_UP_RULE_CHANGE));
      }
      
      public function get levelUpData() : Vector.<ConsortiaLevelInfo>
      {
         return this._levelUpData;
      }
      
      public function getLevelData(level:int) : ConsortiaLevelInfo
      {
         if(this.levelUpData == null)
         {
            return null;
         }
         for(var i:uint = 0; i < this.levelUpData.length; i++)
         {
            if(this.levelUpData[i]["Level"] == level)
            {
               return this.levelUpData[i];
            }
         }
         return null;
      }
      
      public function getLevelString(type:int, level:int) : Vector.<String>
      {
         var result:Vector.<String> = new Vector.<String>(4);
         switch(type)
         {
            case LEVEL:
               if(level >= CONSORTION_MAX_LEVEL)
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.explainTxt",this.getLevelData(level).Count);
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.upgrade",this.getLevelData(level).Count);
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel",level + 1,this.getLevelData(level + 1).Count);
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consumeTxt",String(this.getLevelData(level + 1).Riches),this.checkRiches(this.getLevelData(level + 1).Riches),this.getLevelData(level + 1).NeedGold) + this.checkGold(this.getLevelData(level + 1).NeedGold);
               }
               result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               break;
            case SHOP:
               if(level >= SHOP_MAX_LEVEL)
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText") + (level + 1) + LanguageMgr.GetTranslation("grade");
                  result[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (level + 1) * 2 + LanguageMgr.GetTranslation("grade");
                  if(Boolean(this.getLevelData(level + 1)))
                  {
                     result[3] = this.getLevelData(level + 1).ShopRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(level + 1).ShopRiches);
                  }
               }
               break;
            case STORE:
               if(level >= STORE_MAX_LEVEL)
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.store");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.success") + level * 10 + "%";
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.storeSuccess",level + 1,(level + 1) * 10 + "%");
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",level + 1);
                  if(Boolean(this.getLevelData(level + 1)))
                  {
                     result[3] = this.getLevelData(level + 1).SmithRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(level + 1).SmithRiches);
                  }
               }
               break;
            case BANK:
               if(level >= BANK_MAX_LEVEL)
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.bank");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.contentUpgrade",level * 10);
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.contentSmith",level + 1,(level + 1) * 10);
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.appealTxt",level + 1);
                  if(Boolean(this.getLevelData(level + 1)))
                  {
                     result[3] = this.getLevelData(level + 1).StoreRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(level + 1).StoreRiches);
                  }
               }
               break;
            case SKILL:
               if(level >= SKILL_MAX_LEVEL)
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                  result[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
               }
               else
               {
                  result[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill.explainTxt");
                  result[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.skill",level + 1);
                  result[2] = LanguageMgr.GetTranslation("consortia.upgrade") + (level + 1) + LanguageMgr.GetTranslation("grade");
                  if(Boolean(this.getLevelData(level + 1)))
                  {
                     result[3] = this.getLevelData(level + 1).BufferRiches + LanguageMgr.GetTranslation("consortia.Money") + this.checkRiches(this.getLevelData(level + 1).BufferRiches);
                  }
               }
         }
         return result;
      }
      
      public function checkConsortiaRichesForUpGrade(type:int) : Boolean
      {
         var riches:int = PlayerManager.Instance.Self.consortiaInfo.Riches;
         switch(type)
         {
            case 0:
               if(PlayerManager.Instance.Self.consortiaInfo.Level < CONSORTION_MAX_LEVEL)
               {
                  if(riches < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level + 1).Riches)
                  {
                     return false;
                  }
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel < SHOP_MAX_LEVEL)
               {
                  if(riches < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1).ShopRiches)
                  {
                     return false;
                  }
               }
               break;
            case 3:
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < BANK_MAX_LEVEL)
               {
                  if(riches < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1).StoreRiches)
                  {
                     return false;
                  }
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel < STORE_MAX_LEVEL)
               {
                  if(riches < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.SmithLevel + 1).SmithRiches)
                  {
                     return false;
                  }
               }
               break;
            case 4:
               if(PlayerManager.Instance.Self.consortiaInfo.BufferLevel < SKILL_MAX_LEVEL)
               {
                  if(riches < this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.BufferLevel + 1).BufferRiches)
                  {
                     return false;
                  }
               }
         }
         return true;
      }
      
      private function checkRiches($riches:int) : String
      {
         var result:String = "";
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < $riches)
         {
            result = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return result;
      }
      
      private function checkGold($gold:int) : String
      {
         var result:String = "";
         if(PlayerManager.Instance.Self.Gold < $gold)
         {
            result = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
         }
         return result;
      }
   }
}

