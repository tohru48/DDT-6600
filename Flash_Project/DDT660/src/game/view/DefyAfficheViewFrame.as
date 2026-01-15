package game.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddtBuried.BuriedManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import room.model.RoomInfo;
   
   public class DefyAfficheViewFrame extends Frame
   {
      
      private static const ANNOUNCEMENT_FEE:int = 500;
      
      private var _bg:ScaleBitmapImage;
      
      private var _defyAffichebtn:TextButton;
      
      private var _defyAffichebtn1:TextButton;
      
      private var _roomInfo:RoomInfo;
      
      private var _str:String;
      
      private var _textInput:TextInput;
      
      private var _titText:FilterFrameText;
      
      private var _titleInfoText:FilterFrameText;
      
      public function DefyAfficheViewFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._defyAffichebtn = null;
         this._defyAffichebtn1 = null;
         this._textInput = null;
         this._titText = null;
         this._titleInfoText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function inputCheck() : Boolean
      {
         if(this._textInput.text != "")
         {
            if(FilterWordManager.isGotForbiddenWords(this._textInput.text,"name"))
            {
               MessageTipManager.getInstance().show("公告中包含非法字元");
               return false;
            }
         }
         return true;
      }
      
      public function set roomInfo(value:RoomInfo) : void
      {
         this._roomInfo = value;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __alertSendDefy(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
         SoundManager.instance.play("008");
         this.handleString();
         this._str += this._textInput.text;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(BuriedManager.Instance.checkMoney(event.currentTarget.isBand,ANNOUNCEMENT_FEE))
               {
                  return;
               }
               SocketManager.Instance.out.sendDefyAffiche(this._str,event.currentTarget.isBand);
               this.handleString();
               this.dispose();
               break;
         }
      }
      
      private function __cancelClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __leaveToFill(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __okClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.inputCheck())
         {
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.DefyAfficheView.hint",ANNOUNCEMENT_FEE),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.__alertSendDefy);
      }
      
      private function __texeInput(evt:Event) : void
      {
         var n:String = String(120 - this._textInput.text.length);
         this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText",n);
      }
      
      private function handleString() : void
      {
         var i:int = 0;
         this._str = "";
         this._str = "[" + PlayerManager.Instance.Self.NickName + "]";
         this._str += LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheCaput");
         if(Boolean(this._roomInfo.defyInfo))
         {
            for(i = 0; i < this._roomInfo.defyInfo[1].length; i++)
            {
               this._str += "[" + this._roomInfo.defyInfo[1][i] + "]";
            }
         }
         this._str += LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheLast");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.textField.addEventListener(Event.CHANGE,this.__texeInput);
         this._defyAffichebtn.addEventListener(MouseEvent.CLICK,this.__okClick);
         this._defyAffichebtn1.addEventListener(MouseEvent.CLICK,this.__cancelClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._defyAffichebtn.removeEventListener(MouseEvent.CLICK,this.__okClick);
         this._defyAffichebtn1.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
      }
      
      private function selectedBandHander(e:MouseEvent) : void
      {
      }
      
      private function initView() : void
      {
         var self:SelfInfo = null;
         if(PathManager.solveExternalInterfaceEnabel())
         {
            self = PlayerManager.Instance.Self;
            ExternalInterfaceManager.sendToAgent(10,self.ID,self.NickName,ServerManager.Instance.zoneName);
         }
         titleText = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.affiche");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("game.view.DefyAfficheViewFrame.bg");
         addToContent(this._bg);
         this._titleInfoText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleInfoText");
         this._titleInfoText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfoText",ANNOUNCEMENT_FEE);
         addToContent(this._titleInfoText);
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("game.defyAfficheTextInput");
         this._textInput.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfo");
         addToContent(this._textInput);
         this._titText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleText");
         this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText",String(120 - this._textInput.text.length));
         addToContent(this._titText);
         this._defyAffichebtn = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn");
         this._defyAffichebtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._defyAffichebtn);
         this._defyAffichebtn1 = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn1");
         this._defyAffichebtn1.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._defyAffichebtn1);
      }
   }
}

