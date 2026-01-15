package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class WorldBossCutHpMC extends Sprite
   {
      
      public static const _space:int = 19;
      
      private var _num:Number;
      
      private var _type:int;
      
      private var _numBitmapArr:Array;
      
      public function WorldBossCutHpMC(num:Number)
      {
         super();
         this._num = Math.abs(num);
         this.init();
      }
      
      private function init() : void
      {
         var numBitmap:Bitmap = null;
         this._numBitmapArr = new Array();
         var value:String = this._num.toString();
         var cutBitmap:Bitmap = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum10");
         this._numBitmapArr.push(cutBitmap);
         cutBitmap.alpha = 0;
         cutBitmap.scaleX = 0.5;
         addChild(cutBitmap);
         for(var i:int = 0; i < value.length; i++)
         {
            numBitmap = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum" + value.charAt(i));
            numBitmap.x = _space * (i + 1);
            numBitmap.alpha = 0;
            numBitmap.scaleX = 0.5;
            this._numBitmapArr.push(numBitmap);
            addChild(numBitmap);
         }
         addEventListener(Event.ENTER_FRAME,this.actionOne);
      }
      
      private function actionOne(e:Event) : void
      {
         for(var i:int = 0; i < this._numBitmapArr.length; i++)
         {
            if(this._numBitmapArr[i].alpha >= 1)
            {
               removeEventListener(Event.ENTER_FRAME,this.actionOne);
               setTimeout(this.actionTwo,500);
               return;
            }
            this._numBitmapArr[i].alpha += 0.2;
            this._numBitmapArr[i].scaleX += 0.1;
            this._numBitmapArr[i].x += 2;
            this._numBitmapArr[i].y -= 7;
         }
      }
      
      private function actionTwo() : void
      {
         addEventListener(Event.ENTER_FRAME,this.actionTwoStart);
      }
      
      private function actionTwoStart(e:Event) : void
      {
         for(var i:int = 0; i < this._numBitmapArr.length; i++)
         {
            if(this._numBitmapArr[i].alpha <= 0)
            {
               this.dispose();
               return;
            }
            this._numBitmapArr[i].alpha -= 0.2;
            this._numBitmapArr[i].y -= 7;
         }
      }
      
      private function dispose() : void
      {
         var i:int = 0;
         removeEventListener(Event.ENTER_FRAME,this.actionTwoStart);
         if(Boolean(this._numBitmapArr))
         {
            for(i = 0; i < this._numBitmapArr.length; )
            {
               removeChild(this._numBitmapArr[i]);
               this._numBitmapArr[i] = null;
               this._numBitmapArr.shift();
            }
            this._numBitmapArr = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

