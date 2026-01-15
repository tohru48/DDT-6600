package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import flash.display.Sprite;
   
   public class LevelRewardList extends Sprite
   {
      
      private var _cells:Vector.<BaseCell>;
      
      public function LevelRewardList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._cells = new Vector.<BaseCell>();
      }
      
      public function addCell(cell:BaseCell) : void
      {
         this._cells.push(cell);
         addChild(cell);
         this.arrangeCell();
      }
      
      private function arrangeCell() : void
      {
         var i:int = 0;
         for(i = 0; i < this._cells.length; i++)
         {
            this._cells[i].scaleX = this._cells[i].scaleY = 1;
            if(i == 0)
            {
               addChild(this._cells[0]);
               this._cells[0].x = this._cells[0].y = 0;
            }
            else
            {
               addChild(this._cells[i]);
               this._cells[i].x = this._cells[i - 1].x + this._cells[i - 1].width + 5;
            }
         }
      }
      
      public function disopse() : void
      {
         for(var i:int = 0; i < this._cells.length; i++)
         {
            this._cells[i].dispose();
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

