package ddt.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import feedback.FeedbackManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class DailyButtunBar extends Sprite implements Disposeable
   {
      
      private static var instance:DailyButtunBar;
      
      private var _inited:Boolean;
      
      private var _vBox:VBox;
      
      private var _downLoadClientBtn:SimpleBitmapButton;
      
      private var _complainBtn:MovieImage;
      
      private var _eyeBtn:ScaleFrameImage;
      
      private var _hideFlag:Boolean = false;
      
      private var _clickDate:Number = 0;
      
      public function DailyButtunBar()
      {
         super();
         this._inited = false;
      }
      
      public static function get Insance() : DailyButtunBar
      {
         if(instance == null)
         {
            instance = new DailyButtunBar();
         }
         return instance;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._downLoadClientBtn);
         this._downLoadClientBtn = null;
         ObjectUtils.disposeObject(this._complainBtn);
         this._complainBtn = null;
         this._inited = false;
         if(Boolean(this._eyeBtn))
         {
            this._eyeBtn.removeEventListener(MouseEvent.CLICK,this.__onEyeClick);
            this._eyeBtn.dispose();
            this._eyeBtn = null;
         }
         if(Boolean(this._vBox))
         {
            this._vBox.dispose();
            this._vBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      public function initView() : void
      {
         if(this._inited)
         {
            return;
         }
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("toolbar.rightVBox");
         addChild(this._vBox);
         this._eyeBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.eyebtn");
         this._eyeBtn.buttonMode = true;
         this._eyeBtn.tipData = LanguageMgr.GetTranslation("hall.view.dailyBtn.eyeTipsText2");
         this._vBox.addChild(this._eyeBtn);
         this._eyeBtn.addEventListener(MouseEvent.CLICK,this.__onEyeClick);
         if(PathManager.solveFeedbackEnable())
         {
            this._complainBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.complainbtn");
            this._complainBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.customerService");
            this._complainBtn.setFrame(1);
            this._vBox.addChild(this._complainBtn);
            this._complainBtn.buttonMode = true;
         }
         this._downLoadClientBtn = ComponentFactory.Instance.creatComponentByStylename("core.hall.clientDownloadBtn");
         this._downLoadClientBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.downLoadClient");
         if(PathManager.solveClientDownloadPath() != "")
         {
            this._vBox.addChild(this._downLoadClientBtn);
         }
         this._downLoadClientBtn.addEventListener(MouseEvent.CLICK,this.__onActionClick);
         this.setEyeBtnFrame(this._hideFlag ? 1 : 2);
         this.initEvent();
         this._inited = true;
      }
      
      protected function __onEyeClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(new Date().time - this._clickDate > 1000)
         {
            this._clickDate = new Date().time;
            this._hideFlag = !this._hideFlag;
            SocketManager.Instance.out.sendNewHallPlayerHid(this._hideFlag);
         }
      }
      
      public function setEyeBtnFrame(id:int) : void
      {
         if(Boolean(this._eyeBtn))
         {
            this._eyeBtn.setFrame(id);
            this._eyeBtn.tipData = LanguageMgr.GetTranslation("hall.view.dailyBtn.eyeTipsText" + id);
         }
      }
      
      private function __onActionClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      public function show() : void
      {
         this.initView();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
         if(Boolean(FeedbackManager.instance.feedbackReplyData))
         {
            if(FeedbackManager.instance.feedbackReplyData.length <= 0)
            {
               this.setComplainGlow(false);
            }
            else
            {
               this.setComplainGlow(true);
            }
         }
      }
      
      public function setComplainGlow(value:Boolean) : void
      {
         if(value)
         {
            if(Boolean(this._complainBtn))
            {
               this._complainBtn.setFrame(2);
            }
         }
         else if(Boolean(this._complainBtn))
         {
            this._complainBtn.setFrame(1);
         }
      }
      
      private function __onComplainClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("015");
         try
         {
            this._complainBtn.setFrame(1);
            FeedbackManager.instance.show();
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_FEEDBACK);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_FEEDBACK)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_FEEDBACK)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            this._complainBtn.setFrame(1);
            FeedbackManager.instance.show();
         }
      }
      
      private function initEvent() : void
      {
         if(PathManager.solveFeedbackEnable())
         {
            this._complainBtn.addEventListener(MouseEvent.CLICK,this.__onComplainClick);
         }
      }
      
      private function removeEvent() : void
      {
         if(PathManager.solveFeedbackEnable())
         {
            if(this._complainBtn != null)
            {
               this._complainBtn.removeEventListener(MouseEvent.CLICK,this.__onComplainClick);
            }
         }
         if(Boolean(this._downLoadClientBtn))
         {
            this._downLoadClientBtn.removeEventListener(MouseEvent.CLICK,this.__onActionClick);
         }
      }
      
      public function set hideFlag(value:Boolean) : void
      {
         this._hideFlag = value;
         this.setEyeBtnFrame(this._hideFlag ? 1 : 2);
      }
   }
}

