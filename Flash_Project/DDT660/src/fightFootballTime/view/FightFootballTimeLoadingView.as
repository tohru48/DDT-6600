package fightFootballTime.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.model.GameInfo;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   import roomLoading.view.RoomLoadingView;
   
   public class FightFootballTimeLoadingView extends RoomLoadingView
   {
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.LevelIcon.Level_";
      
      public static const LOADING_FINISHED:String = "loadingFinished";
      
      private var playerMovie:MovieClip;
      
      private var vsMovie:MovieClip;
      
      private var redIcon:MovieClip;
      
      private var blueIcon:MovieClip;
      
      private var timerMovie:MovieClip;
      
      private var timer:Timer;
      
      private var perecentageTxtArr:Array = [null,null,null,null];
      
      public function FightFootballTimeLoadingView($info:GameInfo)
      {
         FightFootballTimeManager.instance.isInLoading = true;
         super($info);
      }
      
      private function initData() : void
      {
         var roomPlayer:RoomPlayer = null;
         var sex:int = 0;
         var name:String = null;
         var grade:int = 0;
         var len:int = int(_gameInfo.roomPlayers.length);
         var roomPlayers:Array = _gameInfo.roomPlayers;
         for(var i:int = 0; i < len; i++)
         {
            roomPlayer = _gameInfo.roomPlayers[i];
            roomPlayer.position = i + 1;
            sex = roomPlayer.playerInfo.Sex == true ? 0 : 1;
            name = roomPlayer.playerInfo.NickName;
            grade = roomPlayer.playerInfo.Grade;
            this.setPlayerRole(roomPlayer.position,sex);
            this.setLevelAndName(roomPlayer,name,grade);
            roomPlayer.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         }
      }
      
      protected function __onProgress(event:RoomPlayerEvent) : void
      {
         var _perecentageTxt:FilterFrameText = null;
         var _okTxt:Bitmap = null;
         var finishTxt:Function = function():void
         {
            _perecentageTxt.text = "100%";
            removeTxt();
         };
         var removeTxt:Function = function():void
         {
            if(Boolean(_perecentageTxt))
            {
               _perecentageTxt.parent.removeChild(_perecentageTxt);
            }
         };
         var roomPlayer:RoomPlayer = event.currentTarget as RoomPlayer;
         var name:String = roomPlayer.playerInfo.NickName;
         _perecentageTxt = this.perecentageTxtArr[roomPlayer.position - 1];
         if(_perecentageTxt == null)
         {
            return;
         }
         _perecentageTxt.text = String(int(roomPlayer.progress)) + "%";
         if(roomPlayer.progress > 99)
         {
            _okTxt = ComponentFactory.Instance.creatBitmap("asset.roomLoading.LoadingOK");
            PositionUtils.setPos(_okTxt,"fightFootballTime.roomloading.oktxt" + roomPlayer.position);
            addChild(_okTxt);
            roomPlayer.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
            dispatchEvent(new Event(LOADING_FINISHED));
            finishTxt();
         }
      }
      
      override protected function init() : void
      {
         super.init();
         _bg = ComponentFactory.Instance.creatBitmap("fightFootballTime.roomloading.bg");
         this.playerMovie = ComponentFactory.Instance.creat("fightFootballTime.roomloading.playerMovie");
         PositionUtils.setPos(this.playerMovie,"fightFootballTime.rooloading.playerMoviePos");
         this.vsMovie = ComponentFactory.Instance.creat("fightFootballTime.roomloading.vsMovie");
         PositionUtils.setPos(this.vsMovie,"fightFootballTime.rooloading.vsMoviePos");
         this.redIcon = ComponentFactory.Instance.creat("fightFootballTime.roomloading.redIcon");
         PositionUtils.setPos(this.redIcon,"fightFootballTime.rooloading.redIconPos");
         this.blueIcon = ComponentFactory.Instance.creat("fightFootballTime.roomloading.blueIcon");
         PositionUtils.setPos(this.blueIcon,"fightFootballTime.rooloading.blueIconPos");
         this.timerMovie = ComponentFactory.Instance.creat("fightFootballTime.roomloading.timer");
         this.timerMovie.gotoAndStop(this.timerMovie.totalFrames);
         PositionUtils.setPos(this.timerMovie,"fightFootballTime.rooloading.timerMoviePos");
         this.timerMovie.alpha = 0;
         TweenLite.to(this.timerMovie,1,{
            "x":509,
            "y":388,
            "alpha":1,
            "onComplete":function():void
            {
               timer.start();
            }
         });
         this.timer = new Timer(1000,60);
         this.timer.addEventListener(TimerEvent.TIMER,this._timerCount);
         addChild(_bg);
         addChild(this.playerMovie);
         addChild(this.vsMovie);
         addChild(this.blueIcon);
         addChild(this.redIcon);
         addChild(this.timerMovie);
         addChild(_battleField);
         this.initData();
      }
      
      private function _timerCount(e:TimerEvent) : void
      {
         var time:Timer = e.currentTarget as Timer;
         if(Boolean(this.timerMovie))
         {
            this.timerMovie.gotoAndStop(61 - time.currentCount);
         }
      }
      
      private function setPlayerRole(positon:int, sex:int) : void
      {
         if(positon == 1 && sex == 0)
         {
            this.playerMovie.player1.role.gotoAndStop("red_boy");
         }
         else if(positon == 1 && sex == 1)
         {
            this.playerMovie.player1.role.gotoAndStop("red_girl");
         }
         else if(positon == 2 && sex == 0)
         {
            this.playerMovie.player2.role.gotoAndStop("blue_boy");
         }
         else if(positon == 2 && sex == 1)
         {
            this.playerMovie.player2.role.gotoAndStop("blue_girl");
         }
         else if(positon == 3 && sex == 0)
         {
            this.playerMovie.player3.role.gotoAndStop("red_boy");
         }
         else if(positon == 3 && sex == 1)
         {
            this.playerMovie.player3.role.gotoAndStop("red_girl");
         }
         else if(positon == 4 && sex == 0)
         {
            this.playerMovie.player4.role.gotoAndStop("blue_boy");
         }
         else if(positon == 4 && sex == 1)
         {
            this.playerMovie.player4.role.gotoAndStop("blue_girl");
         }
      }
      
      private function setLevelAndName(roomPlayer:RoomPlayer, name:String, level:int) : void
      {
         var icon:Bitmap = this.creatLevelBitmap(level);
         var position:int = roomPlayer.position;
         var _nameTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
         _nameTxt.text = name;
         var _perecentageTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
         _perecentageTxt.text = "0%";
         this.perecentageTxtArr[position - 1] = _perecentageTxt;
         if(position == 1)
         {
            PositionUtils.setPos(icon,"fightFootballTime.rooloading.levelIconPos1");
            PositionUtils.setPos(_nameTxt,"fightFootballTime.rooloading.nameTxtPos1");
            PositionUtils.setPos(_perecentageTxt,"fightFootballTime.rooloading.percentTxtPos1");
            this.playerMovie.player1.addChild(icon);
            this.playerMovie.player1.addChild(_nameTxt);
            this.playerMovie.player1.addChild(_perecentageTxt);
         }
         else if(position == 2)
         {
            PositionUtils.setPos(icon,"fightFootballTime.rooloading.levelIconPos2");
            PositionUtils.setPos(_nameTxt,"fightFootballTime.rooloading.nameTxtPos2");
            PositionUtils.setPos(_perecentageTxt,"fightFootballTime.rooloading.percentTxtPos2");
            this.playerMovie.player2.addChild(icon);
            this.playerMovie.player2.addChild(_nameTxt);
            this.playerMovie.player2.addChild(_perecentageTxt);
         }
         else if(position == 3)
         {
            PositionUtils.setPos(icon,"fightFootballTime.rooloading.levelIconPos3");
            PositionUtils.setPos(_nameTxt,"fightFootballTime.rooloading.nameTxtPos3");
            PositionUtils.setPos(_perecentageTxt,"fightFootballTime.rooloading.percentTxtPos3");
            this.playerMovie.player3.addChild(icon);
            this.playerMovie.player3.addChild(_nameTxt);
            this.playerMovie.player3.addChild(_perecentageTxt);
         }
         else if(position == 4)
         {
            PositionUtils.setPos(icon,"fightFootballTime.rooloading.levelIconPos4");
            PositionUtils.setPos(_nameTxt,"fightFootballTime.rooloading.nameTxtPos4");
            PositionUtils.setPos(_perecentageTxt,"fightFootballTime.rooloading.percentTxtPos4");
            this.playerMovie.player4.addChild(icon);
            this.playerMovie.player4.addChild(_nameTxt);
            this.playerMovie.player4.addChild(_perecentageTxt);
         }
      }
      
      private function creatLevelBitmap(level:int) : Bitmap
      {
         var iconBitmap:Bitmap = ComponentFactory.Instance.creatBitmap(LEVEL_ICON_CLASSPATH + level.toString());
         iconBitmap.smoothing = true;
         return iconBitmap;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this._timerCount);
            this.timer == null;
         }
      }
      
      override public function dispose() : void
      {
         FightFootballTimeManager.instance.isInLoading = false;
         super.dispose();
         if(Boolean(_bg))
         {
            ObjectUtils.disposeObject(_bg);
         }
         _bg = null;
         if(Boolean(this.playerMovie))
         {
            ObjectUtils.disposeObject(this.playerMovie);
         }
         this.playerMovie = null;
         if(Boolean(this.vsMovie))
         {
            ObjectUtils.disposeObject(this.vsMovie);
         }
         this.vsMovie = null;
         if(Boolean(this.redIcon))
         {
            ObjectUtils.disposeObject(this.redIcon);
         }
         this.redIcon = null;
         if(Boolean(this.blueIcon))
         {
            ObjectUtils.disposeObject(this.blueIcon);
         }
         this.blueIcon = null;
         if(Boolean(this.redIcon))
         {
            ObjectUtils.disposeObject(this.redIcon);
         }
         this.redIcon = null;
         if(Boolean(this.timerMovie))
         {
            ObjectUtils.disposeObject(this.timerMovie);
         }
         this.timerMovie = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

