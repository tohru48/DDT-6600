package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.BadgeInfo;
   import flash.utils.Dictionary;
   
   public class BadgeInfoAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function BadgeInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var info:BadgeInfo = null;
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml..item;
         var len:int = int(xmllist.length());
         for(var i:int = 0; i < len; i++)
         {
            info = new BadgeInfo();
            ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
            this.list[info.BadgeID] = info;
         }
         onAnalyzeComplete();
      }
   }
}

