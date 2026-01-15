package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   public class RoomCharaterLoader extends BaseCharacterLoader
   {
      
      private var _suit:BitmapData;
      
      private var _faceUpBmd:BitmapData;
      
      private var _faceBmd:BitmapData;
      
      public var showWeapon:Boolean;
      
      public function RoomCharaterLoader(info:PlayerInfo)
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
      
      override protected function getIndexByTemplateId(id:String) : int
      {
         var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(id));
         if(item == null)
         {
            return -1;
         }
         switch(item.CategoryID.toString())
         {
            case "1":
            case "10":
            case "11":
            case "12":
               return 2;
            case "13":
               return 0;
            case "15":
               return 8;
            case "16":
               return 9;
            case "17":
               return -1;
            case "2":
               return 1;
            case "3":
               return 5;
            case "4":
               return 3;
            case "5":
               return 4;
            case "6":
               return 6;
            case "27":
            case "7":
               return 7;
            default:
               return -1;
         }
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
      
      override protected function drawCharacter() : void
      {
         var sp:Shape = null;
         var bmd:BitmapData = null;
         var picWidth:Number = ShowCharacter.BIG_WIDTH;
         var picHeight:Number = ShowCharacter.BIG_HEIGHT;
         if(picWidth == 0 || picHeight == 0)
         {
            return;
         }
         if(Boolean(this._suit))
         {
            this._suit.dispose();
         }
         this._suit = new BitmapData(picWidth * 4,picHeight,true,0);
         if(Boolean(this._faceUpBmd))
         {
            this._faceUpBmd.dispose();
         }
         this._faceUpBmd = new BitmapData(picWidth,picHeight,true,0);
         if(Boolean(this._faceBmd))
         {
            this._faceBmd.dispose();
         }
         this._faceBmd = new BitmapData(picWidth * 4,picHeight,true,0);
         if(_info.getShowSuits())
         {
            this._suit.draw(_layers[0].getContent(),null,null,BlendMode.NORMAL);
            if(_info.WeaponID != 0 && _info.WeaponID != -1 && this.showWeapon)
            {
               sp = new Shape();
               bmd = new BitmapData(picWidth,picHeight,true,0);
               bmd.draw(_layers[7].getContent());
               sp.graphics.beginBitmapFill(bmd,null,true,true);
               sp.graphics.drawRect(0,0,picWidth * 4,picHeight);
               sp.graphics.endFill();
               this._suit.draw(sp,null,null,BlendMode.NORMAL);
               bmd.dispose();
            }
         }
         else
         {
            this._faceUpBmd.draw(_layers[5].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[4].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[3].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[2].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[1].getContent(),null,null,BlendMode.NORMAL);
            this._faceBmd.draw(_layers[6].getContent(),null,null,BlendMode.NORMAL);
            if(_info.WeaponID != 0 && _info.WeaponID != -1 && this.showWeapon)
            {
               this._faceUpBmd.draw(_layers[7].getContent(),null,null,BlendMode.NORMAL);
            }
         }
         _wing = _layers[8].getContent() as MovieClip;
      }
      
      override public function getContent() : Array
      {
         return [this._suit,this._faceUpBmd,this._faceBmd,_wing];
      }
   }
}

