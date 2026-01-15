package bagAndInfo.bag
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SellGoodsFrame extends Frame
   {
      
      public static const OK:String = "ok";
      
      public static const CANCEL:String = "cancel";
      
      private var _itemInfo:InventoryItemInfo;
      
      private var _confirm:TextButton;
      
      private var _cancel:TextButton;
      
      private var _cell:BaseCell;
      
      private var _nameTxt:FilterFrameText;
      
      private var _descript:FilterFrameText;
      
      private var _price:FilterFrameText;
      
      public function SellGoodsFrame()
      {
         super();
         this.initView();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmhandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
      }
      
      protected function __confirmhandler(event:MouseEvent) : void
      {
         this.ok();
      }
      
      protected function __cancelHandler(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.ok();
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               this.cancel();
         }
      }
      
      private function ok() : void
      {
         SoundManager.instance.play("008");
         if(this._itemInfo.Property1 != "31")
         {
            SocketManager.Instance.out.reclaimGoods(this._itemInfo.BagType,this._itemInfo.Place,this._itemInfo.Count);
            dispatchEvent(new Event(OK));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipCannotSell"));
         }
         this.dispose();
      }
      
      private function cancel() : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(CANCEL));
         this.dispose();
      }
      
      public function set itemInfo(info:InventoryItemInfo) : void
      {
         this._itemInfo = info;
         this._cell.info = info;
         if(info.Name.length > 20)
         {
            this._nameTxt.text = info.Name.substring(0,20) + "..";
         }
         else
         {
            this._nameTxt.text = info.Name;
         }
         if(info.CategoryID == EquipType.CARDBOX)
         {
            this._nameTxt.textColor = QualityType.QUALITY_COLOR[info.Quality + 1];
         }
         else
         {
            this._nameTxt.textColor = QualityType.QUALITY_COLOR[info.Quality];
         }
         var type:String = info.ReclaimType == 1 ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : (info.ReclaimType == 2 ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "");
         this._descript.htmlText = LanguageMgr.GetTranslation("bagAndInfo.sellFrame.explainTxt",info.Count) + "       " + "                                                       ".substr(0,this._price.text.length * 2 + 2) + type;
         this._price.text = info.Count * info.ReclaimValue + "";
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.ok");
         this._confirm.text = LanguageMgr.GetTranslation("ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.cancel");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._cell = new BaseCell(ClassUtils.CreatInstance("asset.core.ItemCellBG"));
         PositionUtils.setPos(this._cell,"sellFrame.cellPos");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.name");
         PositionUtils.setPos(this._nameTxt,"sellFrame.namePos");
         this._descript = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.explain");
         this._price = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame.price");
         addToContent(this._confirm);
         addToContent(this._cancel);
         addToContent(this._cell);
         addToContent(this._nameTxt);
         addToContent(this._descript);
         addToContent(this._price);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._confirm))
         {
            this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmhandler);
         }
         if(Boolean(this._cancel))
         {
            this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         }
         super.dispose();
         this._itemInfo = null;
         if(Boolean(this._confirm))
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(Boolean(this._cancel))
         {
            ObjectUtils.disposeObject(this._cancel);
         }
         this._cancel = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._descript))
         {
            ObjectUtils.disposeObject(this._descript);
         }
         this._descript = null;
         if(Boolean(this._price))
         {
            ObjectUtils.disposeObject(this._price);
         }
         this._price = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

