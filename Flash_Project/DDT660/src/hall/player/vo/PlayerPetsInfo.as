package hall.player.vo
{
   import flash.utils.Dictionary;
   
   public class PlayerPetsInfo
   {
      
      private var _disDic:Dictionary;
      
      public function PlayerPetsInfo()
      {
         super();
         this._disDic = new Dictionary();
      }
      
      public function set distanceDic(value:String) : void
      {
         var disArr:Array = null;
         var dicArr:Array = value.split(",");
         for(var i:int = 0; i < dicArr.length; i++)
         {
            disArr = dicArr[i].split(":");
            this._disDic[disArr[0]] = disArr[1];
         }
      }
      
      public function get disDic() : Dictionary
      {
         return this._disDic;
      }
   }
}

