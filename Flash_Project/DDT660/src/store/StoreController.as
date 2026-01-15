package store
{
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import store.data.StoreModel;
   import store.states.BaseStoreView;
   
   public class StoreController
   {
      
      private var _type:String;
      
      private var _model:StoreModel;
      
      private var _viewArr:Array;
      
      public function StoreController()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._model = new StoreModel(PlayerManager.Instance.Self);
      }
      
      private function initEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function startupEvent() : void
      {
      }
      
      public function shutdownEvent() : void
      {
      }
      
      public function getSkipView() : Sprite
      {
         if(this._viewArr.length > 0)
         {
            return this._viewArr[0];
         }
         return null;
      }
      
      public function getView(type:String) : Sprite
      {
         this._viewArr = new Array();
         var view:BaseStoreView = new BaseStoreView(this,type);
         PositionUtils.setPos(view,"ddtstore.BagStoreViewPos");
         this._viewArr.push(view);
         return view;
      }
      
      public function get Type() : String
      {
         return this._type;
      }
      
      public function get Model() : StoreModel
      {
         return this._model;
      }
      
      public function dispose() : void
      {
         this.shutdownEvent();
         this.removeEvents();
         this._model.clear();
         this._model = null;
      }
   }
}

