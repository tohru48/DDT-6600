package godsRoads.model
{
   import flash.events.EventDispatcher;
   import godsRoads.data.GodsRoadsMissionInfo;
   import godsRoads.data.GodsRoadsVo;
   
   public class GodsRoadsModel extends EventDispatcher
   {
      
      private var vo:GodsRoadsVo;
      
      private var _questionTemple:Vector.<GodsRoadsMissionInfo>;
      
      public function GodsRoadsModel()
      {
         super();
      }
      
      public function getMissionInfoById(id:int) : GodsRoadsMissionInfo
      {
         var info:GodsRoadsMissionInfo = null;
         for(var i:int = 0; i < this._questionTemple.length; i++)
         {
            if(id == this._questionTemple[i].questId)
            {
               info = this._questionTemple[i];
               break;
            }
         }
         return info;
      }
      
      public function set godsRoadsData(val:GodsRoadsVo) : void
      {
         this.vo = val;
      }
      
      public function get godsRoadsData() : GodsRoadsVo
      {
         return this.vo;
      }
      
      public function set missionInfo(val:Vector.<GodsRoadsMissionInfo>) : void
      {
         this._questionTemple = val;
      }
      
      public function get missionInfo() : Vector.<GodsRoadsMissionInfo>
      {
         return this._questionTemple;
      }
   }
}

