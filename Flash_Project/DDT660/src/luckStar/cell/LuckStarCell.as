package luckStar.cell
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import luckStar.event.LuckStarEvent;
   import luckStar.view.LuckStarAwardAction;
   
   public class LuckStarCell extends BaseCell
   {
      
      private var _maxAward:Bitmap;
      
      private var _cellFrame:Bitmap;
      
      private var _txtCount:FilterFrameText;
      
      private var _selectMovie:MovieClip;
      
      public var _isMaxAward:Boolean;
      
      private var _awardAction:LuckStarAwardAction;
      
      private var _selected:Boolean;
      
      private var _boolCreep:Boolean;
      
      public function LuckStarCell(bg:DisplayObject = null)
      {
         super(ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.cellBg"));
         this.initView();
      }
      
      private function initView() : void
      {
         this._maxAward = ComponentFactory.Instance.creat("luckyStar.view.MaxAward");
         this._cellFrame = ComponentFactory.Instance.creat("luckyStar.view.CellFrame");
         this._txtCount = ComponentFactory.Instance.creat("luckyStar.view.cellCount");
         this._selectMovie = ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectGlintAsset");
         this._selectMovie.x = 5;
         this._selectMovie.y = 6;
         addChild(this._cellFrame);
         addChild(this._maxAward);
         addChild(this._selectMovie);
         this._maxAward.visible = false;
         this._cellFrame.visible = false;
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         if(value == null)
         {
            return;
         }
         super.info = value;
         if(value.Quality == 1)
         {
            this._isMaxAward = true;
            this._maxAward.visible = true;
            if(Boolean(_pic))
            {
               _pic.visible = false;
            }
         }
         else if(value.Quality == 2)
         {
            this._cellFrame.visible = true;
         }
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.width = 48;
            sp.height = 48;
            if(_picPos != null)
            {
               sp.x = _picPos.x;
            }
            else
            {
               sp.x = Math.abs(sp.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               sp.y = _picPos.y;
            }
            else
            {
               sp.y = Math.abs(sp.height - _contentHeight) / 2;
            }
         }
      }
      
      public function get isMaxAward() : Boolean
      {
         return this._isMaxAward;
      }
      
      public function set count(value:int) : void
      {
         if(value <= 1)
         {
            this._txtCount.text = "";
            return;
         }
         this._txtCount.text = String(value);
         addChild(this._txtCount);
      }
      
      public function playAction() : void
      {
         if(Boolean(this._awardAction))
         {
            this._awardAction.dispose();
            this._awardAction = null;
         }
         this._awardAction = new LuckStarAwardAction();
         this._awardAction.playAction(this.cell,createDragImg(),this.getMove(),this.isMaxAward);
         if(!this.isMaxAward)
         {
            addChild(this._awardAction.actionDisplay);
         }
      }
      
      private function getMove() : Point
      {
         return globalToLocal(ComponentFactory.Instance.creatCustomObject("luckyStar.view.goalPos"));
      }
      
      private function cell() : void
      {
         ObjectUtils.disposeObject(this._awardAction);
         this._awardAction = null;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.CELL_ACTION_COMPLETE));
      }
      
      public function setSparkle() : void
      {
         this.selected = true;
         this._selectMovie.gotoAndStop(1);
      }
      
      public function setGreep() : void
      {
         if(!this._boolCreep && this._selected)
         {
            this._selectMovie.gotoAndPlay(2);
            this._boolCreep = true;
         }
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this._selectMovie.visible = this._selected;
         if(this._selected == false)
         {
            this._boolCreep = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._awardAction))
         {
            ObjectUtils.disposeObject(this._awardAction);
            this._awardAction = null;
         }
         ObjectUtils.disposeObject(this._txtCount);
         this._txtCount = null;
         ObjectUtils.disposeObject(this._maxAward);
         this._maxAward = null;
         ObjectUtils.disposeObject(this._cellFrame);
         this._cellFrame = null;
         super.dispose();
      }
   }
}

