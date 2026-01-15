package enchant
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import enchant.data.EnchantInfo;
   
   public class EnchantInfoAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<EnchantInfo> = new Vector.<EnchantInfo>();
      
      public function EnchantInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var enchantInfo:EnchantInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml.Item;
         for each(item in items)
         {
            enchantInfo = new EnchantInfo();
            ObjectUtils.copyPorpertiesByXML(enchantInfo,item);
            this.list.push(enchantInfo);
         }
         onAnalyzeComplete();
      }
   }
}

