package cardSystem.view.cardCollect
{
   import cardSystem.CardControl;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CollectBagView extends Sprite implements Disposeable
   {
      
      public static const SELECT:String = "selected";
      
      private var _container:VBox;
      
      private var _collectItemVector:Vector.<CollectBagItem>;
      
      private var _turnPage:CollectTurnPage;
      
      private var _currentCollectItem:CollectBagItem;
      
      public function CollectBagView()
      {
         super();
         this.initView();
      }
      
      public function get currentItemSetsInfo() : SetsInfo
      {
         return this._currentCollectItem.setsInfo;
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("CollectBagView.container");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("CollectTurnPage");
         addChild(this._container);
         addChild(this._turnPage);
         this._collectItemVector = new Vector.<CollectBagItem>(3);
         for(var i:int = 0; i < 3; i++)
         {
            this._collectItemVector[i] = new CollectBagItem();
            this._container.addChild(this._collectItemVector[i]);
         }
         this._turnPage.addEventListener(Event.CHANGE,this.__turnPage);
         this._turnPage.maxPage = Math.ceil(CardControl.Instance.model.setsSortRuleVector.length / 3);
         this._turnPage.page = 1;
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:CollectBagItem = event.currentTarget as CollectBagItem;
         this.seleted(item);
      }
      
      private function seleted(item:CollectBagItem) : void
      {
         this._currentCollectItem = item;
         this._currentCollectItem.seleted = true;
         for(var i:int = 0; i < 3; i++)
         {
            if(this._collectItemVector[i] != this._currentCollectItem)
            {
               this._collectItemVector[i].seleted = false;
            }
         }
         dispatchEvent(new Event(SELECT));
      }
      
      private function setPage(page:int) : void
      {
         var setsArr:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var len:int = int(setsArr.length);
         for(var i:int = 0; i < 3; i++)
         {
            if((page - 1) * 3 + i < len)
            {
               this._collectItemVector[i].setsInfo = setsArr[(page - 1) * 3 + i];
               this._collectItemVector[i].setSetsDate(CardControl.Instance.model.getSetsCardFromCardBag(setsArr[(page - 1) * 3 + i].ID));
               this._collectItemVector[i].addEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[i].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[i].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
            else
            {
               this._collectItemVector[i].setsInfo = null;
               this._collectItemVector[i].mouseEnabled = false;
               this._collectItemVector[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[i].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[i].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
         }
         this.seleted(this._collectItemVector[0]);
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         (event.currentTarget as CollectBagItem).filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         (event.currentTarget as CollectBagItem).filters = null;
      }
      
      private function removeEvent() : void
      {
         this._turnPage.removeEventListener(Event.CHANGE,this.__turnPage);
      }
      
      protected function __turnPage(event:Event) : void
      {
         this.setPage(this._turnPage.page);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         for(var i:int = 0; i < 3; i++)
         {
            if(Boolean(this._collectItemVector[i]))
            {
               this._collectItemVector[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[i].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[i].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
               this._collectItemVector[i].dispose();
            }
            this._collectItemVector[i] = null;
         }
         this._currentCollectItem = null;
         if(Boolean(this._turnPage))
         {
            this._turnPage.dispose();
         }
         this._turnPage = null;
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

