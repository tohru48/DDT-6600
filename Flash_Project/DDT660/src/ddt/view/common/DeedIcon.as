package ddt.view.common
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import ddtDeed.DeedManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class DeedIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _isOpen:Boolean;
      
      private var payMoney:int;
      
      public function DeedIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.playerInfo.ddtDeed");
         addChild(this._icon);
         this.buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function __openDeedFrameHandlder(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.judgeOpen())
         {
            return;
         }
         this.openConfirmFrame();
      }
      
      private function judgeOpen() : Boolean
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         this.payMoney = ServerConfigManager.instance.getDeedPrices[0];
         return true;
      }
      
      private function openConfirmFrame() : void
      {
         var msg:String = LanguageMgr.GetTranslation("ddt.deedFrame.openPromptTxt",this.payMoney);
         if(this._isOpen)
         {
            msg = LanguageMgr.GetTranslation("ddt.deedFrame.openPromptTxt2",DeedManager.instance.deedTimeStr.toLowerCase(),this.payMoney);
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         var id:int = 0;
         var msg:String = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            id = PlayerManager.Instance.Self.ID;
            msg = "";
            if(BuriedManager.Instance.checkMoney(confirmFrame.isBand,this.payMoney))
            {
               return;
            }
            SocketManager.Instance.out.sendOpenDeed(10,id,msg,false);
            confirmFrame.dispose();
         }
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function updateIcon() : void
      {
         if(!this._isOpen)
         {
            this._icon.filters = [new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0])];
         }
         else
         {
            this._icon.filters = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this);
         removeChild(this._icon);
         this._icon.bitmapData.dispose();
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__openDeedFrameHandlder);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_MAIN_EVENT,this.__refreshBtnState);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__openDeedFrameHandlder);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_MAIN_EVENT,this.__refreshBtnState);
      }
      
      private function __refreshBtnState(event:Event) : void
      {
         this._isOpen = DeedManager.instance.isOpen;
         this.updateIcon();
      }
      
      public function setInfo(isOpen:Boolean, isSelf:Boolean) : void
      {
         this._isOpen = isOpen;
         this.updateIcon();
         this.addEvent();
      }
      
      public function get tipData() : Object
      {
         return DeedManager.instance.getRemainTimeTxt();
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

