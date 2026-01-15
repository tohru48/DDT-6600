package ddtBuried
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.ServerConfigInfo;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.TransactionsFrame;
   import ddt.view.UIModuleSmallLoading;
   import ddtBuried.data.MapItemData;
   import ddtBuried.data.SearchGoodsData;
   import ddtBuried.data.UpdateStarData;
   import ddtBuried.map.MapArrays;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.ColorMatrixFilter;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import labyrinth.LabyrinthManager;
   import road7th.comm.PackageIn;
   
   public class BuriedManager
   {
      
      private static var _instance:BuriedManager;
      
      public static const MAP1:int = 1;
      
      public static const MAP2:int = 2;
      
      public static const MAP3:int = 3;
      
      public static var evnetDispatch:EventDispatcher = new EventDispatcher();
      
      public var mapArrays:MapArrays;
      
      public var isOver:Boolean;
      
      private var _frame:BuriedFrame;
      
      public var mapdataList:Vector.<MapItemData>;
      
      public var mapID:int;
      
      public var level:int;
      
      public var nowPosition:int;
      
      private var num:int;
      
      private var serverConfigInfo:ServerConfigInfo;
      
      public var payMoneyList:Vector.<SearchGoodsData>;
      
      public var upDateStarList:Vector.<UpdateStarData>;
      
      private var pay_count:int;
      
      private var totol_count:int;
      
      public var limit:int;
      
      public var currPayLevel:int = -1;
      
      public var takeCardPayList:Array;
      
      private var cardPayinfo:ServerConfigInfo;
      
      public var eventPosition:int = -1;
      
      public var takeCardLimit:int;
      
      public var cardInitList:Array;
      
      public var currCardIndex:int;
      
      public var isContinue:Boolean;
      
      public var isGetGoods:Boolean;
      
      public var isOpenBuried:Boolean;
      
      public var isBuriedBox:Boolean;
      
      public var isGo:Boolean;
      
      public var isBack:Boolean;
      
      public var isBackToStart:Boolean;
      
      public var isGoEnd:Boolean;
      
      public var stoneNum:int;
      
      private var _isOpening:Boolean;
      
      private var _shopframe:BuriedShopFrame;
      
      public var currGoodID:int;
      
      private var _transactionsFrame:TransactionsFrame;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public var finalNum:int;
      
      public function BuriedManager()
      {
         super();
         this.mapArrays = new MapArrays();
      }
      
      public static function get Instance() : BuriedManager
      {
         if(!BuriedManager._instance)
         {
            BuriedManager._instance = new BuriedManager();
         }
         return BuriedManager._instance;
      }
      
      public function getTakeCardPay() : String
      {
         return this.takeCardPayList[3 - this.takeCardLimit];
      }
      
      public function get isOpening() : Boolean
      {
         return this._isOpening;
      }
      
      public function set isOpening(bool:Boolean) : void
      {
         this._isOpening = bool;
      }
      
      public function oneDegreeToTwoDegree(str:String, row:int, col:int) : Array
      {
         var i:int = 0;
         var oneDegree:Array = str.split(",");
         var k:int = 0;
         var twoDegree:Array = [];
         for(var j:int = 0; j < col; j++)
         {
            twoDegree[j] = [];
            for(i = 0; i < row; i++)
            {
               twoDegree[j][i] = int(oneDegree[k]);
               k++;
            }
         }
         return twoDegree;
      }
      
      public function setup() : void
      {
         this.initEvents();
      }
      
      public function checkMoney(bool:Boolean, money:int, fun:Function = null) : Boolean
      {
         this._money = money;
         this._outFun = fun;
         if(bool)
         {
            if(PlayerManager.Instance.Self.BandMoney < money)
            {
               if(fun != null)
               {
                  this.initAlertFarme();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
               }
               return true;
            }
         }
         else if(PlayerManager.Instance.Self.Money < money)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function initAlertFarme() : void
      {
         var frame:BaseAlerFrame = null;
         frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         frame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(this.checkMoney(false,this._money,this._outFun))
            {
               return;
            }
            if(Boolean(this._transactionsFrame))
            {
               this._transactionsFrame.dispose();
            }
            if(this._outFun != null)
            {
               this._outFun(false);
            }
         }
         e.currentTarget.dispose();
      }
      
      public function SearchGoodsTempHander(analyer:UpdateStarAnalyer) : void
      {
         this.upDateStarList = analyer.itemList;
      }
      
      public function getUpdateData(bool:Boolean) : UpdateStarData
      {
         var nextLevel:int = 0;
         var len:int = int(this.upDateStarList.length);
         if(bool)
         {
            nextLevel = this.level + 1;
         }
         else
         {
            nextLevel = this.level;
         }
         for(var i:int = 0; i < len; i++)
         {
            if(nextLevel == this.upDateStarList[i].StarID)
            {
               return this.upDateStarList[i];
            }
         }
         return null;
      }
      
      public function getPayData() : SearchGoodsData
      {
         var len:int = int(this.payMoneyList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.currPayLevel == this.payMoneyList[i].Number)
            {
               return this.payMoneyList[i];
            }
         }
         return null;
      }
      
      public function searchGoodsPayHander(analyzer:SearchGoodsPayAnalyer) : void
      {
         this.payMoneyList = analyzer.itemList;
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PlayerEnter,this.playerEnterHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PlayNowPosition,this.playNowPositionHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PlayerRollDice,this.playerRollDiceHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PlayerUpgradeStartLevel,this.playerUpgradeLevelEnterHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GetGoods,this.getGoodsHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FlopCard,this.flopCardHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TakeCardResponse,this.takeCardResponseHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RemoveEvent,this.removeEventHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OneStep,this.removeOneStepHandler);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.LABYRINTH_OVER,this.openShopView);
      }
      
      private function removeEventHandler(e:CrazyTankSocketEvent) : void
      {
         var obj:Object = new Object();
         obj.key = e.pkg.readInt();
         obj.value = e.pkg.readInt();
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.RemoveEvent,obj));
      }
      
      private function removeOneStepHandler(e:CrazyTankSocketEvent) : void
      {
         var obj:Object = new Object();
         obj.key = e.pkg.readInt();
         obj.value = e.pkg.readInt();
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.OneStep,obj));
      }
      
      private function takeCardResponseHandler(e:CrazyTankSocketEvent) : void
      {
         this.takeCardLimit = e.pkg.readInt();
         var tempID:int = e.pkg.readInt();
         var count:int = e.pkg.readInt();
         var obj:Object = new Object();
         obj.tempID = tempID;
         obj.count = count;
         evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.TAKE_CARD,obj));
      }
      
      private function flopCardHandler(e:CrazyTankSocketEvent) : void
      {
         var tempID:int = 0;
         var count:int = 0;
         var obj:Object = null;
         this.isOpenBuried = true;
         this.cardInitList = new Array();
         this.takeCardLimit = e.pkg.readInt();
         var conut:int = e.pkg.readInt();
         for(var i:int = 0; i < conut; i++)
         {
            tempID = e.pkg.readInt();
            count = e.pkg.readInt();
            obj = new Object();
            obj.tempID = tempID;
            obj.count = count;
            this.cardInitList.push(obj);
         }
      }
      
      private function getGoodsHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this.currGoodID = pkg.readInt();
         this.isGetGoods = true;
      }
      
      private function playNowPositionHander(e:CrazyTankSocketEvent) : void
      {
         this.isContinue = true;
         var pkg:PackageIn = e.pkg;
         this.eventPosition = pkg.readInt();
         if(this.eventPosition - this.nowPosition == 1)
         {
            this.isGo = true;
         }
         else if(this.nowPosition - this.eventPosition == 1)
         {
            this.isBack = true;
         }
         else if(this.eventPosition == 0)
         {
            this.isBackToStart = true;
         }
         else if(this.eventPosition == 35)
         {
            this.isGoEnd = true;
         }
      }
      
      private function playerRollDiceHander(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this.num = e.pkg.readInt();
         this.finalNum = this.num;
         var type:int = e.pkg.readInt();
         this.nowPosition = e.pkg.readInt();
         if(this.nowPosition == 35)
         {
            this.isOver = true;
         }
         if(this.nowPosition == 0)
         {
            evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.UPDATABTNSTATS));
         }
         this.limit = this.num - this.pay_count;
         switch(type)
         {
            case 1:
               this._frame.setCrFrame("one");
               break;
            case 2:
               this._frame.setCrFrame("two");
               break;
            case 3:
               this._frame.setCrFrame("three");
               break;
            case 4:
               this._frame.setCrFrame("four");
               break;
            case 5:
               this._frame.setCrFrame("five");
               break;
            case 6:
               this._frame.setCrFrame("six");
         }
         this._frame.play();
         if(this.limit <= 0)
         {
            this.currPayLevel = this.pay_count - this.num + 1;
            this.currPayLevel = 1;
            this._frame.upDataBtn();
            this._frame.setTxt(this.num.toString());
            return;
         }
         this.currPayLevel = -1;
         this._frame.setTxt(this.limit.toString());
      }
      
      public function getBuriedFrame() : Frame
      {
         return this._frame;
      }
      
      private function playerUpgradeLevelEnterHander(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this.level = pkg.readInt();
         this._frame.updataStarLevel(this.level);
      }
      
      private function playerEnterHander(e:CrazyTankSocketEvent) : void
      {
         var data:MapItemData = null;
         this.serverConfigInfo = ServerConfigManager.instance.serverConfigInfo["SearchGoodsFreeCount"];
         this.cardPayinfo = ServerConfigManager.instance.serverConfigInfo["SearchGoodsTakeCardMoney"];
         this.takeCardPayList = this.cardPayinfo.Value.split("|");
         this.pay_count = this.payMoneyList.length;
         this.totol_count = this.pay_count + int(this.serverConfigInfo.Value);
         this.dispose();
         this.mapdataList = new Vector.<MapItemData>();
         var pkg:PackageIn = e.pkg;
         this.mapID = pkg.readInt();
         this.level = pkg.readInt();
         this.nowPosition = pkg.readInt();
         this.num = pkg.readInt();
         this.isOver = false;
         if(this.num > this.pay_count)
         {
            this.limit = this.num - this.pay_count;
         }
         else
         {
            this.limit = this.num;
            this.currPayLevel = this.pay_count - this.num + 1;
         }
         var count:int = pkg.readInt();
         if(count == 0)
         {
            return;
         }
         for(var i:int = 0; i < count; i++)
         {
            data = new MapItemData();
            data.type = pkg.readInt();
            data.tempID = pkg.readInt();
            this.mapdataList.push(data);
         }
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this.initBuriedFrame();
      }
      
      public function getBuriedStoneNum() : String
      {
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         var num:int = bagInfo.getItemCountByTemplateId(11680);
         return num.toString();
      }
      
      public function setRemindRoll(bool:Boolean) : void
      {
         SharedManager.Instance.isRemindRoll = bool;
      }
      
      public function getRemindRoll() : Boolean
      {
         return SharedManager.Instance.isRemindRoll;
      }
      
      public function setRemindOverCard(bool:Boolean) : void
      {
         SharedManager.Instance.isRemindOverCard = bool;
      }
      
      public function getRemindOverCard() : Boolean
      {
         return SharedManager.Instance.isRemindOverCard;
      }
      
      public function setRemindOverBind(bool:Boolean) : void
      {
         SharedManager.Instance.isRemindOverCardBind = bool;
      }
      
      public function getRemindOverBind() : Boolean
      {
         return SharedManager.Instance.isRemindOverCardBind;
      }
      
      public function setRemindRollBind(bool:Boolean) : void
      {
         SharedManager.Instance.isRemindRollBind = bool;
      }
      
      public function getRemindRollBind() : Boolean
      {
         return SharedManager.Instance.isRemindRollBind;
      }
      
      public function initBuriedFrame() : void
      {
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_BURIED);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtBuried.BuriedFrame");
            this._frame.addDiceView(this.mapID);
            this._frame.setTxt(this.limit.toString());
            this._frame.setStarList(this.level);
            if(this.currPayLevel >= 0)
            {
               this._frame.upDataBtn();
               this._frame.setTxt(this.num.toString());
            }
            this._isOpening = true;
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function createActivityFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.DDT_BURIED)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtBuried.BuriedFrame");
         this._frame.addDiceView(this.mapID);
         this._frame.setTxt(this.limit.toString());
         if(this.currPayLevel >= 0)
         {
            this._frame.upDataBtn();
            this._frame.setTxt(this.num.toString());
         }
         this._isOpening = true;
         this._frame.setStarList(this.level);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_BURIED)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      private function openShopView(e:BuriedEvent) : void
      {
         if(!this._frame)
         {
            return;
         }
         this._shopframe = ComponentFactory.Instance.creatComponentByStylename("ddtburied.view.labyrinthShopFrame");
         this._shopframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(this._shopframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function openshopHander() : void
      {
         if(LabyrinthManager.Instance.UILoadComplete)
         {
            this._shopframe = ComponentFactory.Instance.creatComponentByStylename("ddtburied.view.labyrinthShopFrame");
            this._shopframe.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
            LayerManager.Instance.addToLayer(this._shopframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            LabyrinthManager.Instance.loadUIModule();
         }
      }
      
      protected function frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._shopframe.dispose();
      }
      
      public function dispose() : void
      {
         this._outFun = null;
         this.currPayLevel = -1;
         this._isOpening = false;
         this.isContinue = false;
         this.isGetGoods = false;
         this.isOpenBuried = false;
         this.isBuriedBox = false;
         this.isGo = false;
         this.isBack = false;
         this.isBackToStart = false;
         this.isGoEnd = false;
         this.isOver = false;
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.dispose();
         }
         if(Boolean(this._shopframe) && Boolean(this._shopframe.parent))
         {
            this._shopframe.dispose();
         }
         if(Boolean(this._shopframe) && Boolean(this._shopframe.parent))
         {
            this._shopframe.dispose();
         }
         if(Boolean(this._transactionsFrame) && Boolean(this._transactionsFrame.parent))
         {
            this._transactionsFrame.dispose();
         }
         this._frame = null;
         this._shopframe = null;
         this._transactionsFrame = null;
      }
      
      public function showTransactionFrame(str:String, payFun:Function = null, clickFun:Function = null, target:Sprite = null) : void
      {
         this._transactionsFrame = ComponentFactory.Instance.creatComponentByStylename("ddtBuried.views.TransactionsFrame");
         this._transactionsFrame.setTxt(str);
         this._transactionsFrame.buyFunction = payFun;
         this._transactionsFrame.clickFunction = clickFun;
         this._transactionsFrame.target = target;
         LayerManager.Instance.addToLayer(this._transactionsFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function applyGray(child:DisplayObject) : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.applyFilter(child,matrix);
      }
      
      public function reGray(child:DisplayObject) : void
      {
         child.filters = null;
      }
      
      private function applyFilter(child:DisplayObject, matrix:Array) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var filters:Array = new Array();
         filters.push(filter);
         child.filters = filters;
      }
      
      public function checkShowIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.BURIED,true);
      }
   }
}

