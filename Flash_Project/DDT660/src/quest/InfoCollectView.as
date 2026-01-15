package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import road7th.utils.StringHelper;
   
   public class InfoCollectView extends Sprite implements Disposeable
   {
      
      public var Type:int = 2;
      
      protected var _dataLabel:FilterFrameText;
      
      protected var _validateLabel:FilterFrameText;
      
      protected var _inputData:FilterFrameText;
      
      protected var _inputValidate:FilterFrameText;
      
      protected var _dataAlert:FilterFrameText;
      
      protected var _valiAlert:FilterFrameText;
      
      private var _submitBtn:TextButton;
      
      private var _sendBtn:TextButton;
      
      private var _id:int;
      
      private var _dicText:FilterFrameText;
      
      public function InfoCollectView(id:int)
      {
         this._id = id;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.addLabel();
         this._inputData = ComponentFactory.Instance.creat("core.quest.infoCollect.InputData");
         this._inputData.maxChars = 13;
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.SubmitBtn");
         this._sendBtn.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
         this._dataLabel.y = this._inputData.y;
         this._sendBtn.y = this._dataLabel.y - 5;
         this._dataAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Alert");
         this._dicText = ComponentFactory.Instance.creat("core.quest.infoCollect.dictext");
         this._dicText.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phoneDictText");
         this._inputValidate = ComponentFactory.Instance.creat("core.quest.infoCollect.InputValidate");
         this._validateLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         this._validateLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.validate");
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.CheckBtn");
         this._submitBtn.text = StringHelper.trimAll(LanguageMgr.GetTranslation("core.quest.valid"));
         this._validateLabel.y = this._inputValidate.y;
         this._submitBtn.y = this._validateLabel.y - 5;
         this._valiAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Result");
         addChild(this._inputData);
         addChild(this._dataLabel);
         addChild(this._inputValidate);
         addChild(this._dataAlert);
         addChild(this._validateLabel);
         addChild(this._sendBtn);
         addChild(this._submitBtn);
         addChild(this._valiAlert);
         addChild(this._dicText);
         this._inputData.addEventListener(FocusEvent.FOCUS_OUT,this.__onDataFocusOut);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__onSendBtn);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this._onSubmitBtn);
         this.modifyView();
      }
      
      protected function modifyView() : void
      {
         this._inputData.restrict = "0-9";
      }
      
      protected function addLabel() : void
      {
         this._dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         this._dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phone");
      }
      
      protected function validate() : void
      {
         this.alert("ddt.quest.collectInfo.validateSend");
      }
      
      protected function __onSendBtn(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._inputData.text.length < 11)
         {
            this.alert("ddt.quest.collectInfo.wrongPhoneNum");
            return;
         }
         if(this._inputData.text.length > 13)
         {
            this.alert("ddt.quest.collectInfo.wrongPhoneNum");
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.sendData();
      }
      
      protected function _onSubmitBtn(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.sendValidate();
      }
      
      protected function sendData() : void
      {
         var selfid:Number = PlayerManager.Instance.Self.ID;
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["selfid"] = selfid;
         args["input"] = this._inputData.text;
         args["questid"] = this._id;
         args["rnd"] = Math.random();
         this.fillArgs(args);
         var request:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SendActiveKeySystem.ashx"),BaseLoader.REQUEST_LOADER,args);
         request.addEventListener(LoaderEvent.COMPLETE,this.__onDataLoad);
         LoadResourceManager.Instance.startLoad(request);
      }
      
      protected function fillArgs(args:URLVariables) : URLVariables
      {
         args["phone"] = args["input"];
         return args;
      }
      
      private function __onDataLoad(e:LoaderEvent) : void
      {
         var x:XML = XML(e.loader.content);
         var result:String = x.@value;
         if(result == "true")
         {
         }
         this.dalert(x.@message);
      }
      
      private function __onLoadError(e:LoaderEvent) : void
      {
      }
      
      private function __onDataFocusOut(e:Event) : void
      {
         this.alert(this.updateHelper(this._inputData.text));
      }
      
      protected function updateHelper(value:String) : String
      {
         if(value.length > 11)
         {
            return "ddt.quest.collectInfo.phoneNumberError";
         }
         return "";
      }
      
      protected function dalert(alertString:String) : void
      {
         this._dataAlert.text = alertString;
      }
      
      protected function alert(alertString:String) : void
      {
         this._dataAlert.text = LanguageMgr.GetTranslation(alertString);
      }
      
      protected function dalertVali(alertString:String) : void
      {
         this._valiAlert.text = alertString;
      }
      
      protected function alertVali(alertString:String) : void
      {
         this._valiAlert.text = LanguageMgr.GetTranslation(alertString);
      }
      
      private function sendValidate() : void
      {
         if(this._inputValidate.text.length < 1)
         {
            this.alertVali("ddt.quest.collectInfo.noValidate");
            return;
         }
         if(this._inputValidate.text.length < 6)
         {
            this.alertVali("ddt.quest.collectInfo.validateError");
            return;
         }
         if(this._inputValidate.text.length > 6)
         {
            this.alertVali("ddt.quest.collectInfo.validateError");
            return;
         }
         SocketManager.Instance.out.sendCollectInfoValidate(this.Type,this._inputValidate.text,this._id);
      }
      
      public function dispose() : void
      {
         this._inputData.removeEventListener(FocusEvent.FOCUS_OUT,this.__onDataFocusOut);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__onSendBtn);
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this._onSubmitBtn);
         ObjectUtils.disposeObject(this._dataLabel);
         this._dataLabel = null;
         ObjectUtils.disposeObject(this._validateLabel);
         this._validateLabel = null;
         ObjectUtils.disposeObject(this._inputData);
         this._inputData = null;
         ObjectUtils.disposeObject(this._inputValidate);
         this._inputValidate = null;
         ObjectUtils.disposeObject(this._valiAlert);
         this._valiAlert = null;
         ObjectUtils.disposeObject(this._submitBtn);
         this._submitBtn = null;
         ObjectUtils.disposeObject(this._sendBtn);
         this._sendBtn = null;
      }
   }
}

