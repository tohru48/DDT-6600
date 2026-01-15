package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import store.forge.wishBead.WishChangeInfo;
   
   public class WishInfoAnalyzer extends DataAnalyzer
   {
      
      public var _wishChangeInfo:Vector.<WishChangeInfo>;
      
      public function WishInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var info:WishChangeInfo = null;
         var xml:XML = new XML(data);
         var items:XMLList = xml..item;
         this._wishChangeInfo = new Vector.<WishChangeInfo>();
         if(xml.@value == "true")
         {
            for(i = 0; i < items.length(); i++)
            {
               info = new WishChangeInfo();
               ObjectUtils.copyPorpertiesByXML(info,items[i]);
               this._wishChangeInfo.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

