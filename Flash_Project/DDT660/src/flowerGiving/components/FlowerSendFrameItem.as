package flowerGiving.components
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class FlowerSendFrameItem extends Sprite implements Disposeable
   {
      
      private var _selectBtn:SelectedCheckButton;
      
      private var _sendTxt:FilterFrameText;
      
      private var _sendNumTxt:FilterFrameText;
      
      private var _canGetTxt:FilterFrameText;
      
      private var _shineBit:Bitmap;
      
      private var _giftData:GiftBagInfo;
      
      private var _sendBagCell:BagCell;
      
      private var _getIconSp:Sprite;
      
      private var _getIcon:Image;
      
      private var _baseTip:GoodTipInfo;
      
      public function FlowerSendFrameItem(data:GiftBagInfo)
      {
         this._giftData = data;
         super();
         this.initView();
         this.initViewWithData();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._selectBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.updateShine();
      }
      
      private function initView() : void
      {
         this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.selectedBtn");
         addChild(this._selectBtn);
         this._sendTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._sendTxt);
         PositionUtils.setPos(this._sendTxt,"flowerGiving.flowerSendFrame.sendPos");
         this._sendTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendTxt");
         this._sendNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._sendNumTxt);
         PositionUtils.setPos(this._sendNumTxt,"flowerGiving.flowerSendFrame.sendNumPos");
         this._canGetTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._canGetTxt);
         PositionUtils.setPos(this._canGetTxt,"flowerGiving.flowerSendFrame.canGetPos");
         this._canGetTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.cenGetTxt");
         this._getIconSp = new Sprite();
         this._getIcon = ComponentFactory.Instance.creatComponentByStylename("flowerSendFrame.rewardIcon");
         this._getIcon.scaleY = 0.58;
         this._getIcon.scaleX = 0.58;
         PositionUtils.setPos(this._getIcon,"flowerGiving.flowerSendFrame.getIconPos");
         this._getIconSp.addChild(this._getIcon);
         addChild(this._getIconSp);
         this._shineBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.mouseOver");
         addChild(this._shineBit);
         this.updateShine();
      }
      
      private function initViewWithData() : void
      {
         var rewardInfo:GiftRewardInfo = null;
         var item:InventoryItemInfo = null;
         this._sendNumTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendNumTxt",this._giftData.giftConditionArr[0].conditionValue);
         this._sendBagCell = this.createBagCell(FlowerGivingManager.instance.flowerTempleteId);
         addChild(this._sendBagCell);
         this._sendBagCell.setCountNotVisible();
         PositionUtils.setPos(this._sendBagCell,"flowerGiving.flowerSendFrame.sendBagCell");
         this._baseTip = new GoodTipInfo();
         var info:ItemTemplateInfo = new ItemTemplateInfo();
         info.Quality = 4;
         info.CategoryID = 11;
         info.Name = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.getGiftPackName" + (this._giftData.giftbagOrder + 1));
         var content:String = "";
         for(var i:int = 0; i < this._giftData.giftRewardArr.length; i++)
         {
            rewardInfo = this._giftData.giftRewardArr[i];
            item = new InventoryItemInfo();
            item.TemplateID = rewardInfo.templateId;
            ItemManager.fill(item);
            if(content != "")
            {
               content += "、";
            }
            content += item.Name + "x" + rewardInfo.count;
         }
         info.Description = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.getGiftPackContent") + content;
         this._baseTip.itemInfo = info;
         this._getIcon.tipStyle = "core.GoodsTip";
         this._getIcon.tipDirctions = "1,3";
         this._getIcon.tipData = this._baseTip;
      }
      
      private function createBagCell(templeteId:int) : BagCell
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = templeteId;
         info = ItemManager.fill(info);
         info.BindType = 4;
         var bagCell:BagCell = new BagCell(0);
         bagCell.info = info;
         bagCell.setBgVisible(false);
         return bagCell;
      }
      
      private function removeEvent() : void
      {
         this._selectBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function updateShine() : void
      {
         this._shineBit.visible = this._selectBtn.selected;
      }
      
      public function get selectBtn() : SelectedCheckButton
      {
         return this._selectBtn;
      }
      
      public function set selectBtn(value:SelectedCheckButton) : void
      {
         this._selectBtn = value;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._getIcon);
         ObjectUtils.disposeAllChildren(this);
         this._getIcon = null;
         this._getIconSp = null;
         this._selectBtn = null;
         this._sendTxt = null;
         this._sendNumTxt = null;
         this._canGetTxt = null;
         this._shineBit = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

