package zodiac
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ZodiacManager extends EventDispatcher
   {
      
      private static var _instance:ZodiacManager;
      
      public var questArr:Array;
      
      public var indexTypeArr:Dictionary;
      
      public var awardRecord:int;
      
      public var maxCounts:int;
      
      public var finshedCounts:int;
      
      public var isOpen:Boolean;
      
      private var newIndex:int;
      
      private var _frame:ZodiacFrame;
      
      public var index:int = 0;
      
      private var _loadComplete:Boolean;
      
      private var _useFirst:Boolean = true;
      
      public var inRolling:Boolean = false;
      
      private var _questCounts:int = 0;
      
      public function ZodiacManager(instanceClass:InstanceClass, target:IEventDispatcher = null)
      {
         super(target);
         this.indexTypeArr = new Dictionary();
      }
      
      public static function get instance() : ZodiacManager
      {
         var instanceclass:InstanceClass = null;
         if(_instance == null)
         {
            instanceclass = new InstanceClass();
            _instance = new ZodiacManager(instanceclass);
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ZODIAC,this.__zodiacHandler);
      }
      
      public function get questCounts() : int
      {
         this._questCounts = 0;
         for(var i:int = 0; i < this.questArr.length; i++)
         {
            if(this.questArr[i] != 0)
            {
               ++this._questCounts;
            }
         }
         return this._questCounts;
      }
      
      private function __zodiacHandler(e:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         var temp:int = 0;
         var pkg:PackageIn = e.pkg;
         var cmd:int = pkg.readInt();
         switch(cmd)
         {
            case 1:
               this.isOpen = pkg.readBoolean();
               if(this.questArr == null)
               {
                  this.questArr = [];
               }
               for(i = 0; i < 12; i++)
               {
                  this.questArr[i] = pkg.readInt();
               }
               this.awardRecord = pkg.readInt();
               this.maxCounts = pkg.readInt();
               this.finshedCounts = pkg.readInt();
               this.setIndexTypeDic(pkg);
               break;
            case 2:
               this.isOpen = pkg.readBoolean();
               if(this.questArr == null)
               {
                  this.questArr = [];
               }
               for(j = 0; j < 12; j++)
               {
                  temp = pkg.readInt();
                  if(this.questArr[j] != temp && temp != 0)
                  {
                     this.newIndex = j + 1;
                     this.questArr[j] = temp;
                     if(Boolean(this._frame))
                     {
                        this._frame.rollingView.rolling(this.newIndex);
                     }
                     this.setCurrentIndexView(this.newIndex);
                  }
                  this.questArr[j] = temp;
               }
               this.awardRecord = pkg.readInt();
               this.maxCounts = pkg.readInt();
               this.finshedCounts = pkg.readInt();
               this.setIndexTypeDic(pkg);
               this.updateMessage();
         }
         if(this.isOpen)
         {
            this.createIcon();
         }
         else
         {
            this.removeIcon();
         }
      }
      
      private function setIndexTypeDic(pkg:PackageIn) : void
      {
         var qID:int = 0;
         var type:int = 0;
         var len:int = pkg.readInt();
         for(var m:int = 0; m < len; m++)
         {
            qID = pkg.readInt();
            type = pkg.readInt();
            this.indexTypeArr[qID] = type;
         }
      }
      
      public function updateMessage() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.mainView.updateView();
            this._frame.rollingView.update();
         }
      }
      
      public function createIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ZODIAC,true);
      }
      
      public function removeIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ZODIAC,false);
      }
      
      public function frameDispose() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.dispose();
            this._frame = null;
         }
      }
      
      public function setCurrentIndexView($index:int) : void
      {
         if(this.inRolling == true)
         {
            return;
         }
         this.index = $index;
         if(Boolean(this._frame))
         {
            this._frame.mainView.setViewIndex(this.index);
         }
      }
      
      public function getCurrentIndex() : int
      {
         var i:int = 0;
         if(this.index == 0)
         {
            for(i = 0; i < this.questArr.length; i++)
            {
               if(this.questArr[i] != 0)
               {
                  this.index = i + 1;
               }
            }
         }
         return this.index;
      }
      
      public function showFrame() : void
      {
         if(this._loadComplete)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainFrame.ZodiacFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         else if(this._useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ZODIAC);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ZODIAC)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.ZODIAC)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            this._loadComplete = true;
            this._useFirst = false;
            this.showFrame();
         }
      }
   }
}

class InstanceClass
{
   
   public function InstanceClass()
   {
      super();
   }
}
