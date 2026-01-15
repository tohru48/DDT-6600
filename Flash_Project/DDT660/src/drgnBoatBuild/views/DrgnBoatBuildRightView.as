package drgnBoatBuild.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import drgnBoatBuild.DrgnBoatBuildManager;
   import drgnBoatBuild.components.DrgnBoatBuildListCell;
   import drgnBoatBuild.data.DrgnBoatBuildCellInfo;
   import drgnBoatBuild.data.DrgnBoatBuildEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class DrgnBoatBuildRightView extends Sprite implements Disposeable
   {
      
      private var _rightBg:Bitmap;
      
      private var _listPanel:ListPanel;
      
      public function DrgnBoatBuildRightView()
      {
         super();
         this.initView();
         this.initEvents();
         DrgnBoatBuildManager.instance.updateDrgnBoatFriendList();
      }
      
      private function initView() : void
      {
         this._rightBg = ComponentFactory.Instance.creat("drgnBoatBuild.rightViewBg");
         addChild(this._rightBg);
         this._listPanel = ComponentFactory.Instance.creat("drgnBoatBuild.listPanel");
         this._listPanel.vScrollProxy = ScrollPanel.ON;
         addChild(this._listPanel);
         this._listPanel.list.updateListView();
      }
      
      private function initEvents() : void
      {
         DrgnBoatBuildManager.instance.addEventListener(DrgnBoatBuildEvent.UPDATE_FRIEND_LIST,this.__updateFriendList);
      }
      
      protected function __updateFriendList(event:DrgnBoatBuildEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var stateInfo:DrgnBoatBuildCellInfo = null;
         var player:PlayerInfo = null;
         this._listPanel.vectorListModel.clear();
         for each(stateInfo in DrgnBoatBuildManager.instance.friendStateList)
         {
            player = stateInfo.playerinfo;
            if(Boolean(player))
            {
               this._listPanel.vectorListModel.insertElementAt(stateInfo,this.getInsertIndex(player));
            }
         }
         this._listPanel.list.updateListView();
      }
      
      private function getInsertIndex(info:PlayerInfo) : int
      {
         var tempInfo:PlayerInfo = null;
         var tempIndex:int = 0;
         var tempArray:Array = this._listPanel.vectorListModel.elements;
         if(tempArray.length == 0)
         {
            return 0;
         }
         for(var i:int = tempArray.length - 1; i >= 0; i--)
         {
            tempInfo = (tempArray[i] as DrgnBoatBuildCellInfo).playerinfo;
            if(!(info.IsVIP && !tempInfo.IsVIP))
            {
               if(!info.IsVIP && tempInfo.IsVIP)
               {
                  return i + 1;
               }
               if(info.IsVIP == tempInfo.IsVIP)
               {
                  if(info.Grade <= tempInfo.Grade)
                  {
                     return i + 1;
                  }
                  tempIndex = i - 1;
               }
            }
         }
         return tempIndex < 0 ? 0 : tempIndex;
      }
      
      private function removeEvents() : void
      {
         DrgnBoatBuildManager.instance.removeEventListener(DrgnBoatBuildEvent.UPDATE_FRIEND_LIST,this.__updateFriendList);
      }
      
      public function dispose() : void
      {
         var cell:DrgnBoatBuildListCell = null;
         this.removeEvents();
         DrgnBoatBuildManager.instance.selectedId = 0;
         for each(cell in this._listPanel.list.cell)
         {
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._listPanel.vectorListModel.clear();
         ObjectUtils.disposeObject(this._rightBg);
         this._rightBg = null;
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
      }
   }
}

