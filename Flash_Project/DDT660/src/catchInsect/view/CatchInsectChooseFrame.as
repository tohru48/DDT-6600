package catchInsect.view
{
   import catchInsect.CatchInsectMananger;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class CatchInsectChooseFrame extends Frame
   {
      
      private var _roomBgImg:ScaleBitmapImage;
      
      private var _entranceImg:Bitmap;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _chooseRoomText:FilterFrameText;
      
      private var _gotoForestBtn:BaseButton;
      
      private var _checkGeinBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _clickDate:Number = 0;
      
      public function CatchInsectChooseFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("catchInsect.chooseFrameTitle");
         this._roomBgImg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.chooseFrame.bg");
         this._entranceImg = ComponentFactory.Instance.creatBitmap("catchInsect.entranceImg");
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.chooseFrame.bottomBg");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.chooseFrame.timeTxt");
         this._chooseRoomText = ComponentFactory.Instance.creatComponentByStylename("catchInsect.chooseFrame.descTxt");
         this._gotoForestBtn = ComponentFactory.Instance.creat("catchInsect.chooseFrame.gotoForestBtn");
         this._checkGeinBtn = ComponentFactory.Instance.creat("catchInsect.chooseFrame.checkGeinBtn");
         this._helpBtn = ComponentFactory.Instance.creat("catchInsect.chooseFrame.helpBtn");
         addToContent(this._roomBgImg);
         addToContent(this._entranceImg);
         addToContent(this._bottomBg);
         addToContent(this._activeTimeTxt);
         addToContent(this._chooseRoomText);
         addToContent(this._gotoForestBtn);
         addToContent(this._checkGeinBtn);
         addToContent(this._helpBtn);
      }
      
      private function initText() : void
      {
         this._chooseRoomText.text = LanguageMgr.GetTranslation("catchInsect.chooseFrame.descTxt");
         this._activeTimeTxt.text = LanguageMgr.GetTranslation("catchInsect.chooseFrame.timeTxt",CatchInsectMananger.instance.model.activityTime);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._gotoForestBtn.addEventListener(MouseEvent.CLICK,this.__gotoForestBtnClick);
         this._checkGeinBtn.addEventListener(MouseEvent.CLICK,this.__checkGeinBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._gotoForestBtn))
         {
            this._gotoForestBtn.removeEventListener(MouseEvent.CLICK,this.__gotoForestBtnClick);
         }
         if(Boolean(this._checkGeinBtn))
         {
            this._checkGeinBtn.removeEventListener(MouseEvent.CLICK,this.__checkGeinBtnClick);
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
         }
      }
      
      private function __gotoForestBtnClick(e:MouseEvent) : void
      {
         if(new Date().time - this._clickDate > 1000)
         {
            this._clickDate = new Date().time;
            SoundManager.instance.play("008");
            SocketManager.Instance.out.enterOrLeaveInsectScene(0);
         }
      }
      
      private function __checkGeinBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CatchInsectMananger.instance.openCheckGeinFrame();
      }
      
      private function __helpBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("catchInsect.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("catchInsect.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(50);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._roomBgImg = null;
         this._entranceImg = null;
         this._activeTimeTxt = null;
         this._chooseRoomText = null;
         this._gotoForestBtn = null;
         this._checkGeinBtn = null;
         this._helpBtn = null;
         this._bottomBg = null;
      }
   }
}

