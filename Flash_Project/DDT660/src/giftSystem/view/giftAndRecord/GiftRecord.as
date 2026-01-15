package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   import giftSystem.data.RecordInfo;
   import giftSystem.element.RecordItem;
   
   public class GiftRecord extends Sprite implements Disposeable
   {
      
      private var _playerInfo:PlayerInfo;
      
      private var _canClick:Boolean = false;
      
      private var _noGift:Bitmap;
      
      private var _container:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemArr:Vector.<RecordItem>;
      
      public function GiftRecord()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._itemArr = new Vector.<RecordItem>();
         this._container = ComponentFactory.Instance.creatComponentByStylename("RecordParent.container");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("RecordParent.Panel");
         this._panel.setView(this._container);
         addChild(this._panel);
      }
      
      private function initEvent() : void
      {
         GiftController.Instance.addEventListener(GiftEvent.LOAD_RECORD_COMPLETE,this.__setRecordList);
      }
      
      private function removeEvent() : void
      {
         GiftController.Instance.removeEventListener(GiftEvent.LOAD_RECORD_COMPLETE,this.__setRecordList);
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         if(this._playerInfo == value)
         {
            return;
         }
         this._playerInfo = value;
         if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            this._canClick = true;
         }
      }
      
      private function __setRecordList(event:GiftEvent) : void
      {
         if(event.str == GiftController.RECEIVEDPATH)
         {
            this.setList(GiftController.Instance.recordInfo);
         }
      }
      
      private function setList(info:RecordInfo) : void
      {
         this.clear();
         this._itemArr = new Vector.<RecordItem>();
         this.setReceived(info);
      }
      
      private function setReceived(info:RecordInfo) : void
      {
         var len:int = 0;
         var i:int = 0;
         var item:RecordItem = null;
         if(Boolean(info))
         {
            len = int(info.recordList.length);
            if(len != 0)
            {
               for(i = 0; i < len; i++)
               {
                  item = new RecordItem();
                  item.setup(this._playerInfo);
                  if(info.recordList[i].Receive == 1)
                  {
                     item.setItemInfoType(info.recordList[i],RecordItem.RECEIVED);
                  }
                  if(info.recordList[i].Receive == 0)
                  {
                     item.setItemInfoType(info.recordList[i],RecordItem.SENDED);
                  }
                  this._container.addChild(item);
                  this._itemArr.push(item);
               }
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function clear() : void
      {
         if(Boolean(this._noGift))
         {
            ObjectUtils.disposeObject(this._noGift);
         }
         this._noGift = null;
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            if(Boolean(this._itemArr[i]))
            {
               this._itemArr[i].dispose();
            }
            this._itemArr[i] = null;
         }
         this._itemArr = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

