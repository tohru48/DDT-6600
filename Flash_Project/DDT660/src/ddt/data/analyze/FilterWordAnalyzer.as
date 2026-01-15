package ddt.data.analyze
{
   import com.hurlant.util.Base64;
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.manager.LanguageMgr;
   
   public class FilterWordAnalyzer extends DataAnalyzer
   {
      
      public var words:Array = [];
      
      public var serverWords:Array = [];
      
      public var unableChar:String;
      
      public function FilterWordAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var tmp:String = null;
         var arr:Array = null;
         var exc:RegExp = null;
         var str:String = Base64.decode(String(data));
         str = str.toLocaleLowerCase();
         var NoFilterWords:Array = LanguageMgr.GetTranslation("zangNoFilterWords").split(",");
         for each(tmp in NoFilterWords)
         {
            exc = new RegExp(tmp,"g");
            str = str.replace(exc,"");
         }
         arr = str.toLocaleLowerCase().split("\n");
         if(Boolean(arr))
         {
            if(Boolean(arr[0]))
            {
               this.unableChar = arr[0];
            }
            if(Boolean(arr[1]))
            {
               this.words = arr[1].split("|");
            }
            if(Boolean(arr[2]))
            {
               this.serverWords = arr[2].split("|");
            }
         }
         onAnalyzeComplete();
      }
   }
}

