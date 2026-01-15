package flowerGiving.components
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class FlowerSendRewardItem extends Sprite implements Disposeable
   {
      
      private var _itemIndex:int;
      
      private var _back:Bitmap;
      
      private var _backOverBit:Bitmap;
      
      private var _contentTxt:FilterFrameText;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _haveGot:Bitmap;
      
      private var _hBox:HBox;
      
      private var index:int;
      
      public var num:int;
      
      public function FlowerSendRewardItem(index:int)
      {
         super();
         this.index = index;
         this._itemIndex = index % 2 == 0 ? 2 : 1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("flowerGiving.accumuGivingItem" + this._itemIndex);
         addChild(this._back);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.contentTxt");
         addChild(this._contentTxt);
         this._contentTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendRewardView.desc");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.getbtn");
         addChild(this._getBtn);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.hBox");
         addChild(this._hBox);
         this._backOverBit = ComponentFactory.Instance.creat("flowerGiving.accumuGivingMouseOver");
         addChild(this._backOverBit);
         this._backOverBit.visible = false;
         this._haveGot = ComponentFactory.Instance.creat("flowerGiving.haveGot");
         addChild(this._haveGot);
         this._haveGot.visible = false;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         addEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__clickHanlder);
      }
      
      protected function __clickHanlder(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGetFlowerReward(2,this.index);
      }
      
      protected function __onOutHandler(event:MouseEvent) : void
      {
         this._backOverBit.visible = false;
      }
      
      protected function __onOverHanlder(event:MouseEvent) : void
      {
         this._backOverBit.visible = true;
      }
      
      public function set info(info:GiftBagInfo) : void
      {
         var reward:GiftRewardInfo = null;
         var item:InventoryItemInfo = null;
         var attrArr:Array = null;
         var bagCell:BagCell = null;
         this.num = info.giftConditionArr[0].conditionValue;
         this._contentTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendRewardView.desc",this.num);
         for(var i:int = 0; i <= info.giftRewardArr.length - 1; i++)
         {
            reward = info.giftRewardArr[i];
            item = new InventoryItemInfo();
            item.TemplateID = reward.templateId;
            ItemManager.fill(item);
            item.IsBinds = reward.isBind;
            item.ValidDate = reward.validDate;
            attrArr = reward.property.split(",");
            item._StrengthenLevel = parseInt(attrArr[0]);
            item.AttackCompose = parseInt(attrArr[1]);
            item.DefendCompose = parseInt(attrArr[2]);
            item.AgilityCompose = parseInt(attrArr[3]);
            item.LuckCompose = parseInt(attrArr[4]);
            if(EquipType.isMagicStone(item.CategoryID))
            {
               item.Level = item.StrengthenLevel;
               item.Attack = item.AttackCompose;
               item.Defence = item.DefendCompose;
               item.Agility = item.AgilityCompose;
               item.Luck = item.LuckCompose;
               item.MagicAttack = parseInt(attrArr[6]);
               item.MagicDefence = parseInt(attrArr[7]);
               item.StrengthenExp = parseInt(attrArr[8]);
            }
            bagCell = new BagCell(0);
            bagCell.info = item;
            bagCell.setCount(reward.count);
            bagCell.setBgVisible(false);
            this._hBox.addChild(bagCell);
         }
      }
      
      public function setBtnEnable(type:int) : void
      {
         switch(type)
         {
            case 0:
               this._getBtn.enable = false;
               this._haveGot.visible = false;
               break;
            case 1:
               this._getBtn.enable = true;
               this._haveGot.visible = false;
               break;
            case 2:
               this._getBtn.enable = false;
               this._haveGot.visible = true;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__clickHanlder);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._backOverBit))
         {
            ObjectUtils.disposeObject(this._backOverBit);
         }
         this._backOverBit = null;
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(Boolean(this._getBtn))
         {
            ObjectUtils.disposeObject(this._getBtn);
         }
         this._getBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

