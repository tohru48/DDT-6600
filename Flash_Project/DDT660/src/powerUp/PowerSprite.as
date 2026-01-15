package powerUp
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PowerSprite extends Sprite implements Disposeable
   {
      
      private var _powerBgMc:MovieClip;
      
      private var _greenAddIcon:MovieClip;
      
      private var _lineMc1:MovieClip;
      
      private var _frameNum:int;
      
      private var _addPowerNum:int;
      
      private var _powerNum:int;
      
      private var _numMovieSprite:NumMovieSprite;
      
      private var _greenIconArr:Array;
      
      public function PowerSprite(powerNum:int, addPowerNum:int)
      {
         super();
         if(powerNum < 0)
         {
            powerNum = 0;
         }
         if(addPowerNum < 0)
         {
            addPowerNum = 0;
         }
         this._powerNum = powerNum;
         this._addPowerNum = addPowerNum;
         this._greenIconArr = new Array();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var powerNumMc:MovieClip = null;
         this._powerBgMc = ComponentFactory.Instance.creat("powerBg");
         this._powerBgMc.x = 30;
         this._powerBgMc.y = 200;
         addChild(this._powerBgMc);
         this._lineMc1 = ComponentFactory.Instance.creat("powerLine");
         this._greenAddIcon = ComponentFactory.Instance.creat("greenAddIcon");
         var addPowerString:String = String(this._addPowerNum);
         this._greenIconArr.push(this._greenAddIcon);
         this._greenIconArr[0].x = 270;
         this._greenIconArr[0].y = -23;
         this._greenIconArr[0].alpha = 0;
         this._powerBgMc.addChild(this._greenIconArr[0]);
         for(var k:int = 0; k < addPowerString.length; k++)
         {
            powerNumMc = ComponentFactory.Instance.creat("greenNum" + addPowerString.charAt(k));
            powerNumMc.x = 290 + powerNumMc.width / 1.1 * k;
            powerNumMc.y = -28;
            powerNumMc.alpha = 0;
            this._powerBgMc.addChild(powerNumMc);
            this._greenIconArr.push(powerNumMc);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.__updatePowerMcHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__updatePowerMcHandler);
      }
      
      protected function __updatePowerMcHandler(event:Event) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(this._frameNum < 41)
         {
            ++this._frameNum;
            if(this._frameNum > 5 && this._frameNum < 25)
            {
               if(this._frameNum == 15)
               {
                  this._numMovieSprite = new NumMovieSprite(this._powerNum,this._addPowerNum);
                  this._powerBgMc.addChild(this._numMovieSprite);
               }
               for(i = 0; i < this._greenIconArr.length; i++)
               {
                  (this._greenIconArr[i] as MovieClip).y -= 4;
                  (this._greenIconArr[i] as MovieClip).alpha += 0.05;
               }
            }
            else if(this._frameNum > 26 && this._frameNum < 37)
            {
               for(j = 0; j < this._greenIconArr.length; j++)
               {
                  (this._greenIconArr[j] as MovieClip).y -= 3;
                  (this._greenIconArr[j] as MovieClip).alpha -= 0.1;
               }
            }
            else if(this._frameNum == 40)
            {
               this._lineMc1.x = this._powerBgMc.x - 20;
               this._lineMc1.y = this._powerBgMc.y - 73;
               addChild(this._lineMc1);
            }
         }
         else
         {
            dispatchEvent(new Event(PowerUpMovieManager.POWER_UP_MOVIE_OVER));
            this.removeEvent();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._powerBgMc);
         this._powerBgMc = null;
         ObjectUtils.disposeObject(this._lineMc1);
         this._lineMc1 = null;
         for(var k:int = 0; k < this._greenIconArr.length; k++)
         {
            if(Boolean(this._greenIconArr[k]))
            {
               ObjectUtils.disposeObject(this._greenIconArr[k]);
               this._greenIconArr[k] = null;
            }
         }
         this._greenIconArr = null;
         ObjectUtils.disposeObject(this._numMovieSprite);
         this._numMovieSprite = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

