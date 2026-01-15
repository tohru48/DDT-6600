package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class SuperWinnerPlayerListView extends Sprite implements Disposeable
   {
      
      private var _data:DictionaryData;
      
      private var _playerList:ListPanel;
      
      public function SuperWinnerPlayerListView(data:DictionaryData)
      {
         this._data = data;
         super();
         this.initbg();
         this.initView();
         this.initEvent();
      }
      
      private function initbg() : void
      {
         var bg:Image = ComponentFactory.Instance.creat("superWinner.playerList.bg");
         addChild(bg);
      }
      
      private function initView() : void
      {
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("asset.superWinner.PlayerList");
         this._playerList.vScrollbar.visible = false;
         addChild(this._playerList);
         this._playerList.list.updateListView();
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
      }
      
      private function __addPlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.insertElementAt(player,this.getInsertIndex(player));
      }
      
      private function __removePlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.remove(player);
      }
      
      private function __updatePlayer(event:DictionaryEvent) : void
      {
         var player:PlayerInfo = event.data as PlayerInfo;
         this._playerList.vectorListModel.remove(player);
         this._playerList.vectorListModel.insertElementAt(player,this.getInsertIndex(player));
         this._playerList.list.updateListView();
      }
      
      private function getInsertIndex(info:PlayerInfo) : int
      {
         var tempInfo:PlayerInfo = null;
         var tempIndex:int = 0;
         var tempArray:Array = this._playerList.vectorListModel.elements;
         if(tempArray.length == 0)
         {
            return 0;
         }
         for(var i:int = tempArray.length - 1; i >= 0; i--)
         {
            tempInfo = tempArray[i] as PlayerInfo;
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
      
      public function dispose() : void
      {
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

