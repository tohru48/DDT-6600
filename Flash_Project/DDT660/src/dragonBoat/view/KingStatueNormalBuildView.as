package dragonBoat.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class KingStatueNormalBuildView extends BaseAlerFrame
   {
      
      private var _item:InventoryItemInfo;
      
      private var _item2:InventoryItemInfo;
      
      private var _itemMax:int;
      
      private var _itemMax2:int;
      
      private var _checkBtn1:SelectedCheckButton;
      
      private var _checkBtn2:SelectedCheckButton;
      
      private var _selectedGroup:SelectedButtonGroup;
      
      private var _sprite1:Sprite;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _sprite2:Sprite;
      
      private var _inputBg2:Bitmap;
      
      private var _inputText2:FilterFrameText;
      
      private var _maxBtn2:SimpleBitmapButton;
      
      private var _bottomPromptTxt:FilterFrameText;
      
      private var _type:int;
      
      public function KingStatueNormalBuildView()
      {
         super();
      }
      
      public function init2(type:int) : void
      {
         this._type = type;
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var title:String = this._type == 0 ? LanguageMgr.GetTranslation("ddt.dragonBoat.normalBuildTxt") : LanguageMgr.GetTranslation("ddt.dragonBoat.normalDecorateTxt");
         var _alertInfo:AlertInfo = new AlertInfo(title,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         _alertInfo.autoDispose = false;
         _alertInfo.sound = "008";
         info = _alertInfo;
         escEnable = true;
         this._checkBtn1 = ComponentFactory.Instance.creatComponentByStylename("KingStatue.checkBtn1");
         addToContent(this._checkBtn1);
         this._checkBtn2 = ComponentFactory.Instance.creatComponentByStylename("KingStatue.checkBtn2");
         addToContent(this._checkBtn2);
         this._selectedGroup = new SelectedButtonGroup();
         this._selectedGroup.addSelectItem(this._checkBtn1);
         this._selectedGroup.addSelectItem(this._checkBtn2);
         this._selectedGroup.selectIndex = 0;
         this._sprite1 = new Sprite();
         this._inputBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.normal.inputBg");
         this._inputBg.x = 0;
         this._inputBg.y = 0;
         this._sprite1.addChild(this._inputBg);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalInputTxt");
         this._inputText.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normal.maxBtn");
         this._sprite2 = new Sprite();
         this._inputBg2 = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.normal.inputBg");
         this._inputBg2.x = 0;
         this._inputBg2.y = 0;
         this._sprite2.addChild(this._inputBg2);
         this._inputText2 = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalInputTxt");
         this._inputText2.text = "1";
         this._maxBtn2 = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normal.maxBtn");
         this._sprite2.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._inputText2.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._inputText2.mouseEnabled = false;
         this._maxBtn2.enable = false;
         this._bottomPromptTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.consumePromptTxt2");
         PositionUtils.setPos(this._sprite1,"kingStatue.consumeFrame.inputBgPos");
         PositionUtils.setPos(this._inputText,"kingStatue.consumeFrame.inputTxtPos");
         PositionUtils.setPos(this._maxBtn,"kingStatue.consumeFrame.maxBtnPos");
         PositionUtils.setPos(this._sprite2,"kingStatue.consumeFrame.inputBg2Pos");
         PositionUtils.setPos(this._inputText2,"kingStatue.consumeFrame.inputTxt2Pos");
         PositionUtils.setPos(this._maxBtn2,"kingStatue.consumeFrame.maxBtn2Pos");
         PositionUtils.setPos(this._bottomPromptTxt,"kingStatue.consumeFrame.tipsPos");
         this._checkBtn1.text = LanguageMgr.GetTranslation("kingStatue.inputLowChip");
         this._checkBtn2.text = LanguageMgr.GetTranslation("kingStatue.inputHighChip");
         this._bottomPromptTxt.text = LanguageMgr.GetTranslation("kingStatue.normalBuildTips");
         addToContent(this._sprite1);
         addToContent(this._inputText);
         addToContent(this._maxBtn);
         addToContent(this._sprite2);
         addToContent(this._inputText2);
         addToContent(this._maxBtn2);
         addToContent(this._bottomPromptTxt);
      }
      
      private function initData() : void
      {
         this._item = PlayerManager.Instance.Self.PropBag.getItemByTemplateId(11771);
         this._itemMax = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11771,false);
         this._item2 = PlayerManager.Instance.Self.PropBag.getItemByTemplateId(11772);
         this._itemMax2 = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11772,false);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this._inputText2.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._maxBtn2.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._selectedGroup.addEventListener(Event.CHANGE,this.__groupChangeHandler);
      }
      
      private function __groupChangeHandler(event:Event) : void
      {
         SoundManager.instance.playButtonSound();
         switch(this._selectedGroup.selectIndex)
         {
            case 0:
               this._sprite1.filters = [];
               this._inputText.filters = [];
               this._inputText.mouseEnabled = true;
               this._maxBtn.enable = true;
               this._sprite2.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._inputText2.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._inputText2.mouseEnabled = false;
               this._maxBtn2.enable = false;
               break;
            case 1:
               this._sprite2.filters = [];
               this._inputText2.filters = [];
               this._inputText2.mouseEnabled = true;
               this._maxBtn2.enable = true;
               this._sprite1.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._inputText.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._inputText.mouseEnabled = false;
               this._maxBtn.enable = false;
         }
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var input:FilterFrameText = event.currentTarget as FilterFrameText;
         var num:int = int(input.text);
         if(num < 0)
         {
            input.text = "0";
         }
         switch(event.currentTarget)
         {
            case this._inputText:
               if(Boolean(this._item))
               {
                  if(num > this._itemMax)
                  {
                     input.text = this._itemMax.toString();
                  }
               }
               break;
            case this._inputText2:
               if(Boolean(this._item2))
               {
                  if(num > this._itemMax2)
                  {
                     input.text = this._itemMax2.toString();
                  }
               }
         }
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._maxBtn:
               if(Boolean(this._item))
               {
                  this._inputText.text = this._itemMax.toString();
               }
               break;
            case this._maxBtn2:
               if(Boolean(this._item2))
               {
                  this._inputText2.text = this._itemMax2.toString();
               }
         }
      }
      
      private function enterKeyHandler() : void
      {
         switch(this._selectedGroup.selectIndex)
         {
            case 0:
               SocketManager.Instance.out.sendDragonBoatBuildOrDecorate(1,int(this._inputText.text));
               break;
            case 1:
               SocketManager.Instance.out.sendDragonBoatBuildOrDecorate(1,int(this._inputText2.text));
         }
         this.dispose();
      }
      
      private function responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.enterKeyHandler();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._inputText.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
         this._inputText2.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         this._maxBtn2.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         this._selectedGroup.removeEventListener(Event.CHANGE,this.__groupChangeHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._inputText);
         this._inputText = null;
         ObjectUtils.disposeObject(this._maxBtn);
         this._maxBtn = null;
         ObjectUtils.disposeObject(this._inputBg2);
         this._inputBg2 = null;
         ObjectUtils.disposeObject(this._inputText2);
         this._inputText2 = null;
         ObjectUtils.disposeObject(this._maxBtn2);
         this._maxBtn2 = null;
         ObjectUtils.disposeObject(this._bottomPromptTxt);
         this._bottomPromptTxt = null;
         super.dispose();
      }
   }
}

