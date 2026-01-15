package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import flash.events.MouseEvent;
   import microenddownload.MicroendDownloadAwardsManager;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   
   public class LandersAwardManager
   {
      
      public static var LANDERS_AWARD_4399:Boolean;
      
      public static var LANDERS_AWARD_OFFICIAL:Boolean;
      
      private static var _instance:LandersAwardManager;
      
      private var _landersBtn:SimpleBitmapButton;
      
      private var _getFlag:Boolean = true;
      
      private var _hBox:HBox;
      
      public function LandersAwardManager()
      {
         super();
      }
      
      public static function get instance() : LandersAwardManager
      {
         if(!_instance)
         {
            _instance = new LandersAwardManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(RingStationEvent.LANDERSAWARD_RECEIVE,this.__onIsReceiveAward);
      }
      
      protected function __onIsReceiveAward(event:RingStationEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._getFlag = pkg.readBoolean();
         if(!this._getFlag)
         {
            this.showIcon();
         }
         else
         {
            this.disposeEntryBtn();
         }
      }
      
      private function showIcon() : void
      {
         if(Boolean(this._hBox))
         {
            this.createEntryBtn(this._hBox);
         }
      }
      
      public function createEntryBtn(hBox:HBox) : void
      {
         this._hBox = hBox;
         if((LANDERS_AWARD_4399 || LANDERS_AWARD_OFFICIAL) && !this._getFlag)
         {
            if(!this._landersBtn)
            {
               this._landersBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.landersAward");
               this._landersBtn.tipData = LanguageMgr.GetTranslation("ddt.hallStateView.landerAward");
               this._landersBtn.addEventListener(MouseEvent.CLICK,this.__onGetAward);
               this._hBox.addChild(this._landersBtn);
            }
         }
      }
      
      protected function __onGetAward(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(DesktopManager.Instance.landersAwardFlag || DesktopManager.Instance.isDesktop)
         {
            SocketManager.Instance.out.receiveLandersAward();
         }
         else
         {
            MicroendDownloadAwardsManager.getInstance().loadUIModule();
         }
      }
      
      public function disposeEntryBtn() : void
      {
         if(Boolean(this._landersBtn))
         {
            this._landersBtn.removeEventListener(MouseEvent.CLICK,this.__onGetAward);
            this._landersBtn.dispose();
            this._landersBtn = null;
         }
      }
   }
}

