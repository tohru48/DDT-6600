package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExpTotalNums extends Sprite implements Disposeable
   {
      
      public static const EXPERIENCE:uint = 0;
      
      public static const EXPLOIT:uint = 1;
      
      public var maxValue:int;
      
      private var _value:int;
      
      private var _type:int;
      
      private var _bg:MovieClip;
      
      private var _operator:Bitmap;
      
      private var _bitmaps:Vector.<Bitmap>;
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      public function ExpTotalNums(type:int)
      {
         super();
         this._type = type;
         this.init();
      }
      
      private function init() : void
      {
         var str:String = null;
         this._operator = new Bitmap();
         this._bitmaps = new Vector.<Bitmap>(5);
         this._bitmapDatas = new Vector.<BitmapData>();
         if(this._type == EXPERIENCE)
         {
            str = "asset.experience.TotalExpNum_";
            this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExpTxtLight");
         }
         else
         {
            str = "asset.experience.TotalExploitNum_";
            this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExploitTxtLight");
         }
         PositionUtils.setPos(this._bg,"experience.TotalTextLightPos");
         addChildAt(this._bg,0);
         for(var i:int = 0; i < 10; i++)
         {
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(str + String(i)));
         }
         this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(str + "+"));
         this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(str + "-"));
      }
      
      public function playLight() : void
      {
         this._bg.gotoAndPlay(2);
      }
      
      public function setValue(value:int) : void
      {
         var posX:int = 0;
         var offset:int = 0;
         var strArr:Array = null;
         var i:int = 0;
         if(value > this.maxValue)
         {
            this._value = this.maxValue;
         }
         else
         {
            this._value = value;
         }
         posX = 0;
         offset = 20;
         if(this._value >= 0)
         {
            this._operator.bitmapData = this._bitmapDatas[10];
         }
         else
         {
            this._operator.bitmapData = this._bitmapDatas[11];
         }
         addChild(this._operator);
         posX += offset;
         this._value = Math.abs(this._value);
         strArr = this._value.toString().split("");
         for(i = 0; i < strArr.length; i++)
         {
            if(this._bitmaps[i] == null)
            {
               this._bitmaps[i] = new Bitmap();
            }
            this._bitmaps[i].bitmapData = this._bitmapDatas[int(strArr[i])];
            this._bitmaps[i].x = posX;
            posX += offset;
            addChild(this._bitmaps[i]);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg = null;
         }
         if(Boolean(this._operator))
         {
            if(Boolean(this._operator.parent))
            {
               this._operator.parent.removeChild(this._operator);
            }
            this._operator.bitmapData.dispose();
            this._operator = null;
         }
         this._bitmapDatas = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

