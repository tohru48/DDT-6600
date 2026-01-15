package game.objects
{
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import game.actions.SkillActions.LaserAction;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   import phy.bombs.BaseBomb;
   import phy.maps.Map;
   
   public class SkillBomb extends BaseBomb
   {
      
      private var _info:Bomb;
      
      private var _owner:Living;
      
      private var _lifeTime:int = 0;
      
      private var _cunrrentAction:BombAction;
      
      private var _laserAction:LaserAction;
      
      private var _game:GameInfo;
      
      public function SkillBomb(info:Bomb, owner:Living)
      {
         this._info = info;
         this._owner = owner;
         super(this._info.Id);
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      override public function setMap(map:Map) : void
      {
         super.setMap(map);
         if(Boolean(map))
         {
            this._game = this.map.game;
         }
      }
      
      override public function update(dt:Number) : void
      {
         var living:Living = null;
         var player:Living = null;
         if(this._cunrrentAction == null)
         {
            this._cunrrentAction = this._info.Actions.shift();
         }
         if(this._cunrrentAction == null)
         {
            bomb();
         }
         else if(this._cunrrentAction.type == ActionType.Laser)
         {
            if(this._laserAction == null)
            {
               living = this._game.findLiving(this._cunrrentAction.param1);
               this._laserAction = new LaserAction(living,this.map,this._cunrrentAction.param2);
               this._laserAction.prepare();
            }
            else if(this._laserAction.isFinished)
            {
               this._cunrrentAction = this._info.Actions.shift();
            }
            else
            {
               this._laserAction.execute();
            }
         }
         else if(this._cunrrentAction.type == ActionType.KILL_PLAYER)
         {
            player = this._game.findLiving(this._cunrrentAction.param1);
            if(Boolean(player))
            {
               if(Math.abs(player.blood - this._cunrrentAction.param4) > 30000 && this._owner is Player)
               {
                  SocketManager.Instance.out.sendErrorMsg("客户端发现异常:" + this._owner.playerInfo.NickName + "打出单发炮弹" + Math.abs(player.blood - this._cunrrentAction.param4) + "的伤害");
               }
               player.updateBlood(this._cunrrentAction.param4,this._cunrrentAction.param3,0 - this._cunrrentAction.param2);
               player.isHidden = false;
               player.bomd();
            }
            this._cunrrentAction = this._info.Actions.shift();
         }
         else
         {
            this._cunrrentAction = this._info.Actions.shift();
         }
      }
      
      override protected function DigMap() : void
      {
      }
      
      override public function die() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         super.die();
         dispose();
      }
   }
}

