package giftSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.display.Sprite;
   import giftSystem.element.GiftGoodItem;
   
   public class GiftGoodsListView extends Sprite implements Disposeable
   {
      
      private var _containerAll:VBox;
      
      private var _container:Vector.<HBox>;
      
      public function GiftGoodsListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._container = new Vector.<HBox>();
         this._containerAll = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.containerAll");
         addChild(this._containerAll);
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         var item:GiftGoodItem = null;
         this.clear();
         this._container = new Vector.<HBox>();
         var k:int = 0;
         var sum:int = list.length < 6 ? int(list.length) : 6;
         for(var i:int = 0; i < 6; i++)
         {
            if(i % 2 == 0)
            {
               k = i / 2;
               this._container[k] = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.container");
               this._containerAll.addChild(this._container[k]);
            }
            item = new GiftGoodItem();
            if(i < sum)
            {
               item.info = list[i];
            }
            this._container[k].addChild(item);
         }
      }
      
      private function clear() : void
      {
         var i:int = 0;
         ObjectUtils.disposeAllChildren(this._containerAll);
         if(this._container.length > 0)
         {
            for(i = 0; i < 3; i++)
            {
               this._container[i] = null;
            }
         }
         this._container = null;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         if(Boolean(this._containerAll))
         {
            ObjectUtils.disposeObject(this._containerAll);
         }
         this._containerAll = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

