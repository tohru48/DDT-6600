package gypsyShop.ui
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyItemData;
   import shop.view.ShopItemCell;
   
   public class GypsyItemCell extends Sprite implements Disposeable
   {
      
      private var _id:int;
      
      private var _bg:Bitmap;
      
      private var _bagCell:ShopItemCell;
      
      private var _nameTxt:FilterFrameText;
      
      private var _priceTxt:FilterFrameText;
      
      private var _priceUnitIcon:ScaleFrameImage;
      
      private var _buyBtn:SimpleBitmapButton;
      
      public function GypsyItemCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("gypsy.frame.cell.bg");
         addChild(this._bg);
         var cellBG:Shape = new Shape();
         cellBG.graphics.beginFill(16777215,0);
         cellBG.graphics.drawRect(0,0,60,60);
         cellBG.graphics.endFill();
         this._bagCell = new ShopItemCell(cellBG);
         PositionUtils.setPos(this._bagCell,{
            "x":4,
            "y":4
         });
         addChild(this._bagCell);
         this._nameTxt = ComponentFactory.Instance.creat("gypsy.textfield.itemname");
         this._nameTxt.text = "";
         addChild(this._nameTxt);
         this._priceTxt = ComponentFactory.Instance.creat("gypsy.textfield.price");
         this._priceTxt.text = "";
         addChild(this._priceTxt);
         this._priceUnitIcon = ComponentFactory.Instance.creat("gypsy.closeBtn.unit.icon");
         this._priceUnitIcon.setFrame(2);
         addChild(this._priceUnitIcon);
         this._buyBtn = ComponentFactory.Instance.creat("gypsy.BuyBtn");
         this._buyBtn.enable = true;
         addChild(this._buyBtn);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      protected function onClick(me:MouseEvent) : void
      {
         GypsyShopManager.getInstance().itemBuyBtnClicked(this.id);
      }
      
      public function clear() : void
      {
         this._id = -1;
         this._bagCell.info = null;
         this._nameTxt.text = "";
         this._priceTxt.text = "";
         this._buyBtn.enable = false;
      }
      
      public function updateCell(data:GypsyItemData) : void
      {
         var __name:String = null;
         this._id = data.id;
         this._bagCell.info = ItemManager.Instance.getTemplateById(data.infoID);
         if(this._bagCell.info != null)
         {
            __name = this._bagCell.info.Name;
            if(__name.length > 15)
            {
               __name = __name.substr(0,13) + "...";
            }
            this._nameTxt.text = __name;
         }
         this._priceUnitIcon.setFrame(data.unit);
         this._priceTxt.text = data.price.toString();
         this._buyBtn.enable = data.canBuy == 0 ? false : true;
      }
      
      public function updateBuyButtonState(state:int) : void
      {
         switch(state)
         {
            case 0:
               this._buyBtn.enable = false;
               break;
            default:
               this._buyBtn.enable = true;
         }
      }
      
      public function dispose() : void
      {
         this._id = -1;
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         ObjectUtils.disposeAllChildren(this);
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}

