package equipretrieve
{
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import equipretrieve.view.RetrieveBagcell;
   
   public class RetrieveController
   {
      
      private static var _instance:RetrieveController;
      
      private var _viewMouseEvtBoolean:Boolean = true;
      
      private var _view:RetrieveFrame;
      
      public function RetrieveController()
      {
         super();
      }
      
      public static function get Instance() : RetrieveController
      {
         if(_instance == null)
         {
            _instance = new RetrieveController();
         }
         return _instance;
      }
      
      public function startView(view:RetrieveFrame) : void
      {
         this._addEvt();
         this._view = view;
      }
      
      public function close() : void
      {
         this._removeEvt();
         RetrieveModel.Instance.replay();
         this._view = null;
      }
      
      public function get view() : RetrieveFrame
      {
         return this._view;
      }
      
      public function get viewMouseEvtBoolean() : Boolean
      {
         return this._viewMouseEvtBoolean;
      }
      
      public function set viewMouseEvtBoolean(boo:Boolean) : void
      {
         if(Boolean(this._view))
         {
            this._viewMouseEvtBoolean = boo;
            this._view.mouseChildren = boo;
            this._view.mouseEnabled = boo;
         }
      }
      
      public function set shine(boo:Boolean) : void
      {
         if(Boolean(this._view))
         {
            this._view.shine = boo;
         }
      }
      
      public function set retrieveType(i:int) : void
      {
         this._view.bagType = i;
      }
      
      private function _addEvt() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this._updateStoreBag);
      }
      
      private function _removeEvt() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this._updateStoreBag);
      }
      
      private function _updateStoreBag(e:BagEvent) : void
      {
         if(Boolean(this._view))
         {
            this._view.updateBag(e.changedSlots);
         }
      }
      
      public function cellDoubleClick(cell:RetrieveBagcell) : void
      {
         this._view.cellDoubleClick(cell);
      }
   }
}

