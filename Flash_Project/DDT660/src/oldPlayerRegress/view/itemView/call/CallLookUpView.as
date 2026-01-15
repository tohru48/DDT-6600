package oldPlayerRegress.view.itemView.call
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class CallLookUpView extends Sprite implements Disposeable
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _cleanUpBtn:BaseButton;
      
      private var _inputText:TextInput;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _list:VBox;
      
      private var _NAN:FilterFrameText;
      
      private var _lookBtn:Bitmap;
      
      public function CallLookUpView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("call.inputBg");
         addChild(this._bg);
         this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.searchIcon");
         PositionUtils.setPos(this._lookBtn,"regress.call.lookBtn.pos");
         addChild(this._lookBtn);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("call.textinput");
         addChild(this._inputText);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("call.Lookup.lookUpBG");
         this._bg2.visible = false;
         addChild(this._bg2);
         this._list = ComponentFactory.Instance.creat("call.Lookup.lookupList");
         addChild(this._list);
         this._cleanUpBtn = ComponentFactory.Instance.creatComponentByStylename("call.cleanUpBtn");
         this._cleanUpBtn.visible = false;
         addChild(this._cleanUpBtn);
         this._NAN = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.IMLookupItemName");
         this._NAN.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
         this._NAN.visible = false;
         this._NAN.x = this._bg2.x + 10;
         this._NAN.y = this._bg2.y + 7;
         addChild(this._NAN);
      }
      
      private function initEvent() : void
      {
         this.inputText.addEventListener(Event.CHANGE,this.__textInput);
      }
      
      private function __textInput(event:Event) : void
      {
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this.inputText))
         {
            this.inputText.removeEventListener(Event.CHANGE,this.__textInput);
         }
      }
      
      private function hide() : void
      {
         this._bg2.visible = false;
         this._NAN.visible = false;
         this._cleanUpBtn.visible = false;
         this._list.visible = false;
         this._lookBtn.visible = true;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg2))
         {
            this._bg2.dispose();
            this._bg2 = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._cleanUpBtn))
         {
            this._cleanUpBtn.dispose();
            this._cleanUpBtn = null;
         }
         if(Boolean(this.inputText))
         {
            this.inputText.dispose();
            this.inputText = null;
         }
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._NAN))
         {
            ObjectUtils.disposeObject(this._NAN);
            this._NAN = null;
         }
         if(Boolean(this._lookBtn))
         {
            this._lookBtn = null;
         }
      }
      
      public function get inputText() : TextInput
      {
         return this._inputText;
      }
      
      public function set inputText(value:TextInput) : void
      {
         this._inputText = value;
      }
   }
}

