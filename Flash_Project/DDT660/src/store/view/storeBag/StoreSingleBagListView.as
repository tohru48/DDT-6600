package store.view.storeBag
{
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.StoreIIEvent;
   import store.view.ConsortiaRateManager;
   
   public class StoreSingleBagListView extends StoreBagListView
   {
      
      private var _categoryID:Number = -1;
      
      private var _showLight:Boolean = false;
      
      private var _otherCells:DictionaryData;
      
      public function StoreSingleBagListView()
      {
         super();
      }
      
      public function set OtherCells(value:DictionaryData) : void
      {
         this._otherCells = value;
      }
      
      override protected function createPanel() : void
      {
         ConsortiaRateManager.instance.addEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
         super.createPanel();
      }
      
      private function __showLight(evt:StoreIIEvent) : void
      {
         if(Boolean(evt.data))
         {
            this._categoryID = evt.data.CategoryID;
            this._showLight = evt.bool;
         }
         else
         {
            this._categoryID = -1;
            this._showLight = evt.bool;
         }
         this.showLight(this._categoryID,this._showLight);
      }
      
      private function showLight(categoryType:Number, isShow:Boolean) : void
      {
         var cell:StoreBagCell = null;
         var i:StoreBagCell = null;
         var j:StoreBagCell = null;
         for each(cell in cells)
         {
            cell.light = false;
         }
         if(categoryType != -1)
         {
            for each(i in cells)
            {
               if(Boolean(i.info) && i.info.CategoryID == categoryType)
               {
                  i.light = isShow;
               }
            }
         }
         else
         {
            for each(j in cells)
            {
               j.light = isShow;
            }
         }
      }
      
      override public function dispose() : void
      {
         ConsortiaRateManager.instance.removeEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
         super.dispose();
      }
      
      override protected function __addGoods(evt:DictionaryEvent) : void
      {
         super.__addGoods(evt);
         this.showLight(this._categoryID,this._showLight);
      }
      
      override protected function __removeGoods(evt:StoreBagEvent) : void
      {
         super.__removeGoods(evt);
         this.showLight(this._categoryID,this._showLight);
      }
   }
}

