package roomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class PassInputFrame extends BaseAlerFrame implements Disposeable
   {
      
      private var _passInputText:TextInput;
      
      private var _explainText:FilterFrameText;
      
      private var _ID:int;
      
      public function PassInputFrame()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      private function initContainer() : void
      {
         var _alertInfo:AlertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         info = _alertInfo;
         this._passInputText = ComponentFactory.Instance.creat("asset.ddtroomlist.passinputFrame.input");
         this._passInputText.text = "";
         this._passInputText.textField.restrict = "0-9 A-Z a-z";
         addToContent(this._passInputText);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomlist.passinputFrame.explain");
         this._explainText.text = LanguageMgr.GetTranslation("baglocked.SetPassFrame1.inputTextInfo1");
         addToContent(this._explainText);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         addEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._passInputText.addEventListener(Event.CHANGE,this.__input);
         this._passInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__KeyDown);
      }
      
      private function __KeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            this.submit();
         }
      }
      
      private function __addStage(event:Event) : void
      {
         if(Boolean(this._passInputText))
         {
            submitButtonEnable = false;
            this._passInputText.setFocus();
         }
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      private function submit() : void
      {
         SoundManager.instance.play("008");
         if(this._passInputText.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIPassInput.write"));
            return;
         }
         if(StateManager.currentStateType == StateType.ROOM_LIST)
         {
            SocketManager.Instance.out.sendGameLogin(1,-1,this._ID,this._passInputText.text);
         }
         else if(StateManager.currentStateType == StateType.DUNGEON_LIST)
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,this._ID,this._passInputText.text);
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(4,-1,this._ID,this._passInputText.text);
         }
         this.hide();
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function set ID(value:int) : void
      {
         this._ID = value;
      }
      
      private function hide() : void
      {
         this.dispose();
      }
      
      private function __input(e:Event) : void
      {
         if(this._passInputText.text != "")
         {
            submitButtonEnable = true;
         }
         else
         {
            submitButtonEnable = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._passInputText.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

