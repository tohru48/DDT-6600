package ddt.data.quest
{
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   import com.pickgliss.utils.StringUtils;
   import consortion.ConsortionModelControl;
   import dayActivity.DayActivityManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import horse.HorseManager;
   import quest.TrusteeshipManager;
   import road7th.utils.DateUtils;
   
   public class QuestInfo implements INotSameHeightListCellData
   {
      
      public static const PET:int = 0;
      
      public var QuestID:int;
      
      public var data:QuestDataInfo;
      
      public var Detail:String;
      
      public var Objective:String;
      
      public var otherCondition:int;
      
      public var Level:int;
      
      public var NeedMinLevel:int;
      
      public var NeedMaxLevel:int;
      
      public var required:Boolean = false;
      
      public var Type:int;
      
      public var PreQuestID:String;
      
      public var NextQuestID:String;
      
      public var CanRepeat:Boolean;
      
      public var RepeatInterval:int;
      
      public var RepeatMax:int;
      
      public var Title:String;
      
      public var disabled:Boolean = false;
      
      public var optionalConditionNeed:uint = 0;
      
      public var _conditions:Array;
      
      private var _itemRewards:Array;
      
      public var StrengthenLevel:int;
      
      public var FinishCount:int;
      
      public var ReqItemID:int;
      
      public var ReqKillLevel:int;
      
      public var ReqBeCaption:Boolean;
      
      public var ReqMap:int;
      
      public var ReqFightMode:int;
      
      public var ReqTimeMode:int;
      
      public var RewardGold:int;
      
      public var RewardMoney:int;
      
      public var RewardGP:int;
      
      public var OneKeyFinishNeedMoney:int;
      
      public var TrusteeshipCost:int;
      
      public var TrusteeshipNeedTime:int;
      
      public var RewardOffer:int;
      
      public var RewardRiches:int;
      
      public var RewardBindMoney:int;
      
      public var RewardBuffID:int;
      
      public var RewardBuffDate:int;
      
      public var Rank:String;
      
      public var Level2NeedMoney:int;
      
      public var Level3NeedMoney:int;
      
      public var Level4NeedMoney:int;
      
      public var Level5NeedMoney:int;
      
      public var MapID:int;
      
      public var AutoEquip:Boolean;
      
      public var StarLev:int;
      
      private var _questLevel:int;
      
      public var TimeLimit:Boolean;
      
      public var StartDate:Date;
      
      public var EndDate:Date;
      
      public var BuffID:int;
      
      public var BuffValidDate:int;
      
      public var isManuGet:Boolean;
      
      private var _cellHeight:Number = 0;
      
      public function QuestInfo()
      {
         super();
      }
      
      public static function createFromXML(xml:XML) : QuestInfo
      {
         var tempCondXML:XML = null;
         var tempCondition:QuestCondition = null;
         var tempItemXML:XML = null;
         var countAryy:Array = null;
         var tempReward:QuestItemReward = null;
         var q:QuestInfo = new QuestInfo();
         q.QuestID = xml.@ID;
         q.Type = xml.@QuestID;
         q.Detail = xml.@Detail;
         q.Title = xml.@Title;
         q.Objective = xml.@Objective;
         q.StarLev = xml.@StarLev;
         q.QuestLevel = xml.@QuestLevel;
         q.NeedMinLevel = xml.@NeedMinLevel;
         q.NeedMaxLevel = xml.@NeedMaxLevel;
         q.PreQuestID = xml.@PreQuestID;
         q.NextQuestID = xml.@NextQuestID;
         q.CanRepeat = xml.@CanRepeat == "true" ? true : false;
         q.RepeatInterval = xml.@RepeatInterval;
         q.RepeatMax = xml.@RepeatMax;
         q.RewardGold = xml.@RewardGold;
         q.RewardGP = xml.@RewardGP;
         q.RewardMoney = xml.@RewardMoney;
         q.OneKeyFinishNeedMoney = xml.@OneKeyFinishNeedMoney;
         q.TrusteeshipCost = xml.@CollocationCost;
         q.TrusteeshipNeedTime = xml.@CollocationColdTime;
         q.Rank = xml.@Rank;
         q.RewardOffer = xml.@RewardOffer;
         q.RewardRiches = xml.@RewardRiches;
         q.RewardBindMoney = xml.@RewardBindMoney;
         q.TimeLimit = xml.@TimeMode;
         q.RewardBuffID = xml.@RewardBuffID;
         q.RewardBuffDate = xml.@RewardBuffDate;
         q.Level2NeedMoney = xml.@Level2NeedMoney;
         q.Level3NeedMoney = xml.@Level3NeedMoney;
         q.Level4NeedMoney = xml.@Level4NeedMoney;
         q.Level5NeedMoney = xml.@Level5NeedMoney;
         q.otherCondition = xml.@IsOther;
         q.StartDate = DateUtils.decodeDated(String(xml.@StartDate));
         q.EndDate = DateUtils.decodeDated(String(xml.@EndDate));
         q.MapID = xml.@MapID;
         q.AutoEquip = StringUtils.converBoolean(xml.@AutoEquip);
         q.optionalConditionNeed = xml.@NotMustCount;
         q.isManuGet = xml.@IsAccept == "true" ? true : false;
         var conditions:XMLList = xml..Item_Condiction;
         for(var i:int = 0; i < conditions.length(); i++)
         {
            tempCondXML = conditions[i];
            tempCondition = new QuestCondition(q.QuestID,tempCondXML.@CondictionID,tempCondXML.@CondictionType,tempCondXML.@CondictionTitle,tempCondXML.@Para1,tempCondXML.@Para2);
            if(tempCondXML.@isOpitional == "true")
            {
               tempCondition.isOpitional = true;
            }
            else
            {
               tempCondition.isOpitional = false;
            }
            switch(tempCondition.type)
            {
               case 1:
                  TaskManager.instance.addGradeListener();
                  break;
               case 2:
               case 14:
               case 15:
               case 99:
                  TaskManager.instance.addItemListener(tempCondition.param);
                  break;
               case 18:
                  break;
               case 20:
                  switch(tempCondition.param)
                  {
                     case 1:
                        if(!q.isTimeOut())
                        {
                           TaskManager.instance.addDesktopListener(tempCondition);
                        }
                        break;
                     case 2:
                        TaskManager.instance.addAnnexListener(tempCondition);
                        break;
                     case 3:
                        TaskManager.instance.addFriendListener(tempCondition);
                        break;
                     case 4:
                  }
                  break;
            }
            q.addCondition(tempCondition);
         }
         var rewards:XMLList = xml..Item_Good;
         for(var j:int = 0; j < rewards.length(); j++)
         {
            tempItemXML = rewards[j];
            countAryy = new Array(int(tempItemXML.@RewardItemCount1),int(tempItemXML.@RewardItemCount2),int(tempItemXML.@RewardItemCount3),int(tempItemXML.@RewardItemCount4),int(tempItemXML.@RewardItemCount5));
            tempReward = new QuestItemReward(tempItemXML.@RewardItemID,countAryy,tempItemXML.@IsSelect,tempItemXML.@IsBind);
            tempReward.time = tempItemXML.@RewardItemValid;
            tempReward.AttackCompose = tempItemXML.@AttackCompose;
            tempReward.DefendCompose = tempItemXML.@DefendCompose;
            tempReward.AgilityCompose = tempItemXML.@AgilityCompose;
            tempReward.LuckCompose = tempItemXML.@LuckCompose;
            tempReward.StrengthenLevel = tempItemXML.@StrengthenLevel;
            tempReward.IsCount = tempItemXML.@IsCount;
            tempReward.MagicAttack = tempItemXML.@MagicAttack;
            tempReward.MagicDefence = tempItemXML.@MagicDefence;
            q.addReward(tempReward);
         }
         return q;
      }
      
      public function get QuestLevel() : int
      {
         return this._questLevel;
      }
      
      public function set QuestLevel(value:int) : void
      {
         if(value < 1)
         {
            value = 1;
         }
         if(value > 5)
         {
            value = 5;
         }
         this._questLevel = value;
      }
      
      public function get RewardItemCount() : int
      {
         return this._itemRewards[0].count;
      }
      
      public function get RewardItemValidate() : int
      {
         return this._itemRewards[0].count;
      }
      
      public function get itemRewards() : Array
      {
         return this._itemRewards;
      }
      
      public function get Id() : int
      {
         return this.QuestID;
      }
      
      public function get hadChecked() : Boolean
      {
         if(Boolean(this.data) && this.data.hadChecked)
         {
            return true;
         }
         return false;
      }
      
      public function set hadChecked(value:Boolean) : void
      {
         if(Boolean(this.data))
         {
            this.data.hadChecked = value;
         }
      }
      
      public function BuffName() : String
      {
         return ItemManager.Instance.getTemplateById(this.BuffID).Name;
      }
      
      public function addCondition(condition:QuestCondition) : void
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         this._conditions.push(condition);
      }
      
      public function addReward(reward:QuestItemReward) : void
      {
         if(!this._itemRewards)
         {
            this._itemRewards = new Array();
         }
         this._itemRewards.push(reward);
      }
      
      public function texpTaskIsTimeOut() : Boolean
      {
         if(this.Type > 100 && Boolean(PlayerManager.Instance.Self.texpTaskDate))
         {
            return TimeManager.Instance.Now().getDate() != PlayerManager.Instance.Self.texpTaskDate.getDate();
         }
         return false;
      }
      
      public function isTimeOut() : Boolean
      {
         if(this.Id == 538 && PathManager.solveClientDownloadPath() == "")
         {
            return true;
         }
         var now:Date = TimeManager.Instance.Now();
         var nt:Date = new Date(1990,1,1,now.getHours(),now.getMinutes(),now.getSeconds());
         var startTime:Date = new Date(1990,1,1,this.StartDate.getHours(),this.StartDate.getMinutes(),this.StartDate.getSeconds());
         var endTime:Date = new Date(1990,1,1,this.EndDate.getHours(),this.EndDate.getMinutes(),this.EndDate.getSeconds());
         if(now.time > this.EndDate.time || now.time < this.StartDate.time)
         {
            return true;
         }
         return false;
      }
      
      public function get id() : int
      {
         return this.QuestID;
      }
      
      public function get Condition() : int
      {
         return this._conditions[0].type;
      }
      
      public function get RewardItemID() : int
      {
         return this._itemRewards[0].itemID;
      }
      
      public function get RewardItemValidateTime() : int
      {
         return this._itemRewards[0].time;
      }
      
      public function isAvailableFor(self:SelfInfo) : Boolean
      {
         return false;
      }
      
      public function get isAvailable() : Boolean
      {
         if(!this.isAchieved)
         {
            return true;
         }
         if(!this.CanRepeat)
         {
            return false;
         }
         if(TimeManager.Instance.TotalDaysToNow2(this.data.CompleteDate) < this.RepeatInterval)
         {
            if(this.data.repeatLeft < 1 && !this.data.isExist)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isAchieved() : Boolean
      {
         if(!this.data || !this.data.isAchieved)
         {
            return false;
         }
         return true;
      }
      
      private function getProgressById(id:uint) : uint
      {
         var self:SelfInfo = null;
         var cond:QuestCondition = null;
         var tempItem:InventoryItemInfo = null;
         var equips:Array = null;
         var storeBag:Array = null;
         var count1:int = 0;
         var count2:int = 0;
         var Count1:int = 0;
         var Count2:int = 0;
         var item:InventoryItemInfo = null;
         var storeItem:InventoryItemInfo = null;
         self = PlayerManager.Instance.Self;
         cond = this.getConditionById(id);
         var prog:int = 0;
         if(this.data == null || this.data.progress[id] == null)
         {
            prog = 0;
         }
         else
         {
            prog = int(this.data.progress[id]);
         }
         switch(cond.type)
         {
            case 1:
               prog = self.Grade;
               break;
            case 2:
               prog = 0;
               tempItem = self.getBag(BagInfo.EQUIPBAG).findEquipedItemByTemplateId(cond.param,false);
               if(Boolean(tempItem) && tempItem.Place <= 30)
               {
                  prog = 1;
               }
               break;
            case 9:
               prog = 0;
               equips = self.getBag(BagInfo.EQUIPBAG).findItemsForEach(cond.param);
               storeBag = self.getBag(BagInfo.STOREBAG).findItemsForEach(cond.param);
               for each(item in equips)
               {
                  if(item.StrengthenLevel >= cond.target)
                  {
                     prog = cond.target;
                     break;
                  }
               }
               for each(storeItem in storeBag)
               {
                  if(storeItem.StrengthenLevel >= cond.target)
                  {
                     prog = cond.target;
                     break;
                  }
               }
               break;
            case 14:
            case 15:
               count1 = self.getBag(BagInfo.EQUIPBAG).getItemCountByTemplateId(cond.param,false);
               count2 = self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(cond.param,false);
               prog = count1 + count2;
               break;
            case 16:
               prog = 1;
               break;
            case 17:
               prog = self.IsMarried ? 1 : 0;
               break;
            case 18:
               switch(cond.param)
               {
                  case 0:
                     if(ConsortionModelControl.Instance.model.memberList.length > 0)
                     {
                        prog = ConsortionModelControl.Instance.model.memberList.length;
                     }
                     break;
                  case 1:
                     if(Boolean(PlayerManager.Instance.Self.UseOffer))
                     {
                        prog = PlayerManager.Instance.Self.UseOffer;
                     }
                     break;
                  case 2:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.SmithLevel))
                     {
                        prog = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
                     }
                     break;
                  case 3:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.ShopLevel))
                     {
                        prog = PlayerManager.Instance.Self.consortiaInfo.ShopLevel;
                     }
                     break;
                  case 4:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.StoreLevel))
                     {
                        prog = PlayerManager.Instance.Self.consortiaInfo.StoreLevel;
                     }
               }
               break;
            case 20:
               prog = cond.target - this.data.progress[id];
               if(cond.param == 3)
               {
                  prog = PlayerManager.Instance.friendList.length;
               }
               break;
            case 21:
               prog = cond.target - 1;
               if(this.data && this.data.progress[id] < cond.target && this.data.progress[id] >= 0)
               {
                  prog = cond.target;
               }
               break;
            case 69:
               if(HorseManager.instance.curLevel >= cond.param)
               {
                  prog = 0;
               }
               else
               {
                  prog = cond.target - 1;
               }
               break;
            case 99:
               Count1 = self.getBag(BagInfo.EQUIPBAG).getBagItemCountByTemplateId(cond.param,false);
               Count2 = self.getBag(BagInfo.PROPBAG).getBagItemCountByTemplateId(cond.param,false);
               prog = Count1 + Count2;
               break;
            case 72:
               if(DayActivityManager.Instance.activityValue >= cond.target)
               {
                  prog = cond.target;
               }
               else
               {
                  prog = DayActivityManager.Instance.activityValue;
               }
               break;
            default:
               if(this.data == null || this.data.progress[id] == null)
               {
                  prog = 0;
                  break;
               }
               prog = int(this.data.progress[id]);
               break;
         }
         if(prog > cond.target)
         {
            return 0;
         }
         return cond.target - prog;
      }
      
      public function get progress() : Array
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var tempArr:Array = new Array();
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            tempArr[i] = this.getProgressById(i);
         }
         return tempArr;
      }
      
      public function get conditionStatus() : Array
      {
         var pro:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var tempArr:Array = new Array();
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            pro = int(this.progress[i]);
            if(pro <= 0 || this.isCompleted)
            {
               tempArr[i] = LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
            }
            else if(this._conditions[i].type == 9 || this._conditions[i].type == 12 || this._conditions[i].type == 17 || this._conditions[i].type == 21 || this._conditions[i].type == 50 || this._conditions[i].type == 69)
            {
               tempArr[i] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else if(this._conditions[i].type == 20 && this._conditions[i].param == 2)
            {
               tempArr[i] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else
            {
               tempArr[i] = "(" + String(this._conditions[i].target - pro) + "/" + String(this._conditions[i].target) + ")";
            }
         }
         return tempArr;
      }
      
      public function get conditionDescription() : Array
      {
         var pro:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var tempArr:Array = new Array();
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            pro = int(this.progress[i]);
            if(pro <= 0 || this.isCompleted)
            {
               tempArr[i] = this._conditions[i].description + LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
            }
            else if(this._conditions[i].type == 9 || this._conditions[i].type == 12 || this._conditions[i].type == 21)
            {
               tempArr[i] = this._conditions[i].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else if(this._conditions[i].type == 20 && this._conditions[i].param == 2)
            {
               tempArr[i] = this._conditions[i].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else
            {
               tempArr[i] = this._conditions[i].description + "(" + String(this._conditions[i].target - pro) + "/" + String(this._conditions[i].target) + ")";
            }
         }
         return tempArr;
      }
      
      public function get conditionProgress() : Array
      {
         var pro:int = 0;
         var temp:Array = new Array();
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            pro = int(this.progress[i]);
            temp.push(ItemManager.Instance.getTemplateById(this._conditions[i].param).Name + "," + String(this._conditions[i].target - pro) + "/" + String(this._conditions[i].target));
         }
         return temp;
      }
      
      public function get isCompleted() : Boolean
      {
         var tempCond:QuestCondition = null;
         if(TrusteeshipManager.instance.isTrusteeshipQuestEnd(this.id))
         {
            return true;
         }
         if(this.Type == 4)
         {
            if(!PlayerManager.Instance.Self.IsVIP)
            {
               return false;
            }
            if(this.id == 306 && PlayerManager.Instance.Self.typeVIP < 2)
            {
               return false;
            }
         }
         if(!this.CanRepeat && this.isAchieved)
         {
            return false;
         }
         var optionalCondNeed:int = int(this.optionalConditionNeed);
         for(var i:int = 0; Boolean(tempCond = this.getConditionById(i)); i++)
         {
            if(!tempCond)
            {
               break;
            }
            if(this.progress[i] > 0)
            {
               if(!tempCond.isOpitional)
               {
                  return false;
               }
            }
            else
            {
               optionalCondNeed--;
            }
         }
         if(optionalCondNeed > 0)
         {
            return false;
         }
         return true;
      }
      
      private function getConditionById(id:uint) : QuestCondition
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         return this._conditions[id] as QuestCondition;
      }
      
      public function get questProgressNum() : Number
      {
         var numerator:int = 0;
         var denominator:int = 0;
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            numerator += this.progress[i];
            denominator += this._conditions[i].target;
         }
         return numerator / denominator;
      }
      
      public function get canViewWithProgress() : Boolean
      {
         var numerator:int = 0;
         var denominator:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var boo:Boolean = true;
         if(this.isCompleted)
         {
            return boo;
         }
         for(var i:int = 0; Boolean(this._conditions[i]); i++)
         {
            numerator += this.progress[i];
            denominator += this._conditions[i].target;
         }
         if(numerator == denominator)
         {
            boo = false;
         }
         for(i = 0; Boolean(this._conditions[i]); i++)
         {
            if(this._conditions[i].type == 9 || this._conditions[i].type == 12 || this._conditions[i].type == 17 || this._conditions[i].type == 21)
            {
               boo = false;
            }
            if(this._conditions[i].type == 20 && this._conditions[i].param == 2)
            {
               boo = false;
            }
         }
         return boo;
      }
      
      public function hasOtherAward() : Boolean
      {
         if(this.RewardGP > 0)
         {
            return true;
         }
         if(this.RewardGold > 0)
         {
            return true;
         }
         if(this.RewardMoney > 0)
         {
            return true;
         }
         if(this.RewardOffer > 0)
         {
            return true;
         }
         if(this.RewardRiches > 0)
         {
            return true;
         }
         if(this.RewardBindMoney > 0)
         {
            return true;
         }
         if(this.Rank != "")
         {
            return true;
         }
         if(this.RewardBuffID != 0)
         {
            return true;
         }
         return false;
      }
      
      public function set cellHeight(value:Number) : void
      {
         this._cellHeight = value;
      }
      
      public function getCellHeight() : Number
      {
         return this._cellHeight;
      }
   }
}

