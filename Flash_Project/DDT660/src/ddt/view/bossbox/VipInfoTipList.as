package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class VipInfoTipList extends Sprite implements Disposeable
   {
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var _cells:Vector.<BoxVipTipsInfoCell>;
      
      private var _currentCell:BoxVipTipsInfoCell;
      
      public function VipInfoTipList()
      {
         super();
         this.initList();
      }
      
      public function get currentCell() : BoxVipTipsInfoCell
      {
         return this._currentCell;
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
      }
      
      public function showForVipAward(infoList:Array) : void
      {
         var i:int = 0;
         var cell:BoxVipTipsInfoCell = null;
         if(!infoList || infoList.length < 1)
         {
            return;
         }
         this._goodsList = infoList;
         this._cells = new Vector.<BoxVipTipsInfoCell>();
         this._list.dispose();
         this._list = new SimpleTileList(this._goodsList.length);
         this._list.vSpace = 12;
         this._list.hSpace = 120;
         this._list.beginChanges();
         for(i = 0; i < this._goodsList.length; i++)
         {
            cell = ComponentFactory.Instance.creatCustomObject("bossbox.BoxVipTipsInfoCell");
            if(Boolean(this._goodsList[i]))
            {
               cell.info = this._goodsList[i] as ItemTemplateInfo;
               cell.itemName = (this._goodsList[i] as ItemTemplateInfo).Name;
               cell.isSelect = this.isCanSelect(i);
               if(this.isCanSelect(i))
               {
                  this._currentCell = cell;
               }
               this._list.addChild(cell);
               this._cells.push(cell);
            }
         }
         this._list.commitChanges();
         addChild(this._list);
      }
      
      private function isCanSelect(index:int) : Boolean
      {
         var resultBool:Boolean = false;
         var level:int = PlayerManager.Instance.Self.VIPLevel;
         switch(index)
         {
            case 0:
               resultBool = level < 12;
               break;
            case 1:
               resultBool = level == 12;
         }
         return resultBool;
      }
      
      private function __cellClick(e:CellEvent) : void
      {
         this._currentCell = e.data as BoxVipTipsInfoCell;
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      public function dispose() : void
      {
         var cell:BoxVipTipsInfoCell = null;
         for each(cell in this._cells)
         {
            cell.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

