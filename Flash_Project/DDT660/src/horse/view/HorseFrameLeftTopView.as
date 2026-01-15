package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import horse.HorseManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HorseFrameLeftTopView extends Sprite implements Disposeable
   {
      
      private var _leftArrowBtn:SimpleBitmapButton;
      
      private var _rightArrowBtn:SimpleBitmapButton;
      
      private var _useBtn:SimpleBitmapButton;
      
      private var _takeBackBtn:SimpleBitmapButton;
      
      private var _preLevelUpBtn:SimpleBitmapButton;
      
      private var _nameTxt:FilterFrameText;
      
      private var _horseMc:MovieClip;
      
      private var _horseNameStrList:Array;
      
      private var _curIndex:int;
      
      private var _maxIndex:int;
      
      public function HorseFrameLeftTopView()
      {
         super();
         this._horseNameStrList = LanguageMgr.GetTranslation("horse.horseNameStr").split(",");
         this.initView();
         this.initEvent();
         this.upHorseHandler(null);
         this.guideHandler(null);
      }
      
      private function initView() : void
      {
         this._leftArrowBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.leftArrowBtn");
         this._rightArrowBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.rightArrowBtn");
         this._useBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.useBtn");
         this._takeBackBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.takeBackBtn");
         this._preLevelUpBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.preLevelUp");
         this._preLevelUpBtn.buttonMode = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.horseNameTxt");
         this._horseMc = ComponentFactory.Instance.creat("asset.horse.frame.horseMc");
         PositionUtils.setPos(this._horseMc,"horse.frame.horseMcPos");
         this._horseMc.mouseChildren = false;
         this._horseMc.mouseEnabled = false;
         this._horseMc.gotoAndStop(this._horseMc.totalFrames);
         addChild(this._leftArrowBtn);
         addChild(this._rightArrowBtn);
         addChild(this._useBtn);
         addChild(this._takeBackBtn);
         addChild(this._preLevelUpBtn);
         addChild(this._nameTxt);
         addChild(this._horseMc);
      }
      
      private function initEvent() : void
      {
         this._leftArrowBtn.addEventListener(MouseEvent.CLICK,this.leftArrowClickHandler,false,0,true);
         this._rightArrowBtn.addEventListener(MouseEvent.CLICK,this.rightArrowClickHandler,false,0,true);
         this._useBtn.addEventListener(MouseEvent.CLICK,this.useClickHandler,false,0,true);
         this._takeBackBtn.addEventListener(MouseEvent.CLICK,this.takeBackClickHandler,false,0,true);
         this._preLevelUpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.preLevelUpOverHandler,false,0,true);
         this._preLevelUpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.preLevelUpOutHandler,false,0,true);
         HorseManager.instance.addEventListener(HorseManager.CHANGE_HORSE,this.changeHorseHandler);
         HorseManager.instance.addEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
         HorseManager.instance.addEventListener(HorseManager.GUIDE_6_TO_7,this.guideHandler);
      }
      
      private function guideHandler(event:Event) : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_7) && PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_5))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE2,0,new Point(226,203),"","",this);
         }
      }
      
      private function upHorseHandler(event:Event) : void
      {
         this._maxIndex = int(HorseManager.instance.curLevel / 10) + 1;
         this._curIndex = this._maxIndex;
         if(this._maxIndex == 9)
         {
            this._preLevelUpBtn.enable = false;
         }
         this.refreshHorseShowView(this._curIndex);
         this.refreshHorseUseView();
         this.refreshArrowView();
      }
      
      private function changeHorseHandler(event:Event) : void
      {
         this.refreshHorseUseView();
      }
      
      private function refreshHorseShowView(index:int) : void
      {
		  if(this._horseNameStrList && index - 1 >= 0 && index - 1 < this._horseNameStrList.length)
		  {
			  var name:String = this._horseNameStrList[index - 1];
			  this._nameTxt.text = (name != null) ? name : "";
		  }
		  else
		  {
			  //trace("[HorseView] Invalid index or list is null:", index);
			  this._nameTxt.text = ""; // güvenli fallback
		  }
         this._horseMc.gotoAndStop(index);
      }
      
      private function refreshHorseUseView() : void
      {
         if(HorseManager.instance.curUseHorse == this._curIndex)
         {
            this._useBtn.visible = false;
            this._takeBackBtn.visible = true;
         }
         else
         {
            this._useBtn.visible = true;
            this._takeBackBtn.visible = false;
         }
      }
      
      private function refreshArrowView() : void
      {
         if(this._curIndex == this._maxIndex)
         {
            this._rightArrowBtn.visible = false;
         }
         else
         {
            this._rightArrowBtn.visible = true;
         }
         if(this._curIndex == 1)
         {
            this._leftArrowBtn.visible = false;
         }
         else
         {
            this._leftArrowBtn.visible = true;
         }
      }
      
      private function leftArrowClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._curIndex;
         this._curIndex = this._curIndex < 1 ? 1 : this._curIndex;
         this.refreshHorseShowView(this._curIndex);
         this.refreshHorseUseView();
         this.refreshArrowView();
      }
      
      private function rightArrowClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._curIndex;
         this._curIndex = this._curIndex > this._maxIndex ? this._maxIndex : this._curIndex;
         this.refreshHorseShowView(this._curIndex);
         this.refreshHorseUseView();
         this.refreshArrowView();
      }
      
      private function useClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHorseChangeHorse(this._curIndex);
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_7))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_7);
            if(NewHandContainer.Instance.hasArrow(ArrowType.HORSE_GUIDE2))
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.HORSE_GUIDE2);
            }
         }
      }
      
      private function takeBackClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHorseChangeHorse(0);
      }
      
      private function preLevelUpOverHandler(event:MouseEvent) : void
      {
         var tmp:int = this._maxIndex + 1;
         tmp = tmp > 9 ? 9 : tmp;
         this.refreshHorseShowView(tmp);
         this._useBtn.visible = false;
         this._takeBackBtn.visible = false;
         HorseManager.instance.dispatchEvent(new Event(HorseManager.PRE_NEXT_EFFECT));
      }
      
      private function preLevelUpOutHandler(event:MouseEvent) : void
      {
         this.refreshHorseShowView(this._curIndex);
         this.refreshHorseUseView();
         HorseManager.instance.dispatchEvent(new Event(HorseManager.REFRESH_CUR_EFFECT));
      }
      
      private function removeEvent() : void
      {
         this._leftArrowBtn.removeEventListener(MouseEvent.CLICK,this.leftArrowClickHandler);
         this._rightArrowBtn.removeEventListener(MouseEvent.CLICK,this.rightArrowClickHandler);
         this._useBtn.removeEventListener(MouseEvent.CLICK,this.useClickHandler);
         this._takeBackBtn.removeEventListener(MouseEvent.CLICK,this.takeBackClickHandler);
         this._preLevelUpBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.preLevelUpOverHandler);
         this._preLevelUpBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.preLevelUpOutHandler);
         HorseManager.instance.removeEventListener(HorseManager.CHANGE_HORSE,this.changeHorseHandler);
         HorseManager.instance.removeEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
         HorseManager.instance.removeEventListener(HorseManager.GUIDE_6_TO_7,this.guideHandler);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._horseMc))
         {
            this._horseMc.gotoAndStop(this._horseMc.totalFrames);
         }
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftArrowBtn = null;
         this._rightArrowBtn = null;
         this._useBtn = null;
         this._takeBackBtn = null;
         this._preLevelUpBtn = null;
         this._nameTxt = null;
         this._horseMc = null;
         this._horseNameStrList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

