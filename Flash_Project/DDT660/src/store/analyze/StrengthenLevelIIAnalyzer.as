package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.store.StrengthenLevelII;
   import flash.utils.Dictionary;
   
   public class StrengthenLevelIIAnalyzer extends DataAnalyzer
   {
      
      public var LevelItems1:Dictionary;
      
      public var LevelItems2:Dictionary;
      
      public var LevelItems3:Dictionary;
      
      public var LevelItems4:Dictionary;
      
      public var SucceedRate:int;
      
      private var _xml:XML;
      
      public function StrengthenLevelIIAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var info:StrengthenLevelII = null;
         this._xml = new XML(data);
         this.LevelItems1 = new Dictionary(true);
         this.LevelItems2 = new Dictionary(true);
         this.LevelItems3 = new Dictionary(true);
         this.LevelItems4 = new Dictionary(true);
         var xmllist:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new StrengthenLevelII();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.SucceedRate = info.DamagePlusRate;
               this.LevelItems1[info.StrengthenLevel] = info.Rock;
               this.LevelItems2[info.StrengthenLevel] = info.Rock1;
               this.LevelItems3[info.StrengthenLevel] = info.Rock2;
               this.LevelItems4[info.StrengthenLevel] = info.Rock3;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

