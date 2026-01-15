package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   
   public class ShootPercentView extends Sprite
   {
      
      private var _type:int;
      
      private var _isAdd:Boolean;
      
      private var _picBmp:Bitmap;
      
      private var add:Boolean = true;
      
      private var tmp:int = 0;
      
      public function ShootPercentView(n:int, type:int = 1, isadd:Boolean = false)
      {
         super();
         this._type = type;
         this._isAdd = isadd;
         this._picBmp = this.getPercent(n);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp != null)
         {
            addChild(this._picBmp);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._picBmp))
         {
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._picBmp.bitmapData.dispose();
            removeChild(this._picBmp);
            this._picBmp = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __addToStage(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp == null)
         {
            return;
         }
         if(this._type == 1)
         {
            this._picBmp.x = -70;
            this._picBmp.y = -20;
         }
         else
         {
            this._picBmp.scaleY = 0.5;
            this._picBmp.scaleX = 0.5;
         }
         this._picBmp.alpha = 0;
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(evt:Event) : void
      {
         if(this._type == 1)
         {
            this.doShowType1();
         }
         else
         {
            this.doShowType2();
         }
      }
      
      private function doShowType1() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.y -= 8;
               this._picBmp.alpha += 0.22;
            }
            else
            {
               this._picBmp.y -= 6;
               this._picBmp.alpha -= 0.1;
            }
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      private function doShowType2() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.24;
               this._picBmp.alpha += 0.4;
            }
            else
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.125;
               this._picBmp.alpha -= 0.15;
            }
            this._picBmp.x = -this._picBmp.width / 2 + 10;
            this._picBmp.y = -this._picBmp.height / 2;
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      public function getPercent(n:int) : Bitmap
      {
         var numArr:Array = null;
         var addIcon:Bitmap = null;
         var bm:Bitmap = null;
         var b:Bitmap = null;
         if(n > 99999999)
         {
            return null;
         }
         var numberContainer:Sprite = new Sprite();
         numArr = new Array();
         numArr = [0,0,0,0];
         numberContainer.mouseEnabled = false;
         numberContainer.mouseChildren = false;
         if(this._type == 2)
         {
            if(!this._isAdd)
            {
               bm = ComponentFactory.Instance.creatBitmap("asset.game.redNumberBackgoundAsset") as Bitmap;
               bm.x += 5;
               bm.y = -10;
               numArr.push(bm);
            }
         }
         var s:String = String(n);
         var len:int = s.length;
         var xpos:int = 33 + (4 - len) * 10;
         if(this._isAdd)
         {
            s = " " + s;
            len += 1;
            xpos -= 10;
            addIcon = ComponentFactory.Instance.creatBitmap("asset.game.addBloodIconAsset") as Bitmap;
            addIcon.x = xpos;
            addIcon.y = 20;
            numArr.push(addIcon);
         }
         for(var i:int = this._isAdd ? 1 : 0; i < len; i++)
         {
            if(this._isAdd)
            {
               b = GameManager.Instance.numCreater.createGreenNum(int(s.charAt(i)));
            }
            else
            {
               b = GameManager.Instance.numCreater.createRedNum(int(s.charAt(i)));
            }
            b.smoothing = true;
            b.x = xpos + i * 20;
            b.y = 20;
            numArr.push(b);
         }
         numArr = this.returnNum(numArr);
         var bmpData:BitmapData = new BitmapData(numArr[2],numArr[3],true,0);
         this._picBmp = new Bitmap(bmpData,"auto",true);
         for(i = 4; i < numArr.length; i++)
         {
            bmpData.copyPixels(numArr[i].bitmapData,new Rectangle(0,0,numArr[i].width,numArr[i].height),new Point(numArr[i].x - numArr[0],numArr[i].y - numArr[1]),null,null,true);
         }
         this._picBmp.x = numArr[0];
         this._picBmp.y = numArr[1];
         numArr = null;
         return this._picBmp;
      }
      
      private function returnNum(arr:Array) : Array
      {
         for(var i:int = 4; i < arr.length; i++)
         {
            arr[0] = arr[0] > arr[i].x ? arr[i].x : arr[0];
            arr[1] = arr[1] > arr[i].y ? arr[i].y : arr[1];
            arr[2] = arr[2] > arr[i].width + arr[i].x ? arr[2] : arr[i].width + arr[i].x;
            arr[3] = arr[3] > arr[i].height + arr[i].y ? arr[3] : arr[i].height + arr[i].y;
         }
         arr[2] -= arr[0];
         arr[3] -= arr[1];
         return arr;
      }
   }
}

