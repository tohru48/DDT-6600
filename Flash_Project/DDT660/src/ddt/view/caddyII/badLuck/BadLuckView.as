package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.reader.CaddyReadAwardsView;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BadLuckView extends Sprite implements Disposeable, CaddyUpdate
   {
      
      private var _bg1:ScaleBitmapImage;
      
      private var _bg2:MutipleImage;
      
      private var _awardBtn:SelectedTextButton;
      
      private var _badLuckBtn:SelectedTextButton;
      
      private var _group:SelectedButtonGroup;
      
      private var _lastTimeTxt:FilterFrameText;
      
      private var _myNumberTxt:FilterFrameText;
      
      private var _caddyBadLuckView:CaddyBadLuckView;
      
      private var _readView:CaddyReadAwardsView;
      
      private var _bottomBG:MutipleImage;
      
      public function BadLuckView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("caddy.readAwardsBGIV");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.MyNumberBG");
         this._bg2.visible = false;
         this._bottomBG = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.bottomBG");
         this._group = new SelectedButtonGroup();
         this._awardBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.awardBtn");
         this._awardBtn.text = LanguageMgr.GetTranslation("tank.view.caddy.awardRecord");
         this._badLuckBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.bacLuckBtn");
         this._badLuckBtn.text = LanguageMgr.GetTranslation("tank.view.caddy.badluckf");
         this._group.addSelectItem(this._badLuckBtn);
         this._group.addSelectItem(this._awardBtn);
         this._badLuckBtn.visible = false;
         this._caddyBadLuckView = ComponentFactory.Instance.creatCustomObject("card.CaddyBadLuckView");
         this._readView = ComponentFactory.Instance.creatCustomObject("caddy.CaddyReadAwardsView");
         this._lastTimeTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.lastTimeTxt");
         this._myNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.MyNumberTxt");
         this._myNumberTxt.visible = false;
         addChild(this._bg1);
         addChild(this._bottomBG);
         addChild(this._bg2);
         addChild(this._awardBtn);
         addChild(this._badLuckBtn);
         addChild(this._caddyBadLuckView);
         addChild(this._readView);
         addChild(this._lastTimeTxt);
         addChild(this._myNumberTxt);
         this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
         this._group.selectIndex = 1;
         this._caddyBadLuckView.visible = false;
      }
      
      private function initEvents() : void
      {
         this._awardBtn.addEventListener(MouseEvent.CLICK,this.__awardBtnClick);
         this._badLuckBtn.addEventListener(MouseEvent.CLICK,this.__badLuckBtnClick);
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__updateLastTime);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      private function removeEvents() : void
      {
         this._awardBtn.removeEventListener(MouseEvent.CLICK,this.__awardBtnClick);
         this._badLuckBtn.removeEventListener(MouseEvent.CLICK,this.__badLuckBtnClick);
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__updateLastTime);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      private function __awardBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._caddyBadLuckView.visible = false;
         this._readView.visible = true;
      }
      
      private function __badLuckBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._caddyBadLuckView.visible = true;
         this._readView.visible = false;
      }
      
      private function __updateLastTime(e:CaddyEvent) : void
      {
         this._lastTimeTxt.text = "最後更新:" + e.lastTime;
      }
      
      private function __changeBadLuckNumber(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["BadLuckNumber"]))
         {
            if(PlayerManager.Instance.Self.badLuckNumber == 0)
            {
               this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
            }
         }
      }
      
      public function update() : void
      {
         this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._bottomBG))
         {
            ObjectUtils.disposeObject(this._bottomBG);
         }
         this._bottomBG = null;
         if(Boolean(this._awardBtn))
         {
            ObjectUtils.disposeObject(this._awardBtn);
         }
         this._awardBtn = null;
         if(Boolean(this._badLuckBtn))
         {
            ObjectUtils.disposeObject(this._badLuckBtn);
         }
         this._badLuckBtn = null;
         this._group = null;
         if(Boolean(this._lastTimeTxt))
         {
            ObjectUtils.disposeObject(this._lastTimeTxt);
         }
         this._lastTimeTxt = null;
         if(Boolean(this._myNumberTxt))
         {
            ObjectUtils.disposeObject(this._myNumberTxt);
         }
         this._myNumberTxt = null;
         if(Boolean(this._caddyBadLuckView))
         {
            ObjectUtils.disposeObject(this._caddyBadLuckView);
         }
         this._caddyBadLuckView = null;
         if(Boolean(this._readView))
         {
            ObjectUtils.disposeObject(this._readView);
         }
         this._readView = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

