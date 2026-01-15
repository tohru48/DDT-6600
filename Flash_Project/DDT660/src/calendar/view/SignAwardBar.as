package calendar.view
{
   import bagAndInfo.cell.BagCell;
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SignAwardBar extends Sprite implements Disposeable
   {
      
      private var _items:Vector.<NavigItem> = new Vector.<NavigItem>();
      
      private var _itemsHbox:HBox;
      
      private var _current:NavigItem;
      
      private var _model:CalendarModel;
      
      private var _back:DisplayObject;
      
      private var _title:DisplayObject;
      
      private var _awardHolder:SignedAwardHolder;
      
      private var _signCoundField:FilterFrameText;
      
      private var _selectedItem:NavigItem;
      
      private var _signedTimesPanel:Image;
      
      public var _petBtn:SimpleBitmapButton;
      
      private var receivedBG:Bitmap;
      
      public function SignAwardBar(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         var itemInfo:ItemTemplateInfo = null;
         var tInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         var flag:Boolean = false;
         this._signCoundField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignCountField");
         this._signCoundField.text = this._model.signCount.toString();
         addChild(this._signCoundField);
         this._awardHolder = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignedAwardHolder",[this._model]);
         addChild(this._awardHolder);
         this._itemsHbox = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.hBox");
         addChild(this._itemsHbox);
         this.drawCells();
         var goodaObj:Object = this.returnPetID();
         if(goodaObj != null)
         {
            itemInfo = ItemManager.Instance.getTemplateById(goodaObj.Remark) as ItemTemplateInfo;
            tInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(tInfo,itemInfo);
            tInfo.ValidDate = goodaObj.ValidDate;
            tInfo.IsBinds = true;
            tInfo.Count = goodaObj.Count;
            cell = new BagCell(0,tInfo,false);
            cell.setBgVisible(false);
            cell.width = 38;
            cell.height = 37;
            cell.x = 280;
            cell.y = 19;
            this._petBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.petBtn");
            addChild(this._petBtn);
            addChild(cell);
            flag = this.returnPetIsShow(CalendarManager.getInstance().model.signCount);
            this._petBtn.enable = this._petBtn.mouseChildren = this._petBtn.mouseEnabled = flag;
            this.receivedBG = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.received");
            this.receivedBG.visible = CalendarManager.getInstance().isOK;
            addChild(this.receivedBG);
         }
      }
      
      private function returnPetIsShow(count:int) : Boolean
      {
         var serverTime:Date = TimeManager.Instance.Now();
         var date:Date = new Date(serverTime.getFullYear(),serverTime.getMonth() + 1);
         date.time -= 1;
         var totalDay:int = date.date;
         if(count == totalDay && !CalendarManager.getInstance().isOK)
         {
            return true;
         }
         return false;
      }
      
      private function returnPetID() : Object
      {
         var obj:Object = null;
         var serverDate:Date = TimeManager.Instance.Now();
         for(var i:int = 0; i < CalendarManager.getInstance().signPetInfo.length; i++)
         {
            if(CalendarManager.getInstance().signPetInfo[i].AwardDays == serverDate.getMonth() + 1)
            {
               obj = new Object();
               obj.Remark = CalendarManager.getInstance().signPetInfo[i].Remark;
               obj.ValidDate = CalendarManager.getInstance().signPetInfo[i].ValidDate;
               obj.Count = CalendarManager.getInstance().signPetInfo[i].Count;
               return obj;
            }
         }
         return null;
      }
      
      private function drawCells() : void
      {
         var i:int = 0;
         var item:NavigItem = null;
         var len:int = int(this._model.awardCounts.length);
         var receivedCount:int = 0;
         var start:Point = ComponentFactory.Instance.creatCustomObject("ddtcalendar.Award.TopLeft");
         for(i = 0; i < len; i++)
         {
            item = new NavigItem(this._model.awardCounts[i]);
            item.x = start.x + i * (item.width + 9);
            item.y = start.y;
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items.push(item);
            this._itemsHbox.addChild(item);
            if(this._model.hasReceived(this._model.awardCounts[i]))
            {
               item.received = true;
               receivedCount++;
            }
         }
         if(receivedCount < this._items.length)
         {
            this._items[receivedCount].selected = true;
            this._selectedItem = this._items[receivedCount];
            this._awardHolder.setAwardsByCount(this._selectedItem.count);
         }
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         var item:NavigItem = event.currentTarget as NavigItem;
         if(this._selectedItem != item)
         {
            this._selectedItem.selected = false;
            this._selectedItem = item;
            this._selectedItem.selected = true;
            this._awardHolder.setAwardsByCount(this._selectedItem.count);
            SoundManager.instance.play("008");
         }
      }
      
      private function reset() : void
      {
         var len:int = int(this._model.awardCounts.length);
         for(var i:int = 0; i < len; i++)
         {
            this._items[i].received = false;
            this._items[i].selected = false;
         }
         this._selectedItem = this._items[0];
         this._selectedItem.selected = true;
         this._awardHolder.setAwardsByCount(this._selectedItem.count);
      }
      
      private function __signCountChanged(event:Event) : void
      {
         var len:int = 0;
         var receivedCount:int = 0;
         var i:int = 0;
         this._signCoundField.text = this._model.signCount.toString();
         if(this._model.signCount == 0)
         {
            this.reset();
         }
         else
         {
            len = int(this._model.awardCounts.length);
            receivedCount = 0;
            for(i = 0; i < len; i++)
            {
               if(this._model.hasReceived(this._model.awardCounts[i]))
               {
                  this._items[i].received = true;
                  if(this._items[i] == this._selectedItem)
                  {
                     this._selectedItem = null;
                  }
                  receivedCount++;
               }
            }
            if(receivedCount < this._items.length && this._selectedItem == null)
            {
               this._items[receivedCount].selected = true;
               this._selectedItem = this._items[receivedCount];
               this._awardHolder.setAwardsByCount(this._selectedItem.count);
            }
            else if(this._selectedItem == null)
            {
               this._awardHolder.clean();
            }
         }
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(CalendarEvent.SignCountChanged,this.__signCountChanged);
         CalendarManager.getInstance().addEventListener(CalendarManager.PET_BTN_SHOW,this.__onPetShow);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__onPetBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(CalendarEvent.SignCountChanged,this.__signCountChanged);
         CalendarManager.getInstance().removeEventListener(CalendarManager.PET_BTN_SHOW,this.__onPetShow);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__onPetBtnClick);
      }
      
      private function __onPetShow(e:Event) : void
      {
         this._petBtn.enable = this._petBtn.mouseChildren = this._petBtn.mouseEnabled = true;
      }
      
      private function __onPetBtnClick(e:MouseEvent) : void
      {
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__onPetBtnClick);
         CalendarManager.getInstance().isOK = true;
         this.receivedBG.visible = CalendarManager.getInstance().isOK;
         this._petBtn.enable = this._petBtn.mouseChildren = this._petBtn.mouseEnabled = false;
         GameInSocketOut.sendCalendarPet();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._signCoundField);
         this._signCoundField = null;
         ObjectUtils.disposeObject(this._awardHolder);
         this._awardHolder = null;
         if(Boolean(this._itemsHbox))
         {
            ObjectUtils.disposeObject(this._itemsHbox);
         }
         this._itemsHbox = null;
         var item:NavigItem = this._items.shift();
         while(item != null)
         {
            ObjectUtils.disposeObject(item);
            item = this._items.shift();
         }
         this._selectedItem = null;
         this._current = null;
         this._model = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

