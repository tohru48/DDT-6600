package gradeAwardsBoxBtn.view
{
   import bagAndInfo.cell.BagCell;
   import com.greensock.TweenMax;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.view.MainToolBar;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class GradeAwardsFlyIntoBagView
   {
      
      private static var totalCellFlying:int;
      
      private static var tooMuch:Boolean = false;
      
      public function GradeAwardsFlyIntoBagView()
      {
         super();
      }
      
      public function onFrameClose(infos:Array) : void
      {
         var globalPoint:Point = null;
         var i:int = 0;
         var info:InventoryItemInfo = null;
         var bag:BagCell = null;
         if(infos == null)
         {
            return;
         }
         var goBagBtn:BaseButton = MainToolBar.Instance.goBagBtn;
         if(Boolean(goBagBtn) && Boolean(goBagBtn.parent))
         {
            globalPoint = MainToolBar.Instance.localToGlobal(new Point(goBagBtn.x,goBagBtn.y));
         }
         else
         {
            globalPoint = new Point(MainToolBar.Instance.x,MainToolBar.Instance.y);
         }
         for(i = 0; i < infos.length; i++)
         {
            if(tooMuch)
            {
               break;
            }
            if(totalCellFlying > 30)
            {
               tooMuch = true;
               setTimeout(this.notTooMuchNow,2000);
            }
            ++totalCellFlying;
            info = infos[i] as InventoryItemInfo;
            bag = new BagCell(0,info);
            bag.x = StageReferance.stageWidth * 0.5;
            bag.y = StageReferance.stageHeight * 0.5;
            TweenMax.to(bag,0.8,{
               "onStart":this.onFlyStart,
               "onStartParams":[bag],
               "delay":i * 0.2,
               "x":globalPoint.x,
               "y":globalPoint.y,
               "onComplete":this.onGoodsIconFlied,
               "onCompleteParams":[bag]
            });
         }
      }
      
      private function notTooMuchNow() : void
      {
         tooMuch = false;
      }
      
      private function onFlyStart(tag:BagCell) : void
      {
         LayerManager.Instance.addToLayer(tag,LayerManager.GAME_TOP_LAYER);
      }
      
      private function onGoodsIconFlied(tag:BagCell) : void
      {
         --totalCellFlying;
         totalCellFlying = Math.max(0,totalCellFlying);
         tag.parent && tag.parent.removeChild(tag);
         tag.dispose();
         tag = null;
      }
   }
}

