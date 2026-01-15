package wonderfulActivity.views
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.view.ICalendar;
   import carnivalActivity.view.CarnivalActivityView;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.views.ConsumeRankView;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.items.AccumulativePayView;
   import wonderfulActivity.items.FighterRutrunView;
   import wonderfulActivity.items.HeroView;
   import wonderfulActivity.items.JoinIsPowerView;
   import wonderfulActivity.items.LimitActivityView;
   import wonderfulActivity.items.NewGameBenifitView;
   import wonderfulActivity.items.RechargeReturnView;
   import wonderfulActivity.items.StrengthDarenView;
   import wonderfulActivity.newActivity.AnnouncementAct.AnnouncementActView;
   import wonderfulActivity.newActivity.ExchangeAct.ExchangeActView;
   import wonderfulActivity.newActivity.GetRewardAct.GetRewardActView;
   import wonderfulActivity.newActivity.returnActivity.ReturnActivityView;
   
   public class WonderfulRightView extends Sprite implements Disposeable
   {
      
      private var _view:IRightView;
      
      private var _tittle:Bitmap;
      
      private var _currentInfo:ActiveEventsInfo;
      
      private var _currentLimitView:ICalendar;
      
      public function WonderfulRightView()
      {
         super();
      }
      
      public function setState(type:int, id:int) : void
      {
         if(!this._view)
         {
            return;
         }
         this._view.setState(type,id);
      }
      
      public function updateView(id:String) : void
      {
         var data:ActivityTypeData = null;
         this.dispose();
         var leftViewInfoDic:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         var type:int = int(leftViewInfoDic[id].viewType);
         switch(type)
         {
            case ActivityType.CHONGZHIHUIKUI:
               data = WonderfulActivityManager.Instance.activityRechargeList[0];
               this._view = new RechargeReturnView(1,data);
               break;
            case ActivityType.XIAOFEIHUIKUI:
               data = WonderfulActivityManager.Instance.activityExpList[0];
               this._view = new RechargeReturnView(2,data);
               break;
            case ActivityType.ZHANYOUCHONGZHIHUIKUI:
               data = WonderfulActivityManager.Instance.activityFighterList[0];
               this._view = new FighterRutrunView(data);
               break;
            case ActivityType.HERO:
               this._view = new HeroView();
               break;
            case ActivityType.NEWGAMEBENIFIT:
               this._view = new NewGameBenifitView();
               break;
            case ActivityType.ACCUMULATIVE_PAY:
               this._view = new AccumulativePayView();
               break;
            case ActivityType.STRENGTHEN_DAREN:
               this._view = new StrengthDarenView();
               break;
            case ActivityType.TUANJIE_POWER:
               this._view = new JoinIsPowerView();
               break;
            case ActivityType.ONE_OFF_PAY:
               break;
            case ActivityType.PAY_RETURN:
               this._view = new ReturnActivityView(0,id);
               break;
            case ActivityType.CONSUME_RETURN:
               this._view = new ReturnActivityView(1,id);
               break;
            case ActivityType.NORMAL_EXCHANGE:
               this._view = new ExchangeActView(id);
               break;
            case ActivityType.ACT_ANNOUNCEMENT:
               this._view = new AnnouncementActView(id);
               break;
            case ActivityType.RECEIVE_ACTIVITY:
               this._view = new GetRewardActView(id);
               break;
            case ActivityType.CONSUME_RANK:
               this._view = new ConsumeRankView();
               break;
            case ActivityType.MOUNT_MASTER_LEVEL:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.MOUNT_MASTER,WonderfulActivityTypeData.MOUNT_LEVEL);
               break;
            case ActivityType.MOUNT_MASTER_SKILL:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.MOUNT_MASTER,WonderfulActivityTypeData.MOUNT_SKILL);
               break;
            case ActivityType.CARNIVAL_MOUNT_MASTER:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_MOUNT_LEVEL);
               break;
            case ActivityType.CARNIVAL_GRADE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_GRADE);
               break;
            case ActivityType.CARNIVAL_STRENGTH:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_STRENGTH);
               break;
            case ActivityType.CARNIVAL_FUSION:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_FUSION);
               break;
            case ActivityType.CARNIVAL_ROOKIE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_ROOKIE);
               break;
            case ActivityType.CARNIVAL_BEAD:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_BEAD);
               break;
            case ActivityType.CARNIVAL_TOTEM:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_TOTEM);
               break;
            case ActivityType.CARNIVAL_PRACTICE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_PRACTICE);
               break;
            case ActivityType.CARNIVAL_CARD:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_CARD);
               break;
            case ActivityType.CARNIVAL_ZHANHUN:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_ZHANHUN);
               break;
            case ActivityType.CARNIVAL_PET:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_PET);
               break;
            case ActivityType.WHOLEPEOPLE_VIP:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.WHOLEPEOPLE_VIP);
               break;
            case ActivityType.WHOLEPEOPLE_PET:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.WHOLEPEOPLE_PET);
               break;
            case ActivityType.DAILY_GIFT:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.DAILY_GIFT);
               break;
            default:
               if(Boolean(this._view))
               {
                  this._view.dispose();
                  this._view = null;
               }
         }
         if(type >= ActivityType.LIMIT_FLOOR && type <= ActivityType.LIMIT_CEILING)
         {
            this._view = new LimitActivityView(type);
         }
         if(Boolean(this._view))
         {
            this._view.init();
            addChild(this._view.content());
            WonderfulActivityManager.Instance.currentView = this._view;
         }
         if(Boolean(WonderfulActivityManager.Instance.currentView as ExchangeActView))
         {
            PositionUtils.setPos(this,"limitActivity.wonderfulRightViewPos2");
         }
         else
         {
            PositionUtils.setPos(this,"limitActivity.wonderfulRightViewPos");
         }
         if(Boolean(WonderfulActivityManager.Instance.currentView as LimitActivityView))
         {
            PositionUtils.setPos(this,"limitActivity.wonderfulRightViewPos2");
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this._currentLimitView);
         this._view = null;
         this._currentLimitView = null;
      }
   }
}

