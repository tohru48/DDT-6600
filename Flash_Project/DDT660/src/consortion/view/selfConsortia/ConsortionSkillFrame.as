package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionSkillFrame extends Frame
   {
      
      public static const CONSORTION_SKILL:int = 0;
      
      public static const PERSONAL_SKILL_CON:int = 1;
      
      public static const PERSONAL_SKILL_METAL:int = 2;
      
      private var _bg:MutipleImage;
      
      private var _richesTxt:FilterFrameText;
      
      private var _richbg:ScaleFrameImage;
      
      private var _riches:FilterFrameText;
      
      private var _manager:TextButton;
      
      private var _consortionSkill:SelectedTextButton;
      
      private var _personalSkill:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _contribute:SelectedTextButton;
      
      private var _metal:SelectedTextButton;
      
      private var _cmGroup:SelectedButtonGroup;
      
      private var _scrollbg:ScaleBitmapImage;
      
      private var _vbox:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _items:Vector.<ConsortionSkillItem>;
      
      private var _oldType:int = 0;
      
      public function ConsortionSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.skillFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.bg");
         this._scrollbg = ComponentFactory.Instance.creatComponentByStylename("consortion.SkillItemBtn.scallBG");
         this._richesTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.richesText");
         this._richesTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText1");
         this._richbg = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.richesbg");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.riches");
         this._manager = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.manager");
         this._manager.text = LanguageMgr.GetTranslation("consortion.shop.manager.Text");
         this._consortionSkill = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.consortionSkill");
         this._consortionSkill.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.skillTxt.text");
         this._personalSkill = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.personalSkill");
         this._personalSkill.text = LanguageMgr.GetTranslation("consortion.upGradeFrame.skillTxt.text1");
         this._contribute = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.contribute");
         this._contribute.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText2");
         this._metal = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.metal");
         this._metal.text = LanguageMgr.GetTranslation("ddtMoney");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.panel");
         addToContent(this._bg);
         addToContent(this._scrollbg);
         addToContent(this._richesTxt);
         addToContent(this._richbg);
         addToContent(this._riches);
         addToContent(this._manager);
         addToContent(this._consortionSkill);
         addToContent(this._personalSkill);
         addToContent(this._contribute);
         addToContent(this._metal);
         addToContent(this._panel);
         this._panel.setView(this._vbox);
         this._cmGroup = new SelectedButtonGroup();
         this._cmGroup.addSelectItem(this._contribute);
         this._cmGroup.addSelectItem(this._metal);
         this._cmGroup.selectIndex = 0;
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._consortionSkill);
         this._btnGroup.addSelectItem(this._personalSkill);
         this._btnGroup.selectIndex = 0;
         this.showContent(this._btnGroup.selectIndex + 1);
      }
      
      private function cmGroupVisible(value:Boolean) : void
      {
         this._metal.visible = value;
         this._contribute.visible = value;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._manager.addEventListener(MouseEvent.CLICK,this.__manageHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._cmGroup.addEventListener(Event.CHANGE,this.__cmChangeHandler);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__richChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._manager.removeEventListener(MouseEvent.CLICK,this.__manageHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._cmGroup.removeEventListener(Event.CHANGE,this.__cmChangeHandler);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.SKILL_STATE_CHANGE,this.__stateChange);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__richChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfRichChangeHandler);
      }
      
      protected function __cmChangeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showContent(this._cmGroup.selectIndex + 2);
      }
      
      private function __richChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties[ConsortiaInfo.RICHES]) && this._btnGroup.selectIndex == 0)
         {
            this._riches.text = String(PlayerManager.Instance.Self.consortiaInfo.Riches);
         }
      }
      
      private function __selfRichChangeHandler(event:PlayerPropertyEvent) : void
      {
         if((Boolean(event.changedProperties["RichesRob"]) || Boolean(event.changedProperties["RichesOffer"])) && this._btnGroup.selectIndex == 1)
         {
            this._riches.text = String(PlayerManager.Instance.Self.Riches);
         }
      }
      
      private function __stateChange(event:ConsortionEvent) : void
      {
         this.showContent(this._oldType);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __manageHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      private function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.showContent(this._btnGroup.selectIndex + 1);
      }
      
      private function showContent(type:int) : void
      {
         var b:Boolean = false;
         var isMetal:Boolean = false;
         var item:ConsortionSkillItem = null;
         var temp:int = 0;
         this._oldType = type;
         if(type == 1)
         {
            this._scrollbg.height = 426;
            this._scrollbg.y = 96;
            this._panel.height = 412;
            this._panel.y = 104;
            this.cmGroupVisible(false);
            this._richesTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText1");
         }
         else
         {
            this._scrollbg.height = 395;
            this._scrollbg.y = 128;
            this._panel.height = 383;
            this._panel.y = 136;
            this.cmGroupVisible(true);
            if(type == 2)
            {
               this._richesTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText2");
               this._cmGroup.selectIndex = 0;
            }
            else
            {
               this._richesTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText3");
               this._cmGroup.selectIndex = 1;
            }
         }
         this.clearItem();
         this._richbg.setFrame(type);
         this._riches.text = type == 1 ? String(PlayerManager.Instance.Self.consortiaInfo.Riches) : (type == 2 ? String(PlayerManager.Instance.Self.Riches) : String(PlayerManager.Instance.Self.BandMoney));
         for(var i:int = 0; i < ConsortionModel.SKILL_MAX_LEVEL; i++)
         {
            b = i + 1 > PlayerManager.Instance.Self.consortiaInfo.BufferLevel ? false : true;
            isMetal = type == 3 ? true : false;
            item = new ConsortionSkillItem(i + 1,b,isMetal);
            temp = type == 3 ? 2 : type;
            item.data = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(temp,i + 1);
            this._vbox.addChild(item);
            this._items.push(item);
         }
         this._panel.invalidateViewport();
      }
      
      private function clearItem() : void
      {
         var i:int = 0;
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               this._items[i].dispose();
               this._items[i] = null;
            }
         }
         this._items = new Vector.<ConsortionSkillItem>();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItem();
         this._items = null;
         super.dispose();
         this._bg = null;
         this._scrollbg = null;
         this._metal = null;
         this._cmGroup = null;
         this._richesTxt = null;
         this._richbg = null;
         this._riches = null;
         this._manager = null;
         this._consortionSkill = null;
         this._personalSkill = null;
         this._btnGroup = null;
         this._vbox = null;
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

