package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import road7th.utils.DateUtils;
   
   public class LoginSelectListAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<Role>;
      
      public var totalCount:int;
      
      public function LoginSelectListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:Role = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.list = new Vector.<Role>();
            this.totalCount = int(xml.@total);
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new Role();
               info.LastDate = DateUtils.decodeDated(xmllist[i].@LastDate);
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.list.push(info);
            }
            this.list.sort(this.sortLastDate);
            this.list.sort(this.sortLoginState);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      private function sortLastDate(a:Role, b:Role) : int
      {
         var result:int = 0;
         if(a.LastDate.time < b.LastDate.time)
         {
            result = 1;
         }
         else
         {
            result = -1;
         }
         return result;
      }
      
      private function sortLoginState(a:Role, b:Role) : int
      {
         if(a.LoginState == 1 && b.LoginState != 1)
         {
            return 1;
         }
         if(a.LoginState != -1 && b.LoginState == 1)
         {
            return -1;
         }
         return this.sortLastDate(a,b);
      }
   }
}

