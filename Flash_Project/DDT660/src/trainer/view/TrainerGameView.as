package trainer.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.loader.LoaderCreate;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.GameCharacter;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.gametrainer.objects.TrainerEquip;
   import game.gametrainer.objects.TrainerWeapon;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GamePlayer;
   import game.view.AutoPropEffect;
   import game.view.GameView;
   import hall.HallStateView;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.NewHandQueue;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   
   public class TrainerGameView extends GameView
   {
      
      private const eatOffset:int = -10;
      
      private var _player:GamePlayer;
      
      private var _shouldShowTurn:Boolean;
      
      private var _locked:Boolean;
      
      private var _picked:Boolean;
      
      private var _count:int;
      
      private var _dieNum:int;
      
      private var _weapon:TrainerWeapon;
      
      private var _equip:TrainerEquip;
      
      private var bogu:Living;
      
      private var toolForPick:MovieClip;
      
      public function TrainerGameView()
      {
         super();
      }
      
      override public function getType() : String
      {
         if(StartupResourceLoader.firstEnterHall)
         {
            return StateType.TRAINER2;
         }
         return StateType.TRAINER1;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         var audioLoader:BaseLoader = null;
         var loaderQueue:QueueLoader = null;
         super.enter(prev,data);
         ChatManager.Instance.state = ChatManager.CHAT_TRAINER_STATE;
         ChatManager.Instance.view.visible = false;
         ChatManager.Instance.chatDisabled = true;
         this.setDefaultAngle();
         this.reset();
         this.checkUserGuid();
         if(StartupResourceLoader.firstEnterHall)
         {
            if(!HallStateView.SoundIILoaded)
            {
               audioLoader = LoaderCreate.Instance.createAudioIILoader();
               audioLoader.addEventListener(LoaderEvent.COMPLETE,this.__onAudioIILoadComplete);
               LoadResourceManager.Instance.startLoad(audioLoader);
            }
         }
         else if(!HallStateView.SoundILoaded)
         {
            loaderQueue = new QueueLoader();
            loaderQueue.addLoader(LoaderCreate.Instance.createAudioILoader());
            loaderQueue.addLoader(LoaderCreate.Instance.createAudioIILoader());
            loaderQueue.addEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
            loaderQueue.start();
         }
      }
      
      private function __onAudioIILoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onAudioLoadComplete);
         if(event.loader.isSuccess)
         {
            SoundManager.instance.setupAudioResource(true);
            HallStateView.SoundIILoaded = true;
         }
      }
      
      private function __onAudioLoadComplete(event:Event) : void
      {
         event.currentTarget.removeEventListener(Event.COMPLETE,this.__onAudioLoadComplete);
         SoundManager.instance.setupAudioResource(false);
         HallStateView.SoundILoaded = true;
      }
      
      private function reset() : void
      {
         this._shouldShowTurn = true;
         this._locked = false;
         this._picked = false;
         this._count = 0;
         this._dieNum = 0;
      }
      
      private function checkUserGuid() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            NewHandQueue.Instance.push(new Step(Step.POP_MOVE,this.exeMoveUI,this.preMoveUI));
            NewHandQueue.Instance.push(new Step(Step.MOVE,this.exeMove,this.preMove,this.finMove));
            NewHandQueue.Instance.push(new Step(Step.SPAWN,this.exeSpawn,this.preSpawn,null,2000));
            NewHandQueue.Instance.push(new Step(Step.POP_TIP_ONE,this.exeTipOne,this.preTipOne,this.finTipOne));
            NewHandQueue.Instance.push(new Step(Step.POP_ENERGY,this.exeEnergyUI,this.preEnergyUI));
            NewHandQueue.Instance.push(new Step(Step.BEAT_LIVING_RIGHT,this.exeBeatLivingRight,this.preBeatLivingRight,this.finBeatLivingRight));
            NewHandQueue.Instance.push(new Step(Step.BEAT_LIVING_LEFT,this.exeBeatLivingLeft,this.preBeatLivingLeft,this.finBeatLivingLeft,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_ONE,this.exePickOne,this.prePickOne,this.finPickOne,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 112)
         {
            NewHandQueue.Instance.push(new Step(Step.PLAY_ONE_GLOW,this.exeOneGlow,this.preOneGlow,this.finOneGlow));
            NewHandQueue.Instance.push(new Step(Step.POP_ANGLE,this.exeAngle,this.preAngle,this.finAngle));
            NewHandQueue.Instance.push(new Step(Step.SPAWN_SMALL_BOGU,this.exeSmallBogu,this.preSmallBogu,this.finSmallBogu));
            NewHandQueue.Instance.push(new Step(Step.SPAWN_BIG_BOGU,this.exeBigBogu,this.preBigBogu,this.finBigBogu,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_TEN,this.exePickTen,this.prePickTen,this.finPickTen,1500));
            NoviceDataManager.instance.saveNoviceData(370,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(NewHandGuideManager.Instance.mapID == 113)
         {
            NewHandQueue.Instance.push(new Step(Step.PICK_POWER_THREE,this.exePickPower,this.prePickPower,this.finPickPower,1500));
            NoviceDataManager.instance.saveNoviceData(470,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(NewHandGuideManager.Instance.mapID == 114)
         {
            NewHandQueue.Instance.push(new Step(Step.POP_ENERGY,this.exeEnergyUI,this.preEnergyUIF));
            setTimeout(this.finBeatLivingRightF,13000);
            NewHandQueue.Instance.push(new Step(Step.ARROW_THREE,this.exeArrowThree,this.preArrowThree,this.finArrowThree));
            NewHandQueue.Instance.push(new Step(Step.ARROW_POWER,this.exeArrowPower,this.preArrowPower,this.finArrowPower,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_PLANE,this.exePickPlane,this.prePickPlane,this.finPickPlane,1500));
            NoviceDataManager.instance.saveNoviceData(520,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(NewHandGuideManager.Instance.mapID == 115)
         {
            NewHandQueue.Instance.push(new Step(Step.POP_ENERGY,this.exeEnergyUI,this.preEnergyUIFF));
            setTimeout(this.finBeatLivingRightF,16000);
            NewHandQueue.Instance.push(new Step(Step.BEAT_JIANJIAO_BOGU,this.exeBeatJianjiaoBogu,this.preBeatJianjiaoBogu,this.finBeatJianjiaoBogu,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_TWO_TWENTY,this.exePickTwoTwenty,this.prePickTwoTwenty,this.finPickTwoTwenty,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 116)
         {
            NewHandQueue.Instance.push(new Step(Step.BEAT_ROBOT,this.exeBeatRobot,this.preBeatRobot,this.finBeatRobot,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_THREE_FOUR_FIVE,this.exePickThreeFourFive,this.prePickThreeFourFive,this.finPickThreeFourFive,1500));
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         super.leaving(next);
         NewHandGuideManager.Instance.mapID = 0;
         this.disposeThis();
      }
      
      private function showAchieve() : void
      {
         var mc:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("game.trainer.achiveAsset"),true,true);
         PositionUtils.setPos(mc.movie,"trainer.posAchieve");
         LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_TOP_LAYER,false);
      }
      
      override protected function __playerChange(event:CrazyTankSocketEvent) : void
      {
         if(this._locked)
         {
            _map.lockFocusAt(PositionUtils.creatPoint("trainer.posLockFocus"));
         }
         if(this._shouldShowTurn)
         {
            super.__playerChange(event);
            _selfMarkBar.enabled = true;
         }
         else
         {
            _selfMarkBar.enabled = false;
         }
         setPropBarClickEnable(true,true);
      }
      
      override protected function __shoot(event:CrazyTankSocketEvent) : void
      {
         super.__shoot(event);
         if(this._locked)
         {
            _map.releaseFocus();
         }
      }
      
      public function set shouldShowTurn(value:Boolean) : void
      {
         this._shouldShowTurn = value;
      }
      
      public function skip() : void
      {
         GameInSocketOut.sendGameSkipNext(1);
      }
      
      private function enableSpace(enable:Boolean) : void
      {
         if(enable)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,false,99);
         }
      }
      
      private function enableLeftAndRight(enable:Boolean) : void
      {
         if(enable)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,false,99);
         }
      }
      
      private function enableUpAndDown(enable:Boolean) : void
      {
         if(enable)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,false,99);
         }
      }
      
      private function __keyDownSpace(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.SPACE)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function __keyDownLeftRight(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.LEFT || evt.keyCode == Keyboard.RIGHT || evt.keyCode == 65 || evt.keyCode == 68)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function __keyDownUpDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.UP || evt.keyCode == Keyboard.DOWN || evt.keyCode == 87 || evt.keyCode == 83)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function preMoveUI() : void
      {
         _selfMarkBar.enabled = false;
         _map.smallMap.allowDrag = false;
         this.enableSpace(false);
         this.enableLeftAndRight(false);
         this.enableUpAndDown(false);
         setBarrierVisible(false);
         setPlayerThumbVisible(false);
         this.shouldShowTurn = false;
         this._player = _players[_gameInfo.selfGamePlayer] as GamePlayer;
         this._player.player.isAttacking = true;
         this._player.player.maxEnergy = 10000;
         _gameInfo.selfGamePlayer.energy = 10000;
         NewHandContainer.Instance.showMovie("asset.trainer.mcMove");
         setTimeout(NewHandContainer.Instance.showMovie,1000,"asset.trainer.leftKeyShineAsset","trainer.posLeftKey");
      }
      
      private function exeMoveUI() : Boolean
      {
         return true;
      }
      
      private function preMove() : void
      {
         this._weapon = new TrainerWeapon(100001);
         this._weapon.pos = PositionUtils.creatPoint("trainer1.posWeapon");
         this._player.map.addPhysical(this._weapon);
         this.enableLeftAndRight(true);
         GameManager.Instance.Current.selfGamePlayer.selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged,false,-1);
      }
      
      private function exeMove() : Boolean
      {
         var eatWeapon:MovieClipWrapper = null;
         var eatEquip:MovieClipWrapper = null;
         if(Boolean(this._weapon))
         {
            if(this._player.pos.x - this._weapon.pos.x < 65)
            {
               GameInSocketOut.sendUpdatePlayStep("pickUpWeapon");
               eatWeapon = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset"),true,true);
               eatWeapon.addFrameScriptAt(12,this.headWeaponEffect);
               SoundManager.instance.play("039");
               eatWeapon.movie.y = this.eatOffset;
               this._player.addChild(eatWeapon.movie);
               this._player.doAction(GameCharacter.HANDCLIP);
               this._weapon.dispose();
               this._weapon = null;
               NewHandContainer.Instance.hideMovie("asset.trainer.leftKeyShineAsset");
               NewHandContainer.Instance.showMovie("asset.trainer.rightKeyShineAsset","trainer.posRightKey");
               this._equip = new TrainerEquip(100002);
               this._equip.pos = PositionUtils.creatPoint("trainer1.posEquip");
               this._player.map.addPhysical(this._equip);
            }
         }
         if(Boolean(this._equip))
         {
            if(this._player.pos.x - this._equip.pos.x > -10)
            {
               GameInSocketOut.sendUpdatePlayStep("pickUpHat");
               eatEquip = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset"),true,true);
               eatEquip.addFrameScriptAt(12,this.headEquipEffect);
               SoundManager.instance.play("039");
               eatEquip.movie.y = this.eatOffset;
               this._player.addChild(eatEquip.movie);
               this._player.doAction(GameCharacter.HANDCLIP);
               this._equip.dispose();
               this._equip = null;
               this.enableLeftAndRight(false);
            }
         }
         if(!this._weapon && !this._equip)
         {
            ++this._count;
         }
         return !this._weapon && !this._equip && this._count >= 55;
      }
      
      private function __playerPropChanged(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["WeaponID"]))
         {
            this.setDefaultAngle();
         }
      }
      
      private function setDefaultAngle() : void
      {
         GameManager.Instance.Current.selfGamePlayer.manuallySetGunAngle(35);
      }
      
      private function headWeaponEffect() : void
      {
         this.headEffect(ComponentFactory.Instance.creatBitmap("asset.trainer.TrainerWeaponIcon"));
      }
      
      private function headEquipEffect() : void
      {
         var str:String = PlayerManager.Instance.Self.Sex ? "asset.trainer.TrainerManEquipIcon" : "asset.trainer.TrainerWomanEquipIcon";
         this.headEffect(ComponentFactory.Instance.creatBitmap(str));
      }
      
      private function headEffect(movie:DisplayObject) : void
      {
         var head:AutoPropEffect = new AutoPropEffect(movie);
         PositionUtils.setPos(head,"trainer1.posHeadEffect");
         movie.width = 62;
         movie.height = 62;
         this._player.addChild(head);
      }
      
      private function finMove() : void
      {
         GameManager.Instance.Current.selfGamePlayer.selfInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged,false);
         NewHandContainer.Instance.hideMovie("asset.trainer.rightKeyShineAsset");
         NewHandContainer.Instance.hideMovie("asset.trainer.mcMove");
         this.showAchieve();
         setPlayerThumbVisible(true);
         SoundManager.instance.play("018");
      }
      
      private function preSpawn() : void
      {
         this._count = 0;
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createRightBogu");
      }
      
      private function exeSpawn() : Boolean
      {
         if(Boolean(this.bogu))
         {
            ++this._count;
         }
         return Boolean(this.bogu) && this._count >= 50;
      }
      
      private function preTipOne() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcBeatBoguAsset");
      }
      
      private function exeTipOne() : Boolean
      {
         ++this._count;
         return this._count >= 106;
      }
      
      private function finTipOne() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.mcBeatBoguAsset");
      }
      
      private function preEnergyUI() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcEnergy");
         setEnergyVisible(true);
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function preEnergyUIF() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcEnergy4","asset.trainer.mcEnergy4.pos");
         setEnergyVisible(true);
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function preEnergyUIFF() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcEnergy5","asset.trainer.mcEnergy5.pos");
         setEnergyVisible(true);
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function exeEnergyUI() : Boolean
      {
         ++this._count;
         return this._count >= 25;
      }
      
      private function preBeatLivingRight() : void
      {
         this.enableSpace(true);
      }
      
      private function exeBeatLivingRight() : Boolean
      {
         if(Boolean(this.bogu) && !this.bogu.isLiving)
         {
            this.enableLeftAndRight(true);
            return true;
         }
         return false;
      }
      
      private function finBeatLivingRight() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.mcEnergy");
         this.showAchieve();
         this.shouldShowTurn = false;
         this.skip();
         SoundManager.instance.play("018");
         this.disposeBogu();
      }
      
      private function finBeatLivingRightF() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.mcEnergy4");
         NewHandContainer.Instance.hideMovie("asset.trainer.mcEnergy5");
      }
      
      private function preBeatLivingLeft() : void
      {
         this._count = 0;
         this.enableSpace(false);
         this.lockMap();
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createLeftBogu");
      }
      
      private function exeBeatLivingLeft() : Boolean
      {
         if(Boolean(this.bogu))
         {
            ++this._count;
         }
         if(this._count == 50)
         {
            NewHandContainer.Instance.showMovie("asset.trainer.mcBigEnergyAsset");
         }
         else if(this._count == 100)
         {
            this.shouldShowTurn = true;
            this.skip();
            this.enableSpace(true);
         }
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finBeatLivingLeft() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         NewHandContainer.Instance.hideMovie("asset.trainer.mcBigEnergyAsset");
         _map.releaseFocus();
      }
      
      private function prePickOne() : void
      {
         this.showAchieve();
         this.creatToolForPick("asset.trainer.pickOneAsset");
      }
      
      private function exePickOne() : Boolean
      {
         return this._picked;
      }
      
      private function finPickOne() : void
      {
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.GAIN_ADDONE);
         this.disposeBogu();
      }
      
      private function __addBogu(event:DictionaryEvent) : void
      {
         this.bogu = event.data as Living;
      }
      
      private function disposeBogu() : void
      {
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addBogu);
         this.bogu = null;
      }
      
      private function lockMap() : void
      {
         _map.lockFocusAt(PositionUtils.creatPoint("trainer.posLockFocus"));
         this._locked = true;
      }
      
      private function preOneGlow() : void
      {
         this._count = 0;
         this.enableUpAndDown(true);
         NewHandContainer.Instance.showMovie("asset.trainer.getOne");
      }
      
      private function exeOneGlow() : Boolean
      {
         ++this._count;
         return this._count >= 93;
      }
      
      private function finOneGlow() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.getOne");
      }
      
      private function preAngle() : void
      {
         NewHandContainer.Instance.showMovie("asset.trainer.mcAngle");
      }
      
      private function exeAngle() : Boolean
      {
         return true;
      }
      
      private function finAngle() : void
      {
      }
      
      private function preSmallBogu() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createsmallbogu");
      }
      
      private function exeSmallBogu() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finSmallBogu() : void
      {
         TrainStep.send(TrainStep.Step.ONE_BOGU_BEAT);
         this.disposeBogu();
         this.shouldShowTurn = false;
         this.skip();
      }
      
      private function preBigBogu() : void
      {
         NoviceDataManager.instance.saveNoviceData(380,PathManager.userName(),PathManager.solveRequestPath());
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showArrow);
         GameInSocketOut.sendUpdatePlayStep("createbigbogu");
         setTimeout(this.showTurn,5000);
      }
      
      private function showTurn() : void
      {
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function exeBigBogu() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finBigBogu() : void
      {
         TrainStep.send(TrainStep.Step.BOSS_BEAT);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showArrow);
         NewHandContainer.Instance.hideMovie("asset.trainer.mcAngle");
      }
      
      private function prePickTen() : void
      {
         this.creatToolForPick("asset.trainer.pickTenAsset");
      }
      
      private function exePickTen() : Boolean
      {
         return this._picked;
      }
      
      private function finPickTen() : void
      {
         this.disposeToolForPick();
         this.disposeBogu();
         SocketManager.Instance.out.syncWeakStep(Step.GAIN_TEN_PERSENT);
      }
      
      private function prePickPower() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__onAddLiving);
      }
      
      private function __onAddLiving(event:DictionaryEvent) : void
      {
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__onAddLiving);
         this.bogu = event.data as Living;
         this.bogu.addEventListener(LivingEvent.DIE,this.__onLivingDie);
      }
      
      private function __onLivingDie(evt:LivingEvent) : void
      {
         TrainStep.send(TrainStep.Step.GET_POW);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         this.bogu.removeEventListener(LivingEvent.DIE,this.__onLivingDie);
         setTimeout(this.creatToolForPick,4000,"asset.trainer.getPowerThreeAsset");
      }
      
      private function exePickPower() : Boolean
      {
         return this._picked;
      }
      
      private function finPickPower() : void
      {
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.POWER_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.THREE_OPEN);
      }
      
      private function preArrowThree() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__add);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
      }
      
      private function __add(evt:DictionaryEvent) : void
      {
         var living:Living = evt.data as Living;
         if(living.typeLiving == 5)
         {
            this.bogu = living;
         }
         else
         {
            living.addEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      private function __die(evt:LivingEvent) : void
      {
         (evt.currentTarget as EventDispatcher).removeEventListener(LivingEvent.DIE,this.__die);
         ++this._dieNum;
      }
      
      private function exeArrowThree() : Boolean
      {
         return this._dieNum >= 5;
      }
      
      private function finArrowThree() : void
      {
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
      }
      
      private function preArrowPower() : void
      {
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showPowerArrow);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.DANDER_CHANGED,this.__showPowerArrow);
      }
      
      private function exeArrowPower() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finArrowPower() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__add);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showPowerArrow);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.DANDER_CHANGED,this.__showPowerArrow);
      }
      
      private function prePickPlane() : void
      {
         this.creatToolForPick("asset.trainer.pickPlaneAsset");
      }
      
      private function exePickPlane() : Boolean
      {
         return this._picked;
      }
      
      private function finPickPlane() : void
      {
         NoviceDataManager.instance.saveNoviceData(530,PathManager.userName(),PathManager.solveRequestPath());
         TrainStep.send(TrainStep.Step.COLLECT_PLANE);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.PLANE_OPEN);
      }
      
      private function __showThreeArrow(evt:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE,-90,"trainer.posTipThree");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showPowerArrow(evt:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            if(_gameInfo.selfGamePlayer.dander >= Player.TOTAL_DANDER)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TIP_POWER,-30,"trainer.posTipPower");
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showArrow(evt:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_ONE,-90,"trainer.posTipOne");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function preBeatJianjiaoBogu() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addJianjiaoBogu);
         setTimeout(__dungeonVisibleChanged,5500,null);
      }
      
      private function __addJianjiaoBogu(evt:DictionaryEvent) : void
      {
         var living:Living = evt.data as Living;
         if(living.typeLiving == 5)
         {
            _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addJianjiaoBogu);
            this.bogu = living;
         }
      }
      
      private function exeBeatJianjiaoBogu() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finBeatJianjiaoBogu() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      private function prePickTwoTwenty() : void
      {
         this.creatToolForPick("asset.trainer.pickTwoTwentyAsset");
      }
      
      private function exePickTwoTwenty() : Boolean
      {
         return this._picked;
      }
      
      private function finPickTwoTwenty() : void
      {
         TrainStep.send(TrainStep.Step.GET_ADD_HARMTWO);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.TWO_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.TWENTY_OPEN);
      }
      
      private function preBeatRobot() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addRobot);
      }
      
      private function __addRobot(evt:DictionaryEvent) : void
      {
         var living:Living = evt.data as Living;
         if(living.typeLiving == 5)
         {
            _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addRobot);
            this.bogu = living;
         }
      }
      
      private function exeBeatRobot() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function finBeatRobot() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      private function prePickThreeFourFive() : void
      {
         this.creatToolForPick("asset.trainer.pickThreeFourFiveAsset");
      }
      
      private function exePickThreeFourFive() : Boolean
      {
         return this._picked;
      }
      
      private function finPickThreeFourFive() : void
      {
         TrainStep.send(TrainStep.Step.GET_ADD_HARMALL);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.THIRTY_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.FORTY_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.FIFTY_OPEN);
      }
      
      private function __missionOver(evt:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         NewHandQueue.Instance.dispose();
         NewHandContainer.Instance.hideMovie("-1");
         NewHandContainer.Instance.clearArrowByID(-1);
      }
      
      private function exeBeatBogu() : Boolean
      {
         return Boolean(this.bogu) && !this.bogu.isLiving;
      }
      
      private function creatToolForPick(style:String) : void
      {
         var pos:Point = _map.localToGlobal(new Point(this.bogu.pos.x,this.bogu.pos.y));
         this.toolForPick = ClassUtils.CreatInstance(style) as MovieClip;
         this.toolForPick.buttonMode = true;
         this.toolForPick.addEventListener(MouseEvent.CLICK,this.__pickTool);
         this.toolForPick.x = pos.x;
         this.toolForPick.y = pos.y;
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         LayerManager.Instance.addToLayer(this.toolForPick,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         SoundManager.instance.play("156");
      }
      
      private function disposeToolForPick() : void
      {
         ObjectUtils.disposeObject(this.toolForPick);
         this.toolForPick.removeEventListener(MouseEvent.CLICK,this.__pickTool);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this.toolForPick = null;
         this._picked = false;
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         this.toolForPick.filters = null;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         this.toolForPick.filters = [new GlowFilter(16737792,1,30,30,2)];
      }
      
      private function __pickTool(event:MouseEvent) : void
      {
         this._picked = true;
         SoundManager.instance.play("008");
         SoundManager.instance.play("157");
      }
      
      private function disposeThis() : void
      {
         this.enableLeftAndRight(true);
         this.enableUpAndDown(true);
         this.enableSpace(true);
         this._player = null;
         this.bogu = null;
         if(Boolean(this._weapon))
         {
            this._weapon.dispose();
            this._weapon = null;
         }
         if(Boolean(this._equip))
         {
            this._equip.dispose();
            this._equip = null;
         }
      }
   }
}

