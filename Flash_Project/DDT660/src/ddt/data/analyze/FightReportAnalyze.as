package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.Base64;
   import flash.utils.ByteArray;
   import road7th.comm.PackageIn;
   
   public class FightReportAnalyze extends DataAnalyzer
   {
      
      private var _pkgVec:Vector.<PackageIn> = new Vector.<PackageIn>();
      
      public function FightReportAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var byte:ByteArray = null;
         var pkg:PackageIn = null;
         var xml:XML = XML(data);
         var length:int = int(xml.Item.length());
         for(var i:int = 0; i < length; i++)
         {
            byte = Base64.decodeToByteArray(xml.Item[i].@Buffer);
            pkg = new PackageIn();
            pkg.loadFightByteInfo(xml.Item[i].@Parameter1,xml.Item[i].@Parameter2,xml.Item[i].@Length,byte,0);
            this._pkgVec.push(pkg);
         }
         onAnalyzeComplete();
      }
      
      public function get pkgVec() : Vector.<PackageIn>
      {
         return this._pkgVec;
      }
   }
}

