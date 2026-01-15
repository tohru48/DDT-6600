package game.view.smallMap
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.LivingEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import game.GameManager;
   import game.model.Living;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   
   public class SmallMapPlayer extends Sprite
   {
      
      private var _info:Living;
      
      private var _player:MovieClip;
      
      public function SmallMapPlayer(info:Living)
      {
         super();
         this._info = info;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         if(this._info is SimpleBoss || this._info is SmallEnemy)
         {
            if(this._info.team == 1)
            {
               this.createPlayer(ComponentFactory.Instance.creatCustomObject("asset.game.SmallMapPlayer1Asset"));
               return;
            }
         }
         if(this._info.team == 1)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer9Asset"));
         }
         else if(this._info.team == 2)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer10Asset"));
         }
         else if(this._info.team == 3)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer11Asset"));
         }
         else if(this._info.team == 4)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer12Asset"));
         }
         else if(this._info.team == 5)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer13Asset"));
         }
         else if(this._info.team == 6)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer14Asset"));
         }
         else if(this._info.team == 7)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer15Asset"));
         }
         else if(this._info.team == 8)
         {
            this.createPlayer(ClassUtils.CreatInstance("asset.game.SmallMapPlayer16Asset"));
         }
      }
      
      private function initEvent() : void
      {
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.addEventListener(LivingEvent.HIDDEN_CHANGED,this.__hide);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.removeEventListener(LivingEvent.HIDDEN_CHANGED,this.__hide);
         this._info.removeEventListener(LivingEvent.DIE,this.__die);
         this._info = null;
         this._player.stop();
         this._player = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function createPlayer(player:MovieClip) : void
      {
         this._player = player;
         this._player.scaleY = 1.2;
         this._player.scaleX = 1.2;
         player["attrack_mc"].visible = false;
         addChild(this._player);
         if(this._info.isSelf)
         {
            player["player_mc"].gotoAndPlay(1);
         }
         else
         {
            player["player_mc"].gotoAndStop(8);
         }
      }
      
      private function __change(event:LivingEvent) : void
      {
         if((this._info as TurnedLiving).isAttacking)
         {
            this._player["attrack_mc"].visible = true;
         }
         else
         {
            this._player["attrack_mc"].visible = false;
         }
      }
      
      private function __hide(event:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            if(this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               alpha = 0;
               visible = false;
            }
            else
            {
               alpha = 0.5;
            }
         }
         else
         {
            alpha = 1;
            visible = true;
         }
      }
      
      private function __die(evt:LivingEvent) : void
      {
         this._player["attrack_mc"].visible = false;
      }
   }
}

