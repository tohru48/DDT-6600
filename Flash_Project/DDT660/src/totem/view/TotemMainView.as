package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import totem.TotemManager;
   
   public class TotemMainView extends Sprite implements Disposeable
   {
      
      private var _leftView:TotemLeftView;
      
      private var _rightView:TotemRightView;
      
      private var _activateProtectView:TotemActivateProtectView;
      
      public function TotemMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._leftView = ComponentFactory.Instance.creatCustomObject("totemLeftView");
         this._rightView = ComponentFactory.Instance.creatCustomObject("totemRightView");
         this._activateProtectView = new TotemActivateProtectView();
         addChild(this._rightView);
         addChild(this._leftView);
         addChild(this._activateProtectView);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      private function refresh(event:CrazyTankSocketEvent) : void
      {
         var isSuccess:Boolean = false;
         var pkg:PackageIn = event.pkg;
         pkg.readInt();
         PlayerManager.Instance.Self.damageScores = pkg.readInt();
         var id:int = pkg.readInt();
         if(id == PlayerManager.Instance.Self.totemId)
         {
            isSuccess = false;
            SoundManager.instance.play("202");
         }
         else
         {
            SoundManager.instance.play("201");
            isSuccess = true;
            PlayerManager.Instance.Self.totemId = id;
            TotemManager.instance.updatePropertyAddtion(PlayerManager.Instance.Self.totemId,PlayerManager.Instance.Self.propertyAddition);
            PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_PLAYER_PROPERTY));
         }
         this._leftView.refreshView(isSuccess);
         this._rightView.refreshView();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftView = null;
         this._rightView = null;
         this._activateProtectView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

