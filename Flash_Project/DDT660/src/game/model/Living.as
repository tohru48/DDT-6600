package game.model
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.FightContainerBuff;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingCommandEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BuffManager;
   import ddt.manager.LogManager;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.GameManager;
   import game.actions.ActionManager;
   import game.actions.BaseAction;
   import game.interfaces.ICommandedAble;
   import game.objects.SimpleBox;
   import game.view.effects.BaseMirariEffectIcon;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   
   [Event(name="say",type="ddt.events.LivingEvent")]
   [Event(name="jump",type="ddt.events.LivingEvent")]
   [Event(name="fall",type="ddt.events.LivingEvent")]
   [Event(name="moveTo",type="ddt.events.LivingEvent")]
   [Event(name="transmit",type="ddt.events.LivingEvent")]
   [Event(name="beat",type="ddt.events.LivingEvent")]
   [Event(name="shoot",type="ddt.events.LivingEvent")]
   [Event(name="beginNewTurn",type="ddt.events.LivingEvent")]
   [Event(name="bloodChanged",type="ddt.events.LivingEvent")]
   [Event(name="angleChanged",type="ddt.events.LivingEvent")]
   [Event(name="die",type="ddt.events.LivingEvent")]
   [Event(name="noholeChanged",type="ddt.events.LivingEvent")]
   [Event(name="hiddenChanged",type="ddt.events.LivingEvent")]
   [Event(name="forzenChanged",type="ddt.events.LivingEvent")]
   [Event(name="dirChanged",type="ddt.events.LivingEvent")]
   [Event(name="posChanged",type="ddt.events.LivingEvent")]
   public class Living extends EventDispatcher implements ICommandedAble
   {
      
      public static const CRY_ACTION:String = "cry";
      
      public static const STAND_ACTION:String = "stand";
      
      public static const DIE_ACTION:String = "die";
      
      public static const SHOOT_ACTION:String = "beat2";
      
      public static const BORN_ACTION:String = "born";
      
      public static const RENEW:String = "renew";
      
      public static const ANGRY_ACTION:String = "angry";
      
      public static const WALK_ACTION:String = "walk";
      
      public static const DEFENCE_ACTION:String = "shield";
      
      public static const SUICIDE:int = 6;
      
      public static const WOUND:int = 3;
      
      public static const FLASH_BACK:int = 7;
      
      public var character:ShowCharacter;
      
      public var typeLiving:int;
      
      private var _state:int = 0;
      
      private var _onChange:Boolean;
      
      private var _mirariEffects:DictionaryData;
      
      private var _localBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
      
      private var _turnBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
      
      private var _petBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
      
      public var outTurnBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
      
      private var _noPicPetBuff:DictionaryData = new DictionaryData();
      
      public var maxEnergy:int = 240;
      
      public var isExist:Boolean = true;
      
      public var isBottom:Boolean;
      
      public var isLocked:Boolean;
      
      private var _fightPower:Number;
      
      private var _currentSelectId:int;
      
      public var state:Boolean;
      
      private var _damageNum:int;
      
      public var wishFreeTime:int = 3;
      
      private var _isLockFly:Boolean = false;
      
      private var _isLockAngle:Boolean;
      
      private var _payBuff:FightContainerBuff;
      
      private var _consortiaBuff:FightContainerBuff;
      
      private var _cardBuff:FightContainerBuff;
      
      private var _name:String = "";
      
      private var _livingID:int;
      
      private var _team:int;
      
      private var _fallingType:int = 0;
      
      protected var _pos:Point = new Point(0,0);
      
      protected var _isShowBlood:Boolean = true;
      
      protected var _isShowSmallMapPoint:Boolean = true;
      
      private var _direction:int = 1;
      
      private var _maxBlood:int;
      
      private var _blood:int;
      
      private var _isFrozen:Boolean;
      
      private var _isGemGlow:Boolean;
      
      private var _gemDefense:Boolean;
      
      private var _isHidden:Boolean;
      
      private var _isNoNole:Boolean;
      
      protected var _lockState:Boolean;
      
      protected var _lockType:int = 1;
      
      protected var _isLiving:Boolean;
      
      private var _playerAngle:Number = 0;
      
      private var _actionMovieName:String;
      
      private var _isMoving:Boolean;
      
      public var isFalling:Boolean;
      
      private var _actionManager:ActionManager;
      
      private var _actionMovie:Bitmap;
      
      private var _thumbnail:BitmapData;
      
      private var _defaultAction:String = "";
      
      private var _cmdList:Dictionary;
      
      public var outProperty:Dictionary;
      
      private var _shootInterval:int = Player.SHOOT_INTERVAL;
      
      protected var _psychic:int = 0;
      
      protected var _energy:Number = 1;
      
      private var _forbidMoving:Boolean = false;
      
      private var _currentAction:String;
      
      public var route:Vector.<Point>;
      
      public function Living(id:int, team:int, maxBlood:int)
      {
         super();
         this._livingID = id;
         this._team = team;
         this._maxBlood = maxBlood;
         this._actionManager = new ActionManager();
         this._mirariEffects = new DictionaryData();
         this.reset();
      }
      
      public function get MirariEffects() : DictionaryData
      {
         return this._mirariEffects;
      }
      
      public function get fightPower() : Number
      {
         return this._fightPower;
      }
      
      public function set fightPower(value:Number) : void
      {
         this._fightPower = value;
         dispatchEvent(new LivingEvent(LivingEvent.FIGHTPOWER_CHANGE));
      }
      
      public function get currentSelectId() : int
      {
         return this._currentSelectId;
      }
      
      public function set currentSelectId(value:int) : void
      {
         this._currentSelectId = value;
         dispatchEvent(new LivingEvent(LivingEvent.WISHSELECT_CHANGE));
      }
      
      public function get isBoss() : Boolean
      {
         return this.typeLiving == 4 || this.typeLiving == 5;
      }
      
      public function reset() : void
      {
         this._blood = this._maxBlood;
         this._isLiving = true;
         this._isFrozen = false;
         this._gemDefense = false;
         this._isHidden = false;
         this._isNoNole = false;
         this.isLockAngle = false;
         this._localBuffs = new Vector.<FightBuffInfo>();
         this._turnBuffs = new Vector.<FightBuffInfo>();
         this._petBuffs = new Vector.<FightBuffInfo>();
         this.outTurnBuffs = new Vector.<FightBuffInfo>();
         ObjectUtils.disposeObject(this._payBuff);
         this._payBuff = null;
         ObjectUtils.disposeObject(this._consortiaBuff);
         this._consortiaBuff = null;
         ObjectUtils.disposeObject(this._cardBuff);
         this._cardBuff = null;
      }
      
      public function clearEffectIcon() : void
      {
         this._mirariEffects.clear();
      }
      
      public function set isLockFly(val:Boolean) : void
      {
         this._isLockFly = val;
         dispatchEvent(new LivingEvent(LivingEvent.LOCKFLY_CHANGED,0,0,this._isLockFly));
      }
      
      public function get isLockFly() : Boolean
      {
         return this._isLockFly;
      }
      
      public function get isLockAngle() : Boolean
      {
         return this._isLockAngle;
      }
      
      public function set isLockAngle(val:Boolean) : void
      {
         if(this._isLockAngle == val)
         {
            return;
         }
         var oldValue:int = 0;
         var newValue:int = 0;
         if(this._isLockAngle)
         {
            oldValue = 1;
         }
         if(val)
         {
            newValue = 1;
         }
         this._isLockAngle = val;
         dispatchEvent(new LivingEvent(LivingEvent.LOCKANGLE_CHANGE,newValue,oldValue));
      }
      
      public function hasEffect(effecicon:BaseMirariEffectIcon) : Boolean
      {
         return this._mirariEffects[String(effecicon.mirariType)] != null;
      }
      
      public function get localBuffs() : Vector.<FightBuffInfo>
      {
         return this._localBuffs;
      }
      
      public function get turnBuffs() : Vector.<FightBuffInfo>
      {
         return this._turnBuffs;
      }
      
      public function set turnBuffs(buffs:Vector.<FightBuffInfo>) : void
      {
         this._turnBuffs = buffs;
      }
      
      public function get petBuffs() : Vector.<FightBuffInfo>
      {
         return this._petBuffs;
      }
      
      private function addPayBuff(buff:FightBuffInfo) : void
      {
         if(this._payBuff == null)
         {
            this._payBuff = new FightContainerBuff(-1);
            this._localBuffs.unshift(this._payBuff);
         }
         this._payBuff.addFightBuff(buff);
      }
      
      private function addConsortiaBuff(buff:FightBuffInfo) : void
      {
         if(this._consortiaBuff == null)
         {
            this._consortiaBuff = new FightContainerBuff(-1,BuffType.CONSORTIA);
            this._localBuffs.unshift(this._consortiaBuff);
         }
         this._consortiaBuff.addFightBuff(buff);
      }
      
      private function addCardBuff(buff:FightBuffInfo) : void
      {
         if(this._cardBuff == null)
         {
            this._cardBuff = new FightContainerBuff(-1,BuffType.CARD_BUFF);
            this._localBuffs.unshift(this._cardBuff);
         }
         this._cardBuff.addFightBuff(buff);
      }
      
      public function addBuff(buff:FightBuffInfo) : void
      {
         buff.isSelf = this.isSelf;
         if(BuffType.isPayBuff(buff))
         {
            this.addPayBuff(buff);
            return;
         }
         if(BuffType.isConsortiaBuff(buff))
         {
            this.addConsortiaBuff(buff);
            return;
         }
         if(BuffType.isCardBuff(buff))
         {
            this.addCardBuff(buff);
            return;
         }
         if(buff.type == BuffType.Local)
         {
            this._localBuffs.push(buff);
         }
         else
         {
            if(this.hasBuff(buff,this._turnBuffs))
            {
               return;
            }
            this._turnBuffs.push(buff);
         }
         buff.execute(this);
         dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,buff.type));
      }
      
      public function addPetBuff(buff:FightBuffInfo) : void
      {
         var hasBuff:Boolean = false;
         var b:FightBuffInfo = null;
         if(buff.buffPic != "-1")
         {
            hasBuff = false;
            for each(b in this._petBuffs)
            {
               if(b.id == buff.id)
               {
                  ++b.Count;
                  hasBuff = true;
                  break;
               }
            }
            if(!hasBuff)
            {
               this._petBuffs.push(buff);
            }
         }
         else
         {
            this._noPicPetBuff.add(buff.id,true);
         }
         buff.execute(this);
         dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,buff.type));
      }
      
      public function removePetBuff(buff:FightBuffInfo) : void
      {
         var len:int = int(this._petBuffs.length);
         var buffid:int = buff.id;
         for(var i:int = 0; i < len; i++)
         {
            if(this._petBuffs[i].id == buffid)
            {
               this._petBuffs[i].unExecute(this);
               this._petBuffs.splice(i,1);
               dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,buff.type));
               break;
            }
         }
         if(buff.buffPic == "-1" && Boolean(this._noPicPetBuff[buff.id]))
         {
            this._noPicPetBuff.remove(buff.id);
            buff.unExecute(this);
         }
      }
      
      private function hasBuff(buff:FightBuffInfo, list:Vector.<FightBuffInfo>) : Boolean
      {
         var b:FightBuffInfo = null;
         for each(b in list)
         {
            if(b.id == buff.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function removeBuff(buffid:int) : void
      {
         var buffs:Vector.<FightBuffInfo> = null;
         var buffType:int = 0;
         if(BuffType.isLocalBuffByID(buffid))
         {
            buffs = this._localBuffs;
            buffType = BuffType.Local;
         }
         else
         {
            buffs = this._turnBuffs;
            buffType = BuffType.Turn;
         }
         var len:int = int(buffs.length);
         for(var i:int = 0; i < len; i++)
         {
            if(buffs[i].id == buffid)
            {
               buffs[i].unExecute(this);
               buffs.splice(i,1);
               if(buffType == BuffType.Local)
               {
                  this._localBuffs = this._localBuffs.sort(this.buffCompare);
               }
               else
               {
                  this._turnBuffs = this._turnBuffs.sort(this.buffCompare);
               }
               dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,buffType));
               break;
            }
         }
      }
      
      protected function buffCompare(a:FightBuffInfo, b:FightBuffInfo) : Number
      {
         if(a.priority == b.priority)
         {
            return 0;
         }
         if(a.priority < b.priority)
         {
            return 1;
         }
         return -1;
      }
      
      public function handleMirariEffect(effecicon:BaseMirariEffectIcon) : void
      {
         if(effecicon.single)
         {
            if(!this.hasEffect(effecicon))
            {
               this._mirariEffects.add(effecicon.mirariType,effecicon);
            }
         }
         else
         {
            this._mirariEffects.add(effecicon.mirariType,effecicon);
         }
         effecicon.excuteEffect(this);
      }
      
      public function removeMirariEffect(effecicon:BaseMirariEffectIcon) : void
      {
         effecicon.dispose();
         this._mirariEffects.remove(effecicon.mirariType);
         effecicon.unExcuteEffect(this);
      }
      
      public function dispose() : void
      {
         this.isExist = false;
         if(Boolean(this._actionMovie))
         {
            if(Boolean(this._actionMovie.parent))
            {
               this._actionMovie.parent.removeChild(this._actionMovie);
            }
            this._actionMovie.bitmapData.dispose();
         }
         this._actionMovie = null;
         if(Boolean(this._thumbnail))
         {
            this._thumbnail.dispose();
         }
         this._thumbnail = null;
         this.character = null;
         if(Boolean(this._mirariEffects))
         {
            this._mirariEffects.clear();
         }
         this._mirariEffects = null;
         if(Boolean(this._actionManager))
         {
            this._actionManager.clear();
         }
         this._actionManager = null;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get LivingID() : int
      {
         return this._livingID;
      }
      
      public function get team() : int
      {
         return this._team;
      }
      
      public function set team(value:int) : void
      {
         this._team = value;
      }
      
      public function set fallingType(i:int) : void
      {
         this._fallingType = 0;
      }
      
      public function get fallingType() : int
      {
         return this._fallingType;
      }
      
      public function get onChange() : Boolean
      {
         return this._onChange;
      }
      
      public function set onChange(value:Boolean) : void
      {
         this._onChange = value;
      }
      
      public function get pos() : Point
      {
         return this._pos;
      }
      
      public function set pos(value:Point) : void
      {
         if(!value)
         {
            return;
         }
         if(this._pos.equals(value) == false)
         {
            this._pos = value;
            dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
         }
      }
      
      public function get isShowBlood() : Boolean
      {
         return this._isShowBlood;
      }
      
      public function set isShowBlood(value:Boolean) : void
      {
         this._isShowBlood = value;
      }
      
      public function get isShowSmallMapPoint() : Boolean
      {
         return this._isShowSmallMapPoint;
      }
      
      public function set isShowSmallMapPoint(value:Boolean) : void
      {
         this._isShowSmallMapPoint = value;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(value:int) : void
      {
         if(this._direction == value)
         {
            return;
         }
         this._direction = value;
         this.sendCommand("changeDir");
         dispatchEvent(new LivingEvent(LivingEvent.DIR_CHANGED));
      }
      
      public function get maxBlood() : int
      {
         return this._maxBlood;
      }
      
      public function set maxBlood(value:int) : void
      {
         this._maxBlood = value;
         dispatchEvent(new LivingEvent(LivingEvent.MAX_HP_CHANGED));
      }
      
      public function get blood() : int
      {
         return this._blood;
      }
      
      public function set blood(value:int) : void
      {
         this._blood = value > this.maxBlood ? this.maxBlood : value;
      }
      
      public function initBlood(value:int) : void
      {
         this.blood = value;
         dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,0,5));
      }
      
      public function get isFrozen() : Boolean
      {
         return this._isFrozen;
      }
      
      public function set isFrozen(value:Boolean) : void
      {
         if(this._isFrozen == value)
         {
            return;
         }
         this._isFrozen = value;
         dispatchEvent(new LivingEvent(LivingEvent.FORZEN_CHANGED));
      }
      
      public function get isGemGlow() : Boolean
      {
         return this._isGemGlow;
      }
      
      public function set isGemGlow(i:Boolean) : void
      {
         if(this._isGemGlow != i)
         {
            this._isGemGlow = i;
            dispatchEvent(new LivingEvent(LivingEvent.GEM_GLOW_CHANGED));
         }
      }
      
      public function get gemDefense() : Boolean
      {
         return this._gemDefense;
      }
      
      public function set gemDefense(value:Boolean) : void
      {
         if(this._gemDefense == value)
         {
            return;
         }
         this._gemDefense = value;
         dispatchEvent(new LivingEvent(LivingEvent.GEM_DEFENSE_CHANGED));
      }
      
      public function get isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function set isHidden(value:Boolean) : void
      {
         if(value == this._isHidden)
         {
            return;
         }
         this._isHidden = value;
         dispatchEvent(new LivingEvent(LivingEvent.HIDDEN_CHANGED));
      }
      
      public function get isNoNole() : Boolean
      {
         return this._isNoNole;
      }
      
      public function set isNoNole(val:Boolean) : void
      {
         if(this._isNoNole != val)
         {
            this._isNoNole = val;
            if(this._isNoNole)
            {
               this.addBuff(BuffManager.creatBuff(BuffType.NoHole));
            }
            else
            {
               this.removeBuff(BuffType.NoHole);
            }
         }
      }
      
      public function set LockState(val:Boolean) : void
      {
         if(this._lockState != val)
         {
            this._lockState = val;
            if(this._lockState)
            {
               if(this.LockType == 1 || this.LockType == 2 || this.LockType == 3)
               {
                  this.addBuff(BuffManager.creatBuff(BuffType.LockState));
               }
            }
            else
            {
               this.removeBuff(BuffType.LockState);
            }
         }
      }
      
      public function get LockState() : Boolean
      {
         return this._lockState;
      }
      
      public function set LockType(value:int) : void
      {
         this._lockType = value;
      }
      
      public function get LockType() : int
      {
         return this._lockType;
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      public function die(withAction:Boolean = true) : void
      {
         if(this._isLiving)
         {
            this._isLiving = false;
            dispatchEvent(new LivingEvent(LivingEvent.DIE,0,0,withAction));
            this._turnBuffs = new Vector.<FightBuffInfo>();
            dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,BuffType.Turn));
            while(GameManager.Instance.dropGoodslist.length > 0)
            {
               GameManager.Instance.dropGoodslist.pop().start();
            }
         }
      }
      
      public function revive() : void
      {
         this._isLiving = true;
         this._isFrozen = false;
         this._gemDefense = false;
         this._isHidden = false;
         this._isNoNole = false;
         this.isLockAngle = false;
      }
      
      public function get playerAngle() : Number
      {
         return this._playerAngle;
      }
      
      public function set playerAngle(value:Number) : void
      {
         this._playerAngle = value;
         dispatchEvent(new LivingEvent(LivingEvent.ANGLE_CHANGED));
      }
      
      public function get actionMovieName() : String
      {
         return this._actionMovieName;
      }
      
      public function set actionMovieName(value:String) : void
      {
         this._actionMovieName = value;
      }
      
      public function get isMoving() : Boolean
      {
         return this._isMoving;
      }
      
      public function set isMoving(value:Boolean) : void
      {
         this._isMoving = value;
      }
      
      public function updateBlood(value:int, type:int, addVlaue:int = 0) : void
      {
         var oldBlood:int = 0;
         var old:int = 0;
         LogManager.getInstance().sendLog(this.actionMovieName);
         if(!this.isLiving)
         {
            return;
         }
         if(type == WOUND)
         {
            this._blood = value;
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,this._blood,type,addVlaue));
         }
         else if(type == FLASH_BACK)
         {
            oldBlood = this._blood;
            this._blood -= addVlaue;
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,this._blood,oldBlood,type,addVlaue));
         }
         else if(this._blood != value || GameManager.Instance.Current.gameMode == 17)
         {
            old = this._blood;
            this.blood = value;
            if(type != SUICIDE && this._isLiving)
            {
               dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,old,type,addVlaue));
            }
         }
         else if(type == 0 && value >= this._blood)
         {
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,this._blood,type,addVlaue));
         }
         if(this._blood <= 0)
         {
            this._blood = 0;
            this.die(type != SUICIDE);
         }
      }
      
      public function get actionCount() : int
      {
         if(Boolean(this._actionManager))
         {
            return this._actionManager.actionCount;
         }
         return 0;
      }
      
      public function traceCurrentAction() : void
      {
         this._actionManager.traceAllRemainAction();
      }
      
      public function act(action:BaseAction) : void
      {
         this._actionManager.act(action);
      }
      
      public function update() : void
      {
         if(this._actionManager != null)
         {
            this._actionManager.execute();
         }
      }
      
      public function actionManagerClear() : void
      {
         this._actionManager.clear();
      }
      
      public function excuteAtOnce() : void
      {
         this._actionManager.executeAtOnce();
         this._actionManager.clear();
      }
      
      public function set actionMovieBitmap(value:Bitmap) : void
      {
         this._actionMovie = value;
      }
      
      public function get actionMovieBitmap() : Bitmap
      {
         return this._actionMovie;
      }
      
      public function isPlayer() : Boolean
      {
         return false;
      }
      
      public function get isSelf() : Boolean
      {
         return false;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return null;
      }
      
      public function startMoving() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.START_MOVING));
      }
      
      public function beginNewTurn() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEGIN_NEW_TURN));
      }
      
      public function shoot(list:Array, event:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOOT,0,0,list,event));
      }
      
      public function beat(arg:Array) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEAT,0,0,arg));
      }
      
      public function beatenBy(attacker:Living) : void
      {
         attacker.addEventListener(LivingEvent.BEAT,this.__beatenBy);
      }
      
      private function __beatenBy(evt:LivingEvent) : void
      {
         var target:Living = evt.paras[1];
         var damage:int = int(evt.paras[2]);
         var targetBlood:int = evt.value;
         var targetAttackEffect:int = int(evt.paras[3]);
         if(this.isLiving)
         {
            this.isHidden = false;
            this.showAttackEffect(targetAttackEffect);
            this.updateBlood(targetBlood,3,damage);
         }
      }
      
      public function transmit(pos:Point) : void
      {
         if(this._pos.equals(pos) == false)
         {
            this._pos = pos;
            dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
         }
      }
      
      public function showAttackEffect(effectID:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOW_ATTACK_EFFECT,0,0,effectID));
      }
      
      public function moveTo(type:Number, target:Point, dir:Number, isLiving:Boolean, action:String = "", speed:int = 3, endAction:String = "") : void
      {
         if(this.isPlayer() || this._isLiving)
         {
            if(target.x > this._pos.x)
            {
               this.direction = 1;
            }
            else
            {
               this.direction = -1;
            }
            dispatchEvent(new LivingEvent(LivingEvent.MOVE_TO,0,0,type,target,dir,isLiving,action,speed,endAction));
         }
      }
      
      public function changePos(target:Point, action:String = "") : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.CHANGE_POS,0,0,target));
      }
      
      public function fallTo(pos:Point, speed:int, action:String = "", fallType:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.FALL,0,0,pos,speed,action,fallType));
      }
      
      public function jumpTo(pos:Point, speed:int, action:String = "", type:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.JUMP,0,0,pos,speed,action,type));
      }
      
      public function set State(state:int) : void
      {
         if(this._state == state)
         {
            return;
         }
         this._state = state;
         dispatchEvent(new LivingEvent(LivingEvent.CHANGE_STATE));
      }
      
      public function get State() : int
      {
         return this._state;
      }
      
      public function say(msg:String, type:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SAY,0,0,msg,type));
      }
      
      public function playMovie(type:String, fun:Function = null, args:Array = null) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAY_MOVIE,0,0,type,fun,args));
      }
      
      public function turnRotation(rota:int, speed:int, endPlay:String) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.TURN_ROTATION,0,0,rota,speed,endPlay));
      }
      
      public function set defaultAction(action:String) : void
      {
         this._defaultAction = action;
         dispatchEvent(new LivingEvent(LivingEvent.DEFAULT_ACTION_CHANGED));
      }
      
      public function get defaultAction() : String
      {
         return this._defaultAction;
      }
      
      public function doDefaultAction() : void
      {
         this.playMovie(this._defaultAction);
      }
      
      public function pick(box:SimpleBox) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BOX_PICK,0,0,box));
      }
      
      private function cmdX(value:int) : void
      {
      }
      
      public function get commandList() : Dictionary
      {
         if(!this._cmdList)
         {
            this.initCommand();
         }
         return this._cmdList;
      }
      
      public function initCommand() : void
      {
         this._cmdList = new Dictionary();
         this._cmdList["x"] = this.cmdX;
      }
      
      public function command(command:String, value:*) : Boolean
      {
         if(Boolean(this.commandList[command]))
         {
            this.commandList[command](value);
         }
         return true;
      }
      
      public function sendCommand(type:String, data:Object = null) : void
      {
         dispatchEvent(new LivingCommandEvent("someCommand"));
      }
      
      public function setProperty(property:String, value:String) : void
      {
         var vo:StringObject = new StringObject(value);
         var _loc4_:* = property;
         switch(0)
         {
         }
         try
         {
            if(vo.isBoolean)
            {
               this[property] = vo.getBoolean();
               return;
            }
            if(vo.isInt)
            {
               this[property] = vo.getInt();
               return;
            }
            this[property] = vo;
         }
         catch(e:Error)
         {
         }
      }
      
      public function bomd() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BOMBED));
      }
      
      public function showEffect(name:String) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAYSKILLMOVIE,0,0,name));
      }
      
      public function showBuffEffect(name:String, id:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAY_CONTINUOUS_EFFECT,0,0,name,id));
      }
      
      public function removeBuffEffect(id:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.REMOVE_CONTINUOUS_EFFECT,0,0,id));
      }
      
      public function removeSkillMovie(id:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.REMOVESKILLMOVIE,0,0,id));
      }
      
      public function applySkill(skill:int, ... args) : void
      {
         var evt:LivingEvent = null;
         if(args == null || args.length == 0)
         {
            evt = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,skill);
         }
         else if(args.length == 1)
         {
            evt = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,skill,args[0]);
         }
         else if(args.length == 2)
         {
            evt = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,skill,args[0],args[1]);
         }
         else if(args.length == 3)
         {
            evt = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,skill,args[0],args[1],args[2]);
         }
         else if(args.length == 4)
         {
            evt = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,skill,args[0],args[1],args[2],args[3]);
         }
         dispatchEvent(evt);
      }
      
      public function get shootInterval() : int
      {
         return this._shootInterval;
      }
      
      public function set shootInterval(value:int) : void
      {
         this._shootInterval = value;
      }
      
      public function get maxPsychic() : int
      {
         return Player.MaxPsychic;
      }
      
      public function get psychic() : int
      {
         return this._psychic >= 0 ? this._psychic : 0;
      }
      
      public function set psychic(val:int) : void
      {
         if(this._psychic != val && val <= this.maxPsychic)
         {
            this._psychic = val;
            dispatchEvent(new LivingEvent(LivingEvent.PSYCHIC_CHANGED));
         }
      }
      
      public function get energy() : Number
      {
         return this._energy;
      }
      
      public function set energy(value:Number) : void
      {
         if(value != this._energy && value <= this.maxEnergy)
         {
            this._energy = value >= 0 ? value : 0;
            dispatchEvent(new LivingEvent(LivingEvent.ENERGY_CHANGED));
         }
      }
      
      public function get forbidMoving() : Boolean
      {
         return this._forbidMoving;
      }
      
      public function set forbidMoving(value:Boolean) : void
      {
         this._forbidMoving = value;
      }
      
      public function get thumbnail() : BitmapData
      {
         return this._thumbnail;
      }
      
      public function set thumbnail(value:BitmapData) : void
      {
         if(this._thumbnail != null)
         {
            this._thumbnail.dispose();
         }
         this._thumbnail = value;
      }
      
      public function set currentAction(value:String) : void
      {
         this._currentAction = value;
      }
      
      public function get currentAction() : String
      {
         return this._currentAction;
      }
      
      public function get damageNum() : int
      {
         return this._damageNum;
      }
      
      public function set damageNum(value:int) : void
      {
         this._damageNum = value;
      }
   }
}

