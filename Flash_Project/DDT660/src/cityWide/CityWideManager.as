package cityWide
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.utils.setInterval;
   import im.IMEvent;
   
   public class CityWideManager
   {
      
      private static var _instance:CityWideManager;
      
      private var _cityWideView:CityWideFrame;
      
      private var _playerInfo:PlayerInfo;
      
      private var _canOpenCityWide:Boolean = true;
      
      private const TIMES:int = 300000;
      
      public function CityWideManager()
      {
         super();
      }
      
      public static function get Instance() : CityWideManager
      {
         if(_instance == null)
         {
            _instance = new CityWideManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         PlayerManager.Instance.addEventListener(CityWideEvent.ONS_PLAYERINFO,this._updateCityWide);
      }
      
      private function _updateCityWide(evt:CityWideEvent) : void
      {
         this._canOpenCityWide = true;
         if(this._canOpenCityWide)
         {
            this._playerInfo = evt.playerInfo;
            this.showView(this._playerInfo);
            this._canOpenCityWide = false;
            setInterval(this.changeBoolean,this.TIMES);
         }
      }
      
      public function toSendOpenCityWide() : void
      {
         SocketManager.Instance.out.sendOns();
      }
      
      private function changeBoolean() : void
      {
         this._canOpenCityWide = true;
      }
      
      public function showView(playerInfo:PlayerInfo) : void
      {
         if(PlayerManager.Instance.Self.Grade < 11)
         {
            return;
         }
         this._cityWideView = ComponentFactory.Instance.creatComponentByStylename("CityWideFrame");
         this._cityWideView.playerInfo = playerInfo;
         this._cityWideView.addEventListener("submit",this._submitExit);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this._cityWideView));
         }
         else
         {
            this._cityWideView.show();
         }
      }
      
      private function _submitExit(e:Event) : void
      {
         var _baseAlerFrame:BaseAlerFrame = null;
         this._cityWideView = null;
         var len:int = 0;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            len = PlayerManager.Instance.Self.VIPLevel + 2;
         }
         if(PlayerManager.Instance.friendList.length >= 200 + len * 50)
         {
            _baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend",200 + len * 50),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this._close);
            return;
         }
         SocketManager.Instance.out.sendAddFriend(this._playerInfo.NickName,0,false,true);
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this._addAlert);
      }
      
      private function _close(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var aler:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         if(Boolean(aler))
         {
            aler.removeEventListener(FrameEvent.RESPONSE,this._close);
            aler.dispose();
            aler = null;
         }
      }
      
      private function _addAlert(e:IMEvent) : void
      {
         PlayerManager.Instance.removeEventListener(IMEvent.ADDNEW_FRIEND,this._addAlert);
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(""),LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete"),LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.privatename"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.info.enableHtml = true;
         var str:String = LanguageMgr.GetTranslation("cityWideFrame.ONSAlertInfo");
         str = str.replace(/r/g,this._playerInfo.NickName);
         alert.info.data = str;
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(e:FrameEvent) : void
      {
         var num:int = e.responseCode;
         SoundManager.instance.play("008");
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(e.currentTarget);
         switch(num)
         {
            case FrameEvent.CANCEL_CLICK:
               ChatManager.Instance.privateChatTo(this._playerInfo.NickName,this._playerInfo.ID);
               ChatManager.Instance.setFocus();
         }
      }
   }
}

