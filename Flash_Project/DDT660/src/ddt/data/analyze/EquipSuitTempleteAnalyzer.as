package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class EquipSuitTempleteAnalyzer extends DataAnalyzer
   {
      
      private var _dic:Dictionary;
      
      private var _data:Dictionary;
      
      public function EquipSuitTempleteAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var ecInfo:XML = null;
         var i:int = 0;
         var info:EquipSuitTemplateInfo = null;
         var arr:Array = null;
         this._dic = new Dictionary();
         this._data = new Dictionary();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            ecInfo = describeType(new SuitTemplateInfo());
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new EquipSuitTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               if(Boolean(this._dic[info.ID]))
               {
                  arr = this._dic[info.ID];
               }
               else
               {
                  arr = [];
                  this._dic[info.ID] = arr;
               }
               arr.push(info);
               this._data[info.PartName] = info;
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
      
      public function get dic() : Dictionary
      {
         return this._dic;
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
   }
}

