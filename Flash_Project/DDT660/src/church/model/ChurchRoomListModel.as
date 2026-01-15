package church.model
{
   import ddt.data.ChurchRoomInfo;
   import road7th.data.DictionaryData;
   
   public class ChurchRoomListModel
   {
      
      private var _roomList:DictionaryData;
      
      public function ChurchRoomListModel()
      {
         super();
         this._roomList = new DictionaryData(true);
      }
      
      public function get roomList() : DictionaryData
      {
         return this._roomList;
      }
      
      public function addRoom(info:ChurchRoomInfo) : void
      {
         if(Boolean(info))
         {
            this._roomList.add(info.id,info);
         }
      }
      
      public function removeRoom(id:int) : void
      {
         if(Boolean(this._roomList[id]))
         {
            this._roomList.remove(id);
         }
      }
      
      public function updateRoom(info:ChurchRoomInfo) : void
      {
         if(Boolean(info))
         {
            this._roomList.add(info.id,info);
         }
      }
      
      public function dispose() : void
      {
         this._roomList = null;
      }
   }
}

