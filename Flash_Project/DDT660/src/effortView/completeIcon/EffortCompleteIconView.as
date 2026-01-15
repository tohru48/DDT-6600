package effortView.completeIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EffortCompleteIconView extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const MAX:int = 1;
      
      public static const MIN:int = 2;
      
      private var _iconBg:ScaleFrameImage;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:EffortInfo;
      
      private var _glowFilter:Array;
      
      public function EffortCompleteIconView()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(0,0,this.width,this.height);
         this.graphics.endFill();
         this._iconBg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconView.EffortCompleteIconBg");
         this._iconBg.setFrame(MAX);
         addChild(this._iconBg);
         this._tipStyle = "effortView.effortCompleteIconTipsView";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         ShowTipManager.Instance.addTip(this);
         this._tipData = new EffortInfo();
         this._glowFilter = ComponentFactory.Instance.creatFrameFilters("GF_15");
         addEventListener(MouseEvent.MOUSE_OVER,this.__thisOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__thisOut);
      }
      
      private function __thisOut(event:MouseEvent) : void
      {
         this.filters = null;
      }
      
      private function __thisOver(event:MouseEvent) : void
      {
         this.filters = this._glowFilter[0];
      }
      
      public function setInfo(info:EffortInfo) : void
      {
         this._tipData = info;
         this.update();
      }
      
      private function update() : void
      {
         var i:int = 0;
         if(Boolean(this._tipData.effortRewardArray))
         {
            for(i = 0; i < this._tipData.effortRewardArray.length; i++)
            {
               if((this._tipData.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
               {
                  this._iconBg.setFrame(MAX);
               }
            }
         }
         else
         {
            this._iconBg.setFrame(MIN);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__thisOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__thisOut);
         if(Boolean(this._iconBg))
         {
            this._iconBg.dispose();
            this._iconBg = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value as EffortInfo;
         this.update();
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

