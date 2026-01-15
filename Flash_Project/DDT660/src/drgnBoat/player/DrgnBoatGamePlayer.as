package drgnBoat.player
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.data.DrgnBoatCarInfo;
   import drgnBoat.data.DrgnBoatPlayerInfo;
   import drgnBoat.event.DrgnBoatEvent;
   import drgnBoat.views.DrgnBoatBuffCountDown;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class DrgnBoatGamePlayer extends Sprite implements Disposeable
   {
      
      private var _playerInfo:DrgnBoatPlayerInfo;
      
      private var _playerMc:MovieClip;
      
      private var _destinationX:int;
      
      private var _carInfo:DrgnBoatCarInfo;
      
      private var _moveTimer:Timer;
      
      private var _nameTxt:FilterFrameText;
      
      private var _buffCountDownList:DictionaryData;
      
      private var _isDispose:Boolean = false;
      
      private var _fightMc:MovieClip;
      
      private var _leapArrow:Bitmap;
      
      private var _tmpTimer:Timer;
      
      private var _bufTime:Number;
      
      public function DrgnBoatGamePlayer(playerInfo:DrgnBoatPlayerInfo)
      {
         var tmp:Bitmap = null;
         var t:int = 0;
         this._buffCountDownList = new DictionaryData();
         super();
         this._playerInfo = playerInfo;
         if(this._playerInfo.carType == 3)
         {
            this._carInfo = new DrgnBoatCarInfo();
            this._carInfo.type = 3;
            this._carInfo.speed = DrgnBoatManager.instance.npcSpeed;
            this.y = 200 + 75 * 2;
         }
         else
         {
            this._carInfo = DrgnBoatManager.instance.dataInfo.carInfo[this._playerInfo.carType];
            t = this._playerInfo.index >= 2 ? this._playerInfo.index + 1 : this._playerInfo.index;
            this.y = 200 + 75 * t;
         }
         this.x = 280 + this._playerInfo.posX;
         this._playerMc = new MovieClip();
         tmp = ComponentFactory.Instance.creatBitmap("game.player.defaultPlayerCharacter");
         tmp.x = -50;
         tmp.y = -100;
         this._playerMc.addChild(tmp);
         addChild(this._playerMc);
         this.loadRes();
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.game.playerNameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("drgnBoat.playerNameTxt" + this._carInfo.type,this._playerInfo.name);
         if(this._carInfo.type == 3)
         {
            this._nameTxt.textColor = 710173;
         }
         else if(this._playerInfo.isSelf)
         {
            this._nameTxt.textColor = 52479;
         }
         else
         {
            this._nameTxt.textColor = 16711680;
         }
         addChild(this._nameTxt);
         this._fightMc = ComponentFactory.Instance.creat("drgnBoat.playerFighting");
         this._fightMc.gotoAndStop(2);
         PositionUtils.setPos(this._fightMc,"drgnBoat.gamePlayer.fightMcPos");
         addChild(this._fightMc);
         this.refreshFightMc();
         this._leapArrow = ComponentFactory.Instance.creatBitmap("drgnBoat.leapPromptArrow");
         addChild(this._leapArrow);
         this._leapArrow.visible = false;
         if(this._playerInfo.isSelf)
         {
            this._moveTimer = new Timer(1000);
            this._moveTimer.addEventListener(TimerEvent.TIMER,this.moveTimerHandler,false,0,true);
            DrgnBoatManager.instance.addEventListener(DrgnBoatManager.LEAP_PROMPT_SHOW_HIDE,this.showOrHideLeapArrow);
         }
      }
      
      public function get playerInfo() : DrgnBoatPlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set destinationX(value:Number) : void
      {
         this._destinationX = value + 280;
         var tmpSpeed:Number = this._carInfo.speed;
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * DrgnBoatManager.instance.accelerateRate / 100;
         }
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * DrgnBoatManager.instance.decelerateRate / 100;
         }
         if(this._destinationX - x > tmpSpeed * 40)
         {
            x += tmpSpeed * 37;
         }
      }
      
      private function loadRes() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(DrgnBoatManager.instance.getPlayerResUrl(this._playerInfo.isSelf,this._playerInfo.carType),BaseLoader.MODULE_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function onLoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
         if(this._isDispose)
         {
            return;
         }
         if(Boolean(this._playerMc) && Boolean(this._playerMc.parent))
         {
            this._playerMc.parent.removeChild(this._playerMc);
         }
         this._playerMc = ComponentFactory.Instance.creat("asset.drgnBoat" + this._playerInfo.carType);
         this._playerMc.gotoAndPlay("stand");
         addChildAt(this._playerMc,0);
         this.refreshBuffCountDown();
      }
      
      private function moveTimerHandler(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendEscortMove();
      }
      
      private function showOrHideLeapArrow(event:DrgnBoatEvent) : void
      {
         this._leapArrow.visible = event.data.isShow;
      }
      
      public function refreshBuffCountDown() : void
      {
         var tmpBuffCDV:DrgnBoatBuffCountDown = null;
         var tmp2:DrgnBoatBuffCountDown = null;
         var tmp3:DrgnBoatBuffCountDown = null;
         var tmp:DrgnBoatBuffCountDown = null;
         var tmp4:DrgnBoatBuffCountDown = null;
         var tmppp:DrgnBoatBuffCountDown = null;
         var isHasBuff:Boolean = false;
         var now:Date = TimeManager.Instance.Now();
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            if(this._playerMc.currentFrameLabel != "moderate")
            {
               this._playerMc.gotoAndPlay("moderate");
            }
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("2"))
            {
               (this._buffCountDownList["2"] as DrgnBoatBuffCountDown).endTime = this._playerInfo.deceleEndTime;
            }
            else
            {
               tmpBuffCDV = new DrgnBoatBuffCountDown(this._playerInfo.deceleEndTime,2,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("2",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("2"))
         {
            tmp2 = this._buffCountDownList["2"] as DrgnBoatBuffCountDown;
            tmp2.removeEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp2);
            this._buffCountDownList.remove(tmp2.type);
         }
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            if(this._playerMc.currentFrameLabel != "accelerate")
            {
               this._playerMc.gotoAndPlay("accelerate");
            }
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("1"))
            {
               (this._buffCountDownList["1"] as DrgnBoatBuffCountDown).endTime = this._playerInfo.acceleEndTime;
            }
            else
            {
               tmpBuffCDV = new DrgnBoatBuffCountDown(this._playerInfo.acceleEndTime,1,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("1",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("1"))
         {
            tmp3 = this._buffCountDownList["1"] as DrgnBoatBuffCountDown;
            tmp3.removeEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp3);
            this._buffCountDownList.remove(tmp3.type);
         }
         if(this._playerInfo.invisiEndTime.getTime() - TimeManager.Instance.Now().getTime() > 0)
         {
            if(this._playerMc.currentFrameLabel != "transparent")
            {
               this._playerMc.gotoAndPlay("transparent");
            }
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("3"))
            {
               (this._buffCountDownList["3"] as DrgnBoatBuffCountDown).endTime = this._playerInfo.invisiEndTime;
            }
            else
            {
               tmpBuffCDV = new DrgnBoatBuffCountDown(this._playerInfo.invisiEndTime,3,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("3",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("3"))
         {
            tmp = this._buffCountDownList["3"] as DrgnBoatBuffCountDown;
            tmp.removeEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp);
            this._buffCountDownList.remove(tmp.type);
         }
         if(this._playerInfo.missileLaunchEndTime.getTime() - TimeManager.Instance.Now().getTime() > 0)
         {
            if(this._playerMc.currentFrameLabel != "beat")
            {
               this._playerMc.gotoAndPlay("beat");
            }
            isHasBuff = true;
            this._tmpTimer = new Timer(500);
            this._bufTime = this._playerInfo.missileLaunchEndTime.getTime();
            this._tmpTimer.addEventListener(TimerEvent.TIMER,this.__bufTimerHandler);
            this._tmpTimer.start();
         }
         if(this._playerInfo.missileEndTime.getTime() - TimeManager.Instance.Now().getTime() > 0)
         {
            if(this._playerInfo.missileHitEndTime.getTime() - TimeManager.Instance.Now().getTime() > 0)
            {
               if(this._playerMc.currentFrameLabel != "cryA")
               {
                  this._playerMc.gotoAndPlay("cryA");
               }
               this._tmpTimer = new Timer(500);
               this._bufTime = this._playerInfo.missileHitEndTime.getTime();
               this._tmpTimer.addEventListener(TimerEvent.TIMER,this.__bufTimerHandler);
               this._tmpTimer.start();
            }
            else if(this._playerMc.currentFrameLabel != "cryC")
            {
               this._playerMc.gotoAndPlay("cryC");
            }
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("4"))
            {
               (this._buffCountDownList["4"] as DrgnBoatBuffCountDown).endTime = this._playerInfo.missileEndTime;
            }
            else
            {
               tmpBuffCDV = new DrgnBoatBuffCountDown(this._playerInfo.missileEndTime,4,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("4",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("4"))
         {
            tmp4 = this._buffCountDownList["4"] as DrgnBoatBuffCountDown;
            tmp4.removeEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp4);
            this._buffCountDownList.remove(tmp4.type);
         }
         if(!isHasBuff)
         {
            if(this._playerMc.currentLabel == "cryC")
            {
               this._playerMc.gotoAndPlay("cryB");
               this._playerMc.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            }
            else
            {
               this._playerMc.gotoAndPlay("stand");
            }
         }
         if(!this.playerInfo.isSelf)
         {
            for each(tmppp in this._buffCountDownList)
            {
               tmppp.visible = false;
            }
         }
      }
      
      protected function __enterFrame(event:Event) : void
      {
         if(Boolean(this._playerMc) && this._playerMc.currentFrame == this._playerMc.totalFrames)
         {
            this._playerMc.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this.refreshBuffCountDown();
         }
      }
      
      protected function __bufTimerHandler(event:TimerEvent) : void
      {
         var timer:Timer = event.target as Timer;
         if(this._bufTime - TimeManager.Instance.Now().getTime() <= 0)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,this.__bufTimerHandler);
            timer = null;
            this.refreshBuffCountDown();
         }
      }
      
      private function buffCountDownEnd(event:Event) : void
      {
         var tmp:DrgnBoatBuffCountDown = event.target as DrgnBoatBuffCountDown;
         tmp.removeEventListener(DrgnBoatBuffCountDown.END,this.buffCountDownEnd);
         ObjectUtils.disposeObject(tmp);
         this._buffCountDownList.remove(tmp.type);
         this.refreshBuffCountDown();
      }
      
      public function updatePlayer() : void
      {
         var tmpSpeed:Number = this._carInfo.speed;
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * DrgnBoatManager.instance.accelerateRate / 100;
         }
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * DrgnBoatManager.instance.decelerateRate / 100;
         }
         if(x < this._destinationX)
         {
            x += tmpSpeed;
         }
      }
      
      public function refreshFightMc() : void
      {
         if(this._playerInfo.fightState == 1)
         {
            this._fightMc.gotoAndStop(1);
            if(Boolean(this._moveTimer) && this._moveTimer.running)
            {
               this._moveTimer.stop();
            }
            if(Boolean(this._tmpTimer) && this._tmpTimer.running)
            {
               this._tmpTimer.stop();
            }
         }
         else
         {
            this._fightMc.gotoAndStop(2);
            if(Boolean(this._moveTimer) && !this._moveTimer.running)
            {
               this._moveTimer.start();
            }
         }
      }
      
      public function startGame() : void
      {
         if(this._playerInfo.isSelf)
         {
            this._moveTimer.start();
            this.moveTimerHandler(null);
         }
      }
      
      public function endGame() : void
      {
         if(Boolean(this._moveTimer) && this._moveTimer.running)
         {
            this._moveTimer.stop();
         }
      }
      
      public function dispose() : void
      {
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.LEAP_PROMPT_SHOW_HIDE,this.showOrHideLeapArrow);
         if(Boolean(this._playerMc))
         {
            this._playerMc.gotoAndStop(this._playerMc.totalFrames);
            this._playerMc.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
         if(Boolean(this._fightMc))
         {
            this._fightMc.gotoAndStop(2);
         }
         if(Boolean(this._moveTimer))
         {
            this._moveTimer.removeEventListener(TimerEvent.TIMER,this.moveTimerHandler);
            this._moveTimer.stop();
         }
         this._moveTimer = null;
         if(Boolean(this._tmpTimer))
         {
            this._tmpTimer.removeEventListener(TimerEvent.TIMER,this.__bufTimerHandler);
            this._tmpTimer.stop();
         }
         this._tmpTimer = null;
         this._carInfo = null;
         this._playerInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._playerMc = null;
         this._nameTxt = null;
         this._buffCountDownList = null;
         this._fightMc = null;
         this._isDispose = true;
      }
   }
}

