package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellContentCreator;
   import com.greensock.TweenMax;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LevelRewardCell extends BaseCell
   {
      
      public function LevelRewardCell($info:ItemTemplateInfo = null)
      {
         super(null,$info,false,true);
      }
      
      override protected function createChildren() : void
      {
         _pic = new CellContentCreator();
         _pic.mouseEnabled = false;
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            _pic.width = this.getSize();
            _pic.height = this.getSize();
            _pic.x = -this.getSize() * 0.5;
            _pic.y = -this.getSize() * 0.5;
         }
      }
      
      private function getSize() : Number
      {
         return info.CategoryID == EquipType.FRIGHTPROP ? 42 : 48;
      }
      
      override public function get height() : Number
      {
         return 48;
      }
      
      override public function get width() : Number
      {
         return 48;
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         scaleY = 1.1;
         scaleX = 1.1;
         this.showEffect();
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         scaleY = 1;
         scaleX = 1;
         this.hideEffect();
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3
            }
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
         _pic.width = _pic.height = this.getSize();
         _pic.x = _pic.y = -this.getSize() * 0.5;
      }
   }
}

