package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import farm.view.compose.event.SelectComposeItemEvent;
   import shop.view.ShopItemCell;
   
   public class FertilizerSelect extends ChatBasePanel implements Disposeable
   {
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<HelperFerItem>;
      
      private var _result:ShopItemCell;
      
      public function FertilizerSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<HelperFerItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("farm.SeedListBg");
         this._list = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedList");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("farm.helper.Seedselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var item:HelperFerItem = null;
         var infoList:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         for(var i:int = 0; i < infoList.length; i++)
         {
            item = new HelperFerItem();
            item.info = infoList[i];
            item.addEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__itemClick);
            this._itemList.push(item);
            this._list.addChild(item);
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(event:SelectComposeItemEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.SELECT_FERTILIZER,event.data));
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         while(i < this._itemList.length)
         {
            this._itemList[i].removeEventListener(SelectComposeItemEvent.SELECT_SEED,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[i]);
            this._itemList[i] = null;
            i++;
         }
         this._itemList = null;
      }
   }
}

