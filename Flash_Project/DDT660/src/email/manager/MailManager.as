package email.manager
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SelectListManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import email.analyze.AllEmailAnalyzer;
   import email.analyze.SendedEmailAnalyze;
   import email.data.EmailInfo;
   import email.data.EmailState;
   import email.data.EmailType;
   import email.model.EmailModel;
   import email.view.EmailEvent;
   import email.view.EmailView;
   import email.view.WritingView;
   import flash.events.Event;
   import flash.net.URLVariables;
   import hall.event.NewHallEvent;
   import road7th.comm.PackageIn;
   
   public class MailManager
   {
      
      private static var _instance:MailManager;
      
      private static var useFirst:Boolean = true;
      
      private static var loadComplete:Boolean = false;
      
      public const NUM_OF_WRITING_DIAMONDS:uint = 4;
      
      private var _model:EmailModel;
      
      private var _view:EmailView;
      
      private var _isShow:Boolean;
      
      private var args:URLVariables;
      
      public var isOpenFromBag:Boolean = false;
      
      private var _write:WritingView;
      
      private var _name:String;
      
      public var linkChurchRoomId:int = -1;
      
      public function MailManager()
      {
         super();
         this._model = new EmailModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL,this.__sendEmail);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DELETE_MAIL,this.__deleteMail);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,this.__getMailToBag);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_CANCEL,this.__mailCancel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_RESPONSE,this.__responseMail);
      }
      
      public static function get Instance() : MailManager
      {
         if(_instance == null)
         {
            _instance = new MailManager();
         }
         return _instance;
      }
      
      public function get Model() : EmailModel
      {
         return this._model;
      }
      
      public function getAllEmailLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         if(Boolean(PlayerManager.Instance.Self.consortiaInfo.ChairmanID))
         {
            args["chairmanID"] = PlayerManager.Instance.Self.consortiaInfo.ChairmanID;
         }
         else
         {
            args["chairmanID"] = SelectListManager.Instance.currentLoginRole.ChairmanID;
         }
         var _loaderAll:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadUserMail.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         _loaderAll.loadErrorMessage = LanguageMgr.GetTranslation("tank.view.emailII.LoadMailAllInfoError");
         _loaderAll.analyzer = new AllEmailAnalyzer(this.stepAllEmail);
         _loaderAll.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loaderAll;
      }
      
      public function getSendedEmailLoader() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loaderSended:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MailSenderList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,args);
         _loaderSended.loadErrorMessage = LanguageMgr.GetTranslation("tank.view.emailII.LoadSendInfoError");
         _loaderSended.analyzer = new SendedEmailAnalyze(this.stepSendedEmails);
         _loaderSended.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loaderSended;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function loadMail(type:uint) : void
      {
         switch(type)
         {
            case 1:
               LoadResourceManager.Instance.startLoad(this.getAllEmailLoader());
               LoadResourceManager.Instance.startLoad(this.getSendedEmailLoader());
               break;
            case 2:
               LoadResourceManager.Instance.startLoad(this.getSendedEmailLoader());
               break;
            case 3:
               LoadResourceManager.Instance.startLoad(this.getAllEmailLoader());
               LoadResourceManager.Instance.startLoad(this.getSendedEmailLoader());
         }
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      public function stepAllEmail(analyzer:AllEmailAnalyzer) : void
      {
         this._model.emails = analyzer.list;
         this.changeSelected(null);
      }
      
      private function stepSendedEmails(analyzer:SendedEmailAnalyze) : void
      {
         this._model.sendedMails = analyzer.list;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this._view = null;
            this._view = ComponentFactory.Instance.creatCustomObject("emailView");
            this._view.setup(this,this._model);
            this._view.addEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
            this._isShow = true;
            this._view.show();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.EMAIL);
            useFirst = false;
         }
      }
      
      private function __onUIModuleProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.EMAIL)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __onClose(event:Event) : void
      {
         useFirst = true;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.EMAIL)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            loadComplete = true;
            this.show();
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._view))
         {
            this._model.selectEmail = null;
            this._model.mailType = EmailState.ALL;
            this._view.removeEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
            this._view.dispose();
            this._view = null;
         }
         this._isShow = false;
         if(this.isOpenFromBag)
         {
            BagAndInfoManager.Instance.showGiftFrame();
         }
         this.isOpenFromBag = false;
      }
      
      private function __escapeKeyDown(evt:EmailEvent) : void
      {
         if(Boolean(this._write) && Boolean(this._write.parent))
         {
            this._write.removeEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
            this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME,this.__closeWritingFrame);
            ObjectUtils.disposeObject(this._write);
            this._write = null;
         }
         if(Boolean(this._view))
         {
            if(Boolean(this._view.writeView) && Boolean(this._view.writeView.parent))
            {
               this._view.writeView.closeWin();
            }
            else
            {
               this.hide();
            }
         }
      }
      
      public function switchVisible() : void
      {
         if(Boolean(this._view) && Boolean(this._view.parent))
         {
            this.hide();
         }
         else
         {
            this.show();
            this._model.dispatchEvent(new NewHallEvent(NewHallEvent.CANCELEMAILSHINE));
         }
      }
      
      public function changeState(state:String) : void
      {
         this._model.state = state;
      }
      
      public function showWriting(value:String = null) : void
      {
         this._name = value;
         if(loadComplete)
         {
            this.creatWriteView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onWriteUIModuleComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.EMAIL);
         }
      }
      
      private function __onWriteUIModuleComplete(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         loadComplete = true;
         if(event.module == UIModuleTypes.EMAIL)
         {
            this.creatWriteView();
         }
      }
      
      private function creatWriteView() : void
      {
         if(this._write != null)
         {
            this._write = null;
         }
         this._write = ComponentFactory.Instance.creat("email.writingView");
         this._write.type = 0;
         PositionUtils.setPos(this._write,"EmailView.Pos_2");
         this._write.selectInfo = this._model.selectEmail;
         LayerManager.Instance.addToLayer(this._write,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         if(Boolean(StageReferance.stage) && Boolean(StageReferance.stage.focus))
         {
            StageReferance.stage.focus == this._write;
         }
         this._write.reset();
         if(this._name != null)
         {
            this._write.setName(this._name);
         }
         this._write.addEventListener(EmailEvent.CLOSE_WRITING_FRAME,this.__closeWritingFrame);
         this._write.addEventListener(FrameEvent.RESPONSE,this.__closeWriting);
         this._write.addEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
         this._write.addEventListener(EmailEvent.DISPOSED,this.__onDispose);
      }
      
      private function __closeWriting(event:FrameEvent) : void
      {
         if(Boolean(this._write))
         {
            this._write.closeWin();
         }
      }
      
      private function __closeWritingFrame(event:EmailEvent) : void
      {
         if(Boolean(this._write))
         {
            this._write.removeEventListener(FrameEvent.RESPONSE,this.__closeWriting);
            this._write.removeEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
            this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME,this.__closeWritingFrame);
            ObjectUtils.disposeObject(this._write);
            this._write = null;
         }
      }
      
      private function __onDispose(event:EmailEvent) : void
      {
         if(Boolean(this._write))
         {
            try
            {
               this._write.removeEventListener(FrameEvent.RESPONSE,this.__closeWriting);
               this._write.removeEventListener(EmailEvent.ESCAPE_KEY,this.__escapeKeyDown);
               this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME,this.__closeWritingFrame);
               ObjectUtils.disposeObject(this._write);
            }
            catch(e:Error)
            {
            }
         }
         this._write = null;
      }
      
      public function changeType(type:String) : void
      {
         if(this._model.mailType == type)
         {
            return;
         }
         this.updateNoReadMails();
         this._model.mailType = type;
      }
      
      public function changeSelected(info:EmailInfo) : void
      {
         this._model.selectEmail = info;
      }
      
      public function updateNoReadMails() : void
      {
         this._model.getNoReadMails();
      }
      
      public function getAnnexToBag(info:EmailInfo, type:int) : void
      {
         if(!this.HasAtLeastOneDiamond(info))
         {
            return;
         }
         SocketManager.Instance.out.sendGetMail(info.ID,type);
      }
      
      private function HasAtLeastOneDiamond(info:EmailInfo) : Boolean
      {
         if(info.Gold > 0)
         {
            return true;
         }
         if(info.Money > 0)
         {
            return true;
         }
         if(info.BindMoney > 0)
         {
            return true;
         }
         for(var i:uint = 1; i <= 5; i++)
         {
            if(Boolean(info["Annex" + i]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function deleteEmail(info:EmailInfo) : void
      {
         var arr:Array = null;
         if(Boolean(info))
         {
            if(info.Type == EmailType.CONSORTION_EMAIL)
            {
               if(Boolean(SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID]))
               {
                  arr = SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] as Array;
                  if(arr.indexOf(info.ID) < 0)
                  {
                     arr.push(info.ID);
                  }
               }
               else
               {
                  SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] = [info.ID];
               }
               SharedManager.Instance.save();
            }
            SocketManager.Instance.out.sendDeleteMail(info.ID);
         }
      }
      
      public function readEmail(info:EmailInfo) : void
      {
         if(this._model.mailType != EmailState.NOREAD)
         {
            this._model.removeFromNoRead(info);
         }
         SocketManager.Instance.out.sendUpdateMail(info.ID);
      }
      
      public function setPage(pre:Boolean, canChangePane:Boolean = true) : void
      {
         if(!pre && !canChangePane)
         {
            this._model.currentPage = this._model.currentPage;
            return;
         }
         if(pre)
         {
            if(this._model.currentPage - 1 > 0)
            {
               this._model.currentPage -= 1;
            }
         }
         else if(this._model.currentPage + 1 <= this._model.totalPage)
         {
            this._model.currentPage += 1;
         }
         else if(this._model.mailType == EmailState.NOREAD && this._model.totalPage == 1)
         {
            this._model.currentPage = 1;
         }
      }
      
      public function sendEmail(value:Object) : void
      {
         SocketManager.Instance.out.sendEmail(value);
      }
      
      public function onSendAnnex(annexArr:Array) : void
      {
         TaskManager.instance.onSendAnnex(annexArr);
      }
      
      public function untreadEmail(id:int) : void
      {
         SocketManager.Instance.out.untreadEmail(id);
      }
      
      private function __getMailToBag(event:CrazyTankSocketEvent) : void
      {
         var type:int = 0;
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var count:int = pkg.readInt();
         var currentMail:EmailInfo = this._model.getMailByID(id);
         if(!currentMail)
         {
            return;
         }
         if(currentMail.Type > 100 && currentMail.Money > 0)
         {
            currentMail.ValidDate = 72;
            currentMail.Money = 0;
         }
         for(var i:uint = 0; i < count; i++)
         {
            type = pkg.readInt();
            this.deleteMailDiamond(currentMail,type);
         }
         this._model.changeEmail(currentMail);
      }
      
      private function deleteMailDiamond(mail:EmailInfo, type:int) : void
      {
         var i:uint = 0;
         loop1:
         switch(type)
         {
            case 6:
               mail.Gold = 0;
               break;
            case 7:
               mail.Money = 0;
               break;
            case 8:
               mail.BindMoney = 0;
               break;
            case 9:
               mail.BindMoney = 0;
               break;
            default:
               i = 1;
               while(true)
               {
                  if(i > 5)
                  {
                     break loop1;
                  }
                  if(type == i)
                  {
                     mail["Annex" + i] = null;
                     break loop1;
                  }
                  i++;
               }
         }
      }
      
      private function __deleteMail(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         var isSuccess:Boolean = event.pkg.readBoolean();
         if(isSuccess)
         {
            this.removeMail(this._model.getMailByID(id));
            this.changeSelected(null);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.delete"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.false"));
         }
      }
      
      public function removeMail(info:EmailInfo) : void
      {
         this._model.removeEmail(info);
      }
      
      private function __sendEmail(event:CrazyTankSocketEvent) : void
      {
         if(event.pkg.readBoolean())
         {
            if(Boolean(this._view))
            {
               this._view.resetWrite();
            }
            if(Boolean(this._write))
            {
               this._write.reset();
            }
         }
      }
      
      private function __mailCancel(event:CrazyTankSocketEvent) : void
      {
         var cancelID:int = event.pkg.readInt();
         if(event.pkg.readBoolean())
         {
            this._model.removeEmail(this._model.selectEmail);
            this.changeSelected(null);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.back"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.return"));
         }
      }
      
      private function __responseMail(event:CrazyTankSocketEvent) : void
      {
         var args:URLVariables = null;
         var loader:BaseLoader = null;
         var id:int = event.pkg.readInt();
         var type:int = event.pkg.readInt();
         if(type == 4)
         {
            SocketManager.Instance.out.sendReloadGift();
            type = 1;
         }
         this.loadMail(type);
         if(type == 5)
         {
            args = RequestVairableCreater.creatWidthKey(true);
            args["timeTick"] = Math.random();
            loader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,args);
            loader.analyzer = new ShopItemAnalyzer(ShopManager.Instance.updateShopGoods);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      public function calculateRemainTime(startTime:String, validHours:Number) : Number
      {
         var str:String = startTime;
         var startDate:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2)) - 1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
         var nowDate:Date = TimeManager.Instance.Now();
         var remain:Number = validHours - (nowDate.time - startDate.time) / (60 * 60 * 1000);
         if(remain < 0)
         {
            return -1;
         }
         return remain;
      }
      
      public function readingViewLinkHandler(arr:Array) : void
      {
         var churchRoomId:int = 0;
         var name:String = arr[0];
         switch(name)
         {
            case "marrytype":
               churchRoomId = int(arr[1]);
               SocketManager.Instance.out.sendEnterRoom(churchRoomId,"");
               this.linkChurchRoomId = churchRoomId;
         }
      }
   }
}

