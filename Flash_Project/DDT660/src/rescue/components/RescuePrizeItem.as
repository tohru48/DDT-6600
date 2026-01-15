package rescue.components
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import rescue.RescueManager;
   import rescue.data.RescueRewardInfo;
   
   public class RescuePrizeItem extends Sprite implements Disposeable
   {
      
      private var _sp:Sprite;
      
      private var _bg:Bitmap;
      
      private var _prizeImg:Bitmap;
      
      private var _bagCell:BagCell;
      
      private var _alreadyGet:Bitmap;
      
      private var _index:int;
      
      private var _downFlag:Boolean;
      
      public function RescuePrizeItem(index:int)
      {
         this._index = index;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._sp = new Sprite();
         addChild(this._sp);
         this._bg = ComponentFactory.Instance.creat("rescue.prizeBg");
         this._sp.addChild(this._bg);
         this._bagCell = CellFactory.instance.createBagCell(0) as BagCell;
         this._bagCell.scaleX = 1.1;
         this._bagCell.scaleY = 1.1;
         this._bagCell.x = 15;
         this._bagCell.y = 10;
         this._sp.addChild(this._bagCell);
         this._prizeImg = ComponentFactory.Instance.creat("rescue.starPrize" + this._index);
         PositionUtils.setPos(this._prizeImg,"rescue.starPrizePos");
         this._sp.addChild(this._prizeImg);
         this._alreadyGet = ComponentFactory.Instance.creat("rescue.alreadyGet");
         addChild(this._alreadyGet);
         this._alreadyGet.visible = false;
      }
      
      private function addEvents() : void
      {
         this._sp.buttonMode = true;
         this._sp.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         this._sp.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         this._sp.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._sp.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      protected function __mouseOut(event:MouseEvent) : void
      {
         if(this._downFlag)
         {
            this._sp.x -= 1;
            this._sp.y -= 1;
            this._downFlag = false;
         }
         this._sp.filters = null;
      }
      
      protected function __mouseOver(event:MouseEvent) : void
      {
         this._sp.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function __mouseUp(event:MouseEvent) : void
      {
         if(this._downFlag)
         {
            this._sp.x -= 1;
            this._sp.y -= 1;
            this._downFlag = false;
         }
      }
      
      protected function __mouseDown(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._sp.x += 1;
         this._sp.y += 1;
         this._downFlag = true;
         SocketManager.Instance.out.getRescuePrize(RescueManager.instance.curIndex + 1,this._index + 1);
      }
      
      public function setData(reward:RescueRewardInfo) : void
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = reward.TemplateID;
         info = ItemManager.fill(info);
         info.IsBinds = reward.IsBind;
         info.ValidDate = reward.ValidDate;
         info._StrengthenLevel = reward.StrengthenLevel;
         info.AttackCompose = reward.AttackCompose;
         info.DefendCompose = reward.DefendCompose;
         info.AgilityCompose = reward.AgilityCompose;
         info.LuckCompose = reward.LuckCompose;
         this._bagCell.info = info;
         this._bagCell.setCountNotVisible();
         this._bagCell.setBgVisible(false);
      }
      
      public function setStatus(value:int) : void
      {
         switch(value)
         {
            case 0:
               this._sp.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._alreadyGet.visible = false;
               this.removeEvents();
               break;
            case 1:
               this._sp.filters = null;
               this._alreadyGet.visible = false;
               this.addEvents();
               break;
            case 2:
               this._sp.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._alreadyGet.visible = true;
               this.removeEvents();
         }
      }
      
      private function removeEvents() : void
      {
         this._sp.buttonMode = false;
         this._sp.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         this._sp.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         this._sp.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._sp.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._sp);
         this._sp = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._prizeImg);
         this._prizeImg = null;
         ObjectUtils.disposeObject(this._bagCell);
         this._bagCell = null;
         ObjectUtils.disposeObject(this._alreadyGet);
         this._alreadyGet = null;
      }
   }
}

