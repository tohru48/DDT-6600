package roomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class LookupRoomFrame extends BaseAlerFrame implements Disposeable
   {
      
      private var _idInputText:TextInput;
      
      private var _passInputText:TextInput;
      
      private var _idText:FilterFrameText;
      
      private var _checkBox:SelectedCheckButton;
      
      public function LookupRoomFrame()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      private function initContainer() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         var _alertInfo:AlertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.search");
         info = _alertInfo;
         this._idInputText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.idinput");
         this._idInputText.text = "";
         this._idInputText.textField.restrict = "0-9";
         this._idInputText.textField.wordWrap = false;
         this._idInputText.textField.autoSize = "none";
         this._idInputText.textField.width = 135;
         addToContent(this._idInputText);
         this._passInputText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.passinput");
         this._passInputText.text = "";
         this._passInputText.textField.restrict = "0-9 A-Z a-z";
         addToContent(this._passInputText);
         this._idText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.id");
         addToContent(this._idText);
         this._idText.text = LanguageMgr.GetTranslation("ddt.roomlist.lookupframe.id");
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.lookupRoomFrame.selectBtn");
         addToContent(this._checkBox);
         this._checkBox.text = LanguageMgr.GetTranslation("ddt.roomlist.lookupframe.password");
         this.checkEnable();
      }
      
      private function initEvent() : void
      {
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         addEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._idInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._passInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
      }
      
      private function __onkeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            this.submit();
         }
      }
      
      private function __addStage(event:Event) : void
      {
         IMEManager.disable();
         if(Boolean(this._idInputText))
         {
            this._idInputText.setFocus();
         }
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hide();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      protected function submit() : void
      {
         if(Boolean(stage))
         {
            if(this._idInputText.text == "")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
               return;
            }
            if(StateManager.currentStateType == StateType.DUNGEON_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(2,-1,int(this._idInputText.text),this._passInputText.text);
            }
            else
            {
               SocketManager.Instance.out.sendGameLogin(1,-1,int(this._idInputText.text),this._passInputText.text);
            }
         }
         this.hide();
      }
      
      protected function hide() : void
      {
         this.dispose();
      }
      
      private function __checkBoxClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._passInputText.text = "";
         this.checkEnable();
      }
      
      private function checkEnable() : void
      {
         if(this._checkBox.selected)
         {
            this._passInputText.setFocus();
            this._passInputText.mouseChildren = true;
            this._passInputText.mouseEnabled = true;
         }
         else
         {
            this._idInputText.setFocus();
            this._passInputText.mouseChildren = false;
            this._passInputText.mouseEnabled = false;
         }
      }
      
      override public function dispose() : void
      {
         this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._idInputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._passInputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._checkBox.dispose();
         this._idInputText.dispose();
         this._passInputText.dispose();
         super.dispose();
      }
   }
}

