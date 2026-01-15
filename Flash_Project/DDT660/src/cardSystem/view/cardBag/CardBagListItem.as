package cardSystem.view.cardBag
{
   import cardSystem.data.CardInfo;
   import cardSystem.elements.CardBagCell;
   import cardSystem.elements.CardCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardBagListItem extends Sprite implements Disposeable, IListCell
   {
      
      public static const CELL_NUM:int = 4;
      
      private var _dataVec:Array;
      
      private var _cellVec:Vector.<CardCell>;
      
      private var _container:HBox;
      
      public function CardBagListItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get cellVec() : Vector.<CardCell>
      {
         return this._cellVec;
      }
      
      private function initEvent() : void
      {
      }
      
      private function initView() : void
      {
         var cell:CardBagCell = null;
         this._dataVec = new Array();
         this._cellVec = new Vector.<CardCell>(CELL_NUM);
         this._container = ComponentFactory.Instance.creatComponentByStylename("cardBagListItem.container");
         for(var i:int = 0; i < CELL_NUM; i++)
         {
            cell = new CardBagCell(ComponentFactory.Instance.creatBitmap("asset.cardBag.cardBG"));
            cell.setContentSize(71,96);
            cell.canShine = true;
            cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            cell.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            this._container.addChild(cell);
            this._cellVec[i] = cell;
         }
         addChild(this._container);
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         var cell:CardBagCell = event.currentTarget as CardBagCell;
         if(Boolean(cell.cardInfo))
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      protected function __clickHandler(event:InteractiveEvent) : void
      {
         var info:ItemTemplateInfo = null;
         event.stopImmediatePropagation();
         var cell:CardBagCell = event.currentTarget as CardBagCell;
         if(Boolean(cell))
         {
            info = cell.info as ItemTemplateInfo;
         }
         if(info == null)
         {
            return;
         }
         if(!cell.locked)
         {
            SoundManager.instance.play("008");
            cell.dragStart();
         }
      }
      
      protected function __doubleClickHandler(event:InteractiveEvent) : void
      {
         var ref:Boolean = false;
         var i:int = 0;
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var cell:CardBagCell = event.currentTarget as CardBagCell;
         if(Boolean(cell.cardInfo))
         {
            if(Boolean(cell) && !cell.locked)
            {
               if(cell.cardInfo.templateInfo.Property8 == "1")
               {
                  SocketManager.Instance.out.sendMoveCards(cell.cardInfo.Place,0);
                  return;
               }
               ref = true;
               for(i = 1; i < 5; i++)
               {
                  if(PlayerManager.Instance.Self.cardEquipDic[i] == null || PlayerManager.Instance.Self.cardEquipDic[i].Count < 0)
                  {
                     SocketManager.Instance.out.sendMoveCards(cell.cardInfo.Place,i);
                     ref = false;
                     break;
                  }
               }
               if(ref)
               {
                  SocketManager.Instance.out.sendMoveCards(cell.cardInfo.Place,1);
               }
            }
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._dataVec;
      }
      
      public function setCellValue(value:*) : void
      {
         this._dataVec = value;
         this.upView();
      }
      
      override public function get height() : Number
      {
         return this._container.height;
      }
      
      private function upView() : void
      {
         for(var i:int = 0; i < CELL_NUM; i++)
         {
            this._cellVec[i].place = this._dataVec[0] * 4 + i + 1;
            if(Boolean(this._dataVec[i + 1]))
            {
               this._cellVec[i].cardInfo = this._dataVec[i + 1] as CardInfo;
            }
            else
            {
               this._cellVec[i].cardInfo = null;
            }
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this._dataVec = null;
         for(var i:int = 0; i < this._cellVec.length; i++)
         {
            this._cellVec[i].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            this._cellVec[i].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            this._cellVec[i].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            DoubleClickManager.Instance.disableDoubleClick(this._cellVec[i]);
            this._cellVec[i].dispose();
            this._cellVec[i] = null;
         }
         this._cellVec = null;
         DoubleClickManager.Instance.clearTarget();
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

