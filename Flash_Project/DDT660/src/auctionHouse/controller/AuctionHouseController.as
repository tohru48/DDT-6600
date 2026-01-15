package auctionHouse.controller
{
   import auctionHouse.AuctionState;
   import auctionHouse.IAuctionHouse;
   import auctionHouse.analyze.AuctionAnalyzer;
   import auctionHouse.model.AuctionHouseModel;
   import auctionHouse.view.AuctionHouseView;
   import auctionHouse.view.AuctionRightView;
   import auctionHouse.view.FastAuctionView;
   import auctionHouse.view.SimpleLoading;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.MD5;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import flash.net.URLVariables;
   import trainer.data.Step;
   
   public class AuctionHouseController extends BaseStateView
   {
      
      private var _model:AuctionHouseModel;
      
      private var _view:IAuctionHouse;
      
      private var _fastAuctionView:FastAuctionView;
      
      private var _isFastAuction:Boolean = false;
      
      private var _rightView:AuctionRightView;
      
      public function AuctionHouseController(isFastAuction:Boolean = false, auctionID:String = "0")
      {
         super();
         this._isFastAuction = isFastAuction;
         if(isFastAuction)
         {
            this.initAuction(auctionID);
         }
      }
      
      public function initAuction(auctionID:String) : void
      {
         this._model = new AuctionHouseModel();
         AuctionState.CURRENTSTATE = AuctionState.FASTAUCTION;
         this._model.state = AuctionState.CURRENTSTATE;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
         this.searchFastAuction(auctionID);
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this._model = new AuctionHouseModel();
         this._view = new AuctionHouseView(this,this._model);
         this._view.show();
         AuctionState.CURRENTSTATE = "browse";
         this._model.category = ItemManager.Instance.categorys;
         MainToolBar.Instance.show();
         MainToolBar.Instance.setAuctionHouseState();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VISIT_AUCTION) && Boolean(TaskManager.instance.getQuestDataByID(466)))
         {
            SocketManager.Instance.out.sendQuestCheck(466,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.VISIT_AUCTION);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
      }
      
      public function set model(mo:AuctionHouseModel) : void
      {
         this._model = mo;
      }
      
      public function get model() : AuctionHouseModel
      {
         return this._model;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         super.leaving(next);
         this.dispose();
         MainToolBar.Instance.hide();
         PlayerManager.Instance.Self.unlockAllBag();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.AUCTION;
      }
      
      public function setState(value:String) : void
      {
         this._model.state = value;
         AuctionState.CURRENTSTATE = value;
      }
      
      public function browseTypeChange(info:CateCoryInfo, id:int = -1) : void
      {
         var tempInfo:CateCoryInfo = null;
         if(info == null)
         {
            tempInfo = this._model.getCatecoryById(id);
         }
         else
         {
            tempInfo = info;
         }
         this._model.currentBrowseGoodInfo = tempInfo;
      }
      
      public function browseTypeChangeNull() : void
      {
         this._model.currentBrowseGoodInfo = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._view))
         {
            this._view.hide();
         }
         this._view = null;
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._model = null;
         if(Boolean(this._rightView))
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function searchAuctionList(page:int, name:String, type:int, pay:int, userID:int, buyId:int, sortIndex:uint = 0, sortBy:String = "false", Auctions:String = "") : void
      {
         if(AuctionHouseModel.searchType == 1)
         {
            name = "";
         }
         this.startLoadAuctionInfo(page,name,type,pay,userID,buyId,sortIndex,sortBy,Auctions);
         (this._view as AuctionHouseView).forbidChangeState();
      }
      
      public function searchFastAuction(Auctions:String = "") : void
      {
         this.startLoadAuctionInfo(1,"",-1,-1,-1,-2,0,"false",Auctions);
      }
      
      private function startLoadAuctionInfo(page:int, name:String, type:int, pay:int, userID:int, buyId:int, sortIndex:uint = 0, sortBy:String = "false", Auctions:String = "") : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["page"] = page;
         args["name"] = name;
         args["type"] = type;
         args["pay"] = pay;
         args["userID"] = userID;
         args["buyID"] = buyId;
         args["order"] = sortIndex;
         args["sort"] = sortBy;
         args["Auctions"] = Auctions;
         args["selfid"] = PlayerManager.Instance.Self.ID;
         args["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AuctionPageList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseListError");
         loader.analyzer = new AuctionAnalyzer(this.__searchResult);
         LoadResourceManager.Instance.startLoad(loader);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         mouseChildren = false;
         mouseEnabled = false;
         if(AuctionHouseModel._dimBooble == false && this._isFastAuction == false)
         {
            SimpleLoading.instance.show();
         }
      }
      
      private function __searchResult(action:AuctionAnalyzer) : void
      {
         var i:int = 0;
         var j:int = 0;
         var auctionIDs:Array = null;
         var k:int = 0;
         mouseChildren = true;
         mouseEnabled = true;
         if(!this._view && !this._isFastAuction)
         {
            return;
         }
         if(Boolean(this._view))
         {
            SimpleLoading.instance.hide();
         }
         var list:Vector.<AuctionGoodsInfo> = action.list;
         if(this._model.state == AuctionState.SELL)
         {
            this._model.clearMyAuction();
            for(i = 0; i < list.length; i++)
            {
               this._model.addMyAuction(list[i]);
            }
            this._model.sellTotal = action.total;
         }
         else if(this._model.state == AuctionState.BROWSE)
         {
            this._model.clearBrowseAuctionData();
            if(list.length == 0 && AuctionHouseModel.searchType != 3)
            {
               if(AuctionHouseModel._dimBooble == false)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseController"));
               }
            }
            for(j = 0; j < list.length; j++)
            {
               this._model.addBrowseAuctionData(list[j]);
            }
            this._model.browseTotal = action.total;
         }
         else if(this._model.state == AuctionState.BUY)
         {
            auctionIDs = new Array();
            this._model.clearBuyAuctionData();
            for(k = 0; k < list.length; k++)
            {
               this._model.addBuyAuctionData(list[k]);
               auctionIDs.push(list[k].AuctionID);
            }
            this._model.buyTotal = action.total;
            SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = auctionIDs;
            SharedManager.Instance.save();
         }
         else if(this._model.state == AuctionState.FASTAUCTION)
         {
            if(list.length == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.controller.noAuction"));
               this.dispose();
               SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
               return;
            }
            this._fastAuctionView = ComponentFactory.Instance.creat("auctionHouse.FastAuctionView",[list[0],this,this._model]);
            LayerManager.Instance.addToLayer(this._fastAuctionView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
            this._fastAuctionView.addEventListener(FrameEvent.RESPONSE,this.fastAuctionResponse);
         }
         if(Boolean(this._view))
         {
            (this._view as AuctionHouseView).allowChangeState();
         }
      }
      
      public function disposeMe() : void
      {
         this.dispose();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
         if(Boolean(this._rightView))
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function fastAuctionResponse(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this._fastAuctionView.dispose();
            this._fastAuctionView = null;
            this.dispose();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,this.__updateAuction);
         }
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __updateAuction(event:CrazyTankSocketEvent) : void
      {
         var item:Boolean = false;
         var bag:InventoryItemInfo = null;
         event.pkg.deCompress();
         var info:AuctionGoodsInfo = new AuctionGoodsInfo();
         info.AuctionID = event.pkg.readInt();
         var isExist:Boolean = event.pkg.readBoolean();
         if(isExist)
         {
            info.AuctioneerID = event.pkg.readInt();
            info.AuctioneerName = event.pkg.readUTF();
            info.beginDateObj = event.pkg.readDate();
            info.BuyerID = event.pkg.readInt();
            info.BuyerName = event.pkg.readUTF();
            info.ItemID = event.pkg.readInt();
            info.Mouthful = event.pkg.readInt();
            info.PayType = event.pkg.readInt();
            info.Price = event.pkg.readInt();
            info.Rise = event.pkg.readInt();
            info.ValidDate = event.pkg.readInt();
            item = event.pkg.readBoolean();
            if(item)
            {
               bag = new InventoryItemInfo();
               bag.Count = event.pkg.readInt();
               bag.TemplateID = event.pkg.readInt();
               bag.AttackCompose = event.pkg.readInt();
               bag.DefendCompose = event.pkg.readInt();
               bag.AgilityCompose = event.pkg.readInt();
               bag.LuckCompose = event.pkg.readInt();
               bag.StrengthenLevel = event.pkg.readInt();
               bag.IsBinds = event.pkg.readBoolean();
               bag.IsJudge = event.pkg.readBoolean();
               bag.BeginDate = event.pkg.readDateString();
               bag.ValidDate = event.pkg.readInt();
               bag.Color = event.pkg.readUTF();
               bag.Skin = event.pkg.readUTF();
               bag.IsUsed = event.pkg.readBoolean();
               bag.Hole1 = event.pkg.readInt();
               bag.Hole2 = event.pkg.readInt();
               bag.Hole3 = event.pkg.readInt();
               bag.Hole4 = event.pkg.readInt();
               bag.Hole5 = event.pkg.readInt();
               bag.Hole6 = event.pkg.readInt();
               bag.Pic = event.pkg.readUTF();
               bag.RefineryLevel = event.pkg.readInt();
               bag.DiscolorValidDate = event.pkg.readDateString();
               bag.Hole5Level = event.pkg.readByte();
               bag.Hole5Exp = event.pkg.readInt();
               bag.Hole6Level = event.pkg.readByte();
               bag.Hole6Exp = event.pkg.readInt();
               ItemManager.fill(bag);
               info.BagItemInfo = bag;
               this._model.sellTotal += 1;
            }
            this._model.addMyAuction(info);
         }
         else
         {
            this._model.removeMyAuction(info);
         }
      }
      
      public function visibleHelp(rightView:AuctionRightView, frame:int) : void
      {
         this._rightView = rightView;
      }
   }
}

