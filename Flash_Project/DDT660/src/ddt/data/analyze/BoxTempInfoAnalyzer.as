package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.BossBoxManager;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import microenddownload.MicroendDownloadAwardsManager;
   import road7th.data.DictionaryData;
   
   public class BoxTempInfoAnalyzer extends DataAnalyzer
   {
      
      public var inventoryItemList:DictionaryData;
      
      private var _boxTemplateID:Dictionary;
      
      public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
      
      public var caddyTempIDList:DictionaryData;
      
      public var beadTempInfoList:DictionaryData;
      
      public var exploitTemplateIDs:Dictionary;
      
      private var microendAwardsIDList:Array;
      
      public function BoxTempInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var info:BoxGoodsTempInfo = null;
         var i:int = 0;
         var boxTempID:String = null;
         var templateId:int = 0;
         var info1:BoxGoodsTempInfo = null;
         var info2:BoxGoodsTempInfo = null;
         var goodsArray:Array = null;
         this.microendAwardsIDList = new Array();
         var _start:uint = uint(getTimer());
         var xml:XML = new XML(data);
         var items:XMLList = xml..Item;
         this.inventoryItemList = new DictionaryData();
         this.caddyTempIDList = new DictionaryData();
         this.beadTempInfoList = new DictionaryData();
         this.caddyBoxGoodsInfo = new Vector.<BoxGoodsTempInfo>();
         this._boxTemplateID = BossBoxManager.instance.boxTemplateID;
         this.exploitTemplateIDs = BossBoxManager.instance.exploitTemplateIDs;
         this.initDictionaryData();
         if(xml.@value == "true")
         {
            for(i = 0; i < items.length(); i++)
            {
               boxTempID = items[i].@ID;
               templateId = int(items[i].@TemplateId);
               if(boxTempID == "112376")
               {
                  this.microendAwardsIDList.push({
                     "count":items[i].@ItemCount,
                     "id":int(items[i].@TemplateId)
                  });
               }
               if(int(boxTempID) == EquipType.CADDY || int(boxTempID) == EquipType.BOMB_KING_BLESS || int(boxTempID) == EquipType.SILVER_BLESS || int(boxTempID) == EquipType.GOLD_BLESS || int(boxTempID) == EquipType.TREASURE_CADDY)
               {
                  info1 = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(info1,items[i]);
                  this.caddyBoxGoodsInfo.push(info1);
                  this.caddyTempIDList.add(info1.TemplateId,info1);
               }
               else if(int(boxTempID) == EquipType.BEAD_ATTACK || int(boxTempID) == EquipType.BEAD_DEFENSE || int(boxTempID) == EquipType.BEAD_ATTRIBUTE)
               {
                  info2 = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(info2,items[i]);
                  this.beadTempInfoList[boxTempID].push(info2);
               }
               if(Boolean(this._boxTemplateID[boxTempID]))
               {
                  info = new BoxGoodsTempInfo();
                  goodsArray = new Array();
                  ObjectUtils.copyPorpertiesByXML(info,items[i]);
                  this.inventoryItemList[boxTempID].push(info);
               }
               if(Boolean(this.exploitTemplateIDs[boxTempID]))
               {
                  info = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(info,items[i]);
                  this.exploitTemplateIDs[boxTempID].push(info);
               }
            }
            MicroendDownloadAwardsManager.getInstance().setup(this.microendAwardsIDList);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function initDictionaryData() : void
      {
         var id:String = null;
         var goodsArray:Array = null;
         for each(id in this._boxTemplateID)
         {
            goodsArray = new Array();
            this.inventoryItemList.add(id,goodsArray);
         }
         this.beadTempInfoList.add(EquipType.BEAD_ATTACK,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_DEFENSE,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_ATTRIBUTE,new Vector.<BoxGoodsTempInfo>());
      }
   }
}

