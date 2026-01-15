package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.actions.FocusInLivingAction;
   import game.actions.PlayerBeatAction;
   import game.actions.SelfPlayerWalkAction;
   import game.actions.SelfSkipAction;
   import game.actions.newHand.NewHandFightHelpAction;
   import game.actions.newHand.NewHandFightHelpIIAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.DragMapAnimation;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.map.MapView;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillTemplateInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class GameLocalPlayer extends GamePlayer
   {
      
      private static const MAX_MOVE_TIME:int = 10;
      
      private var _takeAim:MovieClip;
      
      private var _moveStripContainer:Sprite;
      
      private var _moveStrip:Bitmap;
      
      private var _ballpos:Point;
      
      protected var _shootTimer:Timer;
      
      private var mouseAsset:MovieClip;
      
      private var monkeyEnergy:Number;
      
      private var _turned:Boolean;
      
      private var _transmissionEffoct:MovieClip;
      
      private var _keyDownTime:int;
      
      protected var _isShooting:Boolean = false;
      
      protected var _shootCount:int = 0;
      
      protected var _shootPoint:Point;
      
      private var _shootOverCount:int = 0;
      
      public function GameLocalPlayer(player:LocalPlayer, character:ShowCharacter, movie:GameCharacter = null)
      {
         super(player,character,movie);
      }
      
      public function get localPlayer() : LocalPlayer
      {
         return info as LocalPlayer;
      }
      
      public function get aim() : MovieClip
      {
         return this._takeAim;
      }
      
      override public function set pos(value:Point) : void
      {
         if(value.x < 1000)
         {
         }
         x = value.x;
         y = value.y;
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._ballpos = new Point(30,-20);
         this._takeAim = ClassUtils.CreatInstance("asset.game.TakeAimAsset");
         this._takeAim.x = this._ballpos.x * -1;
         this._takeAim.y = this._ballpos.y;
         this._takeAim["hand"].rotation = this.localPlayer.currentWeapInfo.armMinAngle;
         this._takeAim.mouseChildren = this._takeAim.mouseEnabled = false;
         this._moveStripContainer = new Sprite();
         this._moveStripContainer.addChild(ComponentFactory.Instance.creatBitmap("asset.game.moveStripBgAsset"));
         this._moveStrip = ComponentFactory.Instance.creatBitmap("asset.game.moveStripAsset");
         this._moveStripContainer.addChild(this._moveStrip);
         this._moveStripContainer.mouseChildren = this._moveStripContainer.mouseEnabled = false;
         if(Boolean(_consortiaName))
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _consortiaName.y + 22;
         }
         else
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _nickName.y + 22;
         }
         this.localPlayer.energy = this.localPlayer.maxEnergy;
         this.mouseAsset = ClassUtils.CreatInstance("asset.game.MouseShape") as MovieClip;
         this.mouseAsset.visible = false;
         this._shootTimer = new Timer(Player.SHOOT_TIMER);
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.localPlayer.addEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.addEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this.localPlayer.addEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.addEventListener(LivingEvent.SETCENTER,this.__setCenter);
         this.localPlayer.addEventListener(LivingEvent.MONKEY_CHANGED,this.__monkeyEnergy);
         this._shootTimer.addEventListener(TimerEvent.TIMER,this.__shootTimer);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
      }
      
      private function __monkeyEnergy(e:LivingEvent) : void
      {
         this.monkeyEnergy = e.value;
         this.drawdraw();
      }
      
      private function __setCenter(event:LivingEvent) : void
      {
         var paras:Array = event.paras;
         map.animateSet.addAnimation(new DragMapAnimation(paras[0],paras[1],true));
      }
      
      override public function dispose() : void
      {
         this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         this.localPlayer.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this.localPlayer.removeEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.removeEventListener(LivingEvent.SETCENTER,this.__setCenter);
         this.localPlayer.removeEventListener(LivingEvent.MONKEY_CHANGED,this.__monkeyEnergy);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
         _map.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         if(Boolean(this._takeAim) && Boolean(this._takeAim.parent))
         {
            this._takeAim.parent.removeChild(this._takeAim);
         }
         this._takeAim.stop();
         this._takeAim = null;
         this._moveStripContainer.removeChild(this._moveStrip);
         this._moveStrip.bitmapData.dispose();
         this._moveStrip = null;
         if(Boolean(this._moveStripContainer) && Boolean(this._moveStripContainer.parent))
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         this._moveStripContainer = null;
         this._shootTimer.stop();
         this._shootTimer = null;
         this.mouseAsset.stop();
         if(Boolean(this.mouseAsset.parent))
         {
            this.mouseAsset.parent.removeChild(this.mouseAsset);
         }
         this.mouseAsset = null;
         ObjectUtils.disposeObject(this._transmissionEffoct);
         this._transmissionEffoct;
         super.dispose();
      }
      
      protected function __skip(event:LivingEvent) : void
      {
         act(new SelfSkipAction(this.localPlayer));
      }
      
      public function showTransmissionEffoct() : void
      {
         if(Boolean(this._transmissionEffoct))
         {
            ObjectUtils.disposeObject(this._transmissionEffoct);
            this._transmissionEffoct = null;
         }
         if(Boolean(_player))
         {
            _player.visible = false;
         }
         if(Boolean(_nickName))
         {
            _nickName.visible = false;
         }
         if(Boolean(_bloodStripBg))
         {
            _bloodStripBg.visible = false;
         }
         if(Boolean(_HPStrip))
         {
            _HPStrip.visible = false;
         }
         if(Boolean(_consortiaName))
         {
            _consortiaName.visible = false;
         }
         if(Boolean(_buffBar))
         {
            _buffBar.visible = false;
         }
         this._transmissionEffoct = ClassUtils.CreatInstance("asset.game.transmittedEffoct");
         this._transmissionEffoct.x = _player.x;
         this._transmissionEffoct.y = _player.y;
         this._transmissionEffoct.play();
         addChild(this._transmissionEffoct);
      }
      
      private function __keyUp(event:KeyboardEvent) : void
      {
         this._keyDownTime = 0;
      }
      
      private function __turnLeft() : void
      {
         if(!this._isShooting)
         {
            if(info.direction == 1)
            {
               info.direction = -1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            this.walk();
         }
      }
      
      private function __turnRight() : void
      {
         if(!this._isShooting)
         {
            if(info.direction == -1)
            {
               info.direction = 1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            this.walk();
         }
      }
      
      protected function walk() : void
      {
         if(info.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         if(!_isMoving && this.localPlayer.isAttacking && (this._keyDownTime == 0 || getTimer() - this._keyDownTime > MAX_MOVE_TIME) && !this.localPlayer.forbidMoving)
         {
            act(new SelfPlayerWalkAction(this));
         }
      }
      
      override public function startMoving() : void
      {
         _isMoving = true;
      }
      
      override public function stopMoving() : void
      {
         _vx.clearMotion();
         _vy.clearMotion();
         _isMoving = false;
      }
      
      override protected function __attackingChanged(event:LivingEvent) : void
      {
         super.__attackingChanged(event);
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            act(new SelfPlayerWalkAction(this));
         }
         this.localPlayer.clearPropArr();
      }
      
      override protected function attackingViewChanged() : void
      {
         super.attackingViewChanged();
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            _player.addChild(this._takeAim);
            addChild(this._moveStripContainer);
         }
         else
         {
            if(_player.contains(this._takeAim))
            {
               _player.removeChild(this._takeAim);
            }
            if(Boolean(this._moveStripContainer.parent))
            {
               removeChild(this._moveStripContainer);
            }
         }
      }
      
      override public function die() : void
      {
         this.localPlayer.dander = 0;
         if(Boolean(this._takeAim) && _player.contains(this._takeAim))
         {
            _player.removeChild(this._takeAim);
         }
         if(Boolean(this._moveStripContainer) && Boolean(this._moveStripContainer.parent))
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         if(Boolean(map))
         {
            map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,50,false,AnimationLevel.MIDDLE));
            if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM && RoomManager.Instance.current.type != RoomInfo.ENTERTAINMENT_ROOM && RoomManager.Instance.current.type != RoomInfo.STONEEXPLORE_ROOM)
            {
               map.addEventListener(MouseEvent.CLICK,this.__mouseClick);
            }
         }
         if(Boolean(this._shootTimer))
         {
            this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         }
         setCollideRect(-8,-8,16,16);
         super.die();
      }
      
      override public function revive() : void
      {
         super.revive();
         if(Boolean(map))
         {
            map.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
         if(Boolean(this._shootTimer))
         {
            this._shootTimer.addEventListener(TimerEvent.TIMER,this.__shootTimer);
         }
         setCollideRect(-5,-5,5,5);
      }
      
      private function __mouseClick(event:MouseEvent) : void
      {
         var p:Point = _map.globalToLocal(new Point(event.stageX,event.stageY));
         _map.addChild(this.mouseAsset);
         SoundManager.instance.play("041");
         this.mouseAsset.x = p.x;
         this.mouseAsset.y = p.y;
         this.mouseAsset.visible = true;
         GameInSocketOut.sendGhostTarget(p);
      }
      
      public function hideTargetMouseTip() : void
      {
         this.mouseAsset.visible = false;
      }
      
      override protected function __usingItem(event:LivingEvent) : void
      {
         super.__usingItem(event);
         if(event.paras[0] is ItemTemplateInfo)
         {
            this.localPlayer.energy -= int(event.paras[0].Property4);
         }
      }
      
      protected function __sendShoot(event:LivingEvent) : void
      {
         this._shootPoint = shootPoint();
         this._shootCount = 0;
         this.shootOverCount = 0;
         this.localPlayer.isAttacking = false;
         this._isShooting = true;
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         GameInSocketOut.sendGameCMDDirection(info.direction);
         GameInSocketOut.sendShootTag(true,this.localPlayer.shootTime);
         if(this.localPlayer.shootType == 0)
         {
            this.localPlayer.force = event.paras[0];
            this._shootTimer.start();
            this.__shootTimer(null);
         }
         else
         {
            act(new PlayerBeatAction(this));
         }
      }
      
      private function __shootTimer(event:Event) : void
      {
         var angle:Number = NaN;
         var force:int = 0;
         if(this.localPlayer && this.localPlayer.isLiving && this._shootCount < this.localPlayer.shootCount)
         {
            angle = this.localPlayer.calcBombAngle();
            force = this.localPlayer.force;
            GameInSocketOut.sendGameCMDShoot(this._shootPoint.x,this._shootPoint.y,force,angle);
            MapView(_map).gameView.setRecordRotation();
            ++this._shootCount;
         }
      }
      
      override protected function __shoot(event:LivingEvent) : void
      {
         super.__shoot(event);
         this.localPlayer.lastFireBombs = event.paras[0];
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM)
         {
            if(this._shootCount >= this.localPlayer.shootCount && Boolean(map))
            {
               map.act(new FocusInLivingAction(map.getOneSimpleBoss));
            }
         }
      }
      
      override protected function __beginNewTurn(event:LivingEvent) : void
      {
         super.__beginNewTurn(event);
         map.act(new NewHandFightHelpIIAction(this.localPlayer,event.value - event.old));
         map.act(new NewHandFightHelpAction(this.localPlayer,this._shootOverCount,map));
         this._shootCount = 0;
         this.shootOverCount = 0;
         this._shootTimer.reset();
         if(_player.contains(this._takeAim))
         {
            _player.removeChild(this._takeAim);
         }
         this._isShooting = false;
      }
      
      public function get shootOverCount() : int
      {
         return this._shootOverCount;
      }
      
      public function set shootOverCount(count:int) : void
      {
         this._shootOverCount = count;
         if(this._shootOverCount == this._shootCount)
         {
            this._isShooting = false;
         }
      }
      
      protected function __gunangleChanged(event:LivingEvent) : void
      {
         this._takeAim["hand"].rotation = this.localPlayer.gunAngle;
         this.drawdraw();
      }
      
      private function drawdraw() : void
      {
         this._shootPoint = shootPoint();
         var angle:Number = this.localPlayer.calcBombAngle();
         GameManager.Instance.gameView.map.drawdraw(this.monkeyEnergy,angle,this._shootPoint.x,this._shootPoint.y);
      }
      
      protected function __beginShoot(event:LivingEvent) : void
      {
      }
      
      protected function __energyChanged(event:LivingEvent) : void
      {
         if(this.localPlayer.isLiving)
         {
            this._moveStrip.scaleX = this.localPlayer.energy / this.localPlayer.maxEnergy;
         }
      }
      
      override protected function __usePetSkill(event:LivingEvent) : void
      {
         if(_info.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         super.__usePetSkill(event);
         var skill:PetSkillTemplateInfo = PetSkillManager.getSkillByID(event.value);
         if(skill.isActiveSkill)
         {
            switch(skill.BallType)
            {
               case 0:
               case 3:
                  this.localPlayer.spellKillEnabled = false;
                  break;
               case 1:
               case 2:
                  this.localPlayer.soulPropEnabled = this.localPlayer.propEnabled = this.localPlayer.flyEnabled = this.localPlayer.deputyWeaponEnabled = this.localPlayer.rightPropEnabled = this.localPlayer.spellKillEnabled = false;
            }
         }
      }
   }
}

