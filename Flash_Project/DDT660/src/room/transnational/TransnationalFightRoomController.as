package room.transnational
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class TransnationalFightRoomController extends BaseAlerFrame
   {
      
      private var _transtionalManager:TransnationalFightManager;
      
      private var _rightView:TransnationalRightView;
      
      private var _leftView:TransnationalLeftView;
      
      private var _isdispose:Boolean;
      
      public function TransnationalFightRoomController()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         titleText = LanguageMgr.GetTranslation("tank.menu.transnationalTiTle");
         this._rightView = new TransnationalRightView();
         this._leftView = new TransnationalLeftView();
         PositionUtils.setPos(this._leftView,"asset.ddtroom.transnationalLeftView");
         PositionUtils.setPos(this._rightView,"asset.ddtroom.transnationalrightView");
         addToContent(this._rightView);
         addToContent(this._leftView);
         this.addEvent();
      }
      
      public function playerStyle($style:String, $mainWeaID:int, $secWeaID:int, $petID:int, $lever:int) : void
      {
         if(Boolean(this._leftView))
         {
            this._leftView.updataplayer($style,$mainWeaID,$secWeaID,$petID,$lever);
         }
      }
      
      private function addEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
         this._rightView.addEventListener(TransnationalEvent.SHOPENABLE,this.__shopEnable);
      }
      
      private function __shopEnable(evt:TransnationalEvent) : void
      {
         this._leftView.setScoeresShopBtnEnable(evt._shopenable);
      }
      
      public function updataScores() : void
      {
         this._leftView.updata();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         var roomInfo:RoomInfo = null;
         if(RoomManager.Instance.isTransnationalFight())
         {
            roomInfo = RoomManager.Instance.current;
            if(GameManager.Instance.Current == null)
            {
               return;
            }
            TransnationalFightManager.Instance.hide();
            StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         }
      }
      
      private function removeEvent() : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      public function cancel() : void
      {
         this._rightView.__cancelClick(null);
      }
      
      public function get isdispose() : Boolean
      {
         return this._isdispose;
      }
      
      public function set isdispose(value:Boolean) : void
      {
         value = this._isdispose;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._rightView))
         {
            this._rightView.dispose();
            ObjectUtils.disposeObject(this._rightView);
            this._rightView = null;
         }
         if(Boolean(this._leftView))
         {
            this._leftView.dispose();
            ObjectUtils.disposeObject(this._leftView);
            this._leftView = null;
         }
         this._isdispose = true;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

