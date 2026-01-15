package ringStation.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   
   public class StationUserView extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _userInfoBg:Bitmap;
      
      private var _countDownBg:Bitmap;
      
      private var _awardIcon:Bitmap;
      
      private var _countDownSprite:Sprite;
      
      private var _rankInfo:FilterFrameText;
      
      private var _rankNum:FilterFrameText;
      
      private var _challengeInfo:FilterFrameText;
      
      private var _challengeTime:FilterFrameText;
      
      private var _challengeTimeNum:FilterFrameText;
      
      private var _rankAwardInfo:FilterFrameText;
      
      private var _getAwardTimeInfo:FilterFrameText;
      
      private var _getAwardTime:FilterFrameText;
      
      private var _getAwardNum:FilterFrameText;
      
      private var _champion:FilterFrameText;
      
      private var _addChallengeBtn:BaseButton;
      
      private var _fastForwardBtn:BaseButton;
      
      private var _battleFieldsBtn:BaseButton;
      
      private var _heroStandingsBtn:BaseButton;
      
      private var _player:ICharacter;
      
      private var _armoryView:ArmoryView;
      
      private var _battleFieldsView:BattleFieldsView;
      
      private var _buyCount:int;
      
      private var _buyPrice:int;
      
      private var _cdPrice:int;
      
      private var _countDownTime:Number;
      
      private var _timer:Timer;
      
      private var _timeFlag:Boolean;
      
      private var signBG:Bitmap;
      
      private var signText:FilterFrameText;
      
      private var signBnt:BaseButton;
      
      private var signChampionText:FilterFrameText;
      
      private var _signInputFrame:RingStationSingInputFrame;
      
      public function StationUserView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("ringStation.view.userBg");
         addChild(this._bg);
         this._userInfoBg = ComponentFactory.Instance.creat("ringStation.view.userInfoBg");
         addChild(this._userInfoBg);
         this._countDownSprite = new Sprite();
         this._countDownSprite.visible = false;
         addChild(this._countDownSprite);
         PositionUtils.setPos(this._countDownSprite,"ringStation.view.countDownPos");
         this._countDownBg = ComponentFactory.Instance.creat("ringStation.view.countdownBg");
         this._countDownSprite.addChild(this._countDownBg);
         this._challengeTime = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.challengeTime");
         this._challengeTime.text = LanguageMgr.GetTranslation("ringStation.view.challengeTimeText");
         this._countDownSprite.addChild(this._challengeTime);
         this._challengeTimeNum = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.challengeTimeNum");
         this._countDownSprite.addChild(this._challengeTimeNum);
         this._fastForwardBtn = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.fastforwardBtn");
         this._fastForwardBtn.tipData = LanguageMgr.GetTranslation("ringStation.view.countDownTipText");
         this._countDownSprite.addChild(this._fastForwardBtn);
         this._rankInfo = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.rankInfo");
         this._rankInfo.text = LanguageMgr.GetTranslation("ddt.ringstation.rankInfoText");
         addChild(this._rankInfo);
         this._rankNum = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.rankNum");
         addChild(this._rankNum);
         this._champion = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.champion");
         addChild(this._champion);
         this._challengeInfo = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.challengeInfo");
         addChild(this._challengeInfo);
         this._addChallengeBtn = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.addChallegeCountBtn");
         this._addChallengeBtn.tipData = LanguageMgr.GetTranslation("ringStation.view.buyCountTipText");
         addChild(this._addChallengeBtn);
         this._rankAwardInfo = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.rankAwardInfo");
         this._rankAwardInfo.text = LanguageMgr.GetTranslation("ringStation.view.rankAwardInfoText");
         addChild(this._rankAwardInfo);
         this._getAwardTimeInfo = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.getAwardTimeInfo");
         this._getAwardTimeInfo.text = LanguageMgr.GetTranslation("ringStation.view.getAwardTimeInfoText");
         addChild(this._getAwardTimeInfo);
         this._getAwardTime = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.getAwardTime");
         addChild(this._getAwardTime);
         this._getAwardNum = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.getAwardNum");
         addChild(this._getAwardNum);
         this._awardIcon = ComponentFactory.Instance.creat("ringStation.view.awardIcon");
         addChild(this._awardIcon);
         this._battleFieldsBtn = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.balltleFieldsBtn");
         addChild(this._battleFieldsBtn);
         this._heroStandingsBtn = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.heroStandingsBtn");
         addChild(this._heroStandingsBtn);
         this._player = CharactoryFactory.createCharacter(PlayerManager.Instance.Self,"room");
         this._player.showGun = true;
         this._player.show(false,-1);
         this._player.setShowLight(true);
         PositionUtils.setPos(this._player,"ringStation.view.playerPos");
         addChild(this._player as DisplayObject);
         this.addSignCell();
      }
      
      private function addSignCell() : void
      {
         this.signBG = ComponentFactory.Instance.creat("ringStation.view.signBG");
         this.signText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.signText");
         this.signBnt = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.signBnt");
         this.signChampionText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.signText2");
         addChild(this.signBG);
         addChild(this.signText);
         addChild(this.signBnt);
         addChild(this.signChampionText);
      }
      
      private function initEvent() : void
      {
         this._addChallengeBtn.addEventListener(MouseEvent.CLICK,this.__onBuyCount);
         this._fastForwardBtn.addEventListener(MouseEvent.CLICK,this.__onBuyTime);
         this._battleFieldsBtn.addEventListener(MouseEvent.CLICK,this.__onBattleFieldsHandle);
         this._heroStandingsBtn.addEventListener(MouseEvent.CLICK,this.__onArmoryHandle);
         this.signBnt.addEventListener(MouseEvent.CLICK,this.__signClick);
         SocketManager.Instance.addEventListener(RingStationEvent.RINGSTATION_BUYCOUNTORTIME,this.__buyCountOrTime);
      }
      
      private function __signClick(e:MouseEvent) : void
      {
         if(this._signInputFrame == null)
         {
            this._signInputFrame = ComponentFactory.Instance.creatComponentByStylename("ringStation.RingStationSingInputFrame");
         }
         LayerManager.Instance.addToLayer(this._signInputFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._signInputFrame.addEventListener(RingStationEvent.RINGSTATION_SIGN,this.__updateSign);
      }
      
      private function __updateSign(e:RingStationEvent) : void
      {
         this.signText.text = e.sign;
      }
      
      public function setRankNum(num:int) : void
      {
         this._rankNum.text = num.toString();
      }
      
      public function setChampionText(name:String) : void
      {
         if(name.length > 0)
         {
            this.signChampionText.text = LanguageMgr.GetTranslation("ringstation.view.ChampionName",name);
         }
      }
      
      public function setSignText(sign:String) : void
      {
         if(sign.length > 0)
         {
            this.signText.text = sign;
         }
         else
         {
            this.signText.text = LanguageMgr.GetTranslation("ringstation.view.signNormal");
         }
      }
      
      public function setChallengeNum(num:int) : void
      {
         this._challengeInfo.text = LanguageMgr.GetTranslation("ringStation.view.challengeInfoText",num);
         this._addChallengeBtn.x = this._challengeInfo.x + this._challengeInfo.width + 3;
      }
      
      public function setChallengeTime(date:Date) : void
      {
         this._countDownTime = date.time - TimeManager.Instance.Now().time;
         if(this._countDownTime < 0)
         {
            this._countDownSprite.visible = false;
            this._challengeTimeNum.text = "00:00";
         }
         else
         {
            this._countDownSprite.visible = true;
            this._countDownTime /= 1000;
            this._challengeTimeNum.text = this.transSecond(this._countDownTime);
            if(!this._timer)
            {
               this._timer = new Timer(1000);
               this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
            }
            this._timer.start();
         }
      }
      
      protected function __onTimer(event:TimerEvent) : void
      {
         --this._countDownTime;
         if(this._countDownTime < 0)
         {
            if(Boolean(this._countDownSprite))
            {
               this._countDownSprite.visible = false;
            }
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
            SocketManager.Instance.out.sendRingStationFightFlag();
         }
         else if(Boolean(this._challengeTimeNum))
         {
            this._challengeTimeNum.text = this.transSecond(this._countDownTime);
         }
      }
      
      public function setAwardNum(num:int) : void
      {
         this._getAwardNum.text = num.toString();
      }
      
      public function setAwardTime(date:Date) : void
      {
         var dayNum:int = 0;
         var nowDate:Number = TimeManager.Instance.Now().time;
         var hourNum:Number = (date.time - nowDate) / (60 * 60 * 1000);
         if(hourNum < 0)
         {
            this._getAwardTime.text = LanguageMgr.GetTranslation("ringStation.view.getAwardTimeText3");
         }
         else if(hourNum < 1)
         {
            this._getAwardTime.text = LanguageMgr.GetTranslation("ringStation.view.getAwardTimeText4");
         }
         else if(hourNum < 24)
         {
            this._getAwardTime.text = LanguageMgr.GetTranslation("ringStation.view.getAwardTimeText2",int(hourNum));
         }
         else
         {
            dayNum = hourNum / 24;
            this._getAwardTime.text = LanguageMgr.GetTranslation("ringStation.view.getAwardTimeText1",dayNum);
         }
      }
      
      protected function __onArmoryHandle(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._armoryView = ComponentFactory.Instance.creatComponentByStylename("ringStation.ArmoryView");
         this._armoryView.show();
      }
      
      protected function __onBattleFieldsHandle(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._battleFieldsView = ComponentFactory.Instance.creatComponentByStylename("ringStation.BattleFieldsView");
         this._battleFieldsView.show();
      }
      
      protected function __onBuyCount(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._timeFlag = false;
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ringStation.view.buyCount.alertInfo",this._buyPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyCountOrTime);
      }
      
      protected function __onBuyTime(event:MouseEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         this._timeFlag = true;
         if(this._countDownTime > 0)
         {
            alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ringStation.view.buyTime.alertInfo",this._cdPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
            alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyCountOrTime);
         }
      }
      
      protected function __buyCountOrTime(event:RingStationEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var timeFlag:Boolean = pkg.readBoolean();
         if(timeFlag)
         {
            if(pkg.readBoolean())
            {
               this._challengeTimeNum.text = "00:00";
               this._timer.stop();
               this._timer.reset();
               this._countDownSprite.visible = false;
            }
         }
         else
         {
            this._buyCount = pkg.readInt();
            this.setChallengeNum(pkg.readInt());
         }
      }
      
      protected function __alertBuyCountOrTime(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyCountOrTime);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(frame.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendBuyBattleCountOrTime(frame.isBand,this._timeFlag);
               break;
         }
         frame.dispose();
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
            SocketManager.Instance.out.sendBuyBattleCountOrTime(false,this._timeFlag);
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
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         var money:int = this._timeFlag ? this._cdPrice : this._buyPrice;
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < money)
         {
            return false;
         }
         return true;
      }
      
      private function transSecond(num:Number) : String
      {
         return String("0" + Math.floor(num / 60)).substr(-2) + ":" + String("0" + Math.floor(num % 60)).substr(-2);
      }
      
      private function removeEvent() : void
      {
         this._addChallengeBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyCount);
         this._battleFieldsBtn.removeEventListener(MouseEvent.CLICK,this.__onBattleFieldsHandle);
         this._heroStandingsBtn.removeEventListener(MouseEvent.CLICK,this.__onArmoryHandle);
         this.signBnt.removeEventListener(MouseEvent.CLICK,this.__signClick);
         SocketManager.Instance.removeEventListener(RingStationEvent.RINGSTATION_BUYCOUNTORTIME,this.__buyCountOrTime);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._userInfoBg))
         {
            this._userInfoBg.bitmapData.dispose();
            this._userInfoBg = null;
         }
         if(Boolean(this._awardIcon))
         {
            this._awardIcon.bitmapData.dispose();
            this._awardIcon = null;
         }
         if(Boolean(this._countDownBg))
         {
            this._countDownBg.bitmapData.dispose();
            this._countDownBg = null;
         }
         if(Boolean(this._rankInfo))
         {
            this._rankInfo.dispose();
            this._rankInfo = null;
         }
         if(Boolean(this._rankNum))
         {
            this._rankNum.dispose();
            this._rankNum = null;
         }
         if(Boolean(this._challengeInfo))
         {
            this._challengeInfo.dispose();
            this._challengeInfo = null;
         }
         if(Boolean(this._challengeTime))
         {
            this._challengeTime.dispose();
            this._challengeTime = null;
         }
         if(Boolean(this._challengeTimeNum))
         {
            this._challengeTimeNum.dispose();
            this._challengeTimeNum = null;
         }
         if(Boolean(this._addChallengeBtn))
         {
            this._addChallengeBtn.dispose();
            this._addChallengeBtn = null;
         }
         if(Boolean(this._fastForwardBtn))
         {
            this._fastForwardBtn.dispose();
            this._fastForwardBtn = null;
         }
         if(Boolean(this._battleFieldsBtn))
         {
            this._battleFieldsBtn.dispose();
            this._battleFieldsBtn = null;
         }
         if(Boolean(this._heroStandingsBtn))
         {
            this._heroStandingsBtn.dispose();
            this._heroStandingsBtn = null;
         }
         if(Boolean(this._rankAwardInfo))
         {
            this._rankAwardInfo.dispose();
            this._rankAwardInfo = null;
         }
         if(Boolean(this._getAwardTimeInfo))
         {
            this._getAwardTimeInfo.dispose();
            this._getAwardTimeInfo = null;
         }
         if(Boolean(this._getAwardTime))
         {
            this._getAwardTime.dispose();
            this._getAwardTime = null;
         }
         if(Boolean(this._getAwardNum))
         {
            this._getAwardNum.dispose();
            this._getAwardNum = null;
         }
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
         if(Boolean(this._champion))
         {
            this._champion.dispose();
            this._champion = null;
         }
         if(Boolean(this._countDownSprite))
         {
            this._countDownSprite = null;
         }
         if(Boolean(this._countDownSprite))
         {
            this._countDownSprite = null;
         }
         if(Boolean(this.signBG))
         {
            this.signBG.bitmapData.dispose();
            this.signBG = null;
         }
         if(Boolean(this.signBnt))
         {
            this.signBnt.dispose();
            this.signBnt = null;
         }
         if(Boolean(this.signText))
         {
            this.signText.dispose();
            this.signText = null;
         }
         if(Boolean(this.signChampionText))
         {
            this.signChampionText.dispose();
            this.signChampionText = null;
         }
      }
      
      public function get buyCount() : int
      {
         return this._buyCount;
      }
      
      public function set buyCount(value:int) : void
      {
         this._buyCount = value;
      }
      
      public function get buyPrice() : int
      {
         return this._buyPrice;
      }
      
      public function set buyPrice(value:int) : void
      {
         this._buyPrice = value;
      }
      
      public function get cdPrice() : int
      {
         return this._cdPrice;
      }
      
      public function set cdPrice(value:int) : void
      {
         this._cdPrice = value;
      }
   }
}

