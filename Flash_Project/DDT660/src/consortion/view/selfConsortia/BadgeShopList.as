package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import consortion.data.BadgeInfo;
   import flash.display.Sprite;
   
   public class BadgeShopList extends Sprite implements Disposeable
   {
      
      private var _items:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function BadgeShopList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._items = new Array();
         this._list = ComponentFactory.Instance.creat("consortion.badgeShop.list");
         this._panel = ComponentFactory.Instance.creat("consortion.badgeShop.panel");
         this._panel.setView(this._list);
         addChild(this._panel);
      }
      
      public function setList(arr:Array) : void
      {
         var item:BadgeShopItem = null;
         var info:BadgeInfo = null;
         var item1:BadgeShopItem = null;
         for each(item in this._items)
         {
            item.dispose();
         }
         this._items = [];
         for each(info in arr)
         {
            item1 = new BadgeShopItem(info);
            this._list.addChild(item1);
            this._items.push(item1);
         }
      }
      
      public function dispose() : void
      {
         var item:BadgeShopItem = null;
         for each(item in this._items)
         {
            item.dispose();
         }
         this._items = null;
         this._list.dispose();
         this._list = null;
         this._panel.dispose();
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

