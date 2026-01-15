package collectionTask.model
{
   import collectionTask.vo.CollectionRobertVo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   
   public class CollectionTaskAnalyzer extends DataAnalyzer
   {
      
      private var _collectionTaskInfoList:Vector.<CollectionRobertVo>;
      
      public function CollectionTaskAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:CollectionRobertVo = null;
         var xml:XML = new XML(data);
         this._collectionTaskInfoList = new Vector.<CollectionRobertVo>();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new CollectionRobertVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               tmpVo.Style = "," + tmpVo.Glass + "|" + ItemManager.Instance.getTemplateById(tmpVo.Glass).Pic + "," + tmpVo.Hair + "|" + ItemManager.Instance.getTemplateById(tmpVo.Hair).Pic + "," + tmpVo.Eye + "|" + ItemManager.Instance.getTemplateById(tmpVo.Eye).Pic + "," + "," + tmpVo.Face + "|" + ItemManager.Instance.getTemplateById(tmpVo.Face).Pic + ",,,,,";
               this._collectionTaskInfoList.push(tmpVo);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get collectionTaskInfoList() : Vector.<CollectionRobertVo>
      {
         return this._collectionTaskInfoList;
      }
   }
}

