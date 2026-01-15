package cardSystem.view.cardBag
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CardBagView extends Sprite implements Disposeable
   {
      
      private var _sortBtn:BaseButton;
      
      private var _collectBtn:BaseButton;
      
      private var _BG:Bitmap;
      
      private var _title:Bitmap;
      
      private var _bagList:OutMainListPanel;
      
      public function CardBagView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.cardBag.BG");
         this._title = ComponentFactory.Instance.creatBitmap("asset.cardBag.word");
         this._sortBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.sortbtn");
         this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.collectBtn");
         this._bagList = ComponentFactory.Instance.creatComponentByStylename("cardSyste.cardBagList");
         addChild(this._BG);
         addChild(this._title);
         addChild(this._sortBtn);
         addChild(this._collectBtn);
         addChild(this._bagList);
         this._bagList.vectorListModel.appendAll(CardControl.Instance.model.getBagListData());
         DragManager.ListenWheelEvent(this._bagList.onMouseWheel);
         DragManager.changeCardState(CardControl.Instance.setSignLockedCardNone);
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._sortBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._sortBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __collectHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CardControl.Instance.showCollectView();
      }
      
      private function __upData(event:DictionaryEvent) : void
      {
         var itemDate:Array = null;
         var newArr:Array = null;
         var info:CardInfo = event.data as CardInfo;
         var m:int = info.Place % 4 == 0 ? int(info.Place / 4 - 2) : int(info.Place / 4 - 1);
         var n:int = info.Place % 4 == 0 ? 4 : int(info.Place % 4);
         if(this._bagList.vectorListModel.elements[m] == null)
         {
            itemDate = new Array();
            itemDate[0] = m + 1;
            itemDate[n] = info;
            this._bagList.vectorListModel.append(itemDate);
         }
         else
         {
            newArr = this._bagList.vectorListModel.elements[m] as Array;
            newArr[n] = info;
            this._bagList.vectorListModel.replaceAt(m,newArr);
         }
      }
      
      private function __remove(event:DictionaryEvent) : void
      {
         var info:CardInfo = event.data as CardInfo;
         var m:int = info.Place % 4 == 0 ? int(info.Place / 4 - 2) : int(info.Place / 4 - 1);
         var n:int = info.Place % 4 == 0 ? 4 : int(info.Place % 4);
         var newArr:Array = this._bagList.vectorListModel.elements[m] as Array;
         newArr[n] = null;
         this._bagList.vectorListModel.replaceAt(m,newArr);
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         var idVec:Vector.<int> = null;
         var j:int = 0;
         var data:DictionaryData = null;
         var info:CardInfo = null;
         SoundManager.instance.play("008");
         var sortData:Vector.<int> = new Vector.<int>();
         var sortArr:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for(var m:int = 0; m < sortArr.length; m++)
         {
            idVec = sortArr[m].cardIdVec;
            for(j = 0; j < idVec.length; j++)
            {
               data = PlayerManager.Instance.Self.cardBagDic;
               for each(info in data)
               {
                  if(info.TemplateID == idVec[j])
                  {
                     sortData.push(info.Place);
                     break;
                  }
               }
            }
         }
         SocketManager.Instance.out.sendSortCards(sortData);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         DragManager.removeListenWheelEvent();
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._sortBtn))
         {
            ObjectUtils.disposeObject(this._sortBtn);
         }
         this._sortBtn = null;
         if(Boolean(this._collectBtn))
         {
            ObjectUtils.disposeObject(this._collectBtn);
         }
         this._collectBtn = null;
         if(Boolean(this._bagList))
         {
            this._bagList.dispose();
         }
         this._bagList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

