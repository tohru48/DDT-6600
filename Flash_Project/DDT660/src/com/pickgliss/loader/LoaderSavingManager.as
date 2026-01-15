package com.pickgliss.loader
{
   import com.pickgliss.events.LoaderResourceEvent;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class LoaderSavingManager extends EventDispatcher
   {
      
      private static var _version:int;
      
      private static var _files:Object;
      
      private static var _saveTimer:Timer;
      
      private static var _so:SharedObject;
      
      private static var _changed:Boolean;
      
      private static var _save:Array;
      
      private static const LOCAL_FILE:String = "7road/files";
      
      private static var _cacheFile:Boolean = false;
      
      private static const READ_ERROR_ID:int = 2030;
      
      public static var eventDispatcher:EventDispatcher = new EventDispatcher();
      
      public static var ReadShareError:Boolean = false;
      
      private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
      
      private static const _reg2:RegExp = /[:|.|\/]/g;
      
      private static var _isSaving:Boolean = false;
      
      private static var _shape:Shape = new Shape();
      
      private static var _retryCount:int = 0;
      
      public function LoaderSavingManager()
      {
         super();
      }
      
      public static function get Version() : int
      {
         return _version;
      }
      
      public static function set Version(param1:int) : void
      {
         _version = param1;
      }
      
      public static function set cacheAble(param1:Boolean) : void
      {
         _cacheFile = param1;
      }
      
      public static function get cacheAble() : Boolean
      {
         return _cacheFile;
      }
      
      public static function setup() : void
      {
         _cacheFile = false;
         _save = new Array();
         loadFilesInLocal();
      }
      
      public static function applyUpdate(param1:int, param2:int, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(param2 <= param1)
         {
            return;
         }
         if(_version < param2)
         {
            if(_version < param1)
            {
               _so.data["data"] = _files = new Object();
               LoadResourceManager.Instance.addDeleteRequest("*");
            }
            else
            {
               _loc4_ = new Array();
               for each(_loc5_ in param3)
               {
                  _loc9_ = getPath(_loc5_);
                  _loc9_ = _loc9_.replace("*","\\w*");
                  _loc4_.push(new RegExp("^" + _loc9_));
                  LoadResourceManager.Instance.addDeleteRequest(_loc5_);
               }
               _loc6_ = new Array();
               for(_loc7_ in _files)
               {
                  _loc7_ = _loc7_.toLocaleLowerCase();
                  if(hasUpdate(_loc7_,_loc4_))
                  {
                     _loc6_.push(_loc7_);
                  }
               }
               for each(_loc8_ in _loc6_)
               {
                  delete _files[_loc8_];
               }
            }
            _version = param2;
            _files["version"] = param2;
            _changed = true;
         }
      }
      
      public static function clearFiles(param1:String) : void
      {
         var updated:Array = null;
         var t:String = null;
         var temp:Array = null;
         var f:String = null;
         var n:String = null;
         var filter:String = param1;
         if(Boolean(_files))
         {
            updated = new Array();
            t = getPath(filter);
            t = t.replace("*","\\w*");
            updated.push(new RegExp("^" + t));
            temp = new Array();
            for(f in _files)
            {
               f = f.toLocaleLowerCase();
               if(hasUpdate(f,updated))
               {
                  temp.push(f);
               }
            }
            for each(n in temp)
            {
               delete _files[n];
            }
            try
            {
               if(_cacheFile)
               {
                  _so.flush(20 * 1024 * 1024);
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public static function loadFilesInLocal() : void
      {
         try
         {
            _so = SharedObject.getLocal(LOCAL_FILE,"/");
            _so.addEventListener(NetStatusEvent.NET_STATUS,__netStatus);
            _files = _so.data["data"];
            if(_files == null)
            {
               _files = new Object();
               _so.data["data"] = _files;
               _files["version"] = _version = -1;
               _cacheFile = false;
            }
            else
            {
               _version = _files["version"];
               _cacheFile = true;
            }
         }
         catch(e:Error)
         {
            if(e.errorID == READ_ERROR_ID)
            {
               resetErrorVersion();
            }
         }
      }
      
      public static function resetErrorVersion() : void
      {
         _version = Math.random() * -777777;
         ReadShareError = true;
      }
      
      private static function getPath(param1:String) : String
      {
         var _loc2_:int = int(param1.indexOf("?"));
         if(_loc2_ != -1)
         {
            param1 = param1.substring(0,_loc2_);
         }
         param1 = param1.replace(_reg1,"");
         return param1.replace(_reg2,"-").toLocaleLowerCase();
      }
      
      public static function saveFilesToLocal() : void
      {
         try
         {
            if(_files && _changed && _cacheFile && !_isSaving)
            {
               _isSaving = true;
               _shape.addEventListener(Event.ENTER_FRAME,save);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private static function save(param1:Event) : void
      {
         var state:String = null;
         var tick:int = 0;
         var obj:Object = null;
         var so:SharedObject = null;
         var event:Event = param1;
         try
         {
            state = _so.flush(20 * 1024 * 1024);
            if(state != SharedObjectFlushStatus.PENDING)
            {
               tick = getTimer();
               if(_save.length > 0)
               {
                  obj = _save[0];
                  so = SharedObject.getLocal(obj.p,"/");
                  so.data["data"] = obj.d;
                  so.flush();
                  _files[obj.p] = true;
                  _so.flush();
                  _save.shift();
               }
               if(_save.length == 0)
               {
                  _shape.removeEventListener(Event.ENTER_FRAME,save);
                  _changed = false;
                  _isSaving = false;
               }
            }
         }
         catch(e:Error)
         {
            _shape.removeEventListener(Event.ENTER_FRAME,save);
         }
      }
      
      private static function hasUpdate(param1:String, param2:Array) : Boolean
      {
         var _loc3_:RegExp = null;
         for each(_loc3_ in param2)
         {
            if(Boolean(param1.match(_loc3_)))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function loadCachedFile(param1:String, param2:Boolean) : ByteArray
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:SharedObject = null;
         if(Boolean(_files))
         {
            _loc3_ = getPath(param1);
            _loc4_ = getTimer();
            _loc5_ = findInSave(_loc3_);
            if(_loc5_ == null && Boolean(_files[_loc3_]))
            {
               _loc6_ = SharedObject.getLocal(_loc3_,"/");
               _loc5_ = ByteArray(_loc6_.data["data"]);
            }
            if(Boolean(_loc5_))
            {
               return _loc5_;
            }
         }
         return null;
      }
      
      private static function findInSave(param1:String) : ByteArray
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _save)
         {
            if(_loc2_.p == param1)
            {
               return ByteArray(_loc2_.d);
            }
         }
         return null;
      }
      
      public static function cacheFile(param1:String, param2:ByteArray, param3:Boolean) : void
      {
         var _loc4_:String = null;
         if(!LoadResourceManager.Instance.isMicroClient && Boolean(_files))
         {
            _loc4_ = getPath(param1);
            _save.push({
               "p":_loc4_,
               "d":param2
            });
            _changed = true;
         }
      }
      
      private static function __netStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "SharedObject.Flush.Failed":
               if(_retryCount < 1)
               {
                  _so.flush(20 * 1024 * 1024);
                  ++_retryCount;
                  break;
               }
               cacheAble = false;
               break;
            default:
               _retryCount = 0;
         }
      }
      
      public static function updateList(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1)
         {
            parseUpdate(_loc2_);
         }
         LoadResourceManager.Instance.addEventListener(LoaderResourceEvent.DELETE,__deleteComplete);
         LoadResourceManager.Instance.startDelete();
      }
      
      protected static function __deleteComplete(param1:Event) : void
      {
         eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public static function parseUpdate(param1:XML) : void
      {
         var vs:XMLList = null;
         var unode:XML = null;
         var fromv:int = 0;
         var tov:int = 0;
         var fs:XMLList = null;
         var updatelist:Array = null;
         var fn:XML = null;
         var config:XML = param1;
         try
         {
            vs = config..version;
            for each(unode in vs)
            {
               fromv = int(unode.@from);
               tov = int(unode.@to);
               fs = unode..file;
               updatelist = new Array();
               for each(fn in fs)
               {
                  updatelist.push(String(fn.@value));
               }
               applyUpdate(fromv,tov,updatelist);
            }
         }
         catch(e:Error)
         {
            _version = -1;
            if(Boolean(_so))
            {
               _so.data["data"] = _files = new Object();
            }
            LoadResourceManager.Instance.addDeleteRequest("*");
            _changed = true;
         }
         saveFilesToLocal();
      }
      
      public static function get hasFileToSave() : Boolean
      {
         return _cacheFile && _changed;
      }
      
      public static function clearAllCache() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:SharedObject = null;
         if(LoadResourceManager.Instance.isMicroClient)
         {
            LoadResourceManager.Instance.deleteResource("*");
         }
         if(!_so)
         {
            return;
         }
         var _loc1_:Array = [];
         for(_loc2_ in _files)
         {
            if(_loc2_ != "version")
            {
               _loc2_ = _loc2_.toLocaleLowerCase();
               _loc1_.push(_loc2_);
               delete _files[_loc2_];
            }
         }
         while(Boolean(_loc3_ = _loc1_.pop()))
         {
            _loc4_ = SharedObject.getLocal(_loc3_,"/");
            _loc4_.data["data"] = new Object();
            _loc4_.flush();
         }
         _version = -1;
         _so.data["data"] = _files = new Object();
         _so["version"] = -1;
         _so.flush();
      }
   }
}

