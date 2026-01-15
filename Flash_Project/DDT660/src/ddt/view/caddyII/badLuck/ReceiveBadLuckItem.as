package ddt.view.caddyII.badLuck
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ReceiveBadLuckItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _RsortTxt:FilterFrameText;
      
      private var _RnameTxt:FilterFrameText;
      
      private var _RgoosTxt:FilterFrameText;
      
      private var _topThteeBit:ScaleFrameImage;
      
      private var _cell:BaseCell;
      
      public function ReceiveBadLuckItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RbadLuckItemBG");
         this._RsortTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RsortTxt");
         this._RnameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RNameTxt");
         this._RgoosTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RgoodsTxt");
         this._topThteeBit = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadTopThreeRink");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,28,28);
         shape.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("badLuck.itemCell",[shape]);
         addChild(this._bg);
         addChild(this._RsortTxt);
         addChild(this._RnameTxt);
         addChild(this._RgoosTxt);
         addChild(this._topThteeBit);
         addChild(this._cell);
      }
      
      public function update(sortNumber:int, name:String, info:InventoryItemInfo) : void
      {
         this._bg.setFrame(sortNumber % 2 + 1);
         this._RsortTxt.text = sortNumber + 1 + "th";
         this._topThteeBit.setFrame(sortNumber < 3 ? sortNumber + 1 : 1);
         this._topThteeBit.visible = sortNumber < 3;
         this._RsortTxt.visible = sortNumber >= 3;
         this._RnameTxt.text = name;
         this._RgoosTxt.text = info.Name;
         this._cell.info = info;
      }
      
      override public function get height() : Number
      {
         if(this._bg == null)
         {
            return 0;
         }
         return this._bg.y + this._bg.displayHeight;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._RsortTxt))
         {
            ObjectUtils.disposeObject(this._RsortTxt);
         }
         this._RsortTxt = null;
         if(Boolean(this._RnameTxt))
         {
            ObjectUtils.disposeObject(this._RnameTxt);
         }
         this._RnameTxt = null;
         if(Boolean(this._RgoosTxt))
         {
            ObjectUtils.disposeObject(this._RgoosTxt);
         }
         this._RgoosTxt = null;
         if(Boolean(this._topThteeBit))
         {
            ObjectUtils.disposeObject(this._topThteeBit);
         }
         this._topThteeBit = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

