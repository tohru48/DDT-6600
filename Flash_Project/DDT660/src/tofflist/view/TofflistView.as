package tofflist.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.display.Sprite;
   import tofflist.TofflistController;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistView extends Sprite implements Disposeable
   {
      
      private var _contro:TofflistController;
      
      private var _leftView:TofflistLeftView;
      
      private var _rightView:TofflistRightView;
      
      public function TofflistView($contro:TofflistController)
      {
         this._contro = $contro;
         super();
         this.init();
      }
      
      public function get rightView() : TofflistRightView
      {
         return this._rightView;
      }
      
      public function addEvent() : void
      {
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,this.__tofflistDataChange);
         TofflistModel.addEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.__crossServerTofflistDataChange);
      }
      
      public function dispose() : void
      {
         this._contro = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftView = null;
         this._rightView = null;
         MainToolBar.Instance.hide();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function removeEvent() : void
      {
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,this.__tofflistDataChange);
         TofflistModel.removeEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.__crossServerTofflistDataChange);
      }
      
      private function __crossServerTofflistDataChange(evt:TofflistEvent) : void
      {
         this._rightView.updateTime(evt.data.data.lastUpdateTime);
         switch(String(evt.data.flag))
         {
            case TofflistEvent.TOFFLIST_INDIVIDUAL_MOUNTS_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualMountsAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalue.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPoint.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalue.list);
         }
      }
      
      private function __tofflistDataChange(evt:TofflistEvent) : void
      {
         this._rightView.updateTime(evt.data.data.lastUpdateTime);
         switch(String(evt.data.flag))
         {
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
               this._rightView.orderList(TofflistModel.Instance.individualGradeDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.individualGradeWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.individualGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.individualExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.individualExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.individualExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalue.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_MATCHES_WEEK:
               this._rightView.orderList(TofflistModel.Instance.personalMatchesWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_MOUNTS_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.personalMountsAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.personalBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPoint.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalue.list);
         }
      }
      
      public function clearDisplayContent() : void
      {
         this._rightView.orderList(new Array());
         this._rightView.updateTime(null);
      }
      
      private function init() : void
      {
         this._leftView = new TofflistLeftView();
         addChild(this._leftView);
         this._rightView = new TofflistRightView(this._contro);
         PositionUtils.setPos(this._rightView,"tofflist.rightViewPos");
         addChild(this._rightView);
         MainToolBar.Instance.show();
      }
   }
}

