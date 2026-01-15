package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.DisplayObjectViewport;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import game.view.propertyWaterBuff.PropertyWaterBuffBar;
   import road7th.data.DictionaryData;
   
   public class LabyrinthBuffTipView extends Sprite
   {
      
      private var _viewBg:ScaleBitmapImage;
      
      private var _buffList:DictionaryData;
      
      private var _buffItemVBox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function LabyrinthBuffTipView()
      {
         super();
         this._buffList = PropertyWaterBuffBar.getPropertyWaterBuffList(PlayerManager.Instance.Self.buffInfo);
         this.initView();
         this.createIconList();
      }
      
      private function createIconList() : void
      {
         var buffInfo:BuffInfo = null;
         var item:LabyrinthBuffItem = null;
         for each(buffInfo in this._buffList)
         {
            item = new LabyrinthBuffItem(buffInfo);
            this._buffItemVBox.addChild(item);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function initView() : void
      {
         this._viewBg = ComponentFactory.Instance.creatComponentByStylename("bagBuffer.tipView.bg");
         addChild(this._viewBg);
         this._viewBg.height = 177;
         this._buffItemVBox = ComponentFactory.Instance.creatComponentByStylename("labyrinthBuff.Vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("labyrinthBuff.scrollPanel");
         this._scrollPanel.setView(this._buffItemVBox);
         addChild(this._scrollPanel);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._buffItemVBox);
         this._buffItemVBox = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         if(Boolean(this._viewBg))
         {
            this._viewBg.dispose();
            this._viewBg = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get viewBg() : DisplayObjectViewport
      {
         return this._scrollPanel.displayObjectViewport;
      }
      
      public function get buffItemVBox() : VBox
      {
         return this._buffItemVBox;
      }
   }
}

