package dayActivity.view.dayActtivityView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.ActivityData;
   import dayActivity.items.DayActivityLeftList;
   import flash.display.Sprite;
   
   public class DayActtivityLeftView extends Sprite implements Disposeable
   {
      
      private var _rightBack:MutipleImage;
      
      private var _resArray:Array = ["day.activity.noover","day.activity.over"];
      
      private var _wordArray:Array = ["ddt.dayActivity.activityNoOver","ddt.dayActivity.activityOver"];
      
      private var _boolArray:Array = [false,false];
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _itemList:Vector.<DayActivityLeftList>;
      
      public function DayActtivityLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemList = new Vector.<DayActivityLeftList>();
         this._rightBack = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.ActivityStateBg");
         addChild(this._rightBack);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.luckpaihangBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.scrollpanel");
         this._panel.y = 21;
         this._panel.setView(this._list);
         addChild(this._panel);
         this._panel.invalidateViewport();
      }
      
      public function initList(overList:Vector.<ActivityData>, noOverList:Vector.<ActivityData>) : void
      {
         var i:int = 0;
         var list:DayActivityLeftList = null;
         this.clearList();
         var arr:Array = [];
         arr.push(noOverList);
         arr.push(overList);
         for(i = 0; i < 2; i++)
         {
            list = new DayActivityLeftList(this._resArray[i],arr[i],this._boolArray[i]);
            list.y = (list.height + 4) * i + 36;
            list.setTxt(this._wordArray[i]);
            list.x = 18;
            this._list.addChild(list);
            this._itemList.push(list);
         }
         this._panel.invalidateViewport();
      }
      
      private function clearList() : void
      {
         if(!this._itemList)
         {
            return;
         }
         for(var i:int = 0; i < 2; i++)
         {
            if(this._itemList.length > 0)
            {
               while(Boolean(this._itemList[i].numChildren))
               {
                  ObjectUtils.disposeObject(this._itemList[i].getChildAt(0));
               }
               ObjectUtils.disposeObject(this._itemList[i]);
            }
         }
         this._itemList.splice(0,this._itemList.length);
      }
      
      public function dispose() : void
      {
         this.clearList();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._itemList = null;
         this._list = null;
         this._panel = null;
      }
   }
}

