package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import horseRace.controller.HorseRaceManager;
   import horseRace.events.HorseRaceEvents;
   
   public class HorseRaceBuffItem extends Sprite implements Disposeable
   {
      
      private var _buffIndex:int;
      
      private var _buffType:int;
      
      private var _bg:Bitmap;
      
      private var _daojishi:MovieClip;
      
      private var _buffObj1:BaseButton;
      
      private var _buffObj2:BaseButton;
      
      private var _buffObj3:BaseButton;
      
      private var _buffObj4:BaseButton;
      
      private var _buffObj5:BaseButton;
      
      private var _buffObj6:BaseButton;
      
      private var _buffObj7:BaseButton;
      
      private var _buffObj8:BaseButton;
      
      private var buffConfig:Array;
      
      public function HorseRaceBuffItem($buffType:int, $buffIndex:int)
      {
         super();
         this._buffIndex = $buffIndex;
         this._buffType = $buffType;
         this.buffConfig = ServerConfigManager.instance.horseGameBuffConfig;
         this.initView();
         this.initEvent();
      }
      
      private function getConfigByID(id:int) : int
      {
         var lastTime:int = 0;
         var buffStr:String = this.buffConfig[id - 1];
         var arr:Array = buffStr.split(",");
         var buffId:int = int(arr[0]);
         if(buffId == id)
         {
            lastTime = int(arr[1]);
         }
         return lastTime;
      }
      
      private function initView() : void
      {
         if(this._buffIndex == 1)
         {
            this._bg = ComponentFactory.Instance.creat("horseRace.raceView.buffViewItem1");
         }
         else if(this._buffIndex == 2)
         {
            this._bg = ComponentFactory.Instance.creat("horseRace.raceView.buffViewItem2");
         }
         this._daojishi = ComponentFactory.Instance.creat("horseRace.raceView.buffView.itemMc");
         this._daojishi.visible = false;
         PositionUtils.setPos(this._daojishi,"horseRace.raceView.buffView.itemMcPos");
         this._buffObj1 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj1");
         this._buffObj1.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe1",this.getConfigByID(1));
         PositionUtils.setPos(this._buffObj1,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj1.width = 42;
         this._buffObj1.height = 42;
         this._buffObj1.visible = false;
         this._buffObj1.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj1);
         this._buffObj2 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj2");
         this._buffObj2.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe2",this.getConfigByID(2));
         PositionUtils.setPos(this._buffObj2,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj2.width = 42;
         this._buffObj2.height = 42;
         this._buffObj2.visible = false;
         this._buffObj2.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj2);
         this._buffObj3 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj3");
         this._buffObj3.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe3",this.getConfigByID(3));
         PositionUtils.setPos(this._buffObj3,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj3.width = 42;
         this._buffObj3.height = 42;
         this._buffObj3.visible = false;
         this._buffObj3.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj3);
         this._buffObj4 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj4");
         this._buffObj4.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe4",this.getConfigByID(4));
         PositionUtils.setPos(this._buffObj4,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj4.width = 42;
         this._buffObj4.height = 42;
         this._buffObj4.visible = false;
         this._buffObj4.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj4);
         this._buffObj5 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj5");
         this._buffObj5.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe5",this.getConfigByID(5));
         PositionUtils.setPos(this._buffObj5,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj5.width = 42;
         this._buffObj5.height = 42;
         this._buffObj5.visible = false;
         this._buffObj5.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj5);
         this._buffObj6 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj6");
         this._buffObj6.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe6",this.getConfigByID(6));
         PositionUtils.setPos(this._buffObj6,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj6.width = 42;
         this._buffObj6.height = 42;
         this._buffObj6.visible = false;
         this._buffObj6.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj6);
         this._buffObj7 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj7");
         this._buffObj7.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe7",this.getConfigByID(7));
         PositionUtils.setPos(this._buffObj7,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj7.width = 42;
         this._buffObj7.height = 42;
         this._buffObj7.visible = false;
         this._buffObj7.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj7);
         this._buffObj8 = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffView.buffObj8");
         this._buffObj8.tipData = LanguageMgr.GetTranslation("horseRace.raceView.buffView.buffObjDiscripe8",this.getConfigByID(8));
         PositionUtils.setPos(this._buffObj8,"horseRace.raceView.buffView.buffObjPos");
         this._buffObj8.width = 42;
         this._buffObj8.height = 42;
         this._buffObj8.visible = false;
         this._buffObj8.addEventListener(MouseEvent.CLICK,this._buffObjClick);
         addChild(this._buffObj8);
         addChild(this._bg);
         addChild(this._daojishi);
         addChild(this._buffObj1);
         addChild(this._buffObj2);
         addChild(this._buffObj3);
         addChild(this._buffObj4);
         addChild(this._buffObj5);
         addChild(this._buffObj6);
         addChild(this._buffObj7);
         addChild(this._buffObj8);
      }
      
      public function setShowBuff($buffType:int, minute:int) : void
      {
         this._buffType = $buffType;
         if($buffType == 0)
         {
            this._daojishi.visible = true;
            this._daojishi.gotoAndStop(minute);
            if(Boolean(this._buffObj1))
            {
               this._buffObj1.visible = false;
            }
            if(Boolean(this._buffObj2))
            {
               this._buffObj2.visible = false;
            }
            if(Boolean(this._buffObj3))
            {
               this._buffObj3.visible = false;
            }
            if(Boolean(this._buffObj4))
            {
               this._buffObj5.visible = false;
            }
            if(Boolean(this._buffObj5))
            {
               this._buffObj5.visible = false;
            }
            if(Boolean(this._buffObj6))
            {
               this._buffObj6.visible = false;
            }
            if(Boolean(this._buffObj7))
            {
               this._buffObj7.visible = false;
            }
            if(Boolean(this._buffObj8))
            {
               this._buffObj8.visible = false;
            }
         }
         if(minute == -1)
         {
            this._daojishi.visible = false;
            if(Boolean(this._buffObj1))
            {
               this._buffObj1.visible = false;
            }
            if(Boolean(this._buffObj2))
            {
               this._buffObj2.visible = false;
            }
            if(Boolean(this._buffObj3))
            {
               this._buffObj3.visible = false;
            }
            if(Boolean(this._buffObj4))
            {
               this._buffObj5.visible = false;
            }
            if(Boolean(this._buffObj5))
            {
               this._buffObj5.visible = false;
            }
            if(Boolean(this._buffObj6))
            {
               this._buffObj6.visible = false;
            }
            if(Boolean(this._buffObj7))
            {
               this._buffObj7.visible = false;
            }
            if(Boolean(this._buffObj8))
            {
               this._buffObj8.visible = false;
            }
         }
      }
      
      public function setShowBuffObj($buffType:int) : void
      {
         if($buffType != 0)
         {
            this._daojishi.visible = false;
            this.showBuffObjByType($buffType);
         }
      }
      
      public function showBuffObjByType(type:int) : void
      {
         if(type == 1)
         {
            this._buffObj1.visible = true;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 2)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = true;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 3)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = true;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 4)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = true;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 5)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = true;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 6)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = true;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
         else if(type == 7)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = true;
            this._buffObj8.visible = false;
         }
         else if(type == 8)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = true;
         }
         else if(type == 0)
         {
            this._buffObj1.visible = false;
            this._buffObj2.visible = false;
            this._buffObj3.visible = false;
            this._buffObj4.visible = false;
            this._buffObj5.visible = false;
            this._buffObj6.visible = false;
            this._buffObj7.visible = false;
            this._buffObj8.visible = false;
         }
      }
      
      private function _buffObjClick(e:MouseEvent) : void
      {
         HorseRaceManager.Instance.dispatchEvent(new HorseRaceEvents(HorseRaceEvents.HORSERACE_USE_DAOJU,this._buffIndex));
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
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

