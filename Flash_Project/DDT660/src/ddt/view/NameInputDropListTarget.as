package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.list.IDropListTarget;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class NameInputDropListTarget extends Sprite implements IDropListTarget, Disposeable
   {
      
      public static const LOOK:int = 1;
      
      public static const CLOSE:int = 2;
      
      public static const CLOSE_CLICK:String = "closeClick";
      
      public static const CLEAR_CLICK:String = "clearClick";
      
      public static const LOOK_CLICK:String = "lookClick";
      
      protected var _background:Image;
      
      protected var _nameInput:TextInput;
      
      protected var _closeBtn:BaseButton;
      
      protected var _lookBtn:Bitmap;
      
      private var _isListening:Boolean;
      
      public function NameInputDropListTarget()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._background = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.InputTextBg");
         this._nameInput = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.NameInput");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("core.nameInputDropListTarget.Close");
         this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.searchIcon");
         addChild(this._background);
         addChild(this._nameInput);
         addChild(this._closeBtn);
         addChild(this._lookBtn);
         this.switchView(LOOK);
      }
      
      public function set text(value:String) : void
      {
         this._nameInput.text = value;
      }
      
      public function get text() : String
      {
         return this._nameInput.text;
      }
      
      public function switchView(type:int) : void
      {
         switch(type)
         {
            case LOOK:
               this._lookBtn.visible = true;
               this._closeBtn.visible = false;
               break;
            case CLOSE:
               this._lookBtn.visible = false;
               this._closeBtn.visible = true;
         }
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__changeDropList);
         this._nameInput.addEventListener(FocusEvent.FOCUS_IN,this._focusHandler);
      }
      
      public function set enable(value:Boolean) : void
      {
         this._nameInput.enable = value;
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._nameInput.removeEventListener(Event.CHANGE,this.__changeDropList);
         this._nameInput.removeEventListener(FocusEvent.FOCUS_IN,this._focusHandler);
      }
      
      public function setCursor(index:int) : void
      {
         this._nameInput.textField.setSelection(index,index);
      }
      
      public function get caretIndex() : int
      {
         return this._nameInput.textField.caretIndex;
      }
      
      public function setValue(value:*) : void
      {
         if(value)
         {
            this._nameInput.text = value.NickName;
         }
      }
      
      public function getValueLength() : int
      {
         if(Boolean(this._nameInput))
         {
            return this._nameInput.text.length;
         }
         return 0;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         if(Boolean(this._nameInput))
         {
            ObjectUtils.disposeObject(this._nameInput);
         }
         this._nameInput = null;
         if(Boolean(this._closeBtn))
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(Boolean(this._lookBtn))
         {
            ObjectUtils.disposeObject(this._lookBtn);
         }
         this._lookBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __clearhandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(CLEAR_CLICK));
      }
      
      protected function __closeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nameInput.text = "";
         this.switchView(LOOK);
         dispatchEvent(new Event(CLOSE_CLICK));
      }
      
      protected function __changeDropList(event:Event) : void
      {
         StringHelper.checkTextFieldLength(this._nameInput.textField,14);
         if(this._nameInput.text == "")
         {
            this.switchView(LOOK);
         }
         else
         {
            this.switchView(CLOSE);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function _focusHandler(event:FocusEvent) : void
      {
         this.__changeDropList(null);
      }
   }
}

