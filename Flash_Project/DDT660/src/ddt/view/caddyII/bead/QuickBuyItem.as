package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class QuickBuyItem extends Sprite implements Disposeable
   {
      
      private static const HammerJumpStep:int = 5;
      
      private static const PotJumpStep:int = 1;
      
      private static const HammerTemplateID:int = 11456;
      
      private static const PotTemplateID:int = 112047;
      
      private var _bg:ScaleFrameImage;
      
      private var _cell:BaseCell;
      
      private var _selectNumber:NumberSelecter;
      
      private var _count:int;
      
      private var _countField:FilterFrameText;
      
      private var _countPos:Point;
      
      private var _selsected:Boolean = false;
      
      private var _selectedBitmap:Scale9CornerImage;
      
      public function QuickBuyItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._countPos = ComponentFactory.Instance.creatCustomObject("caddyII.bead.QuickBuyItem.CountPos");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.QuickBuy.ItemCellBg");
         var size:Point = ComponentFactory.Instance.creatCustomObject("bead.quickCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("bead.quickCell",[shape]);
         this._selectNumber = ComponentFactory.Instance.creatCustomObject("bead.numberSelecter",[0]);
         this._selectNumber.number = 0;
         this._countField = ComponentFactory.Instance.creatComponentByStylename("caddy.QuickBuy.ItemCountField");
         this._selectedBitmap = ComponentFactory.Instance.creatComponentByStylename("caddy.QuickBuy.ItemCellShin");
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._selectNumber);
         addChild(this._countField);
         addChild(this._selectedBitmap);
      }
      
      private function initEvents() : void
      {
         this._selectNumber.addEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function removeEvents() : void
      {
         this._selectNumber.removeEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function _numberChange(e:Event) : void
      {
         if(this._cell.info.TemplateID == HammerTemplateID)
         {
            this._countField.text = String(HammerJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         else if(this._cell.info.TemplateID == PotTemplateID)
         {
            this._countField.text = String(PotJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function _numberClose(e:Event) : void
      {
         dispatchEvent(new Event(NumberSelecter.NUMBER_CLOSE));
      }
      
      public function setFocus() : void
      {
         this._selectNumber.setFocus();
      }
      
      public function set itemID(id:int) : void
      {
         this._cell.info = ItemManager.Instance.getTemplateById(id);
         if(this._cell.info.TemplateID == HammerTemplateID)
         {
            this._countField.text = String(HammerJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         else if(this._cell.info.TemplateID == PotTemplateID)
         {
            this._countField.text = String(PotJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function set count(value:int) : void
      {
         this._selectNumber.number = value;
      }
      
      public function get count() : int
      {
         return this._selectNumber.number;
      }
      
      public function get selected() : Boolean
      {
         return this._selsected;
      }
      
      public function set selected(val:Boolean) : void
      {
         if(this._selsected != val)
         {
            this._selsected = val;
            this._selectedBitmap.visible = this._selsected;
         }
      }
      
      public function get selectNumber() : NumberSelecter
      {
         return this._selectNumber;
      }
      
      public function set selectNumber(value:NumberSelecter) : void
      {
         this._selectNumber = value;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._selectNumber))
         {
            ObjectUtils.disposeObject(this._selectNumber);
         }
         this._selectNumber = null;
         if(Boolean(this._selectedBitmap))
         {
            ObjectUtils.disposeObject(this._selectedBitmap);
         }
         this._selectedBitmap = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

