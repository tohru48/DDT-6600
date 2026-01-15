package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.analyze.EquipSuitTempleteAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.SuitTempleteAnalyzer;
   import ddt.data.goods.CateCoryInfo;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.SuitTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   [Event(name="templateReady",type="flash.events.Event")]
   public class ItemManager extends EventDispatcher
   {
      
      private static var _instance:ItemManager;
      
      private var _categorys:Vector.<CateCoryInfo>;
      
      private var _goodsTemplates:DictionaryData;
      
      private var _SuitTemplates:Dictionary;
      
      private var _EquipTemplates:Dictionary;
      
      private var _info:EquipSuitTemplateInfo = new EquipSuitTemplateInfo();
      
      private var _EquipSuit:Dictionary;
      
      private var _playerinfo:PlayerInfo;
      
      private var _storeCateCory:Array;
      
      public function ItemManager()
      {
         super();
      }
      
      public static function fill(item:InventoryItemInfo) : InventoryItemInfo
      {
         var t:ItemTemplateInfo = ItemManager.Instance.getTemplateById(item.TemplateID);
         ObjectUtils.copyProperties(item,t);
         return item;
      }
      
      public static function firFill(item:InventoryItemInfo) : InventoryItemInfo
      {
         var t:ItemTemplateInfo = ItemManager.Instance.getTemplateById(item.TemplateID);
         ObjectUtils.copyProperties(t,item);
         return item;
      }
      
      public static function get Instance() : ItemManager
      {
         if(_instance == null)
         {
            _instance = new ItemManager();
         }
         return _instance;
      }
      
      public function setupGoodsTemplates(analyzer:ItemTempleteAnalyzer) : void
      {
         this._goodsTemplates = analyzer.list;
      }
      
      public function setupGoodsCategory(analyzer:GoodCategoryAnalyzer) : void
      {
         this._categorys = analyzer.list;
      }
      
      public function addGoodsTemplates(analyzer:ItemTempleteAnalyzer) : void
      {
         var obj:ItemTemplateInfo = null;
         for each(obj in analyzer.list)
         {
            if(!this._goodsTemplates.hasKey(obj.TemplateID))
            {
               this._goodsTemplates.add(obj.TemplateID,obj);
            }
            else
            {
               this._goodsTemplates[obj.TemplateID] = obj;
            }
         }
      }
      
      public function setupSuitTemplates(analyzer:SuitTempleteAnalyzer) : void
      {
         this._SuitTemplates = analyzer.list;
      }
      
      public function setupEquipSuitTemplates(analyzer:EquipSuitTempleteAnalyzer) : void
      {
         this._EquipSuit = analyzer.dic;
         this._EquipTemplates = analyzer.data;
      }
      
      public function get EquipSuit() : Dictionary
      {
         return this._EquipSuit;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerinfo;
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         this._playerinfo = value;
      }
      
      public function getSuitTemplateByID(key:String) : SuitTemplateInfo
      {
         return this._SuitTemplates[key];
      }
      
      public function getEquipSuitbyContainEquip(name:String) : EquipSuitTemplateInfo
      {
         return this._EquipTemplates[name];
      }
      
      public function getTemplateById(templateId:int) : ItemTemplateInfo
      {
         return this._goodsTemplates[templateId];
      }
      
      public function get categorys() : Vector.<CateCoryInfo>
      {
         return this._categorys.slice(0);
      }
      
      public function get storeCateCory() : Array
      {
         return this._storeCateCory;
      }
      
      public function set storeCateCory(value:Array) : void
      {
         this._storeCateCory = value;
      }
      
      public function get goodsTemplates() : DictionaryData
      {
         return this._goodsTemplates;
      }
      
      public function getFreeTemplateByCategoryId(categoryid:int, sex:int = 0) : ItemTemplateInfo
      {
         if(categoryid != EquipType.ARM)
         {
            return this.getTemplateById(Number(String(categoryid) + String(sex) + "01"));
         }
         return this.getTemplateById(Number(String(categoryid) + "00" + String(sex)));
      }
      
      public function getPropByTypeAndPro() : Array
      {
         var info:ItemTemplateInfo = null;
         var result:Array = new Array();
         for each(info in this._goodsTemplates)
         {
            if(info.CategoryID == 10 && info.Property8 == "1")
            {
               result.push(info);
            }
         }
         return result;
      }
      
      public function searchGoodsNameByStr(str:String) : Array
      {
         var info:ItemTemplateInfo = null;
         var i:int = 0;
         var result:Array = new Array();
         for each(info in this._goodsTemplates)
         {
            if(info.Name.indexOf(str) > -1)
            {
               if(result.length == 0)
               {
                  result.push(info.Name);
               }
               else
               {
                  for(i = 0; i < result.length; i++)
                  {
                     if(result[i] == info.Name)
                     {
                        break;
                     }
                     if(i == result.length - 1)
                     {
                        result.push(info.Name);
                     }
                  }
               }
            }
         }
         return result;
      }
   }
}

