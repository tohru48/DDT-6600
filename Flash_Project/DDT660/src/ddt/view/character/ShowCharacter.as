package ddt.view.character
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ShowCharacter extends BaseCharacter
   {
      
      public static const STAND:String = "stand";
      
      public static const WIN:String = "win";
      
      public static const LOST:String = "lost";
      
      public static const BIG_WIDTH:int = 250;
      
      public static const BIG_HEIGHT:int = 342;
      
      private var _showLight:Boolean;
      
      private var _lightPos:Point;
      
      private var _light1:MovieClip;
      
      private var _light2:MovieClip;
      
      private var _light01:BaseLightLayer;
      
      private var _light02:SinpleLightLayer;
      
      private var _loading:MovieClip;
      
      private var _showGun:Boolean;
      
      private var _characterWithWeapon:BitmapData;
      
      private var _characterWithoutWeapon:BitmapData;
      
      private var _wing:MovieClip;
      
      private var _staticBmp:Sprite;
      
      private var _currentAction:String;
      
      private var _recordNimbus:int;
      
      private var _needMultiFrame:Boolean;
      
      private var _showWing:Boolean = true;
      
      private var _playAnimation:Boolean = true;
      
      private var _wpCrtBmd:BitmapData;
      
      private var _winCrtBmd:BitmapData;
      
      public function ShowCharacter(info:PlayerInfo, $showGun:Boolean = true, $showLight:Boolean = true, needMultiFrame:Boolean = false)
      {
         super(info,false);
         this._showGun = $showGun;
         this._showLight = $showLight;
         this._lightPos = new Point(0,0);
         this._needMultiFrame = needMultiFrame;
         this._loading = ComponentFactory.Instance.creat("asset.core.character.FigureBgAsset") as MovieClip;
         _container.addChild(this._loading);
         this._currentAction = STAND;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         _info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangeII);
      }
      
      private function __propertyChangeII(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties[PlayerInfo.NIMBUS]))
         {
            this.updateLight();
         }
      }
      
      override public function set showGun(value:Boolean) : void
      {
         if(value == this._showGun)
         {
            return;
         }
         this._showGun = value;
         this.updateCharacter();
      }
      
      public function set showWing(value:Boolean) : void
      {
         if(Boolean(this._wing))
         {
            this._wing.visible = value;
         }
         if(value == this._showWing)
         {
            return;
         }
         this._showWing = value;
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.SHOW);
         ShowCharacterLoader(_loader).needMultiFrames = this._needMultiFrame;
      }
      
      override public function set scaleX(value:Number) : void
      {
         if(value == -1)
         {
            this._loading.scaleX = 1;
         }
         super.scaleX = _dir = value;
         if(!_loadCompleted)
         {
            this._loading.loading1.visible = value == 1;
            this._loading.loading2.visible = !this._loading.loading1.visible;
         }
         _container.x = value < 0 ? -_characterWidth : 0;
      }
      
      override public function setShowLight(b:Boolean, p:Point = null) : void
      {
         if(this._showLight == b && this._lightPos == p)
         {
            return;
         }
         this._showLight = b;
         if(b)
         {
            if(p == null)
            {
               p = new Point(0,0);
            }
            this._lightPos = p;
         }
         this.updateLight();
      }
      
      private function stopMovieClip(mc:MovieClip) : void
      {
         var i:int = 0;
         if(Boolean(mc))
         {
            mc.gotoAndStop(1);
            if(mc.numChildren > 0)
            {
               for(i = 0; i < mc.numChildren; i++)
               {
                  this.stopMovieClip(mc.getChildAt(i) as MovieClip);
               }
            }
         }
      }
      
      private function playMovieClip(mc:MovieClip) : void
      {
         var i:int = 0;
         if(Boolean(mc))
         {
            mc.gotoAndPlay(1);
            if(mc.numChildren > 0)
            {
               for(i = 0; i < mc.numChildren; i++)
               {
                  this.playMovieClip(mc.getChildAt(i) as MovieClip);
               }
            }
         }
      }
      
      private function stopWing() : void
      {
         this.stopMovieClip(this._wing);
      }
      
      public function stopAnimation() : void
      {
         this._playAnimation = false;
         this.stopAllMoiveClip();
      }
      
      public function playAnimation() : void
      {
         this._playAnimation = true;
         this.playAllMoiveClip();
      }
      
      private function stopAllMoiveClip() : void
      {
         this.stopMovieClip(this._light1);
         this.stopMovieClip(this._light2);
         this.stopWing();
      }
      
      private function playAllMoiveClip() : void
      {
         this.playMovieClip(this._light1);
         this.playMovieClip(this._light2);
         this.playMovieClip(this._wing);
      }
      
      private function restoreAnimationState() : void
      {
         if(this._playAnimation)
         {
            this.playAllMoiveClip();
         }
         else
         {
            this.stopAllMoiveClip();
         }
      }
      
      private function drawBitmapWithWingAndLight() : void
      {
         var _originalX:int = 0;
         var _originalY:int = 0;
         var pContainer:DisplayObjectContainer = null;
         var pIndex:int = 0;
         if(_container == null || !_loadCompleted)
         {
            return;
         }
         this.stopAllMoiveClip();
         _originalX = _container.x;
         _originalY = _container.y;
         pContainer = _container.parent;
         pIndex = pContainer.getChildIndex(_container);
         var clipRect:Rectangle = _container.getBounds(_container);
         var tmpContainer:Sprite = new Sprite();
         pContainer.removeChild(_container);
         _container.x = -clipRect.x * _container.scaleX;
         _container.y = -clipRect.y * _container.scaleX;
         tmpContainer.addChild(_container);
         var bitmapdata:BitmapData = new BitmapData(tmpContainer.width,tmpContainer.height,true,0);
         bitmapdata.draw(tmpContainer);
         var bitmap:Bitmap = new Bitmap(bitmapdata,"auto",true);
         tmpContainer.removeChild(_container);
         tmpContainer.addChild(bitmap);
         _container.x = _originalX;
         _container.y = _originalY;
         pContainer.addChildAt(_container,pIndex);
         if(tmpContainer.width > 140)
         {
            tmpContainer.x = tmpContainer.width - 17;
         }
         else
         {
            tmpContainer.x = tmpContainer.width;
         }
         this._staticBmp = tmpContainer;
         this.restoreAnimationState();
      }
      
      public function getShowBitmapBig() : DisplayObject
      {
         if(this._staticBmp == null)
         {
            this.drawBitmapWithWingAndLight();
         }
         return this._staticBmp;
      }
      
      public function resetShowBitmapBig() : void
      {
         if(Boolean(this._staticBmp) && Boolean(this._staticBmp.parent))
         {
            this._staticBmp.parent.removeChild(this._staticBmp);
         }
         this._staticBmp = null;
      }
      
      private function updateLight() : void
      {
         if(_info == null)
         {
            return;
         }
         if(this._showLight && this.currentAction == STAND)
         {
            if(this._recordNimbus != _info.Nimbus)
            {
               this._recordNimbus = _info.Nimbus;
               if(_info.getHaveLight())
               {
                  if(Boolean(this._light02))
                  {
                     this._light02.dispose();
                  }
                  this._light02 = new SinpleLightLayer(_info.Nimbus);
                  this._light02.load(this.callBack02);
               }
               else
               {
                  if(Boolean(this._light02))
                  {
                     this._light02.dispose();
                  }
                  if(Boolean(this._light2) && Boolean(this._light2.parent))
                  {
                     this._light2.parent.removeChild(this._light2);
                  }
                  this._light2 = null;
               }
               if(_info.getHaveCircle())
               {
                  if(Boolean(this._light01))
                  {
                     this._light01.dispose();
                  }
                  this._light01 = new BaseLightLayer(_info.Nimbus);
                  this._light01.load(this.callBack01);
               }
               else
               {
                  if(Boolean(this._light01))
                  {
                     this._light01.dispose();
                  }
                  if(Boolean(this._light1) && Boolean(this._light1.parent))
                  {
                     this._light1.parent.removeChild(this._light1);
                  }
                  this._light1 = null;
               }
            }
         }
         else
         {
            this._recordNimbus = 0;
            if(Boolean(this._light01))
            {
               this._light01.dispose();
            }
            if(Boolean(this._light02))
            {
               this._light02.dispose();
            }
            if(Boolean(this._light1) && Boolean(this._light1.parent))
            {
               this._light1.parent.removeChild(this._light1);
            }
            if(Boolean(this._light2) && Boolean(this._light2.parent))
            {
               this._light2.parent.removeChild(this._light2);
            }
            this._light1 = null;
            this._light2 = null;
         }
      }
      
      private function callBack01($load:BaseLightLayer) : void
      {
         if(Boolean(this._light1) && Boolean(this._light1.parent))
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = $load.getContent() as MovieClip;
         if(this._light1 != null)
         {
            _container.addChildAt(this._light1,0);
            this._light1.x = this._lightPos.x + 47;
            this._light1.y = this._lightPos.y + 65;
         }
         this.drawBitmapWithWingAndLight();
         this.restoreAnimationState();
      }
      
      private function callBack02($load:SinpleLightLayer) : void
      {
         if(Boolean(this._light2) && Boolean(this._light2.parent))
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = $load.getContent() as MovieClip;
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
            this._light2.x = this._lightPos.x + 45;
            this._light2.y = this._lightPos.y + 126;
         }
         this.drawBitmapWithWingAndLight();
         this.restoreAnimationState();
      }
      
      private function updateCharacter() : void
      {
         if(_loader != null && _loader.getContent()[0] != null)
         {
            this.__loadComplete(_loader);
         }
         else
         {
            this.setContent();
         }
      }
      
      public function get characterWithWeapon() : BitmapData
      {
         return this._characterWithWeapon;
      }
      
      override protected function setContent() : void
      {
         var t:Array = null;
         if(_loader != null)
         {
            t = _loader.getContent();
            if(Boolean(this._characterWithWeapon) && this._characterWithWeapon != t[0])
            {
               this._characterWithWeapon.dispose();
            }
            if(Boolean(this._characterWithoutWeapon) && this._characterWithoutWeapon != t[1])
            {
               this._characterWithoutWeapon.dispose();
            }
            this._characterWithWeapon = t[0];
            this._characterWithoutWeapon = t[1];
            if(Boolean(this._wpCrtBmd))
            {
               this._wpCrtBmd.dispose();
            }
            this._wpCrtBmd = null;
            if(Boolean(this._winCrtBmd))
            {
               this._winCrtBmd.dispose();
            }
            this._winCrtBmd = null;
            if(Boolean(this._wing) && Boolean(this._wing.parent))
            {
               this._wing.parent.removeChild(this._wing);
            }
            this._wing = t[2];
         }
         if(this._showGun)
         {
            characterBitmapdata = this._characterWithWeapon;
         }
         else
         {
            characterBitmapdata = this._characterWithoutWeapon;
         }
         this.doAction(this._currentAction);
         this.drawBitmapWithWingAndLight();
      }
      
      public function get charaterWithoutWeapon() : BitmapData
      {
         if(this._wpCrtBmd == null)
         {
            this._wpCrtBmd = new BitmapData(_characterWidth,_characterHeight,true,0);
            this._wpCrtBmd.copyPixels(this._characterWithoutWeapon,_frames[0],new Point(0,0));
         }
         return this._wpCrtBmd;
      }
      
      public function get winCharater() : BitmapData
      {
         if(this._winCrtBmd == null)
         {
            this._winCrtBmd = new BitmapData(_characterWidth,_characterHeight,true,0);
            this._winCrtBmd.copyPixels(_characterBitmapdata,_frames[1],new Point(0,0));
         }
         return this._winCrtBmd;
      }
      
      private function updateWing() : void
      {
         if(!this._showWing || this._wing == null)
         {
            if(!this._showWing && Boolean(this._wing))
            {
               this._wing.visible = false;
            }
            return;
         }
         var bodyIndex:int = _container.getChildIndex(_body);
         bodyIndex = bodyIndex < 1 ? 0 : bodyIndex - 1;
         var _recordStyle:Array = _info.Style.split(",");
         var shouldAdapt:Boolean = ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])).Property1 != "1";
         if(_info.getSuitsType() == 1 && shouldAdapt)
         {
            this._wing.y = -40;
         }
         else
         {
            this._wing.y = 2;
            this._wing.x = -1;
         }
         if(_info.wingHide)
         {
            if(this._wing.parent != null)
            {
               this._wing.parent.removeChild(this._wing);
            }
         }
         else
         {
            _container.addChild(this._wing);
         }
         this.sortIndex();
      }
      
      private function sortIndex() : void
      {
         if(this._light1 != null)
         {
            _container.addChild(this._light1);
         }
         if(this._wing != null && !_info.wingHide)
         {
            _container.addChild(this._wing);
         }
         if(_body != null)
         {
            _container.addChild(_body);
         }
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
         }
      }
      
      public function removeWing() : void
      {
         if(Boolean(this._wing) && Boolean(this._wing.parent))
         {
            this._wing.parent.removeChild(this._wing);
         }
      }
      
      override protected function __loadComplete(loader:ICharacterLoader) : void
      {
         if(this._loading != null)
         {
            if(Boolean(this._loading.parent))
            {
               this._loading.parent.removeChild(this._loading);
            }
         }
         super.__loadComplete(loader);
         this.updateLight();
      }
      
      override public function doAction(actionType:*) : void
      {
         this._currentAction = actionType;
         if(_info.getSuitsType() == 1)
         {
            _body.y = -13;
         }
         else
         {
            _body.y = 0;
         }
         switch(this._currentAction)
         {
            case ShowCharacter.STAND:
               drawFrame(0);
               this.updateWing();
               break;
            case ShowCharacter.WIN:
               drawFrame(1);
               this.removeWing();
               break;
            case ShowCharacter.LOST:
               drawFrame(2);
               this.removeWing();
         }
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(BIG_WIDTH,BIG_HEIGHT);
         setPicNum(1,2);
      }
      
      override public function show(clearLoader:Boolean = true, dir:int = 1, small:Boolean = true) : void
      {
         super.show(clearLoader,dir,small);
         if(small)
         {
            _body.width = BaseCharacter.BASE_WIDTH;
            _body.height = BaseCharacter.BASE_HEIGHT;
            _body.cacheAsBitmap = false;
         }
         else
         {
            _body.width = BIG_WIDTH;
            _body.height = BIG_HEIGHT;
            _body.cacheAsBitmap = false;
         }
      }
      
      public function showWithSize(clearLoader:Boolean = true, dir:int = 1, width:Number = 120, height:Number = 165) : void
      {
         if(width > 140)
         {
            _container.x = width - 17;
         }
         else
         {
            _container.x = width;
         }
         super.show(clearLoader,dir);
         _body.width = width;
         _body.height = height;
         _body.cacheAsBitmap = false;
      }
      
      override public function get currentAction() : *
      {
         return this._currentAction;
      }
      
      override public function dispose() : void
      {
         if(Boolean(_info))
         {
            _info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangeII);
         }
         if(Boolean(this._light01))
         {
            this._light01.dispose();
         }
         this._light01 = null;
         if(Boolean(this._light02))
         {
            this._light02.dispose();
         }
         this._light02 = null;
         if(Boolean(this._light2) && Boolean(this._light2.parent))
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = null;
         if(Boolean(this._light1) && Boolean(this._light1.parent))
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = null;
         super.dispose();
         if(Boolean(this._characterWithoutWeapon))
         {
            this._characterWithoutWeapon.dispose();
         }
         this._characterWithoutWeapon = null;
         if(Boolean(this._staticBmp))
         {
            ObjectUtils.disposeAllChildren(this._staticBmp);
            ObjectUtils.disposeObject(this._staticBmp);
            this._staticBmp = null;
         }
         if(Boolean(this._characterWithWeapon))
         {
            this._characterWithWeapon.dispose();
         }
         this._characterWithWeapon = null;
         if(Boolean(this._wing) && Boolean(this._wing.parent))
         {
            this._wing.parent.removeChild(this._wing);
         }
         this._wing = null;
         if(Boolean(this._winCrtBmd))
         {
            this._winCrtBmd.dispose();
         }
         this._winCrtBmd = null;
         if(Boolean(this._wpCrtBmd))
         {
            this._wpCrtBmd.dispose();
         }
         this._wpCrtBmd = null;
         if(Boolean(this._loading) && Boolean(this._loading.parent))
         {
            this._loading.parent.removeChild(this._loading);
         }
         this._loading = null;
         this._lightPos = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

