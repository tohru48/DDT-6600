package bagAndInfo.bag
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.PlayerManager;
   import email.view.EmailBagView;
   
   public class BagFrame extends Frame
   {
      
      protected var _bagView:BagView;
      
      protected var _emailBagView:EmailBagView;
      
      protected var _isShow:Boolean;
      
      public function BagFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
         this._bagView.info = PlayerManager.Instance.Self;
         this._emailBagView = ComponentFactory.Instance.creatCustomObject("email.view.EmailBagView.Frame");
         this._emailBagView.info = PlayerManager.Instance.Self;
         addToContent(this._emailBagView);
      }
      
      public function graySortBtn() : void
      {
         this._bagView.sortBagEnable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function get bagView() : BagView
      {
         return this._bagView;
      }
      
      public function get emailBagView() : EmailBagView
      {
         return this._emailBagView;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false);
         this._isShow = true;
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
            this._isShow = false;
         }
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._bagView))
         {
            this._bagView.dispose();
         }
         if(Boolean(this._emailBagView))
         {
            this._emailBagView.dispose();
         }
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

