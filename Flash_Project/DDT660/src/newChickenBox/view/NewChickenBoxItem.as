package newChickenBox.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   
   public class NewChickenBoxItem extends Sprite
   {
      
      private var _bg:MovieClip;
      
      private var _cell:NewChickenBoxCell;
      
      private var _position:int;
      
      public var info:NewChickenBoxGoodsTempInfo;
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      protected var _currentFrameIndex:int = 1;
      
      protected var _tbxCount:FilterFrameText;
      
      public function NewChickenBoxItem(cell:NewChickenBoxCell, bg:MovieClip)
      {
         super();
         this._cell = cell;
         this._bg = bg;
         this._bg.addEventListener("showItem",this.showItem);
         this._bg.addEventListener("hideItem",this.hideItem);
         this._bg.addEventListener("alphaItem",this.alphaItem);
         addChild(this._bg);
         addChild(this._cell);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.CountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this.updateCount();
         this.buttonMode = true;
         this.filterString = "null,lightFilter,null,grayFilter";
         this.addEvent();
      }
      
      public function countTextShowIf() : void
      {
         if(this.info.IsSelected)
         {
            this._tbxCount.visible = true;
         }
         else if(this.info.IsSeeded)
         {
            this._tbxCount.visible = true;
            this._tbxCount.alpha = 0.5;
         }
         else
         {
            this._tbxCount.visible = false;
         }
      }
      
      public function updateCount() : void
      {
         if(Boolean(this._tbxCount))
         {
            if(Boolean(this.info) && this.info.Count > 1)
            {
               this._tbxCount.text = String(this.info.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      public function setBg(state:int) : void
      {
         if(state == 0)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            this.cell.visible = true;
         }
         else if(state == 1)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            this.cell.visible = true;
         }
         else if(state == 2)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
            this.cell.visible = true;
         }
         else if(state == 3)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
            this.cell.visible = false;
         }
         this.setChildIndex(this.cell,0);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.removeEventListener("showItem",this.showItem);
            this._bg.removeEventListener("hideItem",this.hideItem);
            this._bg.removeEventListener("alphaItem",this.alphaItem);
            this._bg = null;
         }
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._tbxCount))
         {
            ObjectUtils.disposeObject(this._tbxCount);
         }
         this._tbxCount = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set filterString(value:String) : void
      {
         if(this._filterString == value)
         {
            return;
         }
         this._filterString = value;
         this._frameFilter = ComponentFactory.Instance.creatFrameFilters(this._filterString);
      }
      
      public function get frameFilter() : Array
      {
         return this._frameFilter;
      }
      
      public function set frameFilter(value:Array) : void
      {
         this._frameFilter = value;
      }
      
      private function alphaItem(e:Event) : void
      {
         this._cell.visible = true;
         this._cell.alpha = 0.5;
         this.updateCount();
         if(Boolean(this._tbxCount))
         {
            this._tbxCount.alpha = 0.5;
         }
      }
      
      private function showItem(e:Event) : void
      {
         this._cell.visible = true;
         this.updateCount();
      }
      
      private function hideItem(e:Event) : void
      {
         this._cell.visible = false;
         if(Boolean(this._tbxCount))
         {
            this._tbxCount.visible = false;
         }
      }
      
      public function get cell() : NewChickenBoxCell
      {
         return this._cell;
      }
      
      public function set cell(value:NewChickenBoxCell) : void
      {
         if(this._cell != null && this._cell.parent != null)
         {
            this._cell.parent.removeChild(this._cell);
         }
         this._cell = value;
         this.addChild(this._cell);
      }
      
      public function get bg() : MovieClip
      {
         return this._bg;
      }
      
      public function set bg(value:MovieClip) : void
      {
         if(this._bg != null && this._bg.parent != null)
         {
            this._bg.removeEventListener("showItem",this.showItem);
            this._bg.removeEventListener("hideItem",this.hideItem);
            this._bg.removeEventListener("alphaItem",this.alphaItem);
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         this._bg = value;
         this._bg.addEventListener("showItem",this.showItem);
         this._bg.addEventListener("hideItem",this.hideItem);
         this._bg.addEventListener("alphaItem",this.alphaItem);
         this.addChild(this._bg);
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(value:int) : void
      {
         this._position = value;
      }
      
      public function setFrame(frameIndex:int) : void
      {
         filters = this._frameFilter[frameIndex - 1];
      }
      
      private function __onMouseRollout(event:MouseEvent) : void
      {
         this.setFrame(1);
      }
      
      private function __onMouseRollover(event:MouseEvent) : void
      {
         this.setFrame(2);
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
   }
}

