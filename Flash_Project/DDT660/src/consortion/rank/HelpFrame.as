package consortion.rank
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   
   public class HelpFrame extends BaseAlerFrame
   {
      
      private var _mc:MovieClip;
      
      public function HelpFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.view.HelpButtonText"),"",LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"));
         info = alerInfo;
         this._mc = ComponentFactory.Instance.creat("consortion.rank.descript");
         this._mc.x = -7;
         this._mc.y = -1;
         addToContent(this._mc);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.frameHander);
      }
      
      private function frameHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.frameHander);
         ObjectUtils.disposeObject(this._mc);
         super.dispose();
         this._mc = null;
      }
   }
}

