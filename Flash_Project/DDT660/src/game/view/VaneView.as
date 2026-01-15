package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class VaneView extends Sprite
   {
      
      public static const RandomVaneOffset:Number = 6;
      
      public static const RANDOW_COLORS:Array = [1710618,1514802,1712150,2493709,1713677,1838339,1842464,2170141,1054500,2630187];
      
      public static const RANDOW_COLORSII:Array = [[4667276,2429483],[11785,5647616],[401937,608599],[473932,6492176],[9178527,1316390],[2360854,7280322],[2185247,927056],[8724255,4076052],[1835158,4653109],[919557,7353207],[1644310,5703976],[149007,857625],[2499109,872256],[8519680,1328498],[5775151,3355404],[1326929,7150931]];
      
      private var _bmVaneTitle:Bitmap;
      
      private var _bmPreviousDirection:Bitmap;
      
      private var _bmPrevious:Bitmap;
      
      private var vane1_mc:MovieClip;
      
      private var mixedbgAccect:Shape;
      
      private var _lastWind:Number;
      
      private var mixedBg1:CheckCodeMixedBack;
      
      private var vane1PosX:Number = 0;
      
      private var vane2PosX:Number = -17.5;
      
      private var text1PosX:Number = 0;
      
      private var text2PosX:Number = 0;
      
      private var _vanePos:Point;
      
      private var _vanePos2:Point;
      
      private var _vaneTitlePos:Point;
      
      private var _vaneTitlePos2:Point;
      
      private var _vaneValuePos:Point;
      
      private var _vaneValuePos2:Point;
      
      private var _field:FilterFrameText;
      
      public var _vanePreviousGradientText:FilterFrameText;
      
      private var textGlowFilter:GlowFilter;
      
      private var textFilter:Array;
      
      private var _previousDirectionPos:Point;
      
      private var _valuePos1:Point;
      
      private var _valuePos2:Point;
      
      private var _zeroTxt:FilterFrameText;
      
      private var _windNumShape:Shape;
      
      public function VaneView()
      {
         super();
         this._vanePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos");
         this._vanePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos2");
         this._vaneTitlePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos");
         this._vaneTitlePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos2");
         this._vaneValuePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
         this._vaneValuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
         this._bmVaneTitle = ComponentFactory.Instance.creatBitmap("asset.game.vaneTitleAsset");
         addChild(this._bmVaneTitle);
         this._bmPrevious = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousAsset");
         this._bmPrevious.visible = false;
         addChild(this._bmPrevious);
         this._bmPreviousDirection = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousDirectionAsset");
         this._previousDirectionPos = new Point(this._bmPreviousDirection.x,this._bmPreviousDirection.y);
         this._bmPreviousDirection.visible = false;
         addChild(this._bmPreviousDirection);
         this._vanePreviousGradientText = ComponentFactory.Instance.creatComponentByStylename("asset.game.vanePreviousGradientTextAsset");
         this._vanePreviousGradientText.visible = false;
         addChild(this._vanePreviousGradientText);
         this._zeroTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneZeroTextAsset");
         this.vane1_mc = ClassUtils.CreatInstance("asset.game.vaneAsset");
         this.vane1_mc.mouseChildren = this.vane1_mc.mouseEnabled = false;
         this.vane1_mc.x = this._vanePos.x;
         this.vane1_mc.y = this._vanePos.y;
         addChild(this.vane1_mc);
         this.mixedbgAccect = new Shape();
         this.mixedbgAccect.graphics.beginFill(16777215,1);
         this.mixedbgAccect.graphics.drawRect(0,0,20,20);
         this.mixedbgAccect.graphics.endFill();
         this.creatGraidenText();
         this.creatMixBg();
         mouseChildren = mouseEnabled = false;
      }
      
      private function creatMixBg() : void
      {
         this.mixedBg1 = new CheckCodeMixedBack(20,20,7238008);
         this.mixedBg1.x = 0;
         this.mixedBg1.y = 0;
         this.mixedBg1.mask = this.mixedbgAccect;
      }
      
      public function setUpCenter(xPos:Number, yPos:Number) : void
      {
         this.x = xPos;
         this.y = yPos;
      }
      
      private function getRandomVaneOffset() : Number
      {
         return Math.random() * RandomVaneOffset - RandomVaneOffset / 2;
      }
      
      private function creatGraidenText() : void
      {
         this._field = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneGradientTextAsset");
         this._field.autoSize = TextFieldAutoSize.CENTER;
         this._valuePos1 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
         this._valuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
         this._windNumShape = new Shape();
         addChildAt(this._windNumShape,numChildren);
      }
      
      public function initialize() : void
      {
         this._lastWind = 11;
      }
      
      public function update(value:Number, upDateLast:Boolean = false, arr:Array = null) : void
      {
         if(arr == null)
         {
            this._windNumShape.visible = false;
            arr = new Array();
            arr = [true,0,0,0];
         }
         else
         {
            this._windNumShape.visible = true;
         }
         if(this._lastWind != 11)
         {
            this.lastTurn(this._lastWind);
         }
         if(upDateLast)
         {
            this._lastWind = value;
         }
         this._bmVaneTitle.x = arr[0] == true ? this._vaneTitlePos2.x : this._vaneTitlePos.x;
         this.vane1_mc.scaleX = arr[0] == true ? 1 : -1;
         this.vane1_mc.x = arr[0] == true ? this._vanePos2.x : this._vanePos.x;
         this._windNumShape.x = arr[0] == true ? this._vaneValuePos.x : this._vaneValuePos2.x;
         this._windNumShape.y = arr[0] == true ? this._vaneValuePos.y : this._vaneValuePos2.y;
         if(arr[1] == 0 && arr[2] == 0 && arr[3] == 0)
         {
            this._zeroTxt.x = this._windNumShape.x;
            this._zeroTxt.y = this._windNumShape.y;
            addChild(this._zeroTxt);
            this._windNumShape.visible = false;
            this._zeroTxt.visible = true;
         }
         else
         {
            this._windNumShape.visible = true;
            this._zeroTxt.visible = false;
            this.drawNum([arr[1],arr[2],arr[3]]);
         }
      }
      
      private function drawNum(nums:Array) : void
      {
         var bitmap:BitmapData = null;
         var id:int = 0;
         var pen:Graphics = this._windNumShape.graphics;
         pen.clear();
         var drawMat:Matrix = new Matrix();
         for each(id in nums)
         {
            bitmap = WindPowerManager.Instance.getWindPicById(id);
            if(Boolean(bitmap))
            {
               drawMat.tx = this._windNumShape.width;
               pen.beginBitmapFill(bitmap,drawMat);
               pen.drawRect(this._windNumShape.width,0,bitmap.width,bitmap.height);
               pen.endFill();
            }
         }
      }
      
      private function setRandomPos() : void
      {
         var sp1:Number = this.getRandomVaneOffset();
         this.vane1_mc.x += sp1;
         this._windNumShape.x += sp1;
      }
      
      private function addZero(value:Number) : String
      {
         var result:String = null;
         if(Math.ceil(value) == value || Math.floor(value) == value)
         {
            result = Math.abs(value).toString() + ".0";
         }
         else
         {
            result = Math.abs(value).toString();
         }
         return result;
      }
      
      private function lastTurn(value:Number) : void
      {
         this._bmPrevious.visible = true;
         this._bmPreviousDirection.visible = true;
         this._vanePreviousGradientText.visible = true;
         this._bmPreviousDirection.scaleX = value > 0 ? 1 : -1;
         this._bmPreviousDirection.x = value > 0 ? this._previousDirectionPos.x : this._previousDirectionPos.x + this._bmPreviousDirection.width;
         this._vanePreviousGradientText.text = Math.abs(value).toString();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bmVaneTitle))
         {
            if(Boolean(this._bmVaneTitle.parent))
            {
               this._bmVaneTitle.parent.removeChild(this._bmVaneTitle);
            }
            this._bmVaneTitle.bitmapData.dispose();
            this._bmVaneTitle = null;
         }
         if(Boolean(this._bmPreviousDirection))
         {
            if(Boolean(this._bmPreviousDirection.parent))
            {
               this._bmPreviousDirection.parent.removeChild(this._bmPreviousDirection);
            }
            this._bmPreviousDirection.bitmapData.dispose();
            this._bmPreviousDirection = null;
         }
         if(Boolean(this._bmPrevious))
         {
            if(Boolean(this._bmPrevious.parent))
            {
               this._bmPrevious.parent.removeChild(this._bmPrevious);
            }
            this._bmPrevious.bitmapData.dispose();
            this._bmPrevious = null;
         }
         this.vane1_mc.stop();
         removeChild(this.vane1_mc);
         this.vane1_mc = null;
         this.mixedbgAccect = null;
         this.mixedBg1.mask = null;
         this.mixedBg1 = null;
         ObjectUtils.disposeObject(this._windNumShape);
         this._windNumShape = null;
         if(Boolean(this._zeroTxt))
         {
            ObjectUtils.disposeObject(this._zeroTxt);
         }
         this._zeroTxt = null;
         ObjectUtils.disposeObject(this._vanePreviousGradientText);
         this._vanePreviousGradientText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

