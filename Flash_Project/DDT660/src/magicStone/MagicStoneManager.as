package magicStone
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import magicStone.components.MgStoneCell;
   import magicStone.data.MagicStoneEvent;
   import magicStone.data.MagicStoneTempAnalyer;
   import magicStone.data.MgStoneTempVO;
   import magicStone.stoneExploreView.StoneExploreModel;
   import magicStone.views.MagicStoneInfoView;
   import magicStone.views.MagicStoneShopFrame;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class MagicStoneManager extends EventDispatcher
   {
      
      private static var _instance:MagicStoneManager;
      
      public static const SHOWEXPLOREVIEW:String = "showExploreView";
      
      public var singleFeedFunc:Function;
      
      public var singleFeedCell:MgStoneCell;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public var mgStoneScore:int = 0;
      
      private var _infoView:MagicStoneInfoView;
      
      private var _shopFrame:MagicStoneShopFrame;
      
      private var _mgStoneTempArr:Array;
      
      private var _upgradeMC:MovieClip;
      
      public var isNoPrompt:Boolean;
      
      public var isBatNoPrompt:Boolean;
      
      public var isBand:Boolean;
      
      public var upTo40Flag:Boolean = false;
      
      public var isDoubleScore:Boolean;
      
      private var _model:StoneExploreModel;
      
      public function MagicStoneManager()
      {
         super();
      }
      
      public static function get instance() : MagicStoneManager
      {
         if(!_instance)
         {
            _instance = new MagicStoneManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new StoneExploreModel();
         this.addEvents();
      }
      
      public function addEvents() : void
      {
         SocketManager.Instance.addEventListener(MagicStoneEvent.MAGIC_STONE_SCORE,this.__getMagicStoneScore);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAGICSTONE_DOUBLESCORE,this.__getMagicStoneDoubleScore);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAGIC_STONE_MONSTER_INFO,this.__MagicStoneMonsterInfo);
      }
      
      public function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(MagicStoneEvent.MAGIC_STONE_SCORE,this.__getMagicStoneScore);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MAGICSTONE_DOUBLESCORE,this.__getMagicStoneDoubleScore);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MAGIC_STONE_MONSTER_INFO,this.__MagicStoneMonsterInfo);
      }
      
      private function __MagicStoneMonsterInfo(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._model.normalFightNum = pkg.readInt();
         this._model.hardFightNum = pkg.readInt();
         dispatchEvent(new Event(SHOWEXPLOREVIEW));
      }
      
      protected function __getMagicStoneScore(event:MagicStoneEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.mgStoneScore = pkg.readInt();
         if(Boolean(this._infoView))
         {
            this._infoView.updateScore(this.mgStoneScore);
         }
         if(Boolean(this._shopFrame))
         {
            this._shopFrame.updateScore(this.mgStoneScore);
         }
      }
      
      private function __getMagicStoneDoubleScore(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.isDoubleScore = pkg.readBoolean();
         pkg.readDate();
         pkg.readDate();
         dispatchEvent(new MagicStoneEvent(MagicStoneEvent.MAGIC_STONE_DOUBLESCORE));
      }
      
      public function loadMgStoneTempComplete(analyzer:MagicStoneTempAnalyer) : void
      {
         this._mgStoneTempArr = analyzer.mgStoneTempArr;
      }
      
      public function getNeedExp(templateId:int, level:int) : int
      {
         var i:int = 0;
         var vo:MgStoneTempVO = null;
         if(this._mgStoneTempArr != null)
         {
            for(i = 0; i <= this._mgStoneTempArr.length - 1; i++)
            {
               vo = this._mgStoneTempArr[i] as MgStoneTempVO;
               if(vo.TemplateID == templateId && vo.Level == level)
               {
                  return vo.Exp;
               }
            }
         }
         return 0;
      }
      
      public function getNeedExpPerLevel(templateId:int, level:int) : int
      {
         var vo:MgStoneTempVO = null;
         var lastExp:int = 0;
         var curExp:int = 0;
         for(var i:int = 0; i <= this._mgStoneTempArr.length - 1; i++)
         {
            vo = this._mgStoneTempArr[i] as MgStoneTempVO;
            if(vo.TemplateID == templateId)
            {
               if(vo.Level == level - 1)
               {
                  lastExp = vo.Exp;
               }
               else if(vo.Level == level)
               {
                  curExp = vo.Exp;
               }
            }
         }
         return curExp - lastExp > 0 ? curExp - lastExp : 0;
      }
      
      public function getExpOfCurLevel(templateId:int, exp:int) : int
      {
         var i:int = 1;
         var levelExp:int = MagicStoneManager.instance.getNeedExpPerLevel(templateId,i);
         while(levelExp > 0 && exp >= levelExp)
         {
            i++;
            exp -= levelExp;
            levelExp = MagicStoneManager.instance.getNeedExpPerLevel(templateId,i);
         }
         return exp;
      }
      
      public function fillPropertys(item:ItemTemplateInfo) : void
      {
         var vo:MgStoneTempVO = null;
         for(var i:int = 0; i <= this._mgStoneTempArr.length - 1; i++)
         {
            vo = this._mgStoneTempArr[i] as MgStoneTempVO;
            if(vo.TemplateID == item.TemplateID && vo.Level == item.Level)
            {
               item.Attack = vo.Attack;
               item.Defence = vo.Defence;
               item.Agility = vo.Agility;
               item.Luck = vo.Luck;
               item.MagicAttack = vo.MagicAttack;
               item.MagicDefence = vo.MagicDefence;
            }
         }
      }
      
      public function playUpgradeMc() : void
      {
         if(Boolean(this._upgradeMC))
         {
            this._upgradeMC.stop();
            this._upgradeMC.removeEventListener(Event.ENTER_FRAME,this.__disposeUpgradeMC);
            ObjectUtils.disposeObject(this._upgradeMC);
            this._upgradeMC = null;
         }
         this._upgradeMC = ComponentFactory.Instance.creat("magicStone.upgradeMc");
         this._upgradeMC.x = 455;
         this._upgradeMC.y = 123;
         this._upgradeMC.addEventListener(Event.ENTER_FRAME,this.__disposeUpgradeMC);
         LayerManager.Instance.addToLayer(this._upgradeMC,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,true);
         this._upgradeMC.gotoAndPlay(1);
      }
      
      protected function __disposeUpgradeMC(event:Event) : void
      {
         var mc:MovieClip = event.target as MovieClip;
         if(mc.currentFrame == mc.totalFrames)
         {
            mc.gotoAndStop(1);
            mc.removeEventListener(Event.ENTER_FRAME,this.__disposeUpgradeMC);
            ObjectUtils.disposeObject(mc);
            mc = null;
         }
      }
      
      public function weakGuide(type:int, container:DisplayObjectContainer = null) : void
      {
         if(!container)
         {
            container = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
         }
         switch(type)
         {
            case 0:
               if(MagicStoneManager.instance.upTo40Flag && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_OPEN))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.MAGIC_STONE_OPEN,0,"hall.mgStoneGuide.openPos","","",container,0,true);
                  MainToolBar.Instance.showBagShineEffect(true);
               }
               break;
            case 1:
               if(MagicStoneManager.instance.upTo40Flag && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_EXPLORE))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.MAGIC_STONE_EXPLORE,0,"hall.mgStoneGuide.explorePos","magicStone.clickToExplore","hall.mgStoneGuide.exploreTipPos",container,0,true);
               }
               break;
            case 2:
               if(MagicStoneManager.instance.upTo40Flag && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_EQUIP))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.MAGIC_STONE_EQUIP,225,"hall.mgStoneGuide.equipPos","magicStone.doubleClickToEquip","hall.mgStoneGuide.equipTipPos",container,0,true);
               }
               break;
            case 3:
               if(MagicStoneManager.instance.upTo40Flag && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_BAG))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.MAGIC_STONE_BAG,180,"hall.mgStoneGuide.bagPos","","",container,0,true);
               }
         }
      }
      
      public function removeWeakGuide(type:int) : void
      {
         switch(type)
         {
            case 0:
               if(PlayerManager.Instance.Self.Grade >= 40 && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_OPEN))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.MAGIC_STONE_OPEN);
                  NewHandContainer.Instance.clearArrowByID(ArrowType.MAGIC_STONE_OPEN);
                  MainToolBar.Instance.showBagShineEffect(false);
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.Grade >= 40 && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_EXPLORE))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.MAGIC_STONE_EXPLORE);
                  NewHandContainer.Instance.clearArrowByID(ArrowType.MAGIC_STONE_EXPLORE);
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.Grade >= 40 && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_EQUIP))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.MAGIC_STONE_EQUIP);
                  NewHandContainer.Instance.clearArrowByID(ArrowType.MAGIC_STONE_EQUIP);
               }
               break;
            case 3:
               if(PlayerManager.Instance.Self.Grade >= 40 && !PlayerManager.Instance.Self.isMagicStoneGuideFinish(Step.MAGIC_STONE_BAG))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.MAGIC_STONE_BAG);
                  NewHandContainer.Instance.clearArrowByID(ArrowType.MAGIC_STONE_BAG);
               }
         }
      }
      
      public function loadResModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MAGIC_STONE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MAGIC_STONE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MAGIC_STONE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      public function updataCharacter(info:PlayerInfo) : void
      {
         if(Boolean(this.infoView))
         {
            this.infoView.updataCharacter(info);
         }
      }
      
      public function get infoView() : MagicStoneInfoView
      {
         return this._infoView;
      }
      
      public function set infoView(value:MagicStoneInfoView) : void
      {
         this._infoView = value;
      }
      
      public function get shopFrame() : MagicStoneShopFrame
      {
         return this._shopFrame;
      }
      
      public function set shopFrame(value:MagicStoneShopFrame) : void
      {
         this._shopFrame = value;
      }
      
      public function get model() : StoneExploreModel
      {
         return this._model;
      }
   }
}

