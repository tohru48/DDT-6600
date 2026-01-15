package setting.view
{
   import bagAndInfo.bag.ItemCellView;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.PropInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class KeySetItem extends ItemCellView implements IAcceptDrag, ITipedDisplay
   {
      
      private var _propIndex:int;
      
      private var _propID:int;
      
      private var _isGlow:Boolean = false;
      
      private var glow_mc:Bitmap;
      
      private var lightingFilter:ColorMatrixFilter;
      
      private const CONST1:int = 40;
      
      private const CONST2:int = 35;
      
      public function KeySetItem(index:uint = 0, propIndex:int = 0, propID:int = 0, item:DisplayObject = null, isCount:Boolean = false)
      {
         super(index,item,isCount);
         this._propIndex = propIndex;
         this._propID = propID;
         this.glow_mc = ComponentFactory.Instance.creatBitmap("ddtsetting.keyset.glowAsset");
         addChild(this.glow_mc);
         this.glow_mc.visible = false;
         addEventListener(MouseEvent.ROLL_OVER,this.__over);
         addEventListener(MouseEvent.ROLL_OUT,this.__out);
         ShowTipManager.Instance.addTip(this);
      }
      
      override protected function initItemBg() : void
      {
         _asset = ComponentFactory.Instance.creatBitmap("ddtsetting.keyset.quickKeyItemBg");
         _asset.width = _asset.height = this.CONST1;
      }
      
      override protected function setItemWidthAndHeight() : void
      {
         _item.width = _item.height = this.CONST2;
         _item.x = 2;
         _item.y = 3;
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         DragManager.acceptDrag(this,DragEffect.NONE);
      }
      
      private function __over(e:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function __out(e:MouseEvent) : void
      {
         filters = null;
      }
      
      public function set glow(b:Boolean) : void
      {
         this._isGlow = b;
         this.glow_mc.visible = this._isGlow;
      }
      
      public function get glow() : Boolean
      {
         return this._isGlow;
      }
      
      public function set propID(value:int) : void
      {
         this._propID = value;
      }
      
      public function get tipData() : Object
      {
         var info:PropInfo = new PropInfo(ItemManager.Instance.getTemplateById(this._propID));
         var tipInfo:ToolPropInfo = new ToolPropInfo();
         tipInfo.showThew = true;
         tipInfo.info = info.Template;
         if(Boolean(this._propIndex))
         {
            tipInfo.shortcutKey = this._propIndex.toString();
         }
         return tipInfo;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set tipData(value:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return -15;
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 5;
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "core.ToolPropTips";
      }
      
      public function set tipStyle(value:String) : void
      {
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.ROLL_OVER,this.__over);
         removeEventListener(MouseEvent.ROLL_OUT,this.__out);
         if(Boolean(this.glow_mc) && Boolean(this.glow_mc.parent))
         {
            this.glow_mc.parent.removeChild(this.glow_mc);
         }
         this.glow_mc = null;
         this.lightingFilter = null;
         filters = null;
         super.dispose();
      }
   }
}

