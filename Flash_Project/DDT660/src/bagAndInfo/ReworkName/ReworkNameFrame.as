package bagAndInfo.ReworkName
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.ReworkNameAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   
   public class ReworkNameFrame extends Frame
   {
      
      public static const Close:String = "close";
      
      public static const ReworkDone:String = "ReworkDone";
      
      public static const Aviable:String = "aviable";
      
      public static const Unavialbe:String = "unaviable";
      
      public static const Input:String = "input";
      
      protected var _tittleField:FilterFrameText;
      
      protected var _nicknameInput:FilterFrameText;
      
      protected var _inputBackground:Bitmap;
      
      protected var _resultField:FilterFrameText;
      
      protected var _checkButton:BaseButton;
      
      protected var _submitButton:TextButton;
      
      protected var _available:Boolean = true;
      
      protected var _nicknameDetail:String = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
      
      private var _resultDefaultFormat:TextFormat;
      
      private var _avialableFormat:TextFormat;
      
      private var _unAviableFormat:TextFormat;
      
      private var _disEnabledFilters:Array = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
      
      private var _complete:Boolean = true;
      
      protected var _path:String = "NickNameCheck.ashx";
      
      protected var _bagType:int;
      
      protected var _place:int;
      
      protected var _maxChars:int;
      
      protected var _state:String;
      
      protected var _isCanRework:Boolean;
      
      public function ReworkNameFrame()
      {
         super();
         escEnable = true;
         enterEnable = true;
         this.configUi();
         this.addEvent();
      }
      
      protected function configUi() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkName");
         this._resultDefaultFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultDefaultTF");
         this._avialableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultAvailableTF");
         this._unAviableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultUnAvailableTF");
         this._inputBackground = ComponentFactory.Instance.creatBitmap("bagAndInfo.reworkname.backgound_input");
         addToContent(this._inputBackground);
         this._tittleField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameTittle");
         this._tittleField.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName");
         addToContent(this._tittleField);
         this._resultField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameCheckResult");
         this._resultField.defaultTextFormat = this._resultDefaultFormat;
         this._resultField.text = this._nicknameDetail;
         addToContent(this._resultField);
         this._nicknameInput = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.NicknameInput");
         addToContent(this._nicknameInput);
         this._checkButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.CheckButton");
         addToContent(this._checkButton);
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.SubmitButton");
         this._submitButton.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.okLabel");
         addToContent(this._submitButton);
         this._submitButton.enable = false;
         this._submitButton.filters = this._disEnabledFilters;
      }
      
      private function addEvent() : void
      {
         this._nicknameInput.addEventListener(Event.CHANGE,this.__onInputChange);
         this._checkButton.addEventListener(MouseEvent.CLICK,this.__onCheckClick);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__onSubmitClick);
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         addEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
      }
      
      private function removeEvent() : void
      {
         this._nicknameInput.removeEventListener(Event.CHANGE,this.__onInputChange);
         this._checkButton.removeEventListener(MouseEvent.CLICK,this.__onCheckClick);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this.__onSubmitClick);
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         removeEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
      }
      
      private function __onToStage(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
         StageReferance.stage.focus = this._nicknameInput;
         setTimeout(this._nicknameInput.setFocus,100);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.close();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._submitButton.enable)
               {
                  this.__onSubmitClick(null);
               }
         }
      }
      
      protected function __onInputChange(evt:Event) : void
      {
         this.state = Input;
         if(this.state != Input)
         {
            this.state = Input;
         }
         if(!this._nicknameInput.text || this._nicknameInput.text == "")
         {
            this._submitButton.enable = false;
            this._submitButton.filters = this._disEnabledFilters;
         }
         else
         {
            this._submitButton.enable = true;
            this._submitButton.filters = null;
         }
      }
      
      protected function __onCheckClick(evt:MouseEvent) : void
      {
         if(this.complete)
         {
            SoundManager.instance.play("008");
            this._isCanRework = false;
            if(this.nameInputCheck())
            {
               this.createCheckLoader(this.checkNameCallBack);
            }
            else
            {
               this.visibleCheckText();
            }
         }
      }
      
      protected function visibleCheckText() : void
      {
         this.state = Input;
         this._resultField.text = this._nicknameDetail;
      }
      
      private function __onSubmitClick(evt:MouseEvent) : void
      {
         if(this.complete)
         {
            SoundManager.instance.play("008");
            this._isCanRework = false;
            if(this._nicknameInput.text == "")
            {
               this.setCheckTxt(LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName"));
            }
            if(!this.nameInputCheck())
            {
               this.visibleCheckText();
               return;
            }
            this.createCheckLoader(this.submitCheckCallBack);
         }
      }
      
      protected function setCheckTxt(m:String, val:Boolean = false) : void
      {
         if(m == LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.setCheckTxt"))
         {
            this.state = Aviable;
            this._isCanRework = true;
         }
         else
         {
            this.state = Unavialbe;
         }
         this._resultField.text = m;
      }
      
      private function __onLoadError(evt:LoaderEvent) : void
      {
         this.complete = true;
         this.state = Unavialbe;
         evt.loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
      }
      
      protected function createCheckLoader(callBack:Function) : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["bagType"] = this._bagType;
         args["place"] = this._place;
         args["NickName"] = this._nicknameInput.text;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(this._path),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("choosecharacter.LoadCheckName.m");
         loader.analyzer = new ReworkNameAnalyzer(callBack);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
         this.complete = false;
         return loader;
      }
      
      protected function checkNameCallBack(analyzer:ReworkNameAnalyzer) : void
      {
         this.complete = true;
         var result:XML = analyzer.result;
         this.setCheckTxt(result.@message,result.@value == "true");
      }
      
      protected function reworkNameComplete() : void
      {
         this.complete = true;
         SoundManager.instance.play("047");
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkNameComplete"),LanguageMgr.GetTranslation("ok"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         this.close();
      }
      
      protected function __onAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               alert.dispose();
         }
         StageReferance.stage.focus = this._nicknameInput;
      }
      
      protected function submitCheckCallBack(analyzer:ReworkNameAnalyzer) : void
      {
         var newName:String = null;
         this.complete = true;
         var result:XML = analyzer.result;
         this.setCheckTxt(result.@message,result.@value == "true");
         if(this.nameInputCheck() && this._isCanRework)
         {
            newName = this._nicknameInput.text;
            SocketManager.Instance.out.sendUseReworkName(this._bagType,this._place,newName);
            this.reworkNameComplete();
         }
      }
      
      protected function __onFrameResponse(evt:FrameEvent) : void
      {
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onFrameResponse);
         alert.dispose();
         this.state = Input;
      }
      
      protected function nameInputCheck() : Boolean
      {
         var alert:BaseAlerFrame = null;
         if(this._nicknameInput.text != "")
         {
            if(FilterWordManager.isGotForbiddenWords(this._nicknameInput.text,"name"))
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.IsNullorEmpty(this._nicknameInput.text))
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.containUnableChar(this._nicknameInput.text))
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            return true;
         }
         alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         return false;
      }
      
      public function initialize(bagType:int, place:int) : void
      {
         this._bagType = bagType;
         this._place = place;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(val:String) : void
      {
         if(this._state != val)
         {
            this._state = val;
            if(this._state == Aviable)
            {
               this._resultField.defaultTextFormat = this._avialableFormat;
               this._resultField.setTextFormat(this._avialableFormat,0,this._resultField.length);
            }
            else if(this._state == Unavialbe)
            {
               this._resultField.defaultTextFormat = this._unAviableFormat;
               this._resultField.setTextFormat(this._unAviableFormat,0,this._resultField.length);
            }
            else
            {
               this._resultField.defaultTextFormat = this._resultDefaultFormat;
               this._resultField.setTextFormat(this._resultDefaultFormat,0,this._resultField.length);
               this._resultField.text = this._nicknameDetail;
               this._isCanRework = true;
            }
         }
      }
      
      public function get complete() : Boolean
      {
         return this._complete;
      }
      
      public function set complete(val:Boolean) : void
      {
         if(this._complete != val)
         {
            this._complete = val;
            if(this._complete)
            {
               if(!this._nicknameInput.text || this._nicknameInput.text == "")
               {
                  this._submitButton.enable = false;
                  this._submitButton.filters = this._disEnabledFilters;
               }
               else
               {
                  this._submitButton.enable = true;
                  this._submitButton.filters = null;
               }
            }
            else
            {
               this._submitButton.enable = false;
               this._submitButton.filters = this._disEnabledFilters;
            }
         }
      }
      
      public function close() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._tittleField))
         {
            ObjectUtils.disposeObject(this._tittleField);
            this._tittleField = null;
         }
         if(Boolean(this._resultField))
         {
            ObjectUtils.disposeObject(this._resultField);
            this._resultField = null;
         }
         if(Boolean(this._nicknameInput))
         {
            ObjectUtils.disposeObject(this._nicknameInput);
            this._nicknameInput = null;
         }
         if(Boolean(this._checkButton))
         {
            ObjectUtils.disposeObject(this._checkButton);
            this._checkButton = null;
         }
         if(Boolean(this._submitButton))
         {
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
         }
         if(Boolean(this._inputBackground))
         {
            ObjectUtils.disposeObject(this._inputBackground);
            this._inputBackground = null;
         }
         this._resultDefaultFormat = null;
         this._avialableFormat = null;
         this._disEnabledFilters = null;
         super.dispose();
      }
   }
}

