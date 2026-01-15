package game.model
{
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.GameManager;
   import game.objects.SimpleBox;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.transnational.TransnationalFightManager;
   import trainer.data.Step;
   
   [Event(name="showMark",type="ddt.events.LivingEvent")]
   [Event(name="sendShootAction",type="ddt.events.LivingEvent")]
   [Event(name="skip",type="ddt.events.LivingEvent")]
   [Event(name="forceChanged",type="ddt.events.LivingEvent")]
   [Event(name="gunangleChanged",type="ddt.events.LivingEvent")]
   [Event(name="energyChanged",type="ddt.events.LivingEvent")]
   public class LocalPlayer extends Player
   {
      
      public static const SET_ENABLE:String = "setEnable";
      
      public var _numObject:Object;
      
      private var _isUsedItem:Boolean = false;
      
      private var _isUsedPetSkillWithNoItem:Boolean = false;
      
      public var shootType:int = 0;
      
      public var shootCount:int = 0;
      
      public var shootTime:int;
      
      private var _gunAngle:Number = 0;
      
      private var _force:Number = 0;
      
      private var _iscalcForce:Boolean = false;
      
      private var _selfDieTimer:Timer;
      
      public var isLast:Boolean = true;
      
      private var _selfDieTimeDelayPassed:Boolean = false;
      
      private var _flyCoolDown:int = 0;
      
      private var _flyEnabled:Boolean = true;
      
      private var _deputyWeaponEnabled:Boolean = true;
      
      private var _snapdeputyWeaponCount:int;
      
      private var _deputyWeaponCount:int;
      
      private var _blockDeputyWeapon:Boolean = false;
      
      private var _deputyWeaponCoolDown:int;
      
      public var twoKillEnabled:Boolean = true;
      
      public var soulPropCount:int = 0;
      
      private var _threeKillEnabled:Boolean = true;
      
      private var _spellKillEnabled:Boolean = true;
      
      private var _passBallEnabled:Boolean;
      
      private var _propEnabled:Boolean = true;
      
      private var _petSkillEnabled:Boolean = true;
      
      private var _soulPropEnabled:Boolean = true;
      
      private var _customPropEnabled:Boolean = true;
      
      private var _lockRightProp:Boolean = false;
      
      private var _rightPropEnabled:Boolean = true;
      
      private var _lockDeputyWeapon:Boolean = false;
      
      private var _lockFly:Boolean = false;
      
      private var _lockSpellKill:Boolean = false;
      
      private var _lockProp:Boolean;
      
      public var NewHandEnemyBlood:int;
      
      public var NewHandSelfBlood:int;
      
      public var NewHandHurtSelfCounter:int;
      
      public var NewHandHurtEnemyCounter:int;
      
      public var NewHandBeEnemyHurtCounter:int;
      
      public var NewHandBloodCounter:int;
      
      public var NewHandEnemyIsFrozen:Boolean;
      
      public var lastFireBombs:Array;
      
      private var _flyCount:int;
      
      private var _usePassBall:Boolean;
      
      public function LocalPlayer(info:SelfInfo, id:int, team:int, maxBlood:int)
      {
         super(info,id,team,maxBlood);
         if(info.DeputyWeaponID > 0)
         {
            this.deputyWeaponCount = info.DeputyWeapon.StrengthenLevel + 1;
         }
         this._numObject = {};
      }
      
      public function get isUsedPetSkillWithNoItem() : Boolean
      {
         return this._isUsedPetSkillWithNoItem;
      }
      
      public function set isUsedPetSkillWithNoItem(value:Boolean) : void
      {
         this._isUsedPetSkillWithNoItem = value;
      }
      
      public function get isUsedItem() : Boolean
      {
         return this._isUsedItem;
      }
      
      public function set isUsedItem(value:Boolean) : void
      {
         this._isUsedItem = value;
      }
      
      public function get selfInfo() : SelfInfo
      {
         return playerInfo as SelfInfo;
      }
      
      public function showMark(mark:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOW_MARK,0,0,mark - 1));
      }
      
      override public function set pos(value:Point) : void
      {
         if(value.equals(_pos) == false)
         {
            if(isLiving && onChange == true)
            {
               energy -= Math.abs(value.x - _pos.x) * powerRatio;
            }
            super.pos = value;
         }
      }
      
      public function manuallySetGunAngle(value:Number) : Boolean
      {
         var oldGunAngle:int = this.gunAngle;
         this.gunAngle = value;
         return oldGunAngle != this.gunAngle;
      }
      
      public function get gunAngle() : Number
      {
         return this._gunAngle;
      }
      
      public function set gunAngle(value:Number) : void
      {
         if(value == this._gunAngle)
         {
            return;
         }
         if((currentBomb == 3 || currentBomb == 110 || currentBomb == 117 || RoomManager.Instance.current.type == RoomInfo.RESCUE) && (value < 0 || value > 90))
         {
            return;
         }
         if(currentBomb != 3 && currentBomb != 110 && currentBomb != 117 && RoomManager.Instance.current.type != RoomInfo.RESCUE && value < currentWeapInfo.armMinAngle)
         {
            this._gunAngle = currentWeapInfo.armMinAngle;
            return;
         }
         if(currentBomb != 3 && currentBomb != 110 && currentBomb != 117 && RoomManager.Instance.current.type != RoomInfo.RESCUE && value > currentWeapInfo.armMaxAngle)
         {
            this._gunAngle = currentWeapInfo.armMaxAngle;
            return;
         }
         this._gunAngle = value;
         dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
      }
      
      public function calcBombAngle() : Number
      {
         return direction > 0 ? playerAngle - this._gunAngle : playerAngle + this._gunAngle - 180;
      }
      
      public function get force() : Number
      {
         return this._force;
      }
      
      public function set force(value:Number) : void
      {
         this._force = Math.min(value,Player.FORCE_MAX);
         dispatchEvent(new LivingEvent(LivingEvent.FORCE_CHANGED));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this.checkAngle();
         dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
         this.shootType = 0;
         this._isUsedPetSkillWithNoItem = false;
         this._isUsedItem = false;
      }
      
      private function checkAngle() : void
      {
         if(RoomManager.Instance.current.type == RoomInfo.RESCUE)
         {
            return;
         }
         if(this._gunAngle < currentWeapInfo.armMinAngle)
         {
            this.gunAngle = currentWeapInfo.armMinAngle;
            return;
         }
         if(this._gunAngle > currentWeapInfo.armMaxAngle)
         {
            this.gunAngle = currentWeapInfo.armMaxAngle;
            return;
         }
      }
      
      public function skip() : void
      {
         if(isAttacking)
         {
            stopAttacking();
            dispatchEvent(new LivingEvent(LivingEvent.SKIP));
         }
      }
      
      public function set iscalcForce(value:Boolean) : void
      {
         if(this._iscalcForce == value)
         {
            return;
         }
         this._iscalcForce = value;
         dispatchEvent(new LivingEvent(LivingEvent.IS_CALCFORCE_CHANGE));
      }
      
      public function get iscalcForce() : Boolean
      {
         return this._iscalcForce;
      }
      
      public function sendShootAction(force:Number) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SEND_SHOOT_ACTION,0,0,force));
      }
      
      public function canUseProp(currentPlayer:TurnedLiving) : Boolean
      {
         return this == currentPlayer && !LockState || !isLiving && team == currentPlayer.team;
      }
      
      override public function pick(box:SimpleBox) : void
      {
         super.pick(box);
         if(box.isGhost)
         {
            psychic += box.psychic;
         }
         SocketManager.Instance.out.sendGamePick(box.Id);
      }
      
      override protected function setWeaponInfo() : void
      {
         super.setWeaponInfo();
         this.gunAngle = currentWeapInfo.armMinAngle;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.lockDeputyWeapon = this.lockFly = this.lockSpellKill = false;
         this.soulPropEnabled = this.threeKillEnabled = this.flyEnabled = this.deputyWeaponEnabled = this.rightPropEnabled = this.customPropEnabled = this.passBallEnabled = true;
         this._flyCoolDown = this._deputyWeaponCoolDown = 0;
         if(Boolean(currentWeapInfo))
         {
            this.gunAngle = currentWeapInfo.armMinAngle;
         }
         if(playerInfo.DeputyWeaponID > 0 && Boolean(playerInfo.DeputyWeapon))
         {
            if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
            {
               this.snapDeputyWeaponCount = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL + 1;
            }
            else
            {
               this.deputyWeaponCount = playerInfo.DeputyWeapon.StrengthenLevel + 1;
            }
         }
      }
      
      override public function die(widthAction:Boolean = true) : void
      {
         var living:Living = null;
         var team:DictionaryData = GameManager.Instance.Current.findTeam(this.team);
         for each(living in team)
         {
            if(!living.isSelf && living.isLiving)
            {
               this.isLast = false;
               break;
            }
         }
         super.die(widthAction);
         this._selfDieTimer = new Timer(500,1);
         this._selfDieTimer.start();
         this._selfDieTimer.addEventListener(TimerEvent.TIMER,this.__onDieDelayPassed);
         this.rightPropEnabled = this.spellKillEnabled = this.flyEnabled = this.deputyWeaponEnabled = false;
         if(isSelf)
         {
            ChatManager.Instance.view.output.ghostState = widthAction;
         }
      }
      
      private function __onDieDelayPassed(event:TimerEvent) : void
      {
         this.removeSelfDieTimer();
         this._selfDieTimeDelayPassed = true;
      }
      
      private function removeSelfDieTimer() : void
      {
         if(this._selfDieTimer == null)
         {
            return;
         }
         this._selfDieTimer.stop();
         this._selfDieTimer.removeEventListener(TimerEvent.TIMER,this.__onDieDelayPassed);
         this._selfDieTimer = null;
      }
      
      public function get selfDieTimeDelayPassed() : Boolean
      {
         return this._selfDieTimeDelayPassed;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeSelfDieTimer();
      }
      
      override public function set isAttacking(value:Boolean) : void
      {
         if(value)
         {
            --this._flyCoolDown;
            --this._deputyWeaponCoolDown;
         }
         if(this._flyCoolDown <= 0 && energy >= EquipType.FLY_ENERGY && !this._lockFly)
         {
            this.flyEnabled = true;
         }
         if((hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight()) && this._deputyWeaponCoolDown <= 0 && energy >= currentDeputyWeaponInfo.energy && !this._lockDeputyWeapon && _isLiving)
         {
            this.deputyWeaponEnabled = true;
         }
         this.soulPropEnabled = this.propEnabled = this.spellKillEnabled = this.threeKillEnabled = this.passBallEnabled = true;
         super.isAttacking = value;
      }
      
      public function get flyCoolDown() : int
      {
         return this._flyCoolDown;
      }
      
      public function useFly() : String
      {
         if(this.flyEnabled && _isAttacking)
         {
            this.useFlyImp();
         }
         else
         {
            if(!_isAttacking)
            {
               return UsePropErrorCode.NotAttacking;
            }
            if((this._lockFly || _lockState) && _lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
            if(_isLiving && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
            {
               if(this._flyCoolDown > 0)
               {
                  return UsePropErrorCode.FlyNotCoolDown;
               }
               if(_energy < EquipType.FLY_ENERGY)
               {
                  return UsePropErrorCode.EmptyEnergy;
               }
            }
         }
         return UsePropErrorCode.None;
      }
      
      private function useFlyImp() : void
      {
         this._flyCoolDown = EquipType.FLY_CD;
         SocketManager.Instance.out.sendAirPlane();
         var item:InventoryItemInfo = new InventoryItemInfo();
         var temInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10016);
         item.TemplateID = temInfo.TemplateID;
         item.Pic = "2";
         item.Property4 = temInfo.Property4;
         var info:PropInfo = new PropInfo(item);
         this.useItem(info.Template);
         currentBomb = 3;
         this.flyEnabled = false;
         this.rightPropEnabled = false;
         if((hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight()) && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
         this.spellKillEnabled = false;
      }
      
      public function get flyEnabled() : Boolean
      {
         return _isLiving && !this._lockFly && this._flyEnabled && this._flyCoolDown <= 0 && _energy >= EquipType.FLY_ENERGY;
      }
      
      public function set flyEnabled(val:Boolean) : void
      {
         if(this._flyEnabled != val)
         {
            this._flyEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
         }
      }
      
      public function set deputyWeaponEnabled(val:Boolean) : void
      {
         if(this._deputyWeaponEnabled != val)
         {
            this._deputyWeaponEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function get deputyWeaponEnabled() : Boolean
      {
         if(hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight())
         {
            if(RoomManager.Instance.isTransnationalFight())
            {
               return _isLiving && this.snapDeputyWeaponCount > 0 && this._deputyWeaponCoolDown <= 0 && this._deputyWeaponEnabled && _energy >= currentDeputyWeaponInfo.energy;
            }
            return _isLiving && !this._lockDeputyWeapon && !this._blockDeputyWeapon && this._deputyWeaponEnabled && this._deputyWeaponCount > 0 && this._deputyWeaponCoolDown <= 0 && _energy >= currentDeputyWeaponInfo.energy;
         }
         return false;
      }
      
      public function get snapDeputyWeaponCount() : int
      {
         return this._snapdeputyWeaponCount;
      }
      
      public function set snapDeputyWeaponCount(val:int) : void
      {
         if(this._snapdeputyWeaponCount != val)
         {
            this._snapdeputyWeaponCount = val;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function get deputyWeaponCount() : int
      {
         return this._deputyWeaponCount;
      }
      
      public function set deputyWeaponCount(val:int) : void
      {
         if(this._deputyWeaponCount != val)
         {
            this._deputyWeaponCount = val;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function blockDeputyWeapon() : void
      {
         this._blockDeputyWeapon = true;
         this._deputyWeaponCoolDown = 100000;
         this.deputyWeaponEnabled = false;
      }
      
      public function allowDeputyWeapon() : void
      {
         this._blockDeputyWeapon = false;
         this.deputyWeaponEnabled = true;
      }
      
      private function useDeputyWeaponImp() : void
      {
         var dis:DisplayObject = null;
         this._deputyWeaponCoolDown = currentDeputyWeaponInfo.coolDown;
         SocketManager.Instance.out.useDeputyWeapon();
         dis = currentDeputyWeaponInfo.getDeputyWeaponIcon();
         dis.x += 7;
         useItemByIcon(dis);
         energy -= Number(currentDeputyWeaponInfo.energy);
         if((hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight()) && currentDeputyWeaponInfo.ballId > 0)
         {
            currentBomb = currentDeputyWeaponInfo.ballId;
         }
         this.deputyWeaponEnabled = false;
         if(EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.spellKillEnabled = false;
            this.flyEnabled = false;
            this.rightPropEnabled = false;
         }
      }
      
      public function get deputyWeaponCoolDown() : int
      {
         return this._deputyWeaponCoolDown;
      }
      
      public function useDeputyWeapon() : String
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            SoundManager.instance.play("008");
         }
         var deputyEnergy:Number = Number(currentDeputyWeaponInfo.energy);
         if(this.deputyWeaponEnabled && _isAttacking)
         {
            this.useDeputyWeaponImp();
         }
         else if(hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight())
         {
            if(!_isAttacking)
            {
               return UsePropErrorCode.NotAttacking;
            }
            if((this._lockDeputyWeapon || _lockState) && _lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
            if(RoomManager.Instance.isTransnationalFight())
            {
               if(this._snapdeputyWeaponCount <= 0)
               {
                  return UsePropErrorCode.DeputyWeaponEmpty;
               }
               if(this._deputyWeaponCoolDown > 0)
               {
                  return UsePropErrorCode.DeputyWeaponNotCoolDown;
               }
               if(_energy < deputyEnergy)
               {
                  return UsePropErrorCode.EmptyEnergy;
               }
            }
            else
            {
               if(this._deputyWeaponCount <= 0)
               {
                  return UsePropErrorCode.DeputyWeaponEmpty;
               }
               if(this._deputyWeaponCoolDown > 0)
               {
                  return UsePropErrorCode.DeputyWeaponNotCoolDown;
               }
               if(_energy < deputyEnergy)
               {
                  return UsePropErrorCode.EmptyEnergy;
               }
            }
         }
         return UsePropErrorCode.None;
      }
      
      override public function setDeputyWeaponInfo() : void
      {
         super.setDeputyWeaponInfo();
         if(hasDeputyWeapon())
         {
            this.deputyWeaponCount = playerInfo.DeputyWeapon.StrengthenLevel + 1;
         }
      }
      
      override public function setSnapDeputyWeaponInfo() : void
      {
         super.setSnapDeputyWeaponInfo();
         if(RoomManager.Instance.isTransnationalFight())
         {
            this.snapDeputyWeaponCount = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL + 1;
         }
      }
      
      public function useProp(prop:PropInfo, type:int) : String
      {
         if(_isLiving)
         {
            return this.usePropAtLive(prop,type);
         }
         return this.usePropAtSoul(prop,type);
      }
      
      private function updateNums(propInfo:PropInfo) : void
      {
         var num:int = 0;
         if(this._numObject.hasOwnProperty(propInfo.TemplateID))
         {
            num = this._numObject[propInfo.TemplateID] as int;
         }
         num++;
         this._numObject[propInfo.TemplateID] = num;
      }
      
      private function sendProp(type:int, propInfo:PropInfo) : void
      {
         this.useItem(propInfo.Template);
         GameInSocketOut.sendUseProp(type,propInfo.Place,propInfo.Template.TemplateID);
         dispatchEvent(new Event(LocalPlayer.SET_ENABLE));
         this.twoKillEnabled = false;
      }
      
      private function pushUseProp(type:int, propInfo:PropInfo) : Boolean
      {
         var num:int = 0;
         var num1:int = 0;
         var num2:int = 0;
         var num3:int = 0;
         var ref:Boolean = false;
         if(propInfo.TemplateID == EquipType.ADD_TWO_ATTACK || propInfo.TemplateID == EquipType.ADD_ONE_ATTACK)
         {
            num = this._numObject[propInfo.TemplateID] as int;
            if(num == 2)
            {
               this.sendProp(type,propInfo);
               ref = true;
            }
            else if(num > 2)
            {
               ref = true;
            }
         }
         if(propInfo.TemplateID == EquipType.ADD_TWO_ATTACK || propInfo.TemplateID == EquipType.ADD_ONE_ATTACK || propInfo.TemplateID == EquipType.THREEKILL)
         {
            num1 = this._numObject[EquipType.ADD_TWO_ATTACK] as int;
            num2 = this._numObject[EquipType.THREEKILL] as int;
            num3 = this._numObject[EquipType.ADD_ONE_ATTACK] as int;
            if(num1 >= 1 && num2 >= 1)
            {
               this.sendProp(type,propInfo);
               ref = true;
            }
            else if(num2 >= 1 && num3 >= 1)
            {
               this.sendProp(type,propInfo);
               ref = true;
            }
            else if(num1 >= 1 && num3 >= 1)
            {
               this.sendProp(type,propInfo);
               ref = true;
            }
         }
         return ref;
      }
      
      public function clearPropArr() : void
      {
         this._numObject = {};
         this.twoKillEnabled = true;
      }
      
      override public function set dander(value:int) : void
      {
         super.dander = value;
      }
      
      private function usePropAtSoul(prop:PropInfo, type:int) : String
      {
         if(this._soulPropEnabled)
         {
            if(this.soulPropCount >= MaxSoulPropUsedCount)
            {
               return UsePropErrorCode.SoulPropOverFlow;
            }
            if(type == 2)
            {
               this.useItem(prop.Template);
               GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
               ++this.soulPropCount;
            }
            else
            {
               if(psychic < prop.needPsychic)
               {
                  return UsePropErrorCode.EmptyPsychic;
               }
               this.useItem(prop.Template);
               GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
               psychic -= prop.needPsychic;
               ++this.soulPropCount;
            }
         }
         return UsePropErrorCode.None;
      }
      
      private function usePropAtLive(prop:PropInfo, type:int) : String
      {
         if(!_isLiving && type == 1)
         {
            return UsePropErrorCode.NotLiving;
         }
         if(!_isAttacking)
         {
            return UsePropErrorCode.NotAttacking;
         }
         if(_lockState)
         {
            if(_lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
         }
         else
         {
            if(_energy < prop.needEnergy)
            {
               return UsePropErrorCode.EmptyEnergy;
            }
            this.updateNums(prop);
            if(prop.TemplateID == EquipType.ADD_TWO_ATTACK || prop.TemplateID == EquipType.ADD_ONE_ATTACK || prop.TemplateID == EquipType.THREEKILL)
            {
               if(!this.twoKillEnabled)
               {
                  GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
                  return UsePropErrorCode.Done;
               }
               if(this.pushUseProp(type,prop))
               {
                  return UsePropErrorCode.Done;
               }
            }
            if(prop.TemplateID == EquipType.THREEKILL)
            {
               if(this.threeKillEnabled)
               {
                  this.useItem(prop.Template);
                  GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
                  return UsePropErrorCode.Done;
               }
            }
            else
            {
               if(prop.TemplateID != EquipType.PASS_BALL)
               {
                  this.useItem(prop.Template);
                  GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
                  return UsePropErrorCode.Done;
               }
               if(this.passBallEnabled)
               {
                  this.useItem(prop.Template);
                  GameInSocketOut.sendUseProp(type,prop.Place,prop.Template.TemplateID);
                  return UsePropErrorCode.Done;
               }
            }
         }
         return UsePropErrorCode.None;
      }
      
      override public function useItem(info:ItemTemplateInfo) : void
      {
         if(info.TemplateID == EquipType.THREEKILL)
         {
            this.useThreeKillImp();
         }
         if(info.TemplateID == EquipType.PASS_BALL)
         {
            this.passBallEnabled = false;
         }
         super.useItem(info);
      }
      
      public function get threeKillEnabled() : Boolean
      {
         return this._threeKillEnabled && this._propEnabled && this._rightPropEnabled;
      }
      
      public function set threeKillEnabled(val:Boolean) : void
      {
         if(this._threeKillEnabled != val)
         {
            this._threeKillEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.THREEKILL_CHANGED));
         }
      }
      
      private function useThreeKillImp() : void
      {
         this.threeKillEnabled = false;
         this.spellKillEnabled = false;
         if((hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight()) && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
      }
      
      public function useSpellKill() : String
      {
         if(this.spellKillEnabled && _isAttacking)
         {
            this.useSpellKillImp();
            return UsePropErrorCode.Done;
         }
         return UsePropErrorCode.None;
      }
      
      private function useSpellKillImp() : void
      {
         this.spellKillEnabled = this.flyEnabled = this.threeKillEnabled = false;
         if((hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight()) && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
         skill = 0;
         isSpecialSkill = true;
         this.dander = 0;
         GameInSocketOut.sendGameCMDStunt();
      }
      
      public function get spellKillEnabled() : Boolean
      {
         return this._spellKillEnabled && _dander >= Player.TOTAL_DANDER && !this._lockSpellKill && _isLiving;
      }
      
      public function set spellKillEnabled(val:Boolean) : void
      {
         if(this._spellKillEnabled != val)
         {
            this._spellKillEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
         }
      }
      
      public function get passBallEnabled() : Boolean
      {
         return this._passBallEnabled && _isLiving;
      }
      
      public function set passBallEnabled(val:Boolean) : void
      {
         if(this._passBallEnabled != val)
         {
            this._passBallEnabled = val;
         }
      }
      
      public function set propEnabled(val:Boolean) : void
      {
         if(this._propEnabled != val)
         {
            this._propEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function get propEnabled() : Boolean
      {
         return this._propEnabled && !this._lockProp;
      }
      
      public function set petSkillEnabled(val:Boolean) : void
      {
         if(this._petSkillEnabled != val)
         {
            this._petSkillEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function get petSkillEnabled() : Boolean
      {
         return this._petSkillEnabled;
      }
      
      public function set soulPropEnabled(val:Boolean) : void
      {
         if(this._soulPropEnabled != val)
         {
            this._soulPropEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.SOUL_PROP_ENABEL_CHANGED));
         }
      }
      
      public function get soulPropEnabled() : Boolean
      {
         return this._soulPropEnabled && !this._lockProp;
      }
      
      public function get customPropEnabled() : Boolean
      {
         return this._customPropEnabled && this._propEnabled;
      }
      
      public function set customPropEnabled(val:Boolean) : void
      {
         if(this._customPropEnabled != val)
         {
            this._customPropEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.CUSTOMENABLED_CHANGED));
         }
      }
      
      public function set lockRightProp(val:Boolean) : void
      {
         if(this._lockRightProp != val)
         {
            this._lockRightProp = val;
            dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
         }
      }
      
      public function get lockRightProp() : Boolean
      {
         return this._lockRightProp;
      }
      
      public function get rightPropEnabled() : Boolean
      {
         return this._rightPropEnabled && this._propEnabled && _isLiving && !this._lockRightProp;
      }
      
      public function set rightPropEnabled(val:Boolean) : void
      {
         if(this._rightPropEnabled != val)
         {
            this._rightPropEnabled = val;
            dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
         }
      }
      
      public function get lockDeputyWeapon() : Boolean
      {
         return this._lockDeputyWeapon;
      }
      
      public function set lockDeputyWeapon(val:Boolean) : void
      {
         if(this._lockDeputyWeapon != val)
         {
            this._lockDeputyWeapon = val;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function get lockFly() : Boolean
      {
         return this._lockFly;
      }
      
      public function set lockFly(val:Boolean) : void
      {
         if(this._lockFly != val)
         {
            this._lockFly = val;
            dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
         }
      }
      
      public function get lockSpellKill() : Boolean
      {
         return this._lockSpellKill;
      }
      
      public function set lockSpellKill(val:Boolean) : void
      {
         if(this._lockSpellKill != val)
         {
            this._lockSpellKill = val;
            dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
         }
      }
      
      public function set lockProp(val:Boolean) : void
      {
         if(this._lockProp != val)
         {
            this._lockProp = val;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function get lockProp() : Boolean
      {
         return this._lockProp;
      }
      
      public function get shootEnabled() : Boolean
      {
         return _isAttacking && _isLiving;
      }
      
      public function setCenter(px:Number, py:Number, isTween:Boolean) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SETCENTER,0,0,px,py,isTween));
      }
      
      public function get flyCount() : int
      {
         return this._flyCount;
      }
      
      public function set flyCount(value:int) : void
      {
         this._flyCount = value;
         dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
      }
      
      public function get usePassBall() : Boolean
      {
         return this._usePassBall;
      }
      
      public function set usePassBall(value:Boolean) : void
      {
         this._usePassBall = value;
      }
   }
}

