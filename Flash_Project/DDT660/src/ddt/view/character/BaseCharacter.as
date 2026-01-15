package ddt.view.character
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BaseCharacter extends Sprite implements ICharacter, Disposeable
   {
      
      public static const BASE_WIDTH:int = 120;
      
      public static const BASE_HEIGHT:int = 165;
      
      protected var _info:PlayerInfo;
      
      protected var _frames:Array;
      
      protected var _loader:ICharacterLoader;
      
      protected var _characterWidth:Number;
      
      protected var _characterHeight:Number;
      
      protected var _factory:ICharacterLoaderFactory;
      
      protected var _dir:int;
      
      protected var _container:Sprite;
      
      protected var _body:Bitmap;
      
      protected var _currentframe:int;
      
      protected var _loadCompleted:Boolean;
      
      protected var _picLines:int;
      
      protected var _picsPerLine:int;
      
      private var _autoClearLoader:Boolean;
      
      protected var _characterBitmapdata:BitmapData;
      
      protected var _bitmapChanged:Boolean;
      
      private var _lifeUpdate:Boolean;
      
      private var _disposed:Boolean;
      
      public function BaseCharacter(info:PlayerInfo, lifeUpdate:Boolean)
      {
         this._info = info;
         this._lifeUpdate = lifeUpdate;
         super();
         this.init();
         this.initEvent();
      }
      
      public function get characterWidth() : Number
      {
         return this._characterWidth;
      }
      
      public function get characterHeight() : Number
      {
         return this._characterHeight;
      }
      
      protected function init() : void
      {
         this._currentframe = -1;
         this.initSizeAndPics();
         this.createFrames();
         this._container = new Sprite();
         addChild(this._container);
         this._body = new Bitmap(new BitmapData(this._characterWidth + 1,this._characterHeight,true,0),PixelSnapping.NEVER,true);
         this._container.addChild(this._body);
         mouseEnabled = false;
         mouseChildren = false;
         this._loadCompleted = false;
      }
      
      protected function initSizeAndPics() : void
      {
         this.setCharacterSize(BASE_WIDTH,BASE_HEIGHT);
         this.setPicNum(1,3);
      }
      
      protected function initEvent() : void
      {
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      private function __addToStage(event:Event) : void
      {
         if(this._lifeUpdate)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function __removeFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(event:Event) : void
      {
         this.update();
      }
      
      public function update() : void
      {
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(Boolean(evt.changedProperties[PlayerInfo.STYLE]) || Boolean(evt.changedProperties[PlayerInfo.COLORS]))
         {
            if(this._loader == null || this._loader is GameCharacterLoader)
            {
               if(Boolean(this._loader))
               {
                  this._loader.dispose();
                  this._loader = null;
               }
               this.initLoader();
               this._loader.load(this.__loadComplete);
            }
            else
            {
               this._loader.update();
            }
         }
      }
      
      protected function setCharacterSize(w:Number, h:Number) : void
      {
         this._characterWidth = w;
         this._characterHeight = h;
      }
      
      protected function setPicNum(lines:int, perline:int) : void
      {
         this._picLines = lines;
         this._picsPerLine = perline;
      }
      
      public function setColor(color:*) : Boolean
      {
         return false;
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function get currentFrame() : int
      {
         return this._currentframe;
      }
      
      public function set characterBitmapdata(value:BitmapData) : void
      {
         if(value == this._characterBitmapdata)
         {
            return;
         }
         this._characterBitmapdata = value;
         this._bitmapChanged = true;
      }
      
      public function get characterBitmapdata() : BitmapData
      {
         return this._characterBitmapdata;
      }
      
      public function get completed() : Boolean
      {
         return this._loadCompleted;
      }
      
      public function getCharacterLoadLog() : String
      {
         if(this._loader is ShowCharacterLoader)
         {
            return (this._loader as ShowCharacterLoader).getUnCompleteLog();
         }
         return "not ShowCharacterLoader";
      }
      
      public function doAction(actionType:*) : void
      {
      }
      
      public function setDefaultAction(actionType:*) : void
      {
      }
      
      public function show(clearLoader:Boolean = true, dir:int = 1, small:Boolean = true) : void
      {
         this._dir = dir > 0 ? 1 : -1;
         scaleX = this._dir;
         this._autoClearLoader = clearLoader;
         if(!this._loadCompleted)
         {
            if(this._loader == null)
            {
               this.initLoader();
            }
            this._loader.load(this.__loadComplete);
         }
      }
      
      protected function __loadComplete(loader:ICharacterLoader) : void
      {
         this._loadCompleted = true;
         this.setContent();
         if(this._autoClearLoader && this._loader != null)
         {
            this._loader.dispose();
            this._loader = null;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function setContent() : void
      {
         if(this._loader != null)
         {
            if(Boolean(this._characterBitmapdata) && this._characterBitmapdata != this._loader.getContent()[0])
            {
               this._characterBitmapdata.dispose();
            }
            this.characterBitmapdata = this._loader.getContent()[0];
         }
         this.drawFrame(this._currentframe);
      }
      
      public function setFactory(factory:ICharacterLoaderFactory) : void
      {
         this._factory = factory;
      }
      
      protected function initLoader() : void
      {
         this._loader = this._factory.createLoader(this._info,CharacterLoaderFactory.SHOW);
      }
      
      public function drawFrame(frame:int, type:int = 0, clearOld:Boolean = true) : void
      {
         if(this._characterBitmapdata != null)
         {
            if(frame < 0 || frame >= this._frames.length)
            {
               frame = 0;
            }
            if(frame != this._currentframe || this._bitmapChanged)
            {
               this._bitmapChanged = false;
               this._currentframe = frame;
               this._body.bitmapData.copyPixels(this._characterBitmapdata,this._frames[this._currentframe],new Point(0,0));
            }
         }
      }
      
      protected function createFrames() : void
      {
         var i:int = 0;
         var m:Rectangle = null;
         this._frames = [];
         for(var j:int = 0; j < this._picLines; j++)
         {
            for(i = 0; i < this._picsPerLine; i++)
            {
               m = new Rectangle(i * this._characterWidth,j * this._characterHeight,this._characterWidth,this._characterHeight);
               this._frames.push(m);
            }
         }
      }
      
      public function set smoothing(value:Boolean) : void
      {
         this._body.smoothing = value;
      }
      
      public function set showGun(value:Boolean) : void
      {
      }
      
      public function setShowLight(b:Boolean, p:Point = null) : void
      {
      }
      
      public function get currentAction() : *
      {
         return "";
      }
      
      public function actionPlaying() : Boolean
      {
         return false;
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._disposed = true;
         this._info = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
         if(Boolean(this._loader))
         {
            this._loader.dispose();
            this._loader = null;
         }
         this._factory = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._body) && Boolean(this._body.bitmapData))
         {
            this._body.bitmapData.dispose();
         }
         this._body = null;
         if(Boolean(this._characterBitmapdata))
         {
            this._characterBitmapdata.dispose();
         }
         this._characterBitmapdata = null;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

