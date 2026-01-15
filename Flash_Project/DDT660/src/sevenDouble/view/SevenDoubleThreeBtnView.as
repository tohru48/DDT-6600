package sevenDouble.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import sevenDouble.SevenDoubleManager;
   import sevenDouble.event.SevenDoubleEvent;
   
   public class SevenDoubleThreeBtnView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _leapBtn:SimpleBitmapButton;
      
      private var _invisibilityBtn:SimpleBitmapButton;
      
      private var _cleanBtn:SimpleBitmapButton;
      
      private var _recordClickTag:int;
      
      private var _freeTipList:Vector.<MovieClip>;
      
      public function SevenDoubleThreeBtnView()
      {
         super();
         this.x = 885;
         this.y = 258;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:MovieClip = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.threeBtnBg");
         this._leapBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.leapBtn");
         this._leapBtn.tipData = LanguageMgr.GetTranslation("sevenDouble.game.leapBtnTipTxt");
         this._invisibilityBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.invisibilityBtn");
         this._invisibilityBtn.tipData = LanguageMgr.GetTranslation("sevenDouble.game.invisibilityBtnTipTxt");
         this._cleanBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.cleanBtn");
         this._cleanBtn.tipData = LanguageMgr.GetTranslation("sevenDouble.game.cleanBtnTipTxt");
         addChild(this._bg);
         addChild(this._leapBtn);
         addChild(this._invisibilityBtn);
         addChild(this._cleanBtn);
         this._freeTipList = new Vector.<MovieClip>();
         for(i = 0; i < 3; i++)
         {
            tmp = ComponentFactory.Instance.creat("asset.sevenDouble.freeTipMc") as MovieClip;
            tmp.x = -36;
            tmp.y = -14 + 44 * i;
            tmp.mouseEnabled = false;
            tmp.mouseChildren = false;
            addChild(tmp);
            this._freeTipList.push(tmp);
         }
         this.refreshFreeCount(null);
      }
      
      private function initEvent() : void
      {
         this._leapBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._leapBtn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._leapBtn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._invisibilityBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._cleanBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.REFRESH_ITEM_FREE_COUNT,this.refreshFreeCount);
      }
      
      private function refreshFreeCount(event:Event) : void
      {
         var tmp:Array = SevenDoubleManager.instance.itemFreeCountList;
         for(var i:int = 0; i < 3; i++)
         {
            if(tmp[i] > 0)
            {
               this._freeTipList[i].tf.text = tmp[i].toString();
               this._freeTipList[i].visible = true;
            }
            else
            {
               this._freeTipList[i].visible = false;
            }
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         var tmp:SevenDoubleEvent = new SevenDoubleEvent(SevenDoubleManager.LEAP_PROMPT_SHOW_HIDE);
         tmp.data = {"isShow":false};
         SevenDoubleManager.instance.dispatchEvent(tmp);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         var tmp:SevenDoubleEvent = new SevenDoubleEvent(SevenDoubleManager.LEAP_PROMPT_SHOW_HIDE);
         tmp.data = {"isShow":true};
         SevenDoubleManager.instance.dispatchEvent(tmp);
      }
      
      private function enableBtn(btn:SimpleBitmapButton) : void
      {
         btn.enable = true;
      }
      
      private function unEnableBtn(tag:int) : void
      {
         var target:SimpleBitmapButton = null;
         switch(tag)
         {
            case 0:
               target = this._leapBtn;
               break;
            case 1:
               target = this._invisibilityBtn;
               break;
            case 2:
               target = this._cleanBtn;
         }
         if(Boolean(target))
         {
            target.enable = false;
            setTimeout(this.enableBtn,5000,target);
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var target:SimpleBitmapButton = event.target as SimpleBitmapButton;
         switch(target)
         {
            case this._leapBtn:
               this._recordClickTag = 0;
               break;
            case this._invisibilityBtn:
               this._recordClickTag = 1;
               break;
            case this._cleanBtn:
               this._recordClickTag = 2;
         }
         if(this._freeTipList[this._recordClickTag].visible)
         {
            SocketManager.Instance.out.sendSevenDoubleUseSkill(this._recordClickTag,false,true);
            this.unEnableBtn(this._recordClickTag);
            return;
         }
         var tmpObj:Object = SevenDoubleManager.instance.getBuyRecordStatus(this._recordClickTag + 2);
         var needMoney:int = int(SevenDoubleManager.instance.dataInfo.useSkillNeedMoney[this._recordClickTag]);
         if(Boolean(tmpObj.isNoPrompt))
         {
            if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney < needMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
               tmpObj.isNoPrompt = false;
            }
            else
            {
               if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money < needMoney))
               {
                  SocketManager.Instance.out.sendSevenDoubleUseSkill(this._recordClickTag,tmpObj.isBand,this._freeTipList[this._recordClickTag].visible);
                  this.unEnableBtn(this._recordClickTag);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.frame.useSkillConfirmTxt" + this._recordClickTag,needMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SevenDoubleBuyConfirmView1",30,true,AlertManager.NOSELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.useSkillConfirm,false,0,true);
      }
      
      private function useSkillConfirm(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         var confirmFrame2:BaseAlerFrame = null;
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.useSkillConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = int(SevenDoubleManager.instance.dataInfo.useSkillNeedMoney[this._recordClickTag]);
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < needMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.useSkillReConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as SevenDoubleBuyConfirmView).isNoPrompt)
            {
               tmpObj = SevenDoubleManager.instance.getBuyRecordStatus(this._recordClickTag + 2);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendSevenDoubleUseSkill(this._recordClickTag,confirmFrame.isBand,this._freeTipList[this._recordClickTag].visible);
            this.unEnableBtn(this._recordClickTag);
         }
      }
      
      private function useSkillReConfirm(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.useSkillConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = int(SevenDoubleManager.instance.dataInfo.useSkillNeedMoney[this._recordClickTag]);
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendSevenDoubleUseSkill(this._recordClickTag,false,this._freeTipList[this._recordClickTag].visible);
            this.unEnableBtn(this._recordClickTag);
         }
      }
      
      private function removeEvent() : void
      {
         this._leapBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._leapBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this._leapBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this._invisibilityBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._cleanBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.REFRESH_ITEM_FREE_COUNT,this.refreshFreeCount);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._leapBtn = null;
         this._invisibilityBtn = null;
         this._cleanBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

