package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionSkillInfo;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaMyTaskView extends Sprite implements Disposeable
   {
      
      private var _taskInfo:ConsortiaTaskInfo;
      
      private var _vbox:VBox;
      
      private var _finishItemList:Vector.<ConsortiaMyTaskFinishItem>;
      
      private var _myFinishTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _offerTxt:FilterFrameText;
      
      private var _richesTxt:FilterFrameText;
      
      private var _skillNameTxt:FilterFrameText;
      
      private var _contentTxt1:FilterFrameText;
      
      private var _contentTxt2:FilterFrameText;
      
      private var _contentTxt3:FilterFrameText;
      
      private var _expText:FilterFrameText;
      
      private var _moneyText:FilterFrameText;
      
      private var _caiText:FilterFrameText;
      
      private var _skillText:FilterFrameText;
      
      private var _contributionLbl:FilterFrameText;
      
      private var _contributionTxt:FilterFrameText;
      
      private var _myReseBtn:TextButton;
      
      private var _delayTimeBtn:TextButton;
      
      public function ConsortiaMyTaskView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var right:int = 0;
         var item:ConsortiaMyTaskFinishItem = null;
         this._finishItemList = new Vector.<ConsortiaMyTaskFinishItem>();
         var bgI:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgI");
         var bgII:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgII");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.task.vboxI");
         this._myFinishTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MyfinishTxt");
         this._expText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.expTxt");
         this._expText.text = LanguageMgr.GetTranslation("consortion.task.exp");
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontIMoneyTxt");
         this._moneyText.text = LanguageMgr.GetTranslation("consortion.task.offer");
         this._caiText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontCaiTxt");
         this._caiText.text = LanguageMgr.GetTranslation("consortion.task.Money");
         this._skillText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontSkillTxt");
         this._skillText.text = LanguageMgr.GetTranslation("consortion.task.skillName");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.EXPTxt");
         this._offerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MoneyTxt");
         this._richesTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.caiTxt");
         this._skillNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.SkillTxt");
         this._contributionLbl = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contributionLbl");
         this._contributionLbl.text = LanguageMgr.GetTranslation("consortion.task.contribution");
         this._contributionTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contributionTxt");
         var font1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.conortionTask.FontContent");
         this._contentTxt1 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt1");
         this._contentTxt2 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt2");
         this._contentTxt3 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt3");
         for(var i:int = 0; i < 3; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("ConsortiaMyTaskFinishItem");
            this._finishItemList.push(item);
            this._vbox.addChild(item);
         }
         addChild(bgI);
         addChild(bgII);
         addChild(this._vbox);
         addChild(this._myFinishTxt);
         addChild(this._expText);
         addChild(this._moneyText);
         addChild(this._caiText);
         addChild(this._skillText);
         addChild(this._contributionLbl);
         addChild(this._expTxt);
         addChild(this._offerTxt);
         addChild(this._richesTxt);
         addChild(this._skillNameTxt);
         addChild(this._contributionTxt);
         this._myReseBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.reset1");
         this._myReseBtn.text = LanguageMgr.GetTranslation("consortia.task.resetTable");
         addChild(this._myReseBtn);
         this._delayTimeBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.task.delayTimeBtn");
         this._delayTimeBtn.text = LanguageMgr.GetTranslation("consortia.task.delayTime");
         addChild(this._delayTimeBtn);
         right = PlayerManager.Instance.Self.Right;
         this._myReseBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
         this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
      }
      
      private function initEvents() : void
      {
         this._myReseBtn.addEventListener(MouseEvent.CLICK,this.__resetClick);
         this._delayTimeBtn.addEventListener(MouseEvent.CLICK,this.__delayTimeClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __delayTimeClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpLevel:int = ConsortionModelControl.Instance.TaskModel.taskInfo.level - 1;
         var tmpTime:int = int(ServerConfigManager.instance.consortiaTaskDelayInfo[tmpLevel][0]);
         var tmpRich:int = int(ServerConfigManager.instance.consortiaTaskDelayInfo[tmpLevel][1]);
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.delayTime"),LanguageMgr.GetTranslation("consortia.task.delayTimeContent",tmpRich,tmpTime),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.DELAY_TIME);
         }
      }
      
      private function __resetClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"),LanguageMgr.GetTranslation("consortia.task.resetContent",ConsortiaTaskView.RESET_MONEY),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(event:FrameEvent) : void
      {
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortia.task.stopTable"));
            }
            else
            {
               if(BuriedManager.Instance.checkMoney(event.currentTarget.isBand,ConsortiaTaskView.RESET_MONEY))
               {
                  ObjectUtils.disposeObject(event.currentTarget as BaseAlerFrame);
                  return;
               }
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK,(event.currentTarget as BaseAlerFrame).isBand);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
            }
         }
         ObjectUtils.disposeObject(event.currentTarget as BaseAlerFrame);
      }
      
      private function __onNoMoneyResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._myReseBtn))
         {
            this._myReseBtn.removeEventListener(MouseEvent.CLICK,this.__resetClick);
         }
         if(Boolean(this._delayTimeBtn))
         {
            this._delayTimeBtn.removeEventListener(MouseEvent.CLICK,this.__delayTimeClick);
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __propChange(event:PlayerPropertyEvent) : void
      {
         var right:int = 0;
         if(Boolean(event.changedProperties["Right"]))
         {
            right = PlayerManager.Instance.Self.Right;
            this._myReseBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
            this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
         }
      }
      
      private function update() : void
      {
         var right:int = 0;
         right = PlayerManager.Instance.Self.Right;
         this._myReseBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
         this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
         for(var i:int = 0; i < this._finishItemList.length; i++)
         {
            this._finishItemList[i].update(this._taskInfo.itemList[i]["taskType"],this._taskInfo.itemList[i]["content"],this._taskInfo.itemList[i]["currenValue"],this._taskInfo.itemList[i]["targetValue"]);
         }
         this._expTxt.text = this._taskInfo.exp.toString();
         this._offerTxt.text = this._taskInfo.offer.toString();
         this._richesTxt.text = this._taskInfo.riches.toString();
         this._contributionTxt.text = this._taskInfo.contribution.toString();
         var buffinfo:ConsortionSkillInfo = ConsortionModelControl.Instance.model.getSkillInfoByID(this._taskInfo.buffID);
         if(buffinfo != null)
         {
            this._skillNameTxt.text = buffinfo.name + "*1gündür";
         }
         this._contentTxt1.text = "1. " + this._taskInfo.itemList[0]["content"];
         this._contentTxt2.text = "2. " + this._taskInfo.itemList[1]["content"];
         this._contentTxt3.text = "3. " + this._taskInfo.itemList[2]["content"];
         var myFinish:int = int((this._taskInfo.itemList[0]["finishValue"] / this._taskInfo.itemList[0]["targetValue"] + this._taskInfo.itemList[1]["finishValue"] / this._taskInfo.itemList[1]["targetValue"] + this._taskInfo.itemList[2]["finishValue"] / this._taskInfo.itemList[2]["targetValue"]) / 3 * 100);
         this._myFinishTxt.text = myFinish + "%";
      }
      
      public function set taskInfo(info:ConsortiaTaskInfo) : void
      {
         this._taskInfo = info;
         this.update();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._taskInfo = null;
         if(Boolean(this._myReseBtn))
         {
            ObjectUtils.disposeObject(this._myReseBtn);
         }
         this._myReseBtn = null;
         if(Boolean(this._delayTimeBtn))
         {
            ObjectUtils.disposeObject(this._delayTimeBtn);
         }
         this._delayTimeBtn = null;
         var i:int = 0;
         while(this._finishItemList != null && i < this._finishItemList.length)
         {
            ObjectUtils.disposeObject(this._finishItemList[i]);
            i++;
         }
         this._finishItemList = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._myFinishTxt))
         {
            ObjectUtils.disposeObject(this._myFinishTxt);
         }
         this._myFinishTxt = null;
         if(Boolean(this._expText))
         {
            ObjectUtils.disposeObject(this._expText);
         }
         this._expText = null;
         if(Boolean(this._moneyText))
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(Boolean(this._caiText))
         {
            ObjectUtils.disposeObject(this._caiText);
         }
         this._caiText = null;
         if(Boolean(this._skillText))
         {
            ObjectUtils.disposeObject(this._skillText);
         }
         this._skillText = null;
         if(Boolean(this._expTxt))
         {
            ObjectUtils.disposeObject(this._expTxt);
         }
         this._expTxt = null;
         if(Boolean(this._offerTxt))
         {
            ObjectUtils.disposeObject(this._offerTxt);
         }
         this._offerTxt = null;
         if(Boolean(this._richesTxt))
         {
            ObjectUtils.disposeObject(this._richesTxt);
         }
         this._richesTxt = null;
         if(Boolean(this._skillNameTxt))
         {
            ObjectUtils.disposeObject(this._skillNameTxt);
         }
         this._skillNameTxt = null;
         if(Boolean(this._contentTxt1))
         {
            ObjectUtils.disposeObject(this._contentTxt1);
         }
         this._contentTxt1 = null;
         if(Boolean(this._contentTxt2))
         {
            ObjectUtils.disposeObject(this._contentTxt2);
         }
         this._contentTxt2 = null;
         if(Boolean(this._contentTxt3))
         {
            ObjectUtils.disposeObject(this._contentTxt3);
         }
         this._contentTxt3 = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

