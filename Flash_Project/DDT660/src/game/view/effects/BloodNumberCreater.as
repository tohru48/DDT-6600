package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class BloodNumberCreater
   {
      
      private var greenData:Vector.<BitmapData>;
      
      private var redData:Vector.<BitmapData>;
      
      public function BloodNumberCreater()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.redData = new Vector.<BitmapData>();
         this.greenData = new Vector.<BitmapData>();
         for(var i:int = 0; i < 10; i++)
         {
            this.redData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUm" + i + "Asset"));
            this.greenData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUma" + i + "Asset"));
         }
      }
      
      public function createGreenNum(value:int) : Bitmap
      {
         return new Bitmap(this.greenData[value]);
      }
      
      public function createRedNum(value:int) : Bitmap
      {
         return new Bitmap(this.redData[value]);
      }
      
      public function dispose() : void
      {
         for(var i:int = 0; i < 10; i++)
         {
            this.redData[i].dispose();
            this.redData[i] = null;
            this.greenData[i].dispose();
            this.greenData[i] = null;
         }
      }
   }
}

