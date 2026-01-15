package yyvip.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import yyvip.YYVipManager;
   
   public class YYVipOpenView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _tipTxt:FilterFrameText;
      
      private var _awardList:Vector.<YYVipAwardCell>;
      
      public function YYVipOpenView()
      {
         super();
         this.x = 2;
         this.y = -8;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var tmp:YYVipAwardCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.yyvip.openView.bg");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.view.getBtn");
         this._getBtn.enable = false;
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("yyvip.view.openBtn");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("yyvip.openView.tipTxt");
         this._tipTxt.text = LanguageMgr.GetTranslation("yyVip.openView.tipTxt");
         addChild(this._bg);
         addChild(this._getBtn);
         addChild(this._openBtn);
         addChild(this._tipTxt);
         this._awardList = new Vector.<YYVipAwardCell>();
         var tmpAwardInfoList:Vector.<Object> = YYVipManager.instance.openViewAwardList;
         var len:int = int(tmpAwardInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            tmp = new YYVipAwardCell(tmpAwardInfoList[i]);
            tmp.x = 52 + 108 * i;
            tmp.y = 102;
            addChild(tmp);
            this._awardList.push(tmp);
         }
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.openClickHandler,false,0,true);
      }
      
      private function openClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         YYVipManager.instance.gotoOpenUrl();
      }
      
      private function getClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var args:URLVariables = new URLVariables();
         args["uid"] = PlayerManager.Instance.Self.ID;
         args["type"] = "2";
         args["reward"] = "1";
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ProxyVIP.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestError,false,0,true);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onRequestComplete,false,0,true);
         LoadResourceManager.Instance.startLoad(loader);
         this._getBtn.enable = false;
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
      
      public function refreshOpenOrCostBtn(isVip:int, isCanGet:int) : void
      {
         if(!this._openBtn || !this._getBtn)
         {
            return;
         }
         if(isVip == 0)
         {
            this._openBtn.enable = true;
         }
         else
         {
            this._openBtn.enable = false;
         }
         if(isCanGet == 0)
         {
            this._getBtn.enable = false;
         }
         else
         {
            this._getBtn.enable = true;
         }
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.openClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._getBtn = null;
         this._openBtn = null;
         this._awardList = null;
         this._tipTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

