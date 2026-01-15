package roulette
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class RouletteCell extends BaseCell
   {
      
      private var _selected:Boolean;
      
      private var _count:int;
      
      private var _boolCreep:Boolean;
      
      private var _selectMovie:MovieClip;
      
      public function RouletteCell(bg:DisplayObject)
      {
         super(bg);
         this.initII();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(0,0);
      }
      
      protected function initII() : void
      {
         this._selectMovie = ComponentFactory.Instance.creat("asset.roulette.GlintAsset");
         addChild(this._selectMovie);
         this.count = 0;
         tipDirctions = "1,2,7,0";
      }
      
      public function setSparkle() : void
      {
         this.selected = true;
         this._selectMovie.gotoAndStop(1);
      }
      
      public function set count(n:int) : void
      {
         this._count = n;
      }
      
      public function get count() : int
      {
         return this._count;
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
         super.dispose();
         if(Boolean(this._selectMovie))
         {
            ObjectUtils.disposeObject(this._selectMovie);
         }
         this._selectMovie = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

