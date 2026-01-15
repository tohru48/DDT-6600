package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import game.GameManager;
   import game.model.GameInfo;
   
   public class SingleBattleMatchingView extends RoomLoadingView
   {
      
      private var _matchTxt:Bitmap;
      
      private var _playerArr:Array;
      
      public function SingleBattleMatchingView($info:GameInfo)
      {
         var player:Bitmap = null;
         super($info);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
         this._matchTxt = ComponentFactory.Instance.creatBitmap("asset.room.view.roomView.SingleBattleMatch.matchTxt");
         this._matchTxt.x = 407;
         this._matchTxt.y = 387;
         addChild(this._matchTxt);
         this._playerArr = new Array();
         var len:int = int(_gameInfo.roomPlayers.length);
         for(var i:int = 0; i < len; i++)
         {
            player = ComponentFactory.Instance.creatBitmap("game.player.defaultPlayerCharacter");
            PositionUtils.setPos(player,"asset.roomLoading.CharacterItemRedPos_1");
            addChild(player);
            player.x += 90 * i;
            player.y += 62;
            this._playerArr.push(player);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         StateManager.currentStateType = StateType.SINGLEBATTLE_MATCHING;
      }
      
      override protected function __countDownTick(evt:TimerEvent) : void
      {
         _countDownTxt.updateNum();
      }
      
      override protected function initRoomItem(item:RoomLoadingCharacterItem) : void
      {
         super.initRoomItem(item);
         item.removePerecentageTxt();
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
         if(Boolean(this._matchTxt))
         {
            ObjectUtils.disposeObject(this._matchTxt);
         }
         this._matchTxt = null;
         for(var i:int = 0; i < this._playerArr.length; i++)
         {
            ObjectUtils.disposeObject(this._playerArr[i]);
            this._playerArr[i] = null;
         }
         this._playerArr = null;
      }
   }
}

