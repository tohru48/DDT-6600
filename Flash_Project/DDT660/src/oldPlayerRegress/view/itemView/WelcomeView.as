package oldPlayerRegress.view.itemView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import oldPlayerRegress.RegressManager;
   
   public class WelcomeView extends Frame
   {
      
      private var _titleBg:Bitmap;
      
      private var _welTitleImg:ScaleFrameImage;
      
      private var _privilegeBtn:TextButton;
      
      private var _welDescript:FilterFrameText;
      
      private var _firstDesData:FilterFrameText;
      
      private var _scrollPanel:ScrollPanel;
      
      public function WelcomeView()
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
         this._titleBg = ComponentFactory.Instance.creat("asset.regress.titleBg");
         this._welTitleImg = ComponentFactory.Instance.creatComponentByStylename("regress.WelTitle");
         this._privilegeBtn = ComponentFactory.Instance.creatComponentByStylename("regress.privilegeBtn");
         this._privilegeBtn.text = LanguageMgr.GetTranslation("ddt.regress.welView.Privilege");
         this._welDescript = ComponentFactory.Instance.creatComponentByStylename("regress.Description");
         this._welDescript.text = LanguageMgr.GetTranslation("ddt.regress.welView.Descript");
         this._firstDesData = ComponentFactory.Instance.creatComponentByStylename("regress.firstDes");
         this._firstDesData.mouseEnabled = true;
         this._firstDesData.htmlText = RegressManager.instance.updateContent + "";
         addToContent(this._titleBg);
         addToContent(this._welTitleImg);
         addToContent(this._privilegeBtn);
         addToContent(this._welDescript);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtRegress.views.welcomeViewScroll");
         addToContent(this._scrollPanel);
         this._scrollPanel.setView(this._firstDesData);
         this._scrollPanel.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         this._privilegeBtn.addEventListener(MouseEvent.CLICK,this.__onPrivilegeClick);
      }
      
      protected function __onPrivilegeClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var welFrameView:WelFrameView = ComponentFactory.Instance.creatComponentByStylename("regress.privilegeAssetFrame");
         LayerManager.Instance.addToLayer(welFrameView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._privilegeBtn.removeEventListener(MouseEvent.CLICK,this.__onPrivilegeClick);
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._titleBg))
         {
            this._titleBg = null;
         }
         if(Boolean(this._welTitleImg))
         {
            this._welTitleImg.dispose();
            this._welTitleImg = null;
         }
         if(Boolean(this._privilegeBtn))
         {
            this._privilegeBtn.dispose();
            this._privilegeBtn = null;
         }
         if(Boolean(this._welDescript))
         {
            this._welDescript.dispose();
            this._welDescript = null;
         }
         if(Boolean(this._firstDesData))
         {
            this._firstDesData.dispose();
            this._firstDesData = null;
         }
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeAllChildren(this._scrollPanel);
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
         }
      }
   }
}

