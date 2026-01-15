package ddt.view.qqTips
{
   import calendar.CalendarManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DesktopManager;
   import ddt.manager.PathManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import times.TimesManager;
   
   public class QQTipsView extends Sprite implements Disposeable
   {
      
      private var _qqInfo:QQTipsInfo;
      
      private var _bg:Bitmap;
      
      private var _closeBtn:BaseButton;
      
      private var _titleTxt:FilterFrameText;
      
      private var _outUrlTxt:TextField;
      
      protected var _moveRect:Sprite;
      
      public function QQTipsView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.QQtipsBG");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.closebt");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.titleTxt");
         this._outUrlTxt = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQOutUrlTxt");
         this._outUrlTxt.defaultTextFormat = ComponentFactory.Instance.model.getSet("coreIconQQ.qq.outTF");
         this._moveRect = new Sprite();
         addChild(this._bg);
         addChild(this._closeBtn);
         addChild(this._titleTxt);
         addChild(this._outUrlTxt);
         addChild(this._moveRect);
      }
      
      private function initEvents() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__colseClick);
         this._outUrlTxt.addEventListener(TextEvent.LINK,this.__onTextClicked);
         this._moveRect.addEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
         QQtipsManager.instance.addEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW,this.__CloseView);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function remvoeEvents() : void
      {
         if(Boolean(this._closeBtn))
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__colseClick);
         }
         if(Boolean(this._outUrlTxt))
         {
            this._outUrlTxt.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         }
         if(Boolean(this._moveRect))
         {
            this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
         }
         QQtipsManager.instance.removeEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW,this.__CloseView);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function __colseClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ObjectUtils.disposeObject(this);
      }
      
      private function __CloseView(e:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function __onKeyDown(event:KeyboardEvent) : void
      {
         var focusTarget:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(DisplayUtils.isTargetOrContain(focusTarget,this))
         {
            if(event.keyCode == Keyboard.ESCAPE)
            {
               SoundManager.instance.play("008");
               ObjectUtils.disposeObject(this);
            }
         }
      }
      
      protected function __onFrameMoveStart(event:MouseEvent) : void
      {
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMoveWindow);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onFrameMoveStop);
         startDrag();
      }
      
      protected function __onFrameMoveStop(event:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onFrameMoveStop);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMoveWindow);
         stopDrag();
      }
      
      protected function __onMoveWindow(event:MouseEvent) : void
      {
         if(DisplayUtils.isInTheStage(new Point(event.localX,event.localY),this))
         {
            event.updateAfterEvent();
         }
         else
         {
            this.__onFrameMoveStop(null);
         }
      }
      
      public function set qqInfo(value:QQTipsInfo) : void
      {
         this._qqInfo = value;
         this._titleTxt.text = this._qqInfo.title;
         var url:String = "<a href=\"event:" + "clicktype:" + this._qqInfo.outInType + "\">" + this._qqInfo.content + "</a>";
         this._outUrlTxt.htmlText = url;
      }
      
      private function __onTextClicked(e:TextEvent) : void
      {
         var req:URLRequest = new URLRequest(PathManager.solveRequestPath("LogClickTip.ashx"));
         var toServerData:URLVariables = new URLVariables();
         toServerData["title"] = this.qqInfo.title;
         req.data = toServerData;
         var loader:URLLoader = new URLLoader(req);
         loader.load(req);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         if(this.qqInfo.outInType == 0)
         {
            this.__playINmoudle();
         }
         else
         {
            SoundManager.instance.play("008");
            this.gotoPage(this.qqInfo.url);
         }
         ObjectUtils.disposeObject(this);
      }
      
      private function onIOError(e:IOErrorEvent) : void
      {
      }
      
      private function __playINmoudle() : void
      {
         if(this.qqInfo.outInType == 0)
         {
            if(this.qqInfo.moduleType == QQTipsInfo.MODULE_TIMES)
            {
               TimesManager.Instance.showByQQtips(this.qqInfo.inItemID);
            }
            else if(this.qqInfo.moduleType == QQTipsInfo.MODULE_CALENDAR)
            {
               CalendarManager.getInstance().qqOpen(this.qqInfo.inItemID);
            }
            else if(this.qqInfo.moduleType == QQTipsInfo.MODULE_SHOP)
            {
               QQtipsManager.instance.gotoShop(this.qqInfo.inItemID);
            }
         }
      }
      
      private function gotoPage(url:String) : void
      {
         var redirictURL:String = null;
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            redirictURL = "function redict () {window.open(\"" + url + "\", \"_blank\")}";
            ExternalInterface.call(redirictURL);
         }
         else
         {
            navigateToURL(new URLRequest(encodeURI(url)),"_blank");
         }
      }
      
      public function get qqInfo() : QQTipsInfo
      {
         return this._qqInfo;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false);
         StageReferance.stage.focus = this;
      }
      
      public function set moveRect(value:String) : void
      {
         var arr:Array = value.split(",");
         this._moveRect.graphics.clear();
         this._moveRect.graphics.beginFill(0,0);
         this._moveRect.graphics.drawRect(arr[0],arr[1],arr[2],arr[3]);
         this._moveRect.graphics.endFill();
      }
      
      public function dispose() : void
      {
         this.remvoeEvents();
         this._qqInfo = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._closeBtn))
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(Boolean(this._titleTxt))
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(Boolean(this._outUrlTxt))
         {
            ObjectUtils.disposeObject(this._outUrlTxt);
         }
         this._outUrlTxt = null;
         if(Boolean(this._moveRect))
         {
            ObjectUtils.disposeObject(this._moveRect);
         }
         this._moveRect = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         QQtipsManager.instance.isShowTipNow = false;
      }
   }
}

