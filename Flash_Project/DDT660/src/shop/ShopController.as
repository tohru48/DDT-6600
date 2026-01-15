package shop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatBugleView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import shop.view.ShopLeftView;
   import shop.view.ShopRankingView;
   import shop.view.ShopRightView;
   
   public class ShopController extends BaseStateView
   {
      
      private var _leftView:ShopLeftView;
      
      private var _view:Sprite;
      
      private var _model:ShopModel;
      
      private var _rightView:ShopRightView;
      
      private var _rankingView:ShopRankingView;
      
      public function ShopController()
      {
         super();
      }
      
      public function get leftView() : ShopLeftView
      {
         return this._leftView;
      }
      
      public function get rightView() : ShopRightView
      {
         return this._rightView;
      }
      
      public function get rankingView() : ShopRankingView
      {
         return this._rankingView;
      }
      
      public function addTempEquip(item:ShopItemInfo) : Boolean
      {
         var boolean:Boolean = this._model.addTempEquip(item);
         this.showPanel(ShopLeftView.SHOW_DRESS);
         return boolean;
      }
      
      public function addToCar(item:ShopCarItemInfo) : Boolean
      {
         this._model.addToShoppingCar(item);
         if(this._model.isCarListMax())
         {
            return false;
         }
         return true;
      }
      
      public function buyItems(list:Array, dressing:Boolean, skin:String = "", isBandArr:Array = null) : void
      {
         var t:ShopCarItemInfo = null;
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var dresses:Array = new Array();
         var places:Array = new Array();
         var skins:Array = [];
         var goodsTyps:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            t = list[i];
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            colors.push(t.Color);
            places.push(t.place);
            if(t.CategoryID == EquipType.FACE)
            {
               skins.push(t.skin);
            }
            else
            {
               skins.push("");
            }
            dresses.push(dressing ? t.dressing : false);
            goodsTyps.push(t.isDiscount);
         }
         SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins,0,goodsTyps,isBandArr);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._view);
         this._model = null;
         this._leftView = null;
         this._rightView = null;
         this._rankingView = null;
         MainToolBar.Instance.hide();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev);
         SocketManager.Instance.out.sendCurrentState(1);
         SocketManager.Instance.out.sendUpdateGoodsCount();
         ChatManager.Instance.state = ChatManager.CHAT_SHOP_STATE;
         ChatBugleView.instance.hide();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.SHOPPING,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         SocketManager.Instance.out.sendGetShopBuyLimitedCount();
         this.init();
         StageReferance.stage.focus = StageReferance.stage;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.SHOP;
      }
      
      override public function getView() : DisplayObject
      {
         return this._view;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         PlayerManager.Instance.Self.Bag.unLockAll();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         super.leaving(next);
      }
      
      public function loadList() : void
      {
      }
      
      public function get model() : ShopModel
      {
         return this._model;
      }
      
      public function presentItems(list:Array, msg:String, nick:String) : void
      {
         var t:ShopCarItemInfo = null;
         var items:Array = new Array();
         var types:Array = new Array();
         var colors:Array = new Array();
         var skins:Array = [];
         var goodTypes:Array = new Array();
         for(var i:int = 0; i < list.length; i++)
         {
            t = list[i];
            items.push(t.GoodsID);
            types.push(t.currentBuyType);
            colors.push(t.Color);
            if(t.CategoryID == EquipType.FACE)
            {
               skins.push(this._model.currentModel.Skin);
            }
            else
            {
               skins.push("");
            }
            goodTypes.push(t.isDiscount);
         }
         SocketManager.Instance.out.sendPresentGoods(items,types,colors,goodTypes,msg,nick,skins,[]);
      }
      
      public function removeFromCar(item:ShopCarItemInfo) : void
      {
         this._model.removeFromShoppingCar(item);
      }
      
      public function removeTempEquip(item:ShopCarItemInfo) : void
      {
         this._model.removeTempEquip(item);
      }
      
      public function restoreAllItemsOnBody() : void
      {
         this._model.restoreAllItemsOnBody();
      }
      
      public function revertToDefault() : void
      {
         this._model.revertToDefalt();
      }
      
      public function setFittingModel(gender:Boolean) : void
      {
         this._rightView.setCurrentSex(gender ? 1 : 2);
         this._rightView.loadList();
         this._model.fittingSex = gender;
         this._leftView.hideLight();
         this._leftView.adjustUpperView(ShopLeftView.SHOW_DRESS);
         this._leftView.refreshCharater();
         this._rankingView.loadList();
      }
      
      public function setSelectedEquip(item:ShopCarItemInfo) : void
      {
         this._model.setSelectedEquip(item);
      }
      
      public function showPanel(type:uint) : void
      {
         this._leftView.adjustUpperView(type);
      }
      
      public function updateCost() : void
      {
         this._model.updateCost();
      }
      
      private function init() : void
      {
         this._model = new ShopModel();
         this._view = new Sprite();
         this._rightView = ComponentFactory.Instance.creatCustomObject("ddtshop.RightView");
         this._leftView = ComponentFactory.Instance.creatCustomObject("ddtshop.LeftView");
         this._rightView.setup(this);
         this._leftView.setup(this,this._model);
         this._view.addChild(this._leftView);
         this._view.addChild(this._rightView);
         MainToolBar.Instance.show();
         MainToolBar.Instance.setShopState();
         if(QQtipsManager.instance.isGotoShop)
         {
            QQtipsManager.instance.isGotoShop = false;
            this._rightView.gotoPage(ShopRightView.TOP_RECOMMEND,QQtipsManager.instance.indexCurrentShop - 1);
         }
         else
         {
            this._rightView.gotoPage(ShopRightView.TOP_TYPE,ShopRightView.SUB_TYPE,ShopRightView.CURRENT_PAGE,ShopRightView.CURRENT_GENDER);
         }
         this._rankingView = ComponentFactory.Instance.creatCustomObject("ddtshop.RankingView");
         this._rankingView.setup(this);
         this._view.addChild(this._rankingView);
         if(!QQtipsManager.instance.isGotoShop)
         {
            this.setFittingModel(ShopRightView.CURRENT_GENDER == 1);
         }
         if(NewSevenDayAndNewPlayerManager.Instance.enterShop)
         {
            this._rightView._shopMoneyGroup.selectIndex = 1;
            this._rightView.gotoPage(3,0);
         }
      }
   }
}

