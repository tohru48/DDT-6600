package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.events.MouseEvent;
   
   public class QuestinfoTargetItemView extends QuestInfoItemView
   {
      
      private var _targets:VBox;
      
      private var _isOptional:Boolean;
      
      private var _starLevel:QuestStarListView;
      
      private var _completeButton:TextButton;
      
      private var _spand:int;
      
      private var _sLevel:int;
      
      public var isImprove:Boolean;
      
      private var _vipBg:Image;
      
      private var _vipIcon:Image;
      
      private var _vipDescTxt:FilterFrameText;
      
      public function QuestinfoTargetItemView(isOptional:Boolean)
      {
         this._isOptional = isOptional;
         super();
      }
      
      public function set sLevel(value:int) : void
      {
         if(value < 1)
         {
            value = 1;
         }
         this._sLevel = value;
         this._starLevel.level(this._sLevel,this.isImprove);
      }
      
      override public function set info(value:QuestInfo) : void
      {
         var cond:QuestCondition = null;
         var condView:QuestConditionView = null;
         _info = value;
         for(var i:int = 0; Boolean(_info._conditions[i]); i++)
         {
            cond = _info._conditions[i];
            if(cond.isOpitional == this._isOptional)
            {
               condView = new QuestConditionView(cond);
               condView.status = _info.conditionStatus[i];
               if(_info.progress[i] <= 0)
               {
                  condView.isComplete = true;
               }
               this._targets.addChild(condView);
            }
         }
         if(_info.QuestID == TaskManager.COLLECT_INFO_EMAIL)
         {
            this._targets.addChild(new InfoCollectViewMail());
         }
         else if(_info.QuestID == TaskManager.COLLECT_INFO_CELLPHONE || _info.QuestID == TaskManager.COLLECT_INFO_CELLPHONEII)
         {
            this._targets.addChild(new InfoCollectView(_info.QuestID));
         }
         this._spand = _info.OneKeyFinishNeedMoney;
         this.sLevel = _info.QuestLevel;
         var vOnkeyRemainTimes:int = TaskManager.instance.improve.canOneKeyFinishTime + int(ServerConfigManager.instance.VIPQuestFinishDirect[PlayerManager.Instance.Self.VIPLevel - 1]) - PlayerManager.Instance.Self.uesedFinishTime;
         if(this._spand > 0)
         {
            if(PathManager.onekeyDoneSwitch)
            {
               this._completeButton = ComponentFactory.Instance.creatComponentByStylename("quest.complete.button");
               this._completeButton.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.complete");
               this._completeButton.tipStyle = null;
               if(this.isInLimitTimes() < 10000)
               {
                  this._completeButton.tipData = LanguageMgr.GetTranslation("tank.manager.TaskManager.complete.remained",this.isInLimitTimes());
                  this._completeButton.tipStyle = "ddt.view.tips.OneLineTip";
               }
               addChild(this._completeButton);
               if(_info.isCompleted)
               {
                  this._completeButton.enable = false;
               }
               else
               {
                  this._completeButton.addEventListener(MouseEvent.CLICK,this._activeGetBtnClick);
               }
            }
         }
         _panel.invalidateViewport();
      }
      
      override protected function initView() : void
      {
         super.initView();
         _titleBg.visible = false;
         _titleImg = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.titleImg");
         _titleImg.setFrame(this._isOptional ? 1 : 2);
         addChild(_titleImg);
         this._targets = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.vbox");
         _content.addChild(this._targets);
         this._starLevel = ComponentFactory.Instance.creatCustomObject("quest.complete.starLevel");
         this._starLevel.tipData = LanguageMgr.GetTranslation("tank.manager.TaskManager.viptip");
         addChild(this._starLevel);
         this._vipBg = ComponentFactory.Instance.creatComponentByStylename("quest.vipBg");
         this._vipBg.width = 130;
         this._vipIcon = ComponentFactory.Instance.creatComponentByStylename("quest.vipIcon");
         this._vipDescTxt = ComponentFactory.Instance.creatComponentByStylename("quest.vipDescTxt");
         this._vipDescTxt.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.VipDescTxt");
         addChild(this._vipBg);
         addChild(this._vipIcon);
         addChild(this._vipDescTxt);
      }
      
      private function isInLimitTimes() : int
      {
         var totalOnKeyCompleteTimes:int = TaskManager.instance.improve.canOneKeyFinishTime;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            totalOnKeyCompleteTimes += int(ServerConfigManager.instance.VIPQuestFinishDirect[PlayerManager.Instance.Self.VIPLevel - 1]);
         }
         return totalOnKeyCompleteTimes - PlayerManager.Instance.Self.uesedFinishTime;
      }
      
      private function _activeGetBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._spand > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this.isInLimitTimes() <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.TaskManager.oneKeyCompleteTimesOver"));
            return;
         }
         var mes:String = LanguageMgr.GetTranslation("tank.manager.TaskManager.completeText",this._spand);
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),mes,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1);
         alert.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         ObjectUtils.disposeObject(frame);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.sendQuestOneToFinish(_info.QuestID);
         }
      }
      
      public function setStarVipHide() : void
      {
         this._starLevel.visible = false;
         this._vipBg.visible = false;
         this._vipIcon.visible = false;
         this._vipDescTxt.visible = false;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._completeButton))
         {
            this._completeButton.removeEventListener(MouseEvent.CLICK,this._activeGetBtnClick);
            ObjectUtils.disposeObject(this._completeButton);
            this._completeButton = null;
         }
         ObjectUtils.disposeObject(this._vipBg);
         this._vipBg = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._vipDescTxt);
         this._vipDescTxt = null;
         ObjectUtils.disposeObject(this._targets);
         this._targets = null;
         if(Boolean(this._starLevel))
         {
            ObjectUtils.disposeObject(this._starLevel);
         }
         this._starLevel = null;
         super.dispose();
      }
   }
}

