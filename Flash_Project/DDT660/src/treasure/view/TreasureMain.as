package treasure.view
{
   import com.pickgliss.manager.CacheSysManager;
   import ddt.constants.CacheConsts;
   import ddt.manager.ChatManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   
   public class TreasureMain extends BaseStateView
   {
      
      private var _treasure:TreasureView;
      
      public function TreasureMain()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         CacheSysManager.lock(CacheConsts.TREASURE);
         MainToolBar.Instance.hide();
         this._treasure = new TreasureView();
         addChild(this._treasure);
         ChatManager.Instance.state = ChatManager.CHAT_TREASURE_STATE;
         addChild(ChatManager.Instance.view);
         super.enter(prev,data);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         CacheSysManager.unlock(CacheConsts.TREASURE);
         CacheSysManager.getInstance().release(CacheConsts.TREASURE);
         MainToolBar.Instance.show();
         super.leaving(next);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.TREASURE;
      }
      
      override public function getBackType() : String
      {
         return StateType.FARM;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._treasure))
         {
            this._treasure.dispose();
            this._treasure = null;
         }
      }
   }
}

