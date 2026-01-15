package pyramid.view
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   
   public class PyramidSystem extends BaseStateView
   {
      
      private var _pyramidView:PyramidView;
      
      public function PyramidSystem()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_PYRAMID);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._pyramidView = new PyramidView();
         addChild(this._pyramidView);
         super.enter(prev,data);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         CacheSysManager.unlock(CacheConsts.ALERT_IN_PYRAMID);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_PYRAMID);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.leaving(next);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.PYRAMID;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._pyramidView);
         this._pyramidView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

