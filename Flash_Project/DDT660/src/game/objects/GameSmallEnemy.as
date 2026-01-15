package game.objects
{
   import ddt.events.LivingEvent;
   import game.actions.MonsterShootBombAction;
   import game.model.Living;
   import game.model.Player;
   import game.model.SmallEnemy;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   import road7th.data.StringObject;
   
   public class GameSmallEnemy extends GameLiving
   {
      
      private var _bombEvent:LivingEvent;
      
      private var _noDispose:Boolean = false;
      
      private var _disposedOverTurns:Boolean = true;
      
      public function GameSmallEnemy(info:SmallEnemy)
      {
         super(info);
         info.defaultAction = "stand";
      }
      
      override protected function initView() : void
      {
         super.initView();
         initMovie();
      }
      
      override public function setMap(map:Map) : void
      {
         super.setMap(map);
         if(Boolean(map))
         {
            __posChanged(null);
         }
      }
      
      public function get smallEnemy() : SmallEnemy
      {
         return info as SmallEnemy;
      }
      
      override protected function __bloodChanged(event:LivingEvent) : void
      {
         super.__bloodChanged(event);
         if(event.value - event.old < 0)
         {
            doAction(Living.CRY_ACTION);
         }
      }
      
      override protected function __die(event:LivingEvent) : void
      {
         if(isMoving())
         {
            stopMoving();
         }
         super.__die(event);
         if(Boolean(event.paras[0]))
         {
            if(_info.typeLiving == 2)
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.clearEnemy);
            }
            else if(this._noDispose)
            {
               _actionMovie.doAction(Living.DIE_ACTION);
            }
            else
            {
               _actionMovie.doAction(Living.DIE_ACTION,this.dispose);
            }
         }
         else if(_info.typeLiving == 2)
         {
            this.clearEnemy();
         }
         else
         {
            this.dispose();
         }
         _chatballview.dispose();
         _isDie = true;
      }
      
      override public function collidedByObject(obj:PhysicalObj) : void
      {
         if(obj is SimpleBomb)
         {
            info.isHidden = false;
         }
      }
      
      override protected function fitChatBallPos() : void
      {
         _chatballview.x = 20;
         _chatballview.y = -50;
         if(this.name == "Người máy A")
         {
            _chatballview.y = -100;
         }
         if(!actionMovie["popupPos"])
         {
            return;
         }
         super.fitChatBallPos();
      }
      
      private function clearEnemy() : void
      {
         this.removeEvents(true);
         deleteSmallView();
      }
      
      private function removeEvents(flag:Boolean = false) : void
      {
         super.removeListener();
         if(flag)
         {
            _info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         }
      }
      
      override protected function __shoot(event:LivingEvent) : void
      {
         map.act(new MonsterShootBombAction(this,event.paras[0],event.paras[1],Player.SHOOT_INTERVAL));
      }
      
      override protected function __beginNewTurn(event:LivingEvent) : void
      {
         if(!this._disposedOverTurns)
         {
            return;
         }
         if(_isDie)
         {
            ++_turns;
         }
         if(_turns >= 5)
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(_info))
         {
            _info.dispose();
         }
         super.dispose();
      }
      
      override public function setProperty(property:String, value:String) : void
      {
         var vo:StringObject = new StringObject(value);
         super.setProperty(property,value);
         switch(property)
         {
            case "disposedOverTurns":
               this._disposedOverTurns = vo.getBoolean();
               break;
            case "noDispose":
               this._noDispose = vo.getBoolean();
         }
      }
   }
}

