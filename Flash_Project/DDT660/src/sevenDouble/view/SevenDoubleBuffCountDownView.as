package sevenDouble.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SevenDoubleBuffCountDownView extends Sprite implements Disposeable
   {
      
      public static const END:String = "SevenDoubleBuffCountDownEnd";
      
      private var _bg:Bitmap;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _titleTxt:FilterFrameText;
      
      private var _endTime:Date;
      
      private var _timer:Timer;
      
      private var _type:int;
      
      private const colorList:Array = [16711680,1813759,59158];
      
      public function SevenDoubleBuffCountDownView(endTime:Date, type:int, index:int)
      {
         super();
         if(type == 3)
         {
            this.x = 5;
         }
         else
         {
            this.x = -143;
         }
         this.y = -138;
         this._endTime = endTime;
         this._type = type;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.buffCountDownBg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.game.buffTitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("sevenDouble.game.buffTitleTxt" + this._type);
         this._titleTxt.textColor = this.colorList[this._type - 1];
         this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.game.buffCountDownTxt");
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._countDownTxt);
         this.refreshTxt(null);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.refreshTxt,false,0,true);
         this._timer.start();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set endTime(value:Date) : void
      {
         this._endTime = value;
         this.refreshTxt(null);
      }
      
      private function refreshTxt(event:TimerEvent) : void
      {
         var endTimestamp:Number = this._endTime.getTime();
         var nowTimestamp:Number = TimeManager.Instance.Now().getTime();
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var minute:int = differ / TimeManager.Minute_TICKS;
         var second:int = differ % TimeManager.Minute_TICKS / 1000;
         var minStr:String = minute < 10 ? "0" + minute : minute.toString();
         var secStr:String = second < 10 ? "0" + second : second.toString();
         this._countDownTxt.text = minStr + ":" + secStr;
         this._countDownTxt.textColor = this.colorList[this._type - 1];
         if(second <= 0)
         {
            dispatchEvent(new Event(END));
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.refreshTxt);
            this._timer.stop();
         }
         this._timer = null;
         this._endTime = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTxt = null;
         this._countDownTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

