package wonderfulActivity.newActivity.mountsActivity
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class MountAwardsItem extends Sprite implements Disposeable
   {
      
      private var _describeText:FilterFrameText;
      
      private var _bagCellContainer:Sprite;
      
      private var _cellItems:Vector.<BagCell>;
      
      private var _btnGetAwards:SimpleBitmapButton;
      
      private var _index:int;
      
      public function MountAwardsItem(index:int)
      {
         super();
         this._index = index;
      }
      
      public function init() : void
      {
         var i:int = 0;
         this._describeText = ComponentFactory.Instance.creat("");
         this._describeText.text = "";
         addChild(this._describeText);
         this._bagCellContainer = new Sprite();
         this._cellItems = new Vector.<BagCell>();
         for(i = 0; i < 3; i++)
         {
            this._cellItems[i] = new BagCell(0);
            this._cellItems[i].info = null;
            this._cellItems[i].x = i * 60;
            this._bagCellContainer.addChild(this._cellItems[i]);
         }
      }
      
      public function setData(describe:String, listID:Array, btnState:int) : void
      {
         this._describeText.text = describe;
         var len:int = int(listID.length);
         for(var i:int = 0; i < len; i++)
         {
            this._cellItems[i].info = ItemManager.Instance.getTemplateById(listID[i]);
         }
         while(i < 3)
         {
            this._cellItems[i].info = null;
            i++;
         }
      }
      
      public function dispose() : void
      {
         var dis:Function = null;
         dis = function(item:*, index:int, arr:Vector.<BagCell>):void
         {
            arr[index].dispose();
         };
         this._describeText = null;
         while(this._bagCellContainer.numChildren > 0)
         {
            this._bagCellContainer.removeChildAt(0);
         }
         this._cellItems.forEach(dis);
         this._cellItems = null;
         this._btnGetAwards.dispose();
      }
   }
}

