package littleGame
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import littleGame.events.LittleGameSocketEvent;
   import littleGame.model.Scenario;
   import littleGame.view.LittleGameOptionView;
   
   public class LittleHall extends BaseStateView
   {
      
      private var _game:Scenario;
      
      private var _optionView:LittleGameOptionView;
      
      private var _gameLoader:LittleGameLoader;
      
      public function LittleHall()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         this._optionView = new LittleGameOptionView();
         addChild(this._optionView);
         ChatManager.Instance.state = ChatManager.CHAT_LITTLEHALL;
         ChatManager.Instance.view.visible = true;
         ChatManager.Instance.chatDisabled = false;
         addChild(ChatManager.Instance.view);
         this.addEvent();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         super.enter(prev,data);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         KeyboardShortcutsManager.Instance.cancelForbidden();
         if(Boolean(this._optionView))
         {
            ObjectUtils.disposeObject(this._optionView);
         }
         this._optionView = null;
         super.leaving(next);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.START_LOAD,this.__loadGame);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.GAME_START,this.__gameStart);
      }
      
      private function __gameStart(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.enterGame(this._game,event.pkg);
         StateManager.setState(StateType.LITTLEGAME,this._game);
         this._game = null;
      }
      
      private function __loadGame(event:LittleGameSocketEvent) : void
      {
         this._game = LittleGameManager.Instance.createGame(event.pkg);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadClose);
         UIModuleSmallLoading.Instance.show();
         this._gameLoader = new LittleGameLoader(this._game);
         this._gameLoader.addEventListener(LoaderEvent.COMPLETE,this.__gameComplete);
         this._gameLoader.addEventListener(LoaderEvent.PROGRESS,this.__gameLoaderProgress);
         this._gameLoader.startup();
      }
      
      private function __gameLoaderProgress(event:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = this._gameLoader.progress;
      }
      
      private function __loadClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadClose);
         this._gameLoader.shutdown();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.START_LOAD,this.__loadGame);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.GAME_START,this.__gameStart);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadClose);
      }
      
      private function __gameComplete(event:LoaderEvent) : void
      {
         var loader:LittleGameLoader = event.currentTarget as LittleGameLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__gameComplete);
         loader.removeEventListener(LoaderEvent.PROGRESS,this.__gameLoaderProgress);
         this._game.gameLoader = loader;
         this._game.grid = loader.grid;
         this._game.grid.calculateLinks(0);
         UIModuleSmallLoading.Instance.hide();
         LittleGameManager.Instance.loadComplete();
      }
      
      override public function getType() : String
      {
         return StateType.LITTLEHALL;
      }
   }
}

