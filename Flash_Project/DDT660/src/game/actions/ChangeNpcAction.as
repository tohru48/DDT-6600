package game.actions
{
   import ddt.data.PathInfo;
   import ddt.events.CrazyTankSocketEvent;
   import game.GameManager;
   import game.model.Living;
   import game.model.SmallEnemy;
   import game.objects.GameSmallEnemy;
   import game.objects.SimpleBox;
   import game.view.Bomb;
   import game.view.GameView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ChangeNpcAction extends BaseAction
   {
      
      private var _gameView:GameView;
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _ignoreSmallEnemy:Boolean;
      
      public function ChangeNpcAction(game:GameView, map:MapView, info:Living, event:CrazyTankSocketEvent, sysMap:PackageIn, ignoreSmallEnemy:Boolean)
      {
         super();
         this._gameView = game;
         this._event = event;
         this._event.executed = false;
         this._pkg = sysMap;
         this._map = map;
         this._info = info;
         this._ignoreSmallEnemy = ignoreSmallEnemy;
      }
      
      private function syncMap() : void
      {
         var windDic:Boolean = false;
         var windPowerNum0:int = 0;
         var windPowerNum1:int = 0;
         var windPowerNum2:int = 0;
         var windNumArr:Array = null;
         var count:int = 0;
         var i:uint = 0;
         var isOutCrater:Boolean = false;
         var bid:int = 0;
         var bx:int = 0;
         var by:int = 0;
         var subType:uint = 0;
         var box:SimpleBox = null;
         var outBombsLength:int = 0;
         var outBombs:DictionaryData = null;
         var k:int = 0;
         var bomb:Bomb = null;
         if(Boolean(this._pkg))
         {
            windDic = this._pkg.readBoolean();
            windPowerNum0 = this._pkg.readByte();
            windPowerNum1 = this._pkg.readByte();
            windPowerNum2 = this._pkg.readByte();
            windNumArr = new Array();
            windNumArr = [windDic,windPowerNum0,windPowerNum1,windPowerNum2];
            GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,false,windNumArr);
            this._pkg.readBoolean();
            this._pkg.readInt();
            count = this._pkg.readInt();
            for(i = 0; i < count; i++)
            {
               bid = this._pkg.readInt();
               bx = this._pkg.readInt();
               by = this._pkg.readInt();
               subType = uint(this._pkg.readInt());
               box = new SimpleBox(bid,String(PathInfo.GAME_BOXPIC),subType);
               box.x = bx;
               box.y = by;
               this._map.addPhysical(box);
            }
            isOutCrater = this._pkg.readBoolean();
            if(isOutCrater)
            {
               outBombsLength = this._pkg.readInt();
               outBombs = new DictionaryData();
               for(k = 0; k < outBombsLength; k++)
               {
                  bomb = new Bomb();
                  bomb.Id = this._pkg.readInt();
                  bomb.X = this._pkg.readInt();
                  bomb.Y = this._pkg.readInt();
                  outBombs.add(k,bomb);
               }
               this._map.DigOutCrater(outBombs);
            }
         }
      }
      
      private function updateNpc() : void
      {
         var p:Living = null;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         for each(p in GameManager.Instance.Current.livings)
         {
            p.beginNewTurn();
         }
         this._map.cancelFocus();
         this._gameView.setCurrentPlayer(this._info);
         if(!this._map.smallMap.locked)
         {
            this.focusOnSmallEnemy();
         }
         if(!this._ignoreSmallEnemy)
         {
            this._ignoreSmallEnemy = true;
            this._gameView.updateControlBarState(GameManager.Instance.Current.selfGamePlayer);
            return;
         }
      }
      
      private function getClosestEnemy() : SmallEnemy
      {
         var result:SmallEnemy = null;
         var p:Living = null;
         var instance:int = -1;
         var x:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
         for each(p in GameManager.Instance.Current.livings)
         {
            if(p is SmallEnemy && p.isLiving && p.typeLiving != 3)
            {
               if(instance == -1 || Math.abs(p.pos.x - x) < instance)
               {
                  instance = Math.abs(p.pos.x - x);
                  result = p as SmallEnemy;
               }
            }
         }
         return result;
      }
      
      private function focusOnSmallEnemy() : void
      {
         var closestEnemy:SmallEnemy = this.getClosestEnemy();
         if(Boolean(closestEnemy))
         {
            if(Boolean(closestEnemy.LivingID) && Boolean(this._map.getPhysical(closestEnemy.LivingID)))
            {
               (this._map.getPhysical(closestEnemy.LivingID) as GameSmallEnemy).needFocus();
               this._map.currentFocusedLiving = this._map.getPhysical(closestEnemy.LivingID) as GameSmallEnemy;
            }
         }
      }
      
      override public function execute() : void
      {
         this._event.executed = true;
         this.syncMap();
         this.updateNpc();
         _isFinished = true;
      }
   }
}

