package room.view.states
{
   import com.pickgliss.ui.LayerManager;
   import ddt.data.BagInfo;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   import room.view.RoomRightPropView;
   import trainer.controller.NewHandGuideManager;
   
   public class FreshmanRoomState extends BaseRoomState
   {
      
      private var black:Sprite;
      
      public function FreshmanRoomState()
      {
         super();
      }
      
      override public function getType() : String
      {
         if(StartupResourceLoader.firstEnterHall)
         {
            return StateType.FRESHMAN_ROOM2;
         }
         return StateType.FRESHMAN_ROOM1;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         MainToolBar.Instance.hide();
         LayerManager.Instance.clearnGameDynamic();
         this.black = new Sprite();
         this.black.graphics.beginFill(0,1);
         this.black.graphics.drawRect(0,0,1000,600);
         this.black.graphics.endFill();
         addChild(this.black);
         if((NewHandGuideManager.Instance.mapID == 115 || NewHandGuideManager.Instance.mapID == 116) && PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items.length < RoomRightPropView.UPCELLS_NUMBER)
         {
            SocketManager.Instance.out.sendBuyProp(1001202,false);
         }
         SocketManager.Instance.out.enterUserGuide(NewHandGuideManager.Instance.mapID);
         GameInSocketOut.sendGameStart();
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         if(Boolean(this.black) && Boolean(this.black.parent))
         {
            this.black.parent.removeChild(this.black);
         }
         super.leaving(next);
      }
   }
}

