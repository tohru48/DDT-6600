package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GameCountDownView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _hundredsTxt:FilterFrameText;
      
      private var _tensTxt:FilterFrameText;
      
      private var _unitTxt:FilterFrameText;
      
      private var _total:int;
      
      private var _timer:Timer;
      
      public function GameCountDownView(total:int)
      {
         super();
         this._total = total;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.gameCountDown.bg");
         this._hundredsTxt = ComponentFactory.Instance.creatComponentByStylename("gameView.countDownView.txt");
         this._tensTxt = ComponentFactory.Instance.creatComponentByStylename("gameView.countDownView.txt");
         PositionUtils.setPos(this._tensTxt,"gameView.countDownView.tensTxtPos");
         this._unitTxt = ComponentFactory.Instance.creatComponentByStylename("gameView.countDownView.txt");
         PositionUtils.setPos(this._unitTxt,"gameView.countDownView.unitTxtPos");
         addChild(this._bg);
         addChild(this._hundredsTxt);
         addChild(this._tensTxt);
         addChild(this._unitTxt);
         this.refreshTxt();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._total;
         if(this._total <= 0)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this.refreshTxt();
      }
      
      private function refreshTxt() : void
      {
         this._hundredsTxt.text = int(this._total / 100).toString();
         this._tensTxt.text = int(this._total % 100 / 10).toString();
         this._unitTxt.text = int(this._total % 10).toString();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._hundredsTxt = null;
         this._tensTxt = null;
         this._unitTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

