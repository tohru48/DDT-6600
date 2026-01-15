package escort.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import escort.EscortManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EscortEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:MovieClip;
      
      public function EscortEntryBtn()
      {
         super();
         this.buttonMode = true;
         this.mouseChildren = false;
         this._btn = ComponentFactory.Instance.creat("asset.escort.entryBtn");
         this._btn.gotoAndStop(1);
         addChild(this._btn);
         addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(EscortManager.instance.isInGame)
         {
            EscortManager.instance.addEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
            SocketManager.Instance.out.sendEscortCanEnter();
         }
         else
         {
            EscortManager.instance.loadEscortModule();
         }
      }
      
      private function canEnterHandler(event:Event) : void
      {
         EscortManager.instance.removeEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
         StateManager.setState(StateType.ESCORT);
      }
      
      public function dispose() : void
      {
         EscortManager.instance.removeEventListener(EscortManager.CAN_ENTER,this.canEnterHandler);
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         if(Boolean(this._btn))
         {
            this._btn.gotoAndStop(2);
         }
         removeChild(this._btn);
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

