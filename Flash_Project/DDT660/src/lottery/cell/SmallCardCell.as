package lottery.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class SmallCardCell extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const BIG:String = "";
      
      public static const SMALL:String = "";
      
      private var _cardId:int;
      
      private var _selected:Boolean;
      
      protected var _selectedBg:ScaleBitmapImage;
      
      protected var _pic:ScaleFrameImage;
      
      protected var _tipData:Object;
      
      protected var _tipDirection:String;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _tipStyle:String;
      
      private var _enable:Boolean = true;
      
      public function SmallCardCell()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function set cardId(value:int) : void
      {
         if(this._cardId == value)
         {
            return;
         }
         this._cardId = value;
         this._pic.setFrame(this._cardId);
         this.tipData = LanguageMgr.GetTranslation("tank.lottery.cradName" + String(this._cardId));
      }
      
      public function get cardId() : int
      {
         return this._cardId;
      }
      
      public function get hasCard() : Boolean
      {
         return this._cardId > 0;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this._selectedBg.visible = this._selected;
      }
      
      public function set enable(value:Boolean) : void
      {
         if(this._enable == value)
         {
            return;
         }
         this._enable = value;
         if(this._enable && Boolean(this._pic))
         {
            this._pic.filters = null;
         }
         else
         {
            this._pic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      protected function initView() : void
      {
         this._pic = ComponentFactory.Instance.creatComponentByStylename("lottery.cardCell.cardPic");
         addChild(this._pic);
         this._pic.setFrame(1);
         this._selectedBg = ComponentFactory.Instance.creatComponentByStylename("lottery.cardCell.selctedBg");
         addChild(this._selectedBg);
         this._selectedBg.visible = false;
         this.updateSize();
         ShowTipManager.Instance.addTip(this);
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "5";
         this.tipGapH = -2;
         this.tipGapV = -2;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      private function __onMouseOver(evt:MouseEvent) : void
      {
         if(this._cardId > 0 && this._enable && Boolean(this._pic))
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      private function __onMouseOut(evt:MouseEvent) : void
      {
         if(this._cardId > 0 && this._enable && Boolean(this._pic))
         {
            filters = null;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      protected function updateSize() : void
      {
         var size:Rectangle = null;
         size = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.picSmallSize");
         this._pic.width = size.width;
         this._pic.height = size.height;
         size = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.selectedSmallSize");
         this._selectedBg.width = size.width;
         this._selectedBg.height = size.height;
         this._selectedBg.x = size.x;
         this._selectedBg.y = size.y;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirection = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this._pic;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}

