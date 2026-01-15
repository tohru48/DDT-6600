package superWinner.controller
{
   import christmas.view.playingSnowman.RoomMenuView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import road7th.comm.PackageIn;
   import superWinner.event.SuperWinnerEvent;
   import superWinner.model.SuperWinnerModel;
   import superWinner.view.SuperWinnerView;
   
   public class SuperWinnerController extends BaseStateView
   {
      
      private static var _instance:SuperWinnerController;
      
      private var _view:SuperWinnerView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _model:SuperWinnerModel;
      
      private var _pkg:PackageIn;
      
      public function SuperWinnerController()
      {
         super();
         this._model = new SuperWinnerModel();
      }
      
      public static function get instance() : SuperWinnerController
      {
         if(!_instance)
         {
            _instance = new SuperWinnerController();
         }
         return _instance;
      }
      
      public function get model() : SuperWinnerModel
      {
         return this._model;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.init();
         this.initSocket();
      }
      
      private function initSocket() : void
      {
         this._model.setRoomInfo(this._pkg);
      }
      
      public function enterSuperWinnerRoom(pkg:PackageIn) : void
      {
         this._pkg = pkg;
      }
      
      public function timesUp(pkg:PackageIn) : void
      {
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case 0:
               this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.PROGRESS_TIMES_UP));
               break;
            case 1:
               this._model.formatMyAwards(pkg);
               break;
            case 2:
               this._model.sendGetAwardsMsg(pkg);
               this._model.formatAwards(pkg);
               break;
            case 3:
               this._model.flushChampion(pkg,true);
         }
      }
      
      public function returnDices(pkg:PackageIn) : void
      {
         this._model.isCurrentDiceGetAward = pkg.readBoolean();
         this._model.currentAwardLevel = pkg.readByte();
         var vt:Vector.<int> = new Vector.<int>(6,true);
         for(var i:int = 0; i < 6; i++)
         {
            vt[i] = pkg.readByte();
         }
         this._model.currentDicePoints = vt;
         this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.RETURN_DICES));
      }
      
      public function startRollDices() : void
      {
         this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.START_ROLL_DICES));
      }
      
      public function joinRoom(pkg:PackageIn) : void
      {
         this._model.joinRoom(pkg);
      }
      
      public function endGame() : void
      {
         if(Boolean(this._view))
         {
            this._view.endGame();
         }
      }
      
      private function init() : void
      {
         this._model = new SuperWinnerModel();
         this._view = new SuperWinnerView(this);
         addChild(this._view);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.SUPER_WINNER;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         super.leaving(next);
      }
   }
}

