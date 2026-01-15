package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class NewGameBenifitView extends Sprite implements IRightView
   {
      
      private var _back:Bitmap;
      
      private var _activeTimeBit:Bitmap;
      
      private var _activetimeFilter:FilterFrameText;
      
      private var _rectangle:Rectangle;
      
      private var _pBar:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _progressBarBitmapData:BitmapData;
      
      private var _progressFrame:Bitmap;
      
      private var _progressComplete:Bitmap;
      
      private var _progressTip:NewGameBenifitTipSprite;
      
      private var _progressCompleteNum:int;
      
      private var _progressWidthArr:Array = [35,35 + 56,35 + 56 * 2,35 + 56 * 3,35 + 56 * 4,35 + 56 * 5];
      
      private var _itemArr:Array;
      
      private var _itemLightArr:Array;
      
      private var _currentTarget:*;
      
      private var _awardArr:Array;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _bagCellDic:Dictionary;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _chargeNumArr:Array;
      
      public function NewGameBenifitView()
      {
         super();
         this._itemArr = new Array();
         this._itemLightArr = new Array();
         this._awardArr = new Array();
         this._chargeNumArr = new Array();
         this._bagCellDic = new Dictionary();
         this._progressTip = new NewGameBenifitTipSprite();
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
         var timeArr:Array = null;
         if(!this.checkData())
         {
            return;
         }
         if(Boolean(this._activityInfo))
         {
            timeArr = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
            this._activetimeFilter.text = timeArr[0] + "-" + timeArr[1];
            this._activetimeFilter.y = 202;
         }
         this.initProgressBar(Boolean(this._statusArr) ? int(this._statusArr[0].statusValue) : 0);
         this.initItem();
         this.initAward();
         this.setCurrentData(0);
      }
      
      private function checkData() : Boolean
      {
         if(Boolean(this._activityInfo) && this._chargeNumArr.length >= 6)
         {
            return true;
         }
         return false;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.back");
         addChild(this._back);
         this._activeTimeBit = ComponentFactory.Instance.creat("wonderfulactivity.activetime");
         this._activeTimeBit.y = 195;
         addChild(this._activeTimeBit);
         this._activetimeFilter = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activetimeFilter);
         this._progressFrame = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progressframe");
         addChild(this._progressFrame);
         this._pBar = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progressbar");
         this._progressBar = new Bitmap();
         this._progressBar.x = this._pBar.x;
         this._progressBar.y = this._pBar.y;
         this._progressTip.x = this._progressBar.x;
         this._progressTip.y = this._progressBar.y;
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         var i:int = 0;
         var j:int = 0;
         for each(item in WonderfulActivityManager.Instance.activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.MAIN_PAY_ACTIVITY && item.activityChildType == WonderfulActivityTypeData.NEWGAMEBENIFIT)
            {
               this._activityInfo = item;
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[item.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[item.activityId]["statusArr"];
               }
               for(i = 0; i < item.giftbagArray.length; i++)
               {
                  for(j = 0; j < item.giftbagArray[i].giftConditionArr.length; j++)
                  {
                     if(item.giftbagArray[i].giftConditionArr[j].conditionIndex == 0 && this._chargeNumArr.length < 6)
                     {
                        this._chargeNumArr.push(item.giftbagArray[i].giftConditionArr[j].conditionValue);
                     }
                  }
               }
            }
         }
      }
      
      private function initProgressBar(totalMoney:int) : void
      {
         var i:int = 0;
         var progressComplete:Bitmap = null;
         this._rectangle = new Rectangle();
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.height = this._pBar.height;
         if(totalMoney < this._chargeNumArr[0])
         {
            this._rectangle.width = totalMoney / this._chargeNumArr[0] * 35;
            this._progressCompleteNum = 0;
         }
         else if(totalMoney >= this._chargeNumArr[0] && totalMoney < this._chargeNumArr[1])
         {
            this._rectangle.width = 35 + (totalMoney - this._chargeNumArr[0]) / (this._chargeNumArr[1] - this._chargeNumArr[0]) * 56;
            this._progressCompleteNum = 1;
         }
         else if(totalMoney >= this._chargeNumArr[1] && totalMoney < this._chargeNumArr[2])
         {
            this._rectangle.width = 35 + 56 + (totalMoney - this._chargeNumArr[1]) / (this._chargeNumArr[2] - this._chargeNumArr[1]) * 56;
            this._progressCompleteNum = 2;
         }
         else if(totalMoney >= this._chargeNumArr[2] && totalMoney < this._chargeNumArr[3])
         {
            this._rectangle.width = 35 + 56 * 2 + (totalMoney - this._chargeNumArr[2]) / (this._chargeNumArr[3] - this._chargeNumArr[2]) * 56;
            this._progressCompleteNum = 3;
         }
         else if(totalMoney >= this._chargeNumArr[3] && totalMoney < this._chargeNumArr[4])
         {
            this._rectangle.width = 35 + 56 * 3 + (totalMoney - this._chargeNumArr[3]) / (this._chargeNumArr[4] - this._chargeNumArr[3]) * 56;
            this._progressCompleteNum = 4;
         }
         else if(totalMoney >= this._chargeNumArr[4] && totalMoney < this._chargeNumArr[5])
         {
            this._rectangle.width = 35 + 56 * 4 + (totalMoney - this._chargeNumArr[4]) / (this._chargeNumArr[5] - this._chargeNumArr[4]) * 56;
            this._progressCompleteNum = 5;
         }
         else if(totalMoney >= this._chargeNumArr[5])
         {
            this._rectangle.width = this._pBar.width;
            this._progressCompleteNum = 6;
         }
         if(this._rectangle.width <= 0)
         {
            this._rectangle.width = 1;
         }
         this._rectangle.width = Math.ceil(this._rectangle.width);
         this._progressBarBitmapData = new BitmapData(this._rectangle.width,this._rectangle.height,true,0);
         this._progressBarBitmapData.copyPixels(this._pBar.bitmapData,this._rectangle,new Point(0,0));
         this._progressBar.bitmapData = this._progressBarBitmapData;
         addChild(this._progressBar);
         this._progressTip.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressTip.tipDirctions = "0,1,2";
         this._progressTip.tipData = totalMoney;
         this._progressTip.back = new Bitmap(this._pBar.bitmapData.clone());
         addChild(this._progressTip);
         for(i = 0; i < this._progressCompleteNum; i++)
         {
            progressComplete = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progresscomplete");
            progressComplete.y = this._progressBar.y - 2;
            progressComplete.x = 318 + this._progressWidthArr[i] - 6;
            addChild(progressComplete);
         }
         var enable:Boolean = true;
         if(Boolean(this._giftInfoDic) && this._progressCompleteNum >= 1)
         {
            if(this._giftInfoDic[this._activityInfo.giftbagArray[this._progressCompleteNum - 1].giftbagId].times > 0)
            {
               enable = false;
            }
         }
         if(this._progressCompleteNum > 0 && enable)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
      }
      
      private function __getAward(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._getButton.enable = false;
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._activityInfo.activityId;
         var giftIdArr:Array = new Array();
         for(var j:int = 0; j < this._activityInfo.giftbagArray.length; j++)
         {
            giftIdArr.push(this._activityInfo.giftbagArray[j].giftbagId);
         }
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      private function initItem() : void
      {
         var i:int = 0;
         var item:SimpleBitmapButton = null;
         var itemLight:SimpleBitmapButton = null;
         var itemTxt:FilterFrameText = null;
         for(var j:int = 0; j < this._chargeNumArr.length; j++)
         {
            item = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.itemButton");
            item.x = 330 + 55 * j + j;
            item.y = 294;
            this._itemArr.push(item);
            item.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            addChild(item);
         }
         for(i = 0; i < this._chargeNumArr.length; i++)
         {
            itemLight = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.itemLightButton");
            itemLight.x = 330 + 55 * i + i;
            itemLight.y = 279;
            this._itemLightArr.push(itemLight);
            itemLight.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            addChild(itemLight);
            itemTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.newgameTxt");
            if(i == 0)
            {
               itemLight.enable = itemLight.visible = true;
               this._currentTarget = itemLight;
            }
            else if(i == 1 || i == 2)
            {
               itemLight.enable = itemLight.visible = false;
            }
            else
            {
               itemLight.enable = itemLight.visible = false;
            }
            itemTxt.x = itemLight.x + 5;
            itemTxt.y = itemLight.y + 22;
            if(int(this._chargeNumArr[i]) / 100000 >= 1)
            {
               itemTxt.text = int(this._chargeNumArr[i]) / 10000 + "w";
            }
            else
            {
               itemTxt.text = this._chargeNumArr[i];
            }
            addChild(itemTxt);
         }
      }
      
      private function initAward() : void
      {
         var i:int = 0;
         var bagCellArr:Array = null;
         var j:int = 0;
         var bagCell:BagCell = null;
         if(Boolean(this._activityInfo.giftbagArray))
         {
            for(i = 0; i < this._activityInfo.giftbagArray.length; i++)
            {
               bagCellArr = new Array();
               if(Boolean(this._activityInfo.giftbagArray[i].giftRewardArr))
               {
                  for(j = 0; j < this._activityInfo.giftbagArray[i].giftRewardArr.length; j++)
                  {
                     bagCell = this.createBagCell(this._activityInfo.giftbagArray[i].giftbagOrder,this._activityInfo.giftbagArray[i].giftRewardArr[j]);
                     bagCell.x = this._getButton.x - 89 + 63 * j;
                     bagCell.y = this._getButton.y - 90;
                     addChild(bagCell);
                     bagCellArr.push(bagCell);
                  }
               }
               this._bagCellDic[i] = bagCellArr;
            }
         }
      }
      
      private function createBagCell(order:int, gift:GiftRewardInfo) : BagCell
      {
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
         return bagCell;
      }
      
      private function itemClickHandler(event:MouseEvent) : void
      {
         if(event.target == this._currentTarget)
         {
            return;
         }
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            if(this._itemArr[i] == event.target)
            {
               this._currentTarget = this._itemLightArr[i];
               this.setCurrentData(i);
               break;
            }
         }
      }
      
      private function setCurrentData(index:int) : void
      {
         var item:BagCell = null;
         var item2:BagCell = null;
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            if(i == index)
            {
               this._itemArr[i].enable = this._itemArr[i].visible = false;
               this._itemLightArr[i].enable = this._itemLightArr[i].visible = true;
               if(Boolean(this._bagCellDic[i]))
               {
                  for each(item in this._bagCellDic[i])
                  {
                     item.visible = true;
                  }
               }
            }
            else
            {
               this._itemArr[i].enable = this._itemArr[i].visible = true;
               this._itemLightArr[i].enable = this._itemLightArr[i].visible = false;
               if(Boolean(this._bagCellDic[i]))
               {
                  for each(item2 in this._bagCellDic[i])
                  {
                     item2.visible = false;
                  }
               }
            }
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var bagCellArr:Array = null;
         var k:int = 0;
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            (this._itemArr[i] as SimpleBitmapButton).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
         }
         for(var j:int = 0; j < this._itemArr.length; j++)
         {
            (this._itemLightArr[j] as SimpleBitmapButton).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
         }
         for each(bagCellArr in this._bagCellDic)
         {
            for(k = 0; k < bagCellArr.length; k++)
            {
               bagCellArr[k] = null;
            }
         }
         this._bagCellDic = null;
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

