package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class ShowCharacterLoader extends BaseCharacterLoader
   {
      
      protected var _contentWithoutWeapon:BitmapData;
      
      private var _needMultiFrames:Boolean = false;
      
      public function ShowCharacterLoader(info:PlayerInfo)
      {
         super(info);
      }
      
      override protected function initLayers() : void
      {
         var layer:ILayer = null;
         if(_layers != null)
         {
            for each(layer in _layers)
            {
               layer.dispose();
            }
            _layers = null;
         }
         _layers = new Vector.<ILayer>();
         _recordStyle = _info.Style.split(",");
         _recordColor = _info.Colors.split(",");
         this.loadPart(7);
         this.loadPart(1);
         this.loadPart(0);
         this.loadPart(3);
         this.loadPart(4);
         this.loadPart(2);
         this.loadPart(5);
         this.laodArm();
         this.loadPart(8);
      }
      
      private function loadPart(index:int) : void
      {
         var item:ItemTemplateInfo = null;
         var color:String = null;
         if(_recordStyle[index].split("|")[0] > 0)
         {
            item = ItemManager.Instance.getTemplateById(int(_recordStyle[index].split("|")[0]));
            color = EquipType.isEditable(item) ? _recordColor[index] : "";
            _layers.push(_layerFactory.createLayer(item,_info.Sex,color,BaseLayer.SHOW,index == 2,_info.getHairType()));
         }
      }
      
      private function laodArm() : void
      {
         if(_recordStyle[6].split("|")[0] > 0)
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.SHOW,false,_info.getHairType(),_recordStyle[6].split("|")[1]));
         }
      }
      
      override protected function getIndexByTemplateId(id:String) : int
      {
         var i:int = super.getIndexByTemplateId(id);
         if(i == -1)
         {
            if(int(id.charAt(0)) == EquipType.ARM)
            {
               return 7;
            }
            return -1;
         }
         return i;
      }
      
      public function set needMultiFrames(value:Boolean) : void
      {
         this._needMultiFrames = value;
      }
      
      override protected function drawCharacter() : void
      {
         var weapon:DisplayObject = null;
         var layer:ILayer = null;
         var picWidth:Number = ShowCharacter.BIG_WIDTH;
         var picHeight:Number = ShowCharacter.BIG_HEIGHT;
         if(this._needMultiFrames)
         {
            picWidth *= 2;
         }
         if(Boolean(_content))
         {
            _content.dispose();
         }
         if(Boolean(this._contentWithoutWeapon))
         {
            this._contentWithoutWeapon.dispose();
         }
         _content = new BitmapData(picWidth,picHeight,true,0);
         this._contentWithoutWeapon = new BitmapData(picWidth,picHeight,true,0);
         var mt:Matrix = new Matrix();
         mt.identity();
         mt.translate(picWidth / 2,0);
         for(var i:int = _layers.length - 1; i >= 0; i--)
         {
            if(_info.getShowSuits())
            {
               if(i != 0 && i != 8 && i != 7)
               {
                  continue;
               }
            }
            else if(i == 0)
            {
               continue;
            }
            layer = _layers[i];
            if(layer.info.CategoryID != EquipType.ARM && layer.info.CategoryID != EquipType.TEMPWEAPON)
            {
               if(layer.info.CategoryID == EquipType.WING)
               {
                  _wing = layer.getContent() as MovieClip;
               }
               else if(layer.info.CategoryID != EquipType.FACE && layer.info.CategoryID != EquipType.SUITS)
               {
                  this._contentWithoutWeapon.draw(layer.getContent(),null,null,BlendMode.NORMAL);
                  if(this._needMultiFrames)
                  {
                     this._contentWithoutWeapon.draw(layer.getContent(),mt,null,BlendMode.NORMAL);
                  }
               }
               else
               {
                  this._contentWithoutWeapon.draw(layer.getContent(),null,null,BlendMode.NORMAL);
               }
            }
            else if(_info.WeaponID != 0 && _info.WeaponID != -1)
            {
               weapon = layer.getContent();
            }
         }
         _content.draw(this._contentWithoutWeapon);
         if(weapon != null)
         {
            _content.draw(weapon);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _content = null;
         this._contentWithoutWeapon = null;
      }
      
      public function destory() : void
      {
         _content.dispose();
         this._contentWithoutWeapon.dispose();
         this.dispose();
      }
      
      override public function getContent() : Array
      {
         return [_content,this._contentWithoutWeapon,_wing];
      }
   }
}

