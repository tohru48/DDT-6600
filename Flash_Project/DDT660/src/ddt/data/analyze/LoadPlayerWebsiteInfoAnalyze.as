package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class LoadPlayerWebsiteInfoAnalyze extends DataAnalyzer
   {
      
      public var info:Dictionary = new Dictionary(true);
      
      public function LoadPlayerWebsiteInfoAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = new XML(data);
         if(Boolean(xml))
         {
            this.info["uid"] = xml.uid.toString();
            this.info["name"] = xml.name.toString();
            this.info["gender"] = xml.gender.toString();
            this.info["userName"] = xml.userName.toString();
            this.info["university"] = xml.university.toString();
            this.info["city"] = xml.city.toString();
            this.info["tinyHeadUrl"] = xml.tinyHeadUrl.toString();
            this.info["largeHeadUrl"] = xml.largeHeadUrl.toString();
            this.info["personWeb"] = xml.personWeb.toString();
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

