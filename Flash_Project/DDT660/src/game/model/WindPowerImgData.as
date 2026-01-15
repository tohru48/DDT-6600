package game.model
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   
   public class WindPowerImgData extends EventDispatcher
   {
      
      private var _imgBitmapVec:Vector.<BitmapData>;
      
      public function WindPowerImgData()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         var i:int = 0;
         var bmpData:BitmapData = null;
         for(this._imgBitmapVec = new Vector.<BitmapData>(); i < 11; )
         {
            bmpData = new BitmapData(1,1);
            this._imgBitmapVec.push(bmpData);
            i++;
         }
      }
      
      public function refeshData(bmpBytData:ByteArray, bmpID:int) : void
      {
         var imgLoad:Loader = null;
         var _imgLoadOk:Function = null;
         _imgLoadOk = function(e:Event):void
         {
            BitmapData(_imgBitmapVec[bmpID]).dispose();
            _imgBitmapVec[bmpID] = Bitmap(imgLoad.contentLoaderInfo.content).bitmapData;
            imgLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,_imgLoadOk);
            imgLoad.unload();
            imgLoad = null;
         };
         imgLoad = new Loader();
         imgLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,_imgLoadOk);
         imgLoad.loadBytes(bmpBytData);
      }
      
      public function getImgBmp(arr:Array) : BitmapData
      {
         var w:int = 0;
         var imgData:BitmapData = new BitmapData(this._imgBitmapVec[arr[1]].width + this._imgBitmapVec[arr[2]].width + this._imgBitmapVec[arr[3]].width,this._imgBitmapVec[0].height);
         for(var i:int = 1; i <= 3; i++)
         {
            w = 0;
            switch(i)
            {
               case 2:
                  w = this._imgBitmapVec[arr[1]].width;
                  break;
               case 3:
                  w = this._imgBitmapVec[arr[1]].width + this._imgBitmapVec[arr[2]].width;
                  break;
            }
            imgData.copyPixels(this._imgBitmapVec[arr[i]],this._imgBitmapVec[arr[i]].rect,new Point(w,0));
         }
         return imgData;
      }
      
      public function getImgBmpById(id:int) : BitmapData
      {
         return this._imgBitmapVec[id];
      }
   }
}

