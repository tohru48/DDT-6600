package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ClubRecordList extends Sprite implements Disposeable
   {
      
      public static const INVITE:int = 1;
      
      public static const APPLY:int = 2;
      
      private var _items:Vector.<ClubRecordItem>;
      
      private var _panel:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _data:*;
      
      public function ClubRecordList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("club.recordList.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("club.recordList.panel");
         this._panel.setView(this._vbox);
         addChild(this._panel);
      }
      
      public function setData(data:Object, type:int) : void
      {
         var i:int = 0;
         var item:ClubRecordItem = null;
         if(this._data == data)
         {
            return;
         }
         this.clearItem();
         this._items = new Vector.<ClubRecordItem>();
         if(Boolean(data) && data.length > 0)
         {
            for(i = 0; i < data.length; i++)
            {
               item = new ClubRecordItem(type);
               item.info = data[i];
               this._items.push(item);
               this._vbox.addChild(item);
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function clearItem() : void
      {
         var len:int = 0;
         var i:int = 0;
         if(Boolean(this._items) && this._items.length > 0)
         {
            len = int(this._items.length);
            for(i = 0; i < len; i++)
            {
               this._items[i].dispose();
               this._items[i] = null;
            }
         }
         this._items = null;
      }
      
      public function dispose() : void
      {
         this.clearItem();
         ObjectUtils.disposeAllChildren(this);
         this._vbox = null;
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

