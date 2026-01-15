package LimitAward
{
   import calendar.CalendarManager;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.view.bossbox.TimeTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class LimitAwardButton extends Component
   {
      
      public static const HALL_POINT:int = 0;
      
      public static const PVR_ROOMLIST_POINT:int = 1;
      
      public static const PVP_ROOM_POINT:int = 2;
      
      public static const PVE_ROOMLIST_POINT:int = 3;
      
      public static const PVE_ROOM_POINT:int = 4;
      
      private var _openLimitAward:Sprite;
      
      private var _LimitAwardButton:MovieClip;
      
      private var _delayText:Sprite;
      
      private var timeText:FilterFrameText;
      
      private var _eventActives:Array;
      
      private var timeDiff:int;
      
      private var beginTime:Date;
      
      private var endTime:Date;
      
      private var _pointArray:Vector.<Point>;
      
      private var _timeSprite:TimeTip;
      
      private var _timer:Timer;
      
      private var _taskShineEffect:IEffect;
      
      public function LimitAwardButton(type:int)
      {
         super();
         this.initView(type);
         this.initEvent();
      }
      
      private function initView(type:int) : void
      {
         this._getPoint();
         this.timeDiff = (CalendarManager.getInstance().getShowActiveInfo().end.getTime() - TimeManager.Instance.Now().getTime()) / 1000;
         this._delayText = new Sprite();
         this._openLimitAward = new Sprite();
         this._openLimitAward.graphics.beginFill(0,0);
         this._openLimitAward.graphics.drawRect(75,78,115,70);
         this._openLimitAward.graphics.endFill();
         this._LimitAwardButton = ComponentFactory.Instance.creat("asset.timeBox.LimitAwardButton");
         var timeBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
         this.timeText = ComponentFactory.Instance.creat("LimitAward.TimeBoxStyle");
         addChild(this._LimitAwardButton);
         this._delayText.addChild(timeBG);
         this._delayText.addChild(this.timeText);
         this._timeSprite = ComponentFactory.Instance.creat("LimitAwardBox.TimeTipTwo");
         this._timeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.LimitAwardTip");
         this._timeSprite.setView(this._LimitAwardButton,null);
         this._timeSprite.buttonMode = true;
         addChild(this._timeSprite);
         this._timer = new Timer(1000,int(this.timeDiff));
         this._timer.start();
         if((type == PVE_ROOMLIST_POINT || type == PVR_ROOMLIST_POINT) && this.timeDiff > -1)
         {
            this._LimitAwardButton.x = 3;
            this._LimitAwardButton.y = 15;
            this._delayText.x = 79;
            this._delayText.y = -29;
            this._delayText.width = 130;
         }
         else if((type == PVP_ROOM_POINT || type == PVE_ROOM_POINT) && this.timeDiff > -1)
         {
            this._LimitAwardButton.x = 3;
            this._LimitAwardButton.y = 15;
            this._delayText.x = -30;
            this._delayText.y = 20;
            this._delayText.width = 115;
         }
         else if(type == HALL_POINT && this.timeDiff > -1)
         {
            this._LimitAwardButton.x = 3;
            this._LimitAwardButton.y = 15;
            this._delayText.x = -7;
            this._delayText.y = 32;
            this._delayText.width = 115;
         }
         x = this._pointArray[type].x;
         y = this._pointArray[type].y;
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._timeSprite))
         {
            this._timeSprite.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__complete);
      }
      
      private function timerHandler(evnet:TimerEvent) : void
      {
         this.timeText.text = this.getTimeDiff(this.timeDiff);
         this._timeSprite.tipData = this.getTimeDiff(this.timeDiff);
         --this.timeDiff;
      }
      
      private function __complete(e:TimerEvent) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function getTimeDiff(diff:int) : String
      {
         var d:uint = 0;
         var h:uint = 0;
         var m:uint = 0;
         if(diff >= 0)
         {
            d = Math.floor(diff / 60 / 60 / 24);
            diff %= 60 * 60 * 24;
            h = Math.floor(diff / 60 / 60);
            diff %= 60 * 60;
            m = Math.floor(diff / 60);
         }
         return d + LanguageMgr.GetTranslation("day") + this.fixZero(h) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.hour") + this.fixZero(m) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
      }
      
      private function fixZero(num:uint) : String
      {
         return num < 10 ? "0" + String(num) : String(num);
      }
      
      private function onClick(event:MouseEvent) : void
      {
         CalendarManager.getInstance().qqOpen(CalendarManager.getInstance().getShowActiveInfo().ActiveID);
      }
      
      private function _getPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 5; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("limitAwardButton.point" + i);
            this._pointArray.push(point);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._timeSprite))
         {
            this._timeSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__complete);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._delayText))
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
         if(Boolean(this._openLimitAward))
         {
            ObjectUtils.disposeObject(this._openLimitAward);
         }
         this._openLimitAward = null;
         if(Boolean(this._LimitAwardButton))
         {
            ObjectUtils.disposeObject(this._LimitAwardButton);
         }
         this._LimitAwardButton = null;
         if(Boolean(this.timeText))
         {
            ObjectUtils.disposeObject(this.timeText);
         }
         this.timeText = null;
         if(Boolean(this._timeSprite))
         {
            ObjectUtils.disposeObject(this._timeSprite);
         }
         this._timeSprite = null;
         this._pointArray = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

