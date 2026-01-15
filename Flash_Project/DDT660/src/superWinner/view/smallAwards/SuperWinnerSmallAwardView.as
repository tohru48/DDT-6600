package superWinner.view.smallAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import superWinner.controller.SuperWinnerController;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerSmallAwardView extends Sprite implements Disposeable
   {
      
      private var _awardsArr:Vector.<SuperWinnerSmallAward> = new Vector.<SuperWinnerSmallAward>(6,true);
      
      public function SuperWinnerSmallAwardView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:uint = 0;
         var awards:SuperWinnerSmallAward = null;
         var point:Point = null;
         for(i = 1; i <= 6; i++)
         {
            awards = new SuperWinnerSmallAward(i);
            point = ComponentFactory.Instance.creatCustomObject("superWinner.smallAward" + i);
            awards.x = point.x;
            awards.y = point.y;
            this._awardsArr[i - 1] = awards;
            addChild(awards);
         }
      }
      
      private function initEvent() : void
      {
         SuperWinnerController.instance.model.addEventListener(SuperWinnerEvent.FLUSH_MY_AWARDS,this.flushAwards);
      }
      
      private function flushAwards(e:SuperWinnerEvent) : void
      {
         var awards:Array = SuperWinnerController.instance.model.myAwards;
         for(var i:uint = 0; i < this._awardsArr.length; i++)
         {
            this._awardsArr[i].awardNum = awards[i];
         }
      }
      
      private function removeEvent() : void
      {
         SuperWinnerController.instance.model.removeEventListener(SuperWinnerEvent.FLUSH_MY_AWARDS,this.flushAwards);
      }
      
      public function dispose() : void
      {
         this._awardsArr = null;
         ObjectUtils.removeChildAllChildren(this);
         this.removeEvent();
      }
   }
}

