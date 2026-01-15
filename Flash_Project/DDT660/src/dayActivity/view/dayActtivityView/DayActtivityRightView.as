package dayActivity.view.dayActtivityView
{
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.items.DayAcBar;
   import dayActivity.items.DayActivityRightViewItem;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import mainbutton.MainButtnController;
   
   public class DayActtivityRightView extends Sprite implements Disposeable
   {
      
      private var _back:MutipleImage;
      
      private var _todayABitMap:Bitmap;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _bar:DayAcBar;
      
      private var _rfl:Bitmap;
      
      private var _lfl:Bitmap;
      
      private var _dailyCollectionBtn:SimpleBitmapButton;
      
      private var _list:Vector.<DayActivityRightViewItem>;
      
      private var _activeList:Array = [30,60,80,100];
      
      public function DayActtivityRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var item:DayActivityRightViewItem = null;
         this._list = new Vector.<DayActivityRightViewItem>();
         this._back = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.right.SignedAwardBack");
         addChild(this._back);
         this._rfl = ComponentFactory.Instance.creat("day.activity.huawen");
         this._rfl.x = 9;
         this._rfl.y = 11;
         addChild(this._rfl);
         this._lfl = ComponentFactory.Instance.creat("day.activity.huawen");
         this._lfl.x = 382;
         this._lfl.y = 11;
         this._lfl.scaleX = -1;
         addChild(this._lfl);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.right.txt1");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityGoods");
         addChild(this._txt1);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.right.txt2");
         this._txt2.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityLimit");
         addChild(this._txt2);
         this._todayABitMap = ComponentFactory.Instance.creat("day.todayActivie");
         addChild(this._todayABitMap);
         if(PlayerManager.Instance.Self.Grade >= 5 && MainButtnController.instance.DailyAwardState)
         {
            this._dailyCollectionBtn = ComponentFactory.Instance.creatComponentByStylename("day.activity.dailyCollectionBtn");
            addChild(this._dailyCollectionBtn);
         }
         this._bar = new DayAcBar();
         this._bar.x = 60;
         this._bar.y = 75;
         addChild(this._bar);
         for(i = 0; i < 4; i++)
         {
            item = new DayActivityRightViewItem(this._activeList[i]);
            item.y = (item.height + 5) * i + 158;
            item.x = 13;
            item.id = i + 1;
            addChild(item);
            this._list.push(item);
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._dailyCollectionBtn))
         {
            this._dailyCollectionBtn.addEventListener(MouseEvent.CLICK,this.__onDailyCollection);
         }
      }
      
      protected function __onDailyCollection(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().reciveDayAward();
         this.deleteDailyBtn();
      }
      
      private function deleteDailyBtn() : void
      {
         if(Boolean(this._dailyCollectionBtn))
         {
            this._dailyCollectionBtn.removeEventListener(MouseEvent.CLICK,this.__onDailyCollection);
            this._dailyCollectionBtn.dispose();
            this._dailyCollectionBtn = null;
         }
      }
      
      public function updataBtn(id:int) : void
      {
         this._list[id - 1].showBtn(true);
      }
      
      public function setBarValue($num:int) : void
      {
         this._bar.initBar($num);
         var arr:Array = DayActivityManager.Instance.btnArr;
         if($num >= 30 && $num < 60)
         {
            this.setBtnState(1);
         }
         else if($num >= 60 && $num < 80)
         {
            this.setBtnState(2);
         }
         else if($num >= 80 && $num < 100)
         {
            this.setBtnState(3);
         }
         else if($num >= 100)
         {
            this.setBtnState(4);
         }
      }
      
      private function setBtnState(i:int) : void
      {
         for(var j:int = 0; j < i; j++)
         {
            if(DayActivityManager.Instance.btnArr[j][1] == 0)
            {
               this._list[j].showBtn(false);
            }
            else
            {
               this._list[j].showBtn(true);
            }
         }
      }
      
      public function dispose() : void
      {
         this.deleteDailyBtn();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._list = null;
      }
   }
}

