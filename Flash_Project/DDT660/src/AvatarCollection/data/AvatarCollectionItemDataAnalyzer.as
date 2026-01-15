package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionItemDataAnalyzer extends DataAnalyzer
   {
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollectionItemVo>;
      
      public function AvatarCollectionItemDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:AvatarCollectionItemVo = null;
         var tmpId:int = 0;
         var xml:XML = new XML(data);
         this._maleItemDic = new DictionaryData();
         this._femaleItemDic = new DictionaryData();
         this._maleItemList = new Vector.<AvatarCollectionItemVo>();
         this._femaleItemList = new Vector.<AvatarCollectionItemVo>();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new AvatarCollectionItemVo();
               tmpVo.id = xmllist[i].@ID;
               tmpVo.itemId = xmllist[i].@TemplateID;
               tmpVo.proArea = xmllist[i].@Description;
               tmpVo.needGold = xmllist[i].@Cost;
               tmpVo.sex = xmllist[i].@Sex;
               tmpId = tmpVo.id;
               if(tmpVo.sex == 1)
               {
                  if(!this._maleItemDic[tmpId])
                  {
                     this._maleItemDic[tmpId] = new DictionaryData();
                  }
                  this._maleItemDic[tmpId].add(tmpVo.itemId,tmpVo);
                  this._maleItemList.push(tmpVo);
               }
               else
               {
                  if(!this._femaleItemDic[tmpId])
                  {
                     this._femaleItemDic[tmpId] = new DictionaryData();
                  }
                  this._femaleItemDic[tmpId].add(tmpVo.itemId,tmpVo);
                  this._femaleItemList.push(tmpVo);
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      public function get maleItemDic() : DictionaryData
      {
         return this._maleItemDic;
      }
      
      public function get femaleItemDic() : DictionaryData
      {
         return this._femaleItemDic;
      }
      
      public function get maleItemList() : Vector.<AvatarCollectionItemVo>
      {
         return this._maleItemList;
      }
      
      public function get femaleItemList() : Vector.<AvatarCollectionItemVo>
      {
         return this._femaleItemList;
      }
   }
}

