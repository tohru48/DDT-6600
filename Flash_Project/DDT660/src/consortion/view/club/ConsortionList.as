package consortion.view.club
{
   import com.pickgliss.ui.controls.container.VBox;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaApplyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionList extends VBox
   {
      
      private var _currentItem:ConsortionListItem;
      
      private var items:Vector.<ConsortionListItem>;
      
      private var _selfApplyList:Vector.<ConsortiaApplyInfo>;
      
      public function ConsortionList()
      {
         super();
         _spacing = 3;
         this.__applyListChange(null);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__applyListChange);
      }
      
      private function __applyListChange(event:ConsortionEvent) : void
      {
         this._selfApplyList = ConsortionModelControl.Instance.model.myApplyList;
      }
      
      override protected function init() : void
      {
         var i:int = 0;
         super.init();
         this.items = new Vector.<ConsortionListItem>(6);
         for(i = 0; i < 6; i++)
         {
            this.items[i] = new ConsortionListItem(i);
            this.items[i].buttonMode = true;
            addChild(this.items[i]);
            this.items[i].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[i].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[i].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         for(var i:int = 0; i < 6; i++)
         {
            if(this.items[i] == event.currentTarget as ConsortionListItem)
            {
               this.items[i].selected = true;
               this._currentItem = this.items[i];
            }
            else
            {
               this.items[i].selected = false;
            }
         }
         dispatchEvent(new ConsortionEvent(ConsortionEvent.CLUB_ITEM_SELECTED));
      }
      
      public function get currentItem() : ConsortionListItem
      {
         return this._currentItem;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         (event.currentTarget as ConsortionListItem).light = true;
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         (event.currentTarget as ConsortionListItem).light = false;
      }
      
      public function setListData(data:Vector.<ConsortiaInfo>) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(data != null)
         {
            len = int(data.length);
            for(i = 0; i < 6; i++)
            {
               if(i < len)
               {
                  this.items[i].info = data[i];
                  this.items[i].visible = true;
                  this.items[i].isApply = false;
               }
               else
               {
                  this.items[i].visible = false;
               }
            }
            this.setStatus();
            if(Boolean(this._currentItem))
            {
               this._currentItem.selected = false;
            }
         }
      }
      
      private function setStatus() : void
      {
         var i:int = 0;
         var len:int = 0;
         var j:int = 0;
         if(this._selfApplyList != null)
         {
            for(i = 0; i < 6; i++)
            {
               len = int(this._selfApplyList.length);
               if(this.items[i].visible)
               {
                  for(j = 0; j < len; j++)
                  {
                     if(this.items[i].info.ConsortiaID == this._selfApplyList[j].ConsortiaID)
                     {
                        this.items[i].isApply = true;
                     }
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__applyListChange);
         for(var i:int = 0; i < 6; i++)
         {
            this.items[i].dispose();
            this.items[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            this.items[i].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this.items[i].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            this.items[i] = null;
         }
         this._currentItem = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

