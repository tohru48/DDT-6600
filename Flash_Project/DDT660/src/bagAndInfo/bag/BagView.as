package bagAndInfo.bag
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.ReworkName.ReworkNameConsortia;
   import bagAndInfo.ReworkName.ReworkNameFrame;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.changeSex.ChangeSexAlertFrame;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadBagList;
   import beadSystem.controls.BeadCell;
   import beadSystem.controls.BeadFeedButton;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.controls.BeadLockButton;
   import beadSystem.data.BeadEvent;
   import beadSystem.data.BeadLeadEvent;
   import beadSystem.model.BeadModel;
   import beadSystem.views.BeadFeedInfoFrame;
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.ConsortionBankBagView;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatBugleInputFrame;
   import ddt.view.goods.AddPricePanel;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   import horse.HorseManager;
   import itemActivityGift.ItemActivityGiftManager;
   import itemActivityGift.ItemActivityGiftType;
   import petsBag.PetsBagManager;
   import petsBag.controller.PetBagController;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   import playerDress.views.DressBagView;
   import quest.TrusteeshipManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.DateUtils;
   import setting.view.KeySetFrame;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   import texpSystem.controller.TexpManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import wonderfulActivity.WonderfulActivityManager;
   
   [Event(name="sellstop")]
   [Event(name="sellstart")]
   public class BagView extends Sprite implements Disposeable
   {
      
      public static const FIRST_GET_CARD:String = "firstGetCard";
      
      public static const TABCHANGE:String = "tabChange";
      
      public static const SHOWBEAD:String = "showBeadFrame";
      
      public static const EQUIP:int = 0;
      
      public static const PROP:int = 1;
      
      public static const CARD:int = 2;
      
      public static const CONSORTION:int = 3;
      
      public static const PET:int = 5;
      
      public static const BEAD:int = 21;
      
      public static const DRESS:int = 8;
      
      public static const MAGICHOUSE:int = 51;
      
      public static var isShowCardBag:Boolean = false;
      
      private static const UseColorShellLevel:int = 10;
      
      private var _index:int = 0;
      
      private const STATE_SELL:uint = 1;
      
      private const STATE_BEADFEED:uint = 1;
      
      private var bead_state:uint = 0;
      
      protected var _bgShape:Shape;
      
      protected var _bgShapeII:MovieImage;
      
      private var state:uint = 0;
      
      private var _info:SelfInfo;
      
      protected var _equiplist:BagEquipListView;
      
      protected var _proplist:BagListView;
      
      protected var _petlist:PetBagListView;
      
      protected var _beadList:BeadBagList;
      
      protected var _beadList2:BeadBagList;
      
      protected var _beadList3:BeadBagList;
      
      protected var _dressbagView:DressBagView;
      
      protected var _currIndex:int = 1;
      
      protected var _sellBtn:SellGoodsBtn;
      
      protected var _continueBtn:ContinueGoodsBtn;
      
      protected var _lists:Array;
      
      protected var _currentList:BagListView;
      
      protected var _currentBeadList:BeadBagList;
      
      protected var _breakBtn:BreakGoodsBtn;
      
      protected var _keySortBtn:TextButton;
      
      private var _keySetFrame:KeySetFrame;
      
      private var _chatBugleInputFrame:ChatBugleInputFrame;
      
      protected var _bagType:int;
      
      private var _self:SelfInfo = PlayerManager.Instance.Self;
      
      private var _beadFeedBtn:BeadFeedButton;
      
      private var _beadLockBtn:BeadLockButton;
      
      private var _beadOneKeyBtn:SimpleBitmapButton;
      
      protected var _goldText:FilterFrameText;
      
      protected var _moneyText:FilterFrameText;
      
      protected var _giftText:FilterFrameText;
      
      protected var _goldButton:RichesButton;
      
      protected var _giftButton:RichesButton;
      
      protected var _moneyButton:RichesButton;
      
      protected var _bg:MutipleImage;
      
      protected var _bg1:MovieImage;
      
      protected var _tabBtn1:Sprite;
      
      protected var _tabBtn2:Sprite;
      
      protected var _tabBtn3:Sprite;
      
      protected var _tabBtn4:Sprite;
      
      protected var _cardEnbleFlase:Bitmap;
      
      protected var _itemtabBtn:ScaleFrameImage;
      
      protected var _goodsNumInfoBg:Bitmap;
      
      protected var _goodsNumInfoText:FilterFrameText;
      
      protected var _goodsNumTotalText:FilterFrameText;
      
      protected var _moneyBg:ScaleBitmapImage;
      
      protected var _moneyBg1:ScaleBitmapImage;
      
      protected var _moneyBg2:ScaleBitmapImage;
      
      protected var _moneyBg3:ScaleBitmapImage;
      
      protected var _PointCouponBitmap:Bitmap;
      
      protected var _LiJinBitmap:Bitmap;
      
      protected var _MoneyBitmap:Bitmap;
      
      private var _changeColorController:ChangeColorController;
      
      private var _reworknameView:ReworkNameFrame;
      
      private var _consortaiReworkName:ReworkNameConsortia;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _openBagLock:Boolean = false;
      
      private var _isScreenFood:Boolean = false;
      
      private var _bagList:OutMainListPanel;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pgdn:BaseButton;
      
      private var _pgup:BaseButton;
      
      private var _pageTxtBg:Bitmap;
      
      private var _beadSortBtn:SimpleBitmapButton;
      
      protected var _equipEnbleFlase:Bitmap;
      
      protected var _propEnbleFlase:Bitmap;
      
      protected var _beadEnbleFlase:Bitmap;
      
      private var _disEnabledFilters:Array;
      
      private var _oneKeyFeedMC:MovieClip;
      
      protected var _buttonContainer:Sprite;
      
      protected var _bagArrangeSprite:BagArrangeTipSprite;
      
      protected var _equipSelectedBtn:SelectedButton;
      
      protected var _propSelectedBtn:SelectedButton;
      
      protected var _beadSelectedBtn:SelectedButton;
      
      protected var _dressSelectedBtn:SelectedButton;
      
      public var _bagLockBtn:SimpleBitmapButton;
      
      private var _isUpgradePack:Boolean;
      
      private var _allExp:int;
      
      private var _feedVec:Vector.<Vector.<BeadCell>>;
      
      private var _bindVec:Vector.<Boolean>;
      
      private var _feedID:int = 0;
      
      private var clickSign:int = 0;
      
      private var temInfo:InventoryItemInfo;
      
      private var _currentCell:BagCell;
      
      private var _tmpCell:BagCell;
      
      private var getNewCardMovie:MovieClip;
      
      private var _soundControl:SoundTransform;
      
      public function BagView()
      {
         super();
         this._buttonContainer = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bagView.buttonContainer");
         this.init();
         this.initEvent();
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      protected function init() : void
      {
         this.initBackGround();
         this.initBagList();
         this.initMoneyTexts();
         this.initButtons();
         this.initTabButtons();
         this.initGoodsNumInfo();
         this.set_breakBtn_enable();
         this.set_text_location();
         this.set_btn_location();
         this.setBagType(EQUIP);
      }
      
      protected function initBackGround() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset4");
         addChild(this._bg);
         this._itemtabBtn = ComponentFactory.Instance.creat("bagView.itemTabButton");
         this._equipSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.equipTabBtn");
         this._equipSelectedBtn.mouseEnabled = false;
         this._equipSelectedBtn.mouseChildren = false;
         this._equipSelectedBtn.selected = true;
         addChild(this._equipSelectedBtn);
         this._propSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.propTabBtn");
         this._propSelectedBtn.mouseEnabled = false;
         this._propSelectedBtn.mouseChildren = false;
         addChild(this._propSelectedBtn);
         this._beadSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.beadTabBtn");
         this._beadSelectedBtn.mouseEnabled = false;
         this._beadSelectedBtn.mouseChildren = false;
         this._beadSelectedBtn.visible = false;
         addChild(this._beadSelectedBtn);
         this._dressSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.dressTabBtn");
         this._dressSelectedBtn.mouseEnabled = false;
         this._dressSelectedBtn.mouseChildren = false;
         addChild(this._dressSelectedBtn);
         this._itemtabBtn.setFrame(1);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bgIII");
         this._buttonContainer.addChild(this._bg1);
         this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBG");
         this._buttonContainer.addChild(this._moneyBg);
         this._moneyBg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGI");
         this._buttonContainer.addChild(this._moneyBg1);
         this._moneyBg2 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGII");
         this._buttonContainer.addChild(this._moneyBg2);
         this._bgShape = new Shape();
         this._bgShape.graphics.beginFill(15262671,1);
         this._bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         this._bgShape.graphics.endFill();
         this._bgShape.x = 11;
         this._bgShape.y = 50;
         this._bgShapeII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcardCell.BG");
         addChild(this._bgShapeII);
         this._bgShapeII.visible = false;
         this._bagLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.lockBtn");
         addChild(this._bagLockBtn);
      }
      
      protected function initBagList() : void
      {
         this._equiplist = new BagEquipListView(0);
         this._proplist = new BagListView(1);
         this._petlist = new PetBagListView(1);
         PositionUtils.setPos(this._petlist,"bagAndInfo.bagView.petBag.pos18");
         this._beadList = new BeadBagList(21,32,80);
         this._beadList2 = new BeadBagList(21,81,129);
         this._beadList3 = new BeadBagList(21,130,178);
         this._equiplist.x = this._proplist.x = this._beadList.x = this._beadList2.x = this._beadList3.x = 14;
         this._equiplist.y = this._proplist.y = this._beadList.y = this._beadList2.y = this._beadList3.y = 48;
         this._equiplist.width = this._proplist.width = this._beadList.width = this._beadList2.width = this._beadList3.width = this._petlist.width = 330;
         this._equiplist.height = this._proplist.height = this._beadList.height = this._beadList2.height = this._beadList3.height = this._petlist.height = 320;
         this._proplist.visible = false;
         this._petlist.visible = false;
         this._beadList.visible = false;
         this._beadList2.visible = false;
         this._beadList3.visible = false;
         this._lists = [this._equiplist,this._proplist,this._petlist,this._beadList,this._beadList2,this._beadList3];
         this._currentList = this._equiplist;
         addChild(this._equiplist);
         addChild(this._proplist);
         addChild(this._petlist);
         addChild(this._beadList);
         addChild(this._beadList2);
         addChild(this._beadList3);
      }
      
      private function initMoneyTexts() : void
      {
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("BagMoneyInfoText");
         this._goldText = ComponentFactory.Instance.creatComponentByStylename("BagGoldInfoText");
         this._giftText = ComponentFactory.Instance.creatComponentByStylename("BagGiftInfoText");
         this._buttonContainer.addChild(this._goldText);
         this._buttonContainer.addChild(this._moneyText);
         this._buttonContainer.addChild(this._giftText);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         this._buttonContainer.addChild(this._goldButton);
         var levelNum:int = int(ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel));
         this._giftButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",levelNum.toString());
         this._buttonContainer.addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         this._buttonContainer.addChild(this._moneyButton);
      }
      
      protected function initButtons() : void
      {
         this._sellBtn = ComponentFactory.Instance.creatComponentByStylename("bagSellButton1");
         this._sellBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSell");
         this._buttonContainer.addChild(this._sellBtn);
         this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton1");
         this._continueBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagContinue");
         this._buttonContainer.addChild(this._continueBtn);
         this._breakBtn = ComponentFactory.Instance.creatComponentByStylename("bagBreakButton1");
         this._breakBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
         this._buttonContainer.addChild(this._breakBtn);
         this._keySortBtn = ComponentFactory.Instance.creatComponentByStylename("bagKeySetButton1");
         this._keySortBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSortTxt");
         this._buttonContainer.addChild(this._keySortBtn);
         this._keySortBtn.enable = this._isSkillCanUse();
         this._PointCouponBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.PointCoupon");
         this._buttonContainer.addChild(this._PointCouponBitmap);
         this._LiJinBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.ddtMoney1");
         this._buttonContainer.addChild(this._LiJinBitmap);
         this._MoneyBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.money");
         this._buttonContainer.addChild(this._MoneyBitmap);
      }
      
      public function set sortBagEnable(value:Boolean) : void
      {
         this._keySortBtn.enable = value;
      }
      
      public function set breakBtnEnable(value:Boolean) : void
      {
         this._breakBtn.enable = value;
      }
      
      public function set cardbtnVible(value:Boolean) : void
      {
         this._cardEnbleFlase.visible = value;
      }
      
      public function set cardbtnFilter(filter:Array) : void
      {
         this._cardEnbleFlase.filters = filter;
      }
      
      public function set itemtabBtn(Frame:int) : void
      {
         this._itemtabBtn.setFrame(Frame);
      }
      
      public function set sortBagFilter(filter:Array) : void
      {
         this._keySortBtn.filters = filter;
      }
      
      public function set breakBtnFilter(filter:Array) : void
      {
         this._breakBtn.filters = filter;
      }
      
      public function set tableEnable(value:Boolean) : void
      {
         this._tabBtn3.mouseEnabled = value;
      }
      
      public function switchButtomVisible(value:Boolean) : void
      {
         this._bg1.visible = value;
         this._sellBtn.visible = value;
         this._breakBtn.visible = value;
         this._continueBtn.visible = value;
         this._keySortBtn.visible = value;
         this._goldText.visible = value;
         this._giftButton.visible = value;
         this._giftText.visible = value;
         this._moneyButton.visible = value;
         if(Boolean(this._pgup))
         {
            this._pgup.visible = !value;
         }
         if(Boolean(this._pgdn))
         {
            this._pgdn.visible = !value;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.visible = !value;
         }
         if(Boolean(this._pageTxtBg))
         {
            this._pageTxtBg.visible = !value;
         }
         if(Boolean(this._beadFeedBtn))
         {
            this._beadFeedBtn.visible = !value;
         }
         if(Boolean(this._beadLockBtn))
         {
            this._beadLockBtn.visible = !value;
         }
         if(Boolean(this._beadOneKeyBtn))
         {
            this._beadOneKeyBtn.visible = !value;
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.visible = !value;
         }
         this.enableBeadFunctionBtns(!value);
         if(Boolean(this._moneyBg1))
         {
            this._moneyBg1.visible = value;
         }
         if(Boolean(this._moneyBg2))
         {
            this._moneyBg2.visible = value;
         }
         if(Boolean(this._LiJinBitmap))
         {
            this._LiJinBitmap.visible = value;
         }
         if(Boolean(this._MoneyBitmap))
         {
            this._MoneyBitmap.visible = value;
         }
      }
      
      public function enableBeadFunctionBtns(value:Boolean) : void
      {
         if(Boolean(this._beadFeedBtn))
         {
            this._beadFeedBtn.enable = value;
         }
         if(Boolean(this._beadLockBtn))
         {
            this._beadLockBtn.enable = value;
         }
         if(Boolean(this._beadOneKeyBtn))
         {
            this._beadOneKeyBtn.enable = value;
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.enable = value;
         }
      }
      
      public function initBeadButton() : void
      {
         this._pgup = ComponentFactory.Instance.creatComponentByStylename("beadSystem.prePageBtn");
         addChild(this._pgup);
         this._pgdn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.nextPageBtn");
         addChild(this._pgdn);
         this._pageTxtBg = ComponentFactory.Instance.creatBitmap("beadSystem.pageTxt.bg");
         addChild(this._pageTxtBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.pageTxt");
         addChild(this._pageTxt);
         this._pageTxt.text = "1/3";
         this._pgup.addEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.addEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this._beadSortBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.sortBtn");
         this._beadSortBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick,false,0,true);
         addChild(this._beadSortBtn);
         this._beadFeedBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedbtn1");
         this._beadFeedBtn.width = 106;
         this._beadFeedBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadFeedBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadTip");
         addChild(this._beadFeedBtn);
         this._beadLockBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.lockbtn1");
         this._beadLockBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadLockBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadLockTip");
         addChild(this._beadLockBtn);
         this._beadOneKeyBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedAllBtn");
         this._beadOneKeyBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadOneKeyBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadOneKeyTip");
         addChild(this._beadOneKeyBtn);
         this._beadOneKeyBtn.addEventListener(MouseEvent.CLICK,this.__oneKeyFeedClick);
      }
      
      public function adjustBeadBagPage(onlyNotBind:Boolean) : void
      {
         var bead:InventoryItemInfo = null;
         var index:int = 0;
         var leastPlace:int = int.MAX_VALUE;
         for each(bead in this._info.BeadBag.items)
         {
            if(bead.Place < leastPlace && bead.Place > 31 && (!onlyNotBind || !bead.IsBinds))
            {
               leastPlace = bead.Place;
            }
         }
         index = (leastPlace - 32) / 49 + 1;
         if(index <= 0 || index > 3)
         {
            index = 1;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.text = index + "/3";
         }
         this._beadList.visible = index == 1;
         this._beadList2.visible = index == 2;
         this._beadList3.visible = index == 3;
         this._currentBeadList = [this._beadList,this._beadList2,this._beadList3][index - 1];
      }
      
      public function __oneKeyFeedClick(pEvent:MouseEvent) : void
      {
         var allExp:int = 0;
         var isBind:Boolean = false;
         var i:int = 0;
         var cell:BeadCell = null;
         var desFlag:Boolean = false;
         var j:int = 0;
         SoundManager.instance.play("008");
         if(BeadModel.beadCanUpgrade)
         {
            if(int(PlayerManager.Instance.Self.embedUpLevelCell.itemInfo.Hole1) == 19)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
               return;
            }
            allExp = 0;
            isBind = false;
            this._feedID = 0;
            if(!this._feedVec)
            {
               this._feedVec = new Vector.<Vector.<BeadCell>>(8);
               this._bindVec = new Vector.<Boolean>(8);
            }
            for(i = 0; i < 8; i++)
            {
               if(!this._feedVec[i])
               {
                  this._feedVec[i] = new Vector.<BeadCell>();
                  this._bindVec[i] = false;
               }
               else
               {
                  this._feedVec[i].length = 0;
               }
            }
            for each(cell in this._currentBeadList.BeadCells)
            {
               if(Boolean(cell.info) && !cell.itemInfo.IsUsed)
               {
                  if(cell.itemInfo.Hole1 < 13)
                  {
                     this._feedVec[0].push(cell);
                     allExp += cell.itemInfo.Hole2;
                     cell.locked = true;
                     if(!this._bindVec[0] && cell.itemInfo.IsBinds)
                     {
                        this._bindVec[0] = true;
                     }
                  }
                  else if(cell.itemInfo.Hole1 == 13)
                  {
                     this._feedVec[1].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 14)
                  {
                     this._feedVec[2].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 15)
                  {
                     this._feedVec[3].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 16)
                  {
                     this._feedVec[4].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 17)
                  {
                     this._feedVec[5].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 18)
                  {
                     this._feedVec[6].push(cell);
                  }
                  else if(cell.itemInfo.Hole1 == 19)
                  {
                     this._feedVec[7].push(cell);
                  }
               }
            }
            if(allExp == 0)
            {
               desFlag = true;
               for(j = 1; j < 8; j++)
               {
                  if(this._feedVec[j].length > 0)
                  {
                     desFlag = false;
                     break;
                  }
               }
               if(desFlag)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.noBeadToFeed"));
               }
               else
               {
                  this._feedID = j;
                  this.checkBoxPrompts(this._feedID);
               }
               return;
            }
            this._allExp = allExp;
            this.boxPrompts(this._bindVec[0]);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoFeedBead"));
         }
      }
      
      private function checkNextBox() : void
      {
         ++this._feedID;
         if(this._feedID < 5)
         {
            this.checkBoxPrompts(this._feedID);
         }
      }
      
      private function checkBoxPrompts(id:int) : void
      {
         var i:int = 0;
         var promptAlert:BeadFeedInfoFrame = null;
         this._allExp = 0;
         var length:int = int(this._feedVec[id].length);
         if(length > 0)
         {
            for(i = 0; i < length; i++)
            {
               this._allExp += this._feedVec[id][i].itemInfo.Hole2;
               this._feedVec[id][i].locked = true;
               if(!this._bindVec[id] && this._feedVec[id][i].itemInfo.IsBinds)
               {
                  this._bindVec[id] = true;
               }
            }
            promptAlert = ComponentFactory.Instance.creat("BeadFeedInfoFrame");
            promptAlert.setBeadName(this._feedVec[id][0].tipData["beadName"]);
            LayerManager.Instance.addToLayer(promptAlert,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            promptAlert.textInput.setFocus();
            promptAlert.isBind = this._bindVec[id];
            promptAlert.addEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
         }
         else
         {
            ++this._feedID;
            if(this._feedID < 5)
            {
               this.checkBoxPrompts(this._feedID);
            }
            else
            {
               this._feedID = 0;
            }
         }
      }
      
      private function boxPrompts(isBind:Boolean) : void
      {
         var bindAlert:BaseAlerFrame = null;
         var alert:BaseAlerFrame = null;
         var showExp:FilterFrameText = null;
         if(isBind && !BeadModel.isBeadCellIsBind)
         {
            bindAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            bindAlert.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            showExp = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowExpTextOneFeed");
            showExp.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._allExp);
            alert.addChild(showExp);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
      }
      
      protected function __onConfigResponse(event:FrameEvent) : void
      {
         var length:int = 0;
         var i:int = 0;
         var alertInfo:BeadFeedInfoFrame = event.currentTarget as BeadFeedInfoFrame;
         SoundManager.instance.playButtonSound();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(alertInfo.textInput.text == "YES" || alertInfo.textInput.text == "yes")
               {
                  this.boxPrompts(alertInfo.isBind);
                  alertInfo.removeEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
                  ObjectUtils.disposeObject(alertInfo);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadPromptInfo"));
               }
               break;
            default:
               length = int(this._feedVec[this._feedID].length);
               for(i = 0; i < length; i++)
               {
                  this._feedVec[this._feedID][i].locked = false;
               }
               alertInfo.removeEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
               ObjectUtils.disposeObject(alertInfo);
         }
      }
      
      protected function __onBindRespones(pEvent:FrameEvent) : void
      {
         var length:int = 0;
         var i:int = 0;
         var alert:BaseAlerFrame = null;
         var showExp:FilterFrameText = null;
         SoundManager.instance.playButtonSound();
         switch(pEvent.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               length = int(this._feedVec[this._feedID].length);
               for(i = 0; i < length; i++)
               {
                  this._feedVec[this._feedID][i].locked = false;
               }
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               showExp = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowExpTextOneFeed");
               showExp.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._allExp);
               alert.addChild(showExp);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      protected function __onFeedResponse(event:FrameEvent) : void
      {
         var length:int = 0;
         var i:int = 0;
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               length = int(this._feedVec[this._feedID].length);
               for(i = 0; i < length; i++)
               {
                  this._feedVec[this._feedID][i].locked = false;
               }
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._feedVec[this._feedID].length > 0)
               {
                  if(!this._oneKeyFeedMC)
                  {
                     this._oneKeyFeedMC = ClassUtils.CreatInstance("beadSystem.oneKeyFeed.MC");
                     this._oneKeyFeedMC.gotoAndPlay(1);
                     this._oneKeyFeedMC.scaleX = this._oneKeyFeedMC.scaleY = 0.9;
                     this._oneKeyFeedMC.x = 707;
                     this._oneKeyFeedMC.y = 295;
                     this._oneKeyFeedMC.addEventListener("oneKeyComplete",this.__disposeOneKeyMC);
                     LayerManager.Instance.addToLayer(this._oneKeyFeedMC,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,true);
                  }
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoBead"));
               }
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __disposeOneKeyMC(pEvent:Event) : void
      {
         var c:BeadCell = null;
         var length:int = 0;
         var i:int = 0;
         var arr:Array = new Array();
         for each(c in this._feedVec[this._feedID])
         {
            if(Boolean(c.info) && !c.itemInfo.IsUsed)
            {
               arr.push(c.beadPlace);
            }
         }
         SocketManager.Instance.out.sendBeadUpgrade(arr);
         length = int(this._feedVec[this._feedID].length);
         for(i = 0; i < length; i++)
         {
            this._feedVec[this._feedID][i].locked = false;
         }
         this._oneKeyFeedMC.removeEventListener("oneKeyComplete",this.__disposeOneKeyMC);
         this._oneKeyFeedMC.stop();
         ObjectUtils.disposeObject(this._oneKeyFeedMC);
         this._oneKeyFeedMC = null;
         if(this._allExp + BeadModel.upgradeCellInfo.Hole2 >= ServerConfigManager.instance.getBeadUpgradeExp()[BeadModel.upgradeCellInfo.Hole1 + 1])
         {
            beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.PLAYUPGRADEMC));
         }
         this.checkNextBox();
         if(SharedManager.Instance.beadLeadTaskStep == 4 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= BagAndGiftFrame.BEAD_OPEN_LEVEL && PlayerManager.Instance.Self.Grade <= BagAndGiftFrame.BEAD_OPEN_LEVEL + 5)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_COMBINCLICK);
               BeadLeadManager.Instance.leadEquipBead(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               SharedManager.Instance.beadLeadTaskStep = 5;
               BeadLeadManager.Instance.taskComplete = true;
               TaskManager.instance.checkQuest(TaskManager.BEADLEAD_TASKTYPE2,1,0);
               SharedManager.Instance.save();
            }
         }
      }
      
      protected function initTabButtons() : void
      {
         this._tabBtn1 = new Sprite();
         this._tabBtn1.graphics.beginFill(255,1);
         this._tabBtn1.graphics.drawRoundRect(348,39,51,131,15,15);
         this._tabBtn1.graphics.endFill();
         this._tabBtn1.alpha = 0;
         this._tabBtn1.buttonMode = true;
         addChild(this._tabBtn1);
         this._tabBtn2 = new Sprite();
         this._tabBtn2.graphics.beginFill(255,1);
         this._tabBtn2.graphics.drawRoundRect(349,183,51,131,15,15);
         this._tabBtn2.graphics.endFill();
         this._tabBtn2.alpha = 0;
         this._tabBtn2.buttonMode = true;
         addChild(this._tabBtn2);
         this._tabBtn3 = new Sprite();
         this._tabBtn3.graphics.beginFill(255,1);
         this._tabBtn3.graphics.drawRoundRect(349,327,51,131,15,15);
         this._tabBtn3.graphics.endFill();
         this._tabBtn3.alpha = 0;
         this._tabBtn3.buttonMode = true;
         this._tabBtn3.visible = false;
         addChild(this._tabBtn3);
         this._tabBtn4 = new Sprite();
         this._tabBtn4.graphics.beginFill(255,1);
         this._tabBtn4.graphics.drawRoundRect(349,327,51,131,15,15);
         this._tabBtn4.graphics.endFill();
         this._tabBtn4.alpha = 0;
         this._tabBtn4.buttonMode = true;
         addChild(this._tabBtn4);
         this._cardEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.cardbtn.enblefalse");
         this._cardEnbleFlase.visible = false;
         addChild(this._buttonContainer);
      }
      
      private function initGoodsNumInfo() : void
      {
         this._goodsNumInfoText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumText");
         this._goodsNumTotalText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumTotalText");
         this._goodsNumTotalText.text = "/ " + String(BagInfo.MAXPROPCOUNT + 1);
      }
      
      private function updateView() : void
      {
         this.updateMoney();
         this.updateBagList();
      }
      
      protected function updateBagList() : void
      {
         if(Boolean(this._info))
         {
            this._equiplist.currentBagType = this._bagType;
            this._equiplist.setData(this._info.Bag);
            if(this._isScreenFood)
            {
               this._petlist.setData(this._info.PropBag);
            }
            else
            {
               this._proplist.setData(this._info.PropBag);
            }
            if(this._bagType != PET)
            {
               if(Boolean(this._beadList))
               {
                  this._beadList.setData(this._info.BeadBag);
               }
               if(Boolean(this._beadList2))
               {
                  this._beadList2.setData(this._info.BeadBag);
               }
               if(Boolean(this._beadList3))
               {
                  this._beadList3.setData(this._info.BeadBag);
               }
            }
         }
         else
         {
            this._equiplist.setData(null);
            this._proplist.setData(null);
            this._petlist.setData(null);
         }
      }
      
      private function __showBead(event:BagEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadToBeadBag"));
      }
      
      public function createCard() : void
      {
         if(!isShowCardBag)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CARD_SYSTEM);
            SocketManager.Instance.out.getPlayerCardInfo(PlayerManager.Instance.Self.ID);
         }
         else
         {
            if(this._bagList == null)
            {
               this._bagList = ComponentFactory.Instance.creatComponentByStylename("cardSyste.cardBagList");
               addChild(this._bagList);
               this._bagList.vectorListModel.appendAll(CardControl.Instance.model.getBagListData());
               DragManager.ListenWheelEvent(this._bagList.onMouseWheel);
               DragManager.changeCardState(CardControl.Instance.setSignLockedCardNone);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
            }
            this.setBagType(CARD);
            dispatchEvent(new CardEvent(CardEvent.SETSELECTCARD_COMPLETE));
         }
      }
      
      private function __onUIComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            isShowCardBag = true;
            this.createCard();
         }
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      private function __upData(event:DictionaryEvent) : void
      {
         var itemDate:Array = null;
         var newArr:Array = null;
         var info:CardInfo = event.data as CardInfo;
         var m:int = info.Place % 4 == 0 ? int(info.Place / 4 - 2) : int(info.Place / 4 - 1);
         var n:int = info.Place % 4 == 0 ? 4 : int(info.Place % 4);
         if(this._bagList.vectorListModel.elements[m] == null)
         {
            itemDate = new Array();
            itemDate[0] = m + 1;
            itemDate[n] = info;
            this._bagList.vectorListModel.append(itemDate);
         }
         else
         {
            newArr = this._bagList.vectorListModel.elements[m] as Array;
            newArr[n] = info;
            this._bagList.vectorListModel.replaceAt(m,newArr);
         }
      }
      
      private function __remove(event:DictionaryEvent) : void
      {
         var info:CardInfo = event.data as CardInfo;
         var m:int = info.Place % 4 == 0 ? int(info.Place / 4 - 2) : int(info.Place / 4 - 1);
         var n:int = info.Place % 4 == 0 ? 4 : int(info.Place % 4);
         var newArr:Array = this._bagList.vectorListModel.elements[m] as Array;
         newArr[n] = null;
         this._bagList.vectorListModel.replaceAt(m,newArr);
      }
      
      protected function initEvent() : void
      {
         this._sellBtn.addEventListener(MouseEvent.CLICK,this.__sellClick);
         this._breakBtn.addEventListener(MouseEvent.CLICK,this.__breakClick);
         this._equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist.addEventListener(Event.CHANGE,this.__listChange);
         this._proplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         if(Boolean(this._petlist))
         {
            this._petlist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._beadList2.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._beadList3.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         this._tabBtn1.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.addEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.addEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.addEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         CellMenu.instance.addEventListener(CellMenu.COLOR_CHANGE,this.__cellColorChange);
         CellMenu.instance.addEventListener(CellMenu.SELL,this.__cellSell);
         this._keySortBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick);
         this._keySortBtn.addEventListener(MouseEvent.ROLL_OVER,this.__bagArrangeOver);
         this._keySortBtn.addEventListener(MouseEvent.ROLL_OUT,this.__bagArrangeOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         beadSystemManager.Instance.addEventListener(BeadEvent.AUTOOPENBEAD,this.__onAutoOpenBeadChanged);
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.addEventListener(MouseEvent.CLICK,this.bagLockHandler,false,0,true);
         }
         this.adjustEvent();
      }
      
      protected function bagLockHandler(event:MouseEvent) : void
      {
         this.__openSettingLock(null);
      }
      
      protected function __bagArrangeOut(event:MouseEvent) : void
      {
         if(this._bagType == BEAD)
         {
            return;
         }
         if(Boolean(this._bagArrangeSprite) && !this.containPoint(event.localX,event.localY))
         {
            removeChild(this._bagArrangeSprite);
         }
      }
      
      private function containPoint(x:int, y:int) : Boolean
      {
         if(x > 0 && x < this._bagArrangeSprite.width && y <= 3 && y > -this._bagArrangeSprite.height)
         {
            return true;
         }
         return false;
      }
      
      private function __onAutoOpenBeadChanged(pEvent:BeadEvent) : void
      {
         if(!this._beadOneKeyBtn || !this._beadLockBtn || !this._beadFeedBtn)
         {
            return;
         }
         if(pEvent.CellId == 0)
         {
            this._beadOneKeyBtn.enable = true;
            this._beadLockBtn.enable = true;
            this._beadFeedBtn.enable = true;
         }
         else if(pEvent.CellId == 1)
         {
            this._beadOneKeyBtn.enable = false;
            this._beadLockBtn.enable = false;
            this._beadFeedBtn.enable = false;
         }
      }
      
      private function isInBag(item:InventoryItemInfo, bagList:BeadBagList) : Boolean
      {
         if(item.Place >= bagList._startIndex && item.Place <= bagList._stopIndex)
         {
            return true;
         }
         return false;
      }
      
      protected function __onBeadBagChanged(event:DictionaryEvent) : void
      {
         var tmp:int = 0;
         var i:int = 0;
         if(this._bagType != BEAD)
         {
            return;
         }
         var arr:Array = [this._beadList,this._beadList2,this._beadList3];
         var toPage:int = 1;
         var item:InventoryItemInfo = InventoryItemInfo(event.data);
         if(item.Place < 32)
         {
            return;
         }
         if(Boolean(this._info.BeadBag.getItemAt(item.Place)))
         {
            tmp = 1;
            for(i = 0; i < arr.length; i++)
            {
               if(this.isInBag(item,arr[i]))
               {
                  tmp = i + 1;
                  break;
               }
            }
            toPage = tmp > toPage ? tmp : toPage;
         }
         if(toPage > 3 || toPage < 1)
         {
            toPage = 1;
         }
         if(this._currIndex == toPage)
         {
            return;
         }
         this._currIndex = toPage;
         this._beadList.visible = toPage == 1;
         this._beadList2.visible = toPage == 2;
         this._beadList3.visible = toPage == 3;
         this._pageTxt.text = toPage + "/3";
         this._currentBeadList = arr[toPage - 1];
      }
      
      private function __pgupHandler(pEvent:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currIndex == 1)
         {
            this._currIndex = 3;
            this._beadList.visible = false;
            this._beadList2.visible = false;
            this._beadList3.visible = true;
            this._pageTxt.text = "3/3";
            this._currentBeadList = this._beadList3;
         }
         else if(this._currIndex == 2)
         {
            this._currIndex = 1;
            this._beadList.visible = true;
            this._beadList2.visible = false;
            this._beadList3.visible = false;
            this._pageTxt.text = "1/3";
            this._currentBeadList = this._beadList;
         }
         else if(this._currIndex == 3)
         {
            this._currIndex = 2;
            this._beadList.visible = false;
            this._beadList2.visible = true;
            this._beadList3.visible = false;
            this._pageTxt.text = "2/3";
            this._currentBeadList = this._beadList2;
         }
      }
      
      private function setCurrPage(pIndex:int) : void
      {
      }
      
      public function __pgdnHandler(pEvent:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currIndex == 1)
         {
            this._currIndex = 2;
            this._beadList.visible = false;
            this._beadList2.visible = true;
            this._beadList3.visible = false;
            this._pageTxt.text = "2/3";
            this._currentBeadList = this._beadList2;
         }
         else if(this._currIndex == 2)
         {
            this._currIndex = 3;
            this._beadList.visible = false;
            this._beadList2.visible = false;
            this._beadList3.visible = true;
            this._pageTxt.text = "3/3";
            this._currentBeadList = this._beadList3;
         }
         else if(this._currIndex == 3)
         {
            this._currIndex = 1;
            this._beadList.visible = true;
            this._beadList2.visible = false;
            this._beadList3.visible = false;
            this._pageTxt.text = "1/3";
            this._currentBeadList = this._beadList;
         }
      }
      
      protected function adjustEvent() : void
      {
      }
      
      protected function __useColorShell(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var result:Boolean = pkg.readBoolean();
         if(result)
         {
            SoundManager.instance.play("063");
         }
      }
      
      protected function removeEvents() : void
      {
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(Boolean(this._proplist))
         {
            this._proplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._proplist))
         {
            this._proplist.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._petlist))
         {
            this._petlist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList2))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList3))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._tabBtn1))
         {
            this._tabBtn1.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn2))
         {
            this._tabBtn2.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn3))
         {
            this._tabBtn3.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._pgup))
         {
            this._pgup.removeEventListener(MouseEvent.CLICK,this.__pgupHandler);
         }
         if(Boolean(this._pgdn))
         {
            this._pgdn.removeEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
         }
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.removeEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.removeEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.removeEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         CellMenu.instance.removeEventListener(CellMenu.COLOR_CHANGE,this.__cellColorChange);
         CellMenu.instance.removeEventListener(CellMenu.SELL,this.__cellSell);
         if(Boolean(this._keySortBtn))
         {
            this._keySortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
            this._keySortBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__bagArrangeOver);
            this._keySortBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__bagArrangeOut);
         }
         PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.removeEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
         }
         BagLockedController.Instance.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         beadSystemManager.Instance.removeEventListener(BeadEvent.AUTOOPENBEAD,this.__onAutoOpenBeadChanged);
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.removeEventListener(MouseEvent.CLICK,this.bagLockHandler);
         }
      }
      
      protected function __itemtabBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._tabBtn1:
               if(this._bagType == EQUIP)
               {
                  return;
               }
               this._itemtabBtn.setFrame(1);
               this.setBagType(EQUIP);
               this.refreshSelectedButton(1);
               break;
            case this._tabBtn2:
               if(this._bagType == PROP || this._bagType == PET)
               {
                  return;
               }
               this._itemtabBtn.setFrame(2);
               this.setBagType(this._isScreenFood ? PET : PROP);
               this.refreshSelectedButton(2);
               break;
            case this._tabBtn3:
               if(PlayerManager.Instance.Self.Grade < 16)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.openBeadBtn.text",16));
                  return;
               }
               if(this._bagType == BEAD)
               {
                  return;
               }
               this.setBagType(BEAD);
               this._itemtabBtn.setFrame(3);
               this.refreshSelectedButton(3);
               break;
            case this._tabBtn4:
               this.setBagType(DRESS);
               this.refreshSelectedButton(4);
         }
      }
      
      public function leadBeadSPaling() : void
      {
         var leadGetBead:InventoryItemInfo = null;
         var bead:InventoryItemInfo = null;
         var leastPlace:int = int.MAX_VALUE;
         for each(bead in this._info.BeadBag.items)
         {
            if(bead.TemplateID == BeadLeadManager.BEAD_ID && bead.Hole1 == 3)
            {
               leastPlace = bead.Place;
               leadGetBead = bead;
               break;
            }
         }
         if(leadGetBead == null)
         {
            return;
         }
         var index:int = (leastPlace - 32) / 49 + 1;
         if(index <= 0 || index > 3)
         {
            index = 1;
         }
         this._currentBeadList = [this._beadList,this._beadList2,this._beadList3][index - 1];
         var cell:BeadCell = this._currentBeadList.BeadCells[leadGetBead.Place] as BeadCell;
         if(cell == null)
         {
            return;
         }
         var row:int = (leadGetBead.Place - 32) / 7 + 1;
         var column:int = (leadGetBead.Place - 32) % 7 + 1;
         var point:Point = new Point();
         point.x = 508 + 46 * column;
         point.y = 60 + 46 * row;
         var txtPos:Point = new Point(point.x - 137,point.y - 92);
         BeadLeadManager.Instance.arrowPos = point;
         BeadLeadManager.Instance.txtPos = txtPos;
         BeadLeadManager.Instance.upLevelCellSpaling = true;
         BeadLeadManager.Instance.dispatchEvent(new BeadLeadEvent(BeadLeadEvent.SPALINGUPLEVELCELL));
      }
      
      public function enableOrdisableSB(enable:Boolean) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.enable = enable;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.enable = enable;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.enable = enable;
         }
         if(Boolean(this._tabBtn1))
         {
            this._tabBtn1.visible = enable;
         }
         if(Boolean(this._tabBtn2))
         {
            this._tabBtn2.visible = enable;
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.visible = enable;
         }
      }
      
      public function enableDressSelectedBtn(enable:Boolean) : void
      {
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.enable = enable;
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.visible = enable;
         }
      }
      
      public function showOrHideSB(isShow:Boolean) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.visible = isShow;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.visible = isShow;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.visible = isShow;
         }
      }
      
      private function refreshSelectedButton(tag:int) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.selected = tag == 1;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.selected = tag == 2;
         }
         if(Boolean(this._beadSelectedBtn))
         {
            this._beadSelectedBtn.selected = tag == 3;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.selected = tag == 4;
         }
      }
      
      public function setBagType(type:int) : void
      {
         var thisClass:String = null;
         if(type != BEAD)
         {
            this._currIndex = 1;
            if(Boolean(this._beadList))
            {
               this._currentBeadList = this._beadList;
            }
            if(Boolean(this._pageTxt))
            {
               this._pageTxt.text = "1/3";
            }
         }
         if(Boolean(this._equipEnbleFlase))
         {
            this.btnReable();
         }
         this._bagType = type;
         if(type == PET)
         {
            this._itemtabBtn.setFrame(PROP + 1);
            this.refreshSelectedButton(2);
         }
         if(type == EQUIP)
         {
            this._itemtabBtn.setFrame(1);
            this.refreshSelectedButton(1);
         }
         else if(type == PROP)
         {
            this._itemtabBtn.setFrame(PROP + 1);
            this.refreshSelectedButton(2);
         }
         else if(type == CARD)
         {
            type = 0;
            this._itemtabBtn.setFrame(type + 1);
            this.refreshSelectedButton(1);
         }
         else if(type == BEAD)
         {
            this._itemtabBtn.setFrame(3);
            this.refreshSelectedButton(3);
            this.switchButtomVisible(false);
         }
         else if(type == DRESS)
         {
            PlayerDressManager.instance.loadPlayerDressModule(this.showDressBagView);
            this.refreshSelectedButton(4);
         }
         dispatchEvent(new Event(TABCHANGE));
         this._buttonContainer.visible = this._bagType != DRESS;
         this._bgShape.visible = this._bagType == EQUIP || this._bagType == PROP || this._bagType == PET;
         this._equiplist.visible = this._bagType == EQUIP;
         this._proplist.visible = this._bagType == PROP;
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.visible = this._bagType == DRESS;
         }
         if(Boolean(this._petlist))
         {
            this._petlist.visible = this._bagType == PET;
         }
         if(Boolean(this._beadList))
         {
            this._beadList.visible = this._bagType == BEAD;
            if(this._beadList.visible)
            {
               this._beadList2.visible = this._bagType == BEAD;
               this._beadList3.visible = this._bagType == BEAD;
               this._currentBeadList = this._beadList;
               this._beadList2.visible = false;
               this._beadList3.visible = false;
            }
            else
            {
               this._beadList2.visible = this._bagType == BEAD;
               this._beadList3.visible = this._bagType == BEAD;
               this._currentBeadList = null;
            }
         }
         if(Boolean(this._bagList))
         {
            this._bagList.visible = this._bgShapeII.visible = this._bagType == CARD;
         }
         this.set_breakBtn_enable();
         this._sellBtn.enable = this._continueBtn.enable = this._bagType != CARD;
         if(this._bagType == EQUIP || this._bagType == PROP || this._bagType == PET)
         {
            this._sellBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            this._continueBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         if(Boolean(this._itemtabBtn))
         {
            this._itemtabBtn.visible = true;
         }
         if(this._bagType == CARD)
         {
            this._sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this.btnUnable();
            this._itemtabBtn.visible = false;
            this.showOrHideSB(false);
            if(Boolean(this._bagLockBtn))
            {
               this._bagLockBtn.x = 235;
               this._bagLockBtn.y = -18;
            }
         }
         else
         {
            this.showOrHideSB(true);
            thisClass = getQualifiedClassName(this);
            if(Boolean(this._bagLockBtn) && thisClass != "email.view::EmailBagView")
            {
               this._bagLockBtn.x = 259;
               this._bagLockBtn.y = -25;
            }
         }
         if(this._bagType == EQUIP)
         {
         }
         if(this._bagType == BEAD)
         {
            PositionUtils.setPos(this._moneyText,"moneyTextPosUnderBeadBag");
            this._moneyBg.width = this._goldButton.width = PositionUtils.creatPoint("moneyTextBgWidth").x;
            PositionUtils.setPos(this._PointCouponBitmap,"PointCouponBitmapPosUnderBeadBag");
            PositionUtils.setPos(this._goldButton,"goldButtonBitmapPosUnderBeadBag");
            PositionUtils.setPos(this._moneyBg,"goldButtonBitmapPosUnderBeadBag");
            this.adjustBeadBagPage(false);
         }
         else
         {
            PositionUtils.setPos(this._moneyText,"moneyTextPosUnderCommonBag");
            this._moneyBg.width = this._goldButton.width = PositionUtils.creatPoint("moneyTextBgWidth").x;
            this._moneyBg.x = 18;
            this._PointCouponBitmap.x = 18;
         }
      }
      
      protected function showDressBagView() : void
      {
         if(!this._dressbagView)
         {
            this._dressbagView = ComponentFactory.Instance.creatCustomObject("playerDress.dressBagView");
            addChild(this._dressbagView);
            this._dressbagView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._dressbagView.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._dressbagView.visible = true;
            this._dressbagView.updateBagList();
         }
      }
      
      private function btnUnable() : void
      {
         this._tabBtn1.buttonMode = false;
         this._tabBtn1.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.buttonMode = false;
         this._tabBtn2.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.buttonMode = false;
         this._tabBtn3.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.buttonMode = false;
         this._tabBtn4.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._disEnabledFilters = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
         this._equipEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.equipbtn.enblefalse");
         this._equipEnbleFlase.visible = false;
         addChild(this._equipEnbleFlase);
         this._equipEnbleFlase.filters = this._disEnabledFilters;
         this._propEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.propbtn.enblefalse");
         this._propEnbleFlase.visible = false;
         addChild(this._propEnbleFlase);
         this._propEnbleFlase.filters = this._disEnabledFilters;
         this._beadEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.cardbtn.enblefalse");
         this._beadEnbleFlase.visible = false;
         addChild(this._beadEnbleFlase);
         this._beadEnbleFlase.filters = this._disEnabledFilters;
         PositionUtils.setPos(this._equipEnbleFlase,"equipEnbleFlasePos");
         PositionUtils.setPos(this._propEnbleFlase,"propEnbleFlasePos");
         PositionUtils.setPos(this._beadEnbleFlase,"beadEnbleFlasePos");
      }
      
      private function btnReable() : void
      {
         this._tabBtn1.buttonMode = true;
         this._tabBtn1.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.buttonMode = true;
         this._tabBtn2.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.buttonMode = true;
         this._tabBtn3.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.buttonMode = true;
         this._tabBtn4.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._disEnabledFilters = null;
         removeChild(this._equipEnbleFlase);
         this._equipEnbleFlase = null;
         removeChild(this._propEnbleFlase);
         this._propEnbleFlase = null;
         removeChild(this._beadEnbleFlase);
         this._beadEnbleFlase = null;
      }
      
      public function isNeedCard(value:Boolean) : void
      {
      }
      
      protected function set_breakBtn_enable() : void
      {
      }
      
      protected function set_text_location() : void
      {
      }
      
      protected function set_btn_location() : void
      {
      }
      
      private function __onBagUpdateEQUIPBAG(evt:BagEvent) : void
      {
         if(!(Boolean(this._dressbagView) && this._dressbagView.visible == true))
         {
            this.setBagCountShow(BagInfo.EQUIPBAG);
         }
      }
      
      private function __onBagUpdatePROPBAG(evt:BagEvent) : void
      {
         if(this.bagType != 21 && !this._isScreenFood && this.bagType != 2)
         {
            this.setBagCountShow(BagInfo.PROPBAG);
         }
      }
      
      private function __openSettingLock(evt:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         this._openBagLock = true;
         BagLockedController.Instance.show();
         BagLockedController.Instance.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __onLockComplete(evt:Event) : void
      {
         BagLockedController.Instance.removeEventListener(Event.COMPLETE,this.__onLockComplete);
         this._openBagLock = false;
      }
      
      protected function __bagArrangeOver(evt:MouseEvent) : void
      {
         if(this._bagType == BEAD)
         {
            return;
         }
         if(!this._bagArrangeSprite)
         {
            this._bagArrangeSprite = ComponentFactory.Instance.creatCustomObject("bagArrangeTipSprite");
         }
         this._bagArrangeSprite.y = this._keySortBtn.y + this._buttonContainer.y - 24;
         addChild(this._bagArrangeSprite);
      }
      
      protected function __sortBagClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._bagType != BEAD)
         {
            PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,this._bagArrangeSprite.arrangeAdd);
         }
         else
         {
            PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),32,178,true);
         }
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         alert.dispose();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._bagType != BEAD)
               {
                  PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,true);
               }
               else
               {
                  PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),32,178,true);
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._bagType != BEAD)
               {
                  PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,false);
               }
         }
      }
      
      private function __keySetFrameClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         if(this._keySetFrame == null)
         {
            this._keySetFrame = ComponentFactory.Instance.creatComponentByStylename("keySetFrame");
            this._keySetFrame.addEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         }
         this._keySetFrame.show();
      }
      
      private function __onKeySetResponse(event:FrameEvent) : void
      {
         this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         this._keySetFrame.dispose();
         this._keySetFrame = null;
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties[PlayerInfo.BandMONEY]) || Boolean(evt.changedProperties[PlayerInfo.MONEY]) || Boolean(evt.changedProperties[PlayerInfo.GOLD]) || Boolean(evt.changedProperties[PlayerInfo.DDT_MONEY]))
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         if(Boolean(this._info))
         {
            this._goldText.text = String(this._info.Gold);
            this._moneyText.text = String(this._info.Money);
            this._giftText.text = String(this._info.BandMoney);
         }
         else
         {
            this._goldText.text = this._moneyText.text = this._giftText.text = "";
         }
      }
      
      protected function __listChange(evt:Event) : void
      {
         if(!(Boolean(this._dressbagView) && this._dressbagView.visible == true))
         {
            this.setBagType(BagInfo.EQUIPBAG);
         }
      }
      
      private function __feedClick(pEvent:MouseEvent) : void
      {
         if(!(this.bead_state & this.STATE_BEADFEED))
         {
            this.bead_state |= this.STATE_BEADFEED;
            SoundManager.instance.play("008");
            this._beadFeedBtn.dragStart(pEvent.stageX,pEvent.stageY);
            this._beadFeedBtn.addEventListener(BeadFeedButton.stopFeed,this.__stopFeed);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
            pEvent.stopImmediatePropagation();
         }
         else
         {
            this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
            this._beadFeedBtn.stopDrag();
         }
      }
      
      private function __stopFeed(pEvent:Event) : void
      {
         this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
         this._beadFeedBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("stopfeed"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
         }
      }
      
      private function __onStageClick_FeedBtn(pEvent:Event) : void
      {
         this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
         dispatchEvent(new Event("stopfeed"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
         }
      }
      
      private function __sellClick(evt:MouseEvent) : void
      {
         if(!(this.state & this.STATE_SELL))
         {
            this.state |= this.STATE_SELL;
            SoundManager.instance.play("008");
            this._sellBtn.dragStart(evt.stageX,evt.stageY);
            this._sellBtn.addEventListener(SellGoodsBtn.StopSell,this.__stopSell);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
            evt.stopImmediatePropagation();
         }
         else
         {
            this.state = ~this.STATE_SELL & this.state;
            this._sellBtn.stopDrag();
         }
      }
      
      private function __stopSell(evt:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("sellstop"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __onStageClick_SellBtn(e:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         dispatchEvent(new Event("sellstop"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __breakClick(evt:MouseEvent) : void
      {
         if(this._breakBtn.enable)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
            }
            else
            {
               this._breakBtn.dragStart(evt.stageX,evt.stageY);
            }
         }
      }
      
      public function resetMouse() : void
      {
         this.state = ~this.STATE_SELL & this.state;
         LayerManager.Instance.clearnStageDynamic();
         Mouse.show();
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.stopDrag();
         }
      }
      
      private function isOnlyGivingGoods(info:InventoryItemInfo) : Boolean
      {
         return info.IsBinds == false && EquipType.isPackage(info) && info.Property2 == "10";
      }
      
      protected function __cellClick(evt:CellEvent) : void
      {
         var cell:* = undefined;
         var info:InventoryItemInfo = null;
         var pos:Point = null;
         if(!this._sellBtn.isActive)
         {
            evt.stopImmediatePropagation();
            if(evt.data is BagCell)
            {
               cell = evt.data as BagCell;
            }
            else
            {
               cell = evt.data as BeadCell;
            }
            if(cell)
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
               if(!this.isOnlyGivingGoods(info) && (info.getRemainDate() <= 0 && !EquipType.isProp(info) || EquipType.isPackage(info) || info.getRemainDate() <= 0 && info.TemplateID == 10200 || info.TemplateID == 11955 || EquipType.canBeUsed(info) || DressUtils.isDress(info) || info.CategoryID == EquipType.EVERYDAYGIFTRECORD))
               {
                  pos = cell.parent.localToGlobal(new Point(cell.x,cell.y));
                  CellMenu.instance.show(cell,pos.x + 20,pos.y + 20);
               }
               else
               {
                  cell.dragStart();
               }
            }
         }
      }
      
      public function set cellDoubleClickEnable(b:Boolean) : void
      {
         if(b)
         {
            this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
      }
      
      protected function __cellDoubleClick(evt:CellEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var toPlace:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         evt.stopImmediatePropagation();
         var cell:BagCell = evt.data as BagCell;
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         var templeteInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.TemplateID);
         var playerSex:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(info.getRemainDate() <= 0)
         {
            return;
         }
         if(templeteInfo.NeedSex != playerSex && templeteInfo.NeedSex != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.object"));
            return;
         }
         if(!cell.locked)
         {
            if((cell.info.BindType == 1 || cell.info.BindType == 2 || cell.info.BindType == 3) && cell.itemInfo.IsBinds == false)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               this.temInfo = info;
            }
            else
            {
               SoundManager.instance.play("008");
               if(PlayerManager.Instance.Self.canEquip(info))
               {
                  if(info.CategoryID == 50 || info.CategoryID == 51 || info.CategoryID == 52)
                  {
                     if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
                     {
                        if(!PetBagController.instance().petModel.currentPetInfo)
                        {
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petEquipNo"));
                           return;
                        }
                        SocketManager.Instance.out.addPetEquip(cell.place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
                     }
                     return;
                  }
                  toPlace = PlayerManager.Instance.getDressEquipPlace(info);
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace,info.Count);
               }
            }
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var toPlace:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            if(this.temInfo.CategoryID == 50 || this.temInfo.CategoryID == 51 || this.temInfo.CategoryID == 52)
            {
               if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
               {
                  if(!PetBagController.instance().petModel.currentPetInfo)
                  {
                     return;
                  }
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               return;
            }
            toPlace = PlayerManager.Instance.getDressEquipPlace(this.temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,toPlace,this.temInfo.Count);
         }
      }
      
      private function __cellAddPrice(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         if(Boolean(cell))
         {
            if(ShopManager.Instance.canAddPrice(cell.itemInfo.TemplateID))
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               AddPricePanel.Instance.setInfo(cell.itemInfo,false);
               AddPricePanel.Instance.show();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            }
         }
      }
      
      protected function __cellMove(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         if(Boolean(cell))
         {
            cell.dragStart();
         }
      }
      
      protected function __cellOpenBatch(evt:Event) : void
      {
         var openBatchView:OpenBatchView = null;
         var cell:BagCell = CellMenu.instance.cell as BagCell;
         if(cell != null && cell.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            openBatchView = ComponentFactory.Instance.creatComponentByStylename("bag.OpenBatchView");
            openBatchView.item = cell.itemInfo;
            LayerManager.Instance.addToLayer(openBatchView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function __cellOpen(evt:Event) : void
      {
         var sexN:Number = NaN;
         var bg:Date = null;
         var leftTime:int = 0;
         var h:int = 0;
         var m:int = 0;
         var alertAskGiftBag:BaseAlerFrame = null;
         var frame:BaseAlerFrame = null;
         var cell:BagCell = CellMenu.instance.cell as BagCell;
         this._currentCell = cell;
         if(cell != null && cell.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._isUpgradePack = cell.itemInfo.Property1 == "6" && cell.itemInfo.Property2 == "9" && cell.itemInfo.Property3 == "0";
            this._isUpgradePack = cell.itemInfo.Property2 == "9";
            BagAndInfoManager.Instance.isTimePack = cell.itemInfo.Property2 == "9";
            sexN = PlayerManager.Instance.Self.Sex ? 1 : 2;
            if(cell.info.NeedSex != 0 && sexN != cell.info.NeedSex)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
               return;
            }
            if(PlayerManager.Instance.Self.Grade >= cell.info.NeedLevel)
            {
               if(cell.info.TemplateID == EquipType.VIP_COIN)
               {
                  if(PlayerManager.Instance.Self.IsVIP)
                  {
                     RouletteManager.instance.useVipBox(cell);
                  }
                  else
                  {
                     evt.stopImmediatePropagation();
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipIcon.notVip"));
                  }
               }
               else if(cell.info.TemplateID == EquipType.ROULETTE_BOX)
               {
                  RouletteManager.instance.useRouletteBox(cell);
               }
               else if(cell.info.TemplateID == EquipType.SURPRISE_ROULETTE_BOX)
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useSurpriseRoulette(cell);
               }
               else if(EquipType.isCaddy(cell.info))
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useCaddy(cell);
               }
               else if(cell.info.TemplateID == EquipType.BOMB_KING_BLESS || cell.info.TemplateID == EquipType.SILVER_BLESS || cell.info.TemplateID == EquipType.GOLD_BLESS)
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useBless(cell);
               }
               else if(EquipType.isBeadNeedOpen(cell.info))
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useBead(cell.info.TemplateID);
               }
               else if(cell.info.TemplateID == EquipType.CELEBRATION_BOX)
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useCelebrationBox();
               }
               else if(cell.info.TemplateID == EquipType.BATTLE_COMPANION && !cell.itemInfo.IsBinds)
               {
                  evt.stopImmediatePropagation();
                  WonderfulActivityManager.Instance.useBattleCompanion(cell.itemInfo);
               }
               else if(EquipType.isOfferPackage(cell.info))
               {
                  evt.stopImmediatePropagation();
                  RouletteManager.instance.useOfferPack(cell);
               }
               else if(EquipType.isTimeBox(cell.info))
               {
                  bg = DateUtils.getDateByStr(InventoryItemInfo(cell.info).BeginDate);
                  leftTime = int(cell.info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - bg.getTime()) / 1000;
                  if(leftTime <= 0)
                  {
                     SocketManager.Instance.out.sendItemOpenUp(cell.itemInfo.BagType,cell["place"]);
                  }
                  else
                  {
                     h = leftTime / 3600;
                     m = leftTime % 3600 / 60;
                     m = m > 0 ? m : 1;
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip",h,m));
                  }
               }
               else if(cell.info.CategoryID == EquipType.CARDBOX)
               {
                  evt.stopImmediatePropagation();
                  SocketManager.Instance.out.sendOpenCardBox(cell["place"],1);
               }
               else if(cell.info.TemplateID == EquipType.MYSTICAL_CARDBOX)
               {
                  SocketManager.Instance.out.sendOpenRandomBox(cell["place"],1);
               }
               else if(cell.info.TemplateID == EquipType.MY_CARDBOX)
               {
                  SocketManager.Instance.out.sendOpenRandomBox(cell["place"],1);
               }
               else if(EquipType.isSpecilPackage(cell.info))
               {
                  if(PlayerManager.Instance.Self.BandMoney >= Number(cell.info.Property3))
                  {
                     alertAskGiftBag = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag",cell.info.Property3,cell.info.Name),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                     alertAskGiftBag.addEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII",cell.info.Property3));
                  }
               }
               else if(EquipType.PET_EGG == cell.info.CategoryID)
               {
                  SocketManager.Instance.out.sendAddPet(cell.itemInfo.Place,cell.itemInfo.BagType);
               }
               else if(cell.info.Property2 == "8")
               {
                  frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("bagView.consumePack.openTxt",cell.info.Property3),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
                  frame.addEventListener(FrameEvent.RESPONSE,this.onConsumePackResponse);
               }
               else if(cell.itemInfo.CategoryID == EquipType.EVERYDAYGIFTRECORD)
               {
                  ItemActivityGiftManager.instance.showFrame(ItemActivityGiftType.EVERYDAYGIFTRECORD,cell.itemInfo);
               }
               else if(cell.itemInfo.Property5 == "-1")
               {
                  SocketManager.Instance.out.treasurePuzzle_usePice(this._currentCell.place);
               }
               else if(cell.itemInfo.Property5 == "-1")
               {
                  SocketManager.Instance.out.treasurePuzzle_usePice(this._currentCell.place);
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(cell.itemInfo.BagType,cell.itemInfo.Place);
               }
            }
            else if(cell.info.CategoryID == EquipType.CARDBOX)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.bagView.openCardBox.level"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
            }
         }
      }
      
      protected function onConsumePackResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.onConsumePackResponse);
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            frame.dispose();
            return;
         }
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(frame.isBand)
            {
               if(PlayerManager.Instance.Self.BandMoney < int(this._currentCell.info.Property3))
               {
                  this.initAlertFarme();
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,frame.isBand);
               }
            }
            else if(PlayerManager.Instance.Self.Money < int(this._currentCell.info.Property3))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,frame.isBand);
            }
         }
         frame.dispose();
      }
      
      private function initAlertFarme() : void
      {
         var frame:BaseAlerFrame = null;
         frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         frame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
      }
      
      protected function onResponseHander(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < int(this._currentCell.info.Property3))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,false);
            }
         }
         e.currentTarget.dispose();
      }
      
      private function __GiftBagframeClose(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._currentCell) && Boolean(this._currentCell.itemInfo))
               {
                  SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell["place"]);
               }
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __cellUse(evt:Event) : void
      {
         var alert:BaseAlerFrame = null;
         var storeMainView:StoreMainView = null;
         var storeMainView2:StoreMainView = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         evt.stopImmediatePropagation();
         var cell:BagCell = CellMenu.instance.cell as BagCell;
         if(!cell || cell.info == null)
         {
            return;
         }
         if(cell.info.TemplateID == EquipType.WISHBEAD_ATTACK || cell.info.TemplateID == EquipType.WISHBEAD_DEFENSE || cell.info.TemplateID == EquipType.WISHBEAD_AGILE)
         {
            if(this is ConsortionBankBagView)
            {
               BagStore.instance.isFromConsortionBankFrame = true;
            }
            else
            {
               BagStore.instance.isFromBagFrame = true;
            }
            BagStore.instance.show(BagStore.FORGE_STORE,1);
            return;
         }
         if(cell.info.TemplateID == EquipType.REWORK_NAME)
         {
            this.startReworkName(cell.bagType,cell.place);
            return;
         }
         if(cell.info.CategoryID == 11 && cell.info.Property1 == "5" && cell.info.Property2 != "0")
         {
            this.showChatBugleInputFrame(cell.info.TemplateID);
            return;
         }
         if(cell.info.CategoryID == EquipType.TEXP_TASK)
         {
            if(PlayerManager.Instance.Self.Grade < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.noGrade"));
               return;
            }
            if(TexpManager.Instance.getLv(TexpManager.Instance.getExp(int(cell.info.Property1))) >= PlayerManager.Instance.Self.Grade + 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.lvToplimit"));
               return;
            }
            if(TaskManager.instance.texpQuests.length > 0)
            {
               this._tmpCell = cell;
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("texpSystem.view.TexpView.refreshTaskTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__texpResponse);
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,cell.info.TemplateID,1,cell.place);
            return;
         }
         if(cell.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
         {
            if(PlayerManager.Instance.Self.ConsortiaID == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
               return;
            }
            if(PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
               return;
            }
            this.startupConsortiaReworkName(cell.bagType,cell.place);
            return;
         }
         if(cell.info.TemplateID == EquipType.CHANGE_SEX)
         {
            this.startupChangeSex(cell.bagType,cell.place);
            return;
         }
         if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 37)
         {
            if(!Boolean(PlayerManager.Instance.Self.Bag.getItemAt(6)))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
               return;
            }
            if(PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
            {
               SocketManager.Instance.out.sendUseChangeColorShell(cell.bagType,cell.place);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
         }
         if(cell.info.TemplateID == EquipType.COLORCARD)
         {
            ChangeColorController.instance.changeColorModel.place = cell.place;
            ChangeColorController.instance.changeColorModel.getColorEditableThings();
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
         else if(cell.info.TemplateID != EquipType.TRANSFER_PROP)
         {
            if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 24)
            {
               if(TrusteeshipManager.instance.spiritValue >= TrusteeshipManager.instance.maxSpiritValue)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.maxSpiritCannotUseTxt"));
                  return;
               }
               SocketManager.Instance.out.sendTrusteeshipUseSpiritItem(cell.place,cell.bagType);
            }
            else if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 39)
            {
               SocketManager.Instance.out.sendUseItemKingBless(cell.place,cell.bagType);
            }
            else if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 39 && int(cell.info.Property2) == 10)
            {
               SocketManager.Instance.out.sendUseItemDeed(cell.place,cell.bagType);
            }
            else if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 101)
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,0);
            }
            else if(EquipType.isStrengthStone(cell.info))
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
            }
            else if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 45)
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView.skipFromWantStrong(StoreMainView.EXALT);
            }
            else if(cell.info.CategoryID == 11 && int(cell.info.Property1) == 82)
            {
               if(this._self.horsePicCherishDic.hasKey(cell.info.Property2))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.pic.alreadyActive"));
                  return;
               }
               HorseManager.instance.skipHorsePicCherishId = int(cell.info.Property2);
               HorseManager.instance.isSkipFromBagView = true;
               HorseManager.instance.loadModule();
            }
            else if(cell.info.CategoryID == 11 && (int(cell.info.Property1) == 27 || int(cell.info.Property1) == 29))
            {
               if(this._self.Grade < 25)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.openTxt",25));
                  return;
               }
               PetsBagManager.instance.show();
            }
            else if(EquipType.TITLE_CARD == cell.info.CategoryID)
            {
               SocketManager.Instance.out.sendNewTitleCard(cell.itemInfo.Place,cell.itemInfo.BagType);
            }
            else if(EquipType.isComposeStone(cell.info))
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView2 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView2.skipFromWantStrong(StoreMainView.COMPOSE);
            }
            else if(cell.info.TemplateID == EquipType.GEMSTONE)
            {
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
                  return;
               }
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,3);
            }
            else if(cell.info.TemplateID == EquipType.HORSE_UP_ITEM || cell.info.TemplateID == EquipType.HORSE_SKILL_UP_ITEM)
            {
               HorseManager.instance.loadModule();
            }
            else if(PlayerManager.Instance.Self.bagLocked)
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
            }
            else if(cell.info.CategoryID == 11 && (int(cell.info.Property1) == 100 || int(cell.info.Property1) == 1100 || int(cell.info.Property1) == 1200))
            {
               this.useProp(cell.itemInfo);
            }
            else
            {
               this.useCard(cell.itemInfo);
            }
         }
      }
      
      protected function __cellColorChange(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         if(Boolean(cell))
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(cell.itemInfo.CategoryID == EquipType.SUITS || cell.itemInfo.CategoryID == EquipType.WING)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.suitAndWingCannotChange"));
               return;
            }
            if(this.checkDress(cell))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.canNotChangeColor"));
               return;
            }
            ChangeColorController.instance.changeColorModel.place = -1;
            ChangeColorController.instance.addOneThing(cell);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
      }
      
      private function __alertChangeColor(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < ShopManager.Instance.getGiftShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
               return;
            }
         }
      }
      
      protected function __cellSell(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         if(this.checkDress(cell))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.canNotSell"));
            return;
         }
         if(Boolean(cell))
         {
            cell.sellItem(cell.itemInfo);
         }
      }
      
      private function checkDress(cell:BagCell) : Boolean
      {
         var arr:Array = null;
         var currentModel:DressModel = null;
         var i:int = 0;
         var vo:DressVo = null;
         var item:InventoryItemInfo = null;
         var modelArr:Array = PlayerDressManager.instance.modelArr;
         for each(arr in modelArr)
         {
            for(i = 0; i <= arr.length - 1; i++)
            {
               vo = arr[i];
               if(vo.itemId == cell.itemInfo.ItemID)
               {
                  return true;
               }
            }
         }
         currentModel = PlayerDressManager.instance.dressView.currentModel;
         if(Boolean(currentModel))
         {
            for each(item in currentModel.model.Bag.items)
            {
               if(Boolean(item) && item.ItemID == cell.itemInfo.ItemID)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function __texpResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__texpResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 10)
            {
               LeavePageManager.showFillFrame();
               this._tmpCell = null;
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,this._tmpCell.info.TemplateID,1,this._tmpCell.place);
            this._tmpCell = null;
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
      }
      
      private function __changeColorProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __changeColorComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleSmallLoading.Instance.hide();
            ChangeColorController.instance.show();
         }
      }
      
      private function useCard(info:InventoryItemInfo) : void
      {
         if(info.TemplateID == EquipType.FREE_PROP_CARD || info.TemplateID == EquipType.DOUBLE_EXP_CARD || info.TemplateID == EquipType.DOUBLE_GESTE_CARD || info.TemplateID == EquipType.PREVENT_KICK || info.TemplateID.toString().substring(0,3) == "119" || info.TemplateID == EquipType.VIPCARD || info.TemplateID == EquipType.CARDSOUL_BOX || info.TemplateID == EquipType.CHRISTMAS_TIMER || info.TemplateID == EquipType.TREASURELOST_POWER)
         {
            if(this._self.Grade < 3 && (info.TemplateID == EquipType.VIPCARD || info.TemplateID == EquipType.VIPCARD_TEST))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
            SocketManager.Instance.out.sendUseCard(info.BagType,info.Place,[info.TemplateID],info.PayType);
         }
      }
      
      private function useProp(info:InventoryItemInfo) : void
      {
         if(!info)
         {
            return;
         }
         SocketManager.Instance.out.sendUseProp(info.BagType,info.Place,[info.TemplateID],info.PayType);
      }
      
      private function createBreakWin(cell:BagCell) : void
      {
         SoundManager.instance.play("008");
         var win:BreakGoodsView = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
      }
      
      public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         this._currentList.setCellInfo(index,info);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._oneKeyFeedMC))
         {
            this._oneKeyFeedMC.removeEventListener("oneKeyComplete",this.__disposeOneKeyMC);
            this._oneKeyFeedMC.stop();
            ObjectUtils.disposeObject(this._oneKeyFeedMC);
         }
         this.removeEvents();
         this.resetMouse();
         this._info = null;
         this._lists = null;
         this._tmpCell = null;
         this._self.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
         this._self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
         if(Boolean(this._pgup))
         {
            ObjectUtils.disposeObject(this._pgup);
         }
         this._pgup = null;
         if(Boolean(this._pgdn))
         {
            ObjectUtils.disposeObject(this._pgdn);
         }
         this._pgdn = null;
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         this._pageTxt = null;
         if(Boolean(this._pageTxtBg))
         {
            ObjectUtils.disposeObject(this._pageTxtBg);
         }
         this._pageTxtBg = null;
         if(Boolean(this._beadSortBtn))
         {
            ObjectUtils.disposeObject(this._beadSortBtn);
         }
         this._beadSortBtn = null;
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         }
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(Boolean(this._goodsNumInfoBg))
         {
            ObjectUtils.disposeObject(this._goodsNumInfoBg);
         }
         this._goodsNumInfoBg = null;
         if(Boolean(this._goodsNumInfoText))
         {
            ObjectUtils.disposeObject(this._goodsNumInfoText);
         }
         this._goodsNumInfoText = null;
         if(Boolean(this._goodsNumTotalText))
         {
            ObjectUtils.disposeObject(this._goodsNumTotalText);
         }
         this._goodsNumTotalText = null;
         if(Boolean(this._tabBtn1))
         {
            ObjectUtils.disposeObject(this._tabBtn1);
         }
         this._tabBtn1 = null;
         if(Boolean(this._tabBtn2))
         {
            ObjectUtils.disposeObject(this._tabBtn2);
         }
         this._tabBtn2 = null;
         if(Boolean(this._tabBtn3))
         {
            ObjectUtils.disposeObject(this._tabBtn3);
         }
         this._tabBtn3 = null;
         if(Boolean(this._tabBtn4))
         {
            ObjectUtils.disposeObject(this._tabBtn4);
         }
         this._tabBtn4 = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._goldText))
         {
            ObjectUtils.disposeObject(this._goldText);
         }
         this._goldText = null;
         if(Boolean(this._moneyText))
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(Boolean(this._giftText))
         {
            ObjectUtils.disposeObject(this._giftText);
         }
         this._giftText = null;
         if(Boolean(this._keySortBtn))
         {
            ObjectUtils.disposeObject(this._keySortBtn);
         }
         this._keySortBtn = null;
         if(Boolean(this._breakBtn))
         {
            ObjectUtils.disposeObject(this._breakBtn);
         }
         this._breakBtn = null;
         if(Boolean(this._currentList))
         {
            ObjectUtils.disposeObject(this._currentList);
         }
         this._currentList = null;
         if(Boolean(this._sellBtn))
         {
            ObjectUtils.disposeObject(this._sellBtn);
         }
         this._sellBtn = null;
         if(Boolean(this._proplist))
         {
            ObjectUtils.disposeObject(this._proplist);
         }
         this._proplist = null;
         if(Boolean(this._petlist))
         {
            ObjectUtils.disposeObject(this._petlist);
         }
         this._petlist = null;
         if(Boolean(this._equiplist))
         {
            ObjectUtils.disposeObject(this._equiplist);
         }
         this._equiplist = null;
         if(Boolean(this._beadList))
         {
            ObjectUtils.disposeObject(this._beadList);
         }
         this._beadList = null;
         if(Boolean(this._beadList2))
         {
            ObjectUtils.disposeObject(this._beadList2);
         }
         this._beadList2 = null;
         if(Boolean(this._beadList3))
         {
            ObjectUtils.disposeObject(this._beadList3);
         }
         this._beadList3 = null;
         if(Boolean(this._bgShape))
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         if(Boolean(this._goldButton))
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(Boolean(this._giftButton))
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(Boolean(this._moneyButton))
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(Boolean(this._continueBtn))
         {
            ObjectUtils.disposeObject(this._continueBtn);
         }
         this._continueBtn = null;
         if(Boolean(this._chatBugleInputFrame))
         {
            ObjectUtils.disposeObject(this._chatBugleInputFrame);
         }
         this._chatBugleInputFrame = null;
         if(Boolean(this._bgShapeII))
         {
            ObjectUtils.disposeObject(this._bgShapeII);
         }
         this._bgShapeII = null;
         if(Boolean(this._bagList))
         {
            ObjectUtils.disposeObject(this._bagList);
         }
         this._bagList = null;
         if(Boolean(this._PointCouponBitmap))
         {
            ObjectUtils.disposeObject(this._PointCouponBitmap);
         }
         this._PointCouponBitmap = null;
         if(Boolean(this._LiJinBitmap))
         {
            ObjectUtils.disposeObject(this._LiJinBitmap);
         }
         this._LiJinBitmap = null;
         if(Boolean(this._MoneyBitmap))
         {
            ObjectUtils.disposeObject(this._MoneyBitmap);
         }
         this._MoneyBitmap = null;
         if(Boolean(this._currentBeadList))
         {
            ObjectUtils.disposeObject(this._currentBeadList);
         }
         this._currentBeadList = null;
         ObjectUtils.disposeObject(this._bagLockBtn);
         this._bagLockBtn = null;
         ObjectUtils.disposeObject(this._equipSelectedBtn);
         this._equipSelectedBtn = null;
         ObjectUtils.disposeObject(this._propSelectedBtn);
         this._propSelectedBtn = null;
         ObjectUtils.disposeObject(this._beadSelectedBtn);
         this._beadSelectedBtn = null;
         ObjectUtils.disposeObject(this._dressSelectedBtn);
         this._dressSelectedBtn = null;
         ObjectUtils.disposeObject(this._cardEnbleFlase);
         this._cardEnbleFlase = null;
         ObjectUtils.disposeObject(this._itemtabBtn);
         this._itemtabBtn = null;
         ObjectUtils.disposeObject(this._moneyBg);
         this._moneyBg = null;
         ObjectUtils.disposeObject(this._moneyBg1);
         this._moneyBg1 = null;
         ObjectUtils.disposeObject(this._moneyBg2);
         this._moneyBg2 = null;
         ObjectUtils.disposeObject(this._buttonContainer);
         this._buttonContainer = null;
         ObjectUtils.disposeObject(this._bagArrangeSprite);
         this._bagArrangeSprite = null;
         ObjectUtils.disposeObject(this._dressbagView);
         this._dressbagView = null;
         if(Boolean(this._oneKeyFeedMC))
         {
            ObjectUtils.disposeObject(this._oneKeyFeedMC);
         }
         this._oneKeyFeedMC = null;
         if(Boolean(this._keySetFrame))
         {
            this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
            this._keySetFrame.dispose();
            this._keySetFrame = null;
         }
         if(Boolean(this._reworknameView))
         {
            this.shutdownReworkName();
         }
         if(Boolean(this._consortaiReworkName))
         {
            this.shutdownConsortiaReworkName();
         }
         if(CellMenu.instance.showed)
         {
            CellMenu.instance.hide();
         }
         AddPricePanel.Instance.close();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setBagCountShow(bagType:int) : void
      {
         var goodsNum:int = 0;
         var glowFilter:GlowFilter = null;
         var textColor:uint = 0;
         switch(bagType)
         {
            case BagInfo.EQUIPBAG:
               goodsNum = PlayerManager.Instance.Self.getBag(bagType).itemBgNumber(this._equiplist._startIndex,this._equiplist._stopIndex);
               if(goodsNum >= 49)
               {
                  textColor = 16711680;
                  glowFilter = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  textColor = 1310468;
                  glowFilter = new GlowFilter(876032,0.5,3,3,10);
               }
               break;
            case BagInfo.PROPBAG:
               goodsNum = PlayerManager.Instance.Self.getBag(bagType).itemBgNumber(0,BagInfo.MAXPROPCOUNT);
               if(goodsNum >= BagInfo.MAXPROPCOUNT + 1)
               {
                  textColor = 16711680;
                  glowFilter = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  textColor = 1310468;
                  glowFilter = new GlowFilter(876032,0.5,3,3,10);
               }
         }
         this._goodsNumInfoText.textColor = textColor;
         this._goodsNumInfoText.text = goodsNum.toString();
         this.setBagType(bagType);
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(value:SelfInfo) : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.removeEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this._info = value;
         if(Boolean(this._info))
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.addEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
            PlayerManager.Instance.Self.addEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this.updateView();
      }
      
      private function startReworkName(bagType:int, place:int) : void
      {
         this._reworknameView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameFrame");
         LayerManager.Instance.addToLayer(this._reworknameView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._reworknameView.initialize(bagType,place);
         this._reworknameView.addEventListener(Event.COMPLETE,this.__onRenameComplete);
      }
      
      private function shutdownReworkName() : void
      {
         this._reworknameView.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._reworknameView);
         this._reworknameView = null;
      }
      
      private function __onRenameComplete(evt:Event) : void
      {
         this.shutdownReworkName();
      }
      
      private function startupConsortiaReworkName(bagType:int, place:int) : void
      {
         this._consortaiReworkName = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameConsortia");
         LayerManager.Instance.addToLayer(this._consortaiReworkName,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._consortaiReworkName.initialize(bagType,place);
         this._consortaiReworkName.addEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
      }
      
      private function shutdownConsortiaReworkName() : void
      {
         this._consortaiReworkName.removeEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
         ObjectUtils.disposeObject(this._consortaiReworkName);
         this._consortaiReworkName = null;
      }
      
      private function showChatBugleInputFrame(templateID:int) : void
      {
         if(this._chatBugleInputFrame == null)
         {
            this._chatBugleInputFrame = ComponentFactory.Instance.creat("chat.BugleInputFrame");
         }
         this._chatBugleInputFrame.templateID = templateID;
         LayerManager.Instance.addToLayer(this._chatBugleInputFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onConsortiaRenameComplete(evt:Event) : void
      {
         this.shutdownConsortiaReworkName();
      }
      
      public function hide() : void
      {
         if(Boolean(this._reworknameView))
         {
            this.shutdownReworkName();
         }
         if(Boolean(this._consortaiReworkName))
         {
            this.shutdownConsortiaReworkName();
         }
         if(Boolean(this._keySetFrame))
         {
            this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
            this._keySetFrame.dispose();
            this._keySetFrame = null;
         }
      }
      
      private function judgeAndPlayCardMovie() : void
      {
         var cardInfo:CardInfo = null;
         var s:Sprite = null;
         var cardTempInfo:ItemTemplateInfo = null;
         var cell:BaseCell = null;
         var text:GradientText = null;
         var templateInfo:ItemTemplateInfo = this._currentCell.info;
         var bagCardDic:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         for each(cardInfo in bagCardDic)
         {
            if(cardInfo.TemplateID == int(templateInfo.Property5))
            {
               return;
            }
         }
         SocketManager.Instance.out.sendFirstGetCards();
         dispatchEvent(new Event(FIRST_GET_CARD,true));
         this.getNewCardMovie = ClassUtils.CreatInstance("asset.getNecCard.movie") as MovieClip;
         PositionUtils.setPos(this.getNewCardMovie,"BagView.NewCardMovie.Pos");
         s = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,113,156);
         s.graphics.endFill();
         cardTempInfo = ItemManager.Instance.getTemplateById(int(templateInfo.Property5));
         cell = new BaseCell(s,cardTempInfo);
         this.getNewCardMovie["card"].addChild(cell);
         text = ComponentFactory.Instance.creatComponentByStylename("getNewCardMovie.text");
         text.text = LanguageMgr.GetTranslation("ddt.cardSystem.getNewCard.name",cardTempInfo.Name);
         text.x -= (text.textWidth - cell.width) / 6;
         this.getNewCardMovie["word"].addChild(text);
         LayerManager.Instance.addToLayer(this.getNewCardMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         this.getNewCardMovie.gotoAndPlay(1);
         this.getNewCardMovie.addEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl = new SoundTransform();
         if(SoundManager.instance.allowSound)
         {
            this._soundControl.volume = 1;
         }
         else
         {
            this._soundControl.volume = 0;
         }
         this.getNewCardMovie.soundTransform = this._soundControl;
      }
      
      private function __showOver(event:Event) : void
      {
         this.getNewCardMovie.removeEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl.volume = 0;
         this.getNewCardMovie.soundTransform = this._soundControl;
         this._soundControl = null;
         ObjectUtils.disposeObject(this.getNewCardMovie);
         this.getNewCardMovie = null;
      }
      
      protected function _isSkillCanUse() : Boolean
      {
         var boo:Boolean = false;
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN))
         {
            boo = true;
         }
         return boo;
      }
      
      private function startupChangeSex(bagType:int, place:int) : void
      {
         var alert:ChangeSexAlertFrame = ComponentFactory.Instance.creat("bagAndInfo.bag.changeSexAlert");
         alert.bagType = bagType;
         alert.place = place;
         alert.info = this.getAlertInfo("tank.view.bagII.changeSexAlert",true);
         alert.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,alert.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = alert;
      }
      
      private function getAlertInfo(tip:String, showCancel:Boolean = false) : AlertInfo
      {
         var result:AlertInfo = new AlertInfo();
         result.autoDispose = true;
         result.showSubmit = true;
         result.showCancel = showCancel;
         result.enterEnable = true;
         result.escEnable = true;
         result.moveEnable = false;
         result.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         result.data = LanguageMgr.GetTranslation(tip);
         return result;
      }
      
      private function __onAlertSizeChanged(event:ComponentEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         if(alert.info.frameCenter)
         {
            alert.x = (StageReferance.stageWidth - alert.width) / 2;
            alert.y = (StageReferance.stageHeight - alert.height) / 2;
         }
      }
      
      private function __onAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:ChangeSexAlertFrame = ChangeSexAlertFrame(evt.currentTarget);
         alert.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendChangeSex(alert.bagType,alert.place);
         }
         alert.dispose();
         alert = null;
      }
      
      private function __changeSexHandler(evt:CrazyTankSocketEvent) : void
      {
         var alert:SimpleAlert = null;
         SocketManager.Instance.socket.close();
         var state:Boolean = evt.pkg.readBoolean();
         if(state)
         {
            alert = ComponentFactory.Instance.creat("sellGoodsAlert");
            alert.info = this.getAlertInfo("tank.view.bagII.changeSexAlert.success",false);
            alert.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onSuccessAlertResponse);
            LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,alert.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = alert;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.changeSexAlert.failed"));
         }
      }
      
      private function __onSuccessAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         ExternalInterface.call("WindowReturn");
      }
      
      public function set isScreenFood(value:Boolean) : void
      {
         this._isScreenFood = value;
      }
      
      public function get beadFeedBtn() : BeadFeedButton
      {
         return this._beadFeedBtn;
      }
      
      public function deleteButtonForPet() : void
      {
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.dispose();
            this._bagLockBtn = null;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.dispose();
            this._dressSelectedBtn = null;
         }
      }
   }
}

