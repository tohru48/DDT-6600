package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import ddt.data.DebugCommand;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class DebugManager
   {
      
      private static var _ins:DebugManager;
      
      private static const USER:String = "admin";
      
      private static const PWD:String = "ddt";
      
      private var _user:String;
      
      private var _pwd:String;
      
      private var _address:String = "127.0.0.1";
      
      private var _port:String = "5800";
      
      private var _started:Boolean = false;
      
      private var _loadedMonster:Boolean = false;
      
      private var _loader:Loader;
      
      public function DebugManager()
      {
         super();
      }
      
      public static function getInstance() : DebugManager
      {
         if(_ins == null)
         {
            _ins = new DebugManager();
         }
         return _ins;
      }
      
      public function get enabled() : Boolean
      {
         return this._started && this._loadedMonster;
      }
      
      private function loadMonster() : void
      {
         if(!this._loadedMonster)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__monsterComplete);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__progress);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
            this._loader.load(new URLRequest(PathManager.getMonsterPath()),new LoaderContext(false,ApplicationDomain.currentDomain));
         }
      }
      
      private function __progress(event:ProgressEvent) : void
      {
         var rate:int = event.bytesLoaded / event.bytesTotal * 100;
         ChatManager.Instance.sysChatYellow("Monster 已载入 " + rate + "%");
      }
      
      private function __ioError(event:IOErrorEvent) : void
      {
         var info:LoaderInfo = event.currentTarget as LoaderInfo;
         info.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         info.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         info.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         ChatManager.Instance.sysChatYellow("Monster io error: " + event.text);
      }
      
      protected function __monsterComplete(event:Event) : void
      {
         var info:LoaderInfo = event.currentTarget as LoaderInfo;
         info.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         info.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         info.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         this._loadedMonster = true;
         ChatManager.Instance.sysChatYellow("Monster载入完成。");
      }
      
      public function startup(str:String) : void
      {
         var arr:Array = null;
         var s:String = null;
         var param:Array = null;
         var monsterRef:Class = null;
         if(!this._started)
         {
            arr = str.split(" -");
            for each(s in arr)
            {
               param = s.split(" ");
               switch(param[0])
               {
                  case "u":
                     this._user = param[1];
                     break;
                  case "p":
                     this._pwd = param[1];
                     break;
                  case "host":
                     this._address = param[1];
                     break;
                  case "P":
                     this._port = param[1];
                     break;
               }
            }
            try
            {
               if(this._user != USER || this._pwd != PWD)
               {
                  return;
               }
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               if(!monsterRef["initialized"])
               {
                  monsterRef["initialize"](StageReferance.stage);
               }
               monsterRef["startup"](this._address,this._port,this.onDebuggerConnect);
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
            }
         }
      }
      
      private function onDebuggerConnect() : void
      {
         ChatManager.Instance.sysChatYellow("Monster 已经启动。");
         this._started = true;
      }
      
      public function shutdown() : void
      {
         var monsterRef:Class = null;
         if(this._started)
         {
            try
            {
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               monsterRef["shutdown"]();
               ChatManager.Instance.sysChatYellow("Monster 已经关闭。");
               this._started = false;
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
            }
         }
      }
      
      public function handle(str:String) : void
      {
         var op:String = null;
         if(!this._started)
         {
            if(str.split(" ")[0] == "#loadmonster")
            {
               this.loadMonster();
            }
            else if(str.split(" ")[0] == "#debug-startup" && this._loadedMonster)
            {
               this.startup(str);
            }
            else if(str.split(" ")[0] == "#info")
            {
               this.info();
            }
         }
         else if(this._loadedMonster)
         {
            op = String(str.split(" ")[0]).replace("#","");
            switch(op)
            {
               case DebugCommand.Shutdown:
                  this.shutdown();
            }
         }
      }
      
      private function info() : void
      {
         var output:String = "info:\n";
         var playerType:String = Capabilities.playerType;
         var playerVersion:String = Capabilities.version;
         var isDebugger:Boolean = Capabilities.isDebugger;
         output += "PlayerType:" + playerType;
         output += "\nPlayerVersion:" + playerVersion;
         output += "\nisDebugger:" + isDebugger;
         if(playerType == "Desktop")
         {
            output += "\ncpuArchitecture:" + Capabilities.cpuArchitecture;
         }
         output += "\nhasIME:" + Capabilities.hasIME;
         output += "\nlanguage:" + Capabilities.language;
         output += "\nos:" + Capabilities.os;
         output += "\nscreenResolutionX:" + Capabilities.screenResolutionX;
         output += "\nscreenResolutionY:" + Capabilities.screenResolutionY;
         ChatManager.Instance.sysChatYellow(output);
      }
   }
}

