package luckStar.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import luckStar.LoadingLuckStarUI;
   import luckStar.event.LuckStarEvent;
   import luckStar.model.LuckStarModel;
   import luckStar.view.LuckStarFrame;
   import road7th.comm.PackageIn;
   
   public class LuckStarManager
   {
      
      private static var _instance:LuckStarManager;
      
      private var _frame:LuckStarFrame;
      
      private var _model:LuckStarModel;
      
      private var _isOpen:Boolean;
      
      public function LuckStarManager()
      {
         super();
         this._model = new LuckStarModel();
      }
      
      public static function get Instance() : LuckStarManager
      {
         if(_instance == null)
         {
            _instance = new LuckStarManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_OPEN,this.__onActivityOpen);
      }
      
      private function __onActivityOpen(e:CrazyTankSocketEvent) : void
      {
         if(!this._isOpen)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_END,this.__onActivityEnd);
         }
         this._isOpen = true;
         this.addEnterIcon();
      }
      
      private function __onActivityEnd(e:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_END,this.__onActivityEnd);
         this._isOpen = false;
         this.disposeEnterIcon();
      }
      
      private function __onAllGoodsInfo(e:CrazyTankSocketEvent) : void
      {
         var templateID:int = 0;
         var iteminfo:InventoryItemInfo = null;
         var pkg:PackageIn = e.pkg;
         this._model.coins = pkg.readInt();
         this._model.setActivityDate(pkg.readDate(),pkg.readDate());
         this._model.minUseNum = pkg.readInt();
         var count:int = pkg.readInt();
         var list:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         for(var i:int = 0; i < count; i++)
         {
            templateID = pkg.readInt();
            iteminfo = this.getTemplateInfo(templateID);
            iteminfo.StrengthenLevel = pkg.readInt();
            iteminfo.Count = pkg.readInt();
            iteminfo.ValidDate = pkg.readInt();
            iteminfo.AttackCompose = pkg.readInt();
            iteminfo.DefendCompose = pkg.readInt();
            iteminfo.AgilityCompose = pkg.readInt();
            iteminfo.LuckCompose = pkg.readInt();
            iteminfo.IsBinds = pkg.readBoolean();
            iteminfo.Quality = pkg.readInt();
            list.push(iteminfo);
         }
         var arr:Vector.<InventoryItemInfo> = list.slice();
         var index:int = int(arr.length);
         while(Boolean(index))
         {
            arr.push(arr.splice(int(Math.random() * index--),1)[0]);
         }
         this._model.goods = arr;
         if(Boolean(this._frame))
         {
            this._frame.updateActivityDate();
         }
      }
      
      private function __onTurnGoodsInfo(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this._model.coins = pkg.readInt();
         var templateID:int = pkg.readInt();
         var iteminfo:InventoryItemInfo = this.getTemplateInfo(templateID);
         iteminfo.StrengthenLevel = pkg.readInt();
         iteminfo.Count = pkg.readInt();
         iteminfo.ValidDate = pkg.readInt();
         iteminfo.AttackCompose = pkg.readInt();
         iteminfo.DefendCompose = pkg.readInt();
         iteminfo.AgilityCompose = pkg.readInt();
         iteminfo.LuckCompose = pkg.readInt();
         iteminfo.IsBinds = pkg.readBoolean();
         this._frame.getAwardGoods(iteminfo);
      }
      
      private function __onUpdateReward(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var goodsID:int = pkg.readInt();
         var count:int = pkg.readInt();
         var name:String = pkg.readUTF();
         this._frame.updateNewAwardList(name,goodsID,count);
      }
      
      private function __onReward(e:CrazyTankSocketEvent) : void
      {
         var arr:Array = null;
         var pkg:PackageIn = e.pkg;
         var count:int = pkg.readInt();
         var list:Vector.<Array> = new Vector.<Array>();
         for(var i:int = 0; i < count; i++)
         {
            arr = [];
            arr.push(pkg.readInt());
            arr.push(pkg.readInt());
            arr.push(pkg.readUTF());
            list.push(arr);
         }
         this._model.newRewardList = list;
      }
      
      private function __onAwardRank(e:CrazyTankSocketEvent) : void
      {
         var templateID:int = 0;
         var iteminfo:InventoryItemInfo = null;
         var pkg:PackageIn = e.pkg;
         var count:int = pkg.readInt();
         var list:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         for(var i:int = 0; i < count; i++)
         {
            templateID = pkg.readInt();
            iteminfo = this.getTemplateInfo(templateID);
            iteminfo.StrengthenLevel = pkg.readInt();
            iteminfo.Count = pkg.readInt();
            iteminfo.ValidDate = pkg.readInt();
            iteminfo.AttackCompose = pkg.readInt();
            iteminfo.DefendCompose = pkg.readInt();
            iteminfo.AgilityCompose = pkg.readInt();
            iteminfo.LuckCompose = pkg.readInt();
            iteminfo.IsBinds = pkg.readBoolean();
            iteminfo.Quality = pkg.readInt();
            list.push(iteminfo);
         }
         this._model.reward = list;
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      private function _onLuckyStarEvent(e:LuckStarEvent) : void
      {
         if(Boolean(this._frame))
         {
            if(e.code == LuckStarEvent.GOODS)
            {
               this._frame.updateCellInfo();
               this._frame.updateMinUseNum();
            }
            else if(e.code == LuckStarEvent.COINS)
            {
               this._frame.updateLuckyStarCoins();
            }
            else if(e.code == LuckStarEvent.NEW_REWARD_LIST)
            {
               this._frame.updatePlayActionList();
            }
         }
      }
      
      public function addEnterIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTAR,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.LUCKSTAR,true,10);
         }
      }
      
      public function onClickLuckyStarIocn(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoadingLuckStarUI.Instance.startLoad();
         }
      }
      
      public function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTAR,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.LUCKSTAR,false);
      }
      
      public function dispose() : void
      {
         this.disposeEnterIcon();
      }
      
      public function openLuckyStarFrame() : void
      {
         if(this._frame == null)
         {
            this._frame = ComponentFactory.Instance.creat("luckyStar.view.LuckStarFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.luckStar.frameTitle");
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._model.addEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this._onLuckyStarEvent);
         }
         LoadingLuckStarUI.Instance.RequestActivityRank();
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.addSocketEvent();
         SocketManager.Instance.out.sendLuckyStarEnter();
      }
      
      private function __onFrameClose(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            if(this._frame.isTurn)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.luckStar.notExit"));
               return;
            }
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._model.removeEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this._onLuckyStarEvent);
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
            SocketManager.Instance.out.sendLuckyStarClose();
            this.removeSocketEvent();
         }
      }
      
      public function addSocketEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,this.__onTurnGoodsInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,this.__onUpdateReward);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,this.__onAllGoodsInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_RECORD,this.__onReward);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,this.__onAwardRank);
      }
      
      public function removeSocketEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,this.__onTurnGoodsInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,this.__onUpdateReward);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,this.__onAllGoodsInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_RECORD,this.__onReward);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,this.__onAwardRank);
      }
      
      public function updateLuckyStarRank(value:Object) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.updateRankInfo();
         }
      }
      
      public function get openState() : Boolean
      {
         return this._frame != null;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get model() : LuckStarModel
      {
         return this._model;
      }
   }
}

