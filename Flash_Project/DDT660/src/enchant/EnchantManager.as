package enchant
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import enchant.data.EnchantInfo;
   import enchant.data.EnchantModel;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class EnchantManager extends EventDispatcher
   {
      
      private static var _instance:EnchantManager;
      
      public var infoVec:Vector.<EnchantInfo>;
      
      public var model:EnchantModel;
      
      public var isUpGrade:Boolean;
      
      public var soulStoneId:int = 11166;
      
      public var soulStoneGoodsId:int = 1116601;
      
      public function EnchantManager(target:IEventDispatcher = null)
      {
         super(target);
         this.setUp();
      }
      
      public static function get instance() : EnchantManager
      {
         if(!_instance)
         {
            _instance = new EnchantManager();
         }
         return _instance;
      }
      
      public function setupInfoList(analyzer:EnchantInfoAnalyzer) : void
      {
         this.infoVec = analyzer.list;
      }
      
      private function setUp() : void
      {
         this.model = new EnchantModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_ENCHANT,this.__updateHandler);
      }
      
      public function getEnchantInfoByLevel(level:int) : EnchantInfo
      {
         var info:EnchantInfo = null;
         for each(info in this.infoVec)
         {
            if(info.Lv == level)
            {
               return info;
            }
         }
         return new EnchantInfo();
      }
      
      protected function __updateHandler(event:CrazyTankSocketEvent) : void
      {
         var exp:int = event.pkg.readInt();
         this.isUpGrade = event.pkg.readBoolean();
         if(this.isUpGrade)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.succes.txt"));
         }
      }
   }
}

class SingleClass
{
   
   public function SingleClass()
   {
      super();
   }
}
