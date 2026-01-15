package boguAdventure.view
{
   import baglocked.BaglockedManager;
   import boguAdventure.BoguAdventureControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BoguAdventureAwardFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _tipBg:Bitmap;
      
      private var _tipText:FilterFrameText;
      
      private var _awardTipText1:FilterFrameText;
      
      private var _awardTipText2:FilterFrameText;
      
      private var _awardTipText3:FilterFrameText;
      
      private var _control:BoguAdventureControl;
      
      private var _level:int;
      
      private var awardTip1:Component;
      
      private var awardTip2:Component;
      
      private var awardTip3:Component;
      
      private var _awardBtn1:SimpleBitmapButton;
      
      private var _awardBtn2:SimpleBitmapButton;
      
      private var _awardBtn3:SimpleBitmapButton;
      
      public function BoguAdventureAwardFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsBtn");
         this._bg = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.Bg",_container);
         this._tipBg = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.tipBg",_container);
         this._tipText = UICreatShortcut.creatTextAndAdd("boguAdventure.awardFrame.tipText",LanguageMgr.GetTranslation("boguAdventure.view.awardFrameText"),_container);
         this._awardTipText1 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.waradText",_container);
         this._awardTipText2 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.waradText",_container);
         this._awardTipText3 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.waradText",_container);
         this._awardBtn1 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardBtn",_container);
         this._awardBtn2 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardBtn",_container);
         this._awardBtn3 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardBtn",_container);
         this.awardTip1 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardTip",_container);
         this.awardTip2 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardTip",_container);
         this.awardTip3 = UICreatShortcut.creatAndAdd("boguAdventure.awardFrame.awardTip",_container);
         this.createAwardTip(this.awardTip1);
         this.createAwardTip(this.awardTip2);
         this.createAwardTip(this.awardTip3);
         PositionUtils.setPos(this._awardTipText1,"boguAdventure.awardFrame.textPos1");
         PositionUtils.setPos(this._awardTipText2,"boguAdventure.awardFrame.textPos2");
         PositionUtils.setPos(this._awardTipText3,"boguAdventure.awardFrame.textPos3");
         PositionUtils.setPos(this._awardBtn1,"boguAdventure.awardFrame.awardBtnPos1");
         PositionUtils.setPos(this._awardBtn2,"boguAdventure.awardFrame.awardBtnPos2");
         PositionUtils.setPos(this._awardBtn3,"boguAdventure.awardFrame.awardBtnPos3");
         PositionUtils.setPos(this.awardTip1,"boguAdventure.awardFrame.awardTipPos1");
         PositionUtils.setPos(this.awardTip2,"boguAdventure.awardFrame.awardTipPos2");
         PositionUtils.setPos(this.awardTip3,"boguAdventure.awardFrame.awardTipPos3");
         this._awardBtn1.addEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._awardBtn2.addEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._awardBtn3.addEventListener(MouseEvent.CLICK,this.__onAwardClick);
      }
      
      public function set control(value:BoguAdventureControl) : void
      {
         this._control = value;
         this.updateBtnView();
      }
      
      private function updateBtnView() : void
      {
         this._awardBtn1.enable = this._control.model.openCount >= int(this._control.model.awardCount[0]) && !this._control.model.isAcquireAward1;
         this._awardBtn2.enable = this._control.model.openCount >= int(this._control.model.awardCount[1]) && !this._control.model.isAcquireAward2;
         this._awardBtn3.enable = this._control.model.openCount >= int(this._control.model.awardCount[2]) && !this._control.model.isAcquireAward3;
         this.awardTip1.tipData = this._control.model.awardGoodsTip[0];
         this.awardTip2.tipData = this._control.model.awardGoodsTip[1];
         this.awardTip3.tipData = this._control.model.awardGoodsTip[2];
         this._awardTipText1.text = LanguageMgr.GetTranslation("boguAdventure.view.successfulWalkCount",this._control.model.awardCount[0]);
         this._awardTipText2.text = LanguageMgr.GetTranslation("boguAdventure.view.successfulWalkCount",this._control.model.awardCount[1]);
         this._awardTipText3.text = LanguageMgr.GetTranslation("boguAdventure.view.successfulWalkCount",this._control.model.awardCount[2]);
      }
      
      private function __onAwardClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.currentTarget == this._awardBtn1)
         {
            this._level = 0;
         }
         else if(e.currentTarget == this._awardBtn2)
         {
            this._level = 1;
         }
         else
         {
            this._level = 2;
         }
         this.sendAwardAlter();
      }
      
      private function sendAwardAlter() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._control.model.openCount < int(this._control.model.awardCount[this._level]))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.openAwardError"));
            return;
         }
         if(this._control.model.isAcquireAward1 && this._control.model.isAcquireAward2 && this._control.model.isAcquireAward3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.awardComplete"));
            return;
         }
         SocketManager.Instance.out.sendBoguAdventureAcquireAward(this._level);
         this.dispose();
      }
      
      private function createAwardTip(obj:Sprite) : void
      {
         obj.graphics.beginFill(0,0.1);
         obj.graphics.drawRect(0,0,obj.width,obj.height);
         obj.graphics.endFill();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override protected function onResponse(type:int) : void
      {
         super.onResponse(type);
         if(type == FrameEvent.ESC_CLICK || type == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.playButtonSound();
            ObjectUtils.disposeObject(this);
         }
      }
      
      override public function dispose() : void
      {
         this._control = null;
         this._awardBtn1.removeEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._awardBtn2.removeEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._awardBtn3.removeEventListener(MouseEvent.CLICK,this.__onAwardClick);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._tipBg);
         this._tipBg = null;
         ObjectUtils.disposeObject(this._tipText);
         this._tipText = null;
         ObjectUtils.disposeObject(this._awardBtn1);
         this._awardBtn1 = null;
         ObjectUtils.disposeObject(this._awardBtn2);
         this._awardBtn2 = null;
         ObjectUtils.disposeObject(this._awardBtn3);
         this._awardBtn3 = null;
         ObjectUtils.disposeObject(this._awardTipText1);
         this._awardTipText1 = null;
         ObjectUtils.disposeObject(this._awardTipText2);
         this._awardTipText2 = null;
         ObjectUtils.disposeObject(this._awardTipText3);
         this._awardTipText3 = null;
         super.dispose();
      }
   }
}

