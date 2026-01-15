package dayActivity.items
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.ActivityData;
   import dayActivity.data.DayActiveData;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   
   public class DayActivityLeftList extends Sprite implements Disposeable
   {
      
      private var _tilte:DayActivityLeftTitleItem;
      
      private var _num:int;
      
      private var _expriedNum:int;
      
      public function DayActivityLeftList(str:String, list:Vector.<ActivityData>, bool:Boolean)
      {
         super();
         this._num = list.length;
         this._expriedNum = 0;
         this.initView(str,list,bool);
      }
      
      private function initView(str:String, list:Vector.<ActivityData>, bool:Boolean) : void
      {
         var item:DayActivityLeftListItem = null;
         this._expriedNum = 0;
         this._tilte = new DayActivityLeftTitleItem(str,this._num);
         addChild(this._tilte);
         var acitiveDataList:Vector.<DayActiveData> = DayActivityManager.Instance.acitiveDataList;
         var today:int = TimeManager.Instance.serverDate.day;
         for(var i:int = 0; i < this._num; i++)
         {
            if(list[i].ActivityType == 6)
            {
               if(!this.compareDay(today,DayActivityManager.Instance.YUANGUJULONG_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            if(list[i].ActivityType == 18)
            {
               if(Boolean(DayActivityManager.Instance.ANYEBOJUE_DAYOFWEEK) && !this.compareDay(today,DayActivityManager.Instance.ANYEBOJUE_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            if(list[i].ActivityType == 19)
            {
               if(!this.compareDay(today,DayActivityManager.Instance.ZUQIUBOSS_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            item = new DayActivityLeftListItem(bool,list[i]);
            item.setTxt2(list[i].OverCount);
            if(list[i].JumpType > 0)
            {
               item.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.itemTips",list[i].ActivePoint,list[i].Description);
            }
            else
            {
               item.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.btnTip",list[i].ActivePoint);
            }
            item.x = 2;
            item.y = 30 + 25 * (i - this._expriedNum);
            addChild(item);
         }
      }
      
      private function compareDay(day:int, activeDays:String) : Boolean
      {
         var dayArr:Array = activeDays.split(",");
         if(dayArr.indexOf("" + day) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function setTxt(str:String) : void
      {
         this._tilte.setTxt(LanguageMgr.GetTranslation(str,this._num - this._expriedNum));
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

