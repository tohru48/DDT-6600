package treasureHunting.views
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import treasureHunting.TreasureEvent;
   import treasureHunting.TreasureManager;
   
   public class TreasureBagView extends Sprite implements Disposeable
   {
      
      public static const BAG_SIZE:int = 24;
      
      private var _bagBG:Bitmap;
      
      private var _baglist:BagListView;
      
      private var _getAllBtn:BaseButton;
      
      private var _sellAllBtn:BaseButton;
      
      private var _bagData:Dictionary;
      
      private var isBagUpdate:Boolean;
      
      public function TreasureBagView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this.isBagUpdate = false;
         SocketManager.Instance.out.updateTreasureBag();
      }
      
      private function initView() : void
      {
         this._bagBG = ComponentFactory.Instance.creat("treasureHunting.bagBG");
         addChild(this._bagBG);
         this._baglist = new BagListView(0,4,BAG_SIZE);
         PositionUtils.setPos(this._baglist,"treasureHunting.baglistPos");
         this._baglist.vSpace = 4;
         this._baglist.hSpace = 5;
         addChild(this._baglist);
         this._getAllBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.bag.getAllBtn");
         addChild(this._getAllBtn);
         this._sellAllBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.bag.sellAllBtn");
         addChild(this._sellAllBtn);
      }
      
      private function initEvent() : void
      {
         this._getAllBtn.addEventListener(MouseEvent.CLICK,this.onGetAllBtnClick);
         this._sellAllBtn.addEventListener(MouseEvent.CLICK,this.onSellAllBtnClick);
         this._baglist.addEventListener(CellEvent.ITEM_CLICK,this.onItemClick);
         TreasureManager.instance.addEventListener(TreasureEvent.MOVIE_COMPLETE,this.onMovieComplete);
      }
      
      public function updateData(data:Dictionary) : void
      {
         this._bagData = data;
         this.isBagUpdate = true;
         if(TreasureManager.instance.isMovieComplete)
         {
            this.updateBagFrame();
         }
      }
      
      private function onMovieComplete(event:TreasureEvent) : void
      {
         if(this.isBagUpdate)
         {
            this.updateBagFrame();
         }
      }
      
      private function updateBagFrame() : void
      {
         var i:String = null;
         var cellInfo:InventoryItemInfo = null;
         for(i in this._bagData)
         {
            cellInfo = PlayerManager.Instance.Self.CaddyBag.getItemAt(int(i));
            if(this._baglist != null)
            {
               this._baglist.setCellInfo(int(i),cellInfo);
            }
         }
         this.isBagUpdate = false;
      }
      
      private function onItemClick(event:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var item:BagCell = event.data as BagCell;
         var count:int = (item.info as InventoryItemInfo).Count;
         var bagType:int = this._getBagType(item.info as InventoryItemInfo);
         SocketManager.Instance.out.sendMoveGoods(BagInfo.CADDYBAG,item.place,bagType,-1,count);
      }
      
      private function _getBagType(info:InventoryItemInfo) : int
      {
         var type:int = 0;
         switch(info.CategoryID)
         {
            case EquipType.UNFRIGHTPROP:
               if(info.Property1 == "31")
               {
                  type = BagInfo.BEADBAG;
               }
               else
               {
                  type = BagInfo.PROPBAG;
               }
               break;
            case EquipType.FRIGHTPROP:
            case EquipType.TASK:
            case EquipType.TEXP:
            case EquipType.TEXP_TASK:
            case EquipType.ACTIVE_TASK:
            case EquipType.FOOD:
            case EquipType.PET_EGG:
            case EquipType.VEGETABLE:
               type = BagInfo.PROPBAG;
               break;
            case EquipType.SEED:
            case EquipType.MANURE:
               type = BagInfo.FARM;
               break;
            default:
               type = BagInfo.EQUIPBAG;
         }
         return type;
      }
      
      private function onGetAllBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.getAllTreasure();
      }
      
      private function onSellAllBtnClick(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("treasureHunting.alert.ensureSellAll"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.mouseEnabled = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.onAlertResponse);
      }
      
      private function onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onAlertResponse);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendSellAll();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._getAllBtn))
         {
            this._getAllBtn.removeEventListener(MouseEvent.CLICK,this.onGetAllBtnClick);
         }
         if(Boolean(this._sellAllBtn))
         {
            this._sellAllBtn.removeEventListener(MouseEvent.CLICK,this.onSellAllBtnClick);
         }
         TreasureManager.instance.removeEventListener(TreasureEvent.MOVIE_COMPLETE,this.onMovieComplete);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bagBG))
         {
            ObjectUtils.disposeObject(this._bagBG);
         }
         this._bagBG = null;
         if(Boolean(this._baglist))
         {
            ObjectUtils.disposeObject(this._baglist);
         }
         this._baglist = null;
         if(Boolean(this._getAllBtn))
         {
            ObjectUtils.disposeObject(this._getAllBtn);
         }
         this._getAllBtn = null;
         if(Boolean(this._sellAllBtn))
         {
            ObjectUtils.disposeObject(this._sellAllBtn);
         }
         this._sellAllBtn = null;
      }
   }
}

