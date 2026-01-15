package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ManagerFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _consortionShop:Bitmap;
      
      private var _consortionStore:Bitmap;
      
      private var _consortionSkill:Bitmap;
      
      private var _contributionText1:FilterFrameText;
      
      private var _contributionText2:FilterFrameText;
      
      private var _contributionText3:FilterFrameText;
      
      private var _contributionText4:FilterFrameText;
      
      private var _contributionText5:FilterFrameText;
      
      private var _contributionText6:FilterFrameText;
      
      private var _contributionText7:FilterFrameText;
      
      private var _noticeText:FilterFrameText;
      
      private var _inputBG:MutipleImage;
      
      private var _textBG:MutipleImage;
      
      private var _taxBtn:TextButton;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _shopLevelTxt1:TextInput;
      
      private var _shopLevelTxt2:TextInput;
      
      private var _shopLevelTxt3:TextInput;
      
      private var _shopLevelTxt4:TextInput;
      
      private var _shopLevelTxt5:TextInput;
      
      private var _smithTxt:TextInput;
      
      private var _skillTxt:TextInput;
      
      private var _valueArray:Array = [100,100,100,100,100,100,100];
      
      public function ManagerFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.bg");
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.inputBG");
         this._textBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.textBG");
         this._consortionShop = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionShop");
         this._consortionStore = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionStore");
         this._consortionSkill = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionSkill");
         this._contributionText1 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText1");
         this._contributionText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText2");
         this._contributionText3 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText3");
         this._contributionText4 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText4");
         this._contributionText5 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText5");
         this._contributionText6 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText6");
         this._contributionText7 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText7");
         this._taxBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.offerBtn");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.okBtn");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.cancelBtn");
         this._shopLevelTxt1 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt1");
         this._shopLevelTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt2");
         this._shopLevelTxt3 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt3");
         this._shopLevelTxt4 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt4");
         this._shopLevelTxt5 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt5");
         this._smithTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.smithTxt");
         this._skillTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.skillTxt");
         this._noticeText = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.noticeText");
         addToContent(this._bg);
         addToContent(this._inputBG);
         addToContent(this._textBG);
         addToContent(this._consortionShop);
         addToContent(this._consortionStore);
         addToContent(this._consortionSkill);
         addToContent(this._contributionText1);
         addToContent(this._contributionText2);
         addToContent(this._contributionText3);
         addToContent(this._contributionText4);
         addToContent(this._contributionText5);
         addToContent(this._contributionText6);
         addToContent(this._contributionText7);
         addToContent(this._taxBtn);
         addToContent(this._okBtn);
         addToContent(this._cancelBtn);
         addToContent(this._shopLevelTxt1);
         addToContent(this._shopLevelTxt2);
         addToContent(this._shopLevelTxt3);
         addToContent(this._shopLevelTxt4);
         addToContent(this._shopLevelTxt5);
         addToContent(this._smithTxt);
         addToContent(this._skillTxt);
         addToContent(this._noticeText);
         this._contributionText1.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText1");
         this._contributionText2.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText2");
         this._contributionText3.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText3");
         this._contributionText4.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText4");
         this._contributionText5.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText5");
         this._contributionText6.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");
         this._contributionText7.text = this._contributionText6.text;
         this._noticeText.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.noticeText");
         this._taxBtn.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.facilityDonate");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         if(PlayerManager.Instance.Self.DutyLevel == 1)
         {
            this.inputText(this._shopLevelTxt1);
            this.inputText(this._shopLevelTxt2);
            this.inputText(this._shopLevelTxt3);
            this.inputText(this._shopLevelTxt4);
            this.inputText(this._shopLevelTxt5);
            this.inputText(this._smithTxt);
            this.inputText(this._skillTxt);
         }
         else
         {
            this.DynamicText(this._shopLevelTxt1);
            this.DynamicText(this._shopLevelTxt2);
            this.DynamicText(this._shopLevelTxt3);
            this.DynamicText(this._shopLevelTxt4);
            this.DynamicText(this._shopLevelTxt5);
            this.DynamicText(this._smithTxt);
            this.DynamicText(this._skillTxt);
         }
         this._shopLevelTxt1.text = LanguageMgr.GetTranslation("hundred");
         this._shopLevelTxt2.text = LanguageMgr.GetTranslation("hundred");
         this._shopLevelTxt3.text = LanguageMgr.GetTranslation("hundred");
         this._shopLevelTxt4.text = LanguageMgr.GetTranslation("hundred");
         this._shopLevelTxt5.text = LanguageMgr.GetTranslation("hundred");
         this._smithTxt.text = LanguageMgr.GetTranslation("hundred");
         this._skillTxt.text = LanguageMgr.GetTranslation("hundred");
      }
      
      private function inputText(txt:TextInput) : void
      {
         txt.textField.restrict = "0-9";
         txt.textField.maxChars = 8;
         txt.mouseChildren = true;
         txt.mouseEnabled = true;
         txt.textField.selectable = true;
      }
      
      private function DynamicText(txt:TextInput) : void
      {
         txt.textField.selectable = false;
         txt.mouseEnabled = false;
         txt.mouseChildren = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxBtn.addEventListener(MouseEvent.CLICK,this.__taxHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__conditionChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxBtn.removeEventListener(MouseEvent.CLICK,this.__taxHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__conditionChangeHandler);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __okHandler(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked && this.checkChange())
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.DutyLevel == 1)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.okFunction"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function checkChange() : Boolean
      {
         var shopLevel1:int = this.checkInputValue(this._shopLevelTxt1);
         var shopLevel2:int = this.checkInputValue(this._shopLevelTxt2);
         var shopLevel3:int = this.checkInputValue(this._shopLevelTxt3);
         var shopLevel4:int = this.checkInputValue(this._shopLevelTxt4);
         var shopLevel5:int = this.checkInputValue(this._shopLevelTxt5);
         var smithLevel:int = this.checkInputValue(this._smithTxt);
         var skillLevel:int = this.checkInputValue(this._skillTxt);
         var arr:Array = [shopLevel1,shopLevel2,shopLevel3,shopLevel4,shopLevel5,smithLevel,skillLevel];
         var bool:Boolean = false;
         for(var i:int = 0; i < 7; i++)
         {
            if(this._valueArray[i] != arr[i])
            {
               bool = true;
            }
         }
         return bool;
      }
      
      private function __alertResponse(evt:FrameEvent) : void
      {
         var shopLevel1:int = 0;
         var shopLevel2:int = 0;
         var shopLevel3:int = 0;
         var shopLevel4:int = 0;
         var shopLevel5:int = 0;
         var smithLevel:int = 0;
         var skillLevel:int = 0;
         var arr:Array = null;
         SoundManager.instance.play("008");
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         ObjectUtils.disposeObject(evt.currentTarget);
         if((evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK) && this.checkChange())
         {
            shopLevel1 = this.checkInputValue(this._shopLevelTxt1);
            shopLevel2 = this.checkInputValue(this._shopLevelTxt2);
            shopLevel3 = this.checkInputValue(this._shopLevelTxt3);
            shopLevel4 = this.checkInputValue(this._shopLevelTxt4);
            shopLevel5 = this.checkInputValue(this._shopLevelTxt5);
            smithLevel = this.checkInputValue(this._smithTxt);
            skillLevel = this.checkInputValue(this._skillTxt);
            arr = [shopLevel1,shopLevel2,shopLevel3,shopLevel4,shopLevel5,smithLevel,skillLevel];
            SocketManager.Instance.out.sendConsortiaEquipConstrol(arr);
         }
      }
      
      private function checkInputValue(txt:TextInput) : int
      {
         if(txt.text == "")
         {
            return 0;
         }
         return int(txt.text);
      }
      
      private function __cancelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __taxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertTaxFrame();
      }
      
      private function __conditionChangeHandler(event:ConsortionEvent) : void
      {
         var list:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            if(list[i].Type != 1)
            {
               if(list[i].Type == 2)
               {
                  this._smithTxt.text = this._valueArray[5] = String(list[i].Riches);
               }
               else if(list[i].Type == 3)
               {
                  this._skillTxt.text = this._valueArray[6] = String(list[i].Riches);
               }
               continue;
            }
            switch(list[i].Level)
            {
               case 1:
                  this._shopLevelTxt1.text = this._valueArray[0] = String(list[i].Riches);
                  break;
               case 2:
                  this._shopLevelTxt2.text = this._valueArray[1] = String(list[i].Riches);
                  break;
               case 3:
                  this._shopLevelTxt3.text = this._valueArray[2] = String(list[i].Riches);
                  break;
               case 4:
                  this._shopLevelTxt4.text = this._valueArray[3] = String(list[i].Riches);
                  break;
               case 5:
                  this._shopLevelTxt5.text = this._valueArray[4] = String(list[i].Riches);
                  break;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._inputBG = null;
         this._textBG = null;
         if(Boolean(this._consortionShop))
         {
            ObjectUtils.disposeObject(this._consortionShop);
            this._consortionShop.bitmapData.dispose();
         }
         this._consortionShop = null;
         if(Boolean(this._consortionStore))
         {
            ObjectUtils.disposeObject(this._consortionStore);
            this._consortionStore.bitmapData.dispose();
         }
         this._consortionStore = null;
         if(Boolean(this._consortionSkill))
         {
            ObjectUtils.disposeObject(this._consortionSkill);
            this._consortionSkill.bitmapData.dispose();
         }
         this._consortionSkill = null;
         this._contributionText1 = null;
         this._contributionText2 = null;
         this._contributionText3 = null;
         this._contributionText4 = null;
         this._contributionText5 = null;
         this._contributionText6 = null;
         this._contributionText7 = null;
         this._noticeText = null;
         this._taxBtn = null;
         this._okBtn = null;
         this._cancelBtn = null;
         this._shopLevelTxt1 = null;
         this._shopLevelTxt2 = null;
         this._shopLevelTxt3 = null;
         this._shopLevelTxt4 = null;
         this._shopLevelTxt5 = null;
         this._smithTxt = null;
         this._skillTxt = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

