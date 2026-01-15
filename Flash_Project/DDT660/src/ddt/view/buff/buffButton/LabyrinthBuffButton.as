package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LabyrinthBuffButton extends BuffButton
   {
      
      private var _labyrinthBuffTipView:LabyrinthBuffTipView;
      
      private var _helpViewShow:Boolean = false;
      
      public function LabyrinthBuffButton()
      {
         super("asset.core.LabyrinthBuffAsset");
         _tipDirctions = "7,4,5,1";
         this.initView();
      }
      
      private function initView() : void
      {
         info = new BuffInfo(BuffInfo.LABYRINTH_BUFF);
         info.description = LanguageMgr.GetTranslation("ddt.buffinfo.labyrinthBuffhelp");
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      override protected function __onclick(event:MouseEvent) : void
      {
         var viewPos:Point = null;
         super.__onclick(event);
         if(!this._helpViewShow)
         {
            event.stopImmediatePropagation();
            this._labyrinthBuffTipView = new LabyrinthBuffTipView();
            this._helpViewShow = true;
            viewPos = this.localToGlobal(new Point(this.x + this.width,this.y + this.height));
            viewPos.x -= 252;
            PositionUtils.setPos(this._labyrinthBuffTipView,viewPos);
            LayerManager.Instance.addToLayer(this._labyrinthBuffTipView,LayerManager.GAME_DYNAMIC_LAYER);
            stage.addEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
         }
         else if(Boolean(this._labyrinthBuffTipView))
         {
            this._labyrinthBuffTipView.dispose();
            this._labyrinthBuffTipView = null;
            this._helpViewShow = false;
         }
      }
      
      protected function __closeChairChnnel(event:MouseEvent) : void
      {
         if(!this._labyrinthBuffTipView)
         {
            return;
         }
         if(!(event.stageX >= this._labyrinthBuffTipView.x && event.stageX <= this._labyrinthBuffTipView.x + this._labyrinthBuffTipView.width && event.stageY >= this._labyrinthBuffTipView.y && event.stageY <= this._labyrinthBuffTipView.y + this._labyrinthBuffTipView.height))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
            if(Boolean(this._labyrinthBuffTipView))
            {
               this._labyrinthBuffTipView.dispose();
               this._labyrinthBuffTipView = null;
               this._helpViewShow = false;
            }
         }
      }
      
      private function checkIsVBoxChild(target:*, buffItemVBox:VBox) : Boolean
      {
         for(var i:int = 0; i < buffItemVBox.numChildren; i++)
         {
            if(target == buffItemVBox.getChildAt(i))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._labyrinthBuffTipView))
         {
            this._labyrinthBuffTipView.dispose();
            this._labyrinthBuffTipView = null;
         }
         super.dispose();
      }
   }
}

