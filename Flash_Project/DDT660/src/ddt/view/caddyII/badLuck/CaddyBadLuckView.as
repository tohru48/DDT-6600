package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CaddyBadLuckView extends Sprite implements Disposeable
   {
      
      private var _bg:Sprite;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _itemList:Vector.<BadLuckItem>;
      
      private var _dataList:Vector.<Object>;
      
      private var _timer:Timer;
      
      private var _Vline:MutipleImage;
      
      public function CaddyBadLuckView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var item:BadLuckItem = null;
         this._bg = ComponentFactory.Instance.creat("asset.caddy.badLuckBG");
         var sortTitleTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.sorttitleTxt");
         sortTitleTxt.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.sortTitletxt");
         var NametitleTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NametitleTxt");
         NametitleTxt.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.nameTitletxt");
         var NumbertitleTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NumbertitleTxt");
         NumbertitleTxt.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.numberTitletxt");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         this._Vline = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.Vline");
         addChild(this._bg);
         addChild(sortTitleTxt);
         addChild(NametitleTxt);
         addChild(NumbertitleTxt);
         addChild(this._panel);
         addChild(this._Vline);
         this._itemList = new Vector.<BadLuckItem>();
         for(var i:int = 0; i < 10; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("card.BadLuckItem",[i]);
            this._list.addChild(item);
            this._itemList.push(item);
         }
         this._panel.invalidateViewport();
         this._dataList = new Vector.<Object>();
         this._timer = new Timer(30 * 60 * 1000,-1);
         this._timer.start();
         this.requestData();
      }
      
      private function initEvents() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function removeEvents() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function __oneTimer(e:TimerEvent) : void
      {
         this.requestData();
      }
      
      private function requestData() : void
      {
         SocketManager.Instance.out.sendQequestBadLuck(true);
      }
      
      private function __getBadLuckHandler(e:CaddyEvent) : void
      {
         this._dataList = e.dataList;
         this.updateData();
      }
      
      private function updateData() : void
      {
         var obj:Object = null;
         var i:int = 0;
         while(i < 10 && i < this._dataList.length)
         {
            obj = this._dataList[i];
            this._itemList[i].update(i,obj["Nickname"],obj["Count"]);
            i++;
         }
      }
      
      public function dispose() : void
      {
         var item:BadLuckItem = null;
         this.removeEvents();
         for each(item in this._itemList)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._dataList = null;
         this._itemList = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this._Vline))
         {
            ObjectUtils.disposeObject(this._Vline);
         }
         this._Vline = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

