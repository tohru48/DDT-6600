package godsRoads.data
{
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   
   public class GodsRoadsVo implements INotSameHeightListCellData
   {
      
      public var Level:int;
      
      public var currentLevel:int;
      
      public var steps:Vector.<GodsRoadsStepVo> = new Vector.<GodsRoadsStepVo>();
      
      public function GodsRoadsVo()
      {
         super();
      }
      
      public function get currentSteps() : GodsRoadsStepVo
      {
         return this.steps[this.currentLevel - 1];
      }
      
      public function getCellHeight() : Number
      {
         return 30;
      }
   }
}

