package magicStone.views
{
   import baglocked.BaglockedManager;
   import beadSystem.views.BeadFeedInfoFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicStone.MagicStoneManager;
   import magicStone.components.MgStoneCell;
   import magicStone.components.MgStoneFeedBtn;
   import magicStone.components.MgStoneLockBtn;
   import magicStone.components.MgStoneUtils;
   import road7th.data.DictionaryEvent;
   
   public class MagicStoneBagView extends Sprite implements Disposeable
   {
      
      private static const PAGE_COUNT:int = 2;
      
      private var _bg:MutipleImage;
      
      private var _bagList:MagicStoneBagList;
      
      private var _batCombBtn:SimpleBitmapButton;
      
      private var _lockBtn:MgStoneLockBtn;
      
      private var _sortBtn:TextButton;
      
      private var _prevBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _moneyBg:ScaleBitmapImage;
      
      private var _bindMoneyBg:ScaleBitmapImage;
      
      private var _moneyIcon:Bitmap;
      
      private var _bindMoneyIcon:Bitmap;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _bindMoneyTxt:FilterFrameText;
      
      private var _combineLightMC:MovieClip;
      
      private var _curPage:int;
      
      private var _combineArr:Array = [];
      
      private var _highLevelArr:Array = [];
      
      private var _allExp:int;
      
      private var _isPlayMc:Boolean = false;
      
      private var _updateItem:InventoryItemInfo;
      
      private var _mgStoneFeedBtn:MgStoneFeedBtn;
      
      private var _isSingleFeed:Boolean;
      
      private var _isPassExp:Boolean;
      
      public function MagicStoneBagView()
      {
         super();
         this.initView();
         this.initData();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("magicStone.bagViewBg");
         addChild(this._bg);
         this._bagList = new MagicStoneBagList(0,8,56);
         PositionUtils.setPos(this._bagList,"magicStone.bagListPos");
         addChild(this._bagList);
         this._batCombBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.batCombBtn");
         addChild(this._batCombBtn);
         this._batCombBtn.tipData = LanguageMgr.GetTranslation("magicStone.batCombineTips");
         this._lockBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.lockBtn");
         addChild(this._lockBtn);
         this._lockBtn.tipData = LanguageMgr.GetTranslation("magicStone.lockTips");
         this._sortBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.sortBtn");
         this._sortBtn.text = LanguageMgr.GetTranslation("ddt.beadSystem.sortBtnTxt");
         addChild(this._sortBtn);
         this._mgStoneFeedBtn = ComponentFactory.Instance.creatComponentByStylename("MgStoneFeedBtn");
         this._mgStoneFeedBtn.width = 106;
         this._mgStoneFeedBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._mgStoneFeedBtn.tipData = LanguageMgr.GetTranslation("magicStone.feedTip");
         addChild(this._mgStoneFeedBtn);
         this._moneyBg = ComponentFactory.Instance.creat("magicStone.momeyBg");
         addChild(this._moneyBg);
         this._moneyBg.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         this._bindMoneyBg = ComponentFactory.Instance.creat("magicStone.bindMomeyBg");
         addChild(this._bindMoneyBg);
         var vipNum:int = int(ServerConfigManager.instance.VIPExtraBindMoneyUpper[PlayerManager.Instance.Self.VIPLevel - 1]);
         this._bindMoneyBg.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",(60000 + vipNum).toString());
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.PointCoupon");
         PositionUtils.setPos(this._moneyIcon,"magicStone.moneyIconPos");
         addChild(this._moneyIcon);
         this._bindMoneyIcon = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.ddtMoney1");
         PositionUtils.setPos(this._bindMoneyIcon,"magicStone.bindMoneyIconPos");
         addChild(this._bindMoneyIcon);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("BagMoneyInfoText");
         PositionUtils.setPos(this._moneyTxt,"magicStone.moneyTxtPos");
         addChild(this._moneyTxt);
         this._bindMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("BagGiftInfoText");
         PositionUtils.setPos(this._bindMoneyTxt,"magicStone.bindMoneyTxtPos");
         addChild(this._bindMoneyTxt);
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.prevBtn");
         addChild(this._prevBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.nextBtn");
         addChild(this._nextBtn);
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("magicStone.pageBG");
         addChild(this._pageBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.pageTxt");
         addChild(this._pageTxt);
         this._pageTxt.text = "1/2";
      }
      
      private function initData() : void
      {
         this.curPage = 1;
         this._bagList.setData(PlayerManager.Instance.Self.magicStoneBag);
         this.updateMoney();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         PlayerManager.Instance.Self.magicStoneBag.items.addEventListener(DictionaryEvent.ADD,this.__magicStoneAdd);
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._batCombBtn.addEventListener(MouseEvent.CLICK,this.__batCombBtnClick);
         this._lockBtn.addEventListener(MouseEvent.CLICK,this.__lockBtnClick);
         this._sortBtn.addEventListener(MouseEvent.CLICK,this.__sortBtnClick);
         this._prevBtn.addEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         MagicStoneManager.instance.singleFeedFunc = this.__batCombBtnClick;
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties[PlayerInfo.BandMONEY]) || Boolean(evt.changedProperties[PlayerInfo.MONEY]))
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         if(Boolean(this._moneyTxt))
         {
            this._moneyTxt.text = PlayerManager.Instance.Self.Money.toString();
         }
         if(Boolean(this._bindMoneyTxt))
         {
            this._bindMoneyTxt.text = PlayerManager.Instance.Self.BandMoney.toString();
         }
      }
      
      private function __magicStoneAdd(event:DictionaryEvent) : void
      {
         var item:InventoryItemInfo = InventoryItemInfo(event.data);
         var index:int = (item.Place - MgStoneUtils.BAG_START) / MgStoneUtils.PAGE_COUNT + 1;
         if(index <= 0 || index > PAGE_COUNT || index == this.curPage)
         {
            return;
         }
         this.curPage = index;
         this._bagList.updateBagList();
      }
      
      protected function __cellClick(event:CellEvent) : void
      {
         var info:InventoryItemInfo = null;
         event.stopImmediatePropagation();
         var cell:MgStoneCell = event.data as MgStoneCell;
         if(Boolean(cell))
         {
            info = cell.itemInfo as InventoryItemInfo;
         }
         if(info == null)
         {
            return;
         }
         if(!cell.locked)
         {
            SoundManager.instance.play("008");
            cell.dragStart();
         }
      }
      
      protected function __cellDoubleClick(event:CellEvent) : void
      {
         var info:InventoryItemInfo = null;
         var place:int = 0;
         event.stopImmediatePropagation();
         var cell:MgStoneCell = event.data as MgStoneCell;
         if(Boolean(cell))
         {
            info = cell.itemInfo as InventoryItemInfo;
         }
         if(info == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var magicStoneBag:BagInfo = PlayerManager.Instance.Self.magicStoneBag;
         for(var i:int = 0; i <= 8; i++)
         {
            place = MgStoneUtils.getPlace(i);
            if(!magicStoneBag.getItemAt(place))
            {
               SocketManager.Instance.out.moveMagicStone(info.Place,place);
               break;
            }
         }
      }
      
      protected function __batCombBtnClick(event:MouseEvent) : void
      {
         var start:int = 0;
         var end:int = 0;
         var item:InventoryItemInfo = null;
         var alert:BaseAlerFrame = null;
         this._isSingleFeed = !event;
         SoundManager.instance.play("008");
         this._updateItem = PlayerManager.Instance.Self.magicStoneBag.getItemAt(MagicStoneInfoView.UPDATE_CELL);
         if(!this._updateItem)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.updateCellEmpty"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._updateItem.Level >= 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.updateCellMaxLevel"));
            return;
         }
         var completed:int = this._updateItem.StrengthenExp;
         var maxLevelNeedExp:int = MagicStoneManager.instance.getNeedExp(this._updateItem.TemplateID,10);
         if(!event)
         {
            start = end = MagicStoneManager.instance.singleFeedCell.itemInfo.Place;
         }
         else
         {
            start = MgStoneUtils.BAG_START + (this._curPage - 1) * MgStoneUtils.PAGE_COUNT;
            end = MgStoneUtils.BAG_START + this._curPage * MgStoneUtils.PAGE_COUNT - 1;
         }
         this._allExp = 0;
         this._combineArr = [];
         this._highLevelArr = [];
         for(var i:int = start; i <= end; i++)
         {
            item = PlayerManager.Instance.Self.magicStoneBag.getItemAt(i);
            if(Boolean(item) && !item.goodsLock)
            {
               if(!(item.Level >= 10 && (int(item.Property3) >= 4 || item.Quality >= 4)))
               {
                  if(int(item.Property3) != 0 && (int(item.Property3) >= 3 || item.Level >= 7 || item.Quality >= 4))
                  {
                     this._highLevelArr.push(item);
                  }
                  else
                  {
                     this._allExp += item.StrengthenExp;
                     this._combineArr.push(item.Place);
                     if(this._allExp + completed >= maxLevelNeedExp)
                     {
                        break;
                     }
                  }
               }
            }
         }
         if(this._combineArr.length == 0 && this._highLevelArr.length == 0)
         {
            if(!this._isSingleFeed)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.bagEmpty"));
               return;
            }
            if(item.goodsLock)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.lockedTxt"));
               return;
            }
            if(item.Level >= 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.judgeFeedLevel"));
               return;
            }
         }
         else if(this._combineArr.length > 0)
         {
            if(this._isSingleFeed && completed + item.StrengthenExp >= maxLevelNeedExp)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("magicStone.feedTip2"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onMaxResponse);
               return;
            }
            this._isPlayMc = true;
            this.combineConfirmAlert();
         }
         else if(this._highLevelArr.length > 0)
         {
            this._isPassExp = this._isSingleFeed && completed + item.StrengthenExp >= maxLevelNeedExp;
            this.highLevelAlert();
         }
      }
      
      protected function maxJudge() : void
      {
         var alert2:BaseAlerFrame = null;
         if(this._isPassExp)
         {
            alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("magicStone.feedTip2"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert2.addEventListener(FrameEvent.RESPONSE,this.__onMaxResponse);
         }
         else
         {
            this.combineConfirmAlert();
         }
      }
      
      protected function __onMaxResponse(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._isPlayMc = true;
               this.combineConfirmAlert();
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onMaxResponse);
               ObjectUtils.disposeObject(event.currentTarget);
         }
      }
      
      private function combineConfirmAlert() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("magicStone.getExp",this._allExp),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         var showExp:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("magicStone.ensureAlertTxt");
         showExp.htmlText = LanguageMgr.GetTranslation("magicStone.getExp",this._allExp);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onCombineResponse);
      }
      
      private function highLevelAlert() : void
      {
         var item:InventoryItemInfo = this._highLevelArr.pop();
         var completed:int = this._updateItem.StrengthenExp;
         var maxLevelNeedExp:int = MagicStoneManager.instance.getNeedExp(this._updateItem.TemplateID,10);
         if(completed + this._allExp >= maxLevelNeedExp)
         {
            return;
         }
         var promptAlert:BeadFeedInfoFrame = ComponentFactory.Instance.creat("BeadFeedInfoFrame");
         promptAlert.setBeadName(item.Name + "-Lv" + item.Level);
         promptAlert.itemInfo = item;
         LayerManager.Instance.addToLayer(promptAlert,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         promptAlert.textInput.setFocus();
         promptAlert.addEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
      }
      
      protected function __onConfirmResponse(event:FrameEvent) : void
      {
         var alertInfo:BeadFeedInfoFrame = event.currentTarget as BeadFeedInfoFrame;
         SoundManager.instance.playButtonSound();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(alertInfo.textInput.text == "YES" || alertInfo.textInput.text == "yes")
               {
                  this._allExp = alertInfo.itemInfo.StrengthenExp;
                  this._combineArr = [];
                  this._combineArr.push(alertInfo.itemInfo.Place);
                  if(!this._isSingleFeed)
                  {
                     this.combineConfirmAlert();
                  }
                  else
                  {
                     this.maxJudge();
                  }
                  alertInfo.removeEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
                  ObjectUtils.disposeObject(alertInfo);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.pleaseInputYes"));
               }
               break;
            default:
               if(!this._isSingleFeed && this._highLevelArr.length > 0)
               {
                  this.highLevelAlert();
               }
               alertInfo.removeEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
               ObjectUtils.disposeObject(alertInfo);
         }
      }
      
      protected function __onCombineResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               if(this._isPlayMc)
               {
                  this._isPlayMc = false;
                  break;
               }
               if(!this._isSingleFeed && this._highLevelArr.length > 0)
               {
                  this.highLevelAlert();
               }
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._isPlayMc)
               {
                  if(!this._combineLightMC)
                  {
                     KeyboardShortcutsManager.Instance.forbiddenFull();
                     this._combineLightMC = ComponentFactory.Instance.creat("magicStone.combineLightMc");
                     this._combineLightMC.gotoAndPlay(1);
                     this._combineLightMC.scaleX = this._combineLightMC.scaleY = 0.9;
                     PositionUtils.setPos(this._combineLightMC,"magicStone.combineLightMcPos");
                     this._combineLightMC.addEventListener(Event.ENTER_FRAME,this.__disposeCombineLightMC);
                     LayerManager.Instance.addToLayer(this._combineLightMC,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,true);
                  }
               }
               else
               {
                  this.updateMagicStone();
                  if(this._highLevelArr.length > 0)
                  {
                     this.highLevelAlert();
                  }
               }
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onCombineResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function __disposeCombineLightMC(event:Event) : void
      {
         if(this._combineLightMC.currentFrame == this._combineLightMC.totalFrames)
         {
            this._combineLightMC.gotoAndStop(1);
            this._combineLightMC.removeEventListener(Event.ENTER_FRAME,this.__disposeCombineLightMC);
            ObjectUtils.disposeObject(this._combineLightMC);
            this._combineLightMC = null;
            this._isPlayMc = false;
            KeyboardShortcutsManager.Instance.cancelForbidden();
            this.updateMagicStone();
            if(this._highLevelArr.length > 0)
            {
               this.highLevelAlert();
            }
         }
      }
      
      private function updateMagicStone() : void
      {
         SocketManager.Instance.out.updateMagicStone(this._combineArr);
         var completed:int = this._updateItem.StrengthenExp;
         var needExp:int = MagicStoneManager.instance.getNeedExp(this._updateItem.TemplateID,this._updateItem.StrengthenLevel + 1);
         if(needExp != 0 && this._allExp + completed >= needExp)
         {
            MagicStoneManager.instance.playUpgradeMc();
         }
      }
      
      protected function __lockBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __sortBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var mgStoneBag:BagInfo = PlayerManager.Instance.Self.magicStoneBag;
         PlayerManager.Instance.Self.PropBag.sortBag(BagInfo.MAGICSTONE,mgStoneBag,MgStoneUtils.BAG_START,MgStoneUtils.BAG_END);
      }
      
      protected function __prevBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.curPage > 1)
         {
            --this.curPage;
            this._bagList.updateBagList();
         }
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.curPage < PAGE_COUNT)
         {
            ++this.curPage;
            this._bagList.updateBagList();
         }
      }
      
      public function get curPage() : int
      {
         return this._curPage;
      }
      
      public function set curPage(value:int) : void
      {
         this._curPage = value;
         this._bagList.curPage = this._curPage;
         this._pageTxt.text = this._curPage + "/" + PAGE_COUNT;
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         PlayerManager.Instance.Self.magicStoneBag.items.removeEventListener(DictionaryEvent.ADD,this.__magicStoneAdd);
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._batCombBtn.removeEventListener(MouseEvent.CLICK,this.__batCombBtnClick);
         this._lockBtn.removeEventListener(MouseEvent.CLICK,this.__lockBtnClick);
         this._sortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBtnClick);
         this._prevBtn.removeEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         MagicStoneManager.instance.singleFeedFunc = null;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bagList);
         this._bagList = null;
         ObjectUtils.disposeObject(this._batCombBtn);
         this._batCombBtn = null;
         ObjectUtils.disposeObject(this._lockBtn);
         this._lockBtn = null;
         ObjectUtils.disposeObject(this._sortBtn);
         this._sortBtn = null;
         ObjectUtils.disposeObject(this._prevBtn);
         this._prevBtn = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         ObjectUtils.disposeObject(this._moneyBg);
         this._moneyBg = null;
         ObjectUtils.disposeObject(this._moneyIcon);
         this._moneyIcon = null;
         ObjectUtils.disposeObject(this._moneyTxt);
         this._moneyTxt = null;
         ObjectUtils.disposeObject(this._bindMoneyBg);
         this._bindMoneyBg = null;
         ObjectUtils.disposeObject(this._bindMoneyIcon);
         this._bindMoneyIcon = null;
         ObjectUtils.disposeObject(this._bindMoneyTxt);
         this._bindMoneyTxt = null;
         ObjectUtils.disposeObject(this._mgStoneFeedBtn);
         this._mgStoneFeedBtn = null;
      }
   }
}

