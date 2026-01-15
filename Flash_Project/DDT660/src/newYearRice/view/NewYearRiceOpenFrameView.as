package newYearRice.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import invite.InviteFrame;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class NewYearRiceOpenFrameView extends Frame
   {
      
      private var _main:MovieClip;
      
      private var _openBtn:BaseButton;
      
      private var _inviteBtn:BaseButton;
      
      private var _playerItems:Vector.<PlayerCell>;
      
      private var _startInvite:Boolean = false;
      
      private var _inviteFrame:InviteFrame;
      
      private var _bg:Bitmap;
      
      private var _playerID:int;
      
      private var _isRoomPlayer:Boolean;
      
      private var _nameID:int;
      
      private var _alert1:BaseAlerFrame;
      
      private var _roomPlayerID:int;
      
      public function NewYearRiceOpenFrameView()
      {
         super();
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         var cell:PlayerCell = null;
         InviteManager.Instance.enabled = false;
         if(RoomManager.Instance.current != null)
         {
            RoomManager.Instance.current = null;
         }
         BossBoxManager.instance.deleteBoxButton();
         NewYearRiceManager.instance.model.openFrameView = this;
         this._main = ClassUtils.CreatInstance("asset.newYearRice.view") as MovieClip;
         this._main.gotoAndStop(2);
         PositionUtils.setPos(this._main,"asset.newYearRice.view.pos");
         addToContent(this._main);
         this._openBtn = ComponentFactory.Instance.creat("NewYearRiceOpenFrameView.openBtn");
         addToContent(this._openBtn);
         this._inviteBtn = ComponentFactory.Instance.creat("NewYearRiceOpenFrameView.inviteBtn");
         addToContent(this._inviteBtn);
         this._playerItems = new Vector.<PlayerCell>();
         for(var i:int = 0; i < 6; i++)
         {
            cell = ComponentFactory.Instance.creatCustomObject("NewYearRiceOpenFrameView.playerCell." + i);
            cell.mouseEnabled = true;
            addToContent(cell);
            cell.addEventListener(MouseEvent.CLICK,this.__cellClick);
            this._playerItems.push(cell);
         }
      }
      
      private function __cellClick(e:MouseEvent) : void
      {
         var cell:PlayerCell = e.currentTarget as PlayerCell;
         if(cell.info != null && cell.info.ID != this._roomPlayerID && this._roomPlayerID > 0)
         {
            this._nameID = cell.info.ID;
            this._alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("NewYearRiceOpenFrameView.view.QuitPlayer",cell.nikeName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            this._alert1.addEventListener(FrameEvent.RESPONSE,this.__quitPlayer);
         }
      }
      
      private function __quitPlayer(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__quitPlayer);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendQuitNewYearRiceRoom(this._nameID);
         }
      }
      
      public function roomPlayerItem(id:int) : void
      {
         this._roomPlayerID = id;
         this._playerItems[0].setNickName(id,"right");
      }
      
      public function updatePlayerItem(players:Array) : void
      {
         for(var i:int = 0; i < players.length; i++)
         {
            this._playerItems[i].removePlayerCell();
            if(this._playerItems[i].info == null)
            {
               this._playerItems[i].setNickName(players[i].ID,i <= 2 ? "right" : "left",players[i].Style,players[i].NikeName,players[i].Sex);
            }
         }
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openBtnHandler);
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__inviteBtnHandler);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.EXITYEARFOODROOM,this.__exitYearFoodRoom);
         NewYearRiceManager.instance.addEventListener(NewYearRiceManager.UPDATEVIEW,this.__updateView);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCREATEFOOD,this.__quitYearFoodRoom);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openBtnHandler);
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__inviteBtnHandler);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.EXITYEARFOODROOM,this.__exitYearFoodRoom);
         NewYearRiceManager.instance.removeEventListener(NewYearRiceManager.UPDATEVIEW,this.__updateView);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCREATEFOOD,this.__quitYearFoodRoom);
      }
      
      private function __quitYearFoodRoom(event:CrazyTankSocketEvent) : void
      {
         this.dispose();
      }
      
      private function __updateView(e:Event) : void
      {
         var playerArr:Array = NewYearRiceManager.instance.model.playersArray;
         for(var i:int = 1; i < playerArr.length; i++)
         {
            this._playerItems[i].removePlayerCell();
            if(this._playerItems[i].info == null)
            {
               this._playerItems[i].setNickName(playerArr[i].ID,i <= 2 ? "right" : "left",playerArr[i].Style,playerArr[i].NikeName,playerArr[i].Sex);
            }
         }
      }
      
      public function setBtnEnter() : void
      {
         this._openBtn.enable = this._openBtn.mouseChildren = this._openBtn.mouseEnabled = false;
         this._inviteBtn.enable = this._inviteBtn.mouseChildren = this._inviteBtn.mouseEnabled = false;
      }
      
      private function __exitYearFoodRoom(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var pkg:PackageIn = event.pkg;
         this._isRoomPlayer = pkg.readBoolean();
         this._playerID = pkg.readInt();
         if(this._isRoomPlayer)
         {
            if(Boolean(this._inviteFrame))
            {
               this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
               ObjectUtils.disposeObject(this._inviteFrame);
               this._inviteFrame = null;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("NewYearRiceOpenFrameView.RoomPlayer.Exit"));
            this.dispose();
         }
         else if(Boolean(this._playerItems) && this._playerItems.length > 1)
         {
            for(i = 1; i < this._playerItems.length; i++)
            {
               if(this._playerItems[i].playerID == this._playerID)
               {
                  this._playerItems[i].removePlayerCell();
               }
            }
         }
      }
      
      public function setViewFrame(index:int) : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(index == 1)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.DinnerBG");
         }
         else if(index == 2)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.BanquetBG");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.HanBG");
         }
         this._bg.x = 64;
         this._bg.y = -45;
         addToContent(this._bg);
      }
      
      private function __openBtnHandler(evt:MouseEvent) : void
      {
         this._startInvite = false;
         NewYearRiceManager.instance.model.yearFoodInfo = 0;
         SocketManager.Instance.out.sendNewYearRiceOpen(NewYearRiceManager.instance.model.playerNum);
      }
      
      private function __inviteBtnHandler(evt:MouseEvent) : void
      {
         if(this._inviteFrame != null)
         {
            SoundManager.instance.play("008");
            this.__onInviteComplete(null);
         }
         else
         {
            this.startInvite();
         }
      }
      
      protected function startInvite() : void
      {
         if(!this._startInvite && this._inviteFrame == null)
         {
            this._startInvite = true;
            this.loadInviteRes();
         }
      }
      
      private function loadInviteRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTINVITE);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onInviteResComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDTINVITE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
            if(this._startInvite && this._inviteFrame == null)
            {
               this._inviteFrame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame");
               LayerManager.Instance.addToLayer(this._inviteFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               this._inviteFrame.addEventListener(Event.COMPLETE,this.__onInviteComplete);
               this._startInvite = false;
            }
         }
      }
      
      private function __onInviteComplete(evt:Event) : void
      {
         this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
         ObjectUtils.disposeObject(this._inviteFrame);
         this._inviteFrame = null;
      }
      
      private function __onInviteResError(evt:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendExitYearFoodRoom();
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         InviteManager.Instance.enabled = true;
         NewYearRiceManager.instance.model.openFrameView = null;
         NewYearRiceManager.instance.model.playerNum = 0;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._alert1))
         {
            ObjectUtils.disposeObject(this._alert1);
            this._alert1 = null;
         }
         if(Boolean(this._inviteFrame))
         {
            ObjectUtils.disposeObject(this._inviteFrame);
            this._inviteFrame = null;
         }
      }
   }
}

