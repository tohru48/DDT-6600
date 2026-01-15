package ddt.view.caddyII
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CaddyAwardDataAnalyzer extends DataAnalyzer
   {
      
      public var _awards:Vector.<CaddyAwardInfo>;
      
      public var _silverAwards:Vector.<CaddyAwardInfo>;
      
      public var _goldAwards:Vector.<CaddyAwardInfo>;
      
      public var _treasureAwards:Vector.<CaddyAwardInfo>;
      
      public function CaddyAwardDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:CaddyAwardInfo = null;
         this._awards = new Vector.<CaddyAwardInfo>();
         this._silverAwards = new Vector.<CaddyAwardInfo>();
         this._goldAwards = new Vector.<CaddyAwardInfo>();
         this._treasureAwards = new Vector.<CaddyAwardInfo>();
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml.item;
         for(var i:int = 0; i < len; i++)
         {
            itemData = new CaddyAwardInfo();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            if(xmllist[i].@BoxType == 1)
            {
               this._awards.push(itemData);
            }
            else if(xmllist[i].@BoxType == 2)
            {
               this._silverAwards.push(itemData);
            }
            else if(xmllist[i].@BoxType == 3)
            {
               this._goldAwards.push(itemData);
            }
            else if(xmllist[i].@BoxType == 4)
            {
               this._treasureAwards.push(itemData);
            }
         }
         onAnalyzeComplete();
      }
   }
}

