package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import effortView.leftView.EffortCategoryTitleItem;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   
   public class EffortFullView extends Sprite implements Disposeable
   {
      
      public static const FULL_SIZE:Array = [500,28];
      
      public static const COMMON_SIZE:Array = [240,28];
      
      public static const X_OFFSET:int = 20;
      
      public static const Y_OFFSET:int = 30;
      
      private var _recentlyList:VBox;
      
      private var _listArray:Array;
      
      private var _recentlyInfoArray:Array;
      
      private var _scheduleArray:Array;
      
      private var _fullScaleStrip:EffortScaleStrip;
      
      private var _integrationScaleStrip:EffortScaleStrip;
      
      private var _taskScaleStrip:EffortScaleStrip;
      
      private var _roleScaleStrip:EffortScaleStrip;
      
      private var _duplicateScaleStrip:EffortScaleStrip;
      
      private var _combatScaleStrip:EffortScaleStrip;
      
      private var _honorScaleStrip:EffortScaleStrip;
      
      private var fullArray:Array;
      
      private var integrationArray:Array;
      
      private var roleArray:Array;
      
      private var taskArray:Array;
      
      private var duplicateArray:Array;
      
      private var combatArray:Array;
      
      private var honorArray:Array;
      
      private var _controller:EffortController;
      
      private var _itemBg:MutipleImage;
      
      private var _scaleStripBg:MutipleImage;
      
      private var _scaleStripBg1:Bitmap;
      
      private var _titleText_01:Bitmap;
      
      private var _titleText_02:Bitmap;
      
      public function EffortFullView(controller:EffortController)
      {
         this._controller = controller;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortFullView.EffortFullViewBG");
         addChild(this._itemBg);
         this._scaleStripBg = ComponentFactory.Instance.creat("effortView.EffortFullView.EffortFullViewBGII");
         addChild(this._scaleStripBg);
         this._scaleStripBg1 = ComponentFactory.Instance.creatBitmap("asset.ddtEffort.jingduBg");
         addChild(this._scaleStripBg1);
         this._titleText_01 = ComponentFactory.Instance.creat("asset.Effort.title_01");
         addChild(this._titleText_01);
         this._titleText_02 = ComponentFactory.Instance.creat("asset.Effort.title_02");
         addChild(this._titleText_02);
         this.updateItem();
         this.updateScheduleArray();
         this._fullScaleStrip = new EffortScaleStrip(this.fullArray.length,EffortCategoryTitleItem.FULL,FULL_SIZE[0],FULL_SIZE[1]);
         this._fullScaleStrip.setButtonMode(false);
         var pos:Point = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.ScaleStripPos");
         this._fullScaleStrip.x = pos.x;
         this._fullScaleStrip.y = pos.y;
         addChild(this._fullScaleStrip);
         this._roleScaleStrip = new EffortScaleStrip(this.roleArray.length,EffortCategoryTitleItem.PART,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._roleScaleStrip.x = this._fullScaleStrip.x;
         this._roleScaleStrip.y = this._fullScaleStrip.y + Y_OFFSET;
         this._roleScaleStrip.setButtonMode(true);
         addChild(this._roleScaleStrip);
         this._taskScaleStrip = new EffortScaleStrip(this.taskArray.length,EffortCategoryTitleItem.TASK,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._taskScaleStrip.x = this._roleScaleStrip.x + this._roleScaleStrip.width + X_OFFSET;
         this._taskScaleStrip.y = this._roleScaleStrip.y;
         this._taskScaleStrip.setButtonMode(true);
         addChild(this._taskScaleStrip);
         this._duplicateScaleStrip = new EffortScaleStrip(this.duplicateArray.length,EffortCategoryTitleItem.DUNGEON,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._duplicateScaleStrip.x = this._roleScaleStrip.x;
         this._duplicateScaleStrip.y = this._roleScaleStrip.y + Y_OFFSET;
         this._duplicateScaleStrip.setButtonMode(true);
         addChild(this._duplicateScaleStrip);
         this._combatScaleStrip = new EffortScaleStrip(this.combatArray.length,EffortCategoryTitleItem.FIGHT,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._combatScaleStrip.x = this._duplicateScaleStrip.x + this._duplicateScaleStrip.width + X_OFFSET;
         this._combatScaleStrip.y = this._duplicateScaleStrip.y;
         this._combatScaleStrip.setButtonMode(true);
         addChild(this._combatScaleStrip);
         this._integrationScaleStrip = new EffortScaleStrip(this.integrationArray.length,EffortCategoryTitleItem.INTEGRATION,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._integrationScaleStrip.x = this._duplicateScaleStrip.x;
         this._integrationScaleStrip.y = this._duplicateScaleStrip.y + Y_OFFSET;
         this._integrationScaleStrip.setButtonMode(true);
         addChild(this._integrationScaleStrip);
         this._honorScaleStrip = new EffortScaleStrip(this.honorArray.length,EffortCategoryTitleItem.HONOR,COMMON_SIZE[0],COMMON_SIZE[1]);
         this._honorScaleStrip.x = this._integrationScaleStrip.x + this._integrationScaleStrip.width + X_OFFSET;
         this._honorScaleStrip.y = this._integrationScaleStrip.y;
         this._honorScaleStrip.setButtonMode(true);
         addChild(this._honorScaleStrip);
         this.updateScaleStrip();
      }
      
      private function initEvent() : void
      {
         this._integrationScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._roleScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._taskScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._duplicateScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._combatScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._honorScaleStrip.addEventListener(MouseEvent.CLICK,this.__scaleStripClick);
      }
      
      private function updateScheduleArray() : void
      {
         var i:EffortInfo = null;
         var dic:DictionaryData = EffortManager.Instance.fullList;
         this.fullArray = [];
         this.integrationArray = [];
         this.roleArray = [];
         this.taskArray = [];
         this.duplicateArray = [];
         this.combatArray = [];
         this.honorArray = [];
         this.honorArray = EffortManager.Instance.getHonorEfforts();
         for each(i in dic)
         {
            this.fullArray.push(i);
            switch(i.PlaceID)
            {
               case 0:
                  this.integrationArray.push(i);
                  break;
               case 1:
                  this.roleArray.push(i);
                  break;
               case 2:
                  this.taskArray.push(i);
                  break;
               case 3:
                  this.duplicateArray.push(i);
                  break;
               case 4:
                  this.combatArray.push(i);
                  break;
            }
         }
      }
      
      private function __scaleStripClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.currentTarget)
         {
            case this._roleScaleStrip:
               this._controller.currentRightViewType = 1;
               break;
            case this._taskScaleStrip:
               this._controller.currentRightViewType = 2;
               break;
            case this._duplicateScaleStrip:
               this._controller.currentRightViewType = 3;
               break;
            case this._combatScaleStrip:
               this._controller.currentRightViewType = 4;
               break;
            case this._integrationScaleStrip:
               this._controller.currentRightViewType = 5;
               break;
            case this._honorScaleStrip:
               this._controller.currentRightViewType = 6;
         }
      }
      
      private function getCurrentSchedule(arr:Array) : int
      {
         var i:int = 0;
         var j:int = 0;
         var value:int = 0;
         if(EffortManager.Instance.isSelf)
         {
            for(i = 0; i < arr.length; i++)
            {
               if(Boolean((arr[i] as EffortInfo).CompleteStateInfo))
               {
                  value++;
               }
            }
         }
         else
         {
            for(j = 0; j < arr.length; j++)
            {
               if(EffortManager.Instance.tempEffortIsComplete((arr[j] as EffortInfo).ID))
               {
                  value++;
               }
            }
         }
         return value;
      }
      
      private function updateScaleStrip() : void
      {
         this._fullScaleStrip.currentVlaue = this.getCurrentSchedule(this.fullArray);
         this._integrationScaleStrip.currentVlaue = this.getCurrentSchedule(this.integrationArray);
         this._roleScaleStrip.currentVlaue = this.getCurrentSchedule(this.roleArray);
         this._taskScaleStrip.currentVlaue = this.getCurrentSchedule(this.taskArray);
         this._duplicateScaleStrip.currentVlaue = this.getCurrentSchedule(this.duplicateArray);
         this._combatScaleStrip.currentVlaue = this.getCurrentSchedule(this.combatArray);
         this._honorScaleStrip.currentVlaue = this.getCurrentSchedule(this.honorArray);
      }
      
      private function updateItem() : void
      {
         var item:EffortFullItemView = null;
         this.cleanList();
         this._recentlyList = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortFullView.ItemList");
         var pos:Point = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.ItemListPos");
         this._recentlyList.x = pos.x;
         this._recentlyList.y = pos.y;
         addChild(this._recentlyList);
         if(EffortManager.Instance.isSelf)
         {
            this._recentlyInfoArray = EffortManager.Instance.getNewlyCompleteEffort();
         }
         else
         {
            this._recentlyInfoArray = EffortManager.Instance.getTempNewlyCompleteEffort();
         }
         for(var i:int = 0; i < this._recentlyInfoArray.length; i++)
         {
            if(i < 3)
            {
               item = new EffortFullItemView(this._recentlyInfoArray[i]);
               this._listArray.push(this._recentlyList.addChild(item));
            }
         }
      }
      
      private function cleanList() : void
      {
         var i:int = 0;
         if(Boolean(this._listArray))
         {
            for(i = 0; i < this._listArray.length; i++)
            {
               this._listArray[i].dispose();
            }
         }
         ObjectUtils.disposeObject(this._recentlyList);
         this._recentlyList = null;
         this._listArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanList();
         this._integrationScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._roleScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._taskScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._duplicateScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._combatScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         this._honorScaleStrip.removeEventListener(MouseEvent.CLICK,this.__scaleStripClick);
         if(Boolean(this._fullScaleStrip))
         {
            this._fullScaleStrip.dispose();
            this._fullScaleStrip = null;
         }
         ObjectUtils.disposeObject(this._honorScaleStrip);
         this._honorScaleStrip = null;
         if(Boolean(this._integrationScaleStrip))
         {
            this._integrationScaleStrip.parent.removeChild(this._integrationScaleStrip);
            this._integrationScaleStrip.dispose();
            this._integrationScaleStrip = null;
         }
         if(Boolean(this._roleScaleStrip))
         {
            this._roleScaleStrip.parent.removeChild(this._roleScaleStrip);
            this._roleScaleStrip.dispose();
            this._roleScaleStrip = null;
         }
         if(Boolean(this._taskScaleStrip))
         {
            this._taskScaleStrip.parent.removeChild(this._taskScaleStrip);
            this._taskScaleStrip.dispose();
            this._taskScaleStrip = null;
         }
         if(Boolean(this._duplicateScaleStrip))
         {
            this._duplicateScaleStrip.parent.removeChild(this._duplicateScaleStrip);
            this._duplicateScaleStrip.dispose();
            this._duplicateScaleStrip = null;
         }
         if(Boolean(this._combatScaleStrip))
         {
            this._combatScaleStrip.parent.removeChild(this._combatScaleStrip);
            this._combatScaleStrip.dispose();
            this._combatScaleStrip = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.removeChild(this);
         }
      }
   }
}

