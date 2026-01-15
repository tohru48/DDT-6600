package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import giftSystem.data.MyGiftCellInfo;
   import shop.view.ShopItemCell;
   
   public class MyGiftItem extends Sprite implements Disposeable
   {
      
      private var _info:MyGiftCellInfo;
      
      private var _BG:MovieImage;
      
      private var _nameBG:Bitmap;
      
      private var _giftBG:Bitmap;
      
      private var _name:FilterFrameText;
      
      private var _ownCount:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _itemCell:ShopItemCell;
      
      public function MyGiftItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("ddtmyGiftItem.BG");
         this._giftBG = ComponentFactory.Instance.creatBitmap("asset.ddtgiftGoodItem.BG");
         this._giftBG.width = 55;
         this._giftBG.height = 55;
         this._giftBG.x = 25;
         this._giftBG.y = 6;
         this._nameBG = ComponentFactory.Instance.creatBitmap("asset.myGiftname.Bg");
         this._name = ComponentFactory.Instance.creat("MyGiftItem.name");
         this._ownCount = ComponentFactory.Instance.creat("MyGiftItem.ownCount");
         this._count = ComponentFactory.Instance.creat("MyGiftItem.count");
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,59,59);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 50;
         PositionUtils.setPos(this._itemCell,"MyGiftItem.cellPos");
         addChild(this._BG);
         addChild(this._giftBG);
         addChild(this._nameBG);
         addChild(this._name);
         addChild(this._ownCount);
         addChild(this._count);
         addChild(this._itemCell);
      }
      
      public function get info() : MyGiftCellInfo
      {
         return this._info;
      }
      
      public function set info(value:MyGiftCellInfo) : void
      {
         this._info = value;
         this.upView();
      }
      
      private function upView() : void
      {
         if(this._info == null)
         {
            return;
         }
         var shopItemInfo:ShopItemInfo = this._info.info;
         if(shopItemInfo == null)
         {
            return;
         }
         this._itemCell.info = shopItemInfo.TemplateInfo;
         this._name.text = this._itemCell.info.Name.substring(0,5) + "..";
         this.upCountAndownCount();
      }
      
      public function set ownCount(value:int) : void
      {
         this._info.amount = value;
         this.upCountAndownCount();
      }
      
      private function upCountAndownCount() : void
      {
         this._count.text = String(this._info.amount);
         this._ownCount.text = LanguageMgr.GetTranslation("ddt.giftSystem.MyGiftItem.ownI") + "    " + LanguageMgr.GetTranslation("ddt.giftSystem.MyGiftItem.ownII");
      }
      
      private function getSpace(s:String) : String
      {
         if(!s)
         {
            return "";
         }
         var temp:String = "";
         for(var i:int = 0; i < s.length; i++)
         {
            temp += " ";
         }
         return temp;
      }
      
      override public function get height() : Number
      {
         return this._BG.height;
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
         this._info = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._giftBG))
         {
            ObjectUtils.disposeObject(this._giftBG);
         }
         this._giftBG = null;
         if(Boolean(this._nameBG))
         {
            ObjectUtils.disposeObject(this._nameBG);
         }
         this._nameBG = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._ownCount))
         {
            ObjectUtils.disposeObject(this._ownCount);
         }
         this._ownCount = null;
         if(Boolean(this._count))
         {
            ObjectUtils.disposeObject(this._count);
         }
         this._count = null;
         if(Boolean(this._itemCell))
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

