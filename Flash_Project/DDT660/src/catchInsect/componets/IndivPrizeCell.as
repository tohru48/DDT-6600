package catchInsect.componets
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class IndivPrizeCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _requestTxt:FilterFrameText;
      
      private var _cellBg:Bitmap;
      
      private var _cell:BagCell;
      
      private var _getPrizeBtn:SimpleBitmapButton;
      
      private var _templateId:int;
      
      public function IndivPrizeCell()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("catchInsect.prizeItemBg");
         addChild(this._bg);
         this._requestTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.requestTxt");
         addChild(this._requestTxt);
         this._requestTxt.text = "";
         this._cellBg = ComponentFactory.Instance.creat("catchInsect.cellBg");
         addChild(this._cellBg);
         this._cell = new BagCell(0);
         PositionUtils.setPos(this._cell,"catchInsect.cellPos");
         addChild(this._cell);
         this._cell.setBgVisible(false);
         this._getPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.getPrizeBtn");
         addChild(this._getPrizeBtn);
      }
      
      private function initEvents() : void
      {
         this._getPrizeBtn.addEventListener(MouseEvent.CLICK,this.__getPrizeBtnClick);
      }
      
      protected function __getPrizeBtnClick(event:MouseEvent) : void
      {
         SocketManager.Instance.out.getInsectPrize(this._templateId);
      }
      
      public function setData(templateId:int, need:int) : void
      {
         this._templateId = templateId;
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = this._templateId;
         ItemManager.fill(info);
         info.IsBinds = true;
         this._cell.info = info;
         this._cell.setCountNotVisible();
         this._requestTxt.text = LanguageMgr.GetTranslation("catchInsect.needScore",need);
      }
      
      public function setStatus(value:int) : void
      {
         switch(value)
         {
            case 0:
               this._getPrizeBtn.enable = true;
               break;
            case 1:
               this._getPrizeBtn.enable = false;
         }
      }
      
      private function removeEvents() : void
      {
         this._getPrizeBtn.removeEventListener(MouseEvent.CLICK,this.__getPrizeBtnClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._cellBg);
         this._cell = null;
         ObjectUtils.disposeObject(this._getPrizeBtn);
         this._getPrizeBtn = null;
         ObjectUtils.disposeObject(this._requestTxt);
         this._requestTxt = null;
      }
   }
}

