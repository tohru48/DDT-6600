package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionUpGradeFrame extends Frame
   {
      
      private var _level:SelectedButton;
      
      private var _store:SelectedButton;
      
      private var _shop:SelectedButton;
      
      private var _bank:SelectedButton;
      
      private var _skill:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _wordAndbmp1:MutipleImage;
      
      private var _wordAndBmp2:MutipleImage;
      
      private var _levelTxt:FilterFrameText;
      
      private var _storeTxt:FilterFrameText;
      
      private var _shopTxt:FilterFrameText;
      
      private var _bankTxt:FilterFrameText;
      
      private var _skillTxt:FilterFrameText;
      
      private var _levelNum:FilterFrameText;
      
      private var _storeNum:FilterFrameText;
      
      private var _shopNum:FilterFrameText;
      
      private var _bankNum:FilterFrameText;
      
      private var _skillNum:FilterFrameText;
      
      private var _explainWord:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _requireText:FilterFrameText;
      
      private var _consumeText:FilterFrameText;
      
      private var _tiptitle:FilterFrameText;
      
      private var _explain:FilterFrameText;
      
      private var _next:FilterFrameText;
      
      private var _require:FilterFrameText;
      
      private var _consume:FilterFrameText;
      
      private var _ok:TextButton;
      
      private var _cancel:TextButton;
      
      public function ConsortionUpGradeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.titleText");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.level");
         this._store = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.store");
         this._shop = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.shop");
         this._bank = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bank");
         this._skill = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.skill");
         this._btnGroup = new SelectedButtonGroup();
         this._wordAndbmp1 = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bmp1");
         this._wordAndBmp2 = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bmp2");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.levelTxt");
         this._levelTxt.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.levelTxt.text");
         this._storeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.storTxt");
         this._storeTxt.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.storTxt.text");
         this._shopTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.shopTxt");
         this._shopTxt.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.shopTxt.text");
         this._bankTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.boxTxt");
         this._bankTxt.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.boxTxt.text");
         this._skillTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.skillTxt");
         this._skillTxt.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.skillTxt.text");
         this._levelNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.levelNum");
         this._storeNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.storeNum");
         this._shopNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.shopNum");
         this._bankNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bankNum");
         this._skillNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.skillNum");
         this._explainWord = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.explainWord");
         this._explainWord.text = LanguageMgr.GetTranslation("consortion.upGrade.explainWord.text");
         this._nextLevel = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.nextLevel");
         this._nextLevel.text = LanguageMgr.GetTranslation("consortion.upGrade.nextLevel.text");
         this._requireText = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.require");
         this._requireText.text = LanguageMgr.GetTranslation("consortion.upGrade.require.text");
         this._consumeText = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.consume");
         this._consumeText.text = LanguageMgr.GetTranslation("consortion.upGrade.consume.text");
         this._tiptitle = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.title");
         this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.explain");
         this._next = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.next");
         this._require = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.require");
         this._consume = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.consume");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.ok");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.cancel");
         addToContent(this._level);
         addToContent(this._store);
         addToContent(this._shop);
         addToContent(this._bank);
         addToContent(this._skill);
         addToContent(this._wordAndbmp1);
         addToContent(this._wordAndBmp2);
         addToContent(this._levelTxt);
         addToContent(this._storeTxt);
         addToContent(this._shopTxt);
         addToContent(this._bankTxt);
         addToContent(this._skillTxt);
         addToContent(this._levelNum);
         addToContent(this._storeNum);
         addToContent(this._shopNum);
         addToContent(this._bankNum);
         addToContent(this._skillNum);
         addToContent(this._explainWord);
         addToContent(this._nextLevel);
         addToContent(this._requireText);
         addToContent(this._consumeText);
         addToContent(this._tiptitle);
         addToContent(this._explain);
         addToContent(this._next);
         addToContent(this._require);
         addToContent(this._consume);
         addToContent(this._ok);
         addToContent(this._cancel);
         this._btnGroup.addSelectItem(this._level);
         this._btnGroup.addSelectItem(this._store);
         this._btnGroup.addSelectItem(this._shop);
         this._btnGroup.addSelectItem(this._bank);
         this._btnGroup.addSelectItem(this._skill);
         this._btnGroup.selectIndex = 0;
         this._ok.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.okLabel");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this.setLeveText();
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
      }
      
      private function _consortiaInfoChange(event:PlayerPropertyEvent) : void
      {
         this.setLeveText();
      }
      
      private function setLeveText() : void
      {
         this._levelNum.text = String(PlayerManager.Instance.Self.consortiaInfo.Level);
         this._storeNum.text = String(PlayerManager.Instance.Self.consortiaInfo.SmithLevel);
         this._shopNum.text = String(PlayerManager.Instance.Self.consortiaInfo.ShopLevel);
         this._bankNum.text = String(PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
         this._skillNum.text = String(PlayerManager.Instance.Self.consortiaInfo.BufferLevel);
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __btnChangeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function showView(type:int) : void
      {
         var data:Vector.<String> = new Vector.<String>();
         switch(type)
         {
            case 0:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.titleTxt");
               data = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.LEVEL,PlayerManager.Instance.Self.consortiaInfo.Level);
               if(PlayerManager.Instance.Self.consortiaInfo.Level >= ConsortionModel.CONSORTION_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 1:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.storeUpgrade");
               data = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.STORE,PlayerManager.Instance.Self.consortiaInfo.SmithLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= ConsortionModel.STORE_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 2:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopUpgrade");
               data = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.SHOP,PlayerManager.Instance.Self.consortiaInfo.ShopLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= ConsortionModel.SHOP_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 3:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaSmithUpgrade");
               data = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.BANK,PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= ConsortionModel.BANK_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 4:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaSkillUpgrade");
               data = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.SKILL,PlayerManager.Instance.Self.consortiaInfo.BufferLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.BufferLevel >= ConsortionModel.SKILL_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
         }
         this._explain.text = data[0];
         this._next.text = data[1];
         this._require.text = data[2];
         this._consume.htmlText = data[3];
      }
      
      private function __okHandler(event:MouseEvent) : void
      {
         var confirm:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!ConsortionModelControl.Instance.model.checkConsortiaRichesForUpGrade(this._btnGroup.selectIndex))
         {
            this.openRichesTip();
            return;
         }
         if(this.checkGoldOrLevel())
         {
            switch(this._btnGroup.selectIndex)
            {
               case 0:
                  confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  confirm.moveEnable = false;
                  confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 2:
                  confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  confirm.moveEnable = false;
                  confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 3:
                  confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASTOREGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  confirm.moveEnable = false;
                  confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 1:
                  confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASMITHGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  confirm.moveEnable = false;
                  confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 4:
                  confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASKILLGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  confirm.moveEnable = false;
                  confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(frame);
         if(Boolean(frame) && Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendUpGradeData();
         }
      }
      
      private function sendUpGradeData() : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               SocketManager.Instance.out.sendConsortiaLevelUp(1);
               break;
            case 2:
               SocketManager.Instance.out.sendConsortiaLevelUp(3);
               break;
            case 3:
               SocketManager.Instance.out.sendConsortiaLevelUp(2);
               break;
            case 1:
               SocketManager.Instance.out.sendConsortiaLevelUp(4);
               break;
            case 4:
               SocketManager.Instance.out.sendConsortiaLevelUp(5);
         }
      }
      
      private function openRichesTip() : void
      {
         SoundManager.instance.play("047");
         var enoughFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough1"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
         enoughFrame.addEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
      }
      
      private function __noEnoughHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ConsortionModelControl.Instance.alertTaxFrame();
         }
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
         frame.dispose();
         frame = null;
      }
      
      private function checkGoldOrLevel() : Boolean
      {
         var goldAlert:BaseAlerFrame = null;
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               if(PlayerManager.Instance.Self.consortiaInfo.Level >= ConsortionModel.CONSORTION_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaLevel"));
                  return false;
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= ConsortionModel.SHOP_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel"));
                  return false;
               }
               if((PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1) * 2 > PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
               break;
            case 3:
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= ConsortionModel.BANK_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.smith"));
                  return false;
               }
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= ConsortionModel.STORE_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.store"));
                  return false;
               }
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
               break;
            case 4:
               if(PlayerManager.Instance.Self.consortiaInfo.BufferLevel >= ConsortionModel.SKILL_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill"));
               }
               else if(PlayerManager.Instance.Self.consortiaInfo.BufferLevel >= PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
         }
         if(this._btnGroup.selectIndex == 0 && PlayerManager.Instance.Self.Gold < ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level + 1).NeedGold)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return false;
            }
            goldAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            goldAlert.moveEnable = false;
            goldAlert.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return false;
         }
         return true;
      }
      
      private function __quickBuyResponse(evt:FrameEvent) : void
      {
         var quickBuy:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         frame.dispose();
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            quickBuy = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            quickBuy.itemID = EquipType.GOLD_BOX;
            quickBuy.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(quickBuy,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __cancelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._level = null;
         this._store = null;
         this._shop = null;
         this._bank = null;
         this._skill = null;
         this._wordAndbmp1 = null;
         this._wordAndBmp2 = null;
         this._levelTxt = null;
         this._storeTxt = null;
         this._shopTxt = null;
         this._bankTxt = null;
         this._skillTxt = null;
         this._levelNum = null;
         this._storeNum = null;
         this._shopNum = null;
         this._bankNum = null;
         this._skillNum = null;
         this._explainWord = null;
         this._nextLevel = null;
         this._requireText = null;
         this._consumeText = null;
         this._tiptitle = null;
         this._explain = null;
         this._next = null;
         this._require = null;
         this._consume = null;
         this._ok = null;
         this._cancel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

