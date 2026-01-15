package bagAndInfo.bag.ring.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class RingDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _data:Dictionary;
      
      public function RingDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:RingSystemData = null;
         var _loc2_:XML = new XML(param1);
         this._data = new Dictionary();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            RingSystemData.TotalLevel = _loc3_.length();
            _loc4_ = 0;
            while(_loc4_ < RingSystemData.TotalLevel)
            {
               _loc5_ = new RingSystemData();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._data[_loc5_.Level] = _loc5_;
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
   }
}
