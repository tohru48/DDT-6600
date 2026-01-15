package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class RoomLookUpView extends Sprite implements Disposeable
   {
      
      private var _hallType:int;
      
      private var _bg:Scale9CornerImage;
      
      private var _inputText:TextInput;
      
      private var _lookup:Bitmap;
      
      private var _enterBtn:TextButton;
      
      private var _flushBtn:TextButton;
      
      private var _dividingLine:Bitmap;
      
      private var _updateClick:Function;
      
      public function RoomLookUpView(func:Function, hallType:int)
      {
         super();
         this.init();
         this.initEvent();
         this._updateClick = func;
         this._hallType = hallType;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.lookupInputBg");
         addChild(this._bg);
         this._lookup = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.lookup");
         addChild(this._lookup);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.textinput");
         this._inputText.textField.restrict = "0-9";
         addChild(this._inputText);
         this._inputText.text = LanguageMgr.GetTranslation("room.roomList.lookup.text");
         this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.enter");
         this._enterBtn.text = LanguageMgr.GetTranslation("room.roomList.enterBtn.text");
         addChild(this._enterBtn);
         this._flushBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.flush");
         this._flushBtn.text = LanguageMgr.GetTranslation("room.roomList.flushBtn.text");
         addChild(this._flushBtn);
         this._dividingLine = ComponentFactory.Instance.creat("asset.ddtroomlist.right.dividingLine");
         addChild(this._dividingLine);
      }
      
      private function initEvent() : void
      {
         this._inputText.addEventListener(MouseEvent.CLICK,this.__textClick);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._enterBtn.addEventListener(MouseEvent.CLICK,this.__onEnterBtnClick);
         this._flushBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
      }
      
      protected function __onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick);
            SoundManager.instance.play("008");
            if(this._inputText.text.length == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
            }
            else
            {
               SocketManager.Instance.out.sendGameLogin(this._hallType,-1,int(this._inputText.text),"");
            }
         }
      }
      
      private function __updateClick(event:MouseEvent) : void
      {
         if(this._updateClick != null)
         {
            this._updateClick(event);
         }
      }
      
      protected function __onStageClick(event:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick);
         this._inputText.text = LanguageMgr.GetTranslation("room.roomList.lookup.text");
      }
      
      protected function __textClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         stage.addEventListener(MouseEvent.CLICK,this.__onStageClick);
         this._inputText.text = "";
      }
      
      protected function __onEnterBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._inputText.text.length == 6)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(this._hallType,-1,int(this._inputText.text),"");
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._inputText))
         {
            this._inputText.removeEventListener(MouseEvent.CLICK,this.__textClick);
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         }
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick);
         }
         this._enterBtn.removeEventListener(MouseEvent.CLICK,this.__onEnterBtnClick);
         this._flushBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._inputText))
         {
            this._inputText.dispose();
            this._inputText = null;
         }
         if(Boolean(this._lookup))
         {
            this._lookup.bitmapData.dispose();
            this._lookup = null;
         }
         if(Boolean(this._enterBtn))
         {
            this._enterBtn.dispose();
            this._enterBtn = null;
         }
         if(Boolean(this._flushBtn))
         {
            this._flushBtn.dispose();
            this._flushBtn = null;
         }
         if(Boolean(this._dividingLine))
         {
            ObjectUtils.disposeObject(this._dividingLine);
            this._dividingLine = null;
         }
      }
   }
}

