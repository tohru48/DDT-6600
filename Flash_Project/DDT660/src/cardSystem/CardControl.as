package cardSystem
{
   import cardSystem.analyze.CardPropIncreaseRuleAnalyzer;
   import cardSystem.analyze.SetsPropertiesAnalyzer;
   import cardSystem.analyze.SetsSortRuleAnalyzer;
   import cardSystem.analyze.UpgradeRuleAnalyzer;
   import cardSystem.data.CardInfo;
   import cardSystem.model.CardModel;
   import cardSystem.view.PropResetFrame;
   import cardSystem.view.UpGradeFrame;
   import cardSystem.view.cardCollect.CardCollectView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import flash.events.EventDispatcher;
   
   public class CardControl extends EventDispatcher
   {
      
      private static var _instance:CardControl;
      
      private static var _firstShow:Boolean = true;
      
      private var _model:CardModel;
      
      public var signLockedCard:int;
      
      public function CardControl()
      {
         super();
         this._model = new CardModel();
      }
      
      public static function get Instance() : CardControl
      {
         if(_instance == null)
         {
            _instance = new CardControl();
         }
         return _instance;
      }
      
      public function setSignLockedCardNone() : void
      {
         this.signLockedCard = -1;
      }
      
      public function get model() : CardModel
      {
         return this._model;
      }
      
      public function showUpGradeFrame(cardInfo:CardInfo) : void
      {
         var upGrade:UpGradeFrame = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame");
         upGrade.cardInfo = cardInfo;
         LayerManager.Instance.addToLayer(upGrade,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showPropResetFrame(cardInfo:CardInfo) : void
      {
         var propReset:PropResetFrame = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame");
         propReset.show(cardInfo);
      }
      
      public function showCollectView() : void
      {
         var collectView:CardCollectView = ComponentFactory.Instance.creatComponentByStylename("CardCollectView");
         LayerManager.Instance.addToLayer(collectView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function initSetsProperties(analyzer:SetsPropertiesAnalyzer) : void
      {
         this._model.setsList = analyzer.setsList;
      }
      
      public function initSetsSortRule(analyzer:SetsSortRuleAnalyzer) : void
      {
         this._model.setsSortRuleVector = analyzer.setsVector;
      }
      
      public function initSetsUpgradeRule(analyzer:UpgradeRuleAnalyzer) : void
      {
         this._model.upgradeRuleVec = analyzer.upgradeRuleVec;
      }
      
      public function initPropIncreaseRule(analyzer:CardPropIncreaseRuleAnalyzer) : void
      {
         this._model.propIncreaseDic = analyzer.propIncreaseDic;
      }
   }
}

