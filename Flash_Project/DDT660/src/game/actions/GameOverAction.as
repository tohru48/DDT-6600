package game.actions
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SoundManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.MovieClip;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class GameOverAction extends BaseAction
   {
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _current:GameInfo;
      
      private var _func:Function;
      
      public function GameOverAction(map:MapView, event:CrazyTankSocketEvent, func:Function, waitTime:Number = 3000)
      {
         super();
         this._func = func;
         this._event = event;
         this._map = map;
         this._count = waitTime / 40;
         this._current = GameManager.Instance.Current;
         this.readInfo(event);
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
      }
      
      private function readInfo(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var tieStatus:int = 0;
         var num:int = 0;
         var i:int = 0;
         var redFinalScore:int = 0;
         var blueFinalScore:int = 0;
         var j:Living = null;
         var id:int = 0;
         var isWin:Boolean = false;
         var grade:int = 0;
         var gp:int = 0;
         var obj:Object = null;
         var info:Player = null;
         if(Boolean(this._current))
         {
            pkg = event.pkg;
            tieStatus = pkg.readInt();
            num = pkg.readInt();
            for(i = 0; i < num; i++)
            {
               id = pkg.readInt();
               isWin = pkg.readBoolean();
               grade = pkg.readInt();
               gp = pkg.readInt();
               obj = {};
               obj.killGP = pkg.readInt();
               obj.hertGP = pkg.readInt();
               obj.fightGP = pkg.readInt();
               obj.ghostGP = pkg.readInt();
               obj.gpForVIP = pkg.readInt();
               obj.gpForConsortia = pkg.readInt();
               obj.gpForSpouse = pkg.readInt();
               obj.gpForServer = pkg.readInt();
               obj.gpForApprenticeOnline = pkg.readInt();
               obj.gpForApprenticeTeam = pkg.readInt();
               obj.gpForDoubleCard = pkg.readInt();
               obj.gpForPower = pkg.readInt();
               obj.consortiaSkill = pkg.readInt();
               obj.luckyExp = pkg.readInt();
               obj.gainGP = pkg.readInt();
               obj.gpCSMUser = pkg.readInt();
               obj.offerFight = pkg.readInt();
               obj.offerDoubleCard = pkg.readInt();
               obj.offerVIP = pkg.readInt();
               obj.offerService = pkg.readInt();
               obj.offerBuff = pkg.readInt();
               obj.offerConsortia = pkg.readInt();
               obj.luckyOffer = pkg.readInt();
               obj.gainOffer = pkg.readInt();
               obj.offerCSMUser = pkg.readInt();
               obj.canTakeOut = pkg.readInt();
               if(GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
               {
                  if(isWin)
                  {
                     obj.canTakeOut = 3;
                  }
                  else
                  {
                     obj.canTakeOut = 1;
                  }
               }
               obj.gameOverType = ExpView.GAME_OVER_TYPE_1;
               info = this._current.findPlayer(id);
               if(Boolean(info))
               {
                  info.isWin = isWin;
                  info.CurrentGP = gp;
                  info.CurrentLevel = grade;
                  info.expObj = obj;
                  info.GainGP = obj.gainGP;
                  info.GainOffer = obj.gainOffer;
                  info.GetCardCount = obj.canTakeOut;
               }
               if(info is LocalPlayer)
               {
                  info.tieStatus = tieStatus;
               }
            }
            this._current.GainRiches = pkg.readInt();
            redFinalScore = pkg.readInt();
            blueFinalScore = pkg.readInt();
            for each(j in this._current.livings)
            {
               if(Boolean(j.character))
               {
                  j.character.resetShowBitmapBig();
               }
            }
         }
      }
      
      override public function cancel() : void
      {
         if(Boolean(this._event))
         {
            this._event.executed = true;
         }
         this._current = null;
         this._map = null;
         this._event = null;
         this._func = null;
      }
      
      override public function execute() : void
      {
         var movie:MovieClipWrapper = null;
         if(!this._executed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this._executed = true;
               this._event.executed = true;
               if(Boolean(this._map.currentPlayer) && this._map.currentPlayer.isExist)
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
               {
                  if(GameManager.Instance.Current.selfGamePlayer.tieStatus == -1)
                  {
                     movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.newTieAsset")),true,true);
                     movie.movie.x = 434;
                     movie.movie.y = 244;
                  }
                  else if(GameManager.Instance.Current.selfGamePlayer.isWin)
                  {
                     movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.newWinAsset")),true,true);
                     movie.movie.x = 500;
                     movie.movie.y = 217;
                  }
                  else
                  {
                     movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.newLostAsset")),true,true);
                     movie.movie.x = 438;
                     movie.movie.y = 244;
                  }
               }
               else
               {
                  if(GameManager.Instance.Current.selfGamePlayer.isWin)
                  {
                     movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.winAsset")),true,true);
                  }
                  else if(!GameManager.Instance.Current.selfGamePlayer.isWin)
                  {
                     if(GameManager.Instance.Current.redScore == GameManager.Instance.Current.blueScore && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
                     {
                        movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.pingAsset")),true,true);
                     }
                     else
                     {
                        movie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.lostAsset")),true,true);
                     }
                  }
                  movie.movie.x = 500;
                  movie.movie.y = 360;
               }
               SoundManager.instance.play("040");
               this._map.gameView.addChild(movie.movie);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
               this.cancel();
            }
         }
      }
   }
}

