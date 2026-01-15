package bombKing.view
{
   import bombKing.BombKingManager;
   import bombKing.components.BKingLine;
   import bombKing.components.BKingPlayerItem;
   import bombKing.components.BKingPlayerTip;
   import bombKing.components.BKingbattleLogItem;
   import bombKing.data.BKingLogInfo;
   import bombKing.data.BKingPlayerInfo;
   import bombKing.event.BombKingEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class BombKingMainFrame extends Frame
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 120;
      
      private var _bg:Bitmap;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _timeTxt:FilterFrameText;
      
      private var _rankBtn:SimpleBitmapButton;
      
      private var _rankTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _prizeBtn:SimpleBitmapButton;
      
      private var _ruleBtn:SimpleBitmapButton;
      
      private var _purpleIcon:Bitmap;
      
      private var _redIcon:Bitmap;
      
      private var _blueIcon:Bitmap;
      
      private var _firstName:FilterFrameText;
      
      private var _secondName:FilterFrameText;
      
      private var _thirdName:FilterFrameText;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _logVBox:VBox;
      
      private var _battleSoon:Bitmap;
      
      private var _remain:FilterFrameText;
      
      private var _firstStageInPlay:Bitmap;
      
      private var _secondStageInPlay:Bitmap;
      
      private var _finalStageInPlay:Bitmap;
      
      private var _rankFrame:BombKingRankFrame;
      
      private var _prizeFrame:BombKingPrizeFrame;
      
      private var _playerTips:BKingPlayerTip;
      
      private var _itemArr:Array;
      
      private var _lineArr:Array;
      
      private var _stampArr:Array;
      
      private var _itemDic:Dictionary;
      
      private var _lineDic:Dictionary;
      
      private var _rankDic:Dictionary;
      
      private var _top3InfoArr:Array;
      
      private var _top3NameArr:Array;
      
      private var _logArr:Array;
      
      private var _headImgArr:Array;
      
      private var _loaderArr:Array;
      
      private var _battleStage:int;
      
      private var _turn:int;
      
      private var _status:int;
      
      private var _battleEndDate:Date;
      
      private var _tipSprite:Component;
      
      private var nextTimer:Timer;
      
      private var remainTimer:Timer;
      
      public function BombKingMainFrame()
      {
         super();
         this.initData();
         this.initView();
         this.initEvents();
         SocketManager.Instance.out.updateBombKingMainFrame();
         SocketManager.Instance.out.updateBombKingBattleLog();
      }
      
      private function initData() : void
      {
         this._itemArr = [];
         this._lineArr = [];
         this._itemDic = new Dictionary();
         this._lineDic = new Dictionary();
         this._stampArr = [];
         this._headImgArr = [];
         SocketManager.Instance.out.sendUpdateSysDate();
      }
      
      private function initView() : void
      {
         var place:int = 0;
         var line:BKingLine = null;
         var item:BKingPlayerItem = null;
         titleText = LanguageMgr.GetTranslation("bombKing.title");
         this._bg = ComponentFactory.Instance.creat("bombKing.BG");
         addToContent(this._bg);
         for(place = 2; place <= 31; place++)
         {
            line = new BKingLine(place);
            PositionUtils.setPos(line,"bombKing.linePos" + place);
            addToContent(line);
            this._lineArr.push(line);
            this._lineDic[place] = line;
         }
         for(place = 2; place <= 31; place++)
         {
            item = new BKingPlayerItem(place);
            PositionUtils.setPos(item,"bombKing.itemPos" + place);
            item.addEventListener(MouseEvent.CLICK,this.__playerItemClick);
            item.buttonMode = true;
            addToContent(item);
            this._itemArr.push(item);
            this._itemDic[place] = item;
         }
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.startBtn");
         addToContent(this._startBtn);
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.timeTxt");
         addToContent(this._timeTxt);
         this._rankBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankBtn");
         addToContent(this._rankBtn);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankInfoTxt");
         addToContent(this._rankTxt);
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankInfoTxt");
         PositionUtils.setPos(this._scoreTxt,"bombKing.scoreTxtPos");
         addToContent(this._scoreTxt);
         this._prizeBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeBtn");
         addToContent(this._prizeBtn);
         this._ruleBtn = ComponentFactory.Instance.creatComponentByStylename("bombKing.ruleBtn");
         addToContent(this._ruleBtn);
         this._purpleIcon = ComponentFactory.Instance.creat("bombKing.purpleIcon");
         addToContent(this._purpleIcon);
         this._redIcon = ComponentFactory.Instance.creat("bombKing.redIcon");
         addToContent(this._redIcon);
         this._blueIcon = ComponentFactory.Instance.creat("bombKing.blueIcon");
         addToContent(this._blueIcon);
         this._firstName = ComponentFactory.Instance.creatComponentByStylename("bombKing.nameTxt");
         PositionUtils.setPos(this._firstName,"bombKing.firstNamePos");
         addToContent(this._firstName);
         this._secondName = ComponentFactory.Instance.creatComponentByStylename("bombKing.nameTxt");
         PositionUtils.setPos(this._secondName,"bombKing.secondNamePos");
         addToContent(this._secondName);
         this._thirdName = ComponentFactory.Instance.creatComponentByStylename("bombKing.nameTxt");
         PositionUtils.setPos(this._thirdName,"bombKing.thirdNamePos");
         addToContent(this._thirdName);
         this._logVBox = ComponentFactory.Instance.creatComponentByStylename("bombKing.Log.logVBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("bombKing.Log.scrollPanel");
         this._scrollPanel.setView(this._logVBox);
         addToContent(this._scrollPanel);
         this._battleSoon = ComponentFactory.Instance.creat("bombKing.battleSoon");
         addToContent(this._battleSoon);
         this._battleSoon.visible = false;
         this._remain = ComponentFactory.Instance.creatComponentByStylename("bombKing.remainTxt");
         addToContent(this._remain);
         this._remain.text = "60";
         this._remain.visible = false;
         this._firstStageInPlay = ComponentFactory.Instance.creat("bombKing.battling1");
         addToContent(this._firstStageInPlay);
         this._firstStageInPlay.visible = false;
         this._secondStageInPlay = ComponentFactory.Instance.creat("bombKing.battling2");
         addToContent(this._secondStageInPlay);
         this._secondStageInPlay.visible = false;
         this._finalStageInPlay = ComponentFactory.Instance.creat("bombKing.battling3");
         addToContent(this._finalStageInPlay);
         this._finalStageInPlay.visible = false;
         this._startBtn.enable = false;
         this._playerTips = new BKingPlayerTip();
         addToContent(this._playerTips);
         this._playerTips.visible = false;
         this._logArr = [];
         this._top3NameArr = [];
         this._top3NameArr.push(this._firstName);
         this._top3NameArr.push(this._secondName);
         this._top3NameArr.push(this._thirdName);
         this._tipSprite = new Component();
         this._tipSprite.graphics.beginFill(0,0);
         this._tipSprite.graphics.drawRect(0,0,this._prizeBtn.width,this._prizeBtn.height);
         this._tipSprite.graphics.endFill();
         this._tipSprite.x = this._prizeBtn.x;
         this._tipSprite.y = this._prizeBtn.y;
         this._tipSprite.tipStyle = "ddt.view.tips.OneLineTip";
         this._tipSprite.tipDirctions = "7";
         this._tipSprite.tipData = LanguageMgr.GetTranslation("bombKing.levelLimit");
         this._tipSprite.visible = false;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__startBtnClick);
         this._rankBtn.addEventListener(MouseEvent.CLICK,this.__rankBtnClick);
         this._prizeBtn.addEventListener(MouseEvent.CLICK,this.__prizeBtnClick);
         this._ruleBtn.addEventListener(MouseEvent.CLICK,this.__ruleBtnClick);
         SocketManager.Instance.addEventListener(BombKingEvent.UPDATE_MAIN_FRAME,this.__update);
         SocketManager.Instance.addEventListener(BombKingEvent.UPDATE_REQUEST,this.__updateRequest);
         SocketManager.Instance.addEventListener(BombKingEvent.BATTLE_LOG,this.__battleLog);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED,this.__waitGameFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV,this.__waitGameRecv);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__onStageClick);
      }
      
      protected function __waitGameRecv(event:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.out.updateBombKingMainFrame();
      }
      
      protected function __waitGameFailed(event:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.out.updateBombKingMainFrame();
      }
      
      protected function __playerItemClick(event:MouseEvent) : void
      {
         var item:BKingPlayerItem = null;
         var gp:Point = null;
         item = event.currentTarget as BKingPlayerItem;
         if(item && item.info && item.info.userId != 0)
         {
            event.stopPropagation();
            this._playerTips.visible = true;
            _container.setChildIndex(this._playerTips,_container.numChildren - 1);
            gp = globalToLocal(new Point(event.stageX,event.stageY));
            if(gp.x + this._playerTips.width > 1000)
            {
               gp.x = 990 - this._playerTips.width;
            }
            this._playerTips.x = gp.x;
            this._playerTips.y = gp.y;
            this._playerTips.setUserId(item.info.userId,item.info.areaId);
            this._playerTips.mouseEnabled = true;
            this._playerTips.mouseChildren = true;
         }
      }
      
      protected function __onStageClick(event:MouseEvent) : void
      {
         this._playerTips.mouseEnabled = false;
         this._playerTips.mouseChildren = false;
         this._playerTips.visible = false;
      }
      
      protected function __startBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendBombKingStartBattle();
      }
      
      protected function __rankBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._rankFrame = ComponentFactory.Instance.creatComponentByStylename("bombKing.BombKingRankFrame");
         LayerManager.Instance.addToLayer(this._rankFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __prizeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._prizeFrame = ComponentFactory.Instance.creatComponentByStylename("bombKing.BombKingPrizeFrame");
         LayerManager.Instance.addToLayer(this._prizeFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __ruleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("bombKing.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("bombKing.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(50);
         helpPage.titleText = LanguageMgr.GetTranslation("bombKing.rules");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __update(event:BombKingEvent) : void
      {
         var isExist:Boolean = false;
         var info:BKingPlayerInfo = null;
         var isExist2:Boolean = false;
         var info2:BKingPlayerInfo = null;
         var characterLoader:ShowCharacter = null;
         var style:String = null;
         var playerInfo:PlayerInfo = null;
         var pkg:PackageIn = event.pkg;
         var arr:Array = [];
         for(var i:int = 0; i < 16; i++)
         {
            isExist = pkg.readBoolean();
            info = new BKingPlayerInfo();
            if(isExist)
            {
               info.userId = pkg.readInt();
               info.areaId = pkg.readInt();
               info.name = pkg.readUTF();
               info.rankType = pkg.readInt();
            }
            arr.push(info);
         }
         this._top3InfoArr = [];
         this._loaderArr = [];
         for(var j:int = 0; j < 3; j++)
         {
            isExist2 = pkg.readBoolean();
            info2 = new BKingPlayerInfo();
            characterLoader = null;
            if(isExist2)
            {
               info2.userId = pkg.readInt();
               info2.areaId = pkg.readInt();
               info2.name = pkg.readUTF();
               style = pkg.readUTF();
               info2.style = BombKingManager.instance.cutSuitStr(style);
               info2.color = pkg.readUTF();
               info2.sex = pkg.readBoolean();
               playerInfo = new PlayerInfo();
               playerInfo.Style = info2.style;
               playerInfo.Colors = info2.color;
               playerInfo.Sex = info2.sex;
               characterLoader = CharactoryFactory.createCharacter(playerInfo) as ShowCharacter;
               characterLoader.addEventListener(Event.COMPLETE,this.__characterComplete);
               characterLoader.showGun = false;
               characterLoader.setShowLight(false,null);
               characterLoader.stopAnimation();
               characterLoader.show(true,1);
               characterLoader.buttonMode = characterLoader.mouseEnabled = characterLoader.mouseChildren = false;
            }
            this._loaderArr.push(characterLoader);
            this._top3InfoArr.push(info2);
            this._top3NameArr[j].text = info2.name;
         }
         this.fillRankDic(arr);
         this.updateItems();
         var myScore:int = pkg.readInt();
         var myRank:int = pkg.readInt();
         if(myRank <= 0)
         {
            this._rankTxt.text = LanguageMgr.GetTranslation("bombKing.outOfRank1");
         }
         else
         {
            this._rankTxt.text = LanguageMgr.GetTranslation("bombKing.myRank",myRank);
         }
         this._scoreTxt.text = LanguageMgr.GetTranslation("bombKing.myScore",myScore);
         this._battleStage = pkg.readInt();
         this._turn = pkg.readInt() + 1;
         this._status = pkg.readInt();
         var deadline:Date = pkg.readDate();
         this._battleEndDate = pkg.readDate();
         BombKingManager.instance.status = this._status;
         this.setStartBtnStatus(deadline);
         this.setDateOfNext();
      }
      
      public function setDateOfNext() : void
      {
         var diff:int = 0;
         var m:int = 0;
         var s:int = 0;
         var now:Date = TimeManager.Instance.Now();
         if(BombKingManager.instance.isOpen)
         {
            if(!this._battleEndDate)
            {
               return;
            }
            PositionUtils.setPos(this._timeTxt,"bombKing.timeTxt2");
            diff = int((this._battleEndDate.getTime() - now.getTime()) / 1000);
            m = Math.floor(diff / 60);
            s = diff % 60;
            this._timeTxt.text = LanguageMgr.GetTranslation("bombKing.nextTime",this.fillZero(m),this.fillZero(s),this.getTurnStr());
            if(Boolean(this.nextTimer))
            {
               this.nextTimer.stop();
               this.nextTimer.removeEventListener(TimerEvent.TIMER,this.onNextTimer);
               this.nextTimer = null;
            }
            this.nextTimer = new Timer(1000);
            this.nextTimer.addEventListener(TimerEvent.TIMER,this.onNextTimer);
            this.nextTimer.start();
         }
         else
         {
            this._timeTxt.text = "";
         }
      }
      
      private function getTurnStr() : String
      {
         if(this._battleStage <= 2)
         {
            return this._turn + "/10";
         }
         switch(this._battleStage)
         {
            case 3:
               return "1/4";
            case 4:
               return "2/4";
            case 5:
               return "3/4";
            case 6:
               return "4/4";
            default:
               return "";
         }
      }
      
      private function getDayStr(openDay:int) : String
      {
         switch(openDay)
         {
            case 0:
               return "周日";
            case 1:
               return "周一";
            case 2:
               return "周二";
            case 3:
               return "周三";
            case 4:
               return "周四";
            case 5:
               return "周五";
            case 6:
               return "周六";
            default:
               return " ";
         }
      }
      
      private function __characterComplete(event:Event) : void
      {
         var i:int = 0;
         var figure:Bitmap = null;
         var loader:ShowCharacter = event.target as ShowCharacter;
         loader.removeEventListener(Event.COMPLETE,this.__characterComplete);
         for(i = 0; i <= this._loaderArr.length - 1; i++)
         {
            if(loader == this._loaderArr[i])
            {
               break;
            }
         }
         figure = new Bitmap(new BitmapData(200,170));
         figure.bitmapData.copyPixels(loader.characterBitmapdata,new Rectangle(0,60,200,170),new Point(0,0));
         PositionUtils.setPos(figure,"bombKing.figurePos" + i);
         figure.scaleX = 0.3;
         figure.scaleY = 0.3;
         figure.smoothing = true;
         addToContent(figure);
         this._headImgArr.push(figure);
      }
      
      private function setStartBtnStatus(deadLine:Date) : void
      {
         var now:Date = null;
         var diff:int = 0;
         if(PlayerManager.Instance.Self.Grade < 30)
         {
            this._startBtn.visible = true;
            this._startBtn.enable = false;
            this._firstStageInPlay.visible = false;
            this._secondStageInPlay.visible = false;
            this._finalStageInPlay.visible = false;
            this._battleSoon.visible = false;
            this._remain.visible = false;
            this._tipSprite.visible = true;
            return;
         }
         switch(this._status)
         {
            case 0:
               this._startBtn.visible = true;
               this._startBtn.enable = true;
               this._firstStageInPlay.visible = false;
               this._secondStageInPlay.visible = false;
               this._finalStageInPlay.visible = false;
               this._battleSoon.visible = false;
               this._remain.visible = false;
               this._tipSprite.visible = false;
               break;
            case 1:
               this._startBtn.visible = true;
               this._startBtn.enable = false;
               this._firstStageInPlay.visible = false;
               this._secondStageInPlay.visible = false;
               this._finalStageInPlay.visible = false;
               this._battleSoon.visible = false;
               this._remain.visible = false;
               this._tipSprite.visible = false;
               break;
            case 2:
               this._startBtn.visible = false;
               this._firstStageInPlay.visible = false;
               this._secondStageInPlay.visible = false;
               this._finalStageInPlay.visible = false;
               this._battleSoon.visible = true;
               this._remain.visible = true;
               this._tipSprite.visible = false;
               now = TimeManager.Instance.Now();
               diff = int((deadLine.getTime() - now.getTime()) / 1000);
               this._remain.text = diff.toString();
               if(Boolean(this.remainTimer))
               {
                  this.remainTimer.stop();
                  this.remainTimer.removeEventListener(TimerEvent.TIMER,this.onRemainTimer);
                  this.remainTimer = null;
               }
               this.remainTimer = new Timer(1000);
               this.remainTimer.addEventListener(TimerEvent.TIMER,this.onRemainTimer);
               this.remainTimer.start();
               break;
            case 3:
               this._startBtn.visible = false;
               this._battleSoon.visible = false;
               this._remain.visible = false;
               this._tipSprite.visible = false;
               switch(this._battleStage)
               {
                  case 1:
                     this._firstStageInPlay.visible = true;
                     this._secondStageInPlay.visible = false;
                     this._finalStageInPlay.visible = false;
                     break;
                  case 2:
                     this._firstStageInPlay.visible = false;
                     this._secondStageInPlay.visible = true;
                     this._finalStageInPlay.visible = false;
                     break;
                  case 3:
                  case 4:
                  case 5:
                  case 6:
                     this._firstStageInPlay.visible = false;
                     this._secondStageInPlay.visible = false;
                     this._finalStageInPlay.visible = true;
               }
         }
      }
      
      protected function onNextTimer(event:TimerEvent) : void
      {
         var m:int = 0;
         var s:int = 0;
         var now:Date = TimeManager.Instance.Now();
         var diff:int = int((this._battleEndDate.getTime() - now.getTime()) / 1000);
         if(diff <= 0)
         {
            this.nextTimer.stop();
            this.nextTimer.removeEventListener(TimerEvent.TIMER,this.onRemainTimer);
            this.nextTimer = null;
         }
         else
         {
            m = Math.floor(diff / 60);
            s = diff % 60;
            this._timeTxt.text = LanguageMgr.GetTranslation("bombKing.nextTime",this.fillZero(m),this.fillZero(s),this.getTurnStr());
         }
      }
      
      private function fillZero(num:int) : String
      {
         if(num >= 0 && num <= 9)
         {
            return "0" + num;
         }
         return "" + num;
      }
      
      protected function onRemainTimer(event:TimerEvent) : void
      {
         var remainTime:int = 0;
         if(Boolean(this._remain))
         {
            remainTime = parseInt(this._remain.text);
            if(remainTime <= 0)
            {
               this.remainTimer.stop();
               this.remainTimer.removeEventListener(TimerEvent.TIMER,this.onRemainTimer);
               this.remainTimer = null;
            }
            else
            {
               remainTime--;
               this._remain.text = remainTime.toString();
            }
         }
      }
      
      private function fillRankDic(arr:Array) : void
      {
         var count:int = 0;
         var place:int = 0;
         var j:int = 0;
         var info:BKingPlayerInfo = null;
         var info2:BKingPlayerInfo = null;
         this._rankDic = new Dictionary();
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            this._rankDic[i + 16] = arr[i];
            count = (arr[i] as BKingPlayerInfo).rankType - 2;
            place = i + 16;
            for(j = 0; j <= count - 1; j++)
            {
               place = Math.floor(place / 2);
               info = new BKingPlayerInfo();
               ObjectUtils.copyProperties(info,arr[i]);
               this._rankDic[place] = info;
            }
         }
         for(var l:int = 2; l <= 31; l++)
         {
            if(!this._rankDic[l])
            {
               info2 = new BKingPlayerInfo();
               this._rankDic[l] = info2;
            }
         }
         for(var k:int = 2; k <= 15; k++)
         {
            if(this._rankDic[k].userId != 0)
            {
               if(this._rankDic[2 * k].userId == this._rankDic[k].userId)
               {
                  this._rankDic[2 * k].status = 1;
                  if(this._rankDic[2 * k + 1].userId != 0)
                  {
                     this._rankDic[2 * k + 1].status = -1;
                  }
               }
               else
               {
                  if(this._rankDic[2 * k].userId != 0)
                  {
                     this._rankDic[2 * k].status = -1;
                  }
                  this._rankDic[2 * k + 1].status = 1;
               }
            }
         }
         if(this._top3InfoArr[0].userId != 0)
         {
            if(this._top3InfoArr[0].userId == this._rankDic[2].userId)
            {
               this._rankDic[2].status = 1;
               this._rankDic[3].status = -1;
            }
            else
            {
               this._rankDic[2].status = -1;
               this._rankDic[3].status = 1;
            }
         }
      }
      
      private function updateItems() : void
      {
         var item:BKingPlayerItem = null;
         var loseStamp:Bitmap = null;
         for(var j:int = 0; j <= this._stampArr.length - 1; j++)
         {
            ObjectUtils.disposeObject(this._stampArr[j]);
            this._stampArr[j] = null;
         }
         for(var i:int = 2; i <= 31; i++)
         {
            item = this._itemDic[i] as BKingPlayerItem;
            item.info = this._rankDic[i];
            (this._lineDic[i] as BKingLine).info = this._rankDic[i];
            if(Boolean(this._rankDic[i]) && this._rankDic[i].status == -1)
            {
               loseStamp = ComponentFactory.Instance.creat("bombKing.loseStamp");
               addToContent(loseStamp);
               loseStamp.x = item.x - 15;
               loseStamp.y = item.y - 20;
               this._stampArr.push(loseStamp);
            }
         }
      }
      
      protected function __updateRequest(event:BombKingEvent) : void
      {
         SocketManager.Instance.out.updateBombKingMainFrame();
         SocketManager.Instance.out.updateBombKingBattleLog();
      }
      
      protected function __battleLog(event:BombKingEvent) : void
      {
         var info:BKingLogInfo = null;
         var item:BKingbattleLogItem = null;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         for(var k:int = 0; k <= this._logArr.length - 1; k++)
         {
            ObjectUtils.disposeObject(this._logArr[k]);
            this._logArr[k] = null;
         }
         this._logArr = [];
         for(var i:int = 0; i <= count - 1; i++)
         {
            info = new BKingLogInfo();
            info.stage = pkg.readInt();
            info.userId = pkg.readInt();
            info.areaId = pkg.readInt();
            info.name = pkg.readUTF();
            info.fightId = pkg.readInt();
            info.fightAreaId = pkg.readInt();
            info.fightName = pkg.readUTF();
            info.reportId = pkg.readUTF();
            info.result = pkg.readBoolean();
            item = new BKingbattleLogItem();
            item.info = info;
            this._logVBox.addChild(item);
            this._logArr.push(item);
         }
         this._scrollPanel.invalidateViewport(true);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               if(this._status == 2)
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("bombKing.cancelBattle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  alert.moveEnable = false;
                  alert.addEventListener(FrameEvent.RESPONSE,this._response);
               }
               else
               {
                  this.dispose();
               }
         }
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopPropagation();
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            GameInSocketOut.sendCancelWait();
            this.dispose();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function removeEvents() : void
      {
         if(StageReferance.stage.hasEventListener(MouseEvent.CLICK))
         {
            StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick);
         }
         if(Boolean(this._startBtn))
         {
            this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startBtnClick);
         }
         if(Boolean(this._rankBtn))
         {
            this._rankBtn.removeEventListener(MouseEvent.CLICK,this.__rankBtnClick);
         }
         if(Boolean(this._prizeBtn))
         {
            this._prizeBtn.removeEventListener(MouseEvent.CLICK,this.__prizeBtnClick);
         }
         if(Boolean(this._ruleBtn))
         {
            this._ruleBtn.removeEventListener(MouseEvent.CLICK,this.__ruleBtnClick);
         }
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         SocketManager.Instance.removeEventListener(BombKingEvent.UPDATE_MAIN_FRAME,this.__update);
         SocketManager.Instance.removeEventListener(BombKingEvent.UPDATE_REQUEST,this.__updateRequest);
         SocketManager.Instance.removeEventListener(BombKingEvent.BATTLE_LOG,this.__battleLog);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED,this.__waitGameFailed);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV,this.__waitGameRecv);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         this.removeEvents();
         BombKingManager.instance.frame = null;
         if(this._status == 1)
         {
            GameInSocketOut.sendCancelWait();
         }
         for(i = 0; i <= this._itemArr.length - 1; i++)
         {
            this._itemArr[i].removeEventListener(MouseEvent.CLICK,this.__playerItemClick);
            ObjectUtils.disposeObject(this._itemArr[i]);
            this._itemArr[i] = null;
            ObjectUtils.disposeObject(this._lineArr[i]);
            this._lineArr[i] = null;
         }
         this._itemArr = null;
         this._itemDic = null;
         this._lineArr = null;
         this._lineDic = null;
         for(i = 0; i <= this._stampArr.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._stampArr[i]);
            this._stampArr[i] = null;
         }
         for(i = 0; i <= this._logArr.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._logArr[i]);
            this._logArr[i] = null;
         }
         for(i = 0; i <= this._headImgArr.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._headImgArr[i]);
            this._headImgArr[i] = null;
         }
         for(i = 0; i <= this._top3NameArr.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._top3NameArr[i]);
            this._top3NameArr[i] = null;
         }
         if(Boolean(this._loaderArr))
         {
            for(i = 0; i <= this._loaderArr.length - 1; i++)
            {
               if(Boolean(this._loaderArr[i]))
               {
                  (this._loaderArr[i] as ShowCharacter).removeEventListener(Event.COMPLETE,this.__characterComplete);
                  ObjectUtils.disposeObject(this._loaderArr[i]);
                  this._loaderArr[i] = null;
               }
            }
         }
         if(Boolean(this.remainTimer))
         {
            this.remainTimer.stop();
            this.remainTimer.removeEventListener(TimerEvent.TIMER,this.onRemainTimer);
            this.remainTimer = null;
         }
         if(Boolean(this.nextTimer))
         {
            this.nextTimer.stop();
            this.nextTimer.removeEventListener(TimerEvent.TIMER,this.onRemainTimer);
            this.nextTimer = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._rankBtn);
         this._rankBtn = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._prizeBtn);
         this._prizeBtn = null;
         ObjectUtils.disposeObject(this._ruleBtn);
         this._ruleBtn = null;
         ObjectUtils.disposeObject(this._purpleIcon);
         this._purpleIcon = null;
         ObjectUtils.disposeObject(this._redIcon);
         this._redIcon = null;
         ObjectUtils.disposeObject(this._blueIcon);
         this._blueIcon = null;
         ObjectUtils.disposeObject(this._firstName);
         this._firstName = null;
         ObjectUtils.disposeObject(this._secondName);
         this._secondName = null;
         ObjectUtils.disposeObject(this._thirdName);
         this._thirdName = null;
         ObjectUtils.disposeObject(this._logVBox);
         this._logVBox = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._battleSoon);
         this._battleSoon = null;
         ObjectUtils.disposeObject(this._remain);
         this._remain = null;
         ObjectUtils.disposeObject(this._playerTips);
         this._playerTips = null;
         ObjectUtils.disposeObject(this._firstStageInPlay);
         this._firstStageInPlay = null;
         ObjectUtils.disposeObject(this._secondStageInPlay);
         this._secondStageInPlay = null;
         ObjectUtils.disposeObject(this._finalStageInPlay);
         this._finalStageInPlay = null;
         super.dispose();
      }
   }
}

