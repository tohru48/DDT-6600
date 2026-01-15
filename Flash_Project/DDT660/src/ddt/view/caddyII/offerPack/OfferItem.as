package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class OfferItem extends Sprite implements IListCell
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _cell:BaseCell;
      
      private var _nameTxt:FilterFrameText;
      
      private var _showBG:Boolean = true;
      
      public function OfferItem()
      {
         super();
         this.initView();
         this.initEvents();
         mouseChildren = false;
      }
      
      private function initView() : void
      {
         var point:Point = ComponentFactory.Instance.creatCustomObject("offer.itemCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,point.x,point.y);
         shape.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("offer.itemCell",[shape,null,false]);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("offer.itemNameTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("offer.comboxItembgB");
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._nameTxt);
         buttonMode = true;
         this._bg.visible = false;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         if(Boolean(this._bg))
         {
            this._bg.width = value;
         }
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         if(Boolean(this._bg))
         {
            this._bg.height = value;
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this._over);
         addEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._over);
         removeEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function _over(e:MouseEvent) : void
      {
         if(this._showBG)
         {
            this._bg.visible = true;
         }
      }
      
      private function _out(e:MouseEvent) : void
      {
         if(this._showBG)
         {
            this._bg.visible = false;
         }
      }
      
      public function set showBG(value:Boolean) : void
      {
         this._showBG = value;
      }
      
      public function get showBG() : Boolean
      {
         return this._showBG;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         this._cell.info = value;
         this._nameTxt.text = this._cell.info.Name;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._cell.info;
      }
      
      public function setCellValue(value:*) : void
      {
         this.info = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

