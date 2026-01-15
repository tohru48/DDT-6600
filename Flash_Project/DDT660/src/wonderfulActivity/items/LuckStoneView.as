package wonderfulActivity.items
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.views.IRightView;
   
   public class LuckStoneView extends Sprite implements IRightView
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _back:Bitmap;
      
      private var endData:Date;
      
      private var nowdate:Date;
      
      private var _timerTxt:FilterFrameText;
      
      public function LuckStoneView()
      {
         super();
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function init() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.luck.backgroud");
         addChild(this._back);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.luckStoneBtn");
         addChild(this._btn);
         this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.farmetimeTxt");
         addChild(this._timerTxt);
         this._btn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this.initTimer();
      }
      
      private function initTimer() : void
      {
         this.endData = WonderfulActivityManager.Instance.rouleEndTime;
         if(!this.endData)
         {
            this.endData = new Date(2013,5,5);
         }
         this.stoneTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("luckstone",this.stoneTimerHander);
      }
      
      private function stoneTimerHander() : void
      {
         this.nowdate = TimeManager.Instance.Now();
         if(this.nowdate.getTime() > this.endData.getTime())
         {
            return;
         }
         var str:String = WonderfulActivityManager.Instance.getTimeDiff(this.endData,this.nowdate);
         this._timerTxt.text = str;
      }
      
      protected function mouseClickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         RouletteManager.instance.useBless();
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("luckstone");
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

