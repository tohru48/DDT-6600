package superWinner.view.bigAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import superWinner.controller.SuperWinnerController;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerBigAwardView extends Sprite implements Disposeable
   {
      
      private var _awardsArr:Vector.<SuperWinnerBigAward> = new Vector.<SuperWinnerBigAward>(6,true);
      
      public function SuperWinnerBigAwardView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:uint = 0;
         var awards:SuperWinnerBigAward = null;
         var point:Point = null;
         for(i = 1; i <= 6; i++)
         {
            awards = new SuperWinnerBigAward(i);
            point = ComponentFactory.Instance.creatCustomObject("superWinner.bigAward" + i);
            awards.x = point.x;
            awards.y = point.y;
            this._awardsArr[i - 1] = awards;
            (function(mc:SuperWinnerBigAward, ii:uint):void
            {
               mc.addEventListener(MouseEvent.ROLL_OVER,showTip);
               mc.addEventListener(MouseEvent.ROLL_OUT,hideTip);
            })(awards,i);
            addChild(awards);
         }
      }
      
      private function showTip(e:MouseEvent) : void
      {
         var award:SuperWinnerBigAward = e.currentTarget as SuperWinnerBigAward;
         var evt:SuperWinnerEvent = new SuperWinnerEvent(SuperWinnerEvent.SHOW_TIP);
         evt.resultData = award.awardType;
         this.dispatchEvent(evt);
      }
      
      private function hideTip(e:MouseEvent) : void
      {
         var award:SuperWinnerBigAward = e.currentTarget as SuperWinnerBigAward;
         var evt:SuperWinnerEvent = new SuperWinnerEvent(SuperWinnerEvent.HIDE_TIP);
         evt.resultData = award.awardType;
         this.dispatchEvent(evt);
      }
      
      private function initEvent() : void
      {
         SuperWinnerController.instance.model.addEventListener(SuperWinnerEvent.FLUSH_AWARDS,this.flushAwards);
      }
      
      private function flushAwards(e:SuperWinnerEvent) : void
      {
         var awards:Array = SuperWinnerController.instance.model.awards;
         for(var i:uint = 0; i < this._awardsArr.length; i++)
         {
            this._awardsArr[i].awardNum = awards[i];
         }
      }
      
      private function removeEvent() : void
      {
         SuperWinnerController.instance.model.removeEventListener(SuperWinnerEvent.FLUSH_AWARDS,this.flushAwards);
      }
      
      public function dispose() : void
      {
         var mc:SuperWinnerBigAward = null;
         for(var i:uint = 0; i < this._awardsArr.length; i++)
         {
            mc = this._awardsArr[i];
            if(mc.hasEventListener(MouseEvent.ROLL_OVER))
            {
               mc.removeEventListener(MouseEvent.ROLL_OVER,this.showTip);
            }
            if(mc.hasEventListener(MouseEvent.ROLL_OUT))
            {
               mc.removeEventListener(MouseEvent.ROLL_OUT,this.hideTip);
            }
         }
         this._awardsArr = null;
         ObjectUtils.removeChildAllChildren(this);
         this.removeEvent();
      }
   }
}

