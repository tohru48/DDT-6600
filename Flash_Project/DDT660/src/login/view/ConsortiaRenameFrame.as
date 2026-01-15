package login.view
{
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class ConsortiaRenameFrame extends RoleRenameFrame
   {
      
      public function ConsortiaRenameFrame()
      {
         super();
         _path = "RenameConsortiaName.ashx";
         _checkPath = "ConsortiaNameCheck.ashx";
         _resultString = LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert");
         _resultField.text = _resultString;
      }
      
      override protected function configUi() : void
      {
         super.configUi();
         titleText = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
         _nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
         if(Boolean(_nicknameField))
         {
            _nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ConsortianameInput");
            addToContent(_nicknameField);
         }
      }
      
      override protected function __onModifyClick(evt:MouseEvent) : void
      {
         super.__onModifyClick(evt);
      }
      
      override protected function doRename() : void
      {
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
         temp.writeUTFBytes(acc.Account + "," + acc.Password + "," + tempPassword + "," + _roleInfo.NickName + "," + _newName);
         var p:String = CrytoUtils.rsaEncry4(acc.Key,temp);
         var variables:URLVariables = RequestVairableCreater.creatWidthKey(false);
         variables["p"] = p;
         variables["v"] = Version.Build;
         variables["site"] = PathManager.solveConfigSite();
         var loader:RequestLoader = this.createModifyLoader(_path,variables,tempPassword,renameCallBack);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      override protected function createModifyLoader(path:String, variables:URLVariables, tempPassword:String, callBack:Function) : RequestLoader
      {
         return super.createModifyLoader(path,variables,tempPassword,callBack);
      }
      
      override protected function renameComplete() : void
      {
         _roleInfo.ConsortiaNameChanged = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

