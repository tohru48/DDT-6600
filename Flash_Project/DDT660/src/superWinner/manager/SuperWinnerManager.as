package superWinner.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import superWinner.analyze.SuperWinnerAnalyze;
   import superWinner.controller.SuperWinnerController;
   import superWinner.data.SuperWinnerPackageType;
   import superWinner.model.SuperWinnerModel;
   
   public class SuperWinnerManager extends EventDispatcher
   {
      
      private static var _instance:SuperWinnerManager;
      
      public static const ROOM_IS_OPEN:String = "roomIsOpen";
      
      private var _model:SuperWinnerModel;
      
      private var _isOpen:Boolean = false;
      
      private var isFirstOpen:Boolean;
      
      private var _awardsVector:Vector.<Object>;
      
      public function SuperWinnerManager(privateClass:PrivateClass)
      {
         super();
      }
      
      public static function get instance() : SuperWinnerManager
      {
         if(SuperWinnerManager._instance == null)
         {
            SuperWinnerManager._instance = new SuperWinnerManager(new PrivateClass());
         }
         return SuperWinnerManager._instance;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUPER_WINNER,this.pkgHandler);
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case SuperWinnerPackageType.SUPER_WINNER_OPEN:
               this._isOpen = pkg.readBoolean();
               if(this._isOpen)
               {
                  this.showSuperWinner();
                  if(!this.isFirstOpen)
                  {
                     dispatchEvent(new Event(ROOM_IS_OPEN));
                  }
               }
               else
               {
                  this.hideSuperWinnerIcon();
               }
               this.isFirstOpen = this._isOpen;
               break;
            case SuperWinnerPackageType.ENTER_ROOM:
               StateManager.setState(StateType.SUPER_WINNER);
               SuperWinnerController.instance.enterSuperWinnerRoom(pkg);
               break;
            case SuperWinnerPackageType.RETURN_DICES:
               SuperWinnerController.instance.returnDices(pkg);
               break;
            case SuperWinnerPackageType.START_ROLL_DICES:
               SuperWinnerController.instance.startRollDices();
               break;
            case SuperWinnerPackageType.TIMES_UP:
               SuperWinnerController.instance.timesUp(pkg);
               break;
            case SuperWinnerPackageType.JOIN_ROOM:
               SuperWinnerController.instance.joinRoom(pkg);
               break;
            case SuperWinnerPackageType.END_GAME:
               SuperWinnerController.instance.endGame();
         }
      }
      
      public function showSuperWinner() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SUPERWINNER,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.SUPERWINNER,true,20);
         }
      }
      
      public function openSuperWinner(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.enterSuperWinner();
      }
      
      public function hideSuperWinnerIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SUPERWINNER,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.SUPERWINNER,false);
      }
      
      public function awardsLoadCompleted(analyzer:SuperWinnerAnalyze) : void
      {
         this._awardsVector = analyzer.awards;
      }
      
      public function get awardsVector() : Vector.<Object>
      {
         return this._awardsVector;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
