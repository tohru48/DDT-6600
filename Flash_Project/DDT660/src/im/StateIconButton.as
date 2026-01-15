package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.list.IDropListTarget;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.data.player.PlayerState;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class StateIconButton extends Sprite implements IDropListTarget, Disposeable
   {
      
      private var _btn:BaseButton;
      
      private var _stateIcon:ScaleFrameImage;
      
      public function StateIconButton()
      {
         super();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("IMView.selectStateBtn");
         addChild(this._btn);
         this._stateIcon = ComponentFactory.Instance.creatComponentByStylename("im.stateIcon");
         this._stateIcon.setFrame(PlayerManager.Instance.Self.playerState.StateID);
         this._stateIcon.mouseChildren = false;
         this._stateIcon.mouseEnabled = false;
         addChild(this._stateIcon);
      }
      
      public function setCursor(index:int) : void
      {
         this._stateIcon.setFrame(index);
      }
      
      public function setFrame(index:int) : void
      {
         this._stateIcon.setFrame(index);
      }
      
      public function get caretIndex() : int
      {
         return 0;
      }
      
      public function setValue(value:*) : void
      {
         this._stateIcon.setFrame(PlayerState(value).StateID);
         if(PlayerManager.Instance.Self.playerState.StateID != PlayerState(value).StateID)
         {
            SocketManager.Instance.out.sendFriendState(PlayerState(value).StateID);
         }
         PlayerManager.Instance.Self.playerState = value;
      }
      
      public function getValueLength() : int
      {
         return 0;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
      }
   }
}

