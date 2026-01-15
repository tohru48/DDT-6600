package magicHouse.treasureHouse
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseTipFrame;
   
   public class MagicHouseTreasureBagListView extends BagListView
   {
      
      private static var MAX_LINE_NUM:int = 10;
      
      private static const baseDepotCount:int = 10;
      
      private var _depotNum:int;
      
      private var _needMoney:int = 0;
      
      private var _pos:int = 0;
      
      private var _frame:MagicHouseTipFrame;
      
      public function MagicHouseTreasureBagListView(bagType:int, num:int = 0)
      {
         super(bagType,MAX_LINE_NUM);
      }
      
      public function addDepot(num:int) : void
      {
         var index:int = 0;
         var cell:MagicHouseTreasureCell = null;
         if(num == this._depotNum)
         {
            return;
         }
         for(var i:int = this._depotNum; i < num; i++)
         {
            index = i;
            cell = _cells[index] as MagicHouseTreasureCell;
            cell.grayFilters = false;
            cell.isOpen = true;
         }
         this._depotNum = num;
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as MagicHouseTreasureCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
         }
      }
      
      override protected function __clickHandler(e:InteractiveEvent) : void
      {
         var i:int = 0;
         if(Boolean(e.currentTarget.isOpen))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,e.currentTarget,false,false));
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._needMoney = 0;
            this._pos = e.currentTarget.pos;
            for(i = MagicHouseManager.instance.depotCount; i < e.currentTarget.pos + 1; )
            {
               this._needMoney += MagicHouseManager.instance.openDepotNeedMoney + (++i - baseDepotCount - 1) * MagicHouseManager.instance.depotPromoteNeedMoney;
            }
            if(!this._frame)
            {
               this._frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame");
               this._frame.titleText = LanguageMgr.GetTranslation("magichouse.treasureView.openDepotTitle");
               this._frame.setTipHtmlText(LanguageMgr.GetTranslation("magichouse.treasureView.openDepot",this._needMoney,e.currentTarget.pos + 1 - MagicHouseManager.instance.depotCount));
               LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._frame.okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnHandler);
               this._frame.cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnHandler);
               this._frame.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
      }
      
      private function __okBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Money < this._needMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         SocketManager.Instance.out.magicOpenDepot(this._pos);
      }
      
      private function __cancelBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__cancelBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
      }
      
      private function __confirmResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Money < this._needMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.magicOpenDepot(this._pos);
         }
      }
      
      override protected function createCells() : void
      {
         var j:int = 0;
         var index:int = 0;
         var cell:MagicHouseTreasureCell = null;
         _cells = new Dictionary();
         for(var i:int = 0; i < MAX_LINE_NUM; i++)
         {
            for(j = 0; j < MAX_LINE_NUM; j++)
            {
               index = i * MAX_LINE_NUM + j;
               cell = CellFactory.instance.createTreasureCell(index) as MagicHouseTreasureCell;
               addChild(cell);
               cell.bagType = _bagType;
               cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               DoubleClickManager.Instance.enableDoubleClick(cell);
               cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
               _cells[cell.place] = cell;
               if(this._depotNum <= i * MAX_LINE_NUM + j)
               {
                  cell.grayFilters = true;
                  cell.isOpen = false;
               }
            }
         }
      }
      
      public function checkMagicHouseStoreCell() : int
      {
         var cell:MagicHouseTreasureCell = null;
         for(var i:int = 0; i < this._depotNum; i++)
         {
            cell = _cells[i] as MagicHouseTreasureCell;
            if(!cell.info)
            {
               return 1;
            }
         }
         return 0;
      }
      
      public function set depotNum(value:int) : void
      {
         this._depotNum = value;
      }
      
      override public function dispose() : void
      {
         var cell:MagicHouseTreasureCell = null;
         for each(cell in _cells)
         {
            cell.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            cell.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

