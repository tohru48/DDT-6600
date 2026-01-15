package godsRoads.data
{
   public class GodsRoadsStepVo
   {
      
      public var isGetAwards:Boolean;
      
      public var missionsNum:int;
      
      public var missionVos:Array = [];
      
      public var awadsNum:int;
      
      public var awards:Array = [];
      
      public var currentStep:int = 0;
      
      public function GodsRoadsStepVo()
      {
         super();
      }
      
      public function getFinishPerNum() : int
      {
         var vo:GodsRoadsMissionVo = null;
         var per:int = 0;
         var tmp:int = 0;
         for(var i:int = 0; i < this.missionVos.length; i++)
         {
            vo = this.missionVos[i] as GodsRoadsMissionVo;
            if(vo.isFinished)
            {
               tmp++;
            }
         }
         return int(tmp / this.missionVos.length * 100);
      }
      
      public function getFinishPerString() : String
      {
         var vo:GodsRoadsMissionVo = null;
         var per:String = "";
         var tmp:int = 0;
         for(var i:int = 0; i < this.missionVos.length; i++)
         {
            vo = this.missionVos[i] as GodsRoadsMissionVo;
            if(vo.isFinished)
            {
               tmp++;
            }
         }
         return tmp + "/" + this.missionVos.length;
      }
   }
}

