package christmas.manager
{
   import christmas.data.ChristmasPackageType;
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.items.ExpBar;
   import christmas.loader.LoaderChristmasUIModule;
   import christmas.model.ChristmasModel;
   import christmas.player.PlayerVO;
   import christmas.view.ChristmasChooseRoomFrame;
   import christmas.view.makingSnowmenView.ChristmasMakingSnowmenFrame;
   import christmas.view.makingSnowmenView.SnowPackDoubleFrame;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import ddt.data.BagInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ChristmasManager extends EventDispatcher
   {
      
      private static var _instance:ChristmasManager;
      
      public static var isFrameChristmas:Boolean;
      
      public static var isToRoom:Boolean;
      
      public static var isComeRoom:Boolean;
      
      private var _self:SelfInfo;
      
      private var _model:ChristmasModel;
      
      private var _isShowIcon:Boolean = false;
      
      private var _makingSnoFrame:ChristmasMakingSnowmenFrame;
      
      private var _christmasResourceId:String;
      
      private var _currentPVE_ID:int;
      
      private var _mapPath:String;
      
      private var _appearPos:Array = new Array();
      
      private var _christmasInfo:ChristmasSystemItemsInfo;
      
      private var _snowPackDoubleFrame:SnowPackDoubleFrame;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      private var _goods:ShopItemInfo;
      
      private var _chooseRoomFrame:ChristmasChooseRoomFrame;
      
      public function ChristmasManager(pct:PrivateClass)
      {
         super();
      }
      
      public static function get instance() : ChristmasManager
      {
         if(ChristmasManager._instance == null)
         {
            ChristmasManager._instance = new ChristmasManager(new PrivateClass());
         }
         return ChristmasManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new ChristmasModel();
         this._self = new SelfInfo();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         var event:CrazyTankSocketEvent = null;
         switch(cmd)
         {
            case ChristmasPackageType.CHRISTMAS_OPENORCLOSE:
               this.openOrclose(pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER:
               this.enterChristmasGame(pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_MAKING_SNOWMAN_ENTER:
               this.makingSnowmanEnter(pkg);
               break;
            case ChristmasPackageType.FIGHT_SPIRIT_LEVELUP:
               this.snowIsUpdata(pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_PACKS:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_PACKS,pkg);
               break;
            case ChristmasPackageType.GET_PAKCS_TO_PLAYER:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,pkg);
               break;
            case ChristmasPackageType.PLAYER_STATUE:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STATUE,pkg);
               break;
            case ChristmasPackageType.MOVE:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_MOVE,pkg);
               break;
            case ChristmasPackageType.ADDPLAYER:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADDPLAYER_ROOM,pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_EXIT:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_EXIT,pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_MONSTER:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_MONSTER,pkg);
               break;
            case ChristmasPackageType.CHRISTMAS_ROOM_SPEAK:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,pkg);
               break;
            case ChristmasPackageType.UPDATE_TIMES_ROOM:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function enterChristmasGame(pkg:PackageIn) : void
      {
         this._goods = ShopManager.Instance.getGoodsByTemplateID(201145);
         this._model.isEnter = pkg.readBoolean();
         if(this._model.isEnter)
         {
            this._model.gameBeginTime = pkg.readDate();
            this._model.gameEndTime = pkg.readDate();
            this._model.count = pkg.readInt();
            this.playingSnowmanEnter();
         }
         else
         {
            this.showTransactionFrame(LanguageMgr.GetTranslation("christmas.buy.playingSnowman.volumes",this._goods.AValue1),this.buyPlayingSnowmanVolumes,null,null,false,false,1);
         }
      }
      
      private function buyPlayingSnowmanVolumes(num:int = 0) : void
      {
         if(!this.checkMoney(this._goods.AValue1))
         {
            SocketManager.Instance.out.sendBuyPlayingSnowmanVolumes();
         }
      }
      
      public function playingSnowmanEnter() : void
      {
         this._mapPath = LoaderChristmasUIModule.Instance.getChristmasResource() + "/map/ChristmasMap.swf";
         this._christmasInfo.playerDefaultPos = new Point(500,500);
         this._christmasInfo.myPlayerVO.playerPos = this._christmasInfo.playerDefaultPos;
         this._christmasInfo.myPlayerVO.playerStauts = 0;
         LoaderChristmasUIModule.Instance.loadMap();
      }
      
      private function snowIsUpdata(pkg:PackageIn) : void
      {
         var curSnowmenUpInfo:ChristmasSystemItemsInfo = new ChristmasSystemItemsInfo();
         curSnowmenUpInfo.isUp = pkg.readBoolean();
         this._model.count = pkg.readInt();
         this._model.exp = pkg.readInt();
         curSnowmenUpInfo.num = pkg.readInt();
         curSnowmenUpInfo.snowNum = pkg.readInt();
         if(Boolean(this._makingSnoFrame))
         {
            this._makingSnoFrame.upDatafitCount();
            this._makingSnoFrame.snowmenAction(curSnowmenUpInfo);
            dispatchEvent(new ChristmasRoomEvent(ChristmasRoomEvent.SCORE_CONVERT));
         }
      }
      
      private function makingSnowmanEnter(pkg:PackageIn) : void
      {
         this._model.count = pkg.readInt();
         this._model.exp = pkg.readInt();
         this._model.totalExp = 10;
         this._model.awardState = pkg.readInt();
         this._model.packsNumber = pkg.readInt();
         this._makingSnoFrame = ComponentFactory.Instance.creatComponentByStylename("chooseRoom.christmas.ChristmasMakingSnowmenFrame");
         LayerManager.Instance.addToLayer(this._makingSnoFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         var list:Vector.<ChristmasSystemItemsInfo> = null;
         var i:int = 0;
         var cellInfo:ChristmasSystemItemsInfo = null;
         this._model.isOpen = pkg.readBoolean();
         if(this._model.isOpen)
         {
            this._model.beginTime = pkg.readDate();
            this._model.endTime = pkg.readDate();
            this._model.packsLen = pkg.readInt();
            this._model.snowPackNum = new Array();
            list = new Vector.<ChristmasSystemItemsInfo>();
            for(i = 0; i < this._model.packsLen; i++)
            {
               cellInfo = new ChristmasSystemItemsInfo();
               cellInfo.TemplateID = pkg.readInt();
               list.push(cellInfo);
               this._model.snowPackNum[i] = pkg.readInt();
            }
            this._model.lastPacks = pkg.readInt();
            this._model.money = pkg.readInt();
            this._model.myGiftData = list;
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            if(StateManager.currentStateType == StateType.CHRISTMAS || StateManager.currentStateType == StateType.CHRISTMAS_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
         }
      }
      
      public function getBagSnowPacksCount() : int
      {
         var _selfInfo:SelfInfo = PlayerManager.Instance.Self;
         var bagInfo:BagInfo = _selfInfo.getBag(BagInfo.PROPBAG);
         return bagInfo.getItemCountByTemplateId(201144);
      }
      
      public function showEnterIcon() : void
      {
         this._isShowIcon = true;
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHRISTMAS,true);
         this._christmasInfo = new ChristmasSystemItemsInfo();
         this._christmasInfo.myPlayerVO = new PlayerVO();
      }
      
      public function onClickChristmasIcon(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.Icon.NoEnter"));
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderChristmasUIModule.Instance.loadUIModule(this.doOpenChristmasFrame);
         }
      }
      
      private function doOpenChristmasFrame() : void
      {
         if(this._isShowIcon)
         {
            this._chooseRoomFrame = ComponentFactory.Instance.creatComponentByStylename("chooseRoom.christmas.ChristmasChooseRoomFrame");
            LayerManager.Instance.addToLayer(this._chooseRoomFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function get expBar() : ExpBar
      {
         return this._makingSnoFrame.expBar;
      }
      
      public function get christmasInfo() : ChristmasSystemItemsInfo
      {
         return this._christmasInfo;
      }
      
      public function getCount() : int
      {
         var _selfInfo:SelfInfo = PlayerManager.Instance.Self;
         var bagInfo:BagInfo = _selfInfo.getBag(BagInfo.PROPBAG);
         return bagInfo.getItemCountByTemplateId(201144);
      }
      
      public function showTransactionFrame(str:String, payFun:Function = null, clickFun:Function = null, target:Sprite = null, isShow:Boolean = true, isAddFrame:Boolean = false, select:int = 0) : void
      {
         this._snowPackDoubleFrame = ComponentFactory.Instance.creatComponentByStylename("christmas.views.SnowPackDoubleFrame");
         this._snowPackDoubleFrame.setTxt(str);
         this._snowPackDoubleFrame.buyFunction = payFun;
         this._snowPackDoubleFrame.clickFunction = clickFun;
         this._snowPackDoubleFrame.setIsShow(isShow,select);
         this._snowPackDoubleFrame.initAddView(isAddFrame);
         this._snowPackDoubleFrame.target = target;
         LayerManager.Instance.addToLayer(this._snowPackDoubleFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function setRemindSnowPackDouble(bool:Boolean) : void
      {
         SharedManager.Instance.isRemindSnowPackDouble = bool;
      }
      
      public function getRemindSnowPackDouble() : Boolean
      {
         return SharedManager.Instance.isRemindSnowPackDouble;
      }
      
      public function checkMoney(money:int) : Boolean
      {
         this._money = money;
         if(PlayerManager.Instance.Self.Money < money)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         this.disposeEnterIcon();
      }
      
      public function disposeEnterIcon() : void
      {
         if(Boolean(this._makingSnoFrame))
         {
            this._makingSnoFrame.dispose();
            this._makingSnoFrame = null;
         }
         if(Boolean(this._chooseRoomFrame))
         {
            this._chooseRoomFrame.dispose();
            this._chooseRoomFrame = null;
         }
         if(Boolean(this._snowPackDoubleFrame))
         {
            this._snowPackDoubleFrame.dispose();
            this._snowPackDoubleFrame = null;
         }
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHRISTMAS,false);
      }
      
      public function returnComponentBnt(bnt:BaseButton, tipName:String) : Component
      {
         var compoent:Component = null;
         compoent = new Component();
         compoent.tipData = tipName;
         compoent.tipDirctions = "0,1,2";
         compoent.tipStyle = "ddt.view.tips.OneLineTip";
         compoent.tipGapH = 20;
         compoent.width = bnt.width;
         compoent.x = bnt.x;
         compoent.y = bnt.y;
         bnt.x = 0;
         bnt.y = 0;
         compoent.addChild(bnt);
         return compoent;
      }
      
      public function exitGame() : void
      {
         GameInSocketOut.sendGamePlayerExit();
      }
      
      public function CanGetGift(step:int) : Boolean
      {
         return (ChristmasManager.instance.model.awardState >> step & 1) == 0;
      }
      
      public function get model() : ChristmasModel
      {
         return this._model;
      }
      
      public function get mapPath() : String
      {
         return this._mapPath;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
