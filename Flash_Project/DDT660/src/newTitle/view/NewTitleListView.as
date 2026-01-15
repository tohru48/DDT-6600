package newTitle.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class NewTitleListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      public function NewTitleListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("newTitle.list");
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
      }
      
      protected function __onListItemClick(event:ListItemEvent) : void
      {
         NewTitleManager.instance.dispatchEvent(new NewTitleEvent(NewTitleEvent.TITLE_ITEM_CLICK,[event.index]));
      }
      
      public function updateOwnTitleList() : void
      {
         var titleArray:Array = EffortManager.Instance.getHonorArray();
         this._list.vectorListModel.clear();
         for(var i:int = 0; i < titleArray.length; i++)
         {
            this._list.vectorListModel.append(titleArray[i].Name,i);
         }
         this._list.list.updateListView();
         for(var j:int = 0; j < titleArray.length; j++)
         {
            if(PlayerManager.Instance.Self.honor == titleArray[j].Name)
            {
               this._list.setViewPosition(j);
               this._list.list.currentSelectedIndex = j;
               break;
            }
         }
      }
      
      public function updateAllTitleList() : void
      {
         this._list.vectorListModel.clear();
         var titleArray:Array = NewTitleManager.instance.titleArray;
         for(var i:int = 0; i < titleArray.length; i++)
         {
            this._list.vectorListModel.append(titleArray[i].Name,i);
         }
         this._list.list.updateListView();
         this._list.list.currentSelectedIndex = 0;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._list))
         {
            this._list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
            ObjectUtils.disposeObject(this._list);
            this._list = null;
         }
      }
   }
}

