package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.data.RecordItemInfo;
   import shop.view.ShopItemCell;
   
   public class RecordItem extends Sprite implements Disposeable
   {
      
      private static var THISHEIGHT:int = 52;
      
      public static const RECEIVED:int = 1;
      
      public static const SENDED:int = 0;
      
      private var _playerInfo:PlayerInfo;
      
      private var _info:RecordItemInfo;
      
      private var _headTxt:FilterFrameText;
      
      private var _giftNameTxt:FilterFrameText;
      
      private var _giftCountTxt:FilterFrameText;
      
      private var _playerName:FilterFrameText;
      
      private var _itemCell:ShopItemCell;
      
      private var _clickSp:Sprite;
      
      private var _recordItemBg:MovieImage;
      
      private var _line1:TiledImage;
      
      private var _nameAction:Boolean;
      
      private var _index:int;
      
      private var _receiedIcon:Bitmap;
      
      private var _sendIcon:Bitmap;
      
      private var _showed:Boolean = false;
      
      public function RecordItem()
      {
         super();
      }
      
      public function setup(playerInfo:PlayerInfo) : void
      {
         this.initView();
         this._playerInfo = playerInfo;
      }
      
      private function initView() : void
      {
         this._recordItemBg = ComponentFactory.Instance.creatComponentByStylename("ddtGiftRecordItem.BG");
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("ddtGiftRecordItem.line1");
         this._receiedIcon = ComponentFactory.Instance.creatBitmap("asset.ddtgift.Receive.bg");
         this._sendIcon = ComponentFactory.Instance.creatBitmap("asset.ddtgift.Send.bg");
         this._headTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.headTxt");
         this._giftNameTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.giftNameTxt");
         this._giftCountTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.giftCountTxt");
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,50,50);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 46;
         addChild(this._recordItemBg);
         addChild(this._line1);
         addChild(this._receiedIcon);
         addChild(this._sendIcon);
         addChild(this._headTxt);
         addChild(this._giftNameTxt);
         addChild(this._giftCountTxt);
         addChild(this._itemCell);
         this._receiedIcon.visible = false;
         this._sendIcon.visible = false;
      }
      
      public function setItemInfoType(value:RecordItemInfo, type:int) : void
      {
         if(this._info == value || value == null)
         {
            return;
         }
         this._info = value;
         var shopItemInfo:ShopItemInfo = this._info.info;
         if(shopItemInfo == null)
         {
            return;
         }
         this._itemCell.info = shopItemInfo.TemplateInfo;
         switch(type)
         {
            case RECEIVED:
               this.upReceivedItemView();
               break;
            case SENDED:
               this.upSendedItemView();
         }
      }
      
      private function upReceivedItemView() : void
      {
         this._receiedIcon.visible = true;
         this._sendIcon.visible = false;
         this._headTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.receivedHeadTxt");
         this._giftNameTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.receivedGiftName",this._info.info.TemplateInfo.Name.substring(0,5) + "..");
         this._giftCountTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.giftCount",this._info.count);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("RecordItem.receiverTxt");
         addChild(this._playerName);
         this._playerName.text = this._info.name;
         if(GiftController.Instance.canActive && this._info.playerID != 0 && !GiftController.Instance.inChurch)
         {
            this._clickSp = new Sprite();
            this._clickSp.graphics.beginFill(16711680,0);
            this._clickSp.graphics.drawRect(0,0,this._playerName.textWidth,this._playerName.textHeight);
            this._clickSp.graphics.endFill();
            addChild(this._clickSp);
            this._clickSp.buttonMode = true;
            this._clickSp.y = this._playerName.y;
            this._clickSp.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         this.upPos();
      }
      
      private function upSendedItemView() : void
      {
         this._recordItemBg.visible = false;
         this._receiedIcon.visible = false;
         this._sendIcon.visible = true;
         this._headTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.sendedHeadTxt");
         this._giftNameTxt.text = this._info.info.TemplateInfo.Name;
         this._giftCountTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.giftCount",this._info.count);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("RecordItem.senderTxt");
         addChild(this._playerName);
         this._playerName.text = this._info.name;
         if(this._playerName.text.length > 10)
         {
            this._playerName.text = this._playerName.text.substr(0,7) + "...";
         }
         this.upPos();
      }
      
      private function upPos() : void
      {
         this._playerName.x = this._headTxt.x + this._headTxt.textWidth + 4;
         if(Boolean(this._clickSp))
         {
            this._clickSp.x = this._playerName.x;
         }
         this._giftNameTxt.x = this._playerName.x + this._playerName.textWidth + 4;
         this._itemCell.x = this._giftNameTxt.x + this._giftNameTxt.textWidth;
         this._itemCell.y = -5;
         this._giftCountTxt.x = this._itemCell.x + this._itemCell.width + 4;
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         RebackMenu.Instance.show(this._info,StageReferance.stage.mouseX,StageReferance.stage.mouseY);
      }
      
      override public function get height() : Number
      {
         return THISHEIGHT;
      }
      
      public function dispose() : void
      {
         if(GiftController.Instance.canActive && Boolean(this._playerName))
         {
            this._playerName.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         this._info = null;
         if(Boolean(this._recordItemBg))
         {
            ObjectUtils.disposeObject(this._recordItemBg);
         }
         this._recordItemBg = null;
         if(Boolean(this._line1))
         {
            ObjectUtils.disposeObject(this._line1);
         }
         this._line1 = null;
         if(Boolean(this._receiedIcon))
         {
            ObjectUtils.disposeObject(this._receiedIcon);
         }
         this._receiedIcon = null;
         if(Boolean(this._sendIcon))
         {
            ObjectUtils.disposeObject(this._sendIcon);
         }
         this._sendIcon = null;
         if(Boolean(this._headTxt))
         {
            ObjectUtils.disposeObject(this._headTxt);
         }
         this._headTxt = null;
         if(Boolean(this._giftNameTxt))
         {
            ObjectUtils.disposeObject(this._giftNameTxt);
         }
         this._giftNameTxt = null;
         if(Boolean(this._giftCountTxt))
         {
            ObjectUtils.disposeObject(this._giftCountTxt);
         }
         this._giftCountTxt = null;
         if(Boolean(this._playerName))
         {
            ObjectUtils.disposeObject(this._playerName);
         }
         this._playerName = null;
         if(Boolean(this._itemCell))
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(Boolean(this._clickSp))
         {
            ObjectUtils.disposeObject(this._clickSp);
         }
         this._clickSp = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

