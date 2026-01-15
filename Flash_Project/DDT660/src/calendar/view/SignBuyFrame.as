package calendar.view
{
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   
   public class SignBuyFrame extends BaseAlerFrame
   {
      
      private var _txt:FilterFrameText;
      
      private var _date:Date;
      
      private var _dayCell:DayCell;
      
      public function SignBuyFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.dayCell.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = alerInfo;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("dayCell.alert.txt");
         this._txt.text = LanguageMgr.GetTranslation("dayCell.alert.text",CalendarManager.getInstance().price,5 - CalendarManager.getInstance().times);
         addToContent(this._txt);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function responseHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < CalendarManager.getInstance().price)
            {
               LeavePageManager.showFillFrame();
               this.dispose();
               return;
            }
            SocketManager.Instance.out.sendDaySign(this._date);
            if(CalendarManager.getInstance().signNew(this._date))
            {
               this._dayCell.signMovie();
            }
            this.dispose();
         }
         else if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.dispose();
         }
      }
      
      public function set date(date:Date) : void
      {
         this._date = date;
      }
      
      public function set dayCellClass(cell:DayCell) : void
      {
         this._dayCell = cell;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

