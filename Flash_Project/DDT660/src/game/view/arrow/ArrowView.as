package game.view.arrow
{
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.GraphicsUtils;
   import ddt.view.common.GradientText;
   import ddt.view.tips.ToolPropInfo;
   import fightFootballTime.manager.FightFootballTimeManager;
   import fightLib.LessonType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.WeaponInfo;
   import trainer.data.Step;
   
   public class ArrowView extends Sprite implements Disposeable
   {
      
      public static const FLY_CD:int = 2;
      
      public static const HIDE_BAR:String = "hide bar";
      
      public static const USE_TOOL:String = "use_tool";
      
      public static const ADD_BLOOD_CD:int = 2;
      
      public static const RANDOW_COLORSII:Array = [[1351165,16768512],[1478655,2607344],[1555258,14293039],[7912215,14293199],[12862218,7721224],[14577152,15970051],[6011902,832292],[521814,13411850],[15035908,11327256],[15118867,8369930],[2213785,8116729],[10735137,14497882],[15460371,15430666],[13032456,2861311],[16670299,12510266],[44799,7721224]];
      
      public static const ANGLE_NEXTCHANGE_TIME:int = 100;
      
      private var _bg:ArrowBg;
      
      private var _info:LocalPlayer;
      
      private var _sector:Sprite;
      
      private var _recordChangeBefore:Number;
      
      private var _flyCoolDown:int = 0;
      
      private var _flyEnable:Boolean;
      
      private var _isLockFly:Boolean = false;
      
      private var rotationCountField:GradientText;
      
      private var _hammerCoolDown:int = 0;
      
      private var _hammerEnable:Boolean;
      
      private var _deputyWeaponResCount:int;
      
      private var _AngelLine:MovieClip;
      
      private var _ShineKey:Boolean;
      
      public var _AnglelShineEffect:IEffect;
      
      private var _hideState:Boolean;
      
      private var _enableArrow:Boolean;
      
      private var _currentAngleChangeTime:int = 0;
      
      private var _first:Boolean = true;
      
      private var _recordRotation:Number;
      
      private var _hammerBlocked:Boolean;
      
      public function ArrowView(info:LocalPlayer)
      {
         var pos:Point = null;
         super();
         this._info = info;
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._info.gunAngle = 47;
         }
         this._bg = ComponentFactory.Instance.creatCustomObject("game.view.arrowBg") as ArrowBg;
         addChild(this._bg);
         this._bg.arrowSub.arrowClone_mc.visible = false;
         this._bg.arrowSub.arrowChonghe_mc.visible = false;
         this._sector = GraphicsUtils.drawSector(0,0,55,0,90);
         this._sector.y = 1;
         this._bg.arrowSub.circle_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = true;
         this._bg.arrowSub.green_mc.visible = false;
         this._bg.arrowSub.addChild(this._sector);
         var text:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.game.rotationCountFieldText");
         this.rotationCountField = new GradientText(text,RANDOW_COLORSII);
         pos = ComponentFactory.Instance.creatCustomObject("asset.game.rotationCountPos");
         this.rotationCountField.x = pos.x;
         this.rotationCountField.y = pos.y;
         addChild(this.rotationCountField);
         this.rotationCountField.filters = ComponentFactory.Instance.creatFilters("game.rotationCountField_Filter");
         this.rotationCountField.setText(this.rotationCountField.text);
         this.reset();
         this.__weapAngle(null);
         this.__changeDirection(null);
         this.flyEnable = true;
         this.hammerEnable = true;
         this._flyCoolDown = 0;
         this._hammerCoolDown = 0;
         if(Boolean(this._info.selfInfo) && Boolean(this._info.selfInfo.DeputyWeapon))
         {
            this._deputyWeaponResCount = this._info.selfInfo.DeputyWeapon.StrengthenLevel + 1;
         }
         this.updataAngleLine();
      }
      
      public function set flyEnable(value:Boolean) : void
      {
         if(value == this._flyEnable)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            value = false;
         }
         this._flyEnable = value;
         if(this._isLockFly)
         {
            this._info.flyEnabled = false;
         }
         else
         {
            this._info.flyEnabled = this._flyEnable;
         }
      }
      
      private function __sendShootAction(evt:LivingEvent) : void
      {
         var localPlayer:LocalPlayer = evt.currentTarget as LocalPlayer;
         if(localPlayer.currentBomb == 3)
         {
            this._info.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_PLANE);
            NoviceDataManager.instance.saveNoviceData(550,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      public function set hammerEnable(value:Boolean) : void
      {
         if(value == this._hammerEnable)
         {
            return;
         }
         if(!this._info.hasDeputyWeapon() || !this._info.playerInfo.SnapDeputyWeapon && RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            this._hammerEnable = false;
         }
         else
         {
            this._hammerEnable = value;
         }
         this._info.deputyWeaponEnabled = this._hammerEnable;
      }
      
      public function get hammerEnable() : Boolean
      {
         return this._hammerEnable;
      }
      
      public function disable() : void
      {
         this.flyEnable = false;
         if(!this._info.currentDeputyWeaponInfo.isShield)
         {
            this.hammerEnable = false;
         }
      }
      
      private function updataAngleLine() : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.showAngleLine(FightLibManager.Instance.currentInfo.id);
         }
      }
      
      private function showAngleLine(Agnle:int) : void
      {
         if(!this._AngelLine)
         {
            this._AngelLine = ComponentFactory.Instance.creatCustomObject("game.fightLib.AngleStyle");
            addChild(this._AngelLine);
            this._AngelLine.gotoAndStop("stand");
         }
         switch(Agnle)
         {
            case LessonType.Twenty:
               this._AngelLine.gotoAndStop("20Degree");
               break;
            case LessonType.SixtyFive:
               this._AngelLine.gotoAndStop("65Degree");
               break;
            case LessonType.HighThrow:
               this._AngelLine.gotoAndStop("90Degree");
               break;
            default:
               return;
         }
         this._AnglelShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._AngelLine,{"color":EffectColorType.GOLD});
      }
      
      private function setTip(btn:BaseButton, name:String, property4:String, description:String, dirction:String = "0", showThew:Boolean = true, tipGapH:int = 10) : void
      {
         btn.tipStyle = "core.ToolPropTips";
         btn.tipDirctions = dirction;
         btn.tipGapV = 0;
         btn.tipGapH = tipGapH;
         var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
         itemTemplateInfo.Name = name;
         itemTemplateInfo.Property4 = property4;
         itemTemplateInfo.Description = description;
         var tipInfo:ToolPropInfo = new ToolPropInfo();
         tipInfo.info = itemTemplateInfo;
         tipInfo.count = 1;
         tipInfo.showTurn = false;
         tipInfo.showThew = showThew;
         tipInfo.showCount = false;
         btn.tipData = tipInfo;
      }
      
      private function reset() : void
      {
         this._bg.arrowSub.green_mc.mask = null;
         this._bg.arrowSub.circle_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = true;
         this._bg.arrowSub.green_mc.visible = false;
         if(Boolean(this._info) && Boolean(this._info.currentWeapInfo))
         {
            if(RoomManager.Instance.current.type == RoomInfo.RESCUE)
            {
               GraphicsUtils.changeSectorAngle(this._sector,0,0,55,0,90);
            }
            else
            {
               GraphicsUtils.changeSectorAngle(this._sector,0,0,55,this._info.currentWeapInfo.armMinAngle,this._info.currentWeapInfo.armMaxAngle - this._info.currentWeapInfo.armMinAngle + 1);
            }
         }
      }
      
      public function set hideState(param:Boolean) : void
      {
         this._hideState = param;
      }
      
      public function get hideState() : Boolean
      {
         return this._hideState;
      }
      
      private function carrayAngle() : void
      {
         this._bg.arrowSub.circle_mc.mask = null;
         this._bg.arrowSub.green_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = false;
         this._bg.arrowSub.green_mc.visible = true;
         GraphicsUtils.changeSectorAngle(this._sector,0,0,55,0,90);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._AnglelShineEffect))
         {
            EffectManager.Instance.removeEffect(this._AnglelShineEffect);
         }
         FightLibManager.Instance.isWork = false;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._sector);
         ObjectUtils.disposeObject(this.rotationCountField);
         ObjectUtils.disposeObject(this._AngelLine);
         this._bg = null;
         this._info = null;
         this._sector = null;
         this.rotationCountField = null;
         this._AngelLine = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function initEvents() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_PLANE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            this._info.addEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
         }
         this._info.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__weapAngle);
         this._info.addEventListener(LivingEvent.DIR_CHANGED,this.__changeDirection);
         this._info.addEventListener(LivingEvent.ANGLE_CHANGED,this.__changeAngle);
         this._info.addEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__setArrowClone);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__onTurnChange);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.REVIVE,this.__revive);
         this._info.addEventListener(LivingEvent.LOCKANGLE_CHANGE,this.__lockAngleChangeHandler);
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,this.__setDeputyWeaponNumber);
      }
      
      private function removeEvent() : void
      {
         this._info.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
         this._info.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__weapAngle);
         this._info.removeEventListener(LivingEvent.DIR_CHANGED,this.__changeDirection);
         this._info.removeEventListener(LivingEvent.ANGLE_CHANGED,this.__changeAngle);
         this._info.removeEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__setArrowClone);
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.removeEventListener(LivingEvent.DIE,this.__die);
         this._info.removeEventListener(LivingEvent.REVIVE,this.__revive);
         this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,this.__onTurnChange);
         this._info.removeEventListener(LivingEvent.LOCKANGLE_CHANGE,this.__lockAngleChangeHandler);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,this.__setDeputyWeaponNumber);
      }
      
      private function __lockAngleChangeHandler(e:LivingEvent) : void
      {
         this.enableArrow = this._info.isLockAngle;
      }
      
      public function set enableArrow(b:Boolean) : void
      {
         this._enableArrow = b;
         if(!b)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         }
         else
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function __onTurnChange(e:LivingEvent) : void
      {
         this.rotationCountField.setText(this.rotationCountField.text);
      }
      
      private function __die(event:Event) : void
      {
         if(!this._info.isLiving)
         {
            this.flyEnable = false;
            this.hammerEnable = false;
         }
      }
      
      private function __revive(event:Event) : void
      {
         this.flyEnable = true;
         this.hammerEnable = true;
      }
      
      private function __enterFrame(event:Event) : void
      {
         var angleChanged:Boolean = false;
         var currentTime:int = getTimer();
         if(currentTime - this._currentAngleChangeTime < ANGLE_NEXTCHANGE_TIME)
         {
            return;
         }
         var playSound:Boolean = false;
         if(KeyboardManager.isDown(KeyStroke.VK_S.getCode()) || KeyboardManager.isDown(Keyboard.DOWN))
         {
            if(this._currentAngleChangeTime != 0)
            {
               playSound = this._info.manuallySetGunAngle(this._info.gunAngle - WeaponInfo.ROTATITON_SPEED * this._info.reverse);
            }
            else
            {
               this._currentAngleChangeTime = getTimer();
            }
            angleChanged = true;
         }
         else if(KeyboardManager.isDown(KeyStroke.VK_W.getCode()) || KeyboardManager.isDown(Keyboard.UP))
         {
            if(this._currentAngleChangeTime != 0)
            {
               playSound = this._info.manuallySetGunAngle(this._info.gunAngle + WeaponInfo.ROTATITON_SPEED * this._info.reverse);
            }
            if(this._currentAngleChangeTime == 0)
            {
               this._currentAngleChangeTime = getTimer();
            }
            angleChanged = true;
         }
         if(!angleChanged)
         {
            this._currentAngleChangeTime = 0;
         }
         if(playSound)
         {
            SoundManager.instance.play("006");
         }
      }
      
      private function __inputKeyDown(event:KeyboardEvent) : void
      {
         var playSound:Boolean = false;
         if(!ChatManager.Instance.input.inputField.isFocus())
         {
            playSound = false;
            if(event.keyCode == KeyStroke.VK_S.getCode() || event.keyCode == Keyboard.DOWN)
            {
               playSound = this._info.manuallySetGunAngle(this._info.gunAngle - WeaponInfo.ROTATITON_SPEED * this._info.reverse);
               this._currentAngleChangeTime = 0;
            }
            else if(event.keyCode == KeyStroke.VK_W.getCode() || event.keyCode == Keyboard.UP)
            {
               playSound = this._info.manuallySetGunAngle(this._info.gunAngle + WeaponInfo.ROTATITON_SPEED * this._info.reverse);
               this._currentAngleChangeTime = 0;
            }
            if(playSound)
            {
               SoundManager.instance.play("006");
            }
         }
      }
      
      private function __keydown(event:KeyboardEvent) : void
      {
         if(event.keyCode != KeyStroke.VK_F.getCode())
         {
            if(event.keyCode == KeyStroke.VK_T.getCode())
            {
               dispatchEvent(new Event(ArrowView.HIDE_BAR));
            }
         }
      }
      
      private function __changeBall(event:LivingEvent) : void
      {
         if(this._info.currentBomb == 3 || this._info.currentBomb == 110 || this._info.currentBomb == 117)
         {
            this.carrayAngle();
         }
         else
         {
            this.resetAngle();
         }
      }
      
      private function resetAngle() : void
      {
         this.reset();
      }
      
      private function __change(event:LivingEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         var deputyEnergy:Number = Number(this._info.currentDeputyWeaponInfo.energy);
         this.resetAngle();
      }
      
      private function __weapAngle(event:LivingEvent) : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.checkAngle();
         }
         var temp:Number = 0;
         if(this._info.direction == -1)
         {
            temp = 0;
         }
         else
         {
            temp = 180;
         }
         if(this._info.gunAngle < 0)
         {
            this._bg.arrowSub.arrow.rotation = 360 - (this._info.gunAngle - 180 + temp) * this._info.direction;
         }
         else
         {
            this._bg.arrowSub.arrow.rotation = 360 - (this._info.gunAngle + 180 + temp) * this._info.direction;
         }
         this._recordChangeBefore = this._info.gunAngle;
         this.rotationCountField.setText(String(this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction),false);
         if(this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = true;
            this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.visible = false;
            this._bg.arrowSub.arrow.visible = false;
         }
         else
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = false;
            this._bg.arrowSub.arrowClone_mc.visible = this._first ? false : true;
            this._bg.arrowSub.arrow.visible = true;
         }
      }
      
      private function checkAngle() : void
      {
         if(this._info.direction !== 1 || !this._AnglelShineEffect)
         {
            return;
         }
         var _Angle:int = this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction;
         if(Boolean(FightLibManager.Instance.currentInfo))
         {
            switch(FightLibManager.Instance.currentInfo.id)
            {
               case LessonType.Twenty:
                  if(_Angle > 30 || _Angle < 10)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
                  break;
               case LessonType.SixtyFive:
                  if(_Angle > 75 || _Angle < 55)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
                  break;
               case LessonType.HighThrow:
                  if(_Angle > 100 || _Angle < 60)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
            }
         }
      }
      
      public function set ShineKey(Value:Boolean) : void
      {
         if(this._ShineKey == Value)
         {
            return;
         }
         this._ShineKey = Value;
         this.shineAngleLine();
      }
      
      public function get ShineKey() : Boolean
      {
         return this._ShineKey;
      }
      
      private function shineAngleLine() : void
      {
         if(this._ShineKey == true)
         {
            FightLibManager.Instance.isWork = true;
            this._AnglelShineEffect.play();
         }
         else
         {
            FightLibManager.Instance.isWork = false;
            this._AnglelShineEffect.stop();
         }
      }
      
      private function __changeDirection(event:LivingEvent) : void
      {
         this.__weapAngle(null);
         if(this._info.direction == -1)
         {
            this._sector.scaleX = -1;
            if(Boolean(this._AnglelShineEffect))
            {
               this.ShineKey = true;
            }
         }
         else
         {
            this._sector.scaleX = 1;
         }
      }
      
      private function __changeAngle(event:LivingEvent) : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.checkAngle();
         }
         var dis:Number = this._bg.arrowSub.rotation - this._info.playerAngle;
         this._bg.arrowSub.rotation = this._info.playerAngle;
         this._recordRotation += dis;
         this._bg.arrowSub.arrowClone_mc.rotation = this._recordRotation;
         this.rotationCountField.setText(String(this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction),false);
         if(this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = true;
            this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.visible = false;
            this._bg.arrowSub.arrow.visible = false;
         }
         else
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = false;
            this._bg.arrowSub.arrowClone_mc.visible = this._first ? false : true;
            this._bg.arrowSub.arrow.visible = true;
         }
      }
      
      private function __setArrowClone(event:Event) : void
      {
         if(!this._info.isAttacking)
         {
            this._first = false;
            this._bg.arrowSub.arrowClone_mc.visible = true;
            this._recordRotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
         }
      }
      
      public function setRecordRotation() : void
      {
         this._first = false;
         this._bg.arrowSub.arrowClone_mc.visible = true;
         this._recordRotation = this._bg.arrowSub.arrow.rotation;
         this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
      }
      
      public function blockHammer() : void
      {
         this._hammerBlocked = true;
         this._hammerCoolDown = 100000;
      }
      
      public function allowHammer() : void
      {
         this._hammerBlocked = false;
         this._hammerCoolDown = 0;
      }
      
      private function __setDeputyWeaponNumber(event:CrazyTankSocketEvent) : void
      {
         this._deputyWeaponResCount = event.pkg.readInt();
         if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            this._info.snapDeputyWeaponCount = this._deputyWeaponResCount;
         }
         else
         {
            this._info.deputyWeaponCount = this._deputyWeaponResCount;
         }
      }
      
      public function get transparentBtn() : SimpleBitmapButton
      {
         return null;
      }
      
      public function setPlaneBtnVisible(value:Boolean) : void
      {
         this.flyEnable = value;
      }
      
      public function setOffHandedBtnVisible(value:Boolean) : void
      {
         this.hammerEnable = value;
      }
      
      public function enter() : void
      {
         this.initEvents();
         this.__changeAngle(null);
      }
      
      public function leaving() : void
      {
         this.removeEvent();
      }
   }
}

