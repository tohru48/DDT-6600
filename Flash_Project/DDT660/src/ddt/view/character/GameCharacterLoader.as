package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   
   public class GameCharacterLoader extends BaseCharacterLoader
   {
      
      public static var MALE_STATES:Array = [[1,1],[2,2],[3,3],[4,4],[5,5],[7,7],[8,8],[11,9]];
      
      public static var FEMALE_STATES:Array = [[1,1],[2,2],[3,3],[4,4],[5,5],[7,6],[9,8],[11,9]];
      
      private var _sp:Vector.<BitmapData>;
      
      private var _faceup:BitmapData;
      
      private var _face:BitmapData;
      
      private var _lackHpFace:Vector.<BitmapData>;
      
      private var _faceDown:BitmapData;
      
      private var _normalSuit:BitmapData;
      
      private var _lackHpSuit:BitmapData;
      
      public var specialType:int = -1;
      
      public var stateType:int = -1;
      
      public function GameCharacterLoader(info:PlayerInfo)
      {
         super(info);
      }
      
      public function get STATES_ENUM() : Array
      {
         if(_info.Sex)
         {
            return MALE_STATES;
         }
         return FEMALE_STATES;
      }
      
      override protected function initLayers() : void
      {
         var layer:ILayer = null;
         var arr:Array = null;
         var i:int = 0;
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
         if(_info.getShowSuits())
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])),_info.Sex,"",BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])),_info.Sex,"",BaseLayer.GAME,false,1,null,"1"));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.GAME,true,1,_recordStyle[6].split("|")[1]));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])),_info.Sex,"",BaseLayer.GAME));
         }
         else
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[1].split("|")[0])),_info.Sex,_recordColor[1],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])),_info.Sex,_recordColor[0],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3].split("|")[0])),_info.Sex,_recordColor[3],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4].split("|")[0])),_info.Sex,_recordColor[4],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2].split("|")[0])),_info.Sex,_recordColor[2],BaseLayer.GAME,false,_info.getHairType()));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])),_info.Sex,_recordColor[5],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.GAME,true,1,_recordStyle[6].split("|")[1]));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])),_info.Sex,"",BaseLayer.GAME));
            arr = this.STATES_ENUM;
            for(i = 0; i < arr.length; i++)
            {
               _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])),_info.Sex,_recordColor[5],LayerFactory.STATE,false,1,null,String(arr[i][0])));
               _layers.push(_layerFactory.createLayer(null,_info.Sex,"",LayerFactory.SPECIAL_EFFECT,false,1,null,String(arr[i][1])));
            }
         }
      }
      
      override public function update() : void
      {
         super.update();
      }
      
      override protected function getIndexByTemplateId(id:String) : int
      {
         switch(id.charAt(0))
         {
            case "1":
               if(id.charAt(1) == String(3))
               {
                  return 0;
               }
               if(id.charAt(1) == String(5))
               {
                  return 8;
               }
               return 1;
               break;
            case "2":
               return 0;
            case "3":
               return 4;
            case "4":
               return 2;
            case "5":
               return 3;
            case "6":
               return 5;
            case "7":
               return 7;
            default:
               return -1;
         }
      }
      
      override protected function drawCharacter() : void
      {
         if(_info.getShowSuits())
         {
            this.drawSuits();
         }
         else
         {
            this.drawNormal();
         }
      }
      
      private function drawSuits() : void
      {
         var picWidth:Number = Number(_layers[1].width);
         var picHeight:Number = Number(_layers[1].height);
         if(picWidth == 0 || picHeight == 0)
         {
            return;
         }
         if(Boolean(this._normalSuit))
         {
            this._normalSuit.dispose();
         }
         this._normalSuit = new BitmapData(picWidth,picHeight,true,0);
         if(Boolean(this._lackHpSuit))
         {
            this._lackHpSuit.dispose();
         }
         this._lackHpSuit = new BitmapData(picWidth,picHeight,true,0);
         this._normalSuit.draw((_layers[2] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._lackHpSuit.draw((_layers[2] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._normalSuit.draw((_layers[0] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._lackHpSuit.draw((_layers[1] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         _wing = _layers[3].getContent() as MovieClip;
      }
      
      private function drawNormal() : void
      {
         var bmd:BitmapData = null;
         var bmd1:BitmapData = null;
         var spf:BitmapData = null;
         var sp:BitmapData = null;
         var picWidth:Number = Number(_layers[1].width);
         var picHeight:Number = Number(_layers[1].height);
         if(picWidth == 0 || picHeight == 0)
         {
            return;
         }
         if(Boolean(this._face))
         {
            this._face.dispose();
         }
         this._face = new BitmapData(picWidth,picHeight,true,0);
         if(Boolean(this._faceup))
         {
            this._faceup.dispose();
         }
         this._faceup = new BitmapData(picWidth,picHeight,true,0);
         if(Boolean(this._sp))
         {
            for each(bmd in this._sp)
            {
               bmd.dispose();
            }
         }
         this._sp = new Vector.<BitmapData>();
         if(Boolean(this._lackHpFace))
         {
            for each(bmd1 in this._lackHpFace)
            {
               bmd1.dispose();
            }
         }
         this._lackHpFace = new Vector.<BitmapData>();
         if(Boolean(this._faceDown))
         {
            this._faceDown.dispose();
         }
         this._faceDown = new BitmapData(picWidth,picHeight,true,0);
         for(var i:int = 7; i >= 0; i--)
         {
            if(_layers[i].info.CategoryID == EquipType.WING)
            {
               _wing = _layers[i].getContent() as MovieClip;
            }
            else if(i == 5)
            {
               this._face.draw((_layers[i] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
            else if(i == 6)
            {
               this._faceDown.draw((_layers[i] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
            else if(i < 5)
            {
               this._faceup.draw((_layers[i] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
         }
         var picWidth1:Number = Number(_layers[8].width);
         var picHeight1:Number = Number(_layers[8].height);
         picWidth1 = picWidth1 == 0 ? 50 : picWidth1;
         picHeight1 = picHeight1 == 0 ? 50 : picHeight1;
         for(var j:int = 8; j < _layers.length; j += 2)
         {
            spf = new BitmapData(picWidth1,picHeight1,true,0);
            sp = new BitmapData(picWidth1,picHeight1,true,0);
            spf.draw((_layers[j] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            sp.draw((_layers[j + 1] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            this._lackHpFace.push(spf);
            this._sp.push(sp);
         }
      }
      
      override public function getContent() : Array
      {
         return [_wing,this._sp,this._faceup,this._face,this._lackHpFace,this._faceDown,this._normalSuit,this._lackHpSuit];
      }
      
      override protected function getCharacterLoader(value:ItemTemplateInfo, color:String = "", pic:String = null) : ILayer
      {
         if(value.CategoryID == EquipType.HAIR)
         {
            return _layerFactory.createLayer(value,_info.Sex,color,BaseLayer.GAME,false,_info.getHairType(),pic);
         }
         return _layerFactory.createLayer(value,_info.Sex,color,BaseLayer.GAME,false,1,pic);
      }
      
      override public function dispose() : void
      {
         this._sp = null;
         this._faceup = null;
         this._face = null;
         this._lackHpFace = null;
         this._faceDown = null;
         this._normalSuit = null;
         this._lackHpSuit = null;
         super.dispose();
      }
   }
}

