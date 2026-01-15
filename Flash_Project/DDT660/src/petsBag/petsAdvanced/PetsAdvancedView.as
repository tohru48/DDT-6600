package petsBag.petsAdvanced
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import ddtDeed.DeedManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetsAdvancedEvent;
   
   public class PetsAdvancedView extends Sprite implements Disposeable
   {
      
      protected var _bg:Bitmap;
      
      protected var _petInfo:PetInfo;
      
      protected var _petsBasicInfoView:PetsBasicInfoView;
      
      protected var _viewType:int;
      
      protected var _vBox:VBox;
      
      protected var _itemVector:Vector.<PetsPropItem>;
      
      protected var _btn:SimpleBitmapButton;
      
      protected var _freeBtn:SimpleBitmapButton;
      
      protected var _freeTxt:FilterFrameText;
      
      protected var _allBtn:SelectedCheckButton;
      
      protected var _bagCellBg:Bitmap;
      
      protected var _bagCell:PetsAdvancedCell;
      
      protected var _progress:PetsAdvancedProgressBar;
      
      protected var _starMc:MovieClip;
      
      protected var _gradeMc:MovieClip;
      
      protected var _currentEvolutionExp:int;
      
      protected var _currentPropArr:Array;
      
      protected var _currentGrowArr:Array;
      
      protected var _toLinkTxt:FilterFrameText;
      
      protected var _tip:OneLineTip;
      
      protected var _self:SelfInfo;
      
      private var _clickDate:Number = 0;
      
      public function PetsAdvancedView(viewType:int)
      {
         super();
         this._viewType = viewType;
         this._petInfo = PetBagController.instance().petModel.currentPetInfo;
         this._itemVector = new Vector.<PetsPropItem>();
         this._self = PlayerManager.Instance.Self;
         this.initView();
         this.initData();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         var item:PetsPropItem = null;
         if(this._viewType == 1)
         {
            this._bg = ComponentFactory.Instance.creat("petsBag.risingStar.petsBag.bg");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creat("petsBag.evolution.bg");
         }
         addChild(this._bg);
         this._petsBasicInfoView = new PetsBasicInfoView();
         addChild(this._petsBasicInfoView);
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.vBox");
         addChild(this._vBox);
         for(var i:int = 0; i < 5; i++)
         {
            item = new PetsPropItem(this._viewType);
            this._itemVector.push(item);
            this._vBox.addChild(item);
         }
         this._allBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.allRisingStarBtn");
         addChild(this._allBtn);
         this._allBtn.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.tisingStarTxt");
         this._progress = new PetsAdvancedProgressBar();
         addChild(this._progress);
         this._tip = new OneLineTip();
         this._tip.visible = false;
         addChild(this._tip);
         if(this._viewType == 1)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn");
            addChild(this._btn);
            this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn2");
            addChild(this._freeBtn);
            this._freeTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn2txt");
            addChild(this._freeTxt);
            PositionUtils.setPos(this._progress,"petsBag.risingStar.progressPos");
            PositionUtils.setPos(this._tip,"petsBag.risingStar.tipPos");
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn");
            addChild(this._btn);
            this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn2");
            addChild(this._freeBtn);
            this._freeTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn2txt");
            addChild(this._freeTxt);
            PositionUtils.setPos(this._allBtn,"petsBag.evolution.allEvolutionBtnPos");
            PositionUtils.setPos(this._progress,"petsBag.evolution.progressPos");
            PositionUtils.setPos(this._tip,"petsBag.evolution.tipPos");
         }
         this._bagCellBg = ComponentFactory.Instance.creat("petsBag.risingStar.bagCellBg");
         PositionUtils.setPos(this._bagCellBg,"petsBag.advaced.bagCellBg" + this._viewType);
         addChild(this._bagCellBg);
         this._bagCell = new PetsAdvancedCell();
         PositionUtils.setPos(this._bagCell,"petsBag.advaced.petAdvancedCellPos" + this._viewType);
         addChild(this._bagCell);
         this._toLinkTxt = ComponentFactory.Instance.creat("petAndHorse.risingStar.toLinkTxt");
         this._toLinkTxt.mouseEnabled = true;
         this._toLinkTxt.htmlText = LanguageMgr.GetTranslation("petAndHorse.risingStar.toLinkTxtValue");
         PositionUtils.setPos(this._toLinkTxt,"petAndHorse.risingStar.toLinkTxtPos" + this._viewType);
         addChild(this._toLinkTxt);
         this.refreshFreeTipTxt();
      }
      
      protected function addEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._progress.addEventListener(PetsAdvancedEvent.PROGRESS_MOVIE_COMPLETE,this.__progressMovieHandler);
         this._petsBasicInfoView.addEventListener(PetsAdvancedEvent.ALL_MOVIE_COMPLETE,this.__allComplete);
         this._progress.addEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.addEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._toLinkTxt.addEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function refreshFreeTipTxt(event:Event = null) : void
      {
         var freeCount1:int = 0;
         freeCount1 = DeedManager.instance.getOneBuffData(DeedManager.PET_GRANT);
         var freeCount2:int = DeedManager.instance.getOneBuffData(DeedManager.PET_STAR);
         if(this._viewType == 1)
         {
            if(freeCount1 > 0 && this._petInfo.StarLevel < 5)
            {
               this._freeBtn.visible = true;
               this._freeTxt.visible = true;
               this._freeTxt.text = "(" + freeCount1 + ")";
               this._btn.visible = false;
            }
            else
            {
               this._freeTxt.text = "(" + freeCount1 + ")";
               this._freeBtn.visible = false;
               this._freeTxt.visible = false;
               this._btn.visible = true;
            }
         }
         else if(this._viewType == 2)
         {
            if(freeCount2 > 0 && this._self.evolutionGrade < PetsAdvancedManager.Instance.evolutionDataList.length)
            {
               this._freeBtn.visible = true;
               this._freeTxt.visible = true;
               this._freeTxt.text = "(" + freeCount2 + ")";
               this._btn.visible = false;
            }
            else
            {
               this._freeTxt.text = "(" + freeCount2 + ")";
               this._freeBtn.visible = false;
               this._freeTxt.visible = false;
               this._btn.visible = true;
            }
         }
      }
      
      protected function __hideTip(event:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      protected function __showTip(event:MouseEvent) : void
      {
         this._tip.tipData = this._progress.currentExp + "/" + this._progress.max;
         this._tip.visible = true;
      }
      
      protected function playNumMovie() : void
      {
         for(var i:int = 0; i < this._itemVector.length; i++)
         {
            this._itemVector[i].playNumMc();
         }
      }
      
      protected function __allComplete(event:Event) : void
      {
         if(this._viewType == 1)
         {
            if(this._petInfo.StarLevel < 5)
            {
               this._btn.enable = true;
            }
            else
            {
               this._btn.enable = false;
            }
         }
         else if(this._self.evolutionGrade < PetsAdvancedManager.Instance.evolutionDataList.length)
         {
            this._btn.enable = true;
         }
         else
         {
            this._btn.enable = false;
         }
         PetsAdvancedManager.Instance.isAllMovieComplete = true;
         PetsAdvancedManager.Instance.frame.enableBtn = true;
      }
      
      protected function __progressMovieHandler(event:PetsAdvancedEvent) : void
      {
         if(this._viewType == 1)
         {
            this._starMc = ComponentFactory.Instance.creat("petsBag.risingStar.starMc");
            addChild(this._starMc);
            PositionUtils.setPos(this._starMc,"petsBag.risingStar.starMcPos" + this._petInfo.StarLevel);
         }
         else
         {
            this._gradeMc = ComponentFactory.Instance.creat("petsBag.evolution.gradeMc");
            this._gradeMc.rotation = 44;
            addChild(this._gradeMc);
            PositionUtils.setPos(this._gradeMc,"petsBag.evolution.gradeMcPos");
         }
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      protected function __enterFrame(event:Event) : void
      {
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         var count:int = 0;
         var temp:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(new Date().time - this._clickDate <= 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickDate = new Date().time;
         SoundManager.instance.playButtonSound();
         if(this._viewType == 2 && !this._petInfo.IsEquip)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.evolution.cannotEvolutionTxt"));
            return;
         }
         var freeCount1:int = DeedManager.instance.getOneBuffData(DeedManager.PET_GRANT);
         var freeCount2:int = DeedManager.instance.getOneBuffData(DeedManager.PET_STAR);
         if(this._viewType == 1 && freeCount1 > 0)
         {
            SocketManager.Instance.out.sendPetRisingStar(this._bagCell.getTempleteId(),1,this._petInfo.Place);
            return;
         }
         if(this._viewType == 2 && freeCount2 > 0)
         {
            SocketManager.Instance.out.sendPetEvolution(this._bagCell.getTempleteId(),1);
            return;
         }
         if(this._bagCell.getCount() == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.advanced.noPropTxt",this._bagCell.getPropName()));
            return;
         }
         var exp:int = this._bagCell.getExpOfBagcell();
         var templeteId:int = this._bagCell.getTempleteId();
         if(this._allBtn.selected)
         {
            temp = Math.ceil((this._progress.max - this._progress.currentExp) / exp);
            count = temp < this._bagCell.getCount() ? temp : this._bagCell.getCount();
         }
         else
         {
            count = 1;
         }
         var place:int = this._petInfo.Place;
         if(this._viewType == 1)
         {
            SocketManager.Instance.out.sendPetRisingStar(templeteId,count,place);
         }
         else
         {
            SocketManager.Instance.out.sendPetEvolution(templeteId,count);
         }
      }
      
      protected function initData() : void
      {
         this.updatePetData();
      }
      
      protected function updatePetData() : void
      {
         this._currentPropArr = [this._petInfo.Blood * 100,this._petInfo.Attack * 100,this._petInfo.Defence * 100,this._petInfo.Agility * 100,this._petInfo.Luck * 100];
         this._currentGrowArr = [this._petInfo.BloodGrow,this._petInfo.AttackGrow,this._petInfo.DefenceGrow,this._petInfo.AgilityGrow,this._petInfo.LuckGrow];
         this._petsBasicInfoView.setInfo(this._petInfo);
      }
      
      private function __toLinkTxtHandler(evt:TextEvent) : void
      {
         SoundManager.instance.playButtonSound();
         StateManager.setState(StateType.DUNGEON_LIST);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._btn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._progress.removeEventListener(PetsAdvancedEvent.PROGRESS_MOVIE_COMPLETE,this.__progressMovieHandler);
         this._petsBasicInfoView.removeEventListener(PetsAdvancedEvent.ALL_MOVIE_COMPLETE,this.__allComplete);
         this._progress.removeEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.removeEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._toLinkTxt.removeEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      public function dispose() : void
      {
         var item:PetsPropItem = null;
         for each(item in this._itemVector)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._itemVector = null;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petsBasicInfoView);
         this._petsBasicInfoView = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._freeBtn);
         this._freeBtn = null;
         ObjectUtils.disposeObject(this._freeTxt);
         this._freeTxt = null;
         ObjectUtils.disposeObject(this._allBtn);
         this._allBtn = null;
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         ObjectUtils.disposeObject(this._bagCellBg);
         this._bagCellBg = null;
         ObjectUtils.disposeObject(this._bagCell);
         this._bagCell = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._starMc);
         this._starMc = null;
         ObjectUtils.disposeObject(this._gradeMc);
         this._gradeMc = null;
         ObjectUtils.disposeObject(this._toLinkTxt);
         this._toLinkTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

