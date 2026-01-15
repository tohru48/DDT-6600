package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SetsShopItem extends ShopCartItem
   {
      
      private var _checkBox:SelectedCheckButton;
      
      public function SetsShopItem()
      {
         super();
         PositionUtils.setPos(this._cartItemSelectVBox,"ddtshop.SetsShopView.SelectedCheckBoxPos");
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SetsShopView.SetsShopCheckBox");
         this._checkBox.addEventListener(Event.SELECT,this.__selectedChanged);
         this._checkBox.addEventListener(MouseEvent.CLICK,__soundPlay);
         addChildAt(this._checkBox,getChildIndex(_bg) + 1);
         _closeBtn.visible = false;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._checkBox.removeEventListener(Event.CHANGE,this.__selectedChanged);
         this._checkBox.removeEventListener(MouseEvent.CLICK,__soundPlay);
      }
      
      private function __selectedChanged(event:Event) : void
      {
         dispatchEvent(new Event(Event.SELECT));
      }
      
      override protected function drawBackground(bool:Boolean = false) : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SetsShopItemBg");
         addChild(_bg);
      }
      
      override protected function drawCellField() : void
      {
         super.drawCellField();
         PositionUtils.setPos(_cell,"ddtshop.SetsShopCellPoint");
      }
      
      override protected function drawNameField() : void
      {
         _itemName = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SetsShopItemName");
         addChild(_itemName);
      }
      
      public function get selected() : Boolean
      {
         return this._checkBox.selected;
      }
      
      public function set selected(val:Boolean) : void
      {
         this._checkBox.selected = val;
      }
   }
}

