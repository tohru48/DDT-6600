package ddt.command
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class QuickUseFrame extends BaseAlerFrame
   {
      
      private var _itemId:int;
      
      private var _cellNum:int;
      
      private var _cell:BagCell;
      
      private var _textInfo:FilterFrameText;
      
      private var _numBg:Scale9CornerImage;
      
      private var _num:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      public function QuickUseFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("task.taskView.quickUse.titleText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         alertInfo.moveEnable = false;
         alertInfo.autoDispose = false;
         info = alertInfo;
         this._textInfo = ComponentFactory.Instance.creatComponentByStylename("quickUseFrame.tipsInfo");
         this._textInfo.text = LanguageMgr.GetTranslation("quickUseFrame.tipsInfoText");
         addToContent(this._textInfo);
         this._numBg = ComponentFactory.Instance.creatComponentByStylename("quickUseFrame.itemCell.InputBg");
         addToContent(this._numBg);
         this._num = ComponentFactory.Instance.creatComponentByStylename("quickUseFrame.numText");
         addToContent(this._num);
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("asset.core.quickUse.maxBtn");
         addToContent(this._maxBtn);
      }
      
      public function setItemInfo(itemId:int, cost:int, bagType:int, needNum:int) : void
      {
         var bg:ScaleBitmapImage = null;
         var itemInfo:InventoryItemInfo = null;
         if(this._itemId != itemId)
         {
            this._itemId = itemId;
            bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
            itemInfo = PlayerManager.Instance.Self.PropBag.getItemByTemplateId(this._itemId);
            if(Boolean(itemInfo))
            {
               this._cell = new BagCell(itemInfo.Place,itemInfo,true,bg.display,false);
               this._cell.setContentSize(49,49);
               this._cell.PicPos = new Point(10,9);
               PositionUtils.setPos(this._cell,"quickUserFrame.itemcell.cellPos");
               this.updateItemCellCount(needNum);
               this._cell.bagType = bagType;
               addToContent(this._cell);
               LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
            }
            else
            {
               this.dispose();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.startNotEnough",cost));
            }
         }
      }
      
      private function updateItemCellCount(needNum:int) : void
      {
         this._cellNum = Math.min(needNum,PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._itemId));
         this._num.text = "1";
         this._cell.setCount(this._cellNum);
         this._cell.refreshTbxPos();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._num.addEventListener(Event.CHANGE,this.__onTextInput);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         this._num.text = this._cellNum.toString();
      }
      
      protected function __onTextInput(event:Event) : void
      {
         if(int(this._num.text) > this._cellNum)
         {
            this._num.text = this._cellNum.toString();
         }
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.sendTrusteeshipUseSpiritItem(this._cell.place,this._cell.bagType,int(this._num.text));
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._num.removeEventListener(Event.CHANGE,this.__onTextInput);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._textInfo);
         this._textInfo = null;
         ObjectUtils.disposeObject(this._numBg);
         this._numBg = null;
         ObjectUtils.disposeObject(this._num);
         this._num = null;
         ObjectUtils.disposeObject(this._maxBtn);
         this._maxBtn = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

