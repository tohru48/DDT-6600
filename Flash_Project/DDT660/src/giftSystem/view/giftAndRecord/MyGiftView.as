package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import giftSystem.data.MyGiftCellInfo;
   import giftSystem.element.MyGiftItem;
   
   public class MyGiftView extends Sprite implements Disposeable
   {
      
      private var _myGiftItemContainerAll:VBox;
      
      private var _myGiftItemContainers:Vector.<HBox>;
      
      private var _panel:ScrollPanel;
      
      private var _count:int = 0;
      
      private var _line:int = 0;
      
      private var _itemArr:Vector.<MyGiftItem>;
      
      public function MyGiftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._myGiftItemContainers = new Vector.<HBox>();
         this._itemArr = new Vector.<MyGiftItem>();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemPanel");
         this._myGiftItemContainerAll = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemContainerAll");
         this._panel.setView(this._myGiftItemContainerAll);
         addChild(this._panel);
      }
      
      public function setList(list:Vector.<MyGiftCellInfo>) : void
      {
         this.clearList();
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            this.addItem(list[i]);
         }
      }
      
      public function addItem(info:MyGiftCellInfo) : void
      {
         if(this._count % 3 == 0)
         {
            this._line = this._count / 3;
            this._myGiftItemContainers[this._line] = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemContainer");
            this._myGiftItemContainerAll.addChild(this._myGiftItemContainers[this._line]);
         }
         var myGiftItem:MyGiftItem = new MyGiftItem();
         myGiftItem.info = info;
         this._myGiftItemContainers[this._line].addChild(myGiftItem);
         this._itemArr.push(myGiftItem);
         ++this._count;
         this._myGiftItemContainerAll.height = myGiftItem.height * (this._line + 1);
         this._panel.invalidateViewport();
      }
      
      public function upItem(info:MyGiftCellInfo) : void
      {
         var len:int = int(this._itemArr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this._itemArr[i].info.TemplateID == info.TemplateID)
            {
               this._itemArr[i].info = info;
               break;
            }
         }
      }
      
      private function clearList() : void
      {
         ObjectUtils.disposeAllChildren(this._myGiftItemContainerAll);
         for(var i:int = 0; i < this._line + 1; i++)
         {
            this._myGiftItemContainers[i] = null;
         }
         this._myGiftItemContainers = new Vector.<HBox>();
         this._itemArr = null;
         this._itemArr = new Vector.<MyGiftItem>();
         this._count = 0;
         this._line = 0;
         this._panel.invalidateViewport();
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         for(var i:int = 0; i < this._line + 1; i++)
         {
            this._myGiftItemContainers[i] = null;
         }
         this._myGiftItemContainerAll = null;
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

