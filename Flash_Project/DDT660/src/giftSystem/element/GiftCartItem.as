package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import shop.view.ShopItemCell;
   
   public class GiftCartItem extends Sprite implements Disposeable
   {
      
      private var _itemCell:ShopItemCell;
      
      private var _name:FilterFrameText;
      
      private var _info:ShopItemInfo;
      
      private var _chooseNum:ChooseNum;
      
      private var _bg:ScaleBitmapImage;
      
      private var _itemCellBg:ScaleBitmapImage;
      
      private var _lineBg:ScaleBitmapImage;
      
      private var _InputBg:Scale9CornerImage;
      
      public function GiftCartItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSytem.CartItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSytem.CartItemCellBg");
         this._name = ComponentFactory.Instance.creatComponentByStylename("GiftCartItem.name");
         this._chooseNum = ComponentFactory.Instance.creatCustomObject("chooseNum");
         this._lineBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
         PositionUtils.setPos(this._lineBg,"giftSystem.linePos");
         this._InputBg = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.TotalMoneyPanel.InputBg");
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,48,48);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 60;
         PositionUtils.setPos(this._itemCell,"GiftCartItem.cellPos");
         addChild(this._bg);
         addChild(this._itemCellBg);
         addChild(this._itemCell);
         addChild(this._InputBg);
         addChild(this._name);
         addChild(this._chooseNum);
      }
      
      public function get number() : int
      {
         return this._chooseNum.number;
      }
      
      public function set info(value:ShopItemInfo) : void
      {
         if(this._info == value)
         {
            return;
         }
         this._info = value;
         this.upView();
      }
      
      private function upView() : void
      {
         this._itemCell.info = this._info.TemplateInfo;
         this._name.text = this._info.TemplateInfo.Name;
      }
      
      private function initEvent() : void
      {
         this._chooseNum.addEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
      }
      
      private function __numberChange(event:Event) : void
      {
         dispatchEvent(new Event(ChooseNum.NUMBER_IS_CHANGE));
      }
      
      private function removeEvent() : void
      {
         this._chooseNum.removeEventListener(ChooseNum.NUMBER_IS_CHANGE,this.__numberChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._itemCellBg))
         {
            ObjectUtils.disposeObject(this._itemCellBg);
         }
         this._itemCellBg = null;
         if(Boolean(this._itemCell))
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(Boolean(this._InputBg))
         {
            ObjectUtils.disposeObject(this._InputBg);
         }
         this._InputBg = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._chooseNum))
         {
            ObjectUtils.disposeObject(this._chooseNum);
         }
         this._chooseNum = null;
         if(Boolean(this._lineBg))
         {
            ObjectUtils.disposeObject(this._lineBg);
         }
         this._lineBg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

