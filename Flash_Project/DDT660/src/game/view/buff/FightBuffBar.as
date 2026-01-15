package game.view.buff
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightBuffInfo;
   import flash.display.Sprite;
   
   public class FightBuffBar extends Sprite implements Disposeable
   {
      
      private var _buffCells:Vector.<BuffCell> = new Vector.<BuffCell>();
      
      public function FightBuffBar()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      private function clearBuff() : void
      {
         var cell:BuffCell = null;
         for each(cell in this._buffCells)
         {
            cell.clearSelf();
         }
      }
      
      private function drawBuff() : void
      {
      }
      
      public function update(buffs:Vector.<FightBuffInfo>) : void
      {
         var i:int = 0;
         var cell:BuffCell = null;
         this.clearBuff();
         var len:int = int(buffs.length);
         for(i = 0; i < len; i++)
         {
            if(i + 1 > this._buffCells.length)
            {
               cell = new BuffCell();
               this._buffCells.push(cell);
            }
            else
            {
               cell = this._buffCells[i];
            }
            cell.setInfo(buffs[i]);
            cell.x = (i & 3) * 24;
            cell.y = -(i >> 2) * 24;
            addChild(cell);
         }
      }
      
      public function dispose() : void
      {
         var cell:BuffCell = this._buffCells.shift();
         while(Boolean(cell))
         {
            ObjectUtils.disposeObject(cell);
            cell = this._buffCells.shift();
         }
         this._buffCells = null;
      }
   }
}

