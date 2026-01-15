package effortView
{
   import ddt.manager.EffortManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EffortController extends EventDispatcher
   {
      
      private var _currentRightViewType:int;
      
      private var _currentViewType:int;
      
      private var _isSelf:Boolean;
      
      public function EffortController()
      {
         super();
         this._currentRightViewType = 0;
         this._currentViewType = 0;
         this._isSelf = true;
      }
      
      public function set isSelf(isSelf:Boolean) : void
      {
         this._isSelf = isSelf;
      }
      
      public function set currentRightViewType(type:int) : void
      {
         this._currentRightViewType = type;
         if(this._isSelf)
         {
            this.updateRightView(this._currentRightViewType);
         }
         else
         {
            this.updateTempRightView(this._currentRightViewType);
         }
      }
      
      public function get currentRightViewType() : int
      {
         return this._currentRightViewType;
      }
      
      public function set currentViewType(type:int) : void
      {
         this._currentViewType = type;
         if(this._isSelf)
         {
            this.updateView(this._currentViewType);
         }
         else
         {
            this.updateTempView(this._currentViewType);
         }
      }
      
      public function get currentViewType() : int
      {
         return this._currentViewType;
      }
      
      private function updateRightView(type:int) : void
      {
         switch(type)
         {
            case 0:
               break;
            case 1:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getRoleEffort();
               break;
            case 2:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTaskEffort();
               break;
            case 3:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getDuplicateEffort();
               break;
            case 4:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getCombatEffort();
               break;
            case 5:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getIntegrationEffort();
               break;
            case 6:
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateView(type:int) : void
      {
         EffortManager.Instance.setEffortType(type);
      }
      
      private function updateTempRightView(type:int) : void
      {
         switch(type)
         {
            case 0:
               break;
            case 1:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempRoleEffort();
               break;
            case 2:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempTaskEffort();
               break;
            case 3:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempDuplicateEffort();
               break;
            case 4:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempCombatEffort();
               break;
            case 5:
               EffortManager.Instance.currentEffortList = EffortManager.Instance.getTempIntegrationEffort();
               break;
            case 6:
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateTempView(type:int) : void
      {
         EffortManager.Instance.setTempEffortType(type);
      }
   }
}

