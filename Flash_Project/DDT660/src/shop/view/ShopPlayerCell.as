package shop.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import shop.ShopEvent;
   
   public class ShopPlayerCell extends BaseCell
   {
      
      private var _shopItemInfo:ShopCarItemInfo;
      
      private var _light:MovieImage;
      
      public function ShopPlayerCell(bg:DisplayObject)
      {
         super(bg);
      }
      
      public function set shopItemInfo(value:ShopCarItemInfo) : void
      {
         if(value == null)
         {
            super.info = null;
         }
         else
         {
            super.info = value.TemplateInfo;
         }
         this._shopItemInfo = value;
         locked = false;
         if(value is ShopCarItemInfo)
         {
            setColor(ShopCarItemInfo(value).Color);
         }
         dispatchEvent(new ShopEvent(ShopEvent.ITEMINFO_CHANGE,null,null));
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function setSkinColor(color:String) : void
      {
         var t:Array = null;
         var cs:String = null;
         if(Boolean(this.shopItemInfo) && EquipType.hasSkin(this.shopItemInfo.CategoryID))
         {
            t = this.shopItemInfo.Color.split("|");
            cs = "";
            if(t.length > 2)
            {
               cs = t[0] + "|" + color + "|" + t[2];
            }
            else
            {
               cs = t[0] + "|" + color + "|" + t[1];
            }
            this.shopItemInfo.Color = cs;
            setColor(cs);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this._light == null)
         {
            this._light = ComponentFactory.Instance.creatComponentByStylename("ddtshop.shopPlayerCell.RightItemLightMc");
         }
         addChild(this._light);
         this._light.visible = this._light.mouseChildren = this._light.mouseEnabled = false;
      }
      
      public function showLight() : void
      {
         this._light.visible = true;
      }
      
      public function hideLight() : void
      {
         this._light.visible = false;
      }
      
      override public function dispose() : void
      {
         if(locked)
         {
            if(_info != null && _info is InventoryItemInfo)
            {
               PlayerManager.Instance.Self.Bag.unlockItem(_info as InventoryItemInfo);
            }
            locked = false;
         }
         this._shopItemInfo = null;
         if(Boolean(this._light))
         {
            ObjectUtils.disposeObject(this._light);
         }
         this._light = null;
         super.dispose();
      }
   }
}

