package horseRace.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.InviteManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import hall.player.vo.PlayerPetsInfo;
   import hall.player.vo.PlayerVO;
   import horseRace.controller.HorseRaceManager;
   import room.RoomManager;
   
   public class HorseRaceMatchView extends Frame
   {
      
      public static var petsDisInfo:PlayerPetsInfo;
      
      private var _bg:Bitmap;
      
      private var _helpTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _startBnt:SimpleBitmapButton;
      
      private var _countDown:int = 0;
      
      private var _timer:Timer;
      
      private var _matchTxt:Bitmap;
      
      private var walkingPlayer:HorseRaceWalkPlayer;
      
      private var _buyCountTxt:FilterFrameText;
      
      private var _buyCount:int = 5;
      
      private var _buyBnt:BaseButton;
      
      private var rewardBox:HBox;
      
      private var _selectBtn:SelectedCheckButton;
      
      private var alert:BaseAlerFrame;
      
      public function HorseRaceMatchView()
      {
         super();
         this.initView();
         this.initEvent();
         InviteManager.Instance.enabled = false;
         this.walkingPlayer.stand();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("horseRace.horseRaceMatchView.title");
         this._bg = ComponentFactory.Instance.creatBitmap("horseRace.matchView.bg");
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView.rightTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("horseRace.match.description");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView.timeTxt");
         this._timeTxt.text = "0" + this._countDown;
         this._timeTxt.visible = false;
         this._matchTxt = ComponentFactory.Instance.creat("horseRace.matchView.txt");
         this._matchTxt.visible = false;
         this._startBnt = ComponentFactory.Instance.creatComponentByStylename("horseRace.matchView.startBtn");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("horseRace.matchView.cancelBtn");
         this._cancelBtn.visible = false;
         this._buyCountTxt = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView.buyCountTxt");
         this._buyCount = HorseRaceManager.Instance.horseRaceCanRaceTime;
         this._buyCountTxt.htmlText = LanguageMgr.GetTranslation("horseRace.match.buyCountTxt",this._buyCount);
         this._buyBnt = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView.buyCountBnt");
         this.rewardBox = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.matchView.rewardList");
         addToContent(this._bg);
         addToContent(this._helpTxt);
         addToContent(this._timeTxt);
         addToContent(this._matchTxt);
         addToContent(this._cancelBtn);
         addToContent(this._startBnt);
         addToContent(this._buyCountTxt);
         addToContent(this._buyBnt);
         addToContent(this.rewardBox);
         var self:PlayerVO = new PlayerVO();
         self.playerInfo = PlayerManager.Instance.Self;
         var tempInfo:PlayerInfo = new PlayerInfo();
         ObjectUtils.copyProperties(tempInfo,PlayerManager.Instance.findPlayer(self.playerInfo.ID));
         self.playerInfo = tempInfo;
         self.playerInfo.MountsType = Math.max(1,self.playerInfo.MountsType);
         self.playerInfo.PetsID = 0;
         this.walkingPlayer = new HorseRaceWalkPlayer(self,this.callBack);
         addToContent(this.walkingPlayer);
         this.setRewardToList();
      }
      
      private function setRewardToList() : void
      {
         var itemInfo:ItemTemplateInfo = null;
         var tInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         var rewardList:Array = HorseRaceManager.Instance.itemInfoList;
         if(rewardList == null)
         {
            return;
         }
         for(var i:int = 0; i < rewardList.length; i++)
         {
            itemInfo = ItemManager.Instance.getTemplateById(rewardList[i].TemplateID) as ItemTemplateInfo;
            tInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(tInfo,itemInfo);
            tInfo.ValidDate = rewardList[i].ValidDate;
            tInfo.StrengthenLevel = rewardList[i].StrengthLevel;
            tInfo.AttackCompose = rewardList[i].AttackCompose;
            tInfo.DefendCompose = rewardList[i].DefendCompose;
            tInfo.LuckCompose = rewardList[i].LuckCompose;
            tInfo.AgilityCompose = rewardList[i].AgilityCompose;
            tInfo.IsBinds = rewardList[i].IsBind;
            tInfo.Count = rewardList[i].Count;
            cell = new BagCell(0,tInfo,false);
            cell.x = 6;
            cell.y = 5;
            cell.setBgVisible(false);
            this.rewardBox.addChild(cell);
         }
      }
      
      public function reflushHorseRaceTime() : void
      {
         this._buyCount = HorseRaceManager.Instance.horseRaceCanRaceTime;
         if(Boolean(this._buyCountTxt))
         {
            this._buyCountTxt.htmlText = LanguageMgr.GetTranslation("horseRace.match.buyCountTxt",this._buyCount);
         }
      }
      
      private function callBack($walkingPlayer:HorseRaceWalkPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            $walkingPlayer.setSceneCharacterDirectionDefault = $walkingPlayer.sceneCharacterDirection = $walkingPlayer.playerVO.scenePlayerDirection;
            $walkingPlayer.mouseEnabled = false;
            $walkingPlayer.showPlayerTitle();
            $walkingPlayer.sceneCharacterStateType = "natural";
            $walkingPlayer.showPlayerTitle();
            $walkingPlayer.showVipName();
            $walkingPlayer.playerPoint = new Point(123,276);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler);
         this._startBnt.addEventListener(MouseEvent.CLICK,this._startClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this._onCancel);
         this._buyBnt.addEventListener(MouseEvent.CLICK,this._onBuyCountClick);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler);
         this._startBnt.removeEventListener(MouseEvent.CLICK,this._startClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this._onCancel);
         this._buyBnt.removeEventListener(MouseEvent.CLICK,this._onBuyCountClick);
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer = null;
         this.walkingPlayer.stop();
      }
      
      private function _onBuyCountClick(e:MouseEvent) : void
      {
         var price:int = 0;
         var content:String = null;
         if(HorseRaceManager.Instance.showBuyCountFram)
         {
            price = ServerConfigManager.instance.HorseGameCostMoneyCount;
            content = LanguageMgr.GetTranslation("horseRace.match.buyCountDescription",price);
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),content,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
            this._selectBtn.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
            this._selectBtn.addEventListener(MouseEvent.CLICK,this.__onClickSelectedBtn);
            this.alert.addToContent(this._selectBtn);
            this.alert.moveEnable = false;
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
            this.alert.height = 200;
            this._selectBtn.x = 102;
            this._selectBtn.y = 67;
         }
         else
         {
            SocketManager.Instance.out.buyHorseRaceCount();
         }
      }
      
      private function __onClickSelectedBtn(e:MouseEvent) : void
      {
         HorseRaceManager.Instance.showBuyCountFram = !this._selectBtn.selected;
      }
      
      private function __onRecoverResponse(e:FrameEvent) : void
      {
         var price:int = 0;
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            price = ServerConfigManager.instance.HorseGameCostMoneyCount;
            if(PlayerManager.Instance.Self.Money < price)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.buyHorseRaceCount();
         }
         else if(e.responseCode == FrameEvent.CANCEL_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            HorseRaceManager.Instance.showBuyCountFram = true;
         }
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
         if(Boolean(this._selectBtn))
         {
            this._selectBtn.removeEventListener(MouseEvent.CLICK,this.__onClickSelectedBtn);
         }
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      private function _startClick(e:MouseEvent) : void
      {
         var buyCount1:int = HorseRaceManager.Instance.horseRaceCanRaceTime;
         if(buyCount1 <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horseRace.raceView.noTimeToRace"));
            return;
         }
         this._timeTxt.visible = true;
         this._matchTxt.visible = true;
         this._timer.reset();
         this._countDown = 0;
         if(this._countDown < 10)
         {
            this._timeTxt.text = "0" + this._countDown;
         }
         else
         {
            this._timeTxt.text = "" + this._countDown;
         }
         this._timer.start();
         this._startBnt.visible = false;
         this._cancelBtn.visible = true;
         this.walkingPlayer.walk();
         GameInSocketOut.sendSingleRoomBegin(RoomManager.HORSERACE_ROOM);
      }
      
      private function _onCancel(e:MouseEvent) : void
      {
         this._timeTxt.visible = false;
         this._matchTxt.visible = false;
         this._timer.reset();
         this._timer.stop();
         this._countDown = 0;
         this._startBnt.visible = true;
         this._cancelBtn.visible = false;
         this.walkingPlayer.stand();
         GameInSocketOut.sendCancelWait();
      }
      
      private function cancelMatchHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         ++this._countDown;
         if(this._countDown > 10)
         {
            this._countDown = 0;
         }
         if(this._countDown < 10)
         {
            this._timeTxt.text = "0" + this._countDown;
         }
         else
         {
            this._timeTxt.text = "" + this._countDown;
         }
      }
      
      public function dispose2() : void
      {
         if(Boolean(this.alert))
         {
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
            ObjectUtils.disposeObject(this.alert);
         }
         this.removeEvent();
         super.dispose();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         InviteManager.Instance.enabled = true;
      }
      
      override public function dispose() : void
      {
         GameInSocketOut.sendCancelWait();
         if(Boolean(this.alert))
         {
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
            ObjectUtils.disposeObject(this.alert);
         }
         this.removeEvent();
         super.dispose();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         InviteManager.Instance.enabled = true;
      }
   }
}

