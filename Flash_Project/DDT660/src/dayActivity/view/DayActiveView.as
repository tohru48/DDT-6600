package dayActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayActiveData;
   import dayActivity.items.DayActivieListItem;
   import dayActivity.items.DayActivieTitle;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DayActiveView extends Sprite implements Disposeable
   {
      
      private var _title:DayActivieTitle;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _treeImage2:Scale9CornerImage;
      
      private var _itemList:Vector.<DayActivieListItem>;
      
      private var _bitMap:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _dataList:Vector.<DayActiveData>;
      
      private var _timer:Timer;
      
      private var _backGround:Bitmap;
      
      public function DayActiveView(dataList:Vector.<DayActiveData>)
      {
         super();
         this._dataList = dataList;
         this.initView();
      }
      
      private function initView() : void
      {
         var j:int = 0;
         var item:DayActivieListItem = null;
         var str:String = null;
         this._timer = new Timer(10000);
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         var len:int = int(this._dataList.length);
         this._itemList = new Vector.<DayActivieListItem>();
         this._backGround = ComponentFactory.Instance.creat("day.actiity.groundBack");
         this._backGround.x = 22;
         this._backGround.y = 82;
         addChild(this._backGround);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.luckpaihangBox");
         this._list.spacing = 1;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.scrollpanel");
         this._panel.x = 28;
         this._panel.y = 123;
         this._panel.width = 713;
         this._panel.height = 330;
         this._panel.setView(this._list);
         addChild(this._panel);
         for(var i:int = 0; i < len; i++)
         {
            item = new DayActivieListItem(i);
            item.setData(this._dataList[i]);
            item.seleLigthFun = this.seletLight;
            str = this._dataList[i].ActiveTime.slice(0,7);
            if(str == "全天")
            {
               item.initTxt(false);
            }
            else
            {
               item.initTxt(true);
            }
            item.y = (item.height + 1) * i;
            this._list.addChild(item);
            this._itemList.push(item);
         }
         this._txt = ComponentFactory.Instance.creatComponentByStylename("day.activieView.txt");
         addChild(this._txt);
         DayActivityManager.Instance.initActivityStata(this._itemList);
         this._itemList = this.updataList(this._itemList);
         for(j = 0; j < this._itemList.length; j++)
         {
            this._itemList[j].y = (this._itemList[j].height + 1) * j;
            this._itemList[j].setBg(j);
            this._list.addChild(this._itemList[j]);
         }
         this._txt.text = LanguageMgr.GetTranslation("ddt.dayActivity.leavlOver20") + this._itemList[0].data.LevelLimit;
         this.updata(DayActivityManager.Instance.sessionArr);
         this._itemList[0].setLigthVisible(true);
         this._panel.invalidateViewport();
      }
      
      private function seletLight(dailyItem:DayActivieListItem, lv:int) : void
      {
         var tmpItem:DayActivieListItem = null;
         for each(tmpItem in this._itemList)
         {
            if(tmpItem == dailyItem)
            {
               tmpItem.setLigthVisible(true);
            }
            else
            {
               tmpItem.setLigthVisible(false);
            }
         }
         this._txt.text = LanguageMgr.GetTranslation("ddt.dayActivity.leavlOver20") + lv;
      }
      
      private function updataList(_lists:Vector.<DayActivieListItem>) : Vector.<DayActivieListItem>
      {
         var len:int = int(_lists.length);
         var openList:Vector.<DayActivieListItem> = new Vector.<DayActivieListItem>();
         var closeList:Vector.<DayActivieListItem> = new Vector.<DayActivieListItem>();
         for(var i:int = 0; i < len; i++)
         {
            if(_lists[i].getTxt5str() == LanguageMgr.GetTranslation("ddt.dayActivity.close"))
            {
               closeList.push(_lists[i]);
            }
            else
            {
               openList.push(_lists[i]);
            }
         }
         for(var j:int = 0; j < closeList.length; j++)
         {
            openList.push(closeList[j]);
         }
         return openList;
      }
      
      public function updata(arr:Array) : void
      {
         var j:int = 0;
         if(arr == null)
         {
            return;
         }
         var len:int = int(arr.length);
         for(var i:int = 0; i < len; i++)
         {
            for(j = 0; j < this._itemList.length; j++)
            {
               if(Boolean(arr[i]))
               {
                  if(arr[i][0] == this._itemList[j].id)
                  {
                     this._itemList[j].updataCount(arr[i][1]);
                     break;
                  }
               }
            }
         }
      }
      
      protected function timerHander(event:TimerEvent) : void
      {
         DayActivityManager.Instance.initActivityStata(this._itemList);
         this.updata(DayActivityManager.Instance.sessionArr);
         this._itemList = this.updataList(this._itemList);
         for(var j:int = 0; j < this._itemList.length; j++)
         {
            this._itemList[j].y = (this._itemList[j].height + 1) * j;
            this._itemList[j].setBg(j);
            this._list.addChild(this._itemList[j]);
         }
      }
      
      public function upDataList() : void
      {
         this.clearList();
      }
      
      private function clearList() : void
      {
         while(Boolean(this._list) && Boolean(this._list.numChildren))
         {
            ObjectUtils.disposeObject(this._list.getChildAt(0));
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
         }
         this._timer = null;
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
         this._list = null;
         this._panel = null;
         this._itemList = null;
      }
   }
}

