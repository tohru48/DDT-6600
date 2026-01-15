package dayActivity.items
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import cryptBoss.CryptBossManager;
   import dayActivity.DayActivityManager;
   import dayActivity.data.ActivityData;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyNPCModel;
   import horse.HorseManager;
   import labyrinth.LabyrinthManager;
   import league.manager.LeagueManager;
   import petsBag.PetsBagManager;
   import ringStation.RingStationManager;
   import room.RoomManager;
   import room.view.roomView.SingleRoomView;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import worldboss.WorldBossManager;
   
   public class DayActivityLeftListItem extends Component implements Disposeable
   {
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _line:Bitmap;
      
      private var _str:String;
      
      private var _overCount:int;
      
      private var _total:int;
      
      private var _money:int;
      
      private var _data:ActivityData;
      
      private var _lastCreatTime:int = 0;
      
      private var _backGround:Component;
      
      private var _startTime:int;
      
      private var _endTime:int;
      
      private var alertFrame:BaseAlerFrame;
      
      public function DayActivityLeftListItem(bool:Boolean, data:ActivityData)
      {
         super();
         this._data = data;
         this.initView(bool,data);
      }
      
      private function initView(bool:Boolean, data:ActivityData) : void
      {
         if(bool)
         {
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt1");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt1");
            this._btn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.quikeBtn");
            this._btn.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.quitkOver",data.ActivePoint);
            this._money = data.MoneyPoint;
            addChild(this._btn);
            buttonMode = true;
            useHandCursor = true;
         }
         else
         {
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt2");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt2");
         }
         _id = data.ID;
         this._txt1.x = 0;
         this._txt1.y = 4;
         this._txt1.text = data.Description;
         addChild(this._txt1);
         this._txt2.x = 252;
         this._txt2.y = 4;
         this._txt2.text = data.OverCount + "/" + data.Count;
         addChild(this._txt2);
         this._total = data.Count;
         this._line = ComponentFactory.Instance.creatBitmap("day.line");
         addChild(this._line);
         addEventListener(MouseEvent.CLICK,this.jumpHander);
         this._backGround = new Component();
         this._backGround.graphics.beginFill(0);
         this._backGround.graphics.drawRect(0,0,200,20);
         this._backGround.graphics.endFill();
         this._backGround.alpha = 0;
         this._backGround.tipStyle = "ddt.view.tips.OneLineTip";
         this._backGround.tipDirctions = "5,1,2";
         if(data.JumpType > 0)
         {
            this._backGround.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.itemTips",data.ActivePoint,data.Description);
         }
         else
         {
            this._backGround.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.btnTip",data.ActivePoint);
         }
         addChild(this._backGround);
      }
      
      protected function jumpHander(event:MouseEvent) : void
      {
         var _payAlert:BaseAlerFrame = null;
         var tmpGrade:int = 0;
         SoundManager.instance.play("008");
         if(event.target is SimpleBitmapButton)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._str = LanguageMgr.GetTranslation("ddt.Dayactivity.addSpeed",this._money);
            _payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),this._str,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.GAME_TOP_LAYER,null,"SimpleAlert",50,true);
            _payAlert.enterEnable = false;
            if(Boolean(_payAlert.parent))
            {
               _payAlert.parent.removeChild(_payAlert);
            }
            LayerManager.Instance.addToLayer(_payAlert,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
            _payAlert.addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
            return;
         }
         if(this._data.JumpType > 0)
         {
            switch(this._data.JumpType)
            {
               case 1:
                  if(PlayerManager.Instance.Self.Grade < 30)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                     return;
                  }
                  LabyrinthManager.Instance.show();
                  break;
               case 2:
                  if(PlayerManager.Instance.Self.Grade < 22)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",22));
                     return;
                  }
                  if(!LeagueManager.instance.isOpen)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  StateManager.setState(StateType.ROOM_LIST);
                  ComponentSetting.SEND_USELOG_ID(3);
                  if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
                  }
                  break;
               case 3:
                  if(PlayerManager.Instance.Self.Grade < 21)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",21));
                     return;
                  }
                  if(!BattleGroudManager.Instance.isShow)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
                  break;
               case 4:
                  if(!WorldBossManager.Instance.isOpen)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  SocketManager.Instance.out.enterWorldBossRoom();
                  break;
               case 5:
                  if(PlayerManager.Instance.Self.Grade < 20)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                     return;
                  }
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.TOTEMVIEW - 1);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 6:
                  if(PlayerManager.Instance.Self.Grade < 25)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 7:
                  if(PlayerManager.Instance.Self.Grade < 17)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                     return;
                  }
                  StateManager.setState(StateType.CONSORTIA);
                  ComponentSetting.SEND_USELOG_ID(5);
                  if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
                  }
                  break;
               case 8:
                  if(PlayerManager.Instance.Self.Grade < 6)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",6));
                     return;
                  }
                  StateManager.setState(StateType.SHOP);
                  ComponentSetting.SEND_USELOG_ID(1);
                  break;
               case 9:
                  if(PlayerManager.Instance.Self.Grade < 8)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
                     return;
                  }
                  if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                     return;
                  }
                  if(getTimer() - this._lastCreatTime > 1000)
                  {
                     this._lastCreatTime = getTimer();
                     GameInSocketOut.sendSingleRoomBegin(SingleRoomView.ENCOUNTER);
                  }
                  break;
               case 10:
                  if(PlayerManager.Instance.Self.Grade < 16)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",16));
                     return;
                  }
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 11:
                  if(PlayerManager.Instance.Self.Grade < 17)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                     return;
                  }
                  tmpGrade = ConsortionModelControl.Instance.bossCallCondition;
                  if(PlayerManager.Instance.Self.consortiaInfo.Level < tmpGrade)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.conditionTxt2",tmpGrade));
                     return;
                  }
                  StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
                  break;
               case 12:
                  if(PlayerManager.Instance.Self.Grade < 25)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 13:
                  if(PlayerManager.Instance.Self.Grade < 10)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                     return;
                  }
                  this.toDungeon();
                  break;
               case 14:
                  if(PlayerManager.Instance.Self.Grade < 23)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",23));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 51:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,25))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 15:
                  if(PlayerManager.Instance.Self.Grade < 26)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",26));
                     return;
                  }
                  SocketManager.Instance.out.enterBuried();
                  break;
               case 16:
                  if(PlayerManager.Instance.Self.Grade < 14)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",14));
                     return;
                  }
                  BagAndInfoManager.Instance.showBagAndInfo(4);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 23:
                  if(GypsyNPCModel.getInstance().isStart())
                  {
                     GypsyShopManager.getInstance().showMainFrame();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.upOpen"));
                  }
                  break;
               case 50:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,25))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 53:
                  if(PlayerManager.Instance.Self.Grade < 19)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",19));
                     return;
                  }
                  RingStationManager.instance.show();
                  break;
               case 54:
                  if(PlayerManager.Instance.Self.Grade < 31)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",31));
                     return;
                  }
                  CryptBossManager.instance.show();
                  break;
               case 55:
                  if(PlayerManager.Instance.Self.Grade < 28)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",28));
                     return;
                  }
                  HorseManager.instance.loadModule();
                  break;
               case 56:
                  if(PlayerManager.Instance.Self.Grade < 28)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",28));
                     return;
                  }
                  HorseManager.instance.loadModule();
                  break;
               case 57:
                  if(PlayerManager.Instance.Self.Grade < 25)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  PetsBagManager.instance.show();
                  break;
               case 58:
                  if(PlayerManager.Instance.Self.Grade < 25)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
            }
            DayActivityManager.Instance.dispose();
         }
      }
      
      public function setTxt2(num:int) : void
      {
         if(num >= this._total)
         {
            num = this._total;
         }
         this._txt2.text = num + "/" + this._total;
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         var _payAlert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_payAlert.isBand)
            {
               if(!this.checkMoney(true))
               {
                  _payAlert.dispose();
                  this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                  this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                  return;
               }
               DayActivityManager.Instance.send(1,_id);
            }
            else
            {
               if(!this.checkMoney(false))
               {
                  _payAlert.dispose();
                  this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this.alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               DayActivityManager.Instance.send(2,_id);
            }
         }
         _payAlert.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         ObjectUtils.disposeObject(_payAlert);
         _payAlert = null;
      }
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._money)
         {
            return false;
         }
         return true;
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            DayActivityManager.Instance.send(2,_id);
         }
         e.currentTarget.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function toDungeon() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,8))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
            return;
         }
         if(!PlayerManager.Instance.checkEnterDungeon)
         {
            return;
         }
         StateManager.setState(StateType.DUNGEON_LIST);
         ComponentSetting.SEND_USELOG_ID(4);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.jumpHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

