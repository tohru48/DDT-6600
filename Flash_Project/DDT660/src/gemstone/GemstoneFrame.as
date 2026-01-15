package gemstone
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.ExpBar;
   import gemstone.views.GemstoneCurInfo;
   import gemstone.views.GemstoneInfoView;
   import gemstone.views.GemstoneObtainView;
   import gemstone.views.GemstoneUpView;
   
   public class GemstoneFrame extends Frame
   {
      
      private var _gemstoneObtainView:GemstoneObtainView;
      
      private var _gemstoneInfoView:GemstoneInfoView;
      
      private var _gemstoneUpView:GemstoneUpView;
      
      private var _selfInfo:SelfInfo;
      
      private var _bg:ScaleBitmapImage;
      
      private var _gemstoneCurInfo:GemstoneCurInfo;
      
      private var _loader:BaseLoader;
      
      private var _gInfoList:Vector.<GemstoneStaticInfo>;
      
      public var redInfoList:Vector.<GemstoneStaticInfo>;
      
      public var buleInfoList:Vector.<GemstoneStaticInfo>;
      
      public var greeInfoList:Vector.<GemstoneStaticInfo>;
      
      public var yellInfoList:Vector.<GemstoneStaticInfo>;
      
      private var _goundMask:Sprite;
      
      public function GemstoneFrame()
      {
         super();
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.gemstoneCompHander);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.gemstoneProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GEMSTONE_SYS);
      }
      
      private function gemstoneProgress(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.GEMSTONE_SYS)
         {
            UIModuleSmallLoading.Instance.progress = pEvent.loader.progress * 100;
         }
      }
      
      private function gemstoneCompHander(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.GEMSTONE_SYS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.gemstoneCompHander);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.gemstoneProgress);
            this._selfInfo = PlayerManager.Instance.Self;
            this.initView();
         }
      }
      
      public function initView() : void
      {
         this._goundMask = new Sprite();
         this._goundMask.graphics.beginFill(0);
         this._goundMask.graphics.drawRect(-69,-94,1000,800);
         this._goundMask.graphics.endFill();
         this._goundMask.alpha = 0;
         this._goundMask.visible = false;
         this._gemstoneUpView = new GemstoneUpView(this._selfInfo);
         addToContent(this._gemstoneUpView);
         addToContent(this._goundMask);
      }
      
      public function upDatafitCount() : void
      {
         this._gemstoneUpView.upDatafitCount();
      }
      
      public function getMaskMc() : Sprite
      {
         return this._goundMask;
      }
      
      public function gemstoneAction(info:GemstoneUpGradeInfo) : void
      {
         this._gemstoneUpView.gemstoneAction(info);
      }
      
      public function get expBar() : ExpBar
      {
         return this._gemstoneUpView.expBar;
      }
      
      override public function dispose() : void
      {
         GemstoneManager.Instance.clearFrame();
         if(Boolean(this._gemstoneObtainView))
         {
            ObjectUtils.disposeObject(this._gemstoneObtainView);
            this._gemstoneObtainView = null;
         }
         if(Boolean(this._gemstoneInfoView))
         {
            ObjectUtils.disposeObject(this._gemstoneInfoView);
            this._gemstoneInfoView = null;
         }
         if(Boolean(this._gemstoneUpView))
         {
            ObjectUtils.disposeObject(this._gemstoneUpView);
            this._gemstoneUpView = null;
         }
         super.dispose();
      }
   }
}

