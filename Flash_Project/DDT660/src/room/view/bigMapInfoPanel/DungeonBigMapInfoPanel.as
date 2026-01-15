package room.view.bigMapInfoPanel
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.view.chooseMap.DungeonChooseMapFrame;
   import trainer.data.Step;
   
   public class DungeonBigMapInfoPanel extends MissionRoomBigMapInfoPanel
   {
      
      private var _chooseBtn:SimpleBitmapButton;
      
      public function DungeonBigMapInfoPanel()
      {
         super();
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._chooseBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._chooseBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._chooseBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         _info.addEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.addEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.isOpenBoss || RoomManager.Instance.current.isFarmBoss)
         {
            this._chooseBtn.visible = false;
            return;
         }
         var mapChooser:DungeonChooseMapFrame = new DungeonChooseMapFrame();
         mapChooser.show();
         dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_2))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_GUIDE_2);
         }
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         if(_info.mapId != 0 && _info.mapId != 10000)
         {
            this._chooseBtn.alpha = 0;
         }
         else
         {
            if(RoomManager.Instance.current.isOpenBoss)
            {
               this._chooseBtn.visible = false;
               return;
            }
            this._chooseBtn.alpha = 1;
         }
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         if(RoomManager.Instance.current.isOpenBoss)
         {
            this._chooseBtn.visible = false;
            return;
         }
         this._chooseBtn.alpha = 1;
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._chooseBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._chooseBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._chooseBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         _info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.removeEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      override protected function initView() : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.bigMapinfo.bg");
         addChild(_bg);
         _mapShowContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.bigMapIconContainer");
         addChild(_mapShowContainer);
         this._chooseBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.selectDungeonButton");
         this._chooseBtn.mouseChildren = true;
         this._chooseBtn.mouseEnabled = true;
         this._chooseBtn.visible = false;
         addChild(this._chooseBtn);
         _pos1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos1");
         _pos2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dropListPos2");
         _dropList = new DropList();
         _dropList.x = _pos1.x;
         _dropList.y = _pos1.y;
         addChild(_dropList);
         _dropList.visible = true;
         _info = RoomManager.Instance.current;
         if(Boolean(_info))
         {
            _info.addEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
            _info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,__updateHard);
            this.updateMap();
         }
         if(_ticketView == null)
         {
            _ticketView = ComponentFactory.Instance.creatCustomObject("asset.warriorsArena.ticketView");
            _ticketView.visible = RoomManager.Instance.IsLastMisstion;
            addChild(_ticketView);
         }
         if(Boolean(_info))
         {
            updateDropList();
         }
         MainToolBar.Instance.backFunction = this.leaveAlert;
      }
      
      private function leaveAlert() : void
      {
         if((RoomManager.Instance.current.isOpenBoss || RoomManager.Instance.current.mapId == 12016) && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.showAlert();
         }
         else
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      private function showAlert() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         alert = null;
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      private function __onGameStarted(evt:RoomEvent) : void
      {
         this._chooseBtn.enable = !_info.started;
      }
      
      override protected function __onMapChanged(evt:RoomEvent) : void
      {
         super.__onMapChanged(evt);
         if(_info.mapId == 12016 || _info.mapId == 70002)
         {
            this._chooseBtn.visible = false;
         }
         if(_info.mapId != 0 && _info.mapId != 10000)
         {
            this._chooseBtn.alpha = 0;
         }
         else
         {
            this._chooseBtn.alpha = 1;
         }
      }
      
      private function __playerStateChange(evt:RoomEvent) : void
      {
         if(RoomManager.Instance.current.isOpenBoss || RoomManager.Instance.current.mapId == 12016 || RoomManager.Instance.current.mapId == 70002)
         {
            this._chooseBtn.visible = false;
         }
         else
         {
            this._chooseBtn.visible = _info.selfRoomPlayer.isHost;
         }
      }
      
      private function __openBossChange(evt:RoomEvent) : void
      {
         this.updateMap();
         updateDropList();
      }
      
      override protected function updateMap() : void
      {
         super.updateMap();
         if(Boolean(_info.selfRoomPlayer) && _info.mapId != 12016)
         {
            this._chooseBtn.visible = _info.selfRoomPlayer.isHost;
         }
      }
      
      override protected function solvePath() : String
      {
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(Boolean(_info) && _info.mapId > 0)
         {
            if(_info.isOpenBoss)
            {
               if(Boolean(_info.pic) && _info.pic.length > 0)
               {
                  result += _info.mapId + "/" + _info.pic;
               }
            }
            else
            {
               result += _info.mapId + "/show1.jpg";
            }
         }
         else
         {
            result += "10000/show1.jpg";
         }
         return result;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._chooseBtn.dispose();
         this._chooseBtn = null;
         MainToolBar.Instance.backFunction = null;
      }
   }
}

