package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import shop.manager.ShopGiftsManager;
   import shop.view.BuySingleGoodsView;
   
   public class RoomTicketView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _buyBtn:IconButton;
      
      private var _giftBtn:IconButton;
      
      private var _buyLight:MovieClip;
      
      private var _giftLight:MovieClip;
      
      private var _level:int;
      
      private var _ticketsID:Array = [EquipType.EASY_TICKET_ID,EquipType.NORMAL_TICKET_ID,EquipType.HARD_TICKET_ID,EquipType.HERO_TICKET_ID,EquipType.EPIC_TICKET_ID];
      
      private var _ticketsFootballID:Array = [0,EquipType.FOOTBALL_NORMAL_TICKET_ID,EquipType.FOOTBALL_HARD_TICKET_ID,EquipType.FOOTBALL_HERO_TICKET_ID,0];
      
      private var _view:BuySingleGoodsView;
      
      public function RoomTicketView()
      {
         super();
         this.preInitializer();
         this.initializer();
         this.initialEvent();
      }
      
      private function preInitializer() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.Bg");
         this._buyLight = ComponentFactory.Instance.creat("asset.warriorsArena.buyButton.Light");
         this._giftLight = ComponentFactory.Instance.creat("asset.warriorsArena.giftButton.Light");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.buyButton");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.giftButton");
      }
      
      private function initializer() : void
      {
         addChild(this._bg);
         addChild(this._buyBtn);
         addChild(this._giftBtn);
         this._buyLight.mouseChildren = this._buyLight.mouseEnabled = false;
         this._buyLight.x = this._buyBtn.x;
         this._buyLight.y = this._buyBtn.y;
         addChild(this._buyLight);
         this._giftLight.mouseChildren = this._giftLight.mouseEnabled = false;
         this._giftLight.x = this._giftBtn.x;
         this._giftLight.y = this._giftBtn.y;
         addChild(this._giftLight);
      }
      
      private function initialEvent() : void
      {
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyBtnClick);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__onGiftBtnClick);
      }
      
      private function __onBuyBtnClick(event:MouseEvent) : void
      {
         this._view = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(RoomManager.Instance.current.mapId == 14)
         {
            BuySingleGoodsView(this._view).goodsID = this._ticketsFootballID[RoomManager.Instance.current.hardLevel];
         }
         else
         {
            BuySingleGoodsView(this._view).goodsID = this._ticketsID[RoomManager.Instance.current.hardLevel];
         }
      }
      
      private function __onGiftBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.mapId == 14)
         {
            ShopGiftsManager.Instance.buy(this._ticketsFootballID[RoomManager.Instance.current.hardLevel],false,2);
         }
         else
         {
            ShopGiftsManager.Instance.buy(this._ticketsID[RoomManager.Instance.current.hardLevel],false,2);
         }
      }
      
      private function removeEvent() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyBtnClick);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__onGiftBtnClick);
      }
      
      private function __onGiftButtonClick(event:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._giftLight);
         this._giftLight = null;
      }
      
      public function setLevel(value:int = -1) : void
      {
         if(value > 0 && value <= this._ticketsID.length)
         {
            this._level = value;
         }
      }
      
      public function giftBtnEnable() : void
      {
         var _goodsID:int = 0;
         if(RoomManager.Instance.current.mapId == 14)
         {
            _goodsID = int(this._ticketsFootballID[RoomManager.Instance.current.hardLevel]);
         }
         else
         {
            _goodsID = int(this._ticketsID[RoomManager.Instance.current.hardLevel]);
         }
         var shopItemInfo:ShopItemInfo = ShopManager.Instance.getGoodsByTemplateID(_goodsID);
         if(Boolean(shopItemInfo) && String(shopItemInfo.GoodsID).slice(-2) == "02")
         {
            this._giftBtn.enable = false;
            this._giftLight.visible = false;
            this._giftBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._giftBtn.enable = true;
            this._giftLight.visible = true;
            this._giftBtn.filters = null;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._buyLight);
         this._buyLight = null;
         ObjectUtils.disposeObject(this._giftLight);
         this._giftLight = null;
         this.removeEvent();
         this._view = null;
         if(Boolean(this._buyBtn.parent))
         {
            this._buyBtn.parent.removeChild(this._buyBtn);
         }
         this._buyBtn = null;
         if(Boolean(this._giftBtn.parent))
         {
            this._giftBtn.parent.removeChild(this._giftBtn);
         }
         this._giftBtn = null;
         if(Boolean(this._bg.parent))
         {
            this._bg.parent.removeChild(this._bg);
         }
         this._bg = null;
      }
   }
}

