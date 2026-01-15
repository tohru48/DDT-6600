package game.view
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import game.model.WindPowerImgData;
   import road7th.comm.PackageIn;
   
   public class WindPowerManager
   {
      
      private static var _instance:WindPowerManager;
      
      private var _windPicMode:WindPowerImgData;
      
      public function WindPowerManager()
      {
         super();
      }
      
      public static function get Instance() : WindPowerManager
      {
         if(_instance == null)
         {
            _instance = new WindPowerManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         this._windPicMode = new WindPowerImgData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WINDPIC,this._windPicCome);
      }
      
      private function _windPicCome(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var bmpID:int = pkg.readByte();
         var bmpBytData:ByteArray = pkg.readByteArray();
         this._windPicMode.refeshData(bmpBytData,bmpID);
      }
      
      public function getWindPic(arr:Array) : BitmapData
      {
         return this._windPicMode.getImgBmp(arr);
      }
      
      public function getWindPicById(id:int) : BitmapData
      {
         return this._windPicMode.getImgBmpById(id);
      }
   }
}

