package pyramid
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import pyramid.event.PyramidEvent;
   import pyramid.model.PyramidModel;
   import road7th.comm.PackageIn;
   
   public class PyramidManager extends EventDispatcher
   {
      
      private static var _instance:PyramidManager;
      
      private var _isShowIcon:Boolean = false;
      
      private var _model:PyramidModel;
      
      private var _movieLock:Boolean = false;
      
      private var _clickRate:Number = 0;
      
      public var isShowBuyFrameSelectedCheck:Boolean = true;
      
      public var isShowReviveBuyFrameSelectedCheck:Boolean = true;
      
      public var isShowAutoOpenFrameSelectedCheck:Boolean = true;
      
      private var _isAutoOpenCard:Boolean = false;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      private var _tipsType:int;
      
      private var _tipsData:Object;
      
      public var autoCount:int;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      public function PyramidManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : PyramidManager
      {
         if(_instance == null)
         {
            _instance = new PyramidManager();
         }
         return _instance;
      }
      
      public function set movieLock(value:Boolean) : void
      {
         this._movieLock = value;
         dispatchEvent(new PyramidEvent(PyramidEvent.MOVIE_LOCK));
      }
      
      public function get movieLock() : Boolean
      {
         return this._movieLock;
      }
      
      public function get isAutoOpenCard() : Boolean
      {
         return this._isAutoOpenCard;
      }
      
      public function set isAutoOpenCard(value:Boolean) : void
      {
         if(this._isAutoOpenCard != value)
         {
            this._isAutoOpenCard = value;
            dispatchEvent(new PyramidEvent(PyramidEvent.AUTO_OPENCARD));
            if(this._isAutoOpenCard)
            {
               this.isShowReviveBuyFrameSelectedCheck = false;
            }
            else
            {
               this.isShowReviveBuyFrameSelectedCheck = true;
            }
         }
      }
      
      public function get clickRateGo() : Boolean
      {
         var temp:Number = new Date().time;
         if(temp - this._clickRate > 500)
         {
            this._clickRate = temp;
            return false;
         }
         return true;
      }
      
      public function get model() : PyramidModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new PyramidModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PYRAMID_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case PyramidPackageType.PYRAMID_OPENORCLOSE:
               this.openOrclose(pkg);
               break;
            case PyramidPackageType.PYRAMID_ENTER:
               this.iconEnter(pkg);
               break;
            case PyramidPackageType.PYRAMID_STARTORSTOP:
               this.startOrstop(pkg);
               break;
            case PyramidPackageType.PYRAMID_RESULT:
               this.cardResult(pkg);
               break;
            case PyramidPackageType.PYRAMID_DIEEVENT:
               this.dieEvent(pkg);
               break;
            case PyramidPackageType.PYRAMID_SCORECONVERT:
               this.scoreConvert(pkg);
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         var revivePriceCount:int = 0;
         var i:int = 0;
         this.model.isOpen = pkg.readBoolean();
         this.model.isScoreExchange = pkg.readBoolean();
         if(this.model.isOpen)
         {
            this.model.beginTime = pkg.readDate();
            this.model.endTime = pkg.readDate();
            this.model.freeCount = pkg.readInt();
            this.model.turnCardPrice = pkg.readInt();
            this.model.revivePrice = [];
            revivePriceCount = pkg.readInt();
            for(i = 0; i < revivePriceCount; i++)
            {
               this.model.revivePrice.push(pkg.readInt());
            }
         }
         if(this.model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            if(StateManager.currentStateType == StateType.PYRAMID)
            {
               StateManager.setState(StateType.MAIN);
            }
         }
         this.clearFrame();
      }
      
      private function iconEnter(pkg:PackageIn) : void
      {
         var layer:int = 0;
         var i:int = 0;
         var tempLayer:int = 0;
         var count:int = 0;
         var j:int = 0;
         var templateID:int = 0;
         var position:int = 0;
         this.model.isUp = false;
         this.model.currentLayer = pkg.readInt();
         this.model.maxLayer = pkg.readInt();
         this.model.totalPoint = pkg.readInt();
         this.model.turnPoint = pkg.readInt();
         this.model.pointRatio = pkg.readInt();
         this.model.currentFreeCount = pkg.readInt();
         this.model.currentReviveCount = pkg.readInt();
         this.model.isPyramidStart = pkg.readBoolean();
         if(this.model.isPyramidStart)
         {
            layer = pkg.readInt();
            this.model.selectLayerItems = new Dictionary();
            for(i = 1; i <= layer; i++)
            {
               tempLayer = pkg.readInt();
               this.model.selectLayerItems[tempLayer] = new Dictionary();
               count = pkg.readInt();
               for(j = 0; j < count; j++)
               {
                  templateID = pkg.readInt();
                  position = pkg.readInt();
                  this.model.selectLayerItems[tempLayer][position] = templateID;
               }
            }
         }
         if(StateManager.currentStateType != StateType.PYRAMID)
         {
            StateManager.setState(StateType.PYRAMID);
         }
      }
      
      private function startOrstop(pkg:PackageIn) : void
      {
         this.model.isPyramidStart = pkg.readBoolean();
         if(!this.model.isPyramidStart)
         {
            this.model.totalPoint = pkg.readInt();
            this.model.turnPoint = pkg.readInt();
            this.model.pointRatio = pkg.readInt();
            this.model.currentLayer = pkg.readInt();
            this.model.currentReviveCount = 0;
         }
         this.model.selectLayerItems = new Dictionary();
         this.model.dataChange(PyramidEvent.START_OR_STOP);
         this.clearFrame();
         if(this.autoCount > 0 && this.model.isPyramidStart == false && this.isAutoOpenCard)
         {
            GameInSocketOut.sendPyramidStartOrstop(true);
            return;
         }
         if(!this.model.isPyramidStart)
         {
            this.isAutoOpenCard = false;
         }
      }
      
      private function cardResult(pkg:PackageIn) : void
      {
         this.model.templateID = pkg.readInt();
         this.model.position = pkg.readInt();
         this.model.isPyramidDie = pkg.readBoolean();
         this.model.isUp = pkg.readBoolean();
         this.model.currentLayer = pkg.readInt();
         this.model.maxLayer = pkg.readInt();
         this.model.totalPoint = pkg.readInt();
         this.model.turnPoint = pkg.readInt();
         this.model.pointRatio = pkg.readInt();
         this.model.currentFreeCount = pkg.readInt();
         var tempLayer:int = this.model.currentLayer;
         if(this.model.isUp)
         {
            tempLayer--;
         }
         var dic:Dictionary = this.model.selectLayerItems[tempLayer];
         if(!dic)
         {
            dic = new Dictionary();
         }
         dic[this.model.position] = this.model.templateID;
         this.model.selectLayerItems[tempLayer] = dic;
         this.model.dataChange(PyramidEvent.CARD_RESULT);
      }
      
      private function dieEvent(pkg:PackageIn) : void
      {
         this.model.isPyramidStart = pkg.readBoolean();
         this.model.currentLayer = pkg.readInt();
         this.model.totalPoint = pkg.readInt();
         this.model.turnPoint = pkg.readInt();
         this.model.pointRatio = pkg.readInt();
         this.model.currentReviveCount = pkg.readInt();
         this.model.dataChange(PyramidEvent.DIE_EVENT);
         this.clearFrame();
      }
      
      private function scoreConvert(pkg:PackageIn) : void
      {
         this.model.totalPoint = pkg.readInt();
         this.model.dataChange(PyramidEvent.SCORE_CONVERT);
      }
      
      public function showEnterIcon() : void
      {
         this._isShowIcon = true;
         if(PlayerManager.Instance.Self.Grade >= 13)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.PYRAMID,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.PYRAMID,true,13);
         }
      }
      
      public function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.PYRAMID,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.PYRAMID,false);
      }
      
      public function onClickPyramidIcon(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendRequestEnterPyramidSystem();
         if(StateManager.currentStateType != StateType.PYRAMID)
         {
            StateManager.setState(StateType.PYRAMID);
         }
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this.model.items = dataList;
      }
      
      public function showFrame(_type:int, dataObj:Object = null) : void
      {
         var revieMoney:int = 0;
         var _cardFrameReviveCount:FilterFrameText = null;
         var tipText:FilterFrameText = null;
         this._tipsType = _type;
         switch(this._tipsType)
         {
            case 1:
               revieMoney = int(this.model.revivePrice[this.model.currentReviveCount]);
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveTitle"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveContent",revieMoney),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               _cardFrameReviveCount = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.cardFrameReviveCount");
               _cardFrameReviveCount.text = LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveCount",this.model.revivePrice.length - this.model.currentReviveCount,this.model.revivePrice.length);
               this._tipsframe.addToContent(_cardFrameReviveCount);
               break;
            case 2:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveEndContent"),"","",true,false,false,2);
               break;
            case 3:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.stopMsg"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               break;
            case 4:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.scoreConvertMsg"),"","",true,false,false,2);
               break;
            case 5:
               this._tipsData = dataObj;
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.turnCardMoneyMsg",this.model.turnCardPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("pyramid.buyFrameSelectedCheckButton");
               this._selectedCheckButton.text = LanguageMgr.GetTranslation("ddt.pyramid.buyFrameSelectedCheckButtonTextMsg");
               this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
               this._tipsframe.addToContent(this._selectedCheckButton);
               break;
            case 6:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.endScoreConvertTime"),"","",true,false,false,2);
               break;
            case 7:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveEndContent2"),"","",true,false,false,2);
               break;
            case 8:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.autoOpenCardFrameMsg"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               this._tipsframe.height = 250;
               this._text = ComponentFactory.Instance.creatComponentByStylename("pyramid.autoCountSelectFrame.Text");
               this._text.text = LanguageMgr.GetTranslation("ddt.pyramid.autoOpenCount.text");
               this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
               this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
               PositionUtils.setPos(this._numberSelecter,"pyramid.view.autoCountPos");
               tipText = ComponentFactory.Instance.creatComponentByStylename("pyramid.TipTxt");
               tipText.text = LanguageMgr.GetTranslation("pyramid.tipText.content");
               this._tipsframe.addToContent(this._numberSelecter);
               this._tipsframe.addToContent(this._text);
               this._tipsframe.addToContent(tipText);
               this._numberSelecter.valueLimit = "1,50";
         }
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.tipsDispose();
         switch(this._tipsType)
         {
            case -1:
               break;
            case 1:
               if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidRevive(true);
               }
               else
               {
                  GameInSocketOut.sendPyramidRevive(false);
               }
               break;
            case 2:
               GameInSocketOut.sendPyramidRevive(false);
               break;
            case 3:
               if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidStartOrstop(false);
               }
               break;
            case 4:
               break;
            case 5:
               if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidTurnCard(this._tipsData[0],this._tipsData[1]);
               }
               this._tipsData = null;
               break;
            case 6:
               break;
            case 7:
               GameInSocketOut.sendPyramidRevive(false);
               break;
            case 8:
               if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  this.isShowBuyFrameSelectedCheck = false;
                  this.isAutoOpenCard = true;
                  if(Boolean(this._numberSelecter))
                  {
                     this.autoCount = this._numberSelecter.currentValue;
                  }
               }
         }
      }
      
      private function __onselectedCheckButtoClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.isShowBuyFrameSelectedCheck = !this._selectedCheckButton.selected;
      }
      
      private function tipsDispose() : void
      {
         if(Boolean(this._selectedCheckButton))
         {
            this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
            ObjectUtils.disposeObject(this._selectedCheckButton);
            this._selectedCheckButton = null;
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      public function clearFrame() : void
      {
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.dispatchEvent(new FrameEvent(-1));
         }
      }
   }
}

