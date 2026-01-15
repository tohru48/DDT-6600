package magicStone.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class MagicStoneTempAnalyer extends DataAnalyzer
   {
      
      private var _mgStoneTempArr:Array;
      
      public function MagicStoneTempAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var vo:MgStoneTempVO = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this._mgStoneTempArr = [];
            xmllist = xml..Item;
            for(i = 0; i <= xmllist.length() - 1; i++)
            {
               vo = new MgStoneTempVO();
               ObjectUtils.copyPorpertiesByXML(vo,xmllist[i]);
               this._mgStoneTempArr.push(vo);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get mgStoneTempArr() : Array
      {
         return this._mgStoneTempArr;
      }
   }
}

