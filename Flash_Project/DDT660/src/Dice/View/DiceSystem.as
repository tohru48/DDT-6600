package Dice.View
{
   import Dice.Controller.DiceController;
   import com.pickgliss.manager.CacheSysManager;
   import ddt.constants.CacheConsts;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   
   public class DiceSystem extends BaseStateView
   {
      
      private var _diceView:DiceSystemView;
      
      public function DiceSystem()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_DICESYSTEM);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._diceView = new DiceSystemView(DiceController.Instance);
         AddPublicTipManager.Instance.type = AddPublicTipManager.DICESYS;
         addChild(this._diceView);
         super.enter(prev,data);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         CacheSysManager.unlock(CacheConsts.ALERT_IN_DICESYSTEM);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_DICESYSTEM);
         AddPublicTipManager.Instance.type = 0;
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.leaving(next);
      }
      
      override public function getType() : String
      {
         return StateType.DICE_SYSTEM;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._diceView))
         {
            this._diceView.dispose();
            this._diceView = null;
         }
      }
   }
}

