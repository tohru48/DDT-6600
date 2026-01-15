package game.objects
{
   import ddt.manager.SocketManager;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import phy.object.PhysicalObj;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class BombAction
   {
      
      private var _time:int;
      
      private var _type:int;
      
      private var _param1:int;
      
      public var _param2:int;
      
      public var _param3:int;
      
      public var _param4:int;
      
      public function BombAction(time:int, type:int, param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this._time = time;
         this._type = type;
         this._param1 = param1;
         this._param2 = param2;
         this._param3 = param3;
         this._param4 = param4;
      }
      
      public function get param1() : int
      {
         return this._param1;
      }
      
      public function get param2() : int
      {
         return this._param2;
      }
      
      public function get param3() : int
      {
         return this._param3;
      }
      
      public function get param4() : int
      {
         return this._param4;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function execute(ball:SimpleBomb, _game:GameInfo) : void
      {
         var obj:PhysicalObj = null;
         var info:Living = null;
         var player:Living = null;
         var player1:Living = null;
         var player3:Living = null;
         var player2:Player = null;
         var player4:Living = null;
         var player5:Player = null;
         var living:Living = null;
         var living1:Living = null;
         var skill:int = 0;
         var livingId:int = 0;
         var player7:Living = null;
         var player8:Living = null;
         var player9:Living = null;
         var player10:Player = null;
         var player6:Living = null;
         var beatInfo:Dictionary = null;
         switch(this._type)
         {
            case ActionType.PICK:
               obj = ball.map.getPhysical(this._param1);
               if(Boolean(obj))
               {
                  obj.collidedByObject(ball);
               }
               break;
            case ActionType.BOMB:
               ball.x = this._param1;
               ball.y = this._param2;
               ball.bomb();
               break;
            case ActionType.START_MOVE:
               info = _game.findLiving(this._param1);
               if(info is Player)
               {
                  (info as Player).playerMoveTo(1,new Point(this._param2,this._param3),info.direction,this._param4 != 0);
               }
               else if(info != null)
               {
                  info.fallTo(new Point(this._param2,this._param3),Player.FALL_SPEED);
               }
               break;
            case ActionType.FLY_OUT:
               ball.die();
               break;
            case ActionType.KILL_PLAYER:
               player = _game.findLiving(this._param1);
               if(Boolean(player))
               {
                  if(Math.abs(player.blood - this._param4) > 30000 && ball && ball.owner && ball.owner is Player && Boolean(ball.owner.playerInfo))
                  {
                     SocketManager.Instance.out.sendErrorMsg("客户端发现异常:" + ball.owner.playerInfo.NickName + "打出单发炮弹" + Math.abs(player.blood - this._param4) + "的伤害");
                  }
                  player.updateBlood(this._param4,this._param3,0 - this._param2);
                  player.isHidden = false;
               }
               break;
            case ActionType.TRANSLATE:
               ball.owner.transmit(new Point(this._param1,this._param2));
               break;
            case ActionType.FORZEN:
               player1 = _game.findLiving(this._param1);
               if(Boolean(player1))
               {
                  player1.isFrozen = true;
                  player1.isHidden = false;
               }
               break;
            case ActionType.CHANGE_SPEED:
               ball.setSpeedXY(new Point(this._param1,this._param2));
               ball.clearWG();
               if(this._param3 >= 0)
               {
                  player6 = _game.findLiving(this._param3);
                  if(Boolean(player6))
                  {
                     player6.showEffect("asset.game.propanimation.guild");
                  }
               }
               break;
            case ActionType.UNFORZEN:
               player3 = _game.findLiving(this._param1);
               if(Boolean(player3))
               {
                  player3.isFrozen = false;
               }
               break;
            case ActionType.DANER:
               player2 = _game.findPlayer(this._param1);
               if(Boolean(player2) && player2.isLiving)
               {
                  player2.dander = this._param2;
               }
               break;
            case ActionType.CURE:
               player4 = _game.findLiving(this._param1);
               if(Boolean(player4))
               {
                  player4.showAttackEffect(2);
                  player4.updateBlood(this._param2,0,this._param3);
               }
               break;
            case ActionType.GEM_DEFENSE_CHANGED:
               player5 = _game.findPlayer(this._param1);
               if(Boolean(player5))
               {
                  player5.gemDefense = true;
               }
               break;
            case ActionType.CHANGE_STATE:
               living = _game.findLiving(this._param1);
               if(Boolean(living))
               {
                  living.State = this._param2;
               }
               break;
            case ActionType.DO_ACTION:
               living1 = _game.findLiving(this._param1);
               if(Boolean(living1))
               {
                  living1.playMovie(ActionType.ACTION_TYPES[this._param4]);
               }
               break;
            case ActionType.PLAYBUFFER:
               skill = this._param2;
               livingId = this._param1;
               break;
            case ActionType.BOMBED:
               player7 = _game.findLiving(this._param1);
               if(Boolean(player7))
               {
                  player7.bomd();
               }
               break;
            case ActionType.PUP:
               player8 = _game.findLiving(this._param1);
               if(Boolean(player8))
               {
                  player8.showAttackEffect(ActionType.PUP);
               }
               break;
            case ActionType.AUP:
               player9 = _game.findLiving(this._param1);
               if(Boolean(player9))
               {
                  player9.showAttackEffect(ActionType.AUP);
               }
               break;
            case ActionType.PET:
               player10 = Player(_game.findLiving(this._param1));
               if(Boolean(player10) && (RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM))
               {
                  beatInfo = player10.currentPet.petBeatInfo;
                  player10.petBeat(String(beatInfo["actionName"]),Point(beatInfo["targetPoint"]),beatInfo["targets"]);
               }
         }
      }
   }
}

