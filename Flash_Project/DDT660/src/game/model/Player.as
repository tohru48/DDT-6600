package game.model
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.LivingEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.character.GameCharacter;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import game.view.map.MapView;
   import pet.date.PetSkillTemplateInfo;
   import room.RoomManager;
   import room.model.DeputyWeaponInfo;
   import room.model.WeaponInfo;
   import room.model.WebSpeedInfo;
   
   [Event(name="bombChanged",type="ddt.events.LivingEvent")]
   [Event(name="danderChanged",type="ddt.events.LivingEvent")]
   [Event(name="usingSpecialSkill",type="ddt.events.LivingEvent")]
   [Event(name="usingItem",type="ddt.events.LivingEvent")]
   [Event(name="addState",type="ddt.events.LivingEvent")]
   [Event(name="beginShoot",type="ddt.events.LivingEvent")]
   public class Player extends TurnedLiving
   {
      
      public static const MaxPsychic:int = 999;
      
      public static const MaxSoulPropUsedCount:int = 2;
      
      public static var MOVE_SPEED:Number = 2;
      
      public static var GHOST_MOVE_SPEED:Number = 8;
      
      public static var FALL_SPEED:Number = 12;
      
      public static const FORCE_MAX:int = 2000;
      
      public static const FORCE_STEP:int = 24;
      
      public static const TOTAL_DANDER:int = 200;
      
      public static const SHOOT_INTERVAL:uint = 24;
      
      public static const SHOOT_TIMER:uint = 1000;
      
      public static const TOTAL_BLOOD:int = 1000;
      
      public static const TOTAL_LEADER_BLOOD:int = 2000;
      
      public static const FULL_HP:int = 1;
      
      public static const LACK_HP:int = 2;
      
      private var _currentMap:MapView;
      
      public var isPlayAnimation:int;
      
      protected var _maxForce:int = 2000;
      
      private var _info:PlayerInfo;
      
      private var _movie:GameCharacter;
      
      public var _expObj:Object;
      
      public var isUpGrade:Boolean;
      
      private var _isWin:Boolean;
      
      public var tieStatus:int;
      
      public var CurrentLevel:int;
      
      public var CurrentGP:int;
      
      public var TotalKill:int;
      
      public var TotalHurt:int;
      
      public var TotalHitTargetCount:int;
      
      public var TotalShootCount:int;
      
      public var GetCardCount:int;
      
      private var _bossCardCount:int;
      
      public var GainOffer:int;
      
      public var GainGP:int;
      
      public var VipGP:int;
      
      public var MarryGP:int;
      
      public var AcademyGP:int;
      
      public var zoneName:String;
      
      private var _powerRatio:int = 100;
      
      private var _skill:int = -1;
      
      private var _isSpecialSkill:Boolean;
      
      protected var _dander:int;
      
      private var _currentWeapInfo:WeaponInfo;
      
      private var _currentBomb:int;
      
      public var webSpeedInfo:WebSpeedInfo;
      
      private var _currentDeputyWeaponInfo:DeputyWeaponInfo;
      
      private var _isReady:Boolean;
      
      private var _turnTime:int = 0;
      
      private var _reverse:int = 1;
      
      private var _isAutoGuide:Boolean = false;
      
      private var _pet:Pet;
      
      private var _snapPet:Pet;
      
      public var hasLevelAgain:Boolean = false;
      
      public var hasGardGet:Boolean = false;
      
      public var wishKingCount:int;
      
      public var wishKingEnergy:int;
      
      public function Player(info:PlayerInfo, id:int, team:int, maxBlood:int)
      {
         this._info = info;
         super(id,team,maxBlood);
         this.setWeaponInfo();
         this.setDeputyWeaponInfo();
         this.setSnapDeputyWeaponInfo();
         this.webSpeedInfo = new WebSpeedInfo(this._info.webSpeed);
         this.initEvent();
      }
      
      public function get currentMap() : MapView
      {
         return this._currentMap;
      }
      
      public function set currentMap(value:MapView) : void
      {
         this._currentMap = value;
      }
      
      public function get BossCardCount() : int
      {
         return this._bossCardCount;
      }
      
      public function set BossCardCount(value:int) : void
      {
         this._bossCardCount = value;
      }
      
      private function initEvent() : void
      {
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged);
      }
      
      private function removeEvent() : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.movie = null;
         character = null;
         if(Boolean(this._currentWeapInfo))
         {
            this._currentWeapInfo.dispose();
         }
         this._currentWeapInfo = null;
         if(Boolean(this._currentDeputyWeaponInfo))
         {
            this._currentDeputyWeaponInfo.dispose();
         }
         this._currentDeputyWeaponInfo = null;
         this.webSpeedInfo = null;
         this._info = null;
         super.dispose();
      }
      
      override public function reset() : void
      {
         super.reset();
         _isAttacking = false;
         this._dander = 0;
         if(Boolean(this._movie))
         {
            this._movie.State = FULL_HP;
         }
      }
      
      override public function get playerInfo() : PlayerInfo
      {
         return this._info;
      }
      
      override public function get isSelf() : Boolean
      {
         return this._info is SelfInfo;
      }
      
      public function get movie() : GameCharacter
      {
         return this._movie;
      }
      
      public function set movie(value:GameCharacter) : void
      {
         this._movie = value;
      }
      
      public function get isWin() : Boolean
      {
         return this._isWin;
      }
      
      public function set isWin(value:Boolean) : void
      {
         this._isWin = value;
      }
      
      public function set MP(value:int) : void
      {
         if(Boolean(this.currentPet))
         {
            this.currentPet.MP = value;
         }
      }
      
      public function set expObj(value:Object) : void
      {
         this._expObj = value;
      }
      
      public function get expObj() : Object
      {
         return this._expObj;
      }
      
      public function playerMoveTo(type:Number, target:Point, dir:Number, isLiving:Boolean, acts:Array = null) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAYER_MOVETO,0,0,type,target,dir,isLiving,acts));
      }
      
      public function beginShoot() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
      }
      
      public function useItem(info:ItemTemplateInfo) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,info));
      }
      
      public function useItemByIcon(dis:DisplayObject) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,dis));
      }
      
      public function get maxForce() : int
      {
         return this._maxForce;
      }
      
      public function set maxForce(val:int) : void
      {
         if(this._maxForce != val)
         {
            this._maxForce = val;
            dispatchEvent(new LivingEvent(LivingEvent.MAXFORCE_CHANGED,this._maxForce));
         }
      }
      
      public function get powerRatio() : Number
      {
         return this._powerRatio / 100;
      }
      
      public function set powerRatio(value:Number) : void
      {
         this._powerRatio = value;
      }
      
      public function get skill() : int
      {
         return this._skill;
      }
      
      public function set skill(val:int) : void
      {
         this._skill = val;
         if(this._skill >= 0)
         {
            dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
         }
      }
      
      public function get isSpecialSkill() : Boolean
      {
         return this._isSpecialSkill;
      }
      
      public function set isSpecialSkill(value:Boolean) : void
      {
         if(this._isSpecialSkill != value)
         {
            this._isSpecialSkill = value;
            if(value)
            {
               dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
            }
         }
      }
      
      public function get dander() : int
      {
         return this._dander;
      }
      
      public function set dander(value:int) : void
      {
         if(Boolean(RoomManager.Instance.current))
         {
            if(RoomManager.Instance.current.gameMode == 8)
            {
               return;
            }
         }
         if(this._dander == value)
         {
            return;
         }
         if(this._dander > value && value > 0)
         {
            return;
         }
         if(this._dander < 0)
         {
            this._dander = 0;
         }
         else
         {
            this._dander = value > TOTAL_DANDER ? TOTAL_DANDER : value;
         }
         dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED,this._dander));
      }
      
      public function reduceDander(value:int) : void
      {
         if(this._dander == value)
         {
            return;
         }
         if(this._dander < 0)
         {
            this._dander = 0;
         }
         else
         {
            this._dander = value > TOTAL_DANDER ? TOTAL_DANDER : value;
         }
         dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED,this._dander));
      }
      
      public function setSnapDeputyWeaponInfo() : void
      {
         var iteminfo:InventoryItemInfo = null;
         if(Boolean(this._info.snapDeputyWeaponID) && RoomManager.Instance.isTransnationalFight())
         {
            iteminfo = new InventoryItemInfo();
            iteminfo.TemplateID = this._info.snapDeputyWeaponID;
            ItemManager.fill(iteminfo);
            this._currentDeputyWeaponInfo = new DeputyWeaponInfo(iteminfo);
         }
      }
      
      public function get currentWeapInfo() : WeaponInfo
      {
         return this._currentWeapInfo;
      }
      
      public function get currentBomb() : int
      {
         return this._currentBomb;
      }
      
      public function set currentBomb(value:int) : void
      {
         if(value == this._currentBomb)
         {
            return;
         }
         this._currentBomb = value;
         dispatchEvent(new LivingEvent(LivingEvent.BOMB_CHANGED,this._currentBomb,0));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this._currentBomb = this._currentWeapInfo.commonBall;
         this._isSpecialSkill = false;
         gemDefense = false;
      }
      
      override public function die(widthAction:Boolean = true) : void
      {
         if(isLiving)
         {
            if(Boolean(this._movie))
            {
               this._movie.State = LACK_HP;
            }
            super.die();
            this.isSpecialSkill = false;
            this.dander = 0;
            SoundManager.instance.play("Sound042");
         }
      }
      
      override public function isPlayer() : Boolean
      {
         return true;
      }
      
      protected function setWeaponInfo() : void
      {
         var iteminfo:InventoryItemInfo = new InventoryItemInfo();
         iteminfo.TemplateID = this.playerInfo.WeaponID;
         ItemManager.fill(iteminfo);
         if(Boolean(this._currentWeapInfo))
         {
            this._currentWeapInfo.dispose();
         }
         this._currentWeapInfo = new WeaponInfo(iteminfo);
         this.currentBomb = this._currentWeapInfo.commonBall;
      }
      
      public function setDeputyWeaponInfo() : void
      {
         var iteminfo:InventoryItemInfo = new InventoryItemInfo();
         iteminfo.TemplateID = this._info.DeputyWeaponID;
         ItemManager.fill(iteminfo);
         this._currentDeputyWeaponInfo = new DeputyWeaponInfo(iteminfo);
      }
      
      public function get currentDeputyWeaponInfo() : DeputyWeaponInfo
      {
         return this._currentDeputyWeaponInfo;
      }
      
      public function hasDeputyWeapon() : Boolean
      {
         return this._info != null && this._info.DeputyWeaponID > 0;
      }
      
      private function __playerPropChanged(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["WeaponID"]))
         {
            this.setWeaponInfo();
         }
         else if(Boolean(event.changedProperties["DeputyWeaponID"]))
         {
            this.setDeputyWeaponInfo();
         }
         else if(Boolean(event.changedProperties["snapDeputyWeaponID"]))
         {
            this.setSnapDeputyWeaponInfo();
         }
         if(Boolean(event.changedProperties["Grade"]) && StateManager.currentStateType != StateType.MISSION_ROOM)
         {
            this.isUpGrade = this._info.IsUpGrade;
            if(this.isSelf)
            {
               PlayerManager.Instance.Self.isUpGradeInGame = true;
            }
         }
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function set isReady(value:Boolean) : void
      {
         this._isReady = value;
      }
      
      override public function updateBlood(value:int, type:int, addVlaue:int = 0) : void
      {
         super.updateBlood(value,type,addVlaue);
         if(this._movie == null)
         {
            return;
         }
         if(blood <= maxBlood * 0.3)
         {
            this._movie.State = LACK_HP;
         }
         else
         {
            this._movie.State = FULL_HP;
         }
         this._movie.isLackHp = type != 0 && addVlaue >= maxBlood * 0.1;
      }
      
      public function get turnTime() : int
      {
         return this._turnTime;
      }
      
      public function set turnTime(val:int) : void
      {
         this._turnTime = val;
      }
      
      public function get reverse() : int
      {
         return this._reverse;
      }
      
      public function set reverse(val:int) : void
      {
         this._reverse = val;
         dispatchEvent(new LivingEvent(LivingEvent.REVERSE_CHANGED,0,0,this._reverse));
      }
      
      public function get isAutoGuide() : Boolean
      {
         if(this._isAutoGuide == true)
         {
            this._isAutoGuide = false;
            return true;
         }
         return this._isAutoGuide;
      }
      
      public function set isAutoGuide(value:Boolean) : void
      {
         if(this._isAutoGuide == value)
         {
            return;
         }
         this._isAutoGuide = value;
      }
      
      public function get currentPet() : Pet
      {
         return this._pet;
      }
      
      public function set currentPet(val:Pet) : void
      {
         this._pet = val;
      }
      
      public function get currentSnapPet() : Pet
      {
         return this._snapPet;
      }
      
      public function set currentSnapPet(val:Pet) : void
      {
         this._snapPet = val;
      }
      
      private function onUsePetSkill(event:LivingEvent) : void
      {
         dispatchEvent(new LivingEvent(event.type,event.value,0,event.paras[0]));
      }
      
      public function usePetSkill(skillID:int, isUsed:Boolean) : void
      {
         var skill:PetSkillTemplateInfo = PetSkillManager.getSkillByID(skillID);
         if(Boolean(skill) && isUsed)
         {
            this.currentPet.MP -= skill.CostMP;
            this.currentPet.useSkill(skillID,isUsed);
         }
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,skillID,0,isUsed));
      }
      
      public function useHorseSkill(skillID:int, isUsed:Boolean, restCount:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.HORSE_SKILL_USE,0,0,skillID,isUsed,restCount));
      }
      
      public function petBeat(act:String, pt:Point, targets:Array) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PET_BEAT,0,0,act,pt,targets));
      }
   }
}

