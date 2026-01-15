package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NewShopBugViewItem extends Sprite implements ISelectable, Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _lightEffect:Bitmap;
      
      private var _cell:ShopItemCell;
      
      private var _count:String;
      
      private var _money:int;
      
      private var _countTxt:FilterFrameText;
      
      private var _countBg:Image;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _type:int;
      
      public function NewShopBugViewItem($type:int = 0, $count:String = "", $money:int = 0, $cell:ShopItemCell = null)
      {
         super();
         buttonMode = true;
         this._type = $type;
         this._count = $count;
         this._money = $money;
         this._cell = $cell;
         this._cell.width = this._cell.height = 61;
         PositionUtils.setPos(this._cell,"ddtshop.NewShopBugViewItem.cell.pos");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BugleViewBg");
         this._lightEffect = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.lightEffect");
         this._lightEffect.visible = false;
         this._lightEffect.x = 14;
         this._lightEffect.y = 7;
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewCountText");
         this._countBg = ComponentFactory.Instance.creatComponentByStylename("asset.medicineQuickBug.countBg");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewMoneyText");
         this._countTxt.mouseEnabled = this._moneyTxt.mouseEnabled = false;
         this._count = this.getSpecifiedString(this._count);
         this._countTxt.text = this._count;
         this._moneyTxt.text = String(this._money) + LanguageMgr.GetTranslation("money");
         this._bg.setFrame(1);
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._countTxt);
         addChild(this._countBg);
         addChild(this._moneyTxt);
         addChild(this._lightEffect);
      }
      
      private function getSpecifiedString(str:String) : String
      {
         if(!str)
         {
            return "";
         }
         var temp:String = "";
         for(var i:int = 0; i < str.length; i++)
         {
            if(str.charCodeAt(i) >= 48 && str.charCodeAt(i) <= 57)
            {
               temp += str.charAt(i);
            }
         }
         return "+" + temp;
      }
      
      public function set autoSelect(value:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._lightEffect.visible;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._lightEffect.visible = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get count() : String
      {
         return this._count;
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function dispose() : void
      {
         this._bg.dispose();
         this._bg = null;
         this._cell.dispose();
         this._cell = null;
         this._countTxt.dispose();
         this._countTxt = null;
         this._moneyTxt.dispose();
         this._moneyTxt = null;
         if(Boolean(this._lightEffect))
         {
            ObjectUtils.disposeObject(this._lightEffect);
         }
         this._lightEffect = null;
         if(Boolean(this._countBg))
         {
            this._countBg.dispose();
         }
         this._countBg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

