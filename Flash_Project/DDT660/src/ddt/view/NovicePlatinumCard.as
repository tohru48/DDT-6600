package ddt.view
{
   import activeEvents.ActiveEventsManager;
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLVariables;
   
   public class NovicePlatinumCard extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _activityCardPSWII:Bitmap;
      
      private var _divisionLine:Bitmap;
      
      private var _iconGive:Bitmap;
      
      private var _textInput:TextInput;
      
      private var _awardTxt:FilterFrameText;
      
      private var _activeGetBtn:TextButton;
      
      private var _activeCloseBtn:TextButton;
      
      private var _activeEventsInfo:ActiveEventsInfo;
      
      public function NovicePlatinumCard()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("ddt.view.NovicePlatinumCard.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.activeEventsBg");
         this.addToContent(this._bg);
         this._activityCardPSWII = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.activityCardPSWII");
         this.addToContent(this._activityCardPSWII);
         this._divisionLine = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.divisionLine");
         this.addToContent(this._divisionLine);
         this._iconGive = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.iconGive");
         this.addToContent(this._iconGive);
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.textInput");
         this.addToContent(this._textInput);
         this._awardTxt = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.awardTxt");
         this.addToContent(this._awardTxt);
         this._activeGetBtn = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.activeGetBtn");
         this._activeGetBtn.text = LanguageMgr.GetTranslation("get");
         this._activeGetBtn.enable = false;
         this.addToContent(this._activeGetBtn);
         this._activeCloseBtn = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.activeCloseBtn");
         this._activeCloseBtn.text = LanguageMgr.GetTranslation("cancel");
         this.addToContent(this._activeCloseBtn);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.addEventListener(TextEvent.TEXT_INPUT,this.__input);
         this._textInput.addEventListener(Event.CHANGE,this.__onChange);
         this._textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__textInputKeyDown);
         this._activeGetBtn.addEventListener(MouseEvent.CLICK,this.__activeGetBtnClick);
         this._activeCloseBtn.addEventListener(MouseEvent.CLICK,this.__activeCloseBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_PULLDOWN,this.__activeSocket);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.removeEventListener(TextEvent.TEXT_INPUT,this.__input);
         this._textInput.removeEventListener(Event.CHANGE,this.__onChange);
         this._textInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__textInputKeyDown);
         this._activeGetBtn.removeEventListener(MouseEvent.CLICK,this.__activeGetBtnClick);
         this._activeCloseBtn.removeEventListener(MouseEvent.CLICK,this.__activeCloseBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTIVE_PULLDOWN,this.__activeSocket);
      }
      
      protected function __activeSocket(event:CrazyTankSocketEvent) : void
      {
         var boole:Boolean = event.pkg.readBoolean();
         if(boole)
         {
            this.dispose();
         }
         else
         {
            this._activeGetBtn.enable = true;
         }
      }
      
      private function __input(event:TextEvent) : void
      {
         if(this._textInput.text.length + event.text.length > 50)
         {
            event.preventDefault();
         }
      }
      
      private function __onChange(event:Event) : void
      {
         if(this._textInput.text != "")
         {
            this._activeGetBtn.enable = true;
         }
         else
         {
            this._activeGetBtn.enable = false;
         }
      }
      
      protected function __textInputKeyDown(event:KeyboardEvent) : void
      {
         if(this._activeGetBtn.enable && event.keyCode == 13)
         {
            this.__activeGetBtnClick();
         }
      }
      
      protected function __activeGetBtnClick(event:MouseEvent = null) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._textInput.text == "")
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
            alert.info.showCancel = false;
            return;
         }
         this._activeGetBtn.enable = false;
         SocketManager.Instance.out.sendActivePullDown(this._activeEventsInfo.ActiveID,this._textInput.text);
      }
      
      public function setup() : void
      {
         var args:URLVariables = null;
         var load:BaseLoader = null;
         var data:Array = ActiveEventsManager.Instance.model.list;
         if(data == null)
         {
            this.dispose();
            return;
         }
         for(var i:int = 0; i < data.length; i++)
         {
            if(data[i].Type == 10)
            {
               this._activeEventsInfo = data[i] as ActiveEventsInfo;
            }
         }
         if(Boolean(this._activeEventsInfo))
         {
            args = RequestVairableCreater.creatWidthKey(true);
            load = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("UserGetActiveState.ashx"),BaseLoader.REQUEST_LOADER,args);
            load.addEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            load.addEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
            LoadResourceManager.Instance.startLoad(load);
         }
         else
         {
            this.dispose();
         }
      }
      
      protected function __loadComplete(event:LoaderEvent) : void
      {
         event.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         event.currentTarget.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
         if(event.loader.content == "True")
         {
            this._awardTxt.text = this._activeEventsInfo.Content;
            this.show();
         }
         else
         {
            this.dispose();
         }
      }
      
      protected function __loadError(event:LoaderEvent) : void
      {
         event.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         event.currentTarget.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __activeCloseBtnClick(event:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._activeEventsInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._activityCardPSWII);
         this._activityCardPSWII = null;
         ObjectUtils.disposeObject(this._divisionLine);
         this._divisionLine = null;
         ObjectUtils.disposeObject(this._iconGive);
         this._iconGive = null;
         ObjectUtils.disposeObject(this._textInput);
         this._textInput = null;
         ObjectUtils.disposeObject(this._awardTxt);
         this._awardTxt = null;
         ObjectUtils.disposeObject(this._activeGetBtn);
         this._activeGetBtn = null;
         ObjectUtils.disposeObject(this._activeCloseBtn);
         this._activeCloseBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

