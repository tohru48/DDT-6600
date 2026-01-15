package yyvip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import yyvip.YYVipManager;
   
   public class YYVipDailyAwardView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _yearGetBtn:SimpleBitmapButton;
      
      private var _levelAwardList:Vector.<YYVipLevelAwardCell>;
      
      private var _yearAwardList:Vector.<YYVipAwardCell>;
      
      public function YYVipDailyAwardView()
      {
         super();
         this.x = 2;
         this.y = -22;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var j:int = 0;
         var tmp:YYVipLevelAwardCell = null;
         var tmp2:YYVipAwardCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.yyvip.dailyView.bg");
         addChild(this._bg);
         this._levelAwardList = new Vector.<YYVipLevelAwardCell>();
         for(i = 1; i <= 6; i++)
         {
            tmp = new YYVipLevelAwardCell(i);
            tmp.x = 42;
            tmp.y = 31 + i * 51;
            addChild(tmp);
            this._levelAwardList.push(tmp);
         }
         this._yearAwardList = new Vector.<YYVipAwardCell>();
         var tmpAwardInfoList:Vector.<Object> = YYVipManager.instance.dailyViewYearAwardList;
         var len:int = int(tmpAwardInfoList.length);
         for(j = 0; j < len; j++)
         {
            tmp2 = new YYVipAwardCell(tmpAwardInfoList[j]);
            tmp2.x = 492 + j % 2 * 104;
            tmp2.y = 132 + int(j / 2) * 124;
            addChild(tmp2);
            this._yearAwardList.push(tmp2);
         }
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.view.getBtn");
         this._getBtn.enable = false;
         PositionUtils.setPos(this._getBtn,"yyvip.dailyView.getBtnPos");
         this._yearGetBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.view.getBtn");
         this._yearGetBtn.enable = false;
         PositionUtils.setPos(this._yearGetBtn,"yyvip.dailyView.yearGetBtnPos");
         addChild(this._getBtn);
         addChild(this._yearGetBtn);
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
         this._yearGetBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
      }
      
      public function refreshBtnStatus(isCanGet:int, isYearCanGet:int) : void
      {
         if(isCanGet == 0)
         {
            this._getBtn.enable = false;
         }
         else
         {
            this._getBtn.enable = true;
         }
         if(isYearCanGet == 0)
         {
            this._yearGetBtn.enable = false;
         }
         else
         {
            this._yearGetBtn.enable = true;
         }
      }
      
      private function getClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmp:String = "2";
         var tmpBtn:SimpleBitmapButton = event.currentTarget as SimpleBitmapButton;
         tmpBtn.enable = false;
         switch(tmpBtn)
         {
            case this._getBtn:
               tmp = "2";
               break;
            case this._yearGetBtn:
               tmp = "3";
         }
         var args:URLVariables = new URLVariables();
         args["uid"] = PlayerManager.Instance.Self.ID;
         args["type"] = "2";
         args["reward"] = tmp;
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ProxyVIP.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestError,false,0,true);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onRequestComplete,false,0,true);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __onRequestError(evt:LoaderEvent) : void
      {
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestComplete);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.requestData.failTipTxt"));
      }
      
      private function __onRequestComplete(evt:LoaderEvent) : void
      {
         var type:int = 0;
         var result:int = 0;
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestComplete);
         var xml:XML = new XML(evt.loader.content);
         if(xml.@value == "true")
         {
            type = int(xml.@Type);
            if(type == 2)
            {
               result = int(xml.@Reward);
               if(result == 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.getReward.successTxt"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.getReward.failTxt"));
               }
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.requestData.failTipTxt"));
         }
      }
      
      private function guideToOpen(tip:String) : void
      {
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),tip,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.confirmHandler,false,0,true);
      }
      
      private function confirmHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.confirmHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            YYVipManager.instance.gotoOpenUrl();
         }
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         this._yearGetBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._getBtn = null;
         this._yearGetBtn = null;
         this._levelAwardList = null;
         this._yearAwardList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

