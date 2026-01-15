package room.view.chooseMap
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DungeonMapItem extends BaseMapItem
   {
      
      private static const SHINE_DELAY:int = 200;
      
      private var _timer:Timer;
      
      public function DungeonMapItem()
      {
         super();
         this._timer = new Timer(SHINE_DELAY);
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
      }
      
      override protected function initView() : void
      {
         super.initView();
      }
      
      public function shine() : void
      {
         this._timer.start();
      }
      
      public function stopShine() : void
      {
         this._timer.stop();
         this._timer.reset();
         _selectedBg.visible = _selected;
      }
      
      private function __onTimer(evt:TimerEvent) : void
      {
         _selectedBg.visible = this._timer.currentCount % 2 == 1;
      }
      
      override public function set mapId(value:int) : void
      {
         _mapId = value;
         this.updateMapIcon();
         buttonMode = mapId == -1 ? false : true;
         _limitLevel.visible = buttonMode;
      }
      
      override protected function updateMapIcon() : void
      {
         var obj:Object = PlayerManager.Instance.Self.dungeonFlag;
         if(_mapId == -1)
         {
            ObjectUtils.disposeAllChildren(_mapIconContaioner);
            return;
         }
         super.updateMapIcon();
      }
      
      override public function dispose() : void
      {
         this.stopShine();
         super.dispose();
      }
   }
}

