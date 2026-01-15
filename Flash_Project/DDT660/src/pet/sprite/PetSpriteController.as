package pet.sprite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetInfo;
   
   public class PetSpriteController extends EventDispatcher
   {
      
      private static var _instance:PetSpriteController;
      
      private static const DEFAULT_SHOW_TIME:int = 5000;
      
      private static const CHECK_TIME:int = 30 * 1000;
      
      public static const SHOWPET_TIP:String = "showPetTip";
      
      private static const ACTION:Array = ["walkA","walkB","standA","bsetC"];
      
      private var _petSprite:PetSprite;
      
      private var _petModel:PetSpriteModel;
      
      private var _isShown:Boolean = false;
      
      private var _loopTimer:Timer;
      
      private var _loopIntervalTime:int = 5000;
      
      private var _queue:Vector.<PetMessage> = new Vector.<PetMessage>();
      
      private var _checkTimer:Timer;
      
      private var _hasBeenSetup:Boolean = false;
      
      public function PetSpriteController(singleton:SingletonEnforcer)
      {
         super();
         this._petModel = new PetSpriteModel();
      }
      
      public static function get Instance() : PetSpriteController
      {
         if(!_instance)
         {
            _instance = new PetSpriteController(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this._hasBeenSetup)
         {
            return;
         }
         if(!this.canInitPetSprite())
         {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGradeChanged);
            return;
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGradeChanged);
         this._hasBeenSetup = true;
         this.init();
         this.initEvent();
         this._checkTimer = new Timer(CHECK_TIME);
         this._checkTimer.addEventListener(TimerEvent.TIMER,this.__onCheckTimer);
         this._checkTimer.start();
         ChatManager.Instance.output.openPetSprite(PlayerManager.Instance.Self.pets.length > 0);
         this._petModel.petSwitcher = true;
         this.enableChatViewPetSwitcher(PlayerManager.Instance.Self.currentPet != null);
         this._loopTimer = new Timer(this._loopIntervalTime);
         this._loopTimer.addEventListener(TimerEvent.TIMER,this.__messageLoop);
         if(PlayerManager.Instance.Self.pets.length > 0 && !PlayerManager.Instance.Self.currentPet)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.pets[0].Place);
         }
         else if(PlayerManager.Instance.Self.pets.length > 0 && Boolean(PlayerManager.Instance.Self.currentPet))
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.currentPet.Place);
         }
      }
      
      protected function __onGradeChanged(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]))
         {
            if(this.canInitPetSprite())
            {
               this.setup();
            }
         }
      }
      
      protected function __onCheckTimer(event:TimerEvent) : void
      {
         this.checkMessageQueue();
         this.checkHunger();
         this.checkFarmCrop();
      }
      
      public function checkFarmCropRipe() : Boolean
      {
         return this.checkFarmCrop();
      }
      
      private function checkFarmCrop() : Boolean
      {
         var crop:FieldVO = null;
         var hasCropMature:Boolean = false;
         var crops:Vector.<FieldVO> = FarmModelController.instance.model.selfFieldsInfo;
         for each(crop in crops)
         {
            if(crop.plantGrownPhase == 2)
            {
               hasCropMature = true;
               break;
            }
         }
         if(hasCropMature)
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.hasCropMature"),true,1,"walkA");
         }
         return hasCropMature;
      }
      
      private function checkMessageQueue() : void
      {
         var msg:PetMessage = null;
         if(this._isShown || !this.canShowPetSprite())
         {
            return;
         }
         while(this.hasMessageInQueue())
         {
            msg = this._queue[0];
            if(!(!msg.isAlwaysShow && !this._petModel.petSwitcher))
            {
               this.showNextMessage();
               break;
            }
            this._queue.pop();
         }
      }
      
      public function get model() : PetSpriteModel
      {
         return this._petModel;
      }
      
      public function switchPetSprite(val:Boolean) : void
      {
         if(val && this._petSprite.petSpriteLand && this.canShowPetSprite())
         {
            this._petSprite.petSpriteLand.gotoAndPlay(1);
         }
         else if(Boolean(this._petSprite) && Boolean(this._petSprite.petSpriteLand))
         {
            this._petSprite.petNotMove();
         }
         this._petModel.petSwitcher = val;
         if(!this.canInitPetSprite())
         {
            return;
         }
         if(val)
         {
            this.say("");
         }
         else
         {
            this.hidePetSprite(false,false);
            this._queue.length = 0;
         }
      }
      
      private function canInitPetSprite() : Boolean
      {
         return PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.minOpenPetSystemLevel;
      }
      
      public function get petSwitcher() : Boolean
      {
         return this._petModel.petSwitcher;
      }
      
      public function generatePetMovie() : void
      {
         if(!this._petModel.petSwitcher)
         {
            return;
         }
         var action:String = Helpers.randomPick(ACTION);
         if(action == "walkB")
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose1"),true,1,action);
            this._petSprite.petMove();
         }
         else if(action == "walkA")
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose2"),true,1,action);
            this._petSprite.petMove();
         }
         else if(action == "bsetC")
         {
            this._petSprite.petNotMove();
            this.say("",false,-1,action);
         }
         else
         {
            this._petSprite.petNotMove();
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose3"),true,1,action);
         }
      }
      
      private function init() : void
      {
         this._petSprite = ComponentFactory.Instance.creatCustomObject("petSprite.PetSprite",[this._petModel,this]);
      }
      
      public function get petSprite() : PetSprite
      {
         return this._petSprite;
      }
      
      private function initEvent() : void
      {
         this._petModel.addEventListener(PetSpriteModel.CURRENT_PET_CHANGED,this.__onCurrentPetChanged);
      }
      
      protected function __onCurrentPetChanged(event:Event) : void
      {
         this._petSprite.updatePet();
         if(Boolean(this._petModel.currentPet))
         {
            this.generatePetMovie();
         }
         else
         {
            this._queue.length = 0;
            this.hidePetSprite(true,false);
            this.enableChatViewPetSwitcher(false);
         }
         this._petSprite.petNotMove();
         this.checkHunger();
      }
      
      public function checkHunger() : void
      {
         if(Boolean(this._petModel.currentPet) && Number(this._petModel.currentPet.Hunger) / PetInfo.FULL_MAX_VALUE < 0.8)
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.hungerMsg"),true,1,PetSprite.HUNGER);
            this._petSprite.petNotMove();
         }
      }
      
      public function checkGP() : void
      {
      }
      
      public function showPetSprite(immediately:Boolean = false, showAlways:Boolean = false) : void
      {
         if(!this.canShowPetSprite() || !this._petModel.currentPet || !this._petSprite || !this._petModel.currentPet.assetReady || this._isShown)
         {
            if(!this._petModel.currentPet)
            {
               dispatchEvent(new Event(Event.CLOSE));
            }
            return;
         }
         if(!this._petModel.petSwitcher && !showAlways)
         {
            return;
         }
         if(Boolean(this._petModel.currentPet) && Number(this._petModel.currentPet.Hunger) / PetInfo.FULL_MAX_VALUE < 0.5)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.currentPet.Place,false);
            dispatchEvent(new Event(Event.CLOSE));
            return;
         }
         this._petSprite.petSpriteLand.gotoAndPlay(0);
         if(this._petModel.currentPet.Level < 50)
         {
            PositionUtils.setPos(this._petSprite,"petSprite.PetSprite.pet1Pos");
         }
         else
         {
            PositionUtils.setPos(this._petSprite,"petSprite.PetSprite.pet2Pos");
         }
         this._isShown = true;
         if(!immediately)
         {
            this.enableChatViewPetSwitcher(false);
            this._petSprite.playAnimation(PetSprite.APPEAR,this.afterAppear);
         }
         else
         {
            this._petSprite.playAnimation("walkA");
            this.enableChatViewPetSwitcher(true);
            this._loopTimer.start();
         }
      }
      
      private function afterAppear() : void
      {
         this._loopTimer.reset();
         this._loopTimer.start();
         this.enableChatViewPetSwitcher(true);
      }
      
      private function __messageLoop(evt:TimerEvent) : void
      {
         if(!this._petModel.petSwitcher && this._isShown)
         {
            this.hidePetSprite(true,false);
            return;
         }
         if(!this.hasMessageInQueue())
         {
            this.generatePetMovie();
         }
         this.showNextMessage();
      }
      
      public function hidePetSprite(immediately:Boolean = false, canShowNext:Boolean = true) : void
      {
         if(!this._petSprite)
         {
            return;
         }
         if(canShowNext && this.showNextMessage())
         {
            return;
         }
         this._loopTimer.stop();
         this._petSprite.hideMessageText();
         if(immediately)
         {
            this._petSprite.playAnimation("walkA");
            this.removePetSprite();
         }
         else
         {
            this.enableChatViewPetSwitcher(false);
            this._petSprite.playAnimation(PetSprite.DISAPPEAR,this.removePetSprite);
         }
      }
      
      private function removePetSprite() : void
      {
         if(Boolean(this._petSprite.petSpriteLand) && !this._petModel.petSwitcher)
         {
            this._petSprite.petSpriteLand.gotoAndPlay("out");
         }
         else if(Boolean(this._petSprite.petSpriteLand))
         {
            DisplayUtils.removeDisplay(this._petSprite.petSpriteLand);
         }
         DisplayUtils.removeDisplay(this._petSprite);
         this._isShown = false;
         if(this._petModel.currentPet != null)
         {
            this.enableChatViewPetSwitcher(true);
         }
      }
      
      private function canShowPetSprite() : Boolean
      {
         var currentStateType:String = StateManager.currentStateType;
         if(currentStateType == StateType.MAIN || currentStateType == StateType.ROOM_LIST || currentStateType == StateType.DUNGEON_LIST || currentStateType == StateType.MATCH_ROOM || currentStateType == StateType.DUNGEON_ROOM)
         {
            this.enableChatViewPetSwitcher(this._petModel.currentPet != null);
            ChatManager.Instance.output.PetSpriteSwitchVisible(true);
            return true;
         }
         ChatManager.Instance.output.PetSpriteSwitchVisible(false);
         return false;
      }
      
      private function enableChatViewPetSwitcher(val:Boolean) : void
      {
         ChatManager.Instance.output.enablePetSpriteSwitcher(val);
      }
      
      public function showNextMessage() : Boolean
      {
         if(!this._petModel.currentPet || !this.hasMessageInQueue() || !this.canShowPetSprite())
         {
            return false;
         }
         var msg:PetMessage = this._queue.pop();
         if(this._isShown)
         {
            this._petSprite.playAnimation(msg.action);
         }
         else
         {
            this.showPetSprite(false,msg.isAlwaysShow);
         }
         if(msg.type == 1)
         {
            this._petSprite.say(msg.msg);
         }
         else if(msg.type == -1)
         {
            this._petSprite.hideMessageText();
         }
         return true;
      }
      
      public function say(message:String, showAlways:Boolean = false, type:int = -1, action:String = "born3") : void
      {
         if(this._isShown || !this.canShowPetSprite())
         {
            if(this._petModel.petSwitcher || showAlways)
            {
               this._queue.push(new PetMessage(type,action,message,showAlways));
            }
         }
         else
         {
            if(action == PetSprite.HUNGER)
            {
               this.showPetSprite(true,true);
               this._petSprite.playAnimation(PetSprite.HUNGER);
            }
            else
            {
               this.showPetSprite(type == 1,showAlways);
            }
            if(type == 1)
            {
               this._petSprite.say(message);
            }
         }
      }
      
      public function hasMessageInQueue() : Boolean
      {
         return this._queue.length > 0;
      }
      
      public function set petSprite(value:PetSprite) : void
      {
         this._petSprite = value;
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}

class PetMessage
{
   
   public var type:int;
   
   public var action:String;
   
   public var msg:String;
   
   public var isAlwaysShow:Boolean;
   
   public function PetMessage(t:int, ac:String, m:String, always:Boolean)
   {
      super();
      this.type = t;
      this.action = ac;
      this.msg = m;
      this.isAlwaysShow = always;
   }
}
