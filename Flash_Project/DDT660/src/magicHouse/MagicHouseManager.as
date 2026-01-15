package magicHouse
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hall.HallStateView;
   import hall.event.NewHallEvent;
   import hall.player.HallPlayerView;
   import road7th.comm.PackageIn;
   
   public class MagicHouseManager extends EventDispatcher
   {
      
      private static var loadComplete:Boolean;
      
      private static var _instance:MagicHouseManager;
      
      public static const BTNID_MAGICHOUSE:int = 101;
      
      public static const FREEBOX_MAXCOUNT:int = 5;
      
      public static const CHARGEBOX_MAXCOUNT:int = 20;
      
      private static var useFirst:Boolean = true;
      
      public var viewIndex:int = 0;
      
      public const TITLE_JUNIOR_ID:int = 1010;
      
      public const TITLE_MID_ID:int = 1011;
      
      public const TITLE_SENIOR_ID:int = 1012;
      
      private var _equipOpenList:Array;
      
      public var isOpen:Boolean;
      
      public var isMagicRoomShow:Boolean;
      
      private var _activityWeapons:Array;
      
      private var _magicJuniorLv:int;
      
      private var _magicJuniorExp:int;
      
      private var _magicMidLv:int;
      
      private var _magicMidExp:int;
      
      private var _magicSeniorLv:int;
      
      private var _magicSeniorExp:int;
      
      private var _freeGetCount:int;
      
      private var _freeGetTime:Date;
      
      private var _chargeGetCount:int;
      
      private var _chargeGetTime:Date;
      
      private var _depotCount:int;
      
      private var _juniorWeaponList:Array;
      
      private var _midWeaponList:Array;
      
      private var _seniorWeapinList:Array;
      
      private var _boxNeedmoney:int;
      
      private var _levelUpNumber:Array;
      
      private var _openDepotNeedMoney:int;
      
      private var _depotPromoteNeedMoney:int;
      
      private var _juniorAddAttribute:Array;
      
      private var _midAddAttribute:Array;
      
      private var _seniorAddAttribute:Array;
      
      private var _titleDatas:Array;
      
      private var _entryBtn:MagicHouseEntryBtn;
      
      private var _hallPlayerView:HallPlayerView;
      
      private var _magicHouseMainView:MagicHouseMainView;
      
      public function MagicHouseManager($instance:MagicHouseInstance, target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : MagicHouseManager
      {
         if(_instance == null)
         {
            _instance = new MagicHouseManager(new MagicHouseInstance());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAGICHOUSE,this.__magicHouseHandler);
      }
      
      public function initServerConfig() : void
      {
         this._juniorWeaponList = ServerConfigManager.instance.magicHouseJuniorWeaponList;
         this._midWeaponList = ServerConfigManager.instance.magicHouseMidWeaponList;
         this._seniorWeapinList = ServerConfigManager.instance.magicHouseSeniorWeaponList;
         this._boxNeedmoney = ServerConfigManager.instance.magicHouseBoxNeedMonry;
         this._openDepotNeedMoney = ServerConfigManager.instance.magicHouseOpenDepotNeedMoney;
         this._levelUpNumber = ServerConfigManager.instance.magicHouseLevelUpNumber;
         this._depotPromoteNeedMoney = ServerConfigManager.instance.magicHouseDepotPromoteNeedMoney;
         this._juniorAddAttribute = ServerConfigManager.instance.magicHouseJuniorAddAttribute;
         this._midAddAttribute = ServerConfigManager.instance.magicHouseMidAddAttribute;
         this._seniorAddAttribute = ServerConfigManager.instance.magicHouseSeniorAddAttribute;
      }
      
      public function selectEquipFromBag() : void
      {
         var f:Boolean = false;
         var jarr:Array = null;
         var ji:int = 0;
         var arr1:Array = null;
         var jm:int = 0;
         var marr:Array = null;
         var mi:int = 0;
         var arr2:Array = null;
         var mm:int = 0;
         var sarr:Array = null;
         var si:int = 0;
         var arr3:Array = null;
         var sm:int = 0;
         var bag:BagInfo = PlayerManager.Instance.Self.Bag;
         if(this._equipOpenList == null)
         {
            this._equipOpenList = new Array();
         }
         for(var i:int = 0; i < 9; i++)
         {
            f = false;
            if(i < 3)
            {
               jarr = this._juniorWeaponList[i].split(",");
               for(ji = 0; ji < jarr.length; ji++)
               {
                  arr1 = bag.findItemsByTempleteID(jarr[ji]);
                  for(jm = 0; jm < arr1.length; jm++)
                  {
                     if(arr1[jm] != null && arr1[jm].getRemainDate() > 0)
                     {
                        f = true;
                        break;
                     }
                  }
                  if(f)
                  {
                     break;
                  }
               }
               this._equipOpenList[i] = f;
            }
            else if(i < 6)
            {
               marr = this._midWeaponList[i - 3].split(",");
               for(mi = 0; mi < marr.length; mi++)
               {
                  arr2 = bag.findItemsByTempleteID(marr[mi]);
                  for(mm = 0; mm < arr2.length; mm++)
                  {
                     if(arr2[mm] != null && arr2[mm].getRemainDate() > 0)
                     {
                        f = true;
                        break;
                     }
                  }
                  if(f)
                  {
                     break;
                  }
               }
               this._equipOpenList[i] = f;
            }
            else
            {
               sarr = this._seniorWeapinList[i - 6].split(",");
               for(si = 0; si < sarr.length; si++)
               {
                  arr3 = bag.findItemsByTempleteID(sarr[si]);
                  for(sm = 0; sm < arr3.length; sm++)
                  {
                     if(arr3[sm] != null && arr3[sm].getRemainDate() > 0)
                     {
                        f = true;
                        break;
                     }
                  }
                  if(f)
                  {
                     break;
                  }
               }
               this._equipOpenList[i] = f;
            }
         }
      }
      
      private function __magicHouseHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readInt();
         if(cmd == MagicHousePackageType.LOGIN_MESSAGE)
         {
            this._loginMessage(pkg);
         }
         else if(cmd == MagicHousePackageType.UPDATE_MESSAGE)
         {
            this._updateMessage(pkg);
         }
         else if(cmd == MagicHousePackageType.ISOPEN)
         {
            this._isOpen(pkg);
         }
         else if(cmd == MagicHousePackageType.FREEBOX_MESSAGE)
         {
            this._getFreeBoxMessage(pkg);
         }
         else if(cmd == MagicHousePackageType.CHARGEBOX_MESSAGE)
         {
            this._getChargeBoxMessage(pkg);
         }
      }
      
      private function _loginMessage(pkg:PackageIn) : void
      {
         this._activityWeapons = new Array();
         this.isMagicRoomShow = pkg.readBoolean();
         for(var i:int = 0; i < 9; i++)
         {
            this._activityWeapons[i] = pkg.readInt();
         }
         this._magicJuniorLv = pkg.readInt();
         this._magicJuniorExp = pkg.readInt();
         this._magicMidLv = pkg.readInt();
         this._magicMidExp = pkg.readInt();
         this._magicSeniorLv = pkg.readInt();
         this._magicSeniorExp = pkg.readInt();
         this._freeGetCount = pkg.readInt();
         this._freeGetTime = pkg.readDate();
         this._chargeGetCount = pkg.readInt();
         this._chargeGetTime = pkg.readDate();
         this._depotCount = pkg.readInt();
      }
      
      private function _updateMessage(pkg:PackageIn) : void
      {
         if(this._activityWeapons == null)
         {
            this._activityWeapons = new Array();
         }
         this.isMagicRoomShow = pkg.readBoolean();
         for(var i:int = 0; i < 9; i++)
         {
            this._activityWeapons[i] = pkg.readInt();
         }
         this._magicJuniorLv = pkg.readInt();
         this._magicJuniorExp = pkg.readInt();
         this._magicMidLv = pkg.readInt();
         this._magicMidExp = pkg.readInt();
         this._magicSeniorLv = pkg.readInt();
         this._magicSeniorExp = pkg.readInt();
         this._freeGetCount = pkg.readInt();
         this._freeGetTime = pkg.readDate();
         this._chargeGetCount = pkg.readInt();
         this._chargeGetTime = pkg.readDate();
         this._depotCount = pkg.readInt();
         dispatchEvent(new Event("MAGICHOUSE_UPDATA"));
      }
      
      private function _isOpen(pkg:PackageIn) : void
      {
         this.isOpen = pkg.readBoolean();
         this.isMagicRoomShow = pkg.readBoolean();
      }
      
      private function _getFreeBoxMessage(pkg:PackageIn) : void
      {
         var _frame:BaseAlerFrame = null;
         var aView:AwardsView = null;
         var info:BoxGoodsTempInfo = null;
         var currentCount:int = pkg.readInt();
         this._freeGetTime = pkg.readDate();
         var count:int = pkg.readInt();
         var infos:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            info = new BoxGoodsTempInfo();
            info.TemplateId = pkg.readInt();
            info.ItemCount = pkg.readInt();
            info.ItemValid = pkg.readInt();
            info.IsBind = pkg.readBoolean();
            info.StrengthenLevel = pkg.readInt();
            info.AttackCompose = pkg.readInt();
            info.DefendCompose = pkg.readInt();
            info.AgilityCompose = pkg.readInt();
            info.LuckCompose = pkg.readInt();
            infos.push(info);
         }
         aView = new AwardsView();
         aView.goodsList = infos;
         aView.boxType = 4;
         var title:FilterFrameText = ComponentFactory.Instance.creat("magichouse.collectionView.boxGetAwards");
         title.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
         title.x = 80;
         _frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.ItemPreviewListFrame");
         var itemName:String = LanguageMgr.GetTranslation("magichouse.collectionView.freeBoxItemName");
         var ai:AlertInfo = new AlertInfo(itemName);
         ai.showCancel = false;
         ai.moveEnable = false;
         _frame.info = ai;
         _frame.addToContent(aView);
         _frame.addToContent(title);
         _frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(_frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _getChargeBoxMessage(pkg:PackageIn) : void
      {
         var _frame:BaseAlerFrame = null;
         var info:BoxGoodsTempInfo = null;
         var currentCount:int = pkg.readInt();
         this._chargeGetCount -= currentCount;
         this._chargeGetTime = pkg.readDate();
         var count:int = pkg.readInt();
         var infos:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            info = new BoxGoodsTempInfo();
            info.TemplateId = pkg.readInt();
            info.ItemCount = pkg.readInt();
            info.ItemValid = pkg.readInt();
            info.IsBind = pkg.readBoolean();
            info.StrengthenLevel = pkg.readInt();
            info.AttackCompose = pkg.readInt();
            info.DefendCompose = pkg.readInt();
            info.AgilityCompose = pkg.readInt();
            info.LuckCompose = pkg.readInt();
            infos.push(info);
         }
         var aView:AwardsView = new AwardsView();
         aView.goodsList = infos;
         aView.boxType = 4;
         var title:FilterFrameText = ComponentFactory.Instance.creat("magichouse.collectionView.boxGetAwards");
         title.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
         title.x = 80;
         _frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.ItemPreviewListFrame");
         var itemName:String = LanguageMgr.GetTranslation("magichouse.collectionView.chargeBoxItemName");
         var ai:AlertInfo = new AlertInfo(itemName);
         ai.showCancel = false;
         ai.moveEnable = false;
         _frame.info = ai;
         _frame.addToContent(aView);
         _frame.addToContent(title);
         _frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(_frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameClose(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SoundManager.instance.play("008");
               frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               frame.dispose();
               SocketManager.Instance.out.sendClearStoreBag();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxAwardMessage"));
         }
      }
      
      public function checkGetFreeBoxTime() : Boolean
      {
         if(this._freeGetTime.getDate() != TimeManager.Instance.Now().getDate())
         {
            return true;
         }
         return false;
      }
      
      public function chechGetChargeBoxTime() : Boolean
      {
         if(this._chargeGetTime.getDate() != TimeManager.Instance.Now().getDate())
         {
            return true;
         }
         return false;
      }
      
      public function updateTitleTipData() : void
      {
      }
      
      public function get activityWeapons() : Array
      {
         return this._activityWeapons;
      }
      
      public function get magicJuniorLv() : int
      {
         return this._magicJuniorLv;
      }
      
      public function get magicJuniorExp() : int
      {
         return this._magicJuniorExp;
      }
      
      public function get magicMidLv() : int
      {
         return this._magicMidLv;
      }
      
      public function get magicMidExp() : int
      {
         return this._magicMidExp;
      }
      
      public function get magicSeniorLv() : int
      {
         return this._magicSeniorLv;
      }
      
      public function get magicSeniorExp() : int
      {
         return this._magicSeniorExp;
      }
      
      public function get freeGetCount() : int
      {
         return this._freeGetCount;
      }
      
      public function get freeGetTime() : Date
      {
         return this._freeGetTime;
      }
      
      public function get chargeGetCount() : int
      {
         return this._chargeGetCount;
      }
      
      public function get chargeGetTime() : Date
      {
         return this._chargeGetTime;
      }
      
      public function get depotCount() : int
      {
         return this._depotCount;
      }
      
      public function get juniorWeaponList() : Array
      {
         return this._juniorWeaponList;
      }
      
      public function get midWeaponList() : Array
      {
         return this._midWeaponList;
      }
      
      public function get seniorWeapinList() : Array
      {
         return this._seniorWeapinList;
      }
      
      public function get boxNeedmoney() : int
      {
         return this._boxNeedmoney;
      }
      
      public function get levelUpNumber() : Array
      {
         return this._levelUpNumber;
      }
      
      public function get openDepotNeedMoney() : int
      {
         return this._openDepotNeedMoney;
      }
      
      public function get depotPromoteNeedMoney() : int
      {
         return this._depotPromoteNeedMoney;
      }
      
      public function get equipOpenList() : Array
      {
         return this._equipOpenList;
      }
      
      public function get juniorAddAttribute() : Array
      {
         return this._juniorAddAttribute;
      }
      
      public function get midAddAttribute() : Array
      {
         return this._midAddAttribute;
      }
      
      public function get seniorAddAttribute() : Array
      {
         return this._seniorAddAttribute;
      }
      
      public function get titleDatas() : Array
      {
         return this._titleDatas;
      }
      
      public function createEntryBtn(hallPlayerView:HallPlayerView) : void
      {
         this._hallPlayerView = hallPlayerView;
         this._hallPlayerView.addEventListener(NewHallEvent.BTNCLICK,this.__onBtnClick);
         this._entryBtn = new MagicHouseEntryBtn();
         this._entryBtn.addEventListener(MouseEvent.CLICK,this.__entryBtnClickHandler);
         this._hallPlayerView.touchArea.addChild(this._entryBtn);
         this._hallPlayerView.hallView.addChild(this._entryBtn.content);
         PositionUtils.setPos(this._entryBtn,"magicHouse.hallIconPos");
         PositionUtils.setPos(this._entryBtn.content,"magicHouse.hallIconPos");
      }
      
      private function __entryBtnClickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._hallPlayerView.MapClickFlag = false;
         this._hallPlayerView.setSelfPlayerPos(new Point(620,370));
         HallStateView.btnID = BTNID_MAGICHOUSE;
      }
      
      private function __onBtnClick(e:NewHallEvent) : void
      {
         if(HallStateView.btnID == BTNID_MAGICHOUSE)
         {
            if(PlayerManager.Instance.Self.Grade >= 40)
            {
               this.show();
               HallStateView.btnID = -1;
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",40));
            }
         }
      }
      
      public function showMagicHouseView(view:int = 0) : void
      {
         this._magicHouseMainView = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame");
         this._magicHouseMainView.show(view);
      }
      
      public function closeMagicHouseView() : void
      {
         if(Boolean(this._magicHouseMainView))
         {
            this._magicHouseMainView.close();
         }
      }
      
      public function show(view:int = 0) : void
      {
         this.viewIndex = view;
         if(loadComplete)
         {
            this.showMagicHouseView(view);
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MAGICHOUSE);
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MAGICHOUSE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MAGICHOUSE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show(this.viewIndex);
         }
      }
   }
}

class MagicHouseInstance
{
   
   public function MagicHouseInstance()
   {
      super();
   }
}
