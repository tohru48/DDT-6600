package drgnBoat.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import drgnBoat.DrgnBoatManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DrgnBoatEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:MovieClip;
      
      public function DrgnBoatEntryBtn()
      {
         super();
         this.buttonMode = true;
         this.mouseChildren = false;
         this._btn = ComponentFactory.Instance.creat("asset.hall.dragonBoatBtn");
         this._btn.gotoAndStop(1);
         addChild(this._btn);
         addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(DrgnBoatManager.instance.isInGame)
         {
            DrgnBoatManager.instance.addEventListener(DrgnBoatManager.CAN_ENTER,this.canEnterHandler);
            SocketManager.Instance.out.sendEscortCanEnter();
         }
         else
         {
            DrgnBoatManager.instance.loadDrgnBoatModule();
         }
      }
      
      private function canEnterHandler(event:Event) : void
      {
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.CAN_ENTER,this.canEnterHandler);
         StateManager.setState(StateType.DRGN_BOAT);
      }
      
      public function dispose() : void
      {
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.CAN_ENTER,this.canEnterHandler);
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

