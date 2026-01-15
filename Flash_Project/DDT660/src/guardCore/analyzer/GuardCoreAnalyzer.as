package guardCore.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import guardCore.data.GuardCoreInfo;
   
   public class GuardCoreAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Vector.<GuardCoreInfo>;
      
      public function GuardCoreAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:GuardCoreInfo = null;
         var _loc2_:XML = new XML(param1);
         this._list = new Vector.<GuardCoreInfo>();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc6_ = new GuardCoreInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               this._list.push(_loc6_);
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : Vector.<GuardCoreInfo>
      {
         return this._list;
      }
   }
}
