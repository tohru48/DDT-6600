package wantstrong.view
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import wantstrong.WantStrongManager;
   import wantstrong.data.WantStrongModel;
   
   public class WantStrongMenu extends Sprite implements Disposeable
   {
      
      private var _menuArr:Array = [1,2,3,4,5];
      
      private var _titleArr:Array = [LanguageMgr.GetTranslation("ddt.wantStrong.view.titleText"),LanguageMgr.GetTranslation("ddt.wantStrong.view.levelUp"),LanguageMgr.GetTranslation("ddt.wantStrong.view.earnMoney"),LanguageMgr.GetTranslation("ddt.wantStrong.view.artifact"),LanguageMgr.GetTranslation("ddt.wantStrong.view.findBack")];
      
      private var _selectItem:WantStrongCell;
      
      private var _cellArr:Array = [];
      
      private var _model:WantStrongModel;
      
      public function WantStrongMenu(model:WantStrongModel)
      {
         super();
         WantStrongManager.Instance.addEventListener("cellChange",this.cellChangeHandler);
         this._model = model;
         this.createUI();
      }
      
      private function cellChangeHandler(event:Event) : void
      {
         if(this._model.data[5].length == 0)
         {
            removeChildAt(4);
            WantStrongManager.Instance.findBackExist = false;
            this.setSelectItem(this._cellArr[this._model.activeId - 1]);
         }
      }
      
      private function createUI() : void
      {
         var cell:WantStrongCell = null;
         var numTemp:int = 0;
         for(var i:int = 0; i < this._menuArr.length; i++)
         {
            if(Boolean(this._model.data[this._menuArr[i]]))
            {
               cell = new WantStrongCell(this._model.data[this._menuArr[i]],this._titleArr[i]);
               cell.y = numTemp * 54;
               cell.addEventListener(MouseEvent.CLICK,this._cellClickedHandle);
               addChild(cell);
               this._cellArr.push(cell);
               numTemp++;
            }
         }
         if(this._cellArr.length > 0)
         {
            this.setSelectItem(this._cellArr[this._model.activeId - 1]);
            WantStrongManager.Instance.setinitState(this._model.data[this._model.activeId]);
         }
      }
      
      protected function _cellClickedHandle(event:MouseEvent) : void
      {
         var item:WantStrongCell = event.currentTarget as WantStrongCell;
         this.setSelectItem(item);
         WantStrongManager.Instance.setCurrentInfo(item.info);
         SoundManager.instance.play("008");
      }
      
      private function setSelectItem(item:WantStrongCell) : void
      {
         if(item != this._selectItem)
         {
            if(Boolean(this._selectItem))
            {
               this._selectItem.selected = false;
            }
            this._selectItem = item;
            this._selectItem.selected = true;
         }
      }
      
      public function dispose() : void
      {
         var cell:WantStrongCell = null;
         WantStrongManager.Instance.removeEventListener("cellChange",this.cellChangeHandler);
         this._menuArr = null;
         this._titleArr = null;
         if(Boolean(this._selectItem))
         {
            this._selectItem.dispose();
            this._selectItem = null;
         }
         for(var i:int = 0; i < this._cellArr.length; i++)
         {
            cell = this._cellArr[i];
            if(Boolean(cell))
            {
               cell.removeEventListener(MouseEvent.CLICK,this._cellClickedHandle);
               cell.dispose();
               cell = null;
            }
         }
         this._cellArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

