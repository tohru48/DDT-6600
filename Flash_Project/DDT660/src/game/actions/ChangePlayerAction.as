package game.actions
{
   import bombKing.BombKingManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.PathInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SoundManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.SimpleBox;
   import game.view.Bomb;
   import game.view.GameView;
   import game.view.map.MapView;
   import org.aswing.KeyboardManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class ChangePlayerAction extends BaseAction
   {
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _count:int;
      
      private var _changed:Boolean;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _turnTime:int;
      
      public function ChangePlayerAction(map:MapView, info:Living, event:CrazyTankSocketEvent, sysMap:PackageIn, waitTime:Number = 200, turnTime:int = -1)
      {
         super();
         this._event = event;
         this._event.executed = false;
         this._pkg = sysMap;
         this._map = map;
         this._info = info;
         this._count = waitTime / 40;
         this._turnTime = turnTime;
      }
      
      private function syncMap() : void
      {
         var localPlayer:LocalPlayer = null;
         var bid:int = 0;
         var bx:int = 0;
         var by:int = 0;
         var subType:int = 0;
         var box:SimpleBox = null;
         var livingID:int = 0;
         var isLiving:Boolean = false;
         var tx:int = 0;
         var ty:int = 0;
         var blood:int = 0;
         var nonole:Boolean = false;
         var maxEnergy:int = 0;
         var psychic:int = 0;
         var dander:int = 0;
         var petMaxMP:int = 0;
         var petMP:int = 0;
         var shootCount:int = 0;
         var flyCount:int = 0;
         var player:Living = null;
         var outBombsLength:int = 0;
         var outBombs:DictionaryData = null;
         var k:int = 0;
         var bomb:Bomb = null;
         var windDic:Boolean = this._pkg.readBoolean();
         var windPowerNum0:int = this._pkg.readByte();
         var windPowerNum1:int = this._pkg.readByte();
         var windPowerNum2:int = this._pkg.readByte();
         var windNumArr:Array = new Array();
         windNumArr = [windDic,windPowerNum0,windPowerNum1,windPowerNum2];
         GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID,windNumArr);
         this._info.isHidden = this._pkg.readBoolean();
         var turnTime:int = this._pkg.readInt();
         if(this._info is LocalPlayer)
         {
            localPlayer = LocalPlayer(this._info);
            if(this._turnTime == -1)
            {
               if(turnTime > 0)
               {
                  localPlayer.turnTime = turnTime;
               }
               else
               {
                  localPlayer.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
               }
            }
            else
            {
               localPlayer.turnTime = this._turnTime;
               GameInSocketOut.sendGameSkipNext(0);
            }
            if(turnTime != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
            {
            }
         }
         var boxCount:int = this._pkg.readInt();
         for(var i:uint = 0; i < boxCount; i++)
         {
            bid = this._pkg.readInt();
            bx = this._pkg.readInt();
            by = this._pkg.readInt();
            subType = this._pkg.readInt();
            box = new SimpleBox(bid,String(PathInfo.GAME_BOXPIC),subType);
            box.x = bx;
            box.y = by;
            this._map.addPhysical(box);
         }
         var playerCount:int = this._pkg.readInt();
         for(var j:int = 0; j < playerCount; j++)
         {
            livingID = this._pkg.readInt();
            isLiving = this._pkg.readBoolean();
            tx = this._pkg.readInt();
            ty = this._pkg.readInt();
            blood = this._pkg.readInt();
            nonole = this._pkg.readBoolean();
            maxEnergy = this._pkg.readInt();
            psychic = this._pkg.readInt();
            dander = this._pkg.readInt();
            petMaxMP = this._pkg.readInt();
            petMP = this._pkg.readInt();
            shootCount = this._pkg.readInt();
            flyCount = this._pkg.readInt();
            player = GameManager.Instance.Current.livings[livingID];
            if(Boolean(player))
            {
               if(!player.isLiving && isLiving)
               {
                  (this._map.gameView as GameView).revivePlayerChangePlayer(player.LivingID);
               }
               player.updateBlood(blood,5);
               player.isNoNole = nonole;
               player.maxEnergy = maxEnergy;
               player.psychic = psychic;
               if(player.isSelf)
               {
                  localPlayer = LocalPlayer(player);
                  localPlayer.energy = player.maxEnergy;
                  localPlayer.shootCount = shootCount;
                  localPlayer.dander = dander;
                  if(Boolean(localPlayer.currentPet))
                  {
                     localPlayer.currentPet.MaxMP = petMaxMP;
                     localPlayer.currentPet.MP = petMP;
                  }
                  localPlayer.soulPropCount = 0;
                  localPlayer.flyCount = flyCount;
               }
               if(!isLiving)
               {
                  player.die();
               }
               else
               {
                  player.onChange = false;
                  player.pos = new Point(tx,ty);
                  player.onChange = true;
               }
            }
         }
         this._map.currentTurn = this._pkg.readInt();
         var isOutCrater:Boolean = this._pkg.readBoolean();
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
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            GameManager.Instance.Current.nextPlayerId = this._pkg.readInt();
         }
      }
      
      override public function execute() : void
      {
         if(!this._changed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this.executeImp(false);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this.changePlayer();
            }
         }
      }
      
      private function changePlayer() : void
      {
         if(this._info is TurnedLiving && !BombKingManager.instance.Recording)
         {
            TurnedLiving(this._info).isAttacking = true;
         }
         this._map.gameView.updateControlBarState(this._info);
         _isFinished = true;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      private function executeImp(fastModel:Boolean) : void
      {
         var p:Living = null;
         var _turnMovie:MovieClipWrapper = null;
         if(this._info == null)
         {
            return;
         }
         if(!this._info.isExist)
         {
            _isFinished = true;
            this._map.gameView.updateControlBarState(null);
            return;
         }
         if(!this._changed)
         {
            this._event.executed = true;
            this._changed = true;
            if(Boolean(this._pkg))
            {
               this.syncMap();
            }
            for each(p in GameManager.Instance.Current.livings)
            {
               p.beginNewTurn();
            }
            this._map.gameView.setCurrentPlayer(this._info);
            if(Boolean(this._map.getPhysical(this._info.LivingID)))
            {
               (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0,0,{"priority":3});
            }
            this._info.gemDefense = false;
            if(this._info is LocalPlayer && !fastModel && !BombKingManager.instance.Recording)
            {
               KeyboardManager.getInstance().reset();
               SoundManager.instance.play("016");
               _turnMovie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")),true,true);
               _turnMovie.repeat = false;
               _turnMovie.movie.mouseChildren = _turnMovie.movie.mouseEnabled = false;
               _turnMovie.movie.x = 410;
               _turnMovie.movie.y = 200;
               this._map.gameView.addChild(_turnMovie.movie);
            }
            else
            {
               SoundManager.instance.play("038");
               this.changePlayer();
            }
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(false);
         this.changePlayer();
      }
   }
}

