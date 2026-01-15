package overSeasCommunity.vietnam.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class RequestAddFriendTipFrame extends Frame
   {
      
      private var _tipField:FilterFrameText;
      
      private var _requestBtn:TextButton;
      
      private var _player:PlayerInfo;
      
      public function RequestAddFriendTipFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._tipField = ComponentFactory.Instance.creat("community.request.addFriend.tip");
         this._tipField.text = LanguageMgr.GetTranslation("community.request.AddFriend.tip");
         addToContent(this._tipField);
         this._requestBtn = ComponentFactory.Instance.creat("community.request.addFriend.button");
         this._requestBtn.text = LanguageMgr.GetTranslation("tank.menu.community.send");
         addToContent(this._requestBtn);
      }
      
      private function initEvent() : void
      {
         this._requestBtn.addEventListener(MouseEvent.CLICK,this.__request);
      }
      
      private function removeEvent() : void
      {
         this._requestBtn.removeEventListener(MouseEvent.CLICK,this.__request);
      }
      
      public function set player(info:PlayerInfo) : void
      {
         this._player = info;
      }
      
      private function __request(e:MouseEvent) : void
      {
         IMController.Instance.addFriend(this._player.NickName);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

