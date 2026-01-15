package beadSystem.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.cell.IDropListCell;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.BaseLayer;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class DrillItem extends Component implements IDropListCell
   {
      
      private var _itemInfo:DrillItemInfo;
      
      private var _date:InventoryItemInfo;
      
      private var _stateID:int;
      
      private var _icon:DisplayObject;
      
      private var _overBg:Image;
      
      private var _stateName:FilterFrameText;
      
      private var _selected:Boolean;
      
      private var _isInfoChanged:Boolean = false;
      
      public function DrillItem()
      {
         super();
         buttonMode = true;
         this.initView();
      }
      
      private function initView() : void
      {
         graphics.beginFill(16777215,0);
         graphics.drawRect(0,0,80,22);
         graphics.endFill();
         this._overBg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.drillItemHighLight");
         addChild(this._overBg);
         this._overBg.visible = false;
         this._stateName = ComponentFactory.Instance.creatComponentByStylename("beadSystem.drillItemText");
         addChild(this._stateName);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         tipDirctions = "7,6,2,1,5,4,0,3,6";
         tipGapV = 10;
         tipGapH = 10;
         tipStyle = "core.GoodsTip";
         ShowTipManager.Instance.addTip(this);
      }
      
      public function getCellValue() : *
      {
         return this._itemInfo;
      }
      
      public function setCellValue(value:*) : void
      {
         this._isInfoChanged = this._date != value;
         this._itemInfo = value;
         this._date = Boolean(this._itemInfo) ? this._itemInfo.itemInfo : null;
         var tipInfo:GoodTipInfo = new GoodTipInfo();
         tipInfo.itemInfo = Boolean(this._date) ? ItemManager.Instance.getTemplateById(this._date.TemplateID) : null;
         tipData = tipInfo;
         this.update();
      }
      
      private function update() : void
      {
         if(Boolean(this._date))
         {
            if(this._icon == null || this._isInfoChanged)
            {
               this._isInfoChanged = false;
               ObjectUtils.disposeObject(this._icon);
               this._icon = null;
               this._icon = this.creatIcon();
               addChildAt(this._icon,0);
               PositionUtils.setPos(this._icon,"beadSystem.DrillItemIconPos");
            }
            this._stateName.text = this._itemInfo.amount.toString();
         }
      }
      
      private function __out(event:MouseEvent) : void
      {
         this._overBg.visible = false;
      }
      
      private function __over(event:MouseEvent) : void
      {
         this._overBg.visible = true;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
      }
      
      private function creatIcon() : DisplayObject
      {
         var url:String = PathManager.solveGoodsPath(this._date.CategoryID,this._date.Pic,this._date.NeedSex == 1,BaseLayer.ICON,"A","1",this._date.Level,false,this._date.type);
         return new BitmapLoaderProxy(url,new Rectangle(0,0,24,24));
      }
      
      override public function get height() : Number
      {
         return 25;
      }
      
      override public function get width() : Number
      {
         return 80;
      }
      
      override public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = null;
         ObjectUtils.disposeObject(this._stateName);
         this._stateName = null;
         this._date = null;
         this._itemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

