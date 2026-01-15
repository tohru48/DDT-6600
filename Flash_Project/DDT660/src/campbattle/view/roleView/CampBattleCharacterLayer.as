package campbattle.view.roleView
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   import flash.display.Bitmap;
   
   public class CampBattleCharacterLayer extends BaseLayer
   {
      
      private var _equipType:int;
      
      private var _sex:Boolean;
      
      private var _index:int;
      
      private var _direction:int;
      
      private var _baseURL:String;
      
      private var _mountType:int;
      
      public function CampBattleCharacterLayer(info:ItemTemplateInfo, equipType:int, sex:Boolean, index:int, direction:int, baseURl:String, mountType:int)
      {
         this._equipType = equipType;
         this._sex = sex;
         this._index = index;
         this._direction = direction;
         this._baseURL = baseURl;
         this._mountType = mountType;
         super(info);
      }
      
      override public function reSetBitmap() : void
      {
         var i:int = 0;
         var tmpBitmap:Bitmap = null;
         this.clearBitmap();
         for(i = 0; i < _queueLoader.loaders.length; i++)
         {
            if(_queueLoader.loaders[i].content)
            {
               tmpBitmap = new Bitmap((_queueLoader.loaders[i].content as Bitmap).bitmapData);
            }
            _bitmaps.push(tmpBitmap);
            if(Boolean(_bitmaps[i]))
            {
               _bitmaps[i].smoothing = true;
               _bitmaps[i].visible = false;
               addChild(_bitmaps[i]);
            }
         }
      }
      
      override protected function clearBitmap() : void
      {
         _bitmaps = new Vector.<Bitmap>();
      }
      
      override protected function getUrl(layer:int) : String
      {
         var equipStr:String = null;
         var sexStr:String = null;
         var directionStr:String = null;
         var path:String = "";
         sexStr = this._sex ? "M" : "F";
         if(this._mountType == 0)
         {
            equipStr = this._equipType == 0 ? "face" : (this._equipType == 2 ? "clothZ" : "hair");
            directionStr = (this._equipType == 2 ? "cloth" : equipStr) + (this._direction == 1 ? "" : "F");
            path = this._baseURL + equipStr + "/" + sexStr + "/" + String(this._index) + "/" + directionStr + "/" + String(layer) + ".png";
         }
         else
         {
            equipStr = this._equipType == 0 ? "face" : (this._equipType == 2 ? "cloth" : "hair");
            directionStr = (this._equipType == 2 ? "cloth" : equipStr) + (this._direction == 1 ? "" : "F");
            if(this._equipType == 0)
            {
               path = this._baseURL + "face/" + sexStr + "/" + String(this._index) + "/" + directionStr + "/" + String(layer) + ".png";
            }
            else if(this._equipType == 1)
            {
               path = this._baseURL + "hair/" + sexStr + "/" + String(this._index) + "/" + directionStr + "/" + String(layer) + ".png";
            }
            else if(this._equipType == 2)
            {
               path = this._baseURL + "cloth/" + sexStr + "/" + String(this._index) + "/" + String(layer) + ".png";
            }
            else if(this._equipType == 3)
            {
               path = PathManager.SITE_MAIN + "image/mounts/saddle/" + this._mountType + "/" + String(layer) + ".png";
            }
            else if(this._equipType == 4)
            {
               path = PathManager.SITE_MAIN + "image/mounts/horse/" + this._mountType + "/" + String(layer) + ".png";
            }
         }
         return path;
      }
   }
}

