package game
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.GameEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.model.MissionAgainInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="giveup",type="ddt.events.GameEvent")]
   [Event(name="tryagain",type="ddt.events.GameEvent")]
   [Event(name="timeOut",type="ddt.events.GameEvent")]
   public class TryAgain extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _tryagain:BaseButton;
      
      private var _giveup:BaseButton;
      
      private var _titleField:FilterFrameText;
      
      private var _valueField:FilterFrameText;
      
      private var _valueBack:DisplayObject;
      
      private var _timer:Timer;
      
      private var _numDic:Dictionary = new Dictionary();
      
      private var _markshape:Shape;
      
      private var _container:Sprite;
      
      private var _buffNote:DisplayObject;
      
      protected var _isShowNum:Boolean;
      
      protected var _info:MissionAgainInfo;
      
      public function TryAgain(info:MissionAgainInfo, isShowNum:Boolean = true)
      {
         this._info = info;
         this._isShowNum = isShowNum;
         super();
         this._timer = new Timer(1000,10);
         if(this._isShowNum)
         {
            this.creatNums();
         }
         this.configUI();
         this.addEvent();
      }
      
      public function show() : void
      {
         if(!RoomManager.Instance.current)
         {
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            switch(GameManager.Instance.TryAgain)
            {
               case GameManager.MissionAgain:
                  this.tryagain(false);
                  break;
               case GameManager.MissionGiveup:
                  this.__giveup(null);
                  break;
               case GameManager.MissionTimeout:
                  this.timeOut();
            }
         }
         else
         {
            this._timer.start();
         }
      }
      
      private function configUI() : void
      {
         this.drawBlack();
         this._container = new Sprite();
         addChild(this._container);
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.back");
         this._container.addChild(this._back);
         this._tryagain = ComponentFactory.Instance.creatComponentByStylename("GameTryAgain");
         if(Boolean(RoomManager.Instance.current))
         {
            this._tryagain.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
         }
         this._container.addChild(this._tryagain);
         this._giveup = ComponentFactory.Instance.creatComponentByStylename("GameGiveUp");
         if(Boolean(RoomManager.Instance.current))
         {
            this._giveup.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
         }
         this._container.addChild(this._giveup);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainTitle");
         this._container.addChild(this._titleField);
         this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.title",this._info.host);
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.titleII",this._info.host);
         }
         this._valueBack = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.text");
         this._container.addChild(this._valueBack);
         this._valueField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainValue");
         this._container.addChild(this._valueField);
         this._markshape = new Shape();
         this._markshape.y = 60;
         if(this._isShowNum && RoomManager.Instance.current && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.drawMark(this._timer.repeatCount);
         }
         this._container.addChild(this._markshape);
         this._container.x = StageReferance.stageWidth - this._container.width >> 1;
         this._container.y = StageReferance.stageHeight - this._container.height >> 1;
         if(RoomManager.Instance.current && RoomManager.Instance.current.selfRoomPlayer.isHost && this._info.hasLevelAgain)
         {
            this.drawLevelAgainBuff();
            this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value",0);
         }
         else
         {
            this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value",this._info.value);
         }
      }
      
      private function drawLevelAgainBuff() : void
      {
         this._buffNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset72.note"));
      }
      
      private function drawBlack() : void
      {
         var pen:Graphics = graphics;
         pen.clear();
         pen.beginFill(0,0.4);
         pen.drawRect(0,0,2000,1000);
         pen.endFill();
      }
      
      private function creatNums() : void
      {
         var bitmap:BitmapData = null;
         for(var i:int = 0; i < 10; i++)
         {
            bitmap = ComponentFactory.Instance.creatBitmapData("asset.game.mark.Blue" + i);
            this._numDic["Blue" + i] = bitmap;
         }
      }
      
      private function addEvent() : void
      {
         this._tryagain.addEventListener(MouseEvent.CLICK,this.__tryagainClick);
         this._giveup.addEventListener(MouseEvent.CLICK,this.__giveup);
         this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
         GameManager.Instance.addEventListener(GameEvent.MISSIONAGAIN,this.__missionAgain);
      }
      
      private function __missionAgain(event:GameEvent) : void
      {
         var result:int = event.data;
         switch(result)
         {
            case GameManager.MissionAgain:
               this.tryagain(false);
               break;
            case GameManager.MissionGiveup:
               this.__giveup(null);
               break;
            case GameManager.MissionTimeout:
               this.timeOut();
         }
      }
      
      private function timeOut() : void
      {
         dispatchEvent(new GameEvent(GameEvent.TIMEOUT,null));
      }
      
      private function __timeComplete(event:TimerEvent) : void
      {
         switch(GameManager.Instance.TryAgain)
         {
            case GameManager.MissionAgain:
               this.tryagain(false);
               break;
            case GameManager.MissionGiveup:
               this.__giveup(null);
               break;
            case GameManager.MissionTimeout:
               this.timeOut();
         }
      }
      
      private function drawMark(count:int) : void
      {
         var bitmap:BitmapData = null;
         var drawStr:String = null;
         var i:int = 0;
         var pen:Graphics = this._markshape.graphics;
         pen.clear();
         var countStr:String = count.toString();
         if(count == 10)
         {
            for(i = 0; i < countStr.length; i++)
            {
               drawStr = "Blue" + countStr.substr(i,1);
               bitmap = this._numDic[drawStr];
               pen.beginBitmapFill(bitmap,new Matrix(1,0,0,1,this._markshape.width));
               pen.drawRect(this._markshape.width,0,bitmap.width,bitmap.height);
               pen.endFill();
            }
            this._markshape.x = (this._back.width - bitmap.width >> 1) - 20;
         }
         else
         {
            bitmap = this._numDic["Blue" + countStr];
            pen.beginBitmapFill(bitmap);
            pen.drawRect(0,0,bitmap.width,bitmap.height);
            pen.endFill();
            this._markshape.x = this._back.width - bitmap.width >> 1;
         }
      }
      
      private function __mark(event:TimerEvent) : void
      {
         SoundManager.instance.play("014");
         if(this._isShowNum)
         {
            this.drawMark(this._timer.repeatCount - this._timer.currentCount);
         }
      }
      
      protected function __tryagainClick(event:MouseEvent) : void
      {
         if(Boolean(event))
         {
            SoundManager.instance.play("008");
         }
         if(GameManager.Instance.Current.selfGamePlayer.hasLevelAgain > 0)
         {
            GameInSocketOut.sendMissionTryAgain(GameManager.MissionAgain,true,false);
            return;
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            if(BuriedManager.Instance.checkMoney(false,this._info.value))
            {
               return;
            }
            GameInSocketOut.sendMissionTryAgain(GameManager.MissionAgain,true,false);
         }
         else
         {
            this.tryagain(false);
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(GameManager.MissionGiveup,true);
         }
      }
      
      protected function tryagain(bool:Boolean = true) : void
      {
         dispatchEvent(new GameEvent(GameEvent.TRYAGAIN,bool));
      }
      
      private function __giveup(event:MouseEvent) : void
      {
         if(Boolean(event))
         {
            SoundManager.instance.play("008");
         }
         dispatchEvent(new GameEvent(GameEvent.GIVEUP,null));
      }
      
      private function removeEvent() : void
      {
         this._tryagain.removeEventListener(MouseEvent.CLICK,this.__tryagainClick);
         this._giveup.removeEventListener(MouseEvent.CLICK,this.__giveup);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeComplete);
         GameManager.Instance.removeEventListener(GameEvent.MISSIONAGAIN,this.__missionAgain);
      }
      
      public function setLabyrinthTryAgain() : void
      {
         this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.titleII",this._info.host);
      }
      
      public function dispose() : void
      {
         var key:String = null;
         this.removeEvent();
         for(key in this._numDic)
         {
            ObjectUtils.disposeObject(this._numDic[key]);
            delete this._numDic[key];
         }
         ObjectUtils.disposeObject(this._buffNote);
         this._buffNote = null;
         ObjectUtils.disposeObject(this._markshape);
         this._markshape = null;
         ObjectUtils.disposeObject(this._valueField);
         this._valueField = null;
         ObjectUtils.disposeObject(this._valueBack);
         this._valueBack = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._giveup);
         this._giveup = null;
         ObjectUtils.disposeObject(this._tryagain);
         this._tryagain = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

