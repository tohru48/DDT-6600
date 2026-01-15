package consortion.view.club
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.analyze.ReworkNameAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class CreateConsortionFrame extends Frame
   {
      
      public static const MIN_CREAT_CONSROTIA_LEVEL:int = 12;
      
      public static const MIN_CREAT_CONSORTIA_MONEY:int = 500;
      
      public static const MIN_CREAT_CONSORTIA_GOLD:int = int(ServerConfigManager.instance.CreateGuild);
      
      private var _bg:Bitmap;
      
      private var _input:TextInput;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _img:MutipleImage;
      
      private var _conditionText:FilterFrameText;
      
      private var _ticketText1:FilterFrameText;
      
      private var _ticketText2:FilterFrameText;
      
      private var _gradeText1:FilterFrameText;
      
      private var _gradeText2:FilterFrameText;
      
      private var _moneyText1:FilterFrameText;
      
      private var _moneyText2:FilterFrameText;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      private var _moneyAlertFrame:BaseAlerFrame;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      public function CreateConsortionFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.titleText");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.createConsortionFrame.BG");
         this._input = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion.input");
         this._img = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.img");
         this._conditionText = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.conditionText");
         this._conditionText.text = LanguageMgr.GetTranslation("createConsortionFrame.conditionText.Text");
         this._ticketText1 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText1");
         this._ticketText1.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text1");
         this._gradeText2 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.gradeText2");
         this._gradeText2.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.gradeText.Text2");
         this._moneyText1 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.moneyText1");
         this._moneyText1.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.moneyText.Text1",ServerConfigManager.instance.CreateGuild);
         this._ticketText2 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText2");
         this._ticketText2.text = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text2");
         this._gradeText1 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.gradeText1");
         this._gradeText1.text = LanguageMgr.GetTranslation("createConsortionFrame.gradeText.Text1");
         this._moneyText2 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.moneyText2");
         this._moneyText2.text = LanguageMgr.GetTranslation("gold");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.OKBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._bg);
         addToContent(this._input);
         addToContent(this._img);
         addToContent(this._conditionText);
         addToContent(this._ticketText1);
         addToContent(this._ticketText2);
         addToContent(this._gradeText1);
         addToContent(this._gradeText2);
         addToContent(this._moneyText1);
         addToContent(this._moneyText2);
         addToContent(this._okBtn);
         addToContent(this._cancelBtn);
         this._okBtn.enable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okFun);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelFun);
         this._input.addEventListener(Event.CHANGE,this.__inputHandler);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyboardHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._okBtn))
         {
            this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okFun);
         }
         if(Boolean(this._cancelBtn))
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelFun);
         }
         if(Boolean(this._input))
         {
            this._input.removeEventListener(Event.CHANGE,this.__inputHandler);
         }
         if(Boolean(this._input))
         {
            this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyboardHandler);
         }
      }
      
      private function createAction() : void
      {
         this._input.text = StringHelper.trim(this._input.text);
         if(BuriedManager.Instance.checkMoney(false,MIN_CREAT_CONSORTIA_MONEY))
         {
            return;
         }
         if(PlayerManager.Instance.Self.Gold < MIN_CREAT_CONSORTIA_GOLD)
         {
            this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._goldAlertFrame.moveEnable = false;
            this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            this._okBtn.enable = true;
            return;
         }
         if(!this.checkCanCreatConsortia())
         {
            this._okBtn.enable = true;
            return;
         }
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["NickName"] = this._input.text;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaNameCheck.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.analyzer = new ReworkNameAnalyzer(this.checkCallBack);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function sendName() : void
      {
         if(Boolean(this._input))
         {
            SocketManager.Instance.out.sendCreateConsortia(this._input.text,false);
         }
         this.dispose();
      }
      
      public function checkCallBack(analyzer:ReworkNameAnalyzer) : void
      {
         var result:XML = analyzer.result;
         if(result.@value == "true")
         {
            this.sendName();
         }
         else
         {
            this._okBtn.enable = true;
            MessageTipManager.getInstance().show(result.@message);
         }
      }
      
      private function __onLoadError(evt:LoaderEvent) : void
      {
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __quickBuyResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
            this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function checkCanCreatConsortia() : Boolean
      {
         if(this._input.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.inputPlease"));
            return false;
         }
         if(PlayerManager.Instance.Self.Grade < MIN_CREAT_CONSROTIA_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.yourGrade"));
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._input.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.consortiaName"));
            return false;
         }
         return true;
      }
      
      private function __addToStageHandler(event:Event) : void
      {
         this._input.setFocus();
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
               this.createAction();
         }
      }
      
      private function __okFun(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.createAction();
      }
      
      private function __cancelFun(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __inputHandler(event:Event) : void
      {
         if(this._input.text != "")
         {
            this._okBtn.enable = true;
         }
         else
         {
            this._okBtn.enable = false;
         }
         StringHelper.checkTextFieldLength(this._input.textField,12);
      }
      
      private function __keyboardHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            this.createAction();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._input = null;
         this._img = null;
         this._conditionText = null;
         this._ticketText1 = null;
         this._gradeText1 = null;
         this._moneyText1 = null;
         this._ticketText2 = null;
         this._gradeText2 = null;
         this._moneyText2 = null;
         this._okBtn = null;
         this._cancelBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

