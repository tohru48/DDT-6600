package horse.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddtDeed.DeedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import horse.HorseManager;
   import road7th.utils.MovieClipWrapper;
   import shop.manager.ShopBuyManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HorseFrameRightBottomView extends Sprite implements Disposeable
   {
      
      private var _levelUpBtn:SimpleBitmapButton;
      
      private var _freeUpBtn:SimpleBitmapButton;
      
      private var _freeUpTxt:FilterFrameText;
      
      private var _scb:SelectedCheckButton;
      
      private var _itemCell:HorseFrameRightBottomItemCell;
      
      private var _lastUpClickTime:int = 0;
      
      private var _isPlayingFloatCartoon:Boolean;
      
      protected var _toLinkTxt:FilterFrameText;
      
      public function HorseFrameRightBottomView()
      {
         super();
         this.initView();
         this.initEvent();
         this.guideHandler();
      }
      
      private function guideHandler() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_3))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(544,288),"","",this);
         }
      }
      
      private function initView() : void
      {
         this._itemCell = new HorseFrameRightBottomItemCell(11164);
         PositionUtils.setPos(this._itemCell,"horse.frame.itemCellPos");
         this._levelUpBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelUpBtn");
         this._freeUpBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelUpBtn2");
         this._freeUpTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelUpBtn2Txt");
         this.judgeLevelUpBtn();
         this._scb = ComponentFactory.Instance.creatComponentByStylename("horse.frame.rightBottomScb");
         this._scb.text = LanguageMgr.GetTranslation("horse.rightBottom.scbTxt");
         this._scb.selected = true;
         addChild(this._itemCell);
         addChild(this._levelUpBtn);
         addChild(this._freeUpBtn);
         addChild(this._freeUpTxt);
         addChild(this._scb);
         this._toLinkTxt = ComponentFactory.Instance.creat("petAndHorse.risingStar.toLinkTxt");
         this._toLinkTxt.mouseEnabled = true;
         this._toLinkTxt.htmlText = LanguageMgr.GetTranslation("petAndHorse.risingStar.toLinkTxtValue");
         PositionUtils.setPos(this._toLinkTxt,"petAndHorse.risingStar.toLinkTxtPos3");
         addChild(this._toLinkTxt);
         this._toLinkTxt.visible = false;
         this.refreshFreeTipTxt();
      }
      
      private function initEvent() : void
      {
         this._levelUpBtn.addEventListener(MouseEvent.CLICK,this.levelUpHandler,false,0,true);
         this._freeUpBtn.addEventListener(MouseEvent.CLICK,this.levelUpHandler,false,0,true);
         HorseManager.instance.addEventListener(HorseManager.UP_HORSE_STEP_1,this.upSuccessHandler);
         this._toLinkTxt.addEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function refreshFreeTipTxt(event:Event = null) : void
      {
         var freeCount1:int = DeedManager.instance.getOneBuffData(DeedManager.HORSE_LIGHT);
         if(freeCount1 > 0)
         {
            this._freeUpBtn.visible = true;
            this._freeUpTxt.visible = true;
            this._freeUpTxt.text = "(" + freeCount1 + ")";
            this._levelUpBtn.visible = false;
         }
         else
         {
            this._freeUpTxt.text = "(" + freeCount1 + ")";
            this._freeUpBtn.visible = false;
            this._freeUpTxt.visible = false;
            this._levelUpBtn.visible = true;
         }
      }
      
      private function upSuccessHandler(event:Event) : void
      {
         this._isPlayingFloatCartoon = true;
         var mc:MovieClip = ComponentFactory.Instance.creat("asset.horse.upHorse.flowCartoon");
         PositionUtils.setPos(mc,"horse.frame.upHorseFlowCartoonPos");
         addChild(mc);
         var mcw:MovieClipWrapper = new MovieClipWrapper(mc,true,true);
         mcw.addEventListener(Event.COMPLETE,this.playCompleteHandler);
         SoundManager.instance.play("171");
         this.judgeLevelUpBtn();
      }
      
      private function judgeLevelUpBtn() : void
      {
         if(HorseManager.instance.curLevel >= 80)
         {
            this._levelUpBtn.enable = false;
            this._freeUpBtn.enable = false;
         }
         else
         {
            this._levelUpBtn.enable = true;
            this._freeUpBtn.enable = true;
         }
      }
      
      private function playCompleteHandler(event:Event) : void
      {
         var mcw:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         mcw.removeEventListener(Event.COMPLETE,this.playCompleteHandler);
         HorseManager.instance.upFloatCartoonPlayComplete();
         this._isPlayingFloatCartoon = false;
      }
      
      private function levelUpHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         var nextNeedTotal:int = 0;
         var curHasExp:int = 0;
         var upExp:int = 0;
         var tmp:int = 0;
         SoundManager.instance.play("008");
         if(HorseManager.instance.curLevel >= 80)
         {
            return;
         }
         if(this._isPlayingFloatCartoon)
         {
            return;
         }
         if(getTimer() - this._lastUpClickTime <= 1000)
         {
            return;
         }
         this._lastUpClickTime = getTimer();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var freeCount1:int = DeedManager.instance.getOneBuffData(DeedManager.HORSE_LIGHT);
         if(freeCount1 > 0)
         {
            SocketManager.Instance.out.sendHorseUpHorse(1);
            return;
         }
         var itemCount:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11164);
         if(itemCount <= 0)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("horse.itemConfirmBuyPrompt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.buyConfirm,false,0,true);
            return;
         }
         var useCount:int = 1;
         if(this._scb.selected)
         {
            nextNeedTotal = HorseManager.instance.nextHorseTemplateInfo.Experience;
            curHasExp = HorseManager.instance.curExp;
            upExp = int(ItemManager.Instance.getTemplateById(11164).Property2);
            tmp = Math.ceil((nextNeedTotal - curHasExp) / upExp);
            useCount = Math.min(itemCount,tmp);
         }
         SocketManager.Instance.out.sendHorseUpHorse(useCount);
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_3))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_3);
         }
         NewHandContainer.Instance.clearArrowByID(ArrowType.HORSE_GUIDE);
      }
      
      private function buyConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.buyConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            ShopBuyManager.Instance.buy(11164,1,-1);
         }
      }
      
      private function __toLinkTxtHandler(evt:TextEvent) : void
      {
         SoundManager.instance.playButtonSound();
         StateManager.setState(StateType.DUNGEON_LIST);
      }
      
      private function removeEvent() : void
      {
         this._levelUpBtn.removeEventListener(MouseEvent.CLICK,this.levelUpHandler);
         this._freeUpBtn.removeEventListener(MouseEvent.CLICK,this.levelUpHandler);
         HorseManager.instance.removeEventListener(HorseManager.UP_HORSE_STEP_1,this.upSuccessHandler);
         this._toLinkTxt.removeEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._freeUpBtn);
         this._freeUpBtn = null;
         ObjectUtils.disposeObject(this._freeUpTxt);
         this._freeUpTxt = null;
         ObjectUtils.disposeAllChildren(this);
         this._levelUpBtn = null;
         this._scb = null;
         this._itemCell = null;
         ObjectUtils.disposeObject(this._toLinkTxt);
         this._toLinkTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

