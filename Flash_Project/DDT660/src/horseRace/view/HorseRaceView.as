package horseRace.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import hall.player.vo.PlayerVO;
   import horseRace.controller.HorseRaceManager;
   import horseRace.data.HorseRacePlayerInfo;
   import horseRace.events.HorseRaceEvents;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import road7th.comm.PackageIn;
   
   public class HorseRaceView extends Sprite implements Disposeable
   {
      
      public static const GAME_WIDTH:int = 1000;
      
      private var _backBg:Bitmap;
      
      private var _foreBg:MovieClip;
      
      private var racePlayerList:Array = [];
      
      private var racePlayerPos:FilterFrameText;
      
      private var racePlayerIntPosArr:Array = [];
      
      private var moreLen:int = 17;
      
      private var _selfPlayer:HorseRaceWalkPlayer;
      
      private var _playerInfoView:HorseRacePlayerInfoView;
      
      private var _msgView:HorseRaceMsgView;
      
      private var _buffView:HorseRaceBuffView;
      
      private var maxForeMapWidth:int = 40500;
      
      private var maxRaceLen:int = 40000;
      
      private var headLinePosX:int = 250;
      
      private var buffMsgTxt:FilterFrameText;
      
      private var canRanBySpeedToEND:Boolean = false;
      
      private var selfRanBySpeed:Boolean = false;
      
      private var forBgPos:Number;
      
      private var mycount:uint = 0;
      
      private var _selectBtn:SelectedCheckButton;
      
      private var alert:BaseAlerFrame;
      
      private var canKeyDown:Boolean = true;
      
      private var keyShutTimer:Timer;
      
      private var serverTime:int;
      
      private var _first:Boolean = true;
      
      private var _tenCount:int = 0;
      
      private var gameId:int;
      
      public function HorseRaceView()
      {
         super();
         this.initView();
         this.initEvent();
         InviteManager.Instance.enabled = false;
      }
      
      private function startCountDown(count:int) : void
      {
         var countDown:HorseRaceStartCountDown = new HorseRaceStartCountDown(count);
         LayerManager.Instance.addToLayer(countDown,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function endCountDown(count:int, type:String, _callBack:Function) : void
      {
         var countDown:HorseRaceStartCountDown = new HorseRaceStartCountDown(count,type,_callBack);
         LayerManager.Instance.addToLayer(countDown,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._backBg = ComponentFactory.Instance.creatBitmap("horseRaceView.backBg");
         addChild(this._backBg);
         this.createMap();
         this.racePlayerPos = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.raceView.Pos");
         var t:String = this.racePlayerPos.text;
         this.racePlayerIntPosArr = this.getPosArr(t);
      }
      
      private function addBuffMsg() : void
      {
         this.buffMsgTxt = ComponentFactory.Instance.creat("asset.hall.playerInfo.lblName");
         this.buffMsgTxt.mouseEnabled = false;
         PositionUtils.setPos(this.buffMsgTxt,"horseRace.race.raceView.buffMsgPOS");
         addChild(this.buffMsgTxt);
         this.buffMsgTxt.text = "buff描述:~~~~~~~~~~~~~~";
      }
      
      private function createMap() : void
      {
         var endLine:Bitmap = null;
         var middle:Bitmap = null;
         this._foreBg = new MovieClip();
         var posX:int = this.headLinePosX;
         for(var i:int = 0; i < 40; i++)
         {
            middle = ComponentFactory.Instance.creat("horseRace.raceView.foB");
            middle.x = posX;
            posX += middle.width;
            this._foreBg.addChild(middle);
         }
         var headLine:Bitmap = ComponentFactory.Instance.creat("horseRace.raceView.forA");
         endLine = ComponentFactory.Instance.creat("horseRace.raceView.forC");
         this._foreBg.addChildAt(headLine,this._foreBg.numChildren);
         endLine.x = this.maxForeMapWidth - endLine.width;
         this._foreBg.addChildAt(endLine,this._foreBg.numChildren);
         addChild(this._foreBg);
         this._foreBg.y = -70;
         this._foreBg.height = 674;
      }
      
      private function startRace() : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         for(var i:int = 0; i < this.racePlayerList.length; i++)
         {
            walkingPlayer = this.racePlayerList[i] as HorseRaceWalkPlayer;
            if(walkingPlayer.id == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer = walkingPlayer;
               this._selfPlayer.addEventListener(Event.ENTER_FRAME,this._setSelfCenter);
               this._selfPlayer.gameId = this.gameId;
            }
            else
            {
               walkingPlayer.addEventListener(Event.ENTER_FRAME,this._setOtherPlayerWithSelf);
            }
            walkingPlayer.startRace();
         }
      }
      
      private function _setTimer(e:Timer) : void
      {
      }
      
      private function _setSelfCenter(e:Event) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         var mySpeedIncreace:int = this._selfPlayer.speed / 25;
         if(this._selfPlayer.raceLen >= this.maxRaceLen)
         {
            this._selfPlayer.removeEventListener(Event.ENTER_FRAME,this._setSelfCenter);
            this._selfPlayer.isGetEnd = true;
            this._selfPlayer.stopRace();
            this._selfPlayer.raceLen = this.maxRaceLen;
            this._selfPlayer.x = GAME_WIDTH / 2 + this._selfPlayer.initPosX;
            this.endCountDown(6,"end",this.dispose2);
            return;
         }
         if(this._selfPlayer.raceLen + this._selfPlayer.initPosX < GAME_WIDTH / 2)
         {
            this._selfPlayer.x = this._selfPlayer.raceLen + this._selfPlayer.initPosX;
            this.selfRanBySpeed = true;
         }
         else if(this._selfPlayer.raceLen + this._selfPlayer.initPosX >= GAME_WIDTH / 2 && this._selfPlayer.raceLen + this._selfPlayer.initPosX <= this._foreBg.width - GAME_WIDTH / 2)
         {
            this._selfPlayer.x = GAME_WIDTH / 2;
            this.selfRanBySpeed = false;
         }
         else if(this._selfPlayer.raceLen + this._selfPlayer.initPosX > this._foreBg.width - GAME_WIDTH / 2 && this._selfPlayer.raceLen + this._selfPlayer.initPosX < this._foreBg.width - (GAME_WIDTH / 2 - this._selfPlayer.initPosX))
         {
            this._selfPlayer.x = this._selfPlayer.raceLen + this._selfPlayer.initPosX - (this._foreBg.width - GAME_WIDTH);
            this.selfRanBySpeed = true;
         }
         else if(this._selfPlayer.raceLen + this._selfPlayer.initPosX >= this._foreBg.width - (GAME_WIDTH / 2 - this._selfPlayer.initPosX))
         {
         }
         xf = GAME_WIDTH / 2 - this._selfPlayer.raceLen - this._selfPlayer.initPosX;
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf <= GAME_WIDTH - this._foreBg.width)
         {
            xf = GAME_WIDTH - this._foreBg.width;
            this.canRanBySpeedToEND = true;
         }
         if(xf > 0 && xf <= GAME_WIDTH - this._foreBg.width)
         {
            this.selfRanBySpeed = false;
         }
         this._foreBg.x = xf;
         this.forBgPos = xf;
      }
      
      private function _setOtherPlayerWithSelf(e:Event) : void
      {
         var other:HorseRaceWalkPlayer = e.currentTarget as HorseRaceWalkPlayer;
         ++this.mycount;
         var len:Number = other.raceLen - this._selfPlayer.raceLen;
         var len1:int = (other.speed - this._selfPlayer.speed) / 25;
         var otherSpeedIncreate:int = other.speed / 25;
         if(this.mycount > 25)
         {
            this.getRankByRaceLen();
            this.mycount = 0;
         }
         if(this.canRanBySpeedToEND)
         {
            if(other.x < this._selfPlayer.x)
            {
               other.x += other.speed / 25;
               if(other.x >= this._selfPlayer.x)
               {
                  other.isGetEnd = true;
                  other.x = this._selfPlayer.x;
                  other.removeEventListener(Event.ENTER_FRAME,this._setOtherPlayerWithSelf);
                  other.stopRace();
                  this.mycount = 0;
               }
            }
            else if(other.x > this._selfPlayer.x)
            {
               other.x += other.speed / 25;
               if(other.raceLen >= this.maxRaceLen)
               {
                  other.isGetEnd = true;
                  other.x = GAME_WIDTH / 2 + other.initPosX;
                  other.removeEventListener(Event.ENTER_FRAME,this._setOtherPlayerWithSelf);
                  other.stopRace();
                  this.mycount = 0;
               }
            }
            return;
         }
         if(other.raceLen >= this.maxRaceLen)
         {
            other.raceLen = this.maxRaceLen;
            other.isGetEnd = true;
            return;
         }
         other.x = this._selfPlayer.x + len;
      }
      
      private function getPosArr(str:String) : Array
      {
         var str2:String = null;
         var arr3:Array = null;
         var x:int = 0;
         var y:int = 0;
         var pos:Point = null;
         if(str == "" || str == null)
         {
            return null;
         }
         var arr:Array = str.split("|");
         var arr1:Array = [];
         for(var i:int = 0; i < arr.length; i++)
         {
            str2 = arr[i];
            arr3 = str2.split(",");
            x = int(arr3[0]);
            y = int(arr3[1]);
            pos = new Point(x,y);
            arr1.push(pos);
         }
         return arr1;
      }
      
      public function addPlayer(playerInfo:PlayerInfo, raceIndex:int, $speed:int) : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var playerVo:PlayerVO = new PlayerVO();
         playerVo.playerInfo = playerInfo;
         playerInfo.MountsType = Math.max(1,playerInfo.MountsType);
         playerInfo.PetsID = 0;
         walkingPlayer = new HorseRaceWalkPlayer(playerVo,this.callBack);
         walkingPlayer.index = raceIndex;
         walkingPlayer.rank = raceIndex + 1;
         walkingPlayer.speed = $speed;
         walkingPlayer.id = playerInfo.ID;
         if(walkingPlayer.id == PlayerManager.Instance.Self.ID)
         {
            walkingPlayer.isSelf = true;
         }
         else
         {
            walkingPlayer.isSelf = false;
         }
         var pos:Point = this.racePlayerIntPosArr[raceIndex];
         walkingPlayer.playerPoint = pos;
         walkingPlayer.initPosX = pos.x;
         addChild(walkingPlayer);
         this.racePlayerList.push(walkingPlayer);
         walkingPlayer.stand();
      }
      
      private function removePlayer(raceIndex:int) : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = this.racePlayerList[raceIndex] as HorseRaceWalkPlayer;
         walkingPlayer.stop();
         removeChild(walkingPlayer);
      }
      
      private function removeAllPlayer() : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         if(this.racePlayerList == null)
         {
            return;
         }
         for(var i:int = 0; i < this.racePlayerList.length; i++)
         {
            walkingPlayer = this.racePlayerList[i] as HorseRaceWalkPlayer;
            if(walkingPlayer.id == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer.removeEventListener(Event.ENTER_FRAME,this._setSelfCenter);
            }
            else
            {
               walkingPlayer.removeEventListener(Event.ENTER_FRAME,this._setOtherPlayerWithSelf);
            }
            walkingPlayer.stop();
            removeChild(walkingPlayer);
            walkingPlayer.dispose();
         }
         this.racePlayerList = null;
      }
      
      private function findPlayerByID(id:int) : HorseRaceWalkPlayer
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         for(var i:int = 0; i < this.racePlayerList.length; i++)
         {
            walkingPlayer = this.racePlayerList[i] as HorseRaceWalkPlayer;
            if(walkingPlayer.id == id)
            {
               return walkingPlayer;
            }
         }
         return null;
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
         }
      }
      
      private function initEvent() : void
      {
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_INITPLAYER,this._initPlayerInfo);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_START_FIVE,this._startFiveCountDown);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_BEGIN_RACE,this._beginRace);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_PLAYERSPEED_CHANGE,this._speedChange);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_RACE_END,this._raceEnd);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_ALLPLAYER_RACEEND,this._allRaceEnd);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_SYN_ONESECOND,this._synonesecond);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_BUFF_ITEMFLUSH,this._buffItem_flush);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_SHOW_MSG,this._show_msg);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_USE_PINGZHANG,this._use_pingzhang);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         HorseRaceManager.Instance.addEventListener(HorseRaceEvents.HORSERACE_USE_DAOJU,this._use_daoju);
      }
      
      private function removeEvent() : void
      {
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_INITPLAYER,this._initPlayerInfo);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_START_FIVE,this._startFiveCountDown);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_BEGIN_RACE,this._beginRace);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_PLAYERSPEED_CHANGE,this._speedChange);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_RACE_END,this._raceEnd);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_ALLPLAYER_RACEEND,this._allRaceEnd);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_SYN_ONESECOND,this._synonesecond);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_BUFF_ITEMFLUSH,this._buffItem_flush);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_SHOW_MSG,this._show_msg);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_USE_PINGZHANG,this._use_pingzhang);
         HorseRaceManager.Instance.removeEventListener(HorseRaceEvents.HORSERACE_USE_DAOJU,this._use_daoju);
         if(Boolean(this.keyShutTimer))
         {
            this.keyShutTimer.stop();
            this.keyShutTimer.removeEventListener(TimerEvent.TIMER,this._keyShut);
            this.keyShutTimer = null;
         }
      }
      
      private function _use_pingzhang(e:HorseRaceEvents) : void
      {
         var price:int = 0;
         var content:String = null;
         if(HorseRaceManager.Instance.showPingzhangBuyFram)
         {
            price = ServerConfigManager.instance.HorseGameUsePapawMoney;
            content = LanguageMgr.GetTranslation("horseRace.match.usePingzhangDescription",price);
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
            SocketManager.Instance.out.sendHorseRaceItemUse2(this._selfPlayer.gameId,this._selfPlayer.id);
         }
      }
      
      private function __onRecoverResponse(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var price:int = ServerConfigManager.instance.HorseGameUsePapawMoney;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < price)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendHorseRaceItemUse2(this._selfPlayer.gameId,this._selfPlayer.id);
         }
         else if(e.responseCode == FrameEvent.CANCEL_CLICK || e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            HorseRaceManager.Instance.showPingzhangBuyFram = true;
         }
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
         if(Boolean(this._selectBtn))
         {
            this._selectBtn.removeEventListener(MouseEvent.CLICK,this.__onClickSelectedBtn);
         }
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      private function __onClickSelectedBtn(e:MouseEvent) : void
      {
         HorseRaceManager.Instance.showPingzhangBuyFram = !this._selectBtn.selected;
      }
      
      private function _use_daoju(e:HorseRaceEvents) : void
      {
         var type:int = int(e.data);
         if(type == 1)
         {
            if(this._buffView.buffItemType1 != 0)
            {
               SocketManager.Instance.out.sendHorseRaceItemUse(this._selfPlayer.gameId,this._buffView.buffItemType1,this._selfPlayer.id,this._playerInfoView.selectItemId);
            }
         }
         else if(type == 2)
         {
            if(this._buffView.buffItemType2 != 0)
            {
               SocketManager.Instance.out.sendHorseRaceItemUse(this._selfPlayer.gameId,this._buffView.buffItemType2,this._selfPlayer.id,this._playerInfoView.selectItemId);
            }
         }
      }
      
      private function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_1.getCode():
               if(this._buffView.buffItemType1 != 0)
               {
                  SocketManager.Instance.out.sendHorseRaceItemUse(this._selfPlayer.gameId,this._buffView.buffItemType1,this._selfPlayer.id,this._playerInfoView.selectItemId);
               }
               break;
            case KeyStroke.VK_2.getCode():
               if(this._buffView.buffItemType2 != 0)
               {
                  SocketManager.Instance.out.sendHorseRaceItemUse(this._selfPlayer.gameId,this._buffView.buffItemType2,this._selfPlayer.id,this._playerInfoView.selectItemId);
               }
         }
      }
      
      private function _keyShut(e:TimerEvent) : void
      {
         this.canKeyDown = true;
      }
      
      private function _show_msg(e:HorseRaceEvents) : void
      {
         var pkg:PackageIn = e.data as PackageIn;
         var who:String = pkg.readUTF();
         var target:String = pkg.readUTF();
         var itemName:String = pkg.readUTF();
         var msg:String = LanguageMgr.GetTranslation("horseRace.raceView.msgTxt",who,target,itemName);
         this._msgView.addMsg(msg);
      }
      
      private function _buffItem_flush(e:HorseRaceEvents) : void
      {
         var pkg:PackageIn = e.data as PackageIn;
         var buffItem1:int = pkg.readInt();
         var buffItem2:int = pkg.readInt();
         this._buffView.buffItemType1 = buffItem1;
         this._buffView.buffItemType2 = buffItem2;
         var pingzhangSuccess:Boolean = pkg.readBoolean();
         this._buffView.pingzhangUseSuccess = pingzhangSuccess;
         if(pingzhangSuccess)
         {
            this._buffView.showPingzhangDaojishi();
         }
      }
      
      private function _synonesecond(e:HorseRaceEvents) : void
      {
         var id:int = 0;
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var rank:int = 0;
         var raceLen2:int = 0;
         var serverRaceLen:int = 0;
         var raceDic:int = 0;
         var msg:String = null;
         var msg1:String = null;
         var msg2:String = null;
         var buffCount:int = 0;
         var buffList:Array = null;
         var j:int = 0;
         var buffType:int = 0;
         var pkg:PackageIn = e.data as PackageIn;
         var timeSyn:int = pkg.readInt();
         this._buffView.timeSyn = timeSyn;
         this._buffView.flushBuffItem();
         ++this._tenCount;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            walkingPlayer = this.findPlayerByID(id);
            pkg.readInt();
            rank = pkg.readInt();
            if(rank != 0)
            {
               walkingPlayer.rank = rank;
               walkingPlayer.isRankByCilent = false;
            }
            raceLen2 = walkingPlayer.raceLen;
            serverRaceLen = pkg.readInt();
            raceDic = serverRaceLen - raceLen2;
            msg = walkingPlayer.id + "客：" + raceLen2 + "服：" + serverRaceLen + "差：" + raceDic;
            if(serverRaceLen > this.maxRaceLen)
            {
               serverRaceLen = this.maxRaceLen;
            }
            if(this._tenCount > 5)
            {
               walkingPlayer.raceLen = serverRaceLen;
            }
            msg1 = walkingPlayer.id + "原：" + walkingPlayer.speed + "----" + walkingPlayer.raceLen;
            msg2 = walkingPlayer.id + "改：" + walkingPlayer.speed + "----" + walkingPlayer.raceLen;
            walkingPlayer.isGoToEnd = pkg.readBoolean();
            buffCount = pkg.readInt();
            buffList = [];
            for(j = 0; j < buffCount; j++)
            {
               buffType = pkg.readByte();
               buffList.push(buffType);
               pkg.readInt();
               pkg.readInt();
               pkg.readInt();
            }
            if(walkingPlayer.isGoToEnd)
            {
               buffList = [];
            }
            walkingPlayer.buffList = buffList;
         }
         this.getRankByRaceLen();
         this._playerInfoView.flushBuffList();
         this._first = false;
      }
      
      public function getRankByRaceLen() : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var walkingPlayer1:HorseRaceWalkPlayer = null;
         var walkingPlayer2:HorseRaceWalkPlayer = null;
         var k:int = 0;
         var temp:HorseRaceWalkPlayer = null;
         var walkRank:int = 0;
         var p:int = 0;
         var raceLenList:Array = [];
         var raceLenUnRank:Array = [];
         for(var i:int = 0; i < this.racePlayerList.length; i++)
         {
            walkingPlayer = this.racePlayerList[i] as HorseRaceWalkPlayer;
            if(walkingPlayer.isRankByCilent)
            {
               raceLenList.push(walkingPlayer);
            }
            else
            {
               raceLenUnRank.push(walkingPlayer);
            }
         }
         for(var j:int = 0; j < raceLenList.length; j++)
         {
            for(k = j; k < raceLenList.length; k++)
            {
               if(raceLenList[j].raceLen < raceLenList[k].raceLen)
               {
                  temp = raceLenList[j];
                  raceLenList[j] = raceLenList[k];
                  raceLenList[k] = temp;
               }
            }
         }
         var myRankList:Array = [0,0,0,0,0];
         for(var n:int = 0; n < raceLenUnRank.length; n++)
         {
            walkingPlayer2 = raceLenUnRank[n] as HorseRaceWalkPlayer;
            walkRank = walkingPlayer2.rank;
            myRankList[walkRank - 1] = walkingPlayer2;
         }
         for(var m:int = 0; m < raceLenList.length; m++)
         {
            walkingPlayer1 = raceLenList[m] as HorseRaceWalkPlayer;
            for(p = 0; p < myRankList.length; p++)
            {
               if(myRankList[p] == 0)
               {
                  myRankList[p] = walkingPlayer1;
                  walkingPlayer1.rank = p + 1;
                  break;
               }
            }
         }
      }
      
      public function getRankByRaceLen2(arr:Array) : Array
      {
         var temp:int = 0;
         var j:int = 0;
         for(var i:int = 0; i < arr.length; i++)
         {
            for(j = i; j < arr.length; j++)
            {
               if(arr[i] < arr[j])
               {
                  temp = int(arr[i]);
                  arr[i] = arr[j];
                  arr[j] = temp;
               }
            }
         }
         return arr;
      }
      
      private function _allRaceEnd(e:HorseRaceEvents) : void
      {
         var id:int = 0;
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var pkg:PackageIn = e.data as PackageIn;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            walkingPlayer = this.findPlayerByID(id);
         }
      }
      
      private function _raceEnd(e:HorseRaceEvents) : void
      {
         var id:int = 0;
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var pkg:PackageIn = e.data as PackageIn;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            walkingPlayer = this.findPlayerByID(id);
         }
      }
      
      private function _speedChange(e:HorseRaceEvents) : void
      {
         var id:int = 0;
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var speed:int = 0;
         var pkg:PackageIn = e.data as PackageIn;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            walkingPlayer = this.findPlayerByID(id);
            speed = pkg.readInt();
            walkingPlayer.speed = speed;
         }
      }
      
      private function _beginRace(e:HorseRaceEvents) : void
      {
         this.startRace();
      }
      
      private function _startFiveCountDown(e:HorseRaceEvents) : void
      {
         var pkg:PackageIn = e.data as PackageIn;
         var count:int = pkg.readInt();
         this.startCountDown(count / 1000);
      }
      
      private function _initPlayerInfo(e:HorseRaceEvents) : void
      {
         var info:HorseRacePlayerInfo = null;
         this.racePlayerList = [];
         var pkg:PackageIn = e.data as PackageIn;
         this.gameId = pkg.readInt();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            info = new HorseRacePlayerInfo();
            info.ID = pkg.readInt();
            info.NickName = pkg.readUTF();
            info.Sex = pkg.readBoolean();
            info.Hide = pkg.readInt();
            info.Style = pkg.readUTF();
            info.Colors = pkg.readUTF();
            info.Skin = pkg.readUTF();
            info.Grade = pkg.readInt();
            info.horseRaceIndex = pkg.readInt();
            info.horseRaceSpeed = pkg.readInt();
            info.MountsType = pkg.readInt();
            this.addPlayer(info,info.horseRaceIndex - 1,info.horseRaceSpeed);
         }
         this.initPlayerInfoView();
         this.initMsgView();
         this.initBuffView();
      }
      
      private function initBuffView() : void
      {
         this._buffView = new HorseRaceBuffView();
         PositionUtils.setPos(this._buffView,"horseRace.raceView.buffViewPos");
         addChild(this._buffView);
      }
      
      private function initMsgView() : void
      {
         this._msgView = new HorseRaceMsgView();
         PositionUtils.setPos(this._msgView,"horseRace.raceView.msgViewPos");
         addChild(this._msgView);
      }
      
      private function initPlayerInfoView() : void
      {
         var walkingPlayer:HorseRaceWalkPlayer = null;
         var itemView:HorseRacePlayerItemView = null;
         this._playerInfoView = new HorseRacePlayerInfoView();
         PositionUtils.setPos(this._playerInfoView,"horseRace.raceView.playerInfoViewPos");
         addChild(this._playerInfoView);
         for(var i:int = 0; i < this.racePlayerList.length; i++)
         {
            walkingPlayer = this.racePlayerList[i] as HorseRaceWalkPlayer;
            itemView = new HorseRacePlayerItemView(walkingPlayer);
            this._playerInfoView.addPlayerItem(itemView);
         }
      }
      
      public function dispose2() : void
      {
         KeyboardShortcutsManager.Instance.cancelForbidden();
         if(Boolean(this.alert))
         {
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
            ObjectUtils.disposeObject(this.alert);
         }
         SocketManager.Instance.out.sendHorseRaceEnd(this._selfPlayer.gameId,this._selfPlayer.id);
         this.removeAllPlayer();
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         InviteManager.Instance.enabled = true;
      }
      
      public function dispose() : void
      {
         KeyboardShortcutsManager.Instance.cancelForbidden();
         if(Boolean(this.alert))
         {
            this.alert.removeEventListener(FrameEvent.RESPONSE,this.__onRecoverResponse);
            ObjectUtils.disposeObject(this.alert);
         }
         this.removeAllPlayer();
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         InviteManager.Instance.enabled = true;
      }
   }
}

