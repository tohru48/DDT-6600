package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuildingManager extends Sprite implements Disposeable
   {
      
      private var _BG:MutipleImage;
      
      private var _bg:Bitmap;
      
      private var _tax:BaseButton;
      
      private var _shop:BaseButton;
      
      private var _store:BaseButton;
      
      private var _bank:BaseButton;
      
      private var _skill:BaseButton;
      
      private var _boss:BaseButton;
      
      private var _chairmanChanel:TextButton;
      
      private var _manager:TextButton;
      
      private var _takeIn:TextButton;
      
      private var _exit:TextButton;
      
      private var _chairChannel:ChairmanChannelPanel;
      
      private var _chairChannelShow:Boolean = true;
      
      public function BuildingManager()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("consortion.BuildingManagerBG");
         this._tax = ComponentFactory.Instance.creatComponentByStylename("buildingManager.tax");
         this._shop = ComponentFactory.Instance.creatComponentByStylename("buildingManager.shop");
         this._store = ComponentFactory.Instance.creatComponentByStylename("buildingManager.store");
         this._bank = ComponentFactory.Instance.creatComponentByStylename("buildingManager.bank");
         this._skill = ComponentFactory.Instance.creatComponentByStylename("buildingManager.skill");
         this._boss = ComponentFactory.Instance.creatComponentByStylename("buildingManager.boss");
         var tmpGrade:int = ConsortionModelControl.Instance.bossCallCondition;
         this._boss.tipData = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.conditionTxt",tmpGrade);
         this._chairmanChanel = ComponentFactory.Instance.creatComponentByStylename("buildingManager.chairmanChanel");
         this._chairmanChanel.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText1");
         this._manager = ComponentFactory.Instance.creatComponentByStylename("buildingManager.manager");
         this._manager.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText2");
         this._takeIn = ComponentFactory.Instance.creatComponentByStylename("buildingManager.takeIn");
         this._takeIn.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText3");
         this._exit = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
         this._exit.text = LanguageMgr.GetTranslation("consortia.BuildingManager.BtnText4");
         addChild(this._BG);
         addChild(this._tax);
         addChild(this._shop);
         addChild(this._store);
         addChild(this._bank);
         addChild(this._skill);
         addChild(this._boss);
         addChild(this._chairmanChanel);
         addChild(this._manager);
         addChild(this._takeIn);
         addChild(this._exit);
         this.initRight();
      }
      
      private function initRight() : void
      {
         var right:int = PlayerManager.Instance.Self.Right;
         this._exit.enable = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._13_Exit);
         this._takeIn.enable = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._1_Ratify);
         this._chairmanChanel.enable = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._10_ChangeMan);
      }
      
      private function initEvent() : void
      {
         this._tax.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._shop.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._store.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._bank.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._chairmanChanel.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._manager.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._takeIn.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._exit.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._skill.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._boss.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._tax))
         {
            this._tax.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._shop))
         {
            this._shop.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._store))
         {
            this._store.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._bank))
         {
            this._bank.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._chairmanChanel))
         {
            this._chairmanChanel.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._manager))
         {
            this._manager.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._takeIn))
         {
            this._takeIn.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._exit))
         {
            this._exit.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._skill))
         {
            this._skill.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         if(Boolean(this._boss))
         {
            this._boss.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __propChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Right"]))
         {
            this.initRight();
         }
      }
      
      private function __onClickHandler(event:MouseEvent) : void
      {
         var skillFrame:ConsortionSkillFrame = null;
         var tmpGrade:int = 0;
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._tax:
               ConsortionModelControl.Instance.alertTaxFrame();
               break;
            case this._shop:
               ConsortionModelControl.Instance.alertShopFrame();
               break;
            case this._store:
               ConsortionModelControl.Instance.rankFrame();
               break;
            case this._bank:
               ConsortionModelControl.Instance.alertBankFrame();
               break;
            case this._skill:
               skillFrame = ComponentFactory.Instance.creatComponentByStylename("consortionSkillFrame");
               LayerManager.Instance.addToLayer(skillFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._boss:
               tmpGrade = ConsortionModelControl.Instance.bossCallCondition;
               if(PlayerManager.Instance.Self.consortiaInfo.Level < tmpGrade)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.conditionTxt2",tmpGrade));
               }
               else
               {
                  ConsortionModelControl.Instance.openBossFrame();
               }
               break;
            case this._chairmanChanel:
               this.showChairmanChannel(event);
               break;
            case this._manager:
               ConsortionModelControl.Instance.alertManagerFrame();
               break;
            case this._takeIn:
               ConsortionModelControl.Instance.alertTakeInFrame();
               break;
            case this._exit:
               ConsortionModelControl.Instance.alertQuitFrame();
         }
      }
      
      private function showChairmanChannel(evt:MouseEvent) : void
      {
         if(this._chairChannelShow)
         {
            evt.stopImmediatePropagation();
            if(!this._chairChannel)
            {
               this._chairChannel = ComponentFactory.Instance.creatCustomObject("chairmanChannelPanel");
               addChild(this._chairChannel);
            }
            this._chairChannel.visible = true;
            LayerManager.Instance.addToLayer(this._chairChannel,LayerManager.GAME_DYNAMIC_LAYER);
            stage.addEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
         }
         else if(Boolean(this._chairChannel))
         {
            this._chairChannel.visible = false;
         }
         this._chairChannelShow = this._chairChannelShow ? false : true;
      }
      
      private function __closeChairChnnel(e:MouseEvent) : void
      {
         if(e.target != this._chairChannel)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
            if(Boolean(this._chairChannel))
            {
               this._chairChannel.visible = false;
               this._chairChannelShow = true;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._chairChannel))
         {
            ObjectUtils.disposeObject(this._chairChannel);
         }
         this._chairChannel = null;
         if(Boolean(this._tax))
         {
            ObjectUtils.disposeObject(this._tax);
         }
         this._tax = null;
         if(Boolean(this._shop))
         {
            ObjectUtils.disposeObject(this._shop);
         }
         this._shop = null;
         if(Boolean(this._store))
         {
            ObjectUtils.disposeObject(this._store);
         }
         this._store = null;
         if(Boolean(this._bank))
         {
            ObjectUtils.disposeObject(this._bank);
         }
         this._bank = null;
         if(Boolean(this._skill))
         {
            ObjectUtils.disposeObject(this._skill);
         }
         this._skill = null;
         if(Boolean(this._boss))
         {
            ObjectUtils.disposeObject(this._boss);
         }
         this._boss = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._chairmanChanel))
         {
            ObjectUtils.disposeObject(this._chairmanChanel);
         }
         this._chairmanChanel = null;
         if(Boolean(this._manager))
         {
            ObjectUtils.disposeObject(this._manager);
         }
         this._manager = null;
         if(Boolean(this._takeIn))
         {
            ObjectUtils.disposeObject(this._takeIn);
         }
         this._takeIn = null;
         if(Boolean(this._exit))
         {
            ObjectUtils.disposeObject(this._exit);
         }
         this._exit = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

