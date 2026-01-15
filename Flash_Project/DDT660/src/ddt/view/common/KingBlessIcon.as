package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import kingBless.KingBlessManager;
   
   public class KingBlessIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _isOpen:Boolean;
      
      private var _isSelf:Boolean;
      
      public function KingBlessIcon(id:int)
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.playerInfo.kingBless" + id);
         addChild(this._icon);
         this.buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function __openKingBlessFrameHandlder(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         KingBlessManager.instance.loadKingBlessModule(KingBlessManager.instance.doOpenKingBlessFrame);
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
         addEventListener(MouseEvent.CLICK,this.__openKingBlessFrameHandlder);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.__refreshBtnState);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__openKingBlessFrameHandlder);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.__refreshBtnState);
      }
      
      private function __refreshBtnState(event:Event) : void
      {
         var openType:int = KingBlessManager.instance.openType;
         if(openType > 0)
         {
            this._isOpen = true;
            this.updateIcon();
         }
      }
      
      public function setInfo(isOpen:Boolean, isSelf:Boolean) : void
      {
         this._isOpen = isOpen;
         this._isSelf = isSelf;
         this.updateIcon();
         if(this._isSelf)
         {
            this.addEvent();
         }
         else
         {
            this.removeEvent();
         }
      }
      
      public function get tipData() : Object
      {
         var obj:Object = null;
         var obj2:Object = null;
         if(!this._isOpen)
         {
            obj = new Object();
            obj.isOpen = false;
            obj.content = LanguageMgr.GetTranslation("ddt.kingBlessFrame.noOpenTipTxt");
            return obj;
         }
         if(this._isSelf)
         {
            return KingBlessManager.instance.getRemainTimeTxt();
         }
         obj2 = new Object();
         obj2.isOpen = true;
         obj2.isSelf = false;
         obj2.content = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openTipTxt");
         return obj2;
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

