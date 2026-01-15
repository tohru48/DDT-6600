package sevenDouble.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sevenDouble.SevenDoubleManager;
   
   public class SevenDoubleEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:MovieClip;
      
      public function SevenDoubleEntryBtn()
      {
         super();
         this.buttonMode = true;
         this.mouseChildren = false;
         this._btn = ComponentFactory.Instance.creat("assets.hallIcon.sevenDoubleEntryIcon");
         this._btn.gotoAndStop(1);
         addChild(this._btn);
         addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(SevenDoubleManager.instance.isInGame)
         {
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.CAN_ENTER,this.canEnterHandler);
            SocketManager.Instance.out.sendSevenDoubleCanEnter();
         }
         else
         {
            SevenDoubleManager.instance.loadSevenDoubleModule();
         }
      }
      
      private function canEnterHandler(event:Event) : void
      {
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.CAN_ENTER,this.canEnterHandler);
         StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
      }
      
      public function dispose() : void
      {
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.CAN_ENTER,this.canEnterHandler);
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         if(Boolean(this._btn))
         {
            removeChild(this._btn);
         }
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

