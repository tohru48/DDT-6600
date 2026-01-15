package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AvatarCollectionRightView extends Sprite implements Disposeable
   {
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _itemListView:AvatarCollectionItemListView;
      
      private var _propertyView:AvatarCollectionPropertyView;
      
      private var _moneyView:AvatarCollectionMoneyView;
      
      private var _timeView:AvatarCollectionTimeView;
      
      public function AvatarCollectionRightView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemListView = new AvatarCollectionItemListView();
         addChild(this._itemListView);
         this._moneyView = new AvatarCollectionMoneyView();
         addChild(this._moneyView);
         this._timeView = new AvatarCollectionTimeView();
         addChild(this._timeView);
         this._propertyView = new AvatarCollectionPropertyView();
         addChild(this._propertyView);
      }
      
      public function refreshView(data:AvatarCollectionUnitVo) : void
      {
         this._itemListView.refreshView(Boolean(data) ? data.totalItemList : null);
         this._propertyView.refreshView(data);
         this._timeView.refreshView(data);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._data = null;
         this._itemListView = null;
         this._propertyView = null;
         this._moneyView = null;
         this._timeView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

