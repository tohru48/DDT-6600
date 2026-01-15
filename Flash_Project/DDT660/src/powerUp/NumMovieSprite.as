package powerUp
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class NumMovieSprite extends Sprite implements Disposeable
   {
      
      private var _powerNum:int;
      
      private var _powerString:String;
      
      private var _addPowerNum:int;
      
      private var _allPowerNum:int;
      
      private var _allPowerString:String;
      
      private var _iconArr:Array;
      
      private var _iconArr2:Array;
      
      private var _moveNumArr:Array;
      
      private var _frame:int;
      
      public function NumMovieSprite(powerNum:int, addPowerNum:int)
      {
         super();
         this._powerNum = powerNum;
         this._addPowerNum = addPowerNum;
         this._allPowerNum = this._powerNum + this._addPowerNum;
         this._powerString = String(this._powerNum);
         this._allPowerString = String(this._allPowerNum);
         this._iconArr = new Array();
         this._iconArr2 = new Array();
         this._moveNumArr = new Array();
         this.initView();
         addEventListener(Event.ENTER_FRAME,this.__updateNumHandler);
      }
      
      protected function __updateNumHandler(event:Event) : void
      {
         var num:int = 0;
         var str:String = null;
         var k:int = 0;
         var i:int = 0;
         var num1:int = 0;
         var num2:int = 0;
         var item:MovieClip = null;
         ++this._frame;
         if(this._frame <= 10)
         {
            return;
         }
         if(this._frame > 10 && this._frame < 20)
         {
            str = this._allPowerString.substr(this._allPowerString.length - this._powerString.length,this._powerString.length);
            for(k = this._powerString.length - 1; k >= 0; k--)
            {
               num1 = int(str.charAt(k));
               num2 = int(this._powerString.charAt(k));
               if(num1 < num2)
               {
                  num1 += 10;
               }
               num = num1 - num2;
               this._moveNumArr[k] = num;
            }
            for(i = 0; i < this._iconArr.length; i++)
            {
               if(this._moveNumArr[i] > 0 && this._moveNumArr[i] >= this._frame - 10)
               {
                  (this._iconArr[i] as MovieClip).gotoAndStop(this._frame + 1 - 10);
               }
               else
               {
                  (this._iconArr[i] as MovieClip).stop();
               }
            }
         }
         else
         {
            for each(item in this._iconArr2)
            {
               addChild(item);
            }
            removeEventListener(Event.ENTER_FRAME,this.__updateNumHandler);
         }
      }
      
      private function initView() : void
      {
         var powerNumMc2:MovieClip = null;
         var powerNumMc:MovieClip = null;
         var num:int = this._allPowerString.length - this._powerString.length;
         for(var k:int = 0; k < this._powerString.length; k++)
         {
            powerNumMc2 = ComponentFactory.Instance.creat("num" + this._powerString.charAt(k));
            powerNumMc2.x = 210 + powerNumMc2.width / 1.6 * num + powerNumMc2.width / 1.6 * k;
            powerNumMc2.y = -28;
            addChild(powerNumMc2);
            powerNumMc2.stop();
            this._iconArr.push(powerNumMc2);
            this._moveNumArr.push(0);
         }
         for(var m:int = 0; m < num; m++)
         {
            powerNumMc = ComponentFactory.Instance.creat("num" + this._allPowerString.charAt(m));
            powerNumMc.x = 210 + powerNumMc.width / 1.6 * num - powerNumMc.width / 1.6 * (num - m);
            powerNumMc.y = -28;
            powerNumMc.stop();
            this._iconArr2.push(powerNumMc);
         }
      }
      
      public function dispose() : void
      {
         for(var k:int = 0; k < this._iconArr.length; k++)
         {
            if(Boolean(this._iconArr[k]))
            {
               ObjectUtils.disposeObject(this._iconArr[k]);
               this._iconArr[k] = null;
            }
         }
         this._iconArr = null;
         for(var m:int = 0; m < this._iconArr2.length; m++)
         {
            if(Boolean(this._iconArr2[m]))
            {
               ObjectUtils.disposeObject(this._iconArr2[m]);
               this._iconArr2[m] = null;
            }
         }
         this._iconArr2 = null;
         this._moveNumArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

