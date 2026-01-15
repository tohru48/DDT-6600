package hall.hallInfo.playerInfo
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ImgNumConverter
   {
      
      private static var _instance:ImgNumConverter;
      
      public function ImgNumConverter()
      {
         super();
      }
      
      public static function get instance() : ImgNumConverter
      {
         if(!_instance)
         {
            _instance = new ImgNumConverter();
         }
         return _instance;
      }
      
      public function convertToImg(num:int, cmpStr:String, gap:int = 9) : Sprite
      {
         var sp:Sprite = null;
         var img:Bitmap = null;
         sp = new Sprite();
         var numArr:Array = [];
         if(num <= 0)
         {
            num = 0;
         }
         while(num >= 10)
         {
            numArr.push(num % 10);
            num = int(Math.floor(num / 10));
         }
         numArr.push(num);
         var len:int = int(numArr.length);
         for(var i:int = 0; i <= len - 1; i++)
         {
            img = ComponentFactory.Instance.creat(cmpStr + numArr.pop());
            img.smoothing = true;
            img.x = i * gap;
            sp.addChild(img);
         }
         return sp;
      }
   }
}

