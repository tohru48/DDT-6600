package setting.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.Silder;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.OpitionEnum;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import setting.controll.SettingController;
   import trainer.data.Step;
   
   public class SettingView extends BaseAlerFrame
   {
      
      private var _imgTitle1:Image;
      
      private var _imgTitle2:Image;
      
      private var _imgTitle3:Image;
      
      private var _bmpYpsz:Bitmap;
      
      private var _bmpXssz:Bitmap;
      
      private var _bmpGnsz:Bitmap;
      
      private var _cbBjyy:SelectedCheckButton;
      
      private var _cbYxyx:SelectedCheckButton;
      
      private var _cbWqtx:SelectedCheckButton;
      
      private var _cbLbgn:SelectedCheckButton;
      
      private var _cbJsyq:SelectedCheckButton;
      
      private var _cbSxts:SelectedCheckButton;
      
      private var _communityFunction:SelectedCheckButton;
      
      private var _guideFunction:SelectedCheckButton;
      
      private var _academy:SelectedCheckButton;
      
      private var _refusedBeFriendBtn:SelectedCheckButton;
      
      private var _refusedPrivateChatBtn:SelectedCheckButton;
      
      private var _sliderBg1:Image;
      
      private var _sliderBg2:Image;
      
      private var _sliderBjyy:Silder;
      
      private var _sliderYxyx:Silder;
      
      private var _keySettingBtn:SimpleBitmapButton;
      
      private var _keySetFrame:KeySetFrame;
      
      private var _oldAllowMusic:Boolean;
      
      private var _oldAllowSound:Boolean;
      
      private var _oldShowParticle:Boolean;
      
      private var _oldShowBugle:Boolean;
      
      private var _oldShowInvate:Boolean;
      
      private var _oldShowOL:Boolean;
      
      private var _oldisRecommend:Boolean;
      
      private var _oldMusicVolumn:Number;
      
      private var _oldSoundVolumn:Number;
      
      private var _oldIsCommunity:Boolean;
      
      private var _recommendHint:MovieClip;
      
      private var _smallText1:FilterFrameText;
      
      private var _smallText2:FilterFrameText;
      
      private var _bigText1:FilterFrameText;
      
      private var _bigText2:FilterFrameText;
      
      public function SettingView()
      {
         super();
         this.initView();
      }
      
      private function __refusedPrivateChat(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._refusedPrivateChatBtn.selected,OpitionEnum.RefusedPrivateChat);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
      
      private function initView() : void
      {
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
         alertInfo.moveEnable = false;
         info = alertInfo;
         this._imgTitle1 = ComponentFactory.Instance.creat("ddtsetting.VolumeSetting");
         addToContent(this._imgTitle1);
         this._imgTitle2 = ComponentFactory.Instance.creat("ddtsetting.DisplaySetting");
         addToContent(this._imgTitle2);
         this._imgTitle3 = ComponentFactory.Instance.creat("ddtsetting.FuncSetting");
         addToContent(this._imgTitle3);
         this._smallText1 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.smallText1");
         this._smallText2 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.smallText2");
         this._bigText1 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.bigText1");
         this._bigText2 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.bigText2");
         this._cbBjyy = ComponentFactory.Instance.creat("ddtsetting.BackgroundMusicCbn");
         this._cbBjyy.text = LanguageMgr.GetTranslation("setting.backgroundMusic");
         this._cbBjyy.addEventListener(MouseEvent.CLICK,this.__audioSelect);
         addToContent(this._cbBjyy);
         this._cbYxyx = ComponentFactory.Instance.creat("ddtsetting.GameMusicCbn");
         this._cbYxyx.text = LanguageMgr.GetTranslation("setting.gameMusic");
         this._cbYxyx.addEventListener(MouseEvent.CLICK,this.__audioSelect);
         addToContent(this._cbYxyx);
         this._cbWqtx = ComponentFactory.Instance.creat("ddtsetting.WeaponEffectCbn");
         this._cbWqtx.text = LanguageMgr.GetTranslation("setting.weaponEffect");
         this._cbWqtx.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbWqtx);
         this._cbLbgn = ComponentFactory.Instance.creat("ddtsetting.SpeakerFunctionCbn");
         this._cbLbgn.text = LanguageMgr.GetTranslation("setting.speakerFunction");
         this._cbLbgn.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbLbgn);
         this._cbJsyq = ComponentFactory.Instance.creat("ddtsetting.AcceptInvitationCbn");
         this._cbJsyq.text = LanguageMgr.GetTranslation("setting.acceptInvitation");
         this._cbJsyq.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbJsyq);
         this._cbSxts = ComponentFactory.Instance.creat("ddtsetting.OnlinePromptCbn");
         this._cbSxts.text = LanguageMgr.GetTranslation("setting.onlinePrompt");
         this._cbSxts.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbSxts);
         this._communityFunction = ComponentFactory.Instance.creat("ddtsetting.CommunityFunctionCbn");
         this._communityFunction.text = LanguageMgr.GetTranslation("setting.communityFunction");
         this._communityFunction.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._communityFunction);
         if(!PathManager.isVisibleExistBtn() || !PathManager.CommunityExist())
         {
            this._communityFunction.visible = false;
         }
         this._guideFunction = ComponentFactory.Instance.creat("ddtsetting.GuideCbn");
         this._guideFunction.text = LanguageMgr.GetTranslation("setting.GuideCbnText");
         this._guideFunction.addEventListener(MouseEvent.CLICK,this.__setIsGuideHandler);
         addToContent(this._guideFunction);
         if(PlayerManager.Instance.Self.Grade > 15)
         {
            this._guideFunction.selected = false;
         }
         if(!PathManager.isVisibleExistBtn() || !PathManager.CommunityExist())
         {
            PositionUtils.setPos(this._guideFunction,"ddtsetting.GuideCbnPos");
         }
         this._academy = ComponentFactory.Instance.creatComponentByStylename("setting.academy");
         this._academy.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._refusedBeFriendBtn = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.AcceptAddingFriendsCbn");
         this._refusedBeFriendBtn.text = LanguageMgr.GetTranslation("setting.acceptAddingFriends");
         this._refusedBeFriendBtn.addEventListener(MouseEvent.CLICK,this.__refusedBeFriendHandler);
         addToContent(this._refusedBeFriendBtn);
         this._refusedPrivateChatBtn = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.RejectStrangerMessageCbn");
         this._refusedPrivateChatBtn.text = LanguageMgr.GetTranslation("setting.rejectStrangerMessage");
         this._refusedPrivateChatBtn.addEventListener(MouseEvent.CLICK,this.__refusedPrivateChat);
         addToContent(this._refusedPrivateChatBtn);
         this._sliderBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.SliderBarBg1");
         addToContent(this._sliderBg1);
         this._sliderBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.SliderBarBg2");
         addToContent(this._sliderBg2);
         this._sliderBjyy = ComponentFactory.Instance.creat("ddtsetting.BackgroundMusicSlider");
         this._sliderBjyy.addEventListener(InteractiveEvent.STATE_CHANGED,this.__musicSliderChanged);
         addToContent(this._sliderBjyy);
         this._sliderYxyx = ComponentFactory.Instance.creat("ddtsetting.GameMusicSlider");
         this._sliderYxyx.addEventListener(InteractiveEvent.STATE_CHANGED,this.__soundSliderChanged);
         addToContent(this._sliderYxyx);
         this._keySettingBtn = ComponentFactory.Instance.creatComponentByStylename("setting.keySettingBtn");
         this._keySettingBtn.addEventListener(MouseEvent.CLICK,this.__keySettingBtnClick);
         addToContent(this._keySettingBtn);
         this._keySettingBtn.enable = this.isSkillCanUse();
         addToContent(this._smallText1);
         addToContent(this._smallText2);
         addToContent(this._bigText1);
         addToContent(this._bigText2);
         this.initData();
      }
      
      private function initData() : void
      {
         this._oldAllowMusic = this.allowMusic = SharedManager.Instance.allowMusic;
         this._oldAllowSound = this.allowSound = SharedManager.Instance.allowSound;
         this._oldShowParticle = this.particle = SharedManager.Instance.showParticle;
         this._oldShowBugle = this.showbugle = SharedManager.Instance.showTopMessageBar;
         this._oldShowInvate = this.invate = SharedManager.Instance.showInvateWindow;
         this._oldShowOL = this.showOL = SharedManager.Instance.showOL;
         this._oldMusicVolumn = this.musicVolumn = SharedManager.Instance.musicVolumn;
         this._oldSoundVolumn = this.soundVolumn = SharedManager.Instance.soundVolumn;
         this._oldisRecommend = this.isRecommend = SharedManager.Instance.isRecommend;
         this._refusedBeFriendBtn.selected = !PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedBeFriend);
         if(PlayerManager.Instance.Self.Grade < 16)
         {
            this._guideFunction.selected = !PlayerManager.Instance.Self.getOptionState(OpitionEnum.IsSetGuide);
         }
         this._refusedPrivateChatBtn.selected = !PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedPrivateChat);
         this.sliderEnable(this._sliderBjyy,this._sliderBg1,this.allowMusic);
         this.sliderEnable(this._sliderYxyx,this._sliderBg2,this.allowSound);
         this._oldIsCommunity = this.isCommunity = SharedManager.Instance.isCommunity;
      }
      
      public function setShowSettingMovie() : void
      {
         if(SharedManager.Instance.isSetingMovieClip)
         {
            this._recommendHint = ComponentFactory.Instance.creat("asset.setting.RecommendHint");
            PositionUtils.setPos(this._recommendHint,"setting.recommendHintPos");
            LayerManager.Instance.addToLayer(this._recommendHint,LayerManager.GAME_TOP_LAYER,false);
            this._recommendHint.addEventListener(MouseEvent.CLICK,this.__recommendHintClick);
         }
      }
      
      private function get allowMusic() : Boolean
      {
         return this._cbBjyy.selected;
      }
      
      private function set allowMusic(value:Boolean) : void
      {
         this._cbBjyy.selected = value;
      }
      
      private function get allowSound() : Boolean
      {
         return this._cbYxyx.selected;
      }
      
      private function set allowSound(value:Boolean) : void
      {
         this._cbYxyx.selected = value;
      }
      
      private function get particle() : Boolean
      {
         return this._cbWqtx.selected;
      }
      
      private function set particle(value:Boolean) : void
      {
         this._cbWqtx.selected = value;
      }
      
      private function get showbugle() : Boolean
      {
         return this._cbLbgn.selected;
      }
      
      private function set showbugle(value:Boolean) : void
      {
         this._cbLbgn.selected = value;
      }
      
      private function get invate() : Boolean
      {
         return this._cbJsyq.selected;
      }
      
      private function set invate(value:Boolean) : void
      {
         this._cbJsyq.selected = value;
      }
      
      private function get showOL() : Boolean
      {
         return this._cbSxts.selected;
      }
      
      private function set showOL(value:Boolean) : void
      {
         this._cbSxts.selected = value;
      }
      
      private function get musicVolumn() : int
      {
         return this._sliderBjyy.value;
      }
      
      private function set musicVolumn(value:int) : void
      {
         this._sliderBjyy.value = value;
      }
      
      private function get soundVolumn() : int
      {
         return this._sliderYxyx.value;
      }
      
      private function set soundVolumn(value:int) : void
      {
         this._sliderYxyx.value = value;
      }
      
      private function get isRecommend() : Boolean
      {
         return this._academy.selected;
      }
      
      private function set isRecommend(value:Boolean) : void
      {
         this._academy.selected = value;
      }
      
      private function audioChanged() : void
      {
         SharedManager.Instance.changed();
      }
      
      private function get isCommunity() : Boolean
      {
         return this._communityFunction.selected;
      }
      
      private function set isCommunity(value:Boolean) : void
      {
         this._communityFunction.selected = value;
      }
      
      private function revert() : void
      {
         SharedManager.Instance.allowMusic = this._oldAllowMusic;
         SharedManager.Instance.allowSound = this._oldAllowSound;
         SharedManager.Instance.showParticle = this._oldShowParticle;
         SharedManager.Instance.showTopMessageBar = this._oldShowBugle;
         SharedManager.Instance.showInvateWindow = this._oldShowInvate;
         SharedManager.Instance.showOL = this._oldShowOL;
         SharedManager.Instance.musicVolumn = this._oldMusicVolumn;
         SharedManager.Instance.soundVolumn = this._oldSoundVolumn;
         SharedManager.Instance.isCommunity = this._oldIsCommunity;
         SharedManager.Instance.isRecommend = this._oldisRecommend;
         SharedManager.Instance.save();
      }
      
      public function doConfirm() : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.allowMusic = this.allowMusic;
         SharedManager.Instance.allowSound = this.allowSound;
         SharedManager.Instance.showParticle = this.particle;
         SharedManager.Instance.showTopMessageBar = this.showbugle;
         SharedManager.Instance.showInvateWindow = this.invate;
         SharedManager.Instance.showOL = this.showOL;
         SharedManager.Instance.musicVolumn = this.musicVolumn;
         SharedManager.Instance.soundVolumn = this.soundVolumn;
         SharedManager.Instance.isCommunity = this.isCommunity;
         SharedManager.Instance.isRecommend = this.isRecommend;
         SharedManager.Instance.save();
      }
      
      public function doCancel() : void
      {
         SoundManager.instance.play("008");
         this.revert();
      }
      
      private function sliderEnable(slider:Silder, sliderBg:Image, enable:Boolean) : void
      {
         var filter:Array = null;
         slider.mouseChildren = enable;
         slider.mouseEnabled = enable;
         if(enable)
         {
            slider.filters = null;
            sliderBg.filters = null;
         }
         else
         {
            filter = [ComponentFactory.Instance.model.getSet("grayFilter")];
            sliderBg.filters = filter;
            slider.filters = filter;
         }
      }
      
      private function __checkBoxClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __recommendHintClick(event:MouseEvent) : void
      {
         if(Boolean(this._recommendHint) && Boolean(this._recommendHint.parent))
         {
            this._recommendHint.removeEventListener(MouseEvent.CLICK,this.__recommendHintClick);
            this._recommendHint.parent.removeChild(this._recommendHint);
         }
      }
      
      private function __audioSelect(evt:MouseEvent) : void
      {
         SharedManager.Instance.allowMusic = this.allowMusic;
         SharedManager.Instance.allowSound = this.allowSound;
         this.audioChanged();
         if(evt.currentTarget == this._cbBjyy)
         {
            SoundManager.instance.play("008");
            this.sliderEnable(this._sliderBjyy,this._sliderBg1,this.allowMusic);
         }
         else if(evt.currentTarget == this._cbYxyx)
         {
            this.sliderEnable(this._sliderYxyx,this._sliderBg2,this.allowSound);
         }
      }
      
      private function __musicSliderChanged(evt:Event) : void
      {
         SharedManager.Instance.musicVolumn = this.musicVolumn;
         this.audioChanged();
      }
      
      private function __soundSliderChanged(evt:Event) : void
      {
         SharedManager.Instance.soundVolumn = this.soundVolumn;
         this.audioChanged();
      }
      
      private function __refusedBeFriendHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._refusedBeFriendBtn.selected,OpitionEnum.RefusedBeFriend);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
      
      private function __setIsGuideHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade > 15)
         {
            this._guideFunction.selected = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.setting.guideText"));
            return;
         }
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._guideFunction.selected,OpitionEnum.IsSetGuide);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
      
      protected function isSkillCanUse() : Boolean
      {
         var boo:Boolean = false;
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN))
         {
            boo = true;
         }
         return boo;
      }
      
      private function __keySettingBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         if(this._keySetFrame == null)
         {
            this._keySetFrame = ComponentFactory.Instance.creatComponentByStylename("setting.keySetFrame");
            this._keySetFrame.addEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         }
         this._keySetFrame.show();
      }
      
      private function __onKeySetResponse(event:FrameEvent) : void
      {
         this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         this._keySetFrame.dispose();
         this._keySetFrame = null;
      }
      
      override public function dispose() : void
      {
         this._cbBjyy.removeEventListener(MouseEvent.CLICK,this.__audioSelect);
         this._cbYxyx.removeEventListener(MouseEvent.CLICK,this.__audioSelect);
         this._cbWqtx.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbLbgn.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbJsyq.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbSxts.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._academy.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._guideFunction.removeEventListener(MouseEvent.CLICK,this.__setIsGuideHandler);
         this._communityFunction.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._refusedBeFriendBtn.removeEventListener(MouseEvent.CLICK,this.__refusedBeFriendHandler);
         this._refusedPrivateChatBtn.removeEventListener(MouseEvent.CLICK,this.__refusedPrivateChat);
         this._sliderBjyy.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__musicSliderChanged);
         this._sliderYxyx.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__soundSliderChanged);
         this._keySettingBtn.removeEventListener(MouseEvent.CLICK,this.__keySettingBtnClick);
         if(Boolean(this._keySetFrame))
         {
            this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
            this._keySetFrame.dispose();
            this._keySetFrame = null;
         }
         var focusDisplay:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(Boolean(focusDisplay) && contains(focusDisplay))
         {
            StageReferance.stage.focus = null;
         }
         if(Boolean(this._recommendHint) && Boolean(this._recommendHint.parent))
         {
            this._recommendHint.removeEventListener(MouseEvent.CLICK,this.__recommendHintClick);
            this._recommendHint.parent.removeChild(this._recommendHint);
            this._recommendHint = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._imgTitle1 = null;
         this._imgTitle2 = null;
         this._imgTitle3 = null;
         this._smallText1 = null;
         this._smallText2 = null;
         this._bigText1 = null;
         this._bigText2 = null;
         this._bmpYpsz = null;
         this._bmpXssz = null;
         this._bmpGnsz = null;
         this._cbBjyy = null;
         this._cbYxyx = null;
         this._cbWqtx = null;
         this._cbLbgn = null;
         this._cbJsyq = null;
         this._cbSxts = null;
         this._sliderBg1 = null;
         this._sliderBg2 = null;
         this._sliderBjyy = null;
         this._sliderYxyx = null;
         this._refusedBeFriendBtn = null;
         this._refusedPrivateChatBtn = null;
         if(Boolean(this._keySettingBtn))
         {
            ObjectUtils.disposeObject(this._keySettingBtn);
         }
         this._keySettingBtn = null;
         super.dispose();
         SettingController.Instance.dispose();
      }
   }
}

