package academy
{
   import ddt.data.player.AcademyPlayerInfo;
   
   public class AcademyModel
   {
      
      private var _requestType:Boolean;
      
      private var _currentSex:Boolean;
      
      private var _register:Boolean;
      
      private var _appshipStateType:Boolean;
      
      private var _academyPlayers:Vector.<AcademyPlayerInfo>;
      
      private var _currentAcademyItemInfo:AcademyPlayerInfo;
      
      private var _totalPage:int;
      
      private var _selfIsRegister:Boolean;
      
      private var _selfDescribe:String;
      
      public function AcademyModel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._academyPlayers = new Vector.<AcademyPlayerInfo>();
      }
      
      public function set list(players:Vector.<AcademyPlayerInfo>) : void
      {
         this._academyPlayers = players;
      }
      
      public function get list() : Vector.<AcademyPlayerInfo>
      {
         return this._academyPlayers;
      }
      
      public function set sex(value:Boolean) : void
      {
         this._currentSex = value;
      }
      
      public function get sex() : Boolean
      {
         return this._currentSex;
      }
      
      public function set state(value:Boolean) : void
      {
         this._appshipStateType = value;
      }
      
      public function get state() : Boolean
      {
         return this._appshipStateType;
      }
      
      public function set info(value:AcademyPlayerInfo) : void
      {
         this._currentAcademyItemInfo = value;
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._currentAcademyItemInfo;
      }
      
      public function set totalPage(value:int) : void
      {
         this._totalPage = value;
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      public function set selfIsRegister(value:Boolean) : void
      {
         this._selfIsRegister = value;
      }
      
      public function get selfIsRegister() : Boolean
      {
         return this._selfIsRegister;
      }
      
      public function set selfDescribe(value:String) : void
      {
         this._selfDescribe = value;
      }
      
      public function get selfDescribe() : String
      {
         return this._selfDescribe;
      }
   }
}

