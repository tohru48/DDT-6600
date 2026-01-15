package serverlist.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerInfo;
   import ddt.loader.LoaderCreate;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import trainer.controller.SystemOpenPromptManager;
   
   public class ServerDropList extends Frame
   {
      
      protected var _expanded:Boolean;
      
      protected var _bg:Bitmap;
      
      private var _loader:BaseLoader;
      
      protected var _cb:ComboBox;
      
      private var _isClick:Boolean;
      
      public function ServerDropList()
      {
         super();
         this._expanded = false;
         this.initView();
         this.initEvent();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.serverlist.hallBG");
         this._cb = ComponentFactory.Instance.creat("serverlist.hall.DropListCombo");
         addChild(this._cb);
      }
      
      protected function initEvent() : void
      {
         this._cb.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClicked);
         this._cb.addEventListener(MouseEvent.CLICK,this.__onClicked);
      }
      
      private function __onClicked(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._isClick = true;
         this.updateList();
      }
      
      protected function __onStageClicked(e:MouseEvent) : void
      {
         this.hideList();
         this._expanded = false;
      }
      
      private function __onListClicked(e:ListItemEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ServerManager.Instance.refreshFlag = true;
         SystemOpenPromptManager.instance.isShowNewEuipTip = false;
         var _info:ServerInfo = this.getServerByName(e.cellValue);
         if(ServerManager.Instance.connentServer(_info) == false)
         {
            this.refresh();
         }
         else
         {
            this._cb.mouseChildren = false;
         }
      }
      
      private function updateServerList() : void
      {
         var info:ServerInfo = null;
         this._cb.beginChanges();
         var comboxModel:VectorListModel = this._cb.listPanel.vectorListModel;
         comboxModel.clear();
         for each(info in this.getServerList())
         {
            comboxModel.append(info.Name);
         }
         this._cb.commitChanges();
         if(this._isClick)
         {
            this._cb.doShow();
            this._isClick = false;
         }
      }
      
      protected function getServerList() : Vector.<ServerInfo>
      {
         var info:ServerInfo = null;
         var list:Vector.<ServerInfo> = ServerManager.Instance.list;
         var result:Vector.<ServerInfo> = new Vector.<ServerInfo>();
         for each(info in list)
         {
            if(info.Name != ServerManager.Instance.current.Name)
            {
               if(info.State != ServerInfo.MAINTAIN)
               {
                  result.push(info);
               }
            }
         }
         return result;
      }
      
      public function hideList() : void
      {
      }
      
      private function getServerByName(serverName:String) : ServerInfo
      {
         var info:ServerInfo = null;
         var list:Vector.<ServerInfo> = ServerManager.Instance.list;
         for each(info in list)
         {
            if(info.Name == serverName)
            {
               return info;
            }
         }
         return null;
      }
      
      public function refresh() : void
      {
         this._cb.mouseChildren = true;
         this.updateList();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      public function updateList() : void
      {
         this._loader = LoaderCreate.Instance.creatServerListLoader();
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      public function __onListLoadComplete(e:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         this.updateServerList();
         this._cb.textField.text = ServerManager.Instance.current.Name;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onListLoadComplete);
         }
         this._loader = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(Boolean(this._cb))
         {
            this._cb.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClicked);
            this._cb.removeEventListener(MouseEvent.CLICK,this.__onClicked);
            this._cb.dispose();
         }
         this._cb = null;
         super.dispose();
      }
   }
}

