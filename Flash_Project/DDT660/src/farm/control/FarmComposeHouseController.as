package farm.control
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.view.compose.model.ComposeHouseModel;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import pet.date.PetTemplateInfo;
   
   public class FarmComposeHouseController extends EventDispatcher
   {
      
      private static var _instance:FarmComposeHouseController;
      
      public var composeHouseModel:ComposeHouseModel;
      
      public function FarmComposeHouseController(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function instance() : FarmComposeHouseController
      {
         if(!_instance)
         {
            _instance = new FarmComposeHouseController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.composeHouseModel = new ComposeHouseModel();
      }
      
      public function getResultPages(count:int = 10) : int
      {
         var list:Vector.<InventoryItemInfo> = this.getAllItems();
         var totlaPage:int = Math.ceil(list.length / count);
         totlaPage = totlaPage == 0 ? 1 : totlaPage;
         return 1;
      }
      
      public function getAllItems() : Vector.<InventoryItemInfo>
      {
         var item:InventoryItemInfo = null;
         var result:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         for each(item in this.composeHouseModel.items)
         {
            result.push(item);
         }
         return result;
      }
      
      public function getItemsByPage(page:int, count:int = 10) : Vector.<InventoryItemInfo>
      {
         var startIndex:int = 0;
         var len:int = 0;
         var i:int = 0;
         var result:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var list:Vector.<InventoryItemInfo> = this.getAllItems();
         var totlaPage:int = Math.ceil(list.length / count);
         if(page > 0 && page <= totlaPage)
         {
            startIndex = 0 + count * (page - 1);
            len = Math.min(list.length - startIndex,count);
            for(i = 0; i < len; i++)
            {
               result.push(list[startIndex + i]);
            }
         }
         return result;
      }
      
      public function setupFoodComposeList(analyzer:FoodComposeListAnalyzer) : void
      {
         this.composeHouseModel.foodComposeList = analyzer.list;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            if(event.loader.analyzer.message != null)
            {
               msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
            }
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"),"",false,false,false,0,null,"farmSimpleAlert");
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      public function getComposeDetailByID(foodID:int) : Vector.<FoodComposeListTemplateInfo>
      {
         return this.composeHouseModel.foodComposeList[foodID];
      }
      
      public function getNextUpdatePetTimes() : String
      {
         var now:Date = TimeManager.Instance.Now();
         var remainHour:Number = 24 - now.getHours();
         var remainMin:Number = 0;
         if(now.getMinutes() > 0)
         {
            remainHour--;
            remainMin = 60 - now.getMinutes();
         }
         return String(remainHour) + LanguageMgr.GetTranslation("hour") + String(remainMin) + LanguageMgr.GetTranslation("minute") + LanguageMgr.GetTranslation("ddt.farms.refreshPetsLastTimes");
      }
      
      public function isFourStarPet(pets:Array) : Boolean
      {
         var petInfo:PetTemplateInfo = null;
         var resultBool:Boolean = false;
         for each(petInfo in pets)
         {
            if(petInfo.StarLevel == 4)
            {
               resultBool = true;
               break;
            }
         }
         return resultBool;
      }
      
      public function refreshVolume() : String
      {
         return String(PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(PetconfigAnalyzer.PetCofnig.FreeRefereshID));
      }
   }
}

