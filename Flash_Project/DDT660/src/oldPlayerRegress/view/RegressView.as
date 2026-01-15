package oldPlayerRegress.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import oldPlayerRegress.RegressManager;
   
   public class RegressView extends Frame
   {
      
      private var _frameBottom:ScaleBitmapImage;
      
      private var _leftBackgroundBg:DisplayObject;
      
      private var _leftPattern:Bitmap;
      
      private var _goldEdge:ScaleBitmapImage;
      
      private var _rightFrameBottom:ScaleFrameImage;
      
      private var _regressMenuView:RegressMenuView;
      
      public function RegressView()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.regress.regressView.title");
         this._frameBottom = ComponentFactory.Instance.creatComponentByStylename("regress.frameBottom");
         this._leftBackgroundBg = ComponentFactory.Instance.creatCustomObject("regress.ActivityListBg");
         this._leftPattern = ComponentFactory.Instance.creat("asset.regress.huaweng");
         this._goldEdge = ComponentFactory.Instance.creatComponentByStylename("regress.jinbian");
         this._rightFrameBottom = ComponentFactory.Instance.creatComponentByStylename("regress.frameRightBottom");
         this._regressMenuView = new RegressMenuView();
         addToContent(this._frameBottom);
         addToContent(this._leftBackgroundBg);
         addToContent(this._leftPattern);
         addToContent(this._goldEdge);
         addToContent(this._rightFrameBottom);
         addToContent(this._regressMenuView);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      public function show() : void
      {
         if(RegressManager.instance.autoPopUp)
         {
            RegressManager.instance.autoPopUp = false;
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         else
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               RegressManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._frameBottom))
         {
            this._frameBottom.dispose();
            this._frameBottom = null;
         }
         if(Boolean(this._leftBackgroundBg))
         {
            this._leftBackgroundBg = null;
         }
         if(Boolean(this._leftPattern))
         {
            this._leftPattern = null;
         }
         if(Boolean(this._goldEdge))
         {
            this._goldEdge.dispose();
            this._goldEdge = null;
         }
         if(Boolean(this._rightFrameBottom))
         {
            this._rightFrameBottom.dispose();
            this._rightFrameBottom = null;
         }
         if(Boolean(this._regressMenuView))
         {
            this._regressMenuView.dispose();
            this._regressMenuView = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

