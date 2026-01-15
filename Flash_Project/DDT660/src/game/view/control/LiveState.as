package game.view.control
{
   import catchInsect.componets.InsectProBar;
   import catchInsect.event.InsectEvent;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.EnergyView;
   import game.view.arrow.ArrowView;
   import game.view.prop.CustomPropBar;
   import game.view.prop.HorseGameSkillBar;
   import game.view.prop.PetSkillBar;
   import game.view.prop.RightPropBar;
   import game.view.prop.WeaponPropBar;
   import game.view.tool.ToolStripView;
   import rescue.components.RescuePropBar;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import treasureLost.view.TreasureLostProBar;
   import ddt.manager.ChatManager;
   
   public class LiveState extends ControlState
   {
      
      protected var _arrow:ArrowView;
      
      protected var _energy:EnergyView;
      
      protected var _customPropBar:CustomPropBar;
      
      protected var _tool:ToolStripView;
      
      protected var _rightPropBar:RightPropBar;
      
      protected var _weaponPropBar:WeaponPropBar;
      
      protected var _rescuePropBar:RescuePropBar;
      
      protected var _insectProBar:InsectProBar;
      
      protected var _treasureLostProBar:TreasureLostProBar;
      
      protected var _horseSkillBar:HorseGameSkillBar;
      
      protected var _petSkill:PetSkillBar;
      
      protected var _petSkillIsShowBtn:BaseButton;
      
      protected var _petSkillBtnCurrentFrame:int;
      
      protected var _petSkillIsShowBtnTopY:Number;
      
      private var _gameInfo:GameInfo = GameManager.Instance.Current;
      
      public function LiveState(self:LocalPlayer)
      {
         super(self);
      }
      
      override protected function configUI() : void
      {
         this._arrow = new ArrowView(_self);
         var arrowPos:Point = ComponentFactory.Instance.creatCustomObject("asset.game.ArrowViewPos");
         this._arrow.x = arrowPos.x;
         this._arrow.y = arrowPos.y;
         addChild(this._arrow);
         this._energy = new EnergyView(_self);
         var energyPos:Point = ComponentFactory.Instance.creatCustomObject("asset.game.energyPos");
         this._energy.x = energyPos.x;
         this._energy.y = energyPos.y;
         addChild(this._energy);
         if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            this._customPropBar = ComponentFactory.Instance.creatCustomObject("EntertainmentCustomPropBar",[_self,FightControlBar.LIVE]);
         }
         else if(RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM || this._gameInfo.mapIndex == 1405 || this._gameInfo.mapIndex == 1407 || this._gameInfo.missionInfo != null && (this._gameInfo.missionInfo.id == 1277 || this._gameInfo.missionInfo.id == 1378))
         {
            this._customPropBar = ComponentFactory.Instance.creatCustomObject("LiveCustomPropBar",[_self,FightControlBar.LIVE]);
            addChild(this._customPropBar);
         }
         else if(this._gameInfo.roomType == RoomInfo.DUNGEON_ROOM && (this._gameInfo.mapIndex == 1405 || this._gameInfo.mapIndex == 1407))
         {
            this._customPropBar = ComponentFactory.Instance.creatCustomObject("LiveCustomPropBar",[_self,FightControlBar.LIVE]);
            addChild(this._customPropBar);
         }
         else if(this._gameInfo.roomType != FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            if(RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
            {
               this._insectProBar = ComponentFactory.Instance.creatCustomObject("catchInsect.propBar",[_self,FightControlBar.LIVE]);
               addChild(this._insectProBar);
               this._insectProBar.enter();
               this._insectProBar.addEventListener(InsectEvent.USE_PROP,this.__useInsectProp);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.TREASURELOST_ROOM)
            {
               this._treasureLostProBar = ComponentFactory.Instance.creatCustomObject("treasureLost.view.propBar",[_self,FightControlBar.LIVE]);
               addChild(this._treasureLostProBar);
               this._treasureLostProBar.enter();
               this._treasureLostProBar.addEventListener(InsectEvent.USE_PROP,this.__useInsectProp);
            }
            else
            {
               this._horseSkillBar = new HorseGameSkillBar(_self);
               this._horseSkillBar.x = 654;
               this._horseSkillBar.y = 57;
               addChild(this._horseSkillBar);
            }
         }
         if(Boolean(_self.currentPet))
         {
            this._petSkill = new PetSkillBar(_self);
            PositionUtils.setPos(this._petSkill,"asset.game.petskillBarPos");
            if(!(this._gameInfo.mapIndex == 1405 || this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK || RoomManager.Instance.current.type == RoomInfo.TREASURELOST_ROOM))
            {
               addChild(this._petSkill);
            }
            this._petSkillIsShowBtn = ComponentFactory.Instance.creatComponentByStylename("game.petSkillBarIsShowBtn");
            MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(1);
            this._petSkillBtnCurrentFrame = 1;
            this._petSkillIsShowBtn.addEventListener(MouseEvent.CLICK,this.__onPetSillIsShowBtnClick);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.ROLL_OVER,this.__onPetSillIsShowBtnOver);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.ROLL_OUT,this.__onPetSillIsShowBtnOut);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__onPetSillIsShowBtnMousedown);
            if(!(this._gameInfo.mapIndex == 1405 || this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK || RoomManager.Instance.current.type == RoomInfo.TREASURELOST_ROOM))
            {
               addChild(this._petSkillIsShowBtn);
            }
            this._petSkillIsShowBtnTopY = this._petSkillIsShowBtn.y;
         }
         this._weaponPropBar = ComponentFactory.Instance.creatCustomObject("WeaponPropBar",[_self]);
		 addChild(this._weaponPropBar);
		 
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            if(Boolean(this._petSkill))
            {
               this._petSkill.visible = false;
               this._petSkillIsShowBtn.visible = false;
            }
         }
         this._tool = new ToolStripView();
         var toolPos:Point = ComponentFactory.Instance.creatCustomObject("asset.game.toolPos");
         this._tool.x = toolPos.x;
         this._tool.y = toolPos.y;
         if(this._gameInfo.roomType != FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            addChild(this._tool);
         }
         this._rightPropBar = ComponentFactory.Instance.creatCustomObject("RightPropBar",[_self,this]);
         super.configUI();
      }
      
      protected function __useInsectProp(event:InsectEvent) : void
      {
         if(Boolean(this._rightPropBar))
         {
            this._rightPropBar.hidePropBar();
         }
      }
      
      private function __onPetSillIsShowBtnOver(e:MouseEvent) : void
      {
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      private function __onPetSillIsShowBtnOut(e:MouseEvent) : void
      {
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      private function __onPetSillIsShowBtnMousedown(e:MouseEvent) : void
      {
      }
      
      private function __onPetSillIsShowBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._petSkill.visible)
         {
            this._petSkillBtnCurrentFrame = 2;
            this._petSkill.visible = false;
            if(Boolean(this._customPropBar))
            {
               this._petSkillIsShowBtn.y = this._customPropBar.y - this._petSkillIsShowBtn.height;
            }
            if(Boolean(this._horseSkillBar))
            {
               this._petSkillIsShowBtn.y = this._horseSkillBar.y - this._petSkillIsShowBtn.height;
            }
         }
         else
         {
            this._petSkillBtnCurrentFrame = 1;
            this._petSkill.visible = true;
            this._petSkillIsShowBtn.y = this._petSkillIsShowBtnTopY;
         }
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      override protected function addEvent() : void
      {
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.addEvent();
      }
      
      protected function __transparentChanged(event:Event) : void
      {
         if(SharedManager.Instance.propTransparent)
         {
            this._arrow.alpha = 0.5;
            this._energy.alpha = 0.5;
            if(Boolean(this._customPropBar))
            {
               this._customPropBar.alpha = 0.5;
            }
            if(Boolean(this._horseSkillBar))
            {
               this._horseSkillBar.alpha = 0.5;
            }
            this._weaponPropBar.alpha = 0.5;
            if(Boolean(this._petSkill))
            {
               this._petSkill.alpha = 0.5;
            }
            this._tool.alpha = 0.5;
            if(Boolean(this._petSkillIsShowBtn))
            {
               this._petSkillIsShowBtn.alpha = 0.5;
            }
         }
         else
         {
            this._arrow.alpha = 1;
            if(Boolean(this._petSkill))
            {
               this._petSkill.alpha = 1;
            }
            this._energy.alpha = 1;
            if(Boolean(this._customPropBar))
            {
               this._customPropBar.alpha = 1;
            }
            if(Boolean(this._horseSkillBar))
            {
               this._horseSkillBar.alpha = 1;
            }
            this._weaponPropBar.alpha = 1;
            this._tool.alpha = 1;
            if(Boolean(this._petSkillIsShowBtn))
            {
               this._petSkillIsShowBtn.alpha = 1;
            }
         }
      }
      
      override protected function removeEvent() : void
      {
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.removeEvent();
      }
      
      override public function enter(container:DisplayObjectContainer) : void
      {
         if(Boolean(this._customPropBar))
         {
            this._customPropBar.enter();
            if(!this.contains(this._customPropBar))
            {
               addChild(this._customPropBar);
            }
         }
         if(Boolean(this._horseSkillBar))
         {
            this._horseSkillBar.enter();
         }
         this._weaponPropBar.enter();
         if(!this.contains(this._weaponPropBar) && GameManager.Instance.Current.mapIndex != 1405 && RoomManager.Instance.current.type != RoomInfo.RESCUE)
         {
            addChild(this._weaponPropBar);
         }
         this._energy.enter();
         this._arrow.enter();
         this._rightPropBar.setup(container);
         this._rightPropBar.enter();
         this._gameInfo = GameManager.Instance.Current;
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.loadWeakGuild();
         }
         if(RoomManager.Instance.current.type == RoomInfo.RESCUE || RoomManager.Instance.current.type == RoomInfo.CATCH_INSECT_ROOM)
         {
            this._tool.setDanderEnable(false);
         }
         this.__transparentChanged(null);
         super.enter(container);
      }
      
      override public function leaving(onComplete:Function = null) : void
      {
         if(Boolean(this._customPropBar))
         {
            this._customPropBar.leaving();
         }
         if(Boolean(this._insectProBar))
         {
            this._insectProBar.leaving();
            this._insectProBar.removeEventListener(InsectEvent.USE_PROP,this.__useInsectProp);
         }
         if(Boolean(this._treasureLostProBar))
         {
            this._treasureLostProBar.leaving();
            this._treasureLostProBar.removeEventListener(InsectEvent.USE_PROP,this.__useInsectProp);
         }
         if(Boolean(this._horseSkillBar))
         {
            this._horseSkillBar.leaving();
         }
         this._rightPropBar.leaving();
         this._weaponPropBar.leaving();
         ObjectUtils.disposeObject(this._rescuePropBar);
         this._rescuePropBar = null;
         this._energy.leaving();
         this._arrow.leaving();
         super.leaving(onComplete);
      }
      
      override protected function tweenIn() : void
      {
         y = 600;
         TweenLite.to(this,0.3,{"y":498});
      }
      
      protected function loadWeakGuild() : void
      {
         //this.setWeaponPropVisible(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN));
		 this.setWeaponPropVisible(true);
		 this._tool.setDanderEnable(true);
		 this.setRightPropVisible(true,0,1,2,3,4,5,6,7,8);
		 //ChatManager.Instance.sysChatYellow("Buraya geldi");

         if(NewHandGuideManager.Instance.mapID == 111)
         {
            this.setArrowVisible(false);
            this.setEnergyVisible(false);
            this.setSelfPropBarVisible(false);
         }
      }
      
      private function __onDander(event:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            if(GameManager.Instance.Current.selfGamePlayer.dander >= Player.TOTAL_DANDER)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TIP_POWER,-30,"trainer.posTipPower");
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showTenPersentArrow(evt:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_TEN_PERCENT,-90,"trainer.posTipTenPercent");
            NewHandContainer.Instance.showArrow(ArrowType.TIP_ONE,-90,"trainer.posTipOne");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showThreeArrow(evt:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE,-90,"trainer.posTipThree");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function propOpenShow(mcStr:String) : void
      {
         var mc:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(mcStr),true,true);
         LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_UI_LAYER,false);
      }
      
      protected function setWeaponPropVisible(val:Boolean) : void
      {
         this._weaponPropBar.setVisible(val);
         if(val)
         {
            if(!this._weaponPropBar.parent)
            {
               addChild(this._weaponPropBar);
            }
         }
         else if(Boolean(this._weaponPropBar.parent))
         {
            this._weaponPropBar.parent.removeChild(this._weaponPropBar);
         }
      }
      
      protected function setRightPropVisible(v:Boolean, ... args) : void
      {
         for(var i:int = 0; i < args.length; i++)
         {
            this._rightPropBar.setPropVisible(args[i],v);
         }
      }
      
      protected function setSelfPropBarVisible(v:Boolean) : void
      {
         if(Boolean(this._horseSkillBar))
         {
            if(v)
            {
               this._horseSkillBar.enter();
            }
            else
            {
               this._horseSkillBar.leaving();
            }
         }
         if(Boolean(this._customPropBar))
         {
            this._customPropBar.setVisible(v);
            if(v)
            {
               if(!this._customPropBar.parent)
               {
                  addChild(this._customPropBar);
               }
            }
            else if(Boolean(this._customPropBar.parent))
            {
               this._customPropBar.parent.removeChild(this._customPropBar);
            }
         }
      }
      
      protected function setArrowVisible(v:Boolean) : void
      {
         this._arrow.visible = v;
      }
      
      public function setEnergyVisible(v:Boolean) : void
      {
         this._energy.visible = v;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._gameInfo))
         {
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__onDander);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.DANDER_CHANGED,this.__onDander);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showTenPersentArrow);
            this._gameInfo = null;
         }
         if(Boolean(this._petSkillIsShowBtn))
         {
            this._petSkillIsShowBtn.removeEventListener(MouseEvent.CLICK,this.__onPetSillIsShowBtnClick);
            this._petSkillIsShowBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__onPetSillIsShowBtnOver);
            this._petSkillIsShowBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__onPetSillIsShowBtnOut);
            this._petSkillIsShowBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onPetSillIsShowBtnMousedown);
            ObjectUtils.disposeObject(this._petSkillIsShowBtn);
            this._petSkillIsShowBtn = null;
         }
         ObjectUtils.disposeObject(this._arrow);
         this._arrow = null;
         ObjectUtils.disposeObject(this._energy);
         this._energy = null;
         ObjectUtils.disposeObject(this._customPropBar);
         this._customPropBar = null;
         ObjectUtils.disposeObject(this._insectProBar);
         this._insectProBar = null;
         ObjectUtils.disposeObject(this._treasureLostProBar);
         this._treasureLostProBar = null;
         ObjectUtils.disposeObject(this._horseSkillBar);
         this._horseSkillBar = null;
         ObjectUtils.disposeObject(this._weaponPropBar);
         this._weaponPropBar = null;
         ObjectUtils.disposeObject(this._tool);
         this._tool = null;
         ObjectUtils.disposeObject(this._petSkill);
         this._petSkill = null;
         ObjectUtils.disposeObject(this._rightPropBar);
         this._rightPropBar = null;
      }
      
      public function get rescuePropBar() : RescuePropBar
      {
         return this._rescuePropBar;
      }
      
      public function get insectProBar() : InsectProBar
      {
         return this._insectProBar;
      }
      
      public function get treasureLostProBar() : TreasureLostProBar
      {
         return this._treasureLostProBar;
      }
      
      public function get rightPropBar() : RightPropBar
      {
         return this._rightPropBar;
      }
   }
}

