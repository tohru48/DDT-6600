package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.utils.MD5;
   import ddt.events.DuowanInterfaceEvent;
   import flash.events.EventDispatcher;
   
   public class DuowanInterfaceManage extends EventDispatcher
   {
      
      private static var _instance:DuowanInterfaceManage;
      
      private var key:String;
      
      public function DuowanInterfaceManage()
      {
         super();
         this.key = "sdkxccjlqaoehtdwjkdycdrw";
         addEventListener(DuowanInterfaceEvent.ADD_ROLE,this.__userActionNotice);
         addEventListener(DuowanInterfaceEvent.UP_GRADE,this.__upGradeNotice);
         addEventListener(DuowanInterfaceEvent.ONLINE,this.__onLineNotice);
         addEventListener(DuowanInterfaceEvent.OUTLINE,this.__outLineNotice);
      }
      
      public static function get Instance() : DuowanInterfaceManage
      {
         if(_instance == null)
         {
            _instance = new DuowanInterfaceManage();
         }
         return _instance;
      }
      
      private function __userActionNotice(event:DuowanInterfaceEvent) : void
      {
         var username:String = PlayerManager.Instance.Self.ID.toString();
         username = encodeURI(username);
         var sign:String = MD5.hash(username + "4" + this.key);
         this.send("4",username,sign);
      }
      
      private function __upGradeNotice(event:DuowanInterfaceEvent) : void
      {
         var username:String = PlayerManager.Instance.Self.ID.toString();
         username = encodeURI(username);
         var sign:String = MD5.hash(username + "1" + this.key);
         this.send("1",username,sign);
      }
      
      private function __onLineNotice(event:DuowanInterfaceEvent) : void
      {
         var username:String = PlayerManager.Instance.Self.ID.toString();
         username = encodeURI(username);
         var sign:String = MD5.hash(username + "2" + this.key);
         this.send("2",username,sign);
      }
      
      private function __outLineNotice(event:DuowanInterfaceEvent) : void
      {
         var username:String = PlayerManager.Instance.Self.ID.toString();
         username = encodeURI(username);
         var sign:String = MD5.hash(username + "3" + this.key);
         this.send("3",username,sign);
      }
      
      private function send(op:String, username:String, sign:String) : void
      {
         var requestURL:String = PathManager.userActionNotice();
         if(requestURL == "")
         {
            return;
         }
         requestURL = requestURL.replace("{username}",username);
         requestURL = requestURL.replace("{type}",op);
         requestURL = requestURL.replace("{sign}",sign);
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(requestURL,BaseLoader.REQUEST_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete2);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __loaderComplete2(event:LoaderEvent) : void
      {
      }
   }
}

