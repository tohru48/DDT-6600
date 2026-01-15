package overSeasCommunity.overseas.controllers
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import overSeasCommunity.overseas.model.BaseCommunityModel;
   
   public class BaseCommunityController extends EventDispatcher
   {
      
      protected var _model:BaseCommunityModel;
      
      protected var _openTypeIDList:Array;
      
      private var _isShowFrame:Boolean = true;
      
      public function BaseCommunityController(model:BaseCommunityModel)
      {
         super();
         this._model = model;
         this._openTypeIDList = [];
      }
      
      public function get isShowFrame() : Boolean
      {
         return this._isShowFrame;
      }
      
      public function set isShowFrame(value:Boolean) : void
      {
         this._isShowFrame = value;
      }
      
      public function get openTypeIDList() : Array
      {
         return this._openTypeIDList;
      }
      
      public function set openTypeIDList(value:Array) : void
      {
         this._openTypeIDList = value;
      }
      
      public function sendDynamic() : void
      {
         SocketManager.Instance.out.sendSnsMsg(this._model.typeId);
      }
      
      protected function getFeedParam($typeID:int) : *
      {
      }
      
      public function getSayStr() : String
      {
         var str:String = "";
         switch(this._model.typeId)
         {
            case 1:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextI");
               break;
            case 2:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextII");
               break;
            case 3:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIII");
               break;
            case 4:
            case 6:
            case 7:
            case 8:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
               break;
            case 5:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextV");
               break;
            case 9:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVI");
               break;
            case 10:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVII");
               break;
            case 11:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextVIII");
               break;
            default:
               str = LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextIV");
         }
         return str;
      }
   }
}

