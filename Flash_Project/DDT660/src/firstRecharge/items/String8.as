package firstRecharge.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class String8 extends Sprite
   {
      
      private var _bitMapData:BitmapData;
      
      private var _list:Vector.<BitmapData>;
      
      public function String8()
      {
         var rec:Rectangle = null;
         var p:Point = null;
         var data:BitmapData = null;
         super();
         this._list = new Vector.<BitmapData>();
         x = 40;
         y = 239;
         rotation = -20;
         this._bitMapData = ComponentFactory.Instance.creatBitmapData("fristRecharge.str8");
         var t_width:int = this._bitMapData.width / 10;
         var t_height:int = this._bitMapData.height;
         for(var i:int = 0; i < 10; i++)
         {
            rec = new Rectangle(t_width * i,0,t_width,t_height);
            p = new Point(0,0);
            data = new BitmapData(t_width,t_height);
            data.copyPixels(this._bitMapData,rec,p);
            this._list.push(data);
         }
      }
      
      public function setNum(str:String) : void
      {
         var t:int = 0;
         var data:BitmapData = null;
         var bitMap:Bitmap = null;
         this.clear();
         var len:int = str.length;
         for(var i:int = 0; i < len; i++)
         {
            t = int(str.charAt(i));
            data = this._list[t].clone();
            bitMap = new Bitmap(data);
            bitMap.x = i * (bitMap.width - 8);
            bitMap.smoothing = true;
            addChild(bitMap);
         }
      }
      
      public function clear() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

