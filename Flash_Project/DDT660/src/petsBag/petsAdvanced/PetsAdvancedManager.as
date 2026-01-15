package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.analyze.PetMoePropertyAnalyzer;
   import ddt.manager.LanguageMgr;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import petsBag.data.PetFightPropertyData;
   import petsBag.data.PetMoePropertyInfo;
   import petsBag.data.PetStarExpData;
   import petsBag.data.PetsFormData;
   
   public class PetsAdvancedManager extends EventDispatcher
   {
      
      private static var _instance:PetsAdvancedManager;
      
      public var currentViewType:int;
      
      public var risingStarDataList:Vector.<PetStarExpData>;
      
      public var evolutionDataList:Vector.<PetFightPropertyData>;
      
      public var formDataList:Vector.<PetsFormData>;
      
      public var isAllMovieComplete:Boolean = true;
      
      public var isPetsAdvancedViewShow:Boolean;
      
      public var frame:PetsAdvancedFrame;
      
      public var petMoePropertyList:Vector.<PetMoePropertyInfo>;
      
      public function PetsAdvancedManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : PetsAdvancedManager
      {
         if(_instance == null)
         {
            _instance = new PetsAdvancedManager();
         }
         return _instance;
      }
      
      public function risingStarDataComplete(analyzer:PetsRisingStarDataAnalyzer) : void
      {
         this.risingStarDataList = analyzer.list;
      }
      
      public function evolutionDataComplete(analyzer:PetsEvolutionDataAnalyzer) : void
      {
         this.evolutionDataList = analyzer.list;
      }
      
      public function formDataComplete(analyzer:PetsFormDataAnalyzer) : void
      {
         this.formDataList = analyzer.list;
      }
      
      public function moePropertyComplete(analyzer:PetMoePropertyAnalyzer) : void
      {
         this.petMoePropertyList = analyzer.list;
      }
      
      public function showPetsAdvancedFrame() : void
      {
         this.frame = ComponentFactory.Instance.creatCustomObject("petsBag.PetsAdvancedFrame");
         this.frame.titleText = LanguageMgr.GetTranslation("ddt.pets.advancedTxt");
         LayerManager.Instance.addToLayer(this.frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getFormDataIndexByTempId(id:int) : int
      {
         var index:int = -1;
         for(var i:int = 0; i < this.formDataList.length; i++)
         {
            if(id == this.formDataList[i].TemplateID)
            {
               index = i;
               break;
            }
         }
         return index;
      }
   }
}

