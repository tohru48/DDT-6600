package im.messagebox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import im.info.PresentRecordInfo;
   
   public class MessageBox extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _sign:Bitmap;
      
      private var _title:FilterFrameText;
      
      private var _cancelFlash:SimpleBitmapButton;
      
      private var _vbox:VBox;
      
      private var _item:Vector.<MessageBoxItem>;
      
      public var overState:Boolean;
      
      public function MessageBox()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("messageBox.bg");
         this._sign = ComponentFactory.Instance.creatBitmap("asset.messagebox.sign");
         this._title = ComponentFactory.Instance.creatComponentByStylename("messageBox.title");
         this._cancelFlash = ComponentFactory.Instance.creatComponentByStylename("messageBox.cancelFlash");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("messagebox.vbox");
         addChild(this._bg);
         addChild(this._sign);
         addChild(this._title);
         addChild(this._cancelFlash);
         addChild(this._vbox);
         this._item = new Vector.<MessageBoxItem>();
         this._title.text = LanguageMgr.GetTranslation("IM.messagebox.title");
         this._cancelFlash.addEventListener(MouseEvent.CLICK,this.__cancelFlashHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         this.overState = false;
         IMController.Instance.hideMessageBox();
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         this.overState = true;
      }
      
      protected function __cancelFlashHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.cancelFlash();
      }
      
      public function set message(message:Vector.<PresentRecordInfo>) : void
      {
         var item:MessageBoxItem = null;
         this.clearBox();
         for(var i:int = 0; i < message.length; i++)
         {
            item = new MessageBoxItem();
            item.recordInfo = message[i];
            item.addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            item.addEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
            this._vbox.addChild(item);
            this._item.push(item);
         }
         this._bg.height = this._item.length * 28 + 88;
      }
      
      private function clearBox() : void
      {
         for(var i:int = 0; i < this._item.length; i++)
         {
            if(Boolean(this._item[i]))
            {
               this._item[i].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._item[i].removeEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
               ObjectUtils.disposeObject(this._item[i]);
            }
            this._item[i] = null;
         }
         this._item = new Vector.<MessageBoxItem>();
      }
      
      protected function __itemDeleteHandler(event:Event) : void
      {
         var target:MessageBoxItem = event.currentTarget as MessageBoxItem;
         this._item.splice(this._item.indexOf(target),1);
         if(Boolean(target))
         {
            target.removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            target.removeEventListener(MessageBoxItem.DELETE,this.__itemDeleteHandler);
            ObjectUtils.disposeObject(target);
         }
         target = null;
         IMController.Instance.getMessage();
      }
      
      protected function __itemClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var target:MessageBoxItem = event.currentTarget as MessageBoxItem;
         IMController.Instance.alertPrivateFrame(target.recordInfo.id);
         IMController.Instance.getMessage();
      }
      
      public function dispose() : void
      {
         this._cancelFlash.removeEventListener(MouseEvent.CLICK,this.__cancelFlashHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this.clearBox();
         this._item = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._sign))
         {
            ObjectUtils.disposeObject(this._sign);
         }
         this._sign = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._cancelFlash))
         {
            ObjectUtils.disposeObject(this._cancelFlash);
         }
         this._cancelFlash = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

