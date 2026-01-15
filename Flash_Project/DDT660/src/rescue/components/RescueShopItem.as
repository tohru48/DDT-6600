package rescue.components
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import rescue.views.RescueQuickBuyFrame;
   
   public class RescueShopItem extends Sprite implements Disposeable
   {
      
      protected var _itemBg:ScaleFrameImage;
      
      protected var _itemCellBg:Image;
      
      protected var _dotLine:Image;
      
      protected var _payType:ScaleFrameImage;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      private var _itemBmp:Bitmap;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _tipTouch:Component;
      
      private var _index:int;
      
      private var _priceArr:Array;
      
      public function RescueShopItem(index:int)
      {
         this._index = index;
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
         this._dotLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemDotLine");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemName");
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.BuyBtn");
         this._itemBg.setFrame(1);
         this._itemCellBg.setFrame(1);
         this._payType.setFrame(2);
         addChild(this._itemBg);
         addChild(this._itemCellBg);
         addChild(this._dotLine);
         addChild(this._payType);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._buyBtn);
         this._priceArr = ServerConfigManager.instance.rescueShopItemPrice;
         this._itemPriceTxt.text = this._priceArr[this._index];
         switch(this._index)
         {
            case 0:
               this._itemNameTxt.text = LanguageMgr.GetTranslation("rescue.arrow");
               this._itemBmp = ComponentFactory.Instance.creat("rescue.arrow");
               break;
            case 1:
               this._itemNameTxt.text = LanguageMgr.GetTranslation("rescue.bloodBag");
               this._itemBmp = ComponentFactory.Instance.creat("rescue.bloodBag");
               break;
            case 2:
               this._itemNameTxt.text = LanguageMgr.GetTranslation("rescue.kingBless");
               this._itemBmp = ComponentFactory.Instance.creat("rescue.kingBless");
         }
         if(Boolean(this._itemBmp))
         {
            addChild(this._itemBmp);
            this._itemBmp.scaleX = 0.8;
            this._itemBmp.scaleY = 0.8;
            this._itemBmp.smoothing = true;
            this._tipTouch = new Component();
            this._tipTouch.graphics.beginFill(0,0);
            this._tipTouch.graphics.drawRect(0,0,this._itemBmp.width,this._itemBmp.height);
            this._tipTouch.graphics.endFill();
            this._tipTouch.width = this._itemBmp.width;
            this._tipTouch.height = this._itemBmp.height;
            this._tipTouch.x = this._itemBmp.x;
            this._tipTouch.y = this._itemBmp.y;
            this._tipTouch.tipStyle = "ddt.view.tips.OneLineTip";
            this._tipTouch.tipDirctions = "0";
            this._tipTouch.tipData = LanguageMgr.GetTranslation("rescue.itemTip" + this._index);
            addChild(this._tipTouch);
         }
      }
      
      private function initEvents() : void
      {
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyBtnClick);
      }
      
      protected function __buyBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var quickBuyFrame:RescueQuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("rescue.quickBuyFrame");
         quickBuyFrame.setData(this._index,this._priceArr[this._index]);
         LayerManager.Instance.addToLayer(quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvents() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyBtnClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._itemCellBg);
         this._itemCellBg = null;
         ObjectUtils.disposeObject(this._dotLine);
         this._dotLine = null;
         ObjectUtils.disposeObject(this._payType);
         this._payType = null;
         ObjectUtils.disposeObject(this._itemNameTxt);
         this._itemNameTxt = null;
         ObjectUtils.disposeObject(this._itemPriceTxt);
         this._itemPriceTxt = null;
         ObjectUtils.disposeObject(this._itemBmp);
         this._itemBmp = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._tipTouch);
         this._tipTouch = null;
      }
   }
}

