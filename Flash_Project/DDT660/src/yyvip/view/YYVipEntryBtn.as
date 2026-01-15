package yyvip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import yyvip.YYVipManager;
   
   public class YYVipEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _isCanUsable:Boolean = true;
      
      public function YYVipEntryBtn()
      {
         super();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.yyVIPBtn");
         this._btn.tipData = LanguageMgr.GetTranslation("ddt.hallStateView.yyVipText");
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isCanUsable)
         {
            YYVipManager.instance.loadResModule();
            this._count = 60;
            this._timer.start();
            this._isCanUsable = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("yyVip.openMainFrame.limitTipTxt",this._count));
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._count;
         if(this._count <= 0)
         {
            this._timer.reset();
            this._timer.stop();
            this._isCanUsable = true;
            this._count = 0;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
         }
         this._timer = null;
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

