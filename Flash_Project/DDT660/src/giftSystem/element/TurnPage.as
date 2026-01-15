package giftSystem.element
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TurnPage extends Sprite implements Disposeable
   {
      
      public static const CURRENTPAGE_CHANGE:String = "currentPageChange";
      
      private var _numShow:FilterFrameText;
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _firstBtn:BaseButton;
      
      private var _endBtn:BaseButton;
      
      private var _numBG:Scale9CornerImage;
      
      private var _current:int;
      
      private var _total:int;
      
      public function TurnPage()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set current(value:int) : void
      {
         if(this._current == value)
         {
            return;
         }
         this._current = value;
         this._numShow.text = this._current + "/" + this._total;
         dispatchEvent(new Event(CURRENTPAGE_CHANGE));
      }
      
      public function get current() : int
      {
         return this._current;
      }
      
      public function set total(value:int) : void
      {
         if(this._total == value)
         {
            return;
         }
         this._total = value;
         this._numShow.text = this._current + "/" + this._total;
      }
      
      public function get total() : int
      {
         return this._total;
      }
      
      private function initView() : void
      {
         this._numShow = ComponentFactory.Instance.creatComponentByStylename("TurnPage.numShow");
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("ddtgiftleftbutton");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("ddtrightbutton");
         this._firstBtn = ComponentFactory.Instance.creatComponentByStylename("ddtfirstbutton");
         this._endBtn = ComponentFactory.Instance.creatComponentByStylename("ddtendbutton");
         this._numBG = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystemTextViewII");
         addChild(this._numBG);
         addChild(this._numShow);
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._firstBtn);
         addChild(this._endBtn);
      }
      
      private function drawSprit() : Sprite
      {
         var sp:Sprite = null;
         sp = new Sprite();
         sp.graphics.beginFill(0,0);
         sp.graphics.drawRect(0,0,25,25);
         sp.graphics.endFill();
         sp.buttonMode = true;
         return sp;
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightClick);
         this._firstBtn.addEventListener(MouseEvent.CLICK,this.__firtClick);
         this._endBtn.addEventListener(MouseEvent.CLICK,this.__endClick);
      }
      
      private function __rightClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._current >= this._total)
         {
            this.current = 1;
         }
         else
         {
            ++this.current;
         }
      }
      
      private function __endClick(evnet:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.current = this._total;
      }
      
      private function __leftClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._current <= 1)
         {
            this.current = this.total;
         }
         else
         {
            --this.current;
         }
      }
      
      private function __firtClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.current = 1;
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightClick);
         this._firstBtn.removeEventListener(MouseEvent.CLICK,this.__firtClick);
         this._endBtn.removeEventListener(MouseEvent.CLICK,this.__endClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._numBG))
         {
            ObjectUtils.disposeObject(this._numBG);
         }
         this._numBG = null;
         if(Boolean(this._numShow))
         {
            ObjectUtils.disposeObject(this._numShow);
         }
         this._numShow = null;
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
         }
         this._leftBtn = null;
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
         }
         this._rightBtn = null;
         if(Boolean(this._firstBtn))
         {
            ObjectUtils.disposeObject(this._firstBtn);
         }
         this._firstBtn = null;
         if(Boolean(this._endBtn))
         {
            ObjectUtils.disposeObject(this._endBtn);
         }
         this._endBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

