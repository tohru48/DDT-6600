package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class CampBattleMonsterRole extends CampBattlePlayer
   {
      
      private var walkList:Vector.<Point>;
      
      private var _timer:Timer;
      
      public function CampBattleMonsterRole(playerInfo:RoleData, callBack:Function = null)
      {
         super(playerInfo,callBack);
         this.walkList = new Vector.<Point>();
         this.walkList.push(new Point(993,901));
         this.walkList.push(new Point(1208,866));
         this.walkList.push(new Point(1124,644));
         this.walkList.push(new Point(1107,803));
         this.walkList.push(new Point(879,896));
         this._timer = new Timer(4000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
      }
      
      protected function mouseClickHander(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
      }
      
      private function timerHander(e:TimerEvent) : void
      {
         if(!scene)
         {
            return;
         }
         var index:int = Math.random() * this.walkList.length;
         var p:Point = this.walkList[index];
         walk(p);
      }
      
      override protected function enterFrameHander(e:Event) : void
      {
         update();
         playerWalkPath();
         characterMirror();
      }
   }
}

