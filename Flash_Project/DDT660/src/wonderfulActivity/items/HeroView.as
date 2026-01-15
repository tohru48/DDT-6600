package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class HeroView extends Sprite implements IRightView
   {
      
      private var _back:Bitmap;
      
      private var _activeTimeBit:Bitmap;
      
      private var _activetimeFilter:FilterFrameText;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _cartoonList:Vector.<MovieClip>;
      
      private var _cartoonVisibleArr:Array;
      
      private var _bagCellGrayArr:Array;
      
      private var _bagCellArr:Array;
      
      private var _mcNum:int;
      
      private var _info:SelfInfo;
      
      private var _fightPowerArr:Array;
      
      private var _gradeArr:Array;
      
      private var _numPower:int = 0;
      
      private var _numGrade:int = 0;
      
      private var _activityInfo1:GmActivityInfo;
      
      private var _activityInfo2:GmActivityInfo;
      
      private var _activityInfoArr:Array;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusPowerArr:Array;
      
      private var _statusGradeArr:Array;
      
      public function HeroView()
      {
         super();
         this._fightPowerArr = new Array();
         this._gradeArr = new Array();
         this._activityInfoArr = new Array();
         this._cartoonVisibleArr = [false,false,false,false];
         this._bagCellGrayArr = [false,false,false,false];
         this._bagCellArr = new Array();
         this._info = PlayerManager.Instance.Self;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      private function initViewWithData() : void
      {
         var i:int = 0;
         var timeArr:Array = null;
         var timeArr2:Array = null;
         var itemIcon:Bitmap = null;
         var itemFilter:FilterFrameText = null;
         var bagCell:BagCell = null;
         var itemIcon2:Bitmap = null;
         var itemFilter2:FilterFrameText = null;
         var bagCell2:BagCell = null;
         if(!this.checkData())
         {
            return;
         }
         if(Boolean(this._activityInfo1))
         {
            timeArr = [this._activityInfo1.beginTime.split(" ")[0],this._activityInfo1.endTime.split(" ")[0]];
            this._activetimeFilter.text = timeArr[0] + "-" + timeArr[1];
         }
         else if(Boolean(this._activityInfo2))
         {
            timeArr2 = [this._activityInfo2.beginTime.split(" ")[0],this._activityInfo2.endTime.split(" ")[0]];
            this._activetimeFilter.text = timeArr2[0] + "-" + timeArr2[1];
         }
         i = 0;
         while(i < 4 && i < this._numPower + this._numGrade)
         {
            if(i < this._numPower)
            {
               itemIcon = ComponentFactory.Instance.creat("wonderfulactivity.powerBitmap");
               itemIcon.x += 120 * i;
               addChild(itemIcon);
               itemFilter = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.heroTxt");
               itemFilter.x += 120 * i;
               itemFilter.text = this._fightPowerArr[i];
               addChild(itemFilter);
               bagCell = this.createBagCell(i,this._activityInfo1.giftbagArray[i]);
               bagCell.x = itemFilter.x + 22;
               bagCell.y = itemFilter.y + 45;
               addChild(bagCell);
            }
            else
            {
               itemIcon2 = ComponentFactory.Instance.creat("wonderfulactivity.levelBitmap");
               itemIcon2.x += 120 * i;
               itemFilter2 = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.heroTxt");
               itemFilter2.x += 120 * i;
               itemFilter2.text = this._gradeArr[i - this._numPower];
               addChild(itemFilter2);
               bagCell2 = this.createBagCell(i,this._activityInfo2.giftbagArray[i - this._numPower]);
               bagCell2.x = itemIcon2.x + 22;
               bagCell2.y = itemFilter2.y + 45;
               addChild(bagCell2);
            }
            i++;
         }
         this.initItem();
      }
      
      private function checkData() : Boolean
      {
         if((Boolean(this._activityInfo1) || Boolean(this._activityInfo2)) && (this._fightPowerArr.length > 0 || this._gradeArr.length > 0))
         {
            return true;
         }
         return false;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.hero.back");
         addChild(this._back);
         this._activeTimeBit = ComponentFactory.Instance.creat("wonderfulactivity.activetime");
         addChild(this._activeTimeBit);
         this._activetimeFilter = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activetimeFilter);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      private function createBagCell(order:int, giftBagInfo:GiftBagInfo) : BagCell
      {
         var gift:GiftRewardInfo = giftBagInfo.giftRewardArr[0];
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = gift.templateId;
         info = ItemManager.fill(info);
         info.IsBinds = gift.isBind;
         info.ValidDate = gift.validDate;
         var attrArr:Array = gift.property.split(",");
         info._StrengthenLevel = parseInt(attrArr[0]);
         info.AttackCompose = parseInt(attrArr[1]);
         info.DefendCompose = parseInt(attrArr[2]);
         info.AgilityCompose = parseInt(attrArr[3]);
         info.LuckCompose = parseInt(attrArr[4]);
         if(EquipType.isMagicStone(info.CategoryID))
         {
            info.Level = info.StrengthenLevel;
            info.Attack = info.AttackCompose;
            info.Defence = info.DefendCompose;
            info.Agility = info.AgilityCompose;
            info.Luck = info.LuckCompose;
            info.MagicAttack = parseInt(attrArr[6]);
            info.MagicDefence = parseInt(attrArr[7]);
            info.StrengthenExp = parseInt(attrArr[8]);
         }
         var bagCell:BagCell = new BagCell(order);
         bagCell.info = info;
         bagCell.setCount(gift.count);
         bagCell.setBgVisible(false);
         if(Boolean(this._giftInfoDic))
         {
            if(Boolean(this._giftInfoDic[giftBagInfo.giftbagId]) && this._giftInfoDic[giftBagInfo.giftbagId].times > 0)
            {
               this._bagCellGrayArr[order] = bagCell.grayFilters = true;
            }
         }
         else
         {
            this._bagCellGrayArr[order] = bagCell.grayFilters = false;
         }
         this._bagCellArr.push(bagCell);
         return bagCell;
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         var i:int = 0;
         var dic:Dictionary = null;
         var key:String = null;
         var ig:int = 0;
         var j:int = 0;
         var dic2:Dictionary = null;
         var key2:String = null;
         var jg:int = 0;
         var testDic:Dictionary = WonderfulActivityManager.Instance.activityInitData;
         for each(item in WonderfulActivityManager.Instance.activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.MAIN_FAMOUS_ACTIVITY)
            {
               if(item.activityChildType == WonderfulActivityTypeData.HERO_POWER)
               {
                  if(Boolean(WonderfulActivityManager.Instance.activityInitData[item.activityId]))
                  {
                     if(!this._giftInfoDic)
                     {
                        this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                     }
                     else
                     {
                        dic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                        if(Boolean(dic))
                        {
                           for(key in dic)
                           {
                              this._giftInfoDic[key] = dic[key];
                           }
                        }
                     }
                     this._statusPowerArr = WonderfulActivityManager.Instance.activityInitData[item.activityId]["statusArr"];
                  }
                  this._numPower = item.giftbagArray.length;
                  i = 0;
                  while(i < this._numPower && i < 4)
                  {
                     for(ig = 0; ig < item.giftbagArray[i].giftConditionArr.length; ig++)
                     {
                        if(item.giftbagArray[i].giftConditionArr[ig].conditionIndex == 0)
                        {
                           this._fightPowerArr.push(item.giftbagArray[i].giftConditionArr[ig].conditionValue);
                        }
                     }
                     i++;
                  }
                  this._activityInfo1 = item;
                  this._activityInfoArr.push(this._activityInfo1);
               }
               else if(item.activityChildType == WonderfulActivityTypeData.HERO_GRADE)
               {
                  if(Boolean(WonderfulActivityManager.Instance.activityInitData[item.activityId]))
                  {
                     if(!this._giftInfoDic)
                     {
                        this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                     }
                     else
                     {
                        dic2 = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                        if(Boolean(dic2))
                        {
                           for(key2 in dic2)
                           {
                              this._giftInfoDic[key2] = dic2[key2];
                           }
                        }
                     }
                     this._statusGradeArr = WonderfulActivityManager.Instance.activityInitData[item.activityId]["statusArr"];
                  }
                  this._numGrade = item.giftbagArray.length;
                  j = 0;
                  while(j < this._numGrade && j < 4)
                  {
                     for(jg = 0; jg < item.giftbagArray[j].giftConditionArr.length; jg++)
                     {
                        if(item.giftbagArray[j].giftConditionArr[jg].conditionIndex == 0)
                        {
                           this._gradeArr.push(item.giftbagArray[j].giftConditionArr[jg].conditionValue);
                        }
                     }
                     j++;
                  }
                  this._activityInfo2 = item;
                  this._activityInfoArr.push(this._activityInfo2);
               }
            }
         }
      }
      
      private function initCartoonPlayArr(fightPowerArr:Array, gradeArr:Array) : void
      {
         var i:int = 0;
         while(i < fightPowerArr.length && i < 4)
         {
            if(this._statusPowerArr && this._statusPowerArr[0].statusValue >= fightPowerArr[i] && !this._bagCellGrayArr[i])
            {
               this._cartoonVisibleArr[i] = true;
            }
            else
            {
               this._cartoonVisibleArr[i] = false;
            }
            i++;
         }
         for(var j:int = 0; j < 4 - fightPowerArr.length; j++)
         {
            if(this._statusGradeArr && this._statusGradeArr[0].statusValue >= gradeArr[j] && !this._bagCellGrayArr[i])
            {
               this._cartoonVisibleArr[fightPowerArr.length + j] = true;
            }
            else
            {
               this._cartoonVisibleArr[fightPowerArr.length + j] = false;
            }
         }
      }
      
      private function initItem() : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         this._cartoonList = new Vector.<MovieClip>();
         this.initCartoonPlayArr(this._fightPowerArr,this._gradeArr);
         for(i = 0; i < 4; i++)
         {
            if(this._cartoonVisibleArr[i])
            {
               mc = ComponentFactory.Instance.creat("wonderfulactivity.cartoon");
               mc.mouseChildren = false;
               mc.mouseEnabled = false;
               mc.x = 268 + 120 * i;
               mc.y = 311;
               addChild(mc);
               this._cartoonList.push(mc);
            }
         }
         if(this._cartoonList.length > 0)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
      }
      
      private function __getAward(event:MouseEvent) : void
      {
         var sendInfo:SendGiftInfo = null;
         var giftIdArr:Array = null;
         var j:int = 0;
         SoundManager.instance.playButtonSound();
         for(var ig:int = 0; ig < this._bagCellArr.length; ig++)
         {
            if(Boolean(this._cartoonVisibleArr[ig]))
            {
               (this._bagCellArr[ig] as BagCell).grayFilters = true;
            }
         }
         for(var jg:int = 0; jg < this._cartoonList.length; jg++)
         {
            this._cartoonList[jg].parent.removeChild(this._cartoonList[jg]);
         }
         this._getButton.enable = false;
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         for(var i:int = 0; i < this._activityInfoArr.length; i++)
         {
            sendInfo = new SendGiftInfo();
            sendInfo.activityId = this._activityInfoArr[i].activityId;
            giftIdArr = new Array();
            for(j = 0; j < this._activityInfoArr[i].giftbagArray.length; j++)
            {
               giftIdArr.push(this._activityInfoArr[i].giftbagArray[j].giftbagId);
            }
            sendInfo.giftIdArr = giftIdArr;
            sendInfoVec.push(sendInfo);
         }
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var mc:MovieClip = null;
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._bagCellArr = null;
         for each(mc in this._cartoonList)
         {
            if(Boolean(mc.parent))
            {
               mc.parent.removeChild(mc);
            }
            mc = null;
         }
         this._cartoonList = null;
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

