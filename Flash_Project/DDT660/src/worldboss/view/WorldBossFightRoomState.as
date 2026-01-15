package worldboss.view
{
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import room.view.states.BaseRoomState;
   import worldboss.WorldBossManager;
   
   public class WorldBossFightRoomState extends BaseRoomState
   {
      
      public static var IsSuccessStartGame:Boolean = false;
      
      private var black:Sprite;
      
      private var timer:Timer;
      
      public function WorldBossFightRoomState()
      {
         super();
      }
      
      override public function getType() : String
      {
         return StateType.WORLDBOSS_FIGHT_ROOM;
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
         SocketManager.Instance.out.enterUserGuide(WorldBossManager.Instance.currentPVE_ID,14);
         if(!WorldBossManager.Instance.bossInfo.fightOver)
         {
            IsSuccessStartGame = true;
            GameInSocketOut.sendGameStart();
            SocketManager.Instance.out.sendWorldBossRoomStauts(2);
            this.waitForGameStart();
         }
         else
         {
            StateManager.setState(StateType.WORLDBOSS_ROOM);
         }
      }
      
      private function waitForGameStart() : void
      {
         this.timer = new Timer(10000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.__gotoBack);
         this.timer.start();
      }
      
      private function __gotoBack(evt:TimerEvent) : void
      {
         this.timer.reset();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__gotoBack);
         IsSuccessStartGame = false;
         StateManager.setState(StateType.WORLDBOSS_ROOM);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         if(Boolean(this.timer) && this.timer.running)
         {
            this.timer.reset();
            this.timer.removeEventListener(TimerEvent.TIMER,this.__gotoBack);
         }
         if(Boolean(this.black) && Boolean(this.black.parent))
         {
            this.black.parent.removeChild(this.black);
         }
         super.leaving(next);
      }
   }
}

