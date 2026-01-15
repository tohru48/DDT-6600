package mysteriousRoullete.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mysteriousRoullete.MysteriousManager;
   import mysteriousRoullete.components.RouletteRun;
   import mysteriousRoullete.event.MysteriousEvent;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class MysteriousRouletteView extends Sprite implements Disposeable
   {
      
      private var _rouletteTitle:Bitmap;
      
      private var _description:Bitmap;
      
      private var _timeBG:Bitmap;
      
      private var _roullete:Bitmap;
      
      private var _gear:Bitmap;
      
      private var _startBtn:BaseButton;
      
      private var _shopBtn:BaseButton;
      
      private var _dateTxt:FilterFrameText;
      
      private var _rouletteRun:RouletteRun;
      
      private var _lightUnstart:MovieClip;
      
      private var _lightStart:MovieClip;
      
      private var _endBtnLight:MovieClip;
      
      private var _startBtnLight:MovieClip;
      
      private var selectedIndex:int;
      
      public function MysteriousRouletteView()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      public function initView() : void
      {
         this._rouletteTitle = ComponentFactory.Instance.creat("mysteriousRoulette.rouletteTitle");
         addChild(this._rouletteTitle);
         this._description = ComponentFactory.Instance.creat("mysteriousRoulette.desctiption");
         addChild(this._description);
         this._roullete = ComponentFactory.Instance.creat("mysteriousRoulette.roullete");
         addChild(this._roullete);
         this._timeBG = ComponentFactory.Instance.creat("mysteriousRoulette.timeBG");
         addChild(this._timeBG);
         this._dateTxt = ComponentFactory.Instance.creat("mysteriousRoulette.dateTxt");
         this._dateTxt.text = "2013-09-26";
         addChild(this._dateTxt);
         this._rouletteRun = new RouletteRun();
         addChild(this._rouletteRun);
         this._gear = ComponentFactory.Instance.creat("mysteriousRoulette.gear");
         addChild(this._gear);
         this._startBtn = ComponentFactory.Instance.creat("mysteriousRoulette.startBtn");
         addChild(this._startBtn);
         this._shopBtn = ComponentFactory.Instance.creat("mysteriousRoulette.shopBtn");
         addChild(this._shopBtn);
         this._shopBtn.visible = false;
         this._lightUnstart = ComponentFactory.Instance.creat("mysteriousRoulette.mc.6LightUnstart");
         PositionUtils.setPos(this._lightUnstart,"mysteriousRoulette.mc.6LightUnstartPos");
         addChild(this._lightUnstart);
         this._lightStart = ComponentFactory.Instance.creat("mysteriousRoulette.mc.6Lightstart");
         PositionUtils.setPos(this._lightStart,"mysteriousRoulette.mc.6LightstartPos");
         addChild(this._lightStart);
         this._lightStart.visible = false;
         this._endBtnLight = ComponentFactory.Instance.creat("mysteriousRoulette.mc.endBtnLight");
         PositionUtils.setPos(this._endBtnLight,"mysteriousRoulette.mc.endBtnLightPos");
         addChild(this._endBtnLight);
         this._endBtnLight.visible = false;
         this._startBtnLight = ComponentFactory.Instance.creat("mysteriousRoulette.mc.startBtnLight");
         PositionUtils.setPos(this._startBtnLight,"mysteriousRoulette.mc.startBtnLightPos");
         addChild(this._startBtnLight);
         this._startBtnLight.visible = false;
         var index:int = MysteriousManager.instance.selectIndex;
         if(index > 0)
         {
            this._rouletteRun.select(index);
            this._startBtn.mouseEnabled = false;
         }
      }
      
      private function initEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartBtnDown);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this.onShopBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAWN_LOTTERY,this.__dawnLottery);
      }
      
      private function initData() : void
      {
         var startDate:Date = MysteriousManager.instance.startTime;
         var endDate:Date = MysteriousManager.instance.endTime;
         this._dateTxt.text = startDate.getFullYear() + "." + (startDate.getMonth() + 1) + "." + startDate.getDate() + "-" + endDate.getFullYear() + "." + (endDate.getMonth() + 1) + "." + endDate.getDate();
      }
      
      private function onStartBtnDown(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._startBtn.mouseEnabled = false;
         this._startBtnLight.visible = true;
         this._startBtnLight.gotoAndStop(1);
         this._startBtnLight.play();
         this._startBtnLight.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         MysteriousManager.instance.addMask();
         WonderfulActivityManager.Instance.frameCanClose = false;
         SocketManager.Instance.out.sendRouletteRun();
      }
      
      protected function onRouletteRunComplete(event:Event) : void
      {
         this._rouletteRun.removeEventListener(Event.COMPLETE,this.onRouletteRunComplete);
         this._endBtnLight.visible = true;
         this._endBtnLight.gotoAndStop(1);
         this._endBtnLight.play();
         this._endBtnLight.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._lightStart.visible = false;
         this._lightUnstart.visible = true;
         SoundManager.instance.playMusic("140");
         SoundManager.instance.play("126");
         MysteriousManager.instance.removeMask();
         WonderfulActivityManager.Instance.frameCanClose = true;
         if(this.selectedIndex != 4)
         {
            this._startBtn.visible = false;
            this._shopBtn.visible = true;
         }
         MysteriousManager.instance.selectIndex = this.selectedIndex;
      }
      
      private function onShopBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new MysteriousEvent(MysteriousEvent.CHANG_VIEW,MysteriousActivityView.TYPE_SHOP));
      }
      
      private function __dawnLottery(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.selectedIndex = pkg.readInt();
         this._lightUnstart.visible = false;
         this._lightStart.visible = true;
         this._rouletteRun.run(this.selectedIndex);
         this._rouletteRun.addEventListener(Event.COMPLETE,this.onRouletteRunComplete);
      }
      
      protected function onEnterFrame(event:Event) : void
      {
         if((event.target as MovieClip).currentFrame == (event.target as MovieClip).totalFrames)
         {
            (event.target as MovieClip).stop();
            (event.target as MovieClip).visible = false;
            (event.target as MovieClip).gotoAndStop(1);
            (event.target as MovieClip).removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function removeEvent() : void
      {
         this._startBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStartBtnDown);
         this._shopBtn.removeEventListener(MouseEvent.CLICK,this.onShopBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAWN_LOTTERY,this.__dawnLottery);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._rouletteTitle))
         {
            ObjectUtils.disposeObject(this._rouletteTitle);
         }
         this._rouletteTitle = null;
         if(Boolean(this._description))
         {
            ObjectUtils.disposeObject(this._description);
         }
         this._description = null;
         if(Boolean(this._timeBG))
         {
            ObjectUtils.disposeObject(this._timeBG);
         }
         this._timeBG = null;
         if(Boolean(this._dateTxt))
         {
            ObjectUtils.disposeObject(this._dateTxt);
         }
         this._dateTxt = null;
         if(Boolean(this._roullete))
         {
            ObjectUtils.disposeObject(this._roullete);
         }
         this._roullete = null;
         if(Boolean(this._gear))
         {
            ObjectUtils.disposeObject(this._gear);
         }
         this._gear = null;
         if(Boolean(this._startBtn))
         {
            ObjectUtils.disposeObject(this._startBtn);
         }
         this._startBtn = null;
         if(Boolean(this._shopBtn))
         {
            ObjectUtils.disposeObject(this._shopBtn);
         }
         this._shopBtn = null;
         if(Boolean(this._lightStart))
         {
            ObjectUtils.disposeObject(this._lightStart);
         }
         this._lightStart = null;
         if(Boolean(this._lightUnstart))
         {
            ObjectUtils.disposeObject(this._lightUnstart);
         }
         this._lightUnstart = null;
         if(Boolean(this._startBtnLight))
         {
            ObjectUtils.disposeObject(this._startBtnLight);
         }
         this._startBtnLight = null;
         if(Boolean(this._endBtnLight))
         {
            ObjectUtils.disposeObject(this._endBtnLight);
         }
         this._endBtnLight = null;
         if(Boolean(this._rouletteRun))
         {
            ObjectUtils.disposeObject(this._rouletteRun);
         }
         this._rouletteRun = null;
      }
   }
}

