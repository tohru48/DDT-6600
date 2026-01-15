package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import horseRace.controller.HorseRaceManager;
   import horseRace.events.HorseRaceEvents;
   
   public class HorseRaceBuffView extends Sprite implements Disposeable
   {
      
      public var timeSyn:int = 0;
      
      private var _bg:Bitmap;
      
      private var _buffItemType1:int = 0;
      
      private var _buffItemType2:int = 0;
      
      private var buffItem1:HorseRaceBuffItem;
      
      private var buffItem2:HorseRaceBuffItem;
      
      private var pingzhangBnt:BaseButton;
      
      private var pingzhangTimer:Timer;
      
      private var pingzhangCount:int = 15;
      
      private var pingzhangDaojishi:MovieClip;
      
      public var pingzhangUseSuccess:Boolean = false;
      
      public function HorseRaceBuffView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("horseRace.raceView.buffViewBg");
         addChild(this._bg);
         this.buffItem1 = new HorseRaceBuffItem(this._buffItemType1,1);
         this.buffItem2 = new HorseRaceBuffItem(this._buffItemType2,2);
         PositionUtils.setPos(this.buffItem1,"horseRace.raceView.buffView.buffItemPos1");
         PositionUtils.setPos(this.buffItem2,"horseRace.raceView.buffView.buffItemPos2");
         this.pingzhangBnt = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.pingzhangBnt");
         this.pingzhangBnt.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.pingzhangTip");
         addChild(this.buffItem1);
         addChild(this.buffItem2);
         addChild(this.pingzhangBnt);
         this.pingzhangTimer = new Timer(1000);
         this.pingzhangTimer.addEventListener(TimerEvent.TIMER,this._showDaojishi);
         this.pingzhangDaojishi = ComponentFactory.Instance.creat("horseRace.raceView.pingzhangDaojishi");
         PositionUtils.setPos(this.pingzhangDaojishi,"horseRace.raceView.pingzhangDaojishiPos");
         addChild(this.pingzhangDaojishi);
         this.pingzhangDaojishi.visible = false;
      }
      
      private function _showDaojishi(e:TimerEvent) : void
      {
         this.pingzhangDaojishi.gotoAndStop(this.pingzhangCount);
         --this.pingzhangCount;
         if(this.pingzhangCount < 0)
         {
            this.pingzhangDaojishi.gotoAndStop(1);
            this.pingzhangDaojishi.visible = false;
            this.pingzhangDaojishi.gotoAndStop(15);
            this.pingzhangTimer.stop();
            this.pingzhangCount = 15;
            this.pingzhangTimer.reset();
            this.pingzhangBnt.enable = true;
            this.pingzhangUseSuccess = false;
         }
      }
      
      public function showPingzhangDaojishi() : void
      {
         this.pingzhangBnt.enable = false;
         this.pingzhangCount = 15;
         this.pingzhangDaojishi.visible = true;
         this.pingzhangDaojishi.gotoAndStop(15);
         this.pingzhangTimer.start();
         --this.pingzhangCount;
      }
      
      public function set buffItemType1($buffItemType1:int) : void
      {
         this._buffItemType1 = $buffItemType1;
         if(this._buffItemType1 != 0)
         {
            this.buffItem1.setShowBuffObj(this._buffItemType1);
         }
         else
         {
            this.buffItem1.showBuffObjByType(0);
         }
      }
      
      public function get buffItemType1() : int
      {
         return this._buffItemType1;
      }
      
      public function set buffItemType2($buffItemType2:int) : void
      {
         this._buffItemType2 = $buffItemType2;
         if(this._buffItemType2 != 0)
         {
            this.buffItem2.setShowBuffObj(this._buffItemType2);
         }
         else
         {
            this.buffItem2.showBuffObjByType(0);
         }
      }
      
      public function get buffItemType2() : int
      {
         return this._buffItemType2;
      }
      
      public function flushBuffItem() : void
      {
         if(this._buffItemType1 == 0 && this._buffItemType2 == 0)
         {
            this.buffItem1.setShowBuff(this._buffItemType1,this.timeSyn);
            this.buffItem2.setShowBuff(this._buffItemType2,-1);
         }
         else if(this._buffItemType1 == 0 && this._buffItemType2 != 0)
         {
            this.buffItem1.setShowBuff(this._buffItemType1,this.timeSyn);
            this.buffItem2.setShowBuffObj(this._buffItemType2);
         }
         else if(this._buffItemType1 != 0 && this._buffItemType2 == 0)
         {
            this.buffItem1.setShowBuffObj(this._buffItemType1);
            this.buffItem2.setShowBuff(this._buffItemType2,this.timeSyn);
         }
         else if(this._buffItemType1 != 0 && this._buffItemType2 != 0)
         {
            this.buffItem1.setShowBuffObj(this._buffItemType1);
            this.buffItem2.setShowBuffObj(this._buffItemType2);
         }
      }
      
      private function initEvent() : void
      {
         this.pingzhangBnt.addEventListener(MouseEvent.CLICK,this._pingzhangUse);
      }
      
      private function _pingzhangUse(e:MouseEvent) : void
      {
         HorseRaceManager.Instance.dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_USE_PINGZHANG));
      }
      
      private function removeEvent() : void
      {
         this.pingzhangBnt.removeEventListener(MouseEvent.CLICK,this._pingzhangUse);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

