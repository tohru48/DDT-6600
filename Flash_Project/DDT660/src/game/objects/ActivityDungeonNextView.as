package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ActivityDungeonNextView extends Sprite
   {
      
      private var ACTIVITYDUNGEONPOINTSNUM:String = "asset.game.nextView.count_";
      
      private var _bg:Bitmap;
      
      private var _nextBtn:BaseButton;
      
      private var _pointsNum:Sprite;
      
      private var _numBitmapArray:Array;
      
      private var _cdData:Number = 0;
      
      private var _timer:Timer;
      
      private var _id:int;
      
      private var _offX:int = 8;
      
      public function ActivityDungeonNextView(id:int, time:Number)
      {
         super();
         this._id = id;
         this._cdData = (time - TimeManager.Instance.Now().time) / 1000;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         mouseChildren = true;
         this._bg = ComponentFactory.Instance.creat("asset.game.nextView.bg");
         addChild(this._bg);
         this._nextBtn = ComponentFactory.Instance.creat("activyDungeon.nextView.btn");
         addChild(this._nextBtn);
         this._pointsNum = new Sprite();
         PositionUtils.setPos(this._pointsNum,"game.view.activityDungeonNextView.pointsNumPos");
         addChild(this._pointsNum);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this._timer.start();
         this.setCountDownNumber(this._cdData);
      }
      
      protected function __onTimer(event:TimerEvent) : void
      {
         if(this._cdData > 0)
         {
            --this._cdData;
            this.setCountDownNumber(this._cdData);
         }
         else
         {
            this._timer.stop();
            this.visible = false;
         }
      }
      
      private function setCountDownNumber(points:int) : void
      {
         var bitmap:Bitmap = null;
         var pointsStr:String = String("0" + Math.floor(points)).substr(-2);
         var num:String = "";
         this.deleteBitmapArray();
         this._numBitmapArray = new Array();
         for(var i:int = 0; i < pointsStr.length; i++)
         {
            num = pointsStr.charAt(i);
            bitmap = ComponentFactory.Instance.creatBitmap(this.ACTIVITYDUNGEONPOINTSNUM + num);
            bitmap.x = bitmap.bitmapData.width * i - (i == 0 ? 0 : this._offX);
            this._pointsNum.addChild(bitmap);
            this._numBitmapArray.push(bitmap);
         }
      }
      
      private function deleteBitmapArray() : void
      {
         var i:int = 0;
         if(Boolean(this._numBitmapArray))
         {
            for(i = 0; i < this._numBitmapArray.length; i++)
            {
               this._numBitmapArray[i].bitmapData.dispose();
               this._numBitmapArray[i] = null;
            }
            this._numBitmapArray.length = 0;
            this._numBitmapArray = null;
         }
      }
      
      private function initEvent() : void
      {
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      public function setBtnEnable() : void
      {
         this._nextBtn.enable = false;
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         this._timer.stop();
         SocketManager.Instance.out.sendActivityDungeonNextPoints(this._id,true);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         this.deleteBitmapArray();
         if(Boolean(this._pointsNum))
         {
            this._pointsNum = null;
         }
         if(Boolean(this._timer))
         {
            this._timer.reset();
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
      }
      
      public function get Id() : int
      {
         return this._id;
      }
   }
}

