package hall.hallInfo
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.buff.BuffControl;
   import ddt.view.buff.BuffControlManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import hall.event.NewHallEvent;
   import hall.hallInfo.playerInfo.HallServerDropList;
   import hall.hallInfo.playerInfo.PlayerFighterPower;
   import hall.hallInfo.playerInfo.PlayerHead;
   import hall.hallInfo.playerInfo.PlayerTool;
   import hall.hallInfo.playerInfo.PlayerVIP;
   import playerDress.data.PlayerDressEvent;
   import serverlist.view.ServerDropList;
   
   public class HallPlayerInfoView extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _head:PlayerHead;
      
      private var _fighterPower:PlayerFighterPower;
      
      private var _vip:PlayerVIP;
      
      private var _buff:BuffControl;
      
      private var _toolBtn:PlayerTool;
      
      private var _serverlist:ServerDropList;
      
      public function HallPlayerInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.hall.playerInfoBg");
         addChild(this._bg);
         this._head = new PlayerHead();
         PositionUtils.setPos(this._head,"hall.playerInfoview.headPos");
         addChild(this._head);
         this._fighterPower = new PlayerFighterPower();
         PositionUtils.setPos(this._fighterPower,"hall.playerInfoview.bloodPos");
         addChild(this._fighterPower);
         this._vip = new PlayerVIP();
         PositionUtils.setPos(this._vip,"hall.playerInfoview.vipPos");
         addChild(this._vip);
         this._buff = BuffControlManager.instance.buff;
         PositionUtils.setPos(this._buff,"hall.playerInfo.buffPos");
         addChild(this._buff);
         this._toolBtn = new PlayerTool();
         PositionUtils.setPos(this._toolBtn,"hall.playerInfoview.toolPos");
         addChild(this._toolBtn);
         this._serverlist = new HallServerDropList();
         PositionUtils.setPos(this._serverlist,"hall.playerInfoview.serverlistPos");
         addChild(this._serverlist);
      }
      
      public function __updatePlayerInfo(event:PlayerDressEvent) : void
      {
         this._head.loadHead();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(PlayerDressEvent.UPDATE_PLAYERINFO,this.__updatePlayerInfo);
         SocketManager.Instance.addEventListener(NewHallEvent.SHOWBUFFCONTROL,this.__showBuffControl);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["FightPower"]))
         {
            this._fighterPower.update();
         }
      }
      
      protected function __showBuffControl(event:Event) : void
      {
         if(Boolean(this._buff))
         {
            PositionUtils.setPos(this._buff,"hall.playerInfo.buffPos");
            addChild(this._buff);
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(PlayerDressEvent.UPDATE_PLAYERINFO,this.__updatePlayerInfo);
         SocketManager.Instance.removeEventListener(NewHallEvent.SHOWBUFFCONTROL,this.__showBuffControl);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._fighterPower))
         {
            this._fighterPower.dispose();
            this._fighterPower = null;
         }
         if(Boolean(this._buff))
         {
            this._buff.dispose();
            this._buff = null;
            BuffControlManager.instance.buff = null;
         }
         if(Boolean(this._vip))
         {
            this._vip.dispose();
            this._vip = null;
         }
         if(Boolean(this._toolBtn))
         {
            this._toolBtn.dispose();
            this._toolBtn = null;
         }
         if(Boolean(this._head))
         {
            this._head.dispose();
            this._head = null;
         }
         ObjectUtils.disposeObject(this._serverlist);
         this._serverlist = null;
         ObjectUtils.disposeObject(this._serverlist);
         this._serverlist = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get toolBtn() : PlayerTool
      {
         return this._toolBtn;
      }
   }
}

