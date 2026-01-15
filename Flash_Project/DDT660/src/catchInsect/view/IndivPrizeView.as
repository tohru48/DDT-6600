package catchInsect.view
{
   import catchInsect.componets.IndivPrizeCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ServerConfigManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class IndivPrizeView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _listItem:Vector.<IndivPrizeCell>;
      
      public function IndivPrizeView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var arr:Array = null;
         var cell:IndivPrizeCell = null;
         this._bg = ComponentFactory.Instance.creat("catchInsect.indivPrizeBg");
         addChild(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("catchInsect.indivPrize.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("catchInsect.indivPrize.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this._listItem = new Vector.<IndivPrizeCell>();
         var prizeArr:Array = ServerConfigManager.instance.catchInsectPrizeInfo;
         for(var i:int = 0; i <= prizeArr.length - 1; i++)
         {
            arr = prizeArr[i].split(",");
            cell = new IndivPrizeCell();
            cell.setData(arr[0],arr[1]);
            this._vbox.addChild(cell);
            this._listItem.push(cell);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function initEvents() : void
      {
      }
      
      public function setPrizeStatus(status:int) : void
      {
         for(var i:int = 0; i <= this._listItem.length - 1; i++)
         {
            this._listItem[i].setStatus(status & 1);
            status >>= 1;
         }
      }
      
      private function removeEvents() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         for(var i:int = 0; i <= this._listItem.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._listItem[i]);
            this._listItem[i] = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
      }
   }
}

