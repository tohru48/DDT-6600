package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuyBuffConfirmFrame extends BaseAlerFrame
   {
      
      protected var _bgTitle:DisplayObject;
      
      protected var _alertTips:FilterFrameText;
      
      protected var _alertTips2:FilterFrameText;
      
      protected var _buyBtn:SelectedCheckButton;
      
      private var _type:int;
      
      private var _promptSCBGroup:SelectedButtonGroup;
      
      private var _promptSCB:SelectedCheckButton;
      
      private var _promptSCB2:SelectedCheckButton;
      
      public function WorldBossBuyBuffConfirmFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.title");
         this.info = alertInfo;
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.worldboss.titleSmall");
         addChild(this._bgTitle);
         this._alertTips = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text");
         addToContent(this._alertTips);
         this._alertTips2 = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.text2");
         addToContent(this._alertTips2);
         this._alertTips2.text = "";
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuffFrame.selectBtn");
         this._buyBtn.x = 209;
         this._buyBtn.y = 83;
         addToContent(this._buyBtn);
         this._buyBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.noAlert");
      }
      
      public function show(tag:int = 1) : void
      {
         this._type = tag;
         var addInjureBuffMoney:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
         var addInjureValue:int = WorldBossManager.Instance.bossInfo.addInjureValue;
         this._promptSCB = ComponentFactory.Instance.creatComponentByStylename("worldBoss.buffBuffFrame.selectCheckButton");
         this._promptSCB2 = ComponentFactory.Instance.creatComponentByStylename("worldBoss.buffBuffFrame.selectCheckButton");
         PositionUtils.setPos(this._promptSCB2,"worldBoss.buffBuffFrame.selectCheckButtonPos");
         if(tag == 1)
         {
            this._promptSCB.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc3",addInjureBuffMoney,addInjureValue);
            this._promptSCB2.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc4",addInjureBuffMoney);
         }
         else
         {
            this._promptSCB.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc5",addInjureBuffMoney,addInjureValue);
            this._promptSCB2.text = LanguageMgr.GetTranslation("worldboss.buyBuff.confirmFrame.desc6",addInjureBuffMoney);
         }
         this._promptSCBGroup = new SelectedButtonGroup();
         this._promptSCBGroup.addSelectItem(this._promptSCB);
         this._promptSCBGroup.addSelectItem(this._promptSCB2);
         this._promptSCBGroup.selectIndex = 0;
         addToContent(this._promptSCB);
         addToContent(this._promptSCB2);
         _backgound.width += 66;
         _backgound.height += 26;
         if(Boolean(_closeButton))
         {
            _closeButton.x += 66;
         }
         _submitButton.x += 26;
         _cancelButton.x += 26;
         _submitButton.y += 26;
         _cancelButton.y += 26;
         this._buyBtn.x = 238;
         this._buyBtn.y = 117;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._buyBtn.addEventListener(Event.SELECT,this.__noAlertTip);
      }
      
      protected function __noAlertTip(e:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._type == 1)
         {
            SharedManager.Instance.isWorldBossBuyBuff = this._buyBtn.selected;
            SharedManager.Instance.isWorldBossBuyBuffFull = this._promptSCBGroup.selectIndex == 1;
         }
         else
         {
            SharedManager.Instance.isWorldBossBindBuyBuff = this._buyBtn.selected;
            SharedManager.Instance.isWorldBossBindBuyBuffFull = this._promptSCBGroup.selectIndex == 1;
         }
         SharedManager.Instance.save();
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               WorldBossManager.Instance.buyNewBuff(this._type,this._promptSCBGroup.selectIndex == 1);
         }
         this.dispose();
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(Event.SELECT,this.__noAlertTip);
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._promptSCBGroup))
         {
            this._promptSCBGroup.dispose();
         }
         this._promptSCBGroup = null;
         ObjectUtils.disposeObject(this._promptSCB);
         this._promptSCB = null;
         ObjectUtils.disposeObject(this._promptSCB2);
         this._promptSCB2 = null;
         if(Boolean(this._bgTitle))
         {
            ObjectUtils.disposeObject(this._bgTitle);
            this._bgTitle = null;
         }
         if(Boolean(this._buyBtn))
         {
            ObjectUtils.disposeObject(this._buyBtn);
            this._buyBtn = null;
         }
         if(Boolean(this._alertTips2))
         {
            ObjectUtils.disposeObject(this._alertTips2);
            this._alertTips2 = null;
         }
         if(Boolean(this._alertTips))
         {
            ObjectUtils.disposeObject(this._alertTips);
            this._alertTips = null;
         }
         super.dispose();
      }
   }
}

