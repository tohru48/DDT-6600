package gypsyShop.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyShopModel;
   import gypsyShop.ui.GypsyItemCell;
   
   public class GypsyShopMainFrame extends Frame implements Disposeable
   {
      
      private var _model:GypsyShopModel;
      
      private var _bg:Bitmap;
      
      private var _rareTitle:Bitmap;
      
      private var _coolShiningMCList:Vector.<MovieClip>;
      
      private var _rareList:Vector.<BagCell>;
      
      private var _itemList:Vector.<GypsyItemCell>;
      
      private var _rmbTicketsIcon:Bitmap;
      
      private var _honourIcon:Bitmap;
      
      private var _ticketsBG:Bitmap;
      
      private var _honourBG:Bitmap;
      
      private var _rmbTicketsText:FilterFrameText;
      
      private var _honourText:FilterFrameText;
      
      private var _refreshTimeDetails:FilterFrameText;
      
      private var _refreshBtn:BaseButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      public function GypsyShopMainFrame()
      {
         super();
      }
      
      public function setModel(modelProxy:GypsyShopModel) : void
      {
         this._model = modelProxy;
      }
      
      override protected function init() : void
      {
         var i:int = 0;
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("gypsy.frame.bg");
         addToContent(this._bg);
         this._rareTitle = ComponentFactory.Instance.creatBitmap("gypsy.frame.rare.title");
         addToContent(this._rareTitle);
         this._ticketsBG = ComponentFactory.Instance.creatBitmap("gypsy.money.bg");
         PositionUtils.setPos(this._ticketsBG,"gypsy.pt.rmb");
         addToContent(this._ticketsBG);
         this._rmbTicketsIcon = ComponentFactory.Instance.creatBitmap("gypsy.icon.dianjuanWithBG");
         addToContent(this._rmbTicketsIcon);
         this._rmbTicketsText = ComponentFactory.Instance.creat("gypsy.textfield.rmbTicketRemain");
         addToContent(this._rmbTicketsText);
         this._rmbTicketsText.text = "0";
         this._honourBG = ComponentFactory.Instance.creatBitmap("gypsy.money.bg");
         PositionUtils.setPos(this._honourBG,"gypsy.pt.honour.bg");
         addToContent(this._honourBG);
         this._honourIcon = ComponentFactory.Instance.creatBitmap("gypsy.icon.honor");
         PositionUtils.setPos(this._honourIcon,"gypsy.pt.honour.icon");
         addToContent(this._honourIcon);
         this._honourText = ComponentFactory.Instance.creat("gypsy.textfield.honourRemain");
         addToContent(this._honourText);
         this._honourText.text = "0";
         this._refreshTimeDetails = ComponentFactory.Instance.creat("gypsy.textfield.timeRefreshDetail");
         addToContent(this._refreshTimeDetails);
         this._refreshTimeDetails.text = LanguageMgr.GetTranslation("gypsy.refresh.details","18:00");
         this._refreshBtn = ComponentFactory.Instance.creat("gypsy.refreshBtn");
         addToContent(this._refreshBtn);
         this._itemList = new Vector.<GypsyItemCell>();
         for(i = 0; i < 8; i++)
         {
            this._itemList[i] = new GypsyItemCell();
            this._itemList[i].x = 27 + 218 * (i % 2);
            this._itemList[i].y = 148 + 86 * int(i / 2);
            addToContent(this._itemList[i]);
         }
         this._helpBtn = ComponentFactory.Instance.creat("gypsy.btn.helpBtn");
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.onHelp);
         addToContent(this._helpBtn);
         this._rareList = new Vector.<BagCell>();
         this._coolShiningMCList = new Vector.<MovieClip>();
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(FrameEvent.RESPONSE,this._response);
         this.updateWealth();
      }
      
      protected function onHelp(me:MouseEvent) : void
      {
         var helpFrame:GypsyHelpFrame = ComponentFactory.Instance.creat("gypsy.helpFrame");
         helpFrame.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      public function updateNewItemList() : void
      {
         var i:int = 0;
         var len:int = Math.min(8,this._model.itemDataList.length);
         for(i = 0; i < this._itemList.length; i++)
         {
            this._itemList[i].clear();
         }
         for(i = 0; i < len; i++)
         {
            this._itemList[i].updateCell(this._model.itemDataList[i]);
         }
         this.updateWealth();
      }
      
      public function updateBuyResult() : void
      {
         var item:GypsyItemCell = null;
         var id:int = int(this._model.buyResult.id);
         for each(item in this._itemList)
         {
            if(item.id == id)
            {
               item.updateBuyButtonState(this._model.buyResult.canBuy);
            }
         }
         this.updateWealth();
      }
      
      public function updateRareItemsList() : void
      {
         var i:int = 0;
         var bagCell:BagCell = null;
         var mc:MovieClip = null;
         for(i = 0; i < this._rareList.length; i++)
         {
            bagCell = this._rareList[i];
            ObjectUtils.disposeObject(bagCell);
         }
         this._rareList = new Vector.<BagCell>();
         var len:int = int(this._model.listRareItemTempleteIDs.length);
         for(i = 0; i < len; i++)
         {
            this._rareList[i] = new BagCell(0,ItemManager.Instance.getTemplateById(this._model.listRareItemTempleteIDs[i]));
            this._rareList[i].x = 76 + 56 * i;
            this._rareList[i].y = 85;
            addToContent(this._rareList[i]);
            mc = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
            mc.mouseChildren = false;
            mc.mouseEnabled = false;
            mc.x = this._rareList[i].x - 1;
            mc.y = this._rareList[i].y - 1;
            mc.alpha = 0.5;
            addToContent(mc);
            this._coolShiningMCList.push(mc);
         }
         this.updateWealth();
      }
      
      private function updateWealth() : void
      {
         this._rmbTicketsText.text = PlayerManager.Instance.Self.Money.toString();
         this._honourText.text = PlayerManager.Instance.Self.myHonor.toString();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         SoundManager.instance.play("008");
         GypsyShopManager.getInstance().hideMainFrame();
      }
      
      protected function onClick(me:MouseEvent) : void
      {
         if(me.target == this._refreshBtn)
         {
            GypsyShopManager.getInstance().refreshBtnClicked();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.onHelp);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         ObjectUtils.disposeObject(this._refreshBtn);
         this._refreshBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rareTitle);
         this._rareTitle = null;
         ObjectUtils.disposeObject(this._rmbTicketsIcon);
         this._rmbTicketsIcon = null;
         ObjectUtils.disposeObject(this._rmbTicketsText);
         this._rmbTicketsText = null;
         ObjectUtils.disposeObject(this._honourBG);
         this._honourBG = null;
         ObjectUtils.disposeObject(this._honourIcon);
         this._honourIcon = null;
         ObjectUtils.disposeObject(this._honourText);
         this._honourText = null;
         ObjectUtils.disposeObject(this._refreshTimeDetails);
         this._refreshTimeDetails = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         this._itemList.length = 0;
         this._itemList = null;
         this._rareList.length = 0;
         this._rareList = null;
         var len:int = int(this._coolShiningMCList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._coolShiningMCList[i].stop();
         }
         this._coolShiningMCList.length = 0;
         this._coolShiningMCList = null;
         this._model = null;
         super.dispose();
      }
   }
}

