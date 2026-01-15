package carnivalActivity.view
{
   import bagAndInfo.cell.BagCell;
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class CarnivalActivityItem extends Sprite implements Disposeable
   {
      
      protected var _bg:Bitmap;
      
      protected var _getBtn:SimpleBitmapButton;
      
      protected var _giftCurInfo:GiftCurInfo;
      
      protected var _sumCount:int;
      
      protected var _allGiftAlreadyGetCount:int;
      
      protected var _playerAlreadyGetCount:int;
      
      protected var _condtion:int;
      
      protected var _currentCondtion:int;
      
      protected var _goodContent:Sprite;
      
      protected var _descTxt:FilterFrameText;
      
      protected var _awardCountTxt:FilterFrameText;
      
      protected var _type:int;
      
      protected var _info:GiftBagInfo;
      
      protected var _index:int;
      
      protected var _alreadyGetBtn:SimpleBitmapButton;
      
      protected var _statusArr:Array;
      
      public function CarnivalActivityItem(type:int, info:GiftBagInfo, index:int)
      {
         super();
         this._type = type;
         this._info = info;
         this._index = index;
         this.initData();
         this.initView();
         this.initItem();
         this.initEvent();
      }
      
      protected function initData() : void
      {
         for(var i:int = 0; i < this._info.giftConditionArr.length; i++)
         {
            if(this._info.giftConditionArr[i].conditionIndex == 0)
            {
               this._condtion = this._info.giftConditionArr[i].conditionValue;
            }
            else if(this._info.giftConditionArr[i].conditionIndex == 100)
            {
               this._sumCount = this._info.giftConditionArr[i].conditionValue;
            }
         }
      }
      
      protected function initView() : void
      {
         var bagCell:BagCell = null;
         var back:Bitmap = null;
         this._bg = ComponentFactory.Instance.creat("carnicalAct.listItem" + this._index);
         addChild(this._bg);
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.condtionTxt");
         addChild(this._descTxt);
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         addChild(this._getBtn);
         this._getBtn.enable = false;
         PositionUtils.setPos(this._getBtn,"carnivalAct.getButtonPos");
         this._alreadyGetBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
         addChild(this._alreadyGetBtn);
         this._alreadyGetBtn.visible = false;
         this._alreadyGetBtn.enable = false;
         PositionUtils.setPos(this._alreadyGetBtn,"carnivalAct.getButtonPos");
         this._goodContent = new Sprite();
         addChild(this._goodContent);
         for(var i:int = 0; i < this._info.giftRewardArr.length; i++)
         {
            bagCell = this.createBagCell(0,this._info.giftRewardArr[i]);
            back = ComponentFactory.Instance.creat("wonderfulactivity.goods.back");
            back.x = (back.width + 5) * i;
            bagCell.x = back.width / 2 - bagCell.width / 2 + back.x + 2;
            bagCell.y = back.height / 2 - bagCell.height / 2 + 1;
            this._goodContent.addChild(back);
            this._goodContent.addChild(bagCell);
         }
         this._goodContent.x = 142;
         this._goodContent.y = 7;
      }
      
      protected function initItem() : void
      {
         var horseGrade:int = 0;
         var horseStar:int = 0;
         if(this._sumCount != 0)
         {
            this._awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
            addChild(this._awardCountTxt);
         }
         else
         {
            this._descTxt.y += 9;
         }
         if(CarnivalActivityManager.instance.currentChildType == 10)
         {
            horseGrade = int(this._condtion / 10) + 1;
            horseStar = this._condtion % 10;
            this._descTxt.text = LanguageMgr.GetTranslation("carnival.descTxt" + CarnivalActivityManager.instance.currentChildType,horseGrade,horseStar);
         }
         else if(CarnivalActivityManager.instance.currentChildType != 4)
         {
            this._descTxt.text = LanguageMgr.GetTranslation("carnival.descTxt" + CarnivalActivityManager.instance.currentChildType,this._condtion);
         }
      }
      
      protected function createBagCell(order:int, gift:GiftRewardInfo) : BagCell
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
      
      public function updateView() : void
      {
         var info:PlayerCurInfo = null;
         this._giftCurInfo = WonderfulActivityManager.Instance.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagId];
         this._statusArr = WonderfulActivityManager.Instance.activityInitData[this._info.activityId].statusArr;
         this._playerAlreadyGetCount = this._giftCurInfo.times;
         this._allGiftAlreadyGetCount = this._giftCurInfo.allGiftGetTimes;
         this._currentCondtion = this._statusArr[0].statusValue;
         var grade:int = 0;
         var currentGrade:int = 0;
         if(CarnivalActivityManager.instance.currentChildType == 10)
         {
            for each(info in this._statusArr)
            {
               if(info.statusID == 0)
               {
                  grade = info.statusValue;
               }
               else if(info.statusID == 1)
               {
                  currentGrade = info.statusValue;
               }
            }
            this._getBtn.enable = CarnivalActivityManager.instance.canGetAward() && this._playerAlreadyGetCount == 0 && this._condtion > grade && this._condtion <= currentGrade && (this._sumCount == 0 || this._sumCount - this._allGiftAlreadyGetCount > 0);
         }
         else
         {
            this._getBtn.enable = CarnivalActivityManager.instance.canGetAward() && this._playerAlreadyGetCount == 0 && this._currentCondtion >= this._condtion && (this._sumCount == 0 || this._sumCount - this._allGiftAlreadyGetCount > 0);
         }
         if(Boolean(this._awardCountTxt))
         {
            this._awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (this._sumCount - this._allGiftAlreadyGetCount);
         }
         this._alreadyGetBtn.visible = this._playerAlreadyGetCount > 0;
         this._getBtn.visible = !this._alreadyGetBtn.visible;
      }
      
      protected function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
      }
      
      protected function __getAwardHandler(event:MouseEvent) : void
      {
         if(getTimer() - CarnivalActivityManager.instance.lastClickTime < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
            return;
         }
         CarnivalActivityManager.instance.lastClickTime = getTimer();
         SoundManager.instance.playButtonSound();
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var info:SendGiftInfo = new SendGiftInfo();
         info.activityId = this._info.activityId;
         info.giftIdArr = [this._info.giftbagId];
         info.awardCount = 1 - this._playerAlreadyGetCount;
         sendInfoVec.push(info);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      protected function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getAwardHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         this._goodContent = null;
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._getBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

