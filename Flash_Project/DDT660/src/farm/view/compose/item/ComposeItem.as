package farm.view.compose.item
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ComposeItem extends BaseCell
   {
      
      protected var _tbxUseCount:FilterFrameText;
      
      protected var _tbxCount:FilterFrameText;
      
      private var _total:int;
      
      private var _need:int;
      
      public function ComposeItem(bg:DisplayObject)
      {
         super(bg);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("farmHouse.text.composeCount1");
         this._tbxCount.mouseEnabled = false;
         this._tbxUseCount = ComponentFactory.Instance.creatComponentByStylename("farmHouse.text.composeCount2");
         this._tbxUseCount.mouseEnabled = false;
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         PositionUtils.setPos(sp,"farm.componseItem.cellPos");
         sp.width = 50;
         sp.height = 50;
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         addChild(this._tbxUseCount);
         addChild(this._tbxCount);
         if(Boolean(value))
         {
            this._total = PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE).getItemCountByTemplateId(value.TemplateID);
            this._tbxCount.text = this._total.toString();
         }
         else
         {
            this._tbxCount.text = "";
            this._tbxUseCount.text = "";
         }
      }
      
      public function set useCount(count:int) : void
      {
         this._need = count;
         this._tbxUseCount.text = count > 0 ? "/" + count.toString() : "";
         this.fixPos();
      }
      
      private function fixPos() : void
      {
         if(Boolean(this._tbxCount) && Boolean(this._tbxUseCount))
         {
            this._tbxUseCount.x = this.width - this._tbxUseCount.width - 6;
            this._tbxCount.x = this._tbxUseCount.x - this._tbxCount.textWidth - 1;
         }
      }
      
      public function get maxCount() : int
      {
         return int(this._total / this._need);
      }
      
      override public function dispose() : void
      {
         this._need = 0;
         this._total = 0;
         if(Boolean(this._tbxUseCount))
         {
            ObjectUtils.disposeObject(this._tbxUseCount);
            this._tbxUseCount = null;
         }
         if(Boolean(this._tbxCount))
         {
            ObjectUtils.disposeObject(this._tbxCount);
            this._tbxCount = null;
         }
         super.dispose();
      }
   }
}

