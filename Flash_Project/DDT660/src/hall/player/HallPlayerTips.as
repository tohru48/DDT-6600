package hall.player
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class HallPlayerTips extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _addFriend:IconButton;
      
      private var _privateChat:IconButton;
      
      private var _viewInfo:IconButton;
      
      private var _nickName:String;
      
      private var _id:int;
      
      public function HallPlayerTips()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.tipsBg");
         addChild(this._bg);
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("hall.playerTip.itemmakeFriend");
         addChild(this._addFriend);
         this._privateChat = ComponentFactory.Instance.creatComponentByStylename("hall.playerTip.privateChat");
         addChild(this._privateChat);
         this._viewInfo = ComponentFactory.Instance.creatComponentByStylename("hall.playerTip.viewInfo");
         addChild(this._viewInfo);
      }
      
      private function initEvent() : void
      {
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__onAddFriend);
         this._privateChat.addEventListener(MouseEvent.CLICK,this.__onPrivateChat);
         this._viewInfo.addEventListener(MouseEvent.CLICK,this.__onViewInfo);
      }
      
      public function setInfo(nickName:String, id:int) : void
      {
         this._nickName = nickName;
         this._id = id;
      }
      
      protected function __onViewInfo(event:MouseEvent) : void
      {
         PlayerInfoViewControl.viewByID(this._id,-1,true,false);
         PlayerInfoViewControl.isOpenFromBag = false;
         this.visible = false;
      }
      
      protected function __onPrivateChat(event:MouseEvent) : void
      {
         ChatManager.Instance.privateChatTo(this._nickName,this._id);
         this.visible = false;
      }
      
      protected function __onAddFriend(event:MouseEvent) : void
      {
         IMController.Instance.addFriend(this._nickName);
         this.visible = false;
      }
      
      private function removeEvent() : void
      {
         this._addFriend.removeEventListener(MouseEvent.CLICK,this.__onAddFriend);
         this._privateChat.removeEventListener(MouseEvent.CLICK,this.__onPrivateChat);
         this._viewInfo.removeEventListener(MouseEvent.CLICK,this.__onViewInfo);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._addFriend))
         {
            ObjectUtils.disposeObject(this._addFriend);
         }
         this._addFriend = null;
         if(Boolean(this._privateChat))
         {
            ObjectUtils.disposeObject(this._privateChat);
         }
         this._privateChat = null;
         if(Boolean(this._viewInfo))
         {
            ObjectUtils.disposeObject(this._viewInfo);
         }
         this._viewInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

