package game.view.playerThumbnail
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.LivingEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import game.model.Living;
   import game.model.SimpleBoss;
   
   public class NPCThumbnail extends Sprite implements Disposeable
   {
      
      private var _living:Living;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BloodItem;
      
      private var _name:TextField;
      
      private var _tipContainer:Sprite;
      
      private var lightingFilter:BitmapFilter;
      
      public function NPCThumbnail(living:Living)
      {
         super();
         this._living = living;
         this.init();
         this.initEvents();
      }
      
      public function init() : void
      {
         this._headFigure = new HeadFigure(28,28,this._living);
         this._blood = new BloodItem(this._living.blood,this._living.maxBlood);
         this._name = new TextField();
         this.initHead();
         this.initBlood();
         this.initName();
      }
      
      public function initHead() : void
      {
         this._headFigure.x = 7;
         this._headFigure.y = 8;
         addChild(this._headFigure);
      }
      
      public function initBlood() : void
      {
         this._blood.x = 38;
         this._blood.y = 26;
         addChild(this._blood);
      }
      
      public function initName() : void
      {
         var tempIndex:int = 0;
         this._name.autoSize = "left";
         this._name.wordWrap = false;
         this._name.text = this._living.name;
         if(this._name.width > 65)
         {
            tempIndex = this._name.getCharIndexAtPoint(50,5);
            this._name.text = this._name.text.substring(0,tempIndex) + "...";
         }
         this._name.mouseEnabled = false;
         addChild(this._name);
      }
      
      public function initEvents() : void
      {
         if(Boolean(this._living))
         {
            this._living.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.addEventListener(LivingEvent.DIE,this.__die);
            this._living.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
            addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
      }
      
      public function __updateBlood(evt:LivingEvent) : void
      {
         this._blood.bloodNum = this._living.blood;
      }
      
      public function __die(evt:LivingEvent) : void
      {
         if(Boolean(this._headFigure))
         {
            this._headFigure.gray();
         }
         if(Boolean(this._blood))
         {
            this._blood.visible = false;
         }
      }
      
      private function __shineChange(evt:LivingEvent) : void
      {
         var boss:SimpleBoss = this._living as SimpleBoss;
      }
      
      protected function overHandler(evt:MouseEvent) : void
      {
         if(Boolean(this.lightingFilter))
         {
            this.filters = [this.lightingFilter];
         }
      }
      
      protected function outHandler(evt:MouseEvent) : void
      {
         this.filters = null;
      }
      
      public function setUpLintingFilter() : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([1,0,0,0,25]);
         matrix = matrix.concat([0,1,0,0,25]);
         matrix = matrix.concat([0,0,1,0,25]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(matrix);
      }
      
      public function removeEvents() : void
      {
         if(Boolean(this._living))
         {
            this._living.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.removeEventListener(LivingEvent.DIE,this.__die);
            this._living.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
            removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
      }
      
      public function updateView() : void
      {
         if(!this._living)
         {
            this.visible = false;
         }
         else
         {
            if(Boolean(this._headFigure))
            {
               this._headFigure.dispose();
               this._headFigure = null;
            }
            if(Boolean(this._blood))
            {
               this._blood = null;
            }
            this.init();
         }
      }
      
      public function set info(value:Living) : void
      {
         if(!value)
         {
            this.removeEvents();
         }
         this._living = value;
         this.updateView();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._tipContainer))
         {
            if(Boolean(this._tipContainer.parent))
            {
               removeChild(this._tipContainer);
            }
            this._tipContainer = null;
         }
         this.removeEvents();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._headFigure.dispose();
         this._headFigure = null;
         this._blood.dispose();
         this._blood = null;
         this._living = null;
      }
   }
}

