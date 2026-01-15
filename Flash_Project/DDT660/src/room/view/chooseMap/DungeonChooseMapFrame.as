package room.view.chooseMap
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.map.DungeonInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import kingBless.KingBlessManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class DungeonChooseMapFrame extends Sprite implements Disposeable
   {
      
      private var _frame:BaseAlerFrame;
      
      private var _view:DungeonChooseMapView;
      
      private var _selfInfo:SelfInfo;
      
      private var _alert:BaseAlerFrame;
      
      private var _voucherAlert:BaseAlerFrame;
      
      public function DungeonChooseMapFrame()
      {
         super();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtdungeonRoom.ChooseMap.Frame");
         addChild(this._frame);
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.showCancel = false;
         alertInfo.moveEnable = false;
         this._frame.info = alertInfo;
         this._view = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dungeonChooseMapView");
         this._frame.addToContent(this._view);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__responeHandler);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_3))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"guide.dungeon.step3ArrowPos","asset.trainer.dungeonGuide3Txt","guide.dungeon.step3TipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function __responeHandler(evt:FrameEvent) : void
      {
         var dungeon:DungeonInfo = null;
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
         else if(evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SoundManager.instance.play("008");
            if(this._view.checkState())
            {
               dungeon = MapManager.getDungeonInfo(this._view.selectedMapID);
               if(this._view.select)
               {
                  if(KingBlessManager.instance.getOneBuffData(KingBlessManager.DUNGEON_HERO) > 0)
                  {
                     if(PlayerManager.Instance.Self.bagLocked)
                     {
                        BaglockedManager.Instance.show();
                        return;
                     }
                     this.doOpenBossRoom();
                  }
                  else
                  {
                     this.showAlert();
                  }
               }
               else
               {
                  if(dungeon.Type == MapManager.PVE_ACADEMY_MAP)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACADEMY_DUNGEON_ROOM,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,0);
                  }
                  else if(dungeon.Type == MapManager.PVE_ACTIVITY_MAP)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACTIVITY_DUNGEON_ROOM,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,0);
                  }
                  else if(dungeon.Type == MapManager.PVE_SPECIAL_MAP)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.SPECIAL_ACTIVITY_DUNGEON,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,0);
                  }
                  else
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,false,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,0);
                  }
                  RoomManager.Instance.current.roomName = this._view.roomName;
                  RoomManager.Instance.current.roomPass = this._view.roomPass;
                  RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                  this.dispose();
                  if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_3))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_GUIDE_3);
                     NewHandContainer.Instance.clearArrowByID(ArrowType.DUNGEON_GUIDE);
                  }
                  if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_4))
                  {
                     NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,-45,"trainer.startGameArrowPos","asset.trainer.startGameTipAsset","trainer.startGameTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                  }
               }
            }
         }
      }
      
      private function getPrice() : String
      {
         var arr:Array = [];
         var price:String = "";
         var str:String = MapManager.getDungeonInfo(this._view.selectedMapID).BossFightNeedMoney;
         if(Boolean(str))
         {
            arr = str.split("|");
         }
         if(Boolean(arr) && arr.length > 0)
         {
            switch(this._view.selectedLevel)
            {
               case RoomInfo.EASY:
                  price = arr[0];
                  break;
               case RoomInfo.NORMAL:
                  price = arr[1];
                  break;
               case RoomInfo.HARD:
                  price = arr[2];
                  break;
               case RoomInfo.HERO:
                  price = arr[3];
                  break;
               case RoomInfo.EPIC:
                  price = arr[4];
            }
         }
         return price;
      }
      
      private function showAlert() : void
      {
         if(this._alert == null)
         {
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.openBossTip.text",this.getPrice()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      private function disposeAlert() : void
      {
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function __alertResponse(evt:FrameEvent) : void
      {
         var bagInfo:BagInfo = null;
         var conut:int = 0;
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._selfInfo = PlayerManager.Instance.Self;
               bagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
               conut = bagInfo.getItemCountByTemplateId(EquipType.BRAVERY);
               if(conut < Number(this.getPrice()))
               {
                  this.showVoucherAlert();
               }
               else
               {
                  this.doOpenBossRoom();
               }
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.disposeAlert();
         }
      }
      
      private function doOpenBossRoom() : void
      {
         GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,true,this._view.roomPass,this._view.roomName,1,this._view.selectedLevel,0,false,this._view.selectedMapID);
         RoomManager.Instance.current.roomName = this._view.roomName;
         RoomManager.Instance.current.roomPass = this._view.roomPass;
         RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
         this.dispose();
      }
      
      private function showVoucherAlert() : void
      {
         if(this._voucherAlert == null)
         {
            this._voucherAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("dungeonChooseMapGoods"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            this._voucherAlert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         }
      }
      
      private function disposeVoucherAlert() : void
      {
         this.disposeAlert();
         if(Boolean(this._voucherAlert))
         {
            this._voucherAlert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            this._voucherAlert.disposeChildren = true;
            this._voucherAlert.dispose();
            this._voucherAlert = null;
         }
      }
      
      private function __onNoMoneyResponse(e:FrameEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         this.disposeVoucherAlert();
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.BRAVERY;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         this.disposeAlert();
         this.disposeVoucherAlert();
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__responeHandler);
         if(Boolean(this._frame))
         {
            this._frame.dispose();
            this._frame = null;
         }
         if(Boolean(this._view))
         {
            this._view.dispose();
            this._view = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

