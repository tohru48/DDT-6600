package christmas.view
{
   import christmas.manager.ChristmasManager;
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
   
   public class ChristmasChooseRoomFrame extends Frame
   {
      
      private var _titleImg:Bitmap;
      
      private var _roomBgImg:ScaleBitmapImage;
      
      private var _entranceImg:Bitmap;
      
      private var _activityTimeImg:Bitmap;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _chooseRoomText:FilterFrameText;
      
      private var _enterBtn:BaseButton;
      
      private var _enterHeapBtn:BaseButton;
      
      private var _help:BaseButton;
      
      private var _clickDate:Number = 0;
      
      public function ChristmasChooseRoomFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.menu.christmasTiTle");
         this._roomBgImg = ComponentFactory.Instance.creatComponentByStylename("chooseRoom.christmas.ChristmasChooseRoomFrameBgImg");
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.christmas.room.titleImg");
         this._entranceImg = ComponentFactory.Instance.creatBitmap("asset.christmas.room.entranceImg");
         this._activityTimeImg = ComponentFactory.Instance.creatBitmap("asset.christmas.room.activityTimeImg");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.chooseRoom.activeTimeTxt");
         this._chooseRoomText = ComponentFactory.Instance.creatComponentByStylename("christmas.chooseRoom.chooseRoomText");
         this._enterBtn = ComponentFactory.Instance.creat("christmas.chooseRoom.enter.btn");
         this._enterHeapBtn = ComponentFactory.Instance.creat("christmas.chooseRoom.enterHeap.btn");
         this._help = ComponentFactory.Instance.creat("christmas.chooseRoom.help.btn");
         addToContent(this._roomBgImg);
         addToContent(this._titleImg);
         addToContent(this._entranceImg);
         addToContent(this._activityTimeImg);
         addToContent(this._activeTimeTxt);
         addToContent(this._chooseRoomText);
         addToContent(this._enterBtn);
         addToContent(this._enterHeapBtn);
         addToContent(this._help);
      }
      
      private function initText() : void
      {
         this._chooseRoomText.text = LanguageMgr.GetTranslation("christmas.chooseRoom.chooseRoomTextLG");
         this._activeTimeTxt.text = ChristmasManager.instance.model.activityTime;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._enterBtn.addEventListener(MouseEvent.CLICK,this.__onClickEnterHandler);
         this._enterHeapBtn.addEventListener(MouseEvent.CLICK,this.__onClickEnterHeapHandler);
         this._help.addEventListener(MouseEvent.CLICK,this.__onClickHelpHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._enterBtn))
         {
            this._enterBtn.removeEventListener(MouseEvent.CLICK,this.__onClickEnterHandler);
         }
         if(Boolean(this._enterHeapBtn))
         {
            this._enterHeapBtn.removeEventListener(MouseEvent.CLICK,this.__onClickEnterHeapHandler);
         }
         if(Boolean(this._help))
         {
            this._help.removeEventListener(MouseEvent.CLICK,this.__onClickHelpHandler);
         }
      }
      
      private function __onClickEnterHandler(e:MouseEvent) : void
      {
         if(new Date().time - this._clickDate > 1000)
         {
            this._clickDate = new Date().time;
            SoundManager.instance.play("008");
            SocketManager.Instance.out.enterChristmasRoomIsTrue();
         }
      }
      
      private function __onClickEnterHeapHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.enterMakingSnowManRoom();
      }
      
      private function __onClickHelpHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("christmas.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("christmas.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("christmas.christmas.readme");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
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
         this._titleImg = null;
         this._roomBgImg = null;
         this._entranceImg = null;
         this._activityTimeImg = null;
         this._activeTimeTxt = null;
         this._chooseRoomText = null;
         this._enterBtn = null;
         this._enterHeapBtn = null;
      }
   }
}

