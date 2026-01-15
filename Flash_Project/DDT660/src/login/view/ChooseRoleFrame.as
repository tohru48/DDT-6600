package login.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.Role;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SelectListManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.OneLineTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLVariables;
   
   public class ChooseRoleFrame extends Frame
   {
      
      private var _visible:Boolean = true;
      
      private var _listBack:MutipleImage;
      
      private var _enterButton:BaseButton;
      
      private var _list:VBox;
      
      private var _selectedItem:RoleItem;
      
      private var _disenabelFilter:ColorMatrixFilter;
      
      private var _rename:Boolean = false;
      
      private var _renameFrame:RoleRenameFrame;
      
      private var _consortiaRenameFrame:ConsortiaRenameFrame;
      
      private var _roleList:ListPanel;
      
      private var _gradeText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _recoverBtn:TextButton;
      
      private var _deleteBtn:TextButton;
      
      private var _recoverBtnStrip:StripTip;
      
      private var _deleteBtnStrip:StripTip;
      
      private var _oneLineTip:OneLineTip;
      
      private var _ReOrDeOperate:int;
      
      private var _recordOperateRoleItem:RoleItem;
      
      public function ChooseRoleFrame()
      {
         super();
         this.configUi();
      }
      
      private function configUi() : void
      {
         this._disenabelFilter = ComponentFactory.Instance.model.getSet("login.ChooseRole.DisenableGF");
         titleStyle = "login.Title";
         titleText = LanguageMgr.GetTranslation("tank.loginstate.chooseCharacter");
         this._listBack = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.bg");
         addToContent(this._listBack);
         this._gradeText = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.gradeText");
         addToContent(this._gradeText);
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.nameText");
         addToContent(this._nameText);
         this._roleList = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.RoleList");
         addToContent(this._roleList);
         this._recoverBtn = ComponentFactory.Instance.creatComponentByStylename("login.choooseRoleFrame.recoverBtn");
         this._recoverBtn.text = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.recoverBtnTxt");
         addToContent(this._recoverBtn);
         this._recoverBtnStrip = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.textBtnStrip");
         this._recoverBtnStrip.x = this._recoverBtn.x;
         this._recoverBtnStrip.y = this._recoverBtn.y;
         addToContent(this._recoverBtnStrip);
         this._recoverBtnStrip.visible = false;
         this._deleteBtn = ComponentFactory.Instance.creatComponentByStylename("login.choooseRoleFrame.deleteBtn");
         this._deleteBtn.text = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.deleteBtnTxt");
         addToContent(this._deleteBtn);
         this._deleteBtnStrip = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.textBtnStrip");
         this._deleteBtnStrip.x = this._deleteBtn.x;
         this._deleteBtnStrip.y = this._deleteBtn.y;
         addToContent(this._deleteBtnStrip);
         this._deleteBtnStrip.visible = false;
         this._enterButton = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.EnterButton");
         addToContent(this._enterButton);
         this._oneLineTip = new OneLineTip();
         addToContent(this._oneLineTip);
         this._oneLineTip.visible = false;
         this.addEvent();
         for(var i:int = 0; i < SelectListManager.Instance.list.length; i++)
         {
            this.addRole(SelectListManager.Instance.list[i] as Role);
         }
         AlertManager.Instance.layerType = LayerManager.STAGE_TOP_LAYER;
      }
      
      private function addEvent() : void
      {
         this._enterButton.addEventListener(MouseEvent.CLICK,this.__onEnterClick);
         this._roleList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onRoleClick);
         this._recoverBtn.addEventListener(MouseEvent.CLICK,this.recoverOrDeleteHandler,false,0,true);
         this._deleteBtn.addEventListener(MouseEvent.CLICK,this.recoverOrDeleteHandler,false,0,true);
         this._recoverBtn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._recoverBtn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._deleteBtn.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._deleteBtn.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._recoverBtnStrip.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._recoverBtnStrip.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
         this._deleteBtnStrip.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._deleteBtnStrip.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         var tmpTarget:Sprite = event.target as Sprite;
         var tmpTipStr:String = "";
         switch(tmpTarget)
         {
            case this._recoverBtn:
            case this._recoverBtnStrip:
               tmpTipStr = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.recoverBtnTipTxt");
               break;
            case this._deleteBtn:
            case this._deleteBtnStrip:
               tmpTipStr = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.deleteBtnTipTxt");
         }
         this._oneLineTip.tipData = tmpTipStr;
         this._oneLineTip.x = tmpTarget.x - (this._oneLineTip.width - tmpTarget.width) / 2;
         this._oneLineTip.y = tmpTarget.y + tmpTarget.height;
         this._oneLineTip.visible = true;
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this._oneLineTip.visible = false;
      }
      
      private function recoverOrDeleteHandler(event:MouseEvent) : void
      {
         var msg:String = null;
         SoundManager.instance.play("008");
         if(!this._selectedItem)
         {
            return;
         }
         if(event.target == this._deleteBtn)
         {
            msg = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.deleteTipTxt");
            this._ReOrDeOperate = 1;
         }
         else
         {
            msg = LanguageMgr.GetTranslation("ddt.chooseRoleFrame.recoverTipTxt");
            this._ReOrDeOperate = 2;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         var args:URLVariables = null;
         var loader:RequestLoader = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._recordOperateRoleItem = this._selectedItem;
            args = new URLVariables();
            args["username"] = PlayerManager.Instance.Account.Account;
            args["nickname"] = this._selectedItem.roleInfo.NickName;
            args["operation"] = this._ReOrDeOperate;
            loader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoginRemoveSmallAccount.ashx"),BaseLoader.REQUEST_LOADER,args);
            loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestRecoverDeleteError,false,0,true);
            loader.addEventListener(LoaderEvent.COMPLETE,this.__onRequestRecoverDeleteComplete,false,0,true);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function __onRequestRecoverDeleteError(evt:LoaderEvent) : void
      {
         this._recordOperateRoleItem = null;
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestRecoverDeleteError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestRecoverDeleteComplete);
      }
      
      private function __onRequestRecoverDeleteComplete(evt:LoaderEvent) : void
      {
         var tmpNickName:String = null;
         var loginState:int = 0;
         var tmpRoleList:Vector.<Role> = null;
         var tmpRole:Role = null;
         var tmpLoader:RequestLoader = evt.target as RequestLoader;
         tmpLoader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onRequestRecoverDeleteError);
         tmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onRequestRecoverDeleteComplete);
         var xml:XML = new XML(evt.loader.content);
         if(xml.@value == "true")
         {
            tmpNickName = xml.@NickName;
            loginState = int(xml.@LoginState);
            tmpRoleList = SelectListManager.Instance.list;
            for each(tmpRole in tmpRoleList)
            {
               if(tmpRole.NickName == tmpNickName)
               {
                  tmpRole.LoginState = loginState;
                  break;
               }
            }
            if(Boolean(this._recordOperateRoleItem))
            {
               this._recordOperateRoleItem.refreshDeleteIcon();
            }
            this.judgeSelecteRoleState();
         }
         this._recordOperateRoleItem = null;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._enterButton))
         {
            this._enterButton.removeEventListener(MouseEvent.CLICK,this.__onEnterClick);
         }
         this._roleList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onRoleClick);
         if(Boolean(this._recoverBtn))
         {
            this._recoverBtn.removeEventListener(MouseEvent.CLICK,this.recoverOrDeleteHandler);
            this._recoverBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._recoverBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
         if(Boolean(this._deleteBtn))
         {
            this._deleteBtn.removeEventListener(MouseEvent.CLICK,this.recoverOrDeleteHandler);
            this._deleteBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._deleteBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
         if(Boolean(this._recoverBtnStrip))
         {
            this._recoverBtnStrip.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._recoverBtnStrip.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
         if(Boolean(this._deleteBtnStrip))
         {
            this._deleteBtnStrip.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this._deleteBtnStrip.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
      }
      
      private function __onEnterClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         if(this._selectedItem.roleInfo.Rename || this._selectedItem.roleInfo.ConsortiaRename)
         {
            if(this._selectedItem.roleInfo.Rename && !this._selectedItem.roleInfo.NameChanged)
            {
               this.startRename(this._selectedItem.roleInfo);
               return;
            }
            if(this._selectedItem.roleInfo.ConsortiaRename && !this._selectedItem.roleInfo.ConsortiaNameChanged)
            {
               this.startRenameConsortia(this._selectedItem.roleInfo);
               return;
            }
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function __onRoleClick(evt:ListItemEvent) : void
      {
         var role:RoleItem = evt.cell as RoleItem;
         this.selectedItem = role;
      }
      
      private function startRenameConsortia(roleInfo:Role) : void
      {
         this._consortiaRenameFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaRenameFrame");
         this._consortiaRenameFrame.roleInfo = roleInfo;
         this._consortiaRenameFrame.addEventListener(Event.COMPLETE,this.__consortiaRenameComplete);
         LayerManager.Instance.addToLayer(this._consortiaRenameFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function startRename(roleInfo:Role) : void
      {
         this._renameFrame = ComponentFactory.Instance.creatComponentByStylename("RoleRenameFrame");
         this._renameFrame.roleInfo = roleInfo;
         this._renameFrame.addEventListener(Event.COMPLETE,this.__onRenameComplete);
         LayerManager.Instance.addToLayer(this._renameFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onRenameComplete(evt:Event) : void
      {
         this._renameFrame.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._renameFrame);
         this._renameFrame = null;
         this.__onEnterClick(null);
      }
      
      private function __consortiaRenameComplete(evt:Event) : void
      {
         this._consortiaRenameFrame.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._consortiaRenameFrame);
         this._consortiaRenameFrame = null;
         this.__onEnterClick(null);
      }
      
      public function addRole(info:Role) : void
      {
         this._roleList.vectorListModel.insertElementAt(info,this._roleList.vectorListModel.elements.length);
      }
      
      override public function dispose() : void
      {
         AlertManager.Instance.layerType = LayerManager.STAGE_DYANMIC_LAYER;
         this._visible = false;
         this.removeEvent();
         if(Boolean(this._listBack))
         {
            ObjectUtils.disposeObject(this._listBack);
            this._listBack = null;
         }
         if(Boolean(this._gradeText))
         {
            ObjectUtils.disposeObject(this._gradeText);
            this._gradeText = null;
         }
         if(Boolean(this._nameText))
         {
            ObjectUtils.disposeObject(this._nameText);
            this._nameText = null;
         }
         if(Boolean(this._roleList))
         {
            ObjectUtils.disposeObject(this._roleList);
            this._roleList = null;
         }
         if(Boolean(this._recoverBtn))
         {
            ObjectUtils.disposeObject(this._recoverBtn);
            this._recoverBtn = null;
         }
         if(Boolean(this._deleteBtn))
         {
            ObjectUtils.disposeObject(this._deleteBtn);
            this._deleteBtn = null;
         }
         if(Boolean(this._recoverBtnStrip))
         {
            ObjectUtils.disposeObject(this._recoverBtnStrip);
            this._recoverBtnStrip = null;
         }
         if(Boolean(this._deleteBtnStrip))
         {
            ObjectUtils.disposeObject(this._deleteBtnStrip);
            this._deleteBtnStrip = null;
         }
         this._recordOperateRoleItem = null;
         if(Boolean(this._enterButton))
         {
            ObjectUtils.disposeObject(this._enterButton);
            this._enterButton = null;
         }
         super.dispose();
      }
      
      public function get selectedRole() : Role
      {
         return this._selectedItem.roleInfo;
      }
      
      public function get selectedItem() : RoleItem
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(val:RoleItem) : void
      {
         var sel:RoleItem = null;
         if(this._selectedItem != val)
         {
            sel = this._selectedItem;
            this._selectedItem = val;
            if(this._selectedItem != null)
            {
               this._selectedItem.selected = true;
               SelectListManager.Instance.currentLoginRole = this._selectedItem.roleInfo;
               this.judgeSelecteRoleState();
            }
            if(Boolean(sel))
            {
               sel.selected = false;
               sel = null;
            }
         }
      }
      
      private function judgeSelecteRoleState() : void
      {
         if(this._selectedItem.roleInfo.LoginState == 1)
         {
            this._enterButton.enable = false;
            this._recoverBtn.enable = true;
            this._deleteBtn.enable = false;
            this._recoverBtnStrip.visible = false;
            this._deleteBtnStrip.visible = true;
         }
         else
         {
            this._enterButton.enable = true;
            this._recoverBtn.enable = false;
            this._recoverBtnStrip.visible = true;
            if(this._selectedItem.roleInfo.Grade >= 40 || SelectListManager.Instance.haveNotDeleteRoleNum == 1)
            {
               this._deleteBtn.enable = false;
               this._deleteBtnStrip.visible = true;
            }
            else
            {
               this._deleteBtn.enable = true;
               this._deleteBtnStrip.visible = false;
            }
         }
      }
   }
}

