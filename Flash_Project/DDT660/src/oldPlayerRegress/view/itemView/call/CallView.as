package oldPlayerRegress.view.itemView.call
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import oldPlayerRegress.data.RegressData;
   import road7th.comm.PackageIn;
   
   public class CallView extends Frame
   {
      
      private var _titleBg:Bitmap;
      
      private var _bottomBtnBg:ScaleBitmapImage;
      
      private var _titleImg:ScaleFrameImage;
      
      private var _configBtn:SimpleBitmapButton;
      
      private var _callInfo:FilterFrameText;
      
      private var _inputBg:Scale9CornerImage;
      
      private var _lookBtn:Bitmap;
      
      private var _callLookupView:CallLookUpView;
      
      public function CallView()
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
         var pos:Point = null;
         this._titleBg = ComponentFactory.Instance.creat("asset.regress.titleBg");
         this._bottomBtnBg = ComponentFactory.Instance.creatComponentByStylename("regress.bottomBgImg");
         this._titleImg = ComponentFactory.Instance.creatComponentByStylename("call.titleImg");
         this._configBtn = ComponentFactory.Instance.creatComponentByStylename("call.configBtn");
         this._configBtn.enable = false;
         if(RegressData.isCallEnable)
         {
            this._configBtn.enable = true;
         }
         this._callInfo = ComponentFactory.Instance.creatComponentByStylename("regress.Description");
         this._callInfo.text = LanguageMgr.GetTranslation("ddt.regress.callView.callInfo");
         PositionUtils.setPos(this._callInfo,"regress.call.callInfo.pos");
         this._callLookupView = new CallLookUpView();
         pos = ComponentFactory.Instance.creatCustomObject("regress.call.cookupView.Pos");
         this._callLookupView.x = pos.x;
         this._callLookupView.y = pos.y;
         addToContent(this._titleBg);
         addToContent(this._bottomBtnBg);
         addToContent(this._titleImg);
         addToContent(this._configBtn);
         addToContent(this._callInfo);
         addToContent(this._callLookupView);
      }
      
      private function initEvent() : void
      {
         this._configBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_CHECK,this.__onCheck);
      }
      
      protected function __onCheck(event:CrazyTankSocketEvent) : void
      {
         var num:int = 0;
         var pkg:PackageIn = event.pkg;
         if(pkg.bytesAvailable > 0)
         {
            num = pkg.readInt();
            if(num == 1)
            {
               RegressData.isCallEnable = false;
               this._configBtn.enable = false;
            }
         }
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._callLookupView.inputText.text != "")
         {
            SocketManager.Instance.out.sendRegressCheckPlayer(this._callLookupView.inputText.text);
         }
      }
      
      private function removeEvent() : void
      {
         this._configBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_CHECK,this.__onCheck);
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
         if(Boolean(this._bottomBtnBg))
         {
            this._bottomBtnBg.dispose();
            this._bottomBtnBg = null;
         }
         if(Boolean(this._titleImg))
         {
            this._titleImg.dispose();
            this._titleImg = null;
         }
         if(Boolean(this._configBtn))
         {
            this._configBtn.dispose();
            this._configBtn = null;
         }
         if(Boolean(this._callInfo))
         {
            this._callInfo.dispose();
            this._callInfo = null;
         }
         if(Boolean(this._inputBg))
         {
            this._inputBg.dispose();
            this._inputBg = null;
         }
         if(Boolean(this._bottomBtnBg))
         {
            this._lookBtn = null;
         }
         if(Boolean(this._callLookupView))
         {
            this._callLookupView.dispose();
            this._callLookupView = null;
         }
      }
   }
}

