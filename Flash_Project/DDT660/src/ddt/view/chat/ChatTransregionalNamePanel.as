package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.image.Image;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class ChatTransregionalNamePanel extends ChatBasePanel
   {
      
      private var _bg:Image;
      
      private var _blackListBtn:IconButton;
      
      private var _name:String;
      
      public function ChatTransregionalNamePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListBgII");
         this._blackListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.TransregionalItemBlackList");
         addChild(this._bg);
         addChild(this._blackListBtn);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._blackListBtn.addEventListener(MouseEvent.CLICK,this.__onblackList);
      }
      
      public function set NickName(value:String) : void
      {
         this._name = value;
      }
      
      public function get NickName() : String
      {
         return this._name;
      }
      
      protected function __onblackList(event:MouseEvent) : void
      {
         IMController.Instance.addTransregionalblackList(this._name);
      }
      
      public function getHight() : int
      {
         return this._bg.height;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._blackListBtn.removeEventListener(MouseEvent.CLICK,this.__onblackList);
      }
   }
}

