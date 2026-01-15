package sevenDouble.player
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
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   import sevenDouble.SevenDoubleManager;
   import sevenDouble.data.SevenDoubleCarInfo;
   import sevenDouble.data.SevenDoublePlayerInfo;
   import sevenDouble.event.SevenDoubleEvent;
   import sevenDouble.view.SevenDoubleBuffCountDownView;
   
   public class SevenDoubleGamePlayer extends Sprite implements Disposeable
   {
      
      private var _playerInfo:SevenDoublePlayerInfo;
      
      private var _playerMc:MovieClip;
      
      private var _destinationX:int;
      
      private var _carInfo:SevenDoubleCarInfo;
      
      private var _moveTimer:Timer;
      
      private var _nameTxt:FilterFrameText;
      
      private var _buffCountDownList:DictionaryData;
      
      private var _isDispose:Boolean = false;
      
      private var _fightMc:MovieClip;
      
      private var _leapArrow:Bitmap;
      
      public function SevenDoubleGamePlayer(playerInfo:SevenDoublePlayerInfo)
      {
         var tmp:Bitmap = null;
         this._buffCountDownList = new DictionaryData();
         super();
         this._playerInfo = playerInfo;
         this._carInfo = SevenDoubleManager.instance.dataInfo.carInfo[this._playerInfo.carType];
         this.x = 280 + this._playerInfo.posX;
         this.y = 190 + 65 * playerInfo.index;
         this._playerMc = new MovieClip();
         tmp = ComponentFactory.Instance.creatBitmap("game.player.defaultPlayerCharacter");
         tmp.x = -50;
         tmp.y = -100;
         this._playerMc.addChild(tmp);
         addChild(this._playerMc);
         this.loadRes();
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.game.playerNameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("sevenDouble.game.playerNameTxt" + this._carInfo.type,this._playerInfo.name);
         if(this._carInfo.type == 1)
         {
            this._nameTxt.textColor = 710173;
         }
         else if(this._carInfo.type == 2)
         {
            this._nameTxt.textColor = 16711680;
         }
         addChild(this._nameTxt);
         this._fightMc = ComponentFactory.Instance.creat("asset.sevenDouble.playerFighting");
         this._fightMc.gotoAndStop(2);
         PositionUtils.setPos(this._fightMc,"sevenDouble.gamePlayer.fightMcPos");
         addChild(this._fightMc);
         this.refreshFightMc();
         this._leapArrow = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.leapPromptArrow");
         addChild(this._leapArrow);
         this._leapArrow.visible = false;
         if(this._playerInfo.isSelf)
         {
            this._moveTimer = new Timer(1000);
            this._moveTimer.addEventListener(TimerEvent.TIMER,this.moveTimerHandler,false,0,true);
            SevenDoubleManager.instance.addEventListener(SevenDoubleManager.LEAP_PROMPT_SHOW_HIDE,this.showOrHideLeapArrow);
         }
      }
      
      public function get playerInfo() : SevenDoublePlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set destinationX(value:Number) : void
      {
         this._destinationX = value + 280;
         var tmpSpeed:Number = this._carInfo.speed;
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * SevenDoubleManager.instance.accelerateRate / 100;
         }
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * SevenDoubleManager.instance.decelerateRate / 100;
         }
         if(this._destinationX - x > tmpSpeed * 30)
         {
            x += tmpSpeed * 25;
         }
      }
      
      private function loadRes() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(SevenDoubleManager.instance.getPlayerResUrl(this._playerInfo.isSelf,this._playerInfo.carType),BaseLoader.MODULE_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function onLoadComplete(event:LoaderEvent) : void
      {
         var tmpStr:String = null;
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
         if(this._isDispose)
         {
            return;
         }
         if(Boolean(this._playerMc) && Boolean(this._playerMc.parent))
         {
            this._playerMc.parent.removeChild(this._playerMc);
         }
         if(this._playerInfo.isSelf)
         {
            tmpStr = "self";
         }
         else
         {
            tmpStr = "other";
         }
         this._playerMc = ComponentFactory.Instance.creat("asset.sevenDouble." + tmpStr + this._playerInfo.carType);
         this._playerMc.gotoAndPlay("stand");
         addChildAt(this._playerMc,0);
         this.refreshBuffCountDown();
      }
      
      private function moveTimerHandler(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendSevenDoubleMove();
      }
      
      private function showOrHideLeapArrow(event:SevenDoubleEvent) : void
      {
         this._leapArrow.visible = event.data.isShow;
      }
      
      public function refreshBuffCountDown() : void
      {
         var tmpBuffCDV:SevenDoubleBuffCountDownView = null;
         var tmp2:SevenDoubleBuffCountDownView = null;
         var tmp3:SevenDoubleBuffCountDownView = null;
         var tmp:SevenDoubleBuffCountDownView = null;
         var tmppp:SevenDoubleBuffCountDownView = null;
         var isHasBuff:Boolean = false;
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            this._playerMc.gotoAndPlay("moderate");
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("2"))
            {
               (this._buffCountDownList["2"] as SevenDoubleBuffCountDownView).endTime = this._playerInfo.deceleEndTime;
            }
            else
            {
               tmpBuffCDV = new SevenDoubleBuffCountDownView(this._playerInfo.deceleEndTime,2,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("2",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("2"))
         {
            tmp2 = this._buffCountDownList["2"] as SevenDoubleBuffCountDownView;
            tmp2.removeEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp2);
            this._buffCountDownList.remove(tmp2.type);
         }
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            this._playerMc.gotoAndPlay("accelerate");
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("1"))
            {
               (this._buffCountDownList["1"] as SevenDoubleBuffCountDownView).endTime = this._playerInfo.acceleEndTime;
            }
            else
            {
               tmpBuffCDV = new SevenDoubleBuffCountDownView(this._playerInfo.acceleEndTime,1,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("1",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("1"))
         {
            tmp3 = this._buffCountDownList["1"] as SevenDoubleBuffCountDownView;
            tmp3.removeEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp3);
            this._buffCountDownList.remove(tmp3.type);
         }
         if(this._playerInfo.invisiEndTime.getTime() - TimeManager.Instance.Now().getTime() > 0)
         {
            this._playerMc.gotoAndPlay("transparent");
            isHasBuff = true;
            if(this._buffCountDownList.hasKey("3"))
            {
               (this._buffCountDownList["3"] as SevenDoubleBuffCountDownView).endTime = this._playerInfo.invisiEndTime;
            }
            else
            {
               tmpBuffCDV = new SevenDoubleBuffCountDownView(this._playerInfo.invisiEndTime,3,this._buffCountDownList.length);
               tmpBuffCDV.addEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd,false,0,true);
               addChild(tmpBuffCDV);
               this._buffCountDownList.add("3",tmpBuffCDV);
            }
         }
         else if(this._buffCountDownList.hasKey("3"))
         {
            tmp = this._buffCountDownList["3"] as SevenDoubleBuffCountDownView;
            tmp.removeEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd);
            ObjectUtils.disposeObject(tmp);
            this._buffCountDownList.remove(tmp.type);
         }
         if(!isHasBuff)
         {
            this._playerMc.gotoAndPlay("stand");
         }
         if(!this.playerInfo.isSelf)
         {
            for each(tmppp in this._buffCountDownList)
            {
               tmppp.visible = false;
            }
         }
      }
      
      private function buffCountDownEnd(event:Event) : void
      {
         var tmp:SevenDoubleBuffCountDownView = event.target as SevenDoubleBuffCountDownView;
         tmp.removeEventListener(SevenDoubleBuffCountDownView.END,this.buffCountDownEnd);
         ObjectUtils.disposeObject(tmp);
         this._buffCountDownList.remove(tmp.type);
         this.refreshBuffCountDown();
      }
      
      public function updatePlayer() : void
      {
         var tmpSpeed:Number = this._carInfo.speed;
         if(this._playerInfo.acceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * SevenDoubleManager.instance.accelerateRate / 100;
         }
         if(this._playerInfo.deceleEndTime.getTime() > TimeManager.Instance.Now().getTime())
         {
            tmpSpeed = tmpSpeed * SevenDoubleManager.instance.decelerateRate / 100;
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
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.LEAP_PROMPT_SHOW_HIDE,this.showOrHideLeapArrow);
         if(Boolean(this._playerMc))
         {
            this._playerMc.gotoAndStop(this._playerMc.totalFrames);
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

