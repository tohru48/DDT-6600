package im
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   
   public class AutoReplyInput extends Sprite implements Disposeable
   {
      
      private var WIDTH:int = 150;
      
      private var _input:FilterFrameText;
      
      private var _overBg:Bitmap;
      
      public function AutoReplyInput()
      {
         super();
         this._input = ComponentFactory.Instance.creatComponentByStylename("IM.stateItem.AutoReplyInputTxt");
         addChild(this._input);
         this._input.text = PlayerManager.Instance.Self.playerState.AutoReply;
         this._input.type = TextFieldType.INPUT;
         this._input.autoSize = TextFieldAutoSize.NONE;
         this._input.width = 160;
         this._input.height = 20;
         this._input.maxChars = 20;
         this._overBg = ComponentFactory.Instance.creatBitmap("asset.IM.replyInputBgAsset");
         addChild(this._overBg);
         this._overBg.visible = false;
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._input.addEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         this._input.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._input.removeEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         this._input.removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
      private function __onKeyDown(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         event.stopPropagation();
         if(event.keyCode == Keyboard.ENTER)
         {
            PlayerManager.Instance.Self.playerState.AutoReply = this._input.text;
            this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
            StageReferance.stage.focus = null;
         }
      }
      
      private function __focusOut(event:FocusEvent) : void
      {
         this._input.background = false;
         this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
         this._input.scrollH = 0;
      }
      
      private function __onChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["State"]))
         {
            this._input.text = this.getShortStr(PlayerManager.Instance.Self.playerState.AutoReply);
         }
      }
      
      private function __focusIn(event:FocusEvent) : void
      {
         this._overBg.visible = false;
         this._input.background = true;
         this._input.text = PlayerManager.Instance.Self.playerState.AutoReply;
         setTimeout(this._input.setSelection,30,0,this._input.text.length);
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         this._overBg.visible = false;
      }
      
      private function getShortStr(str:String) : String
      {
         var tf:TextField = new TextField();
         tf.wordWrap = true;
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.width = this._input.width;
         tf.text = str;
         if(tf.textWidth > this._input.width - 15)
         {
            str = tf.getLineText(0);
            str = str.substr(0,str.length - 3) + "...";
         }
         return str;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         if(this._input.background == false)
         {
            this._overBg.visible = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = null;
         ObjectUtils.disposeObject(this._input);
         this._input = null;
      }
   }
}

