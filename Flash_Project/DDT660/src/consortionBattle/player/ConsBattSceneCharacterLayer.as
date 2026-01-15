package consortionBattle.player
{
   import com.pickgliss.loader.BitmapLoader;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.character.BaseLayer;
   import flash.display.Bitmap;
   
   public class ConsBattSceneCharacterLayer extends BaseLayer
   {
      
      private var _equipType:int;
      
      private var _sex:Boolean;
      
      private var _index:int;
      
      private var _direction:int;
      
      public function ConsBattSceneCharacterLayer(info:ItemTemplateInfo, equipType:int, sex:Boolean, index:int, direction:int)
      {
         this._equipType = equipType;
         this._sex = sex;
         this._index = index;
         this._direction = direction;
         super(info);
      }
      
      override protected function initLoaders() : void
      {
         var i:int = 0;
         var url:String = null;
         var l:BitmapLoader = null;
         if(_info != null)
         {
            for(i = 0; i < _info.Property8.length; i++)
            {
               url = this.getUrl(int(_info.Property8.charAt(i)));
               l = ConsortiaBattleManager.instance.createLoader(url);
               _queueLoader.addLoader(l);
            }
            _defaultLayer = 0;
            _currentEdit = _queueLoader.length;
         }
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
         var equipStr:String = this._equipType == 1 ? "face" : (this._equipType == 2 ? "cloth" : "hair");
         var sexStr:String = this._sex ? "M" : "F";
         var directionStr:String = equipStr + (this._direction == 1 ? "" : "F");
         return ConsortiaBattleManager.instance.resourcePrUrl + equipStr + "/" + sexStr + "/" + String(this._index) + "/" + directionStr + "/" + String(layer) + ".png";
      }
   }
}

