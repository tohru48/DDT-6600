package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.display.Sprite;
   
   public class ConsortionShopList extends Sprite implements Disposeable
   {
      
      private var _shopId:int;
      
      private var _items:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function ConsortionShopList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._items = new Array();
         this._list = ComponentFactory.Instance.creat("consortion.shop.list");
         this._panel = ComponentFactory.Instance.creat("consortion.shop.panel");
         this._panel.setView(this._list);
         addChild(this._panel);
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.clearList();
         ObjectUtils.disposeAllChildren(this);
         this._panel = null;
         this._list = null;
         this._items = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function list($list:Vector.<ShopItemInfo>, shopId:int, richNum:int, enable:Boolean = false) : void
      {
         var item:ConsortionShopItem = null;
         var len:int = 0;
         var j:int = 0;
         var item2:ConsortionShopItem = null;
         this.clearList();
         this._shopId = shopId + 10;
         for(var i:int = 0; i < $list.length; i++)
         {
            item = new ConsortionShopItem(enable);
            this._list.addChild(item);
            item.info = $list[i];
            item.neededRich = richNum;
            this._items.push(item);
         }
         if($list.length < 6)
         {
            len = 6 - $list.length;
            for(j = 0; j < len; j++)
            {
               item2 = new ConsortionShopItem(enable);
               this._list.addChild(item2);
               this._items.push(item2);
            }
         }
      }
      
      private function clearList() : void
      {
         var i:int = 0;
         if(Boolean(this._items) && Boolean(this._list))
         {
            for(i = 0; i < this._items.length; i++)
            {
               this._items[i].dispose();
            }
            this._list.disposeAllChildren();
         }
         this._items = new Array();
      }
   }
}

