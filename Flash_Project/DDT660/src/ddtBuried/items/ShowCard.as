package ddtBuried.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ShowCard extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _list:Vector.<BagCell>;
      
      public function ShowCard()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._list = new Vector.<BagCell>();
         this._mc = ComponentFactory.Instance.creat("buried.card.show");
         addChild(this._mc);
         this._mc.addFrameScript(69,this.cradOver);
         this._mc.addFrameScript(10,this.intCardShow);
      }
      
      private function intCardShow() : void
      {
         var i:int = 0;
         var obj:Object = null;
         var info:ItemTemplateInfo = null;
         var cell:BagCell = null;
         var len:int = int(BuriedManager.Instance.cardInitList.length);
         for(i = 0; i < len; i++)
         {
            obj = new Object();
            obj.tempID = BuriedManager.Instance.cardInitList[i].tempID;
            obj.count = BuriedManager.Instance.cardInitList[i].count;
            info = ItemManager.Instance.getTemplateById(obj.tempID);
            cell = new BagCell(0,info);
            cell.x = 39;
            cell.y = 107;
            cell.setBgVisible(false);
            cell.setCount(obj.count);
            this._mc["card" + (i + 1)].addChild(cell);
            this._list.push(cell);
            this._mc["card" + (i + 1)].goodsName.text = info.Name;
         }
      }
      
      private function clearCell() : void
      {
         for(var i:int = 0; i < this._list.length; i++)
         {
            this._list[i].dispose();
            ObjectUtils.disposeObject(this._list[i]);
            this._list[i] = null;
            while(Boolean(this._mc["card" + (i + 1)].numChildren))
            {
               ObjectUtils.disposeObject(this._mc["card" + (i + 1)].getChildAt(0));
            }
         }
      }
      
      public function play() : void
      {
         this._mc.play();
      }
      
      public function resetFrame() : void
      {
         this._mc.gotoAndStop(1);
      }
      
      private function cradOver() : void
      {
         this._mc.stop();
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.CARD_SHOW_OVER));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._list))
         {
            this.clearCell();
         }
         if(Boolean(this._mc))
         {
            this._mc.stop();
            while(Boolean(this._mc.numChildren))
            {
               ObjectUtils.disposeObject(this._mc.getChildAt(0));
            }
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._mc = null;
         this._list = null;
      }
   }
}

