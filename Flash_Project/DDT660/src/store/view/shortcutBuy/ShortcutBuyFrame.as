package store.view.shortcutBuy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortcutBuyFrame extends Frame
   {
      
      public static const ADDFrameHeight:int = 60;
      
      public static const ADD_OKBTN_Y:int = 53;
      
      private var _view:ShortCutBuyView;
      
      private var _panelIndex:int;
      
      private var _showRadioBtn:Boolean;
      
      private var okBtn:TextButton;
      
      public function ShortcutBuyFrame()
      {
         super();
      }
      
      public function show(templateIDList:Array, showRadioBtn:Boolean, title:String, panelIndex:int, selectedIndex:int = -1, hSpace:Number = 30, vSpace:Number = 40) : void
      {
         this.titleText = title;
         this._showRadioBtn = showRadioBtn;
         this._panelIndex = panelIndex;
         this._view = ComponentFactory.Instance.creatCustomObject("ddtstore.ShortcutBuyFrame.ShortcutBuyView",[templateIDList,showRadioBtn]);
         escEnable = true;
         enterEnable = true;
         this.initII();
         this.initEvents();
         this.showToLayer();
         this.relocationView(selectedIndex,hSpace,vSpace);
      }
      
      private function relocationView(selectedIndex:int, hSpace:Number, vSpace:Number) : void
      {
         if(selectedIndex != -1)
         {
            this._view.List.selectedIndex = selectedIndex;
         }
         this._view.List.list.hSpace = hSpace;
         this._view.List.list.vSpace = vSpace;
      }
      
      private function initII() : void
      {
         this._view.addEventListener(Event.CHANGE,this.changeHandler);
         this._view.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         addToContent(this._view);
         if(!this._showRadioBtn)
         {
            this._view.x += 5;
         }
         this.okBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortBuyFrameEnter");
         this.okBtn.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         height = this._view.height + this._containerY + ADDFrameHeight;
         this.okBtn.y = height - ADD_OKBTN_Y;
         addChild(this.okBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this.okBtn.addEventListener(MouseEvent.CLICK,this.okFun);
         addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this.okBtn.removeEventListener(MouseEvent.CLICK,this.okFun);
         removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberClose(e:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.okFun(null);
      }
      
      private function changeHandler(evt:Event) : void
      {
         this.okBtn.enable = this._view.totalDDTMoney != 0 || this._view.totalMoney != 0;
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
         else if(e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFun(null);
         }
      }
      
      private function okFun(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._view.currentShopItem == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
            this._view.List.shine();
            return;
         }
         if(this._view.isBand && PlayerManager.Instance.Self.BandMoney < this._view.totalMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
            return;
         }
         if(!this._view.isBand && PlayerManager.Instance.Self.Money < this._view.totalMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this.buyGoods();
         this._view.save();
         this.dispose();
      }
      
      private function buyGoods() : void
      {
         var items:Array = [];
         var types:Array = [];
         var colors:Array = [];
         var dresses:Array = [];
         var skins:Array = [];
         var places:Array = [];
         var bands:Array = [];
         var goodsID:int = this._view.currentShopItem.GoodsID;
         var num:int = this._view.totalNum;
         for(var i:int = 0; i < num; i++)
         {
            items.push(goodsID);
            types.push(1);
            colors.push("");
            dresses.push(false);
            skins.push("");
            places.push(-1);
            bands.push(this._view.isBand);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,dresses,skins,places,this._panelIndex,null,bands);
      }
      
      private function showToLayer() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._view.removeEventListener(Event.CHANGE,this.changeHandler);
         this._view.dispose();
         super.dispose();
         this._view = null;
         if(Boolean(this.okBtn))
         {
            ObjectUtils.disposeObject(this.okBtn);
         }
         this.okBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

