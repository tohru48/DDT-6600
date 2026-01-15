package wonderfulActivity.items
{
   import com.gskinner.geom.ColorMatrix;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class AccumulativeItem extends Component implements Disposeable
   {
      
      private var _box:MovieClip;
      
      private var _numberBG:Bitmap;
      
      private var _number:FilterFrameText;
      
      private var _progressPoint:Bitmap;
      
      private var _questionMark:FilterFrameText;
      
      private var glintFilter:GlowFilter;
      
      private var lightFilter:ColorMatrixFilter;
      
      private var grayFilters:Array;
      
      public var index:int;
      
      private var tempfilters:Array = [];
      
      private var glintFlag:Boolean = true;
      
      public function AccumulativeItem()
      {
         super();
         this.initFilter();
      }
      
      private function initFilter() : void
      {
         this.tempfilters = [];
         this.grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         var colorMatrix:ColorMatrix = new ColorMatrix();
         this.lightFilter = new ColorMatrixFilter();
         colorMatrix.adjustColor(50,4,4,2);
         this.lightFilter.matrix = colorMatrix;
      }
      
      public function initView(index:int) : void
      {
         this.index = index;
         this._numberBG = ComponentFactory.Instance.creat("wonderful.accumulative.numberBG");
         addChild(this._numberBG);
         this._questionMark = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.questionMark");
         this._questionMark.text = "?";
         addChild(this._questionMark);
         this._number = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.number");
         this._number.visible = false;
         addChild(this._number);
         this._box = ComponentFactory.Instance.creat("wonderful.accumulative.box");
         PositionUtils.setPos(this._box,"wonderful.Accumulative.boxPos");
         this._box.gotoAndStop(index);
         this._progressPoint = ComponentFactory.Instance.creat("wonderful.accumulative.progress1");
         this._progressPoint.visible = false;
         addChild(this._progressPoint);
         addChild(this._box);
      }
      
      public function lightProgressPoint() : void
      {
         this._progressPoint.visible = true;
      }
      
      public function setNumber(num:int) : void
      {
         this._questionMark.visible = false;
         this._number.visible = true;
         var displayNum:int = 0;
         if(num >= 100000)
         {
            displayNum = Math.floor(num / 10000);
            this._number.text = displayNum.toString() + "w";
         }
         else
         {
            this._number.text = num.toString();
         }
      }
      
      public function turnGray(flag:Boolean) : void
      {
         this.glint(false);
         var tmp:int = int(this.tempfilters.indexOf(this.lightFilter));
         if(tmp >= 0)
         {
            this.tempfilters = [this.lightFilter];
         }
         else
         {
            this.tempfilters = [];
         }
         if(flag)
         {
            this.tempfilters = this.tempfilters.concat(this.grayFilters);
         }
         this._box.filters = this.tempfilters;
      }
      
      public function turnLight(flag:Boolean) : void
      {
         var tmp:int = int(this.tempfilters.indexOf(this.lightFilter));
         if(flag)
         {
            if(tmp == -1)
            {
               this.tempfilters.push(this.lightFilter);
            }
         }
         else if(tmp >= 0)
         {
            this.tempfilters.splice(tmp,1);
         }
         if(Boolean(this.glintFilter))
         {
            this._box.filters = this.tempfilters.concat(this.glintFilter);
         }
         else
         {
            this._box.filters = this.tempfilters;
         }
      }
      
      public function glint(flag:Boolean) : void
      {
         if(flag)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this.glintFilter = new GlowFilter(16768512,1,10,10,2.7,3);
            this._box.filters = this.tempfilters.concat(this.glintFilter);
         }
         else
         {
            if(hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            }
            this._box.filters = this.tempfilters;
            this.glintFilter = null;
         }
      }
      
      private function __enterFrame(event:Event) : void
      {
         if(this.glintFlag)
         {
            this.glintFilter.blurX -= 0.17;
            this.glintFilter.blurY -= 0.17;
            this.glintFilter.strength -= 0.1;
            if(this.glintFilter.blurX < 8)
            {
               this.glintFlag = false;
            }
         }
         else
         {
            this.glintFilter.blurX += 0.17;
            this.glintFilter.blurY += 0.17;
            this.glintFilter.strength += 0.1;
            if(this.glintFilter.blurX > 10)
            {
               this.glintFlag = true;
            }
         }
         this._box.filters = this.tempfilters.concat(this.glintFilter);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._number))
         {
            ObjectUtils.disposeObject(this._number);
         }
         this._number = null;
         if(Boolean(this._numberBG))
         {
            ObjectUtils.disposeObject(this._numberBG);
         }
         this._numberBG = null;
         if(Boolean(this._box))
         {
            ObjectUtils.disposeObject(this._box);
         }
         this._box = null;
         super.dispose();
      }
      
      public function get box() : MovieClip
      {
         return this._box;
      }
   }
}

