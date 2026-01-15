package store.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import store.events.StoreIIEvent;
   
   public class ConsortiaRateManager extends EventDispatcher
   {
      
      public static var _instance:ConsortiaRateManager;
      
      public static const CHANGE_CONSORTIA:String = "loadComplete_consortia";
      
      private var _SmithLevel:int = 0;
      
      private var _data:String;
      
      private var _rate:int;
      
      private var _selfRich:int;
      
      private var _needRich:int = 100;
      
      public function ConsortiaRateManager()
      {
         super();
         this.initEvents();
      }
      
      public static function get instance() : ConsortiaRateManager
      {
         if(_instance == null)
         {
            _instance = new ConsortiaRateManager();
         }
         return _instance;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._propertyChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this._useConditionChange);
      }
      
      private function __resultConsortiaEquipContro(analyzer:ConsortionBuildingUseConditionAnalyer) : void
      {
         var $info:ConsortiaAssetLevelOffer = null;
         var len:int = int(analyzer.useConditionList.length);
         for(var i:int = 0; i < len; i++)
         {
            $info = analyzer.useConditionList[i];
            if($info.Type == 2)
            {
               this.setStripTipDataRichs($info.Riches);
            }
         }
      }
      
      private function __consortiaClubSearchResult(analyzer:ConsortionListAnalyzer) : void
      {
         var info:ConsortiaInfo = null;
         if(analyzer.consortionList.length > 0)
         {
            info = analyzer.consortionList[0];
            if(Boolean(info))
            {
               this._SmithLevel = info.SmithLevel;
            }
            this._rate = this._SmithLevel;
            this.setStripTipData();
         }
      }
      
      private function setStripTipData() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(this._SmithLevel <= 0)
            {
               this._loadComplete();
            }
            else
            {
               ConsortionModelControl.Instance.loadUseConditionList(this.__resultConsortiaEquipContro,PlayerManager.Instance.Self.ConsortiaID);
            }
         }
         else
         {
            this._loadComplete();
         }
      }
      
      private function setStripTipDataRichs(riches:int) : void
      {
         this._selfRich = PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob;
         if(this._selfRich < riches)
         {
            this._rate = 0;
         }
         this._needRich = riches;
         this._loadComplete();
      }
      
      private function __onLoadErrorII(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponseII);
      }
      
      private function __onAlertResponseII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponseII);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function _propertyChange(e:PlayerPropertyEvent) : void
      {
         if(Boolean(e.changedProperties["SmithLevel"]))
         {
            this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         }
         if(Boolean(e.changedProperties["RichesOffer"]) || Boolean(e.changedProperties["RichesRob"]))
         {
            this._selfRich = PlayerManager.Instance.Self.RichesOffer + PlayerManager.Instance.Self.RichesRob;
         }
         this._rate = this._SmithLevel;
         this._loadComplete();
      }
      
      private function _useConditionChange(e:ConsortionEvent) : void
      {
         var $info:ConsortiaAssetLevelOffer = null;
         var list:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            $info = list[i];
            if($info.Type == 2)
            {
               this.setStripTipDataRichs($info.Riches);
            }
         }
      }
      
      public function reset() : void
      {
         this._SmithLevel = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         this._selfRich = PlayerManager.Instance.Self.Riches;
         ConsortionModelControl.Instance.getConsortionList(this.__consortiaClubSearchResult,1,6,"",-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function get consortiaTipData() : String
      {
         this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel <= 0)
            {
               this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateIII");
            }
            else if(PlayerManager.Instance.Self.UseOffer < this._needRich)
            {
               this._rate = 0;
               this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateII",PlayerManager.Instance.Self.UseOffer,this._needRich);
            }
            else
            {
               this._data = LanguageMgr.GetTranslation("store.StoreIIComposeBG.consortiaRate_txt",PlayerManager.Instance.Self.consortiaInfo.SmithLevel * 10);
            }
         }
         else
         {
            this._rate = 0;
            this._data = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         return this._data;
      }
      
      public function get smithLevel() : int
      {
         return PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
      }
      
      public function get rate() : int
      {
         this._rate = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel > 0 && PlayerManager.Instance.Self.UseOffer < this._needRich)
            {
               this._rate = 0;
            }
         }
         else
         {
            this._rate = 0;
         }
         return this._rate;
      }
      
      public function getConsortiaStrengthenEx(level:int) : Number
      {
         if(level - 1 < 0)
         {
            return 0;
         }
         var arr:Array = ServerConfigManager.instance.ConsortiaStrengthenEx();
         if(Boolean(arr))
         {
            return arr[level - 1];
         }
         return 0;
      }
      
      private function _loadComplete() : void
      {
         dispatchEvent(new Event(CHANGE_CONSORTIA));
      }
      
      public function sendTransferShowLightEvent(value:ItemTemplateInfo, isShow:Boolean) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT,value,isShow));
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._propertyChange);
      }
   }
}

