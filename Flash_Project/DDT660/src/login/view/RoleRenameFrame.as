package login.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.Role;
   import ddt.data.analyze.LoginRenameAnalyzer;
   import ddt.data.analyze.ReworkNameAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLVariables;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class RoleRenameFrame extends Frame
   {
      
      protected static var w:String = "abcdefghijklmnopqrstuvwxyz";
      
      protected static const Aviable:String = "aviable";
      
      protected static const UnAviable:String = "unaviable";
      
      protected static const Input:String = "input";
      
      private var _nicknameBack:Scale9CornerImage;
      
      protected var _nicknameField:FilterFrameText;
      
      protected var _nicknameLabel:FilterFrameText;
      
      protected var _modifyButton:BaseButton;
      
      protected var _resultString:String = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
      
      protected var _resultField:FilterFrameText;
      
      protected var _disenabelFilter:ColorMatrixFilter;
      
      protected var _tempPass:String;
      
      protected var _roleInfo:Role;
      
      protected var _path:String = "RenameNick.ashx";
      
      protected var _checkPath:String = "NickNameCheck.ashx";
      
      protected var _complete:Boolean = false;
      
      protected var _isCanRework:Boolean = false;
      
      protected var _state:String;
      
      protected var _newName:String;
      
      public function RoleRenameFrame()
      {
         super();
         this.configUi();
         this.addEvent();
      }
      
      protected function configUi() : void
      {
         this._disenabelFilter = ComponentFactory.Instance.model.getSet("login.ChooseRole.DisenableGF");
         titleStyle = "login.Title";
         titleText = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
         this._nicknameBack = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameBackground");
         addToContent(this._nicknameBack);
         this._nicknameLabel = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameLabel");
         this._nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
         addToContent(this._nicknameLabel);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameInput");
         addToContent(this._nicknameField);
         this._resultField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.RenameResult");
         addToContent(this._resultField);
         this._modifyButton = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ModifyButton");
         addToContent(this._modifyButton);
         this._modifyButton.enable = false;
         this._modifyButton.filters = [this._disenabelFilter];
         this.state = Input;
      }
      
      private function addEvent() : void
      {
         this._modifyButton.addEventListener(MouseEvent.CLICK,this.__onModifyClick);
         this._nicknameField.addEventListener(Event.CHANGE,this.__onTextChange);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._modifyButton))
         {
            this._modifyButton.removeEventListener(MouseEvent.CLICK,this.__onModifyClick);
         }
         if(Boolean(this._nicknameField))
         {
            this._nicknameField.removeEventListener(Event.CHANGE,this.__onTextChange);
         }
      }
      
      private function __onTextChange(evt:Event) : void
      {
         this.state = Input;
         if(this._nicknameField.text == "" || !this._nicknameField.text)
         {
            if(this._modifyButton.enable)
            {
               this._modifyButton.enable = false;
               this._modifyButton.filters = [this._disenabelFilter];
            }
         }
         else if(!this._modifyButton.enable)
         {
            this._modifyButton.enable = true;
            this._modifyButton.filters = null;
         }
      }
      
      protected function __onModifyClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._modifyButton.enable)
         {
            this._modifyButton.enable = false;
            this._modifyButton.filters = [this._disenabelFilter];
         }
         this._newName = this._nicknameField.text;
         var loader:BaseLoader = this.createCheckLoader(this._checkPath,this.checkCallBack);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      protected function createCheckLoader(path:String, callBack:Function) : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["NickName"] = this._newName;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(path),BaseLoader.REQUEST_LOADER,args);
         loader.analyzer = new ReworkNameAnalyzer(callBack);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
         return loader;
      }
      
      protected function createModifyLoader(path:String, variables:URLVariables, tempPassword:String, callBack:Function) : RequestLoader
      {
         var loader:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(path),BaseLoader.REQUEST_LOADER,variables);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadLoginError);
         var analyzer:LoginRenameAnalyzer = new LoginRenameAnalyzer(callBack);
         analyzer.tempPassword = tempPassword;
         loader.analyzer = analyzer;
         return loader;
      }
      
      private function __onLoadLoginError(evt:LoaderEvent) : void
      {
      }
      
      protected function checkCallBack(analyzer:ReworkNameAnalyzer) : void
      {
         var result:XML = analyzer.result;
         if(result.@value == "true")
         {
            this.state = Aviable;
            this._resultField.text = result.@message;
            this.doRename();
         }
         else
         {
            this._resultField.text = result.@message;
            this.state = UnAviable;
         }
      }
      
      protected function renameCallBack(analyzer:LoginRenameAnalyzer) : void
      {
         var result:XML = analyzer.result;
         if(result.@value == "true")
         {
            this.state = Aviable;
            this.renameComplete();
         }
         else
         {
            this._resultField.text = result.@message;
            this.state = UnAviable;
         }
      }
      
      protected function doRename() : void
      {
         if(this._modifyButton.enable)
         {
            this._modifyButton.enable = false;
            this._modifyButton.filters = [this._disenabelFilter];
         }
         var acc:AccountInfo = PlayerManager.Instance.Account;
         var date:Date = new Date();
         var temp:ByteArray = new ByteArray();
         temp.writeShort(date.fullYearUTC);
         temp.writeByte(date.monthUTC + 1);
         temp.writeByte(date.dateUTC);
         temp.writeByte(date.hoursUTC);
         temp.writeByte(date.minutesUTC);
         temp.writeByte(date.secondsUTC);
         var tempPassword:String = "";
         for(var i:int = 0; i < 6; i++)
         {
            tempPassword += w.charAt(int(Math.random() * 26));
         }
         temp.writeUTFBytes(acc.Account + "," + acc.Password + "," + tempPassword + "," + this._roleInfo.NickName + "," + this._newName);
         var p:String = CrytoUtils.rsaEncry4(acc.Key,temp);
         var variables:URLVariables = RequestVairableCreater.creatWidthKey(false);
         variables["p"] = p;
         variables["v"] = Version.Build;
         variables["site"] = PathManager.solveConfigSite();
         var loader:RequestLoader = this.createModifyLoader(this._path,variables,tempPassword,this.renameCallBack);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      protected function renameComplete() : void
      {
         if(!this._modifyButton.enable)
         {
            this._modifyButton.enable = true;
            this._modifyButton.filters = null;
         }
         this._roleInfo.NameChanged = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __onLoadError(evt:LoaderEvent) : void
      {
      }
      
      public function get roleInfo() : Role
      {
         return this._roleInfo;
      }
      
      public function set roleInfo(val:Role) : void
      {
         this._roleInfo = val;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(val:String) : void
      {
         var tf:TextFormat = null;
         if(this._state != val)
         {
            this._state = val;
            if(this._state == Aviable)
            {
               tf = ComponentFactory.Instance.model.getSet("login.Rename.ResultAvailableTF");
               this._resultField.defaultTextFormat = tf;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(tf,0,this._resultField.length);
               }
            }
            else if(this._state == UnAviable)
            {
               if(this._modifyButton.enable)
               {
                  this._modifyButton.enable = false;
                  this._modifyButton.filters = [this._disenabelFilter];
               }
               tf = ComponentFactory.Instance.model.getSet("login.Rename.ResultUnAvailableTF");
               this._resultField.defaultTextFormat = tf;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(tf,0,this._resultField.length);
               }
            }
            else
            {
               this._resultField.text = this._resultString;
               tf = ComponentFactory.Instance.model.getSet("login.Rename.ResultDefaultTF");
               this._resultField.defaultTextFormat = tf;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(tf,0,this._resultField.length);
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._nicknameBack))
         {
            ObjectUtils.disposeObject(this._nicknameBack);
            this._nicknameBack = null;
         }
         if(Boolean(this._nicknameLabel))
         {
            ObjectUtils.disposeObject(this._nicknameLabel);
            this._nicknameLabel = null;
         }
         if(Boolean(this._nicknameField))
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
         if(Boolean(this._modifyButton))
         {
            ObjectUtils.disposeObject(this._modifyButton);
            this._modifyButton = null;
         }
         this._roleInfo = null;
         super.dispose();
      }
   }
}

