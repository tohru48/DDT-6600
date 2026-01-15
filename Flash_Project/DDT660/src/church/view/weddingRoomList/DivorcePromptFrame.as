package church.view.weddingRoomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import quest.QuestDescTextAnalyz;
   
   public class DivorcePromptFrame extends BaseAlerFrame
   {
      
      private static var _instance:DivorcePromptFrame;
      
      private var _alertInfo:AlertInfo;
      
      private var _infoText:FilterFrameText;
      
      public var isOpenDivorce:Boolean = false;
      
      public function DivorcePromptFrame()
      {
         super();
         this.initialize();
      }
      
      public static function get Instance() : DivorcePromptFrame
      {
         if(_instance == null)
         {
            _instance = ComponentFactory.Instance.creatComponentByStylename("DivorcePromptFrame");
         }
         return _instance;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("church.view.weddingRoomList.DivorcePromptFrame.yes"),LanguageMgr.GetTranslation("church.view.weddingRoomList.DivorcePromptFrame.no"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("DivorcePromptFrameText");
         var _str:String = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.frameInfo");
         _str = _str.replace(/XXXX/g,"<font COLOR=\'#FF0000\'>" + PlayerManager.Instance.Self.SpouseName + "</font>");
         _str = QuestDescTextAnalyz.start(_str);
         this._infoText.htmlText = _str;
         addToContent(this._infoText);
      }
      
      public function show() : void
      {
         if(PlayerManager.Instance.Self.SpouseName != null && PlayerManager.Instance.Self.SpouseName != "")
         {
            SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTimeA);
            SharedManager.Instance.divorceBoolean = false;
            SharedManager.Instance.save();
         }
      }
      
      private function __mateTimeA(e:CrazyTankSocketEvent) : void
      {
         var _date:Date = e.pkg.readDate();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTimeA);
         var dat:Date = TimeManager.Instance.Now();
         var gapHours:int = (dat.valueOf() - _date.valueOf()) / (60 * 60000);
         if(gapHours > 720)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function removeView() : void
      {
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.isOpenDivorce = true;
               this.dispose();
               StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(6);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._infoText))
         {
            ObjectUtils.disposeObject(this._infoText);
         }
         this._infoText = null;
         this.removeEvent();
         this.removeView();
      }
   }
}

