package horse.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class HorseFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _leftTopView:HorseFrameLeftTopView;
      
      private var _rightTopView:HorseFrameRightTopView;
      
      private var _leftBottomView:HorseFrameLeftBottomView;
      
      private var _rightBottomView:HorseFrameRightBottomView;
      
      private var _helpBtn:HorseFrameHelpBtn;
      
      public function HorseFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("horse.frame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.frame.bg");
         this._leftTopView = new HorseFrameLeftTopView();
         this._rightTopView = new HorseFrameRightTopView();
         this._leftBottomView = new HorseFrameLeftBottomView();
         this._rightBottomView = new HorseFrameRightBottomView();
         this._rightBottomView.x = -2;
         this._rightBottomView.y = -9;
         this._helpBtn = new HorseFrameHelpBtn();
         addToContent(this._bg);
         addToContent(this._leftTopView);
         addToContent(this._rightTopView);
         addToContent(this._leftBottomView);
         addToContent(this._rightBottomView);
         addToContent(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._leftTopView = null;
         this._rightTopView = null;
         this._leftBottomView = null;
         this._rightBottomView = null;
         this._helpBtn = null;
      }
   }
}

