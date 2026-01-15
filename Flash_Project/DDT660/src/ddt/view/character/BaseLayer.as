package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderQueue;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.utils.BitmapUtils;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import road7th.utils.StringHelper;
   
   public class BaseLayer extends Sprite implements ILayer
   {
      
      public static const ICON:String = "icon";
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const STATE:String = "state";
      
      protected var _queueLoader:LoaderQueue;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _colors:Array;
      
      protected var _gunBack:Boolean;
      
      protected var _hairType:String;
      
      protected var _currentEdit:uint;
      
      private var _callBack:Function;
      
      protected var _color:String;
      
      protected var _defaultLayer:uint;
      
      protected var _bitmaps:Vector.<Bitmap>;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      protected var _pic:String;
      
      private var _isComplete:Boolean;
      
      public function BaseLayer(info:ItemTemplateInfo, color:String = "", gunback:Boolean = false, hairType:int = 1, pic:String = null)
      {
         this._info = info;
         this._color = color == null ? "" : color;
         this._gunBack = gunback;
         this._hairType = hairType == 1 ? "B" : "A";
         this._pic = pic == null || String(pic) == "undefined" ? this._info.Pic : pic;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._queueLoader = new LoaderQueue();
         this._bitmaps = new Vector.<Bitmap>();
         this._colors = [];
         this.initLoaders();
      }
      
      protected function initLoaders() : void
      {
         var i:int = 0;
         var url:String = null;
         var l:BitmapLoader = null;
         if(this._info != null)
         {
            for(i = 0; i < this._info.Property8.length; i++)
            {
               url = this.getUrl(int(this._info.Property8.charAt(i)));
               if(url.length != 0)
               {
                  l = LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
                  this._queueLoader.addLoader(l);
               }
            }
            this._defaultLayer = 0;
            this._currentEdit = this._queueLoader.length;
         }
      }
      
      protected function initColors(color:String) : void
      {
         var i:int = 0;
         var lightTransfrom:ColorTransform = null;
         var lightBitmap:Bitmap = null;
         this._colors = color.split("|");
         if(this._bitmaps.length == 0)
         {
            return;
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         for(var j:int = 0; j < this._bitmaps.length; j++)
         {
            if(Boolean(this._bitmaps[j]))
            {
               addChild(this._bitmaps[j]);
               this._bitmaps[j].visible = false;
            }
         }
         if(Boolean(this._bitmaps[this._defaultLayer]))
         {
            this._bitmaps[this._defaultLayer].visible = true;
         }
         if(this._colors.length == this._bitmaps.length)
         {
            for(i = 0; i < this._colors.length; i++)
            {
               if(!StringHelper.isNullOrEmpty(this._colors[i]) && this._colors[i].toString() != "undefined" && this._colors[i].toString() != "null")
               {
                  if(this._bitmaps[i] != null)
                  {
                     this._bitmaps[i].visible = true;
                     this._bitmaps[i].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[i]);
                     lightTransfrom = BitmapUtils.getHightlightColorTransfrom(this._colors[i]);
                     lightBitmap = new Bitmap(this._bitmaps[i].bitmapData,"auto",true);
                     if(Boolean(lightTransfrom))
                     {
                        lightBitmap.transform.colorTransform = lightTransfrom;
                     }
                     lightBitmap.blendMode = BlendMode.HARDLIGHT;
                     addChild(lightBitmap);
                  }
               }
               else if(this._bitmaps[i] != null)
               {
                  this._bitmaps[i].transform.colorTransform = new ColorTransform();
               }
            }
         }
      }
      
      public function getContent() : DisplayObject
      {
         return this;
      }
      
      public function setColor(color:*) : Boolean
      {
         if(this._info == null || color == null)
         {
            return false;
         }
         this._color = String(color);
         this.initColors(color);
         return true;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         if(this.info == value)
         {
            return;
         }
         this.clear();
         this._info = value;
         if(Boolean(this._info))
         {
            this.initLoaders();
            this.load(this._callBack);
         }
      }
      
      public function set currentEdit(n:int) : void
      {
         this._currentEdit = n;
         if(this._currentEdit > this._bitmaps.length)
         {
            this._currentEdit = this._bitmaps.length;
         }
         else if(this._currentEdit < 1)
         {
            this._currentEdit = 1;
         }
      }
      
      public function get currentEdit() : int
      {
         return this._currentEdit;
      }
      
      public function dispose() : void
      {
         this.clear();
         this._info = null;
         this._callBack = null;
         this._bitmaps = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      protected function clearBitmap() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bitmaps = new Vector.<Bitmap>();
      }
      
      protected function clear() : void
      {
         if(Boolean(this._queueLoader))
         {
            this._queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
            this._queueLoader.dispose();
            this._queueLoader = null;
         }
         this.clearBitmap();
         this._colors = [];
      }
      
      final public function load(callBack:Function) : void
      {
         this._callBack = callBack;
         if(this._info == null)
         {
            this.loadCompleteCallBack();
            return;
         }
         this._queueLoader.addEventListener(Event.COMPLETE,this.__loadComplete);
         this._queueLoader.start();
      }
      
      protected function getUrl(layer:int) : String
      {
         return PathManager.solveGoodsPath(this._info.CategoryID,this._pic,this._info.NeedSex == 1,SHOW,this._hairType,String(layer),this._info.Level,this._gunBack,int(this._info.Property1));
      }
      
      protected function __loadComplete(event:Event) : void
      {
         this.reSetBitmap();
         this._queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
         this._queueLoader.removeEvent();
         this.initColors(this._color);
         this.loadCompleteCallBack();
      }
      
      public function reSetBitmap() : void
      {
         var i:int = 0;
         this.clearBitmap();
         for(i = 0; i < this._queueLoader.loaders.length; i++)
         {
            this._bitmaps.push(this._queueLoader.loaders[i].content);
            if(Boolean(this._bitmaps[i]))
            {
               this._bitmaps[i].smoothing = true;
               this._bitmaps[i].visible = false;
               addChild(this._bitmaps[i]);
            }
         }
      }
      
      protected function loadCompleteCallBack() : void
      {
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __onBitmapError(event:LoaderEvent) : void
      {
         this._isAllLoadSucceed = false;
      }
      
      public function get isAllLoadSucceed() : Boolean
      {
         return this._isAllLoadSucceed;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}

