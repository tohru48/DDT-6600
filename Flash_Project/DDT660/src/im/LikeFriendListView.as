package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.LikeFriendAnalyzer;
   import ddt.data.player.LikeFriendInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Sprite;
   import flash.net.URLVariables;
   
   public class LikeFriendListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      private var _likeFriendList:Array;
      
      private var _currentItem:LikeFriendInfo;
      
      private var _pos:int;
      
      public function LikeFriendListView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("IM.LikeFriendListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         if(IMController.Instance.likeFriendList != null)
         {
            this._likeFriendList = IMController.Instance.likeFriendList;
            this.__updateList();
         }
         this.creatItemTempleteLoader();
      }
      
      private function initEvents() : void
      {
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      private function removeEvents() : void
      {
         this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      private function creatItemTempleteLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["selfid"] = PlayerManager.Instance.Self.ID;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SameCityIMLoad.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLikeFriendTemplateFailure");
         loader.analyzer = new LikeFriendAnalyzer(this.__loadComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
         return loader;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            if(event.loader.analyzer.message != null)
            {
               msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
            }
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(e:FrameEvent) : void
      {
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      private function __loadComplete(action:LikeFriendAnalyzer) : void
      {
         this._likeFriendList = IMController.Instance.likeFriendList = action.likeFriendList;
         this.__updateList();
      }
      
      private function __itemClick(e:ListItemEvent) : void
      {
         if(!this._currentItem)
         {
            this._currentItem = e.cellValue as LikeFriendInfo;
            this._currentItem.isSelected = true;
         }
         else if(this._currentItem != e.cellValue as LikeFriendInfo)
         {
            this._currentItem.isSelected = false;
            this._currentItem = e.cellValue as LikeFriendInfo;
            this._currentItem.isSelected = true;
         }
         this._list.list.updateListView();
      }
      
      private function __updateList() : void
      {
         if(this._list == null)
         {
            return;
         }
         this._pos = this._list.list.viewPosition.y;
         this.update();
         var intPoint:IntPoint = new IntPoint(0,this._pos);
         this._list.list.viewPosition = intPoint;
      }
      
      private function update() : void
      {
         var info:LikeFriendInfo = null;
         var tempArr:Array = [];
         var tempArr1:Array = [];
         for(var i:int = 0; i < this._likeFriendList.length; i++)
         {
            info = this._likeFriendList[i];
            if(info.IsVIP)
            {
               tempArr.push(info);
            }
            else
            {
               tempArr1.push(info);
            }
         }
         tempArr = tempArr.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         tempArr1 = tempArr1.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._likeFriendList = tempArr.concat(tempArr1);
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._likeFriendList);
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         this._likeFriendList = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

