package yyvip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import yyvip.YYVipManager;
   
   public class YYVipMainFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _openBtn:SelectedButton;
      
      private var _dailyBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _openView:YYVipOpenView;
      
      private var _dailyView:YYVipDailyAwardView;
      
      public function YYVipMainFrame()
      {
         super();
         this.initView();
         this.initEvent();
         if(YYVipManager.isShowOpenView)
         {
            this._openBtn.enable = true;
            this._btnGroup.selectIndex = 0;
         }
         else
         {
            this._openBtn.enable = false;
            this._btnGroup.selectIndex = 1;
         }
         this.initData();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("yyVip.mainFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("yyVip.mainFrame.bg");
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("yyVip.mainFrame.bottomBg");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.mainFrame.openBtn");
         this._dailyBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.mainFrame.dailyBtn");
         this._openView = new YYVipOpenView();
         this._dailyView = new YYVipDailyAwardView();
         addToContent(this._openBtn);
         addToContent(this._dailyBtn);
         addToContent(this._bg);
         addToContent(this._bottomBg);
         addToContent(this._openView);
         addToContent(this._dailyView);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._openBtn);
         this._btnGroup.addSelectItem(this._dailyBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._dailyBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
      }
      
      private function initData() : void
      {
         var args:URLVariables = new URLVariables();
         args["uid"] = PlayerManager.Instance.Self.ID;
         args["type"] = "1";
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ProxyVIP.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestDataError,false,0,true);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onRequestDataComplete,false,0,true);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __onRequestDataError(evt:LoaderEvent) : void
      {
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestDataError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestDataComplete);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.requestData.failTipTxt"));
      }
      
      private function __onRequestDataComplete(evt:LoaderEvent) : void
      {
         var type:int = 0;
         var isVip:int = 0;
         var isCanGetOpenAward:int = 0;
         var isCanGetDailyAward:int = 0;
         var isCanGetYearDailyAward:int = 0;
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestDataError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestDataComplete);
         var xml:XML = new XML(evt.loader.content);
         if(xml.@value == "true")
         {
            type = int(xml.@Type);
            if(type == 1)
            {
               isVip = int(xml.@IsVip);
               isCanGetOpenAward = int(xml.@IsReceiveOpenPack);
               isCanGetDailyAward = int(xml.@IsReceiveEveryDayPack);
               isCanGetYearDailyAward = int(xml.@IsReceiveYearPack);
               if(Boolean(this._openView))
               {
                  this._openView.refreshOpenOrCostBtn(isVip,isCanGetOpenAward);
               }
               if(Boolean(this._dailyView))
               {
                  this._dailyView.refreshBtnStatus(isCanGetDailyAward,isCanGetYearDailyAward);
               }
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.requestData.failTipTxt"));
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._openView.visible = true;
               this._dailyView.visible = false;
               break;
            case 1:
               this._openView.visible = false;
               this._dailyView.visible = true;
         }
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
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
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._dailyBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.dispose();
         }
         super.dispose();
         this._bg = null;
         this._bottomBg = null;
         this._openBtn = null;
         this._dailyBtn = null;
         this._btnGroup = null;
         this._openView = null;
         this._dailyView = null;
      }
   }
}

