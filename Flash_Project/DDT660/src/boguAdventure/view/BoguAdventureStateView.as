package boguAdventure.view
{
   import boguAdventure.BoguAdventureControl;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.SimpleReturnBar;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class BoguAdventureStateView extends BaseStateView
   {
      
      private var _bg:Bitmap;
      
      private var _gameView:BoguAdventureGameView;
      
      private var _control:BoguAdventureControl;
      
      private var _returnBar:SimpleReturnBar;
      
      public function BoguAdventureStateView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_BOGU_ADVENTURE);
         super.enter(prev,data);
      }
      
      override public function addedToStage() : void
      {
         this._bg = UICreatShortcut.creatAndAdd("boguAdventure.stateView.Bg",this);
         this._control = new BoguAdventureControl();
         this._gameView = new BoguAdventureGameView(this._control);
         addChild(this._gameView);
         this._returnBar = UICreatShortcut.creatAndAdd("asset.simpleReturnBar.Button",this);
         this._returnBar.returnCell = this.returnCell;
         this.initEvent();
         SocketManager.Instance.out.sendBoguAdventureEnter();
         KeyboardShortcutsManager.Instance.forbiddenFull();
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.__onUpdateView);
      }
      
      private function __onUpdateView(e:Event) : void
      {
         this._gameView.updateView();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onUpdateView);
      }
      
      private function returnCell() : void
      {
         if(this._control.isMove)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notReturn"));
            return;
         }
         StateManager.setState(StateType.MAIN);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.BOGU_ADVENTURE;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         super.leaving(next);
      }
      
      override public function dispose() : void
      {
         CacheSysManager.unlock(CacheConsts.ALERT_IN_BOGU_ADVENTURE);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_BOGU_ADVENTURE);
         SocketManager.Instance.out.sendOutBoguAdventure();
         this.removeEvent();
         KeyboardShortcutsManager.Instance.cancelForbidden();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._returnBar);
         this._returnBar = null;
         this._gameView.dispose();
         this._gameView = null;
         this._control.dispose();
         this._control = null;
         super.dispose();
      }
   }
}

