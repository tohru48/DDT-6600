package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BossBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SmallBoxButton extends Sprite implements Disposeable
   {
      
      public static const showTypeWait:int = 1;
      
      public static const showTypeCountDown:int = 2;
      
      public static const showTypeOpenbox:int = 3;
      
      public static const showTypeHide:int = 4;
      
      public static const HALL_POINT:int = 0;
      
      public static const PVR_ROOMLIST_POINT:int = 1;
      
      public static const PVP_ROOM_POINT:int = 2;
      
      public static const PVE_ROOMLIST_POINT:int = 3;
      
      public static const PVE_ROOM_POINT:int = 4;
      
      public static const HOTSPRING_ROOMLIST_POINT:int = 5;
      
      public static const HOTSPRING_ROOM_POINT:int = 6;
      
      private var _closeBox:MovieImage;
      
      private var _openBoxAsset:MovieImage;
      
      private var _openBox:Sprite;
      
      private var _delayText:Sprite;
      
      private var timeText:FilterFrameText;
      
      private var _timeSprite:TimeTip;
      
      private var _pointArray:Vector.<Point>;
      
      public function SmallBoxButton(type:int)
      {
         super();
         this.init(type);
         this.initEvent();
      }
      
      private function init(type:int) : void
      {
         this._getPoint();
         this._delayText = new Sprite();
         this._openBox = new Sprite();
         this._openBox.graphics.beginFill(0,0);
         this._openBox.graphics.drawRect(-22,-2,115,70);
         this._openBox.graphics.endFill();
         this._closeBox = ComponentFactory.Instance.creat("bossbox.closeBox");
         this._openBoxAsset = ComponentFactory.Instance.creat("bossbox.openBox");
         var timeBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
         this.timeText = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
         this._delayText.addChild(timeBG);
         this._delayText.addChild(this.timeText);
         this._timeSprite = ComponentFactory.Instance.creat("TimeBox.TimeTip");
         this._timeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.tipMes");
         this._timeSprite.setView(this._closeBox,this._delayText);
         this._timeSprite.buttonMode = true;
         addChild(this._timeSprite);
         this._openBox.addChild(this._openBoxAsset);
         addChild(this._openBox);
         addChild(this._delayText);
         this.showType(BossBoxManager.instance.boxButtonShowType);
         this.updateTime(BossBoxManager.instance.delaySumTime);
         x = this._pointArray[type].x;
         y = this._pointArray[type].y;
      }
      
      private function _getPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 7; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("smallBoxbutton.point" + i);
            this._pointArray.push(point);
         }
      }
      
      private function initEvent() : void
      {
         this._openBox.buttonMode = true;
         this._openBox.addEventListener(MouseEvent.CLICK,this._click);
         this._timeSprite.addEventListener(MouseEvent.CLICK,this._click);
         BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE,this._updateSmallBoxState);
         BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATETIMECOUNT,this._updateTimeCount);
      }
      
      public function updateTime(second:int) : void
      {
         var _timeSum:int = second;
         var _minute:int = _timeSum / 60;
         var _second:int = _timeSum % 60;
         var str:String = "";
         if(_minute < 10)
         {
            str += "0" + _minute;
         }
         else
         {
            str += _minute;
         }
         str += ":";
         if(_second < 10)
         {
            str += "0" + _second;
         }
         else
         {
            str += _second;
         }
         this.timeText.text = str;
      }
      
      public function showType(value:int) : void
      {
         switch(value)
         {
            case SmallBoxButton.showTypeWait:
               this._timeSprite.closeBox.visible = true;
               this._openBox.visible = false;
               this._timeSprite.delayText.visible = true;
               break;
            case SmallBoxButton.showTypeCountDown:
               this._timeSprite.closeBox.visible = true;
               this._openBox.visible = false;
               this._timeSprite.delayText.visible = true;
               break;
            case SmallBoxButton.showTypeOpenbox:
               this._timeSprite.closeBox.visible = false;
               this._openBox.visible = true;
               this._timeSprite.delayText.visible = false;
               break;
            case SmallBoxButton.showTypeHide:
               this.visible = false;
         }
      }
      
      private function _click(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BossBoxManager.instance.showTimeBox();
      }
      
      private function _updateSmallBoxState(evt:TimeBoxEvent) : void
      {
         this.showType(evt.boxButtonShowType);
      }
      
      private function _updateTimeCount(evt:TimeBoxEvent) : void
      {
         this.updateTime(evt.delaySumTime);
      }
      
      override public function get width() : Number
      {
         return 100;
      }
      
      private function removeEvent() : void
      {
         this._openBox.removeEventListener(MouseEvent.CLICK,this._click);
         this._timeSprite.removeEventListener(MouseEvent.CLICK,this._click);
         BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE,this._updateSmallBoxState);
         BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATETIMECOUNT,this._updateTimeCount);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._closeBox))
         {
            ObjectUtils.disposeObject(this._closeBox);
         }
         this._closeBox = null;
         if(Boolean(this._openBoxAsset))
         {
            ObjectUtils.disposeObject(this._openBoxAsset);
         }
         this._openBoxAsset = null;
         if(Boolean(this._openBox))
         {
            ObjectUtils.disposeObject(this._openBox);
         }
         this._openBox = null;
         if(Boolean(this._delayText))
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
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
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

