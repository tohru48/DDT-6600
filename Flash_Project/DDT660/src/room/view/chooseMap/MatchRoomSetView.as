package room.view.chooseMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class MatchRoomSetView extends Sprite implements Disposeable
   {
      
      private var _frame:BaseAlerFrame;
      
      private var _bg:ScaleBitmapImage;
      
      private var _roomMode:Bitmap;
      
      private var _modelIcon:Bitmap;
      
      private var _soprts:FilterFrameText;
      
      private var _roomName:FilterFrameText;
      
      private var _password:FilterFrameText;
      
      private var _nameInput:TextInput;
      
      private var _passInput:TextInput;
      
      private var _isReset:Boolean;
      
      private var _isChanged:Boolean = false;
      
      private var _checkBox:SelectedCheckButton;
      
      public function MatchRoomSetView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var ai:AlertInfo = new AlertInfo();
         ai.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         ai.showCancel = ai.moveEnable = false;
         ai.submitLabel = LanguageMgr.GetTranslation("ok");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView");
         this._frame.info = ai;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setViewBg");
         this._roomMode = ComponentFactory.Instance.creatBitmap("asset.ddtroom.setView.modeWord");
         this._modelIcon = ComponentFactory.Instance.creatBitmap("asset.ddtroom.setView.modeIcon");
         this._soprts = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.sports");
         this._soprts.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.sports");
         this._roomName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.name");
         this._roomName.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.roomname");
         this._password = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.password");
         this._password.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.password");
         this._nameInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.nameInput");
         this._nameInput.textField.wordWrap = this._nameInput.textField.multiline = false;
         this._passInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.passInput");
         this._passInput.textField.wordWrap = this._nameInput.textField.multiline = false;
         this._passInput.textField.restrict = "0-9 A-Z a-z";
         this._checkBox = ComponentFactory.Instance.creat("asset.ddtMatchRoom.setView.selectBtn");
         this._frame.addToContent(this._bg);
         this._frame.addToContent(this._roomMode);
         this._frame.addToContent(this._modelIcon);
         this._frame.addToContent(this._soprts);
         this._frame.addToContent(this._roomName);
         this._frame.addToContent(this._password);
         this._frame.addToContent(this._nameInput);
         this._frame.addToContent(this._passInput);
         this._frame.addToContent(this._checkBox);
         addChild(this._frame);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this.updateRoomInfo();
      }
      
      private function updateRoomInfo() : void
      {
         this._nameInput.text = RoomManager.Instance.current.Name;
         if(Boolean(RoomManager.Instance.current.roomPass))
         {
            this._checkBox.selected = true;
            this._passInput.text = RoomManager.Instance.current.roomPass;
         }
         else
         {
            this._checkBox.selected = false;
         }
         this.upadtePassTextBg();
      }
      
      private function __checkBoxClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.upadtePassTextBg();
      }
      
      private function upadtePassTextBg() : void
      {
         if(this._checkBox.selected)
         {
            this._passInput.mouseChildren = true;
            this._passInput.mouseEnabled = true;
            this._passInput.setFocus();
         }
         else
         {
            this._passInput.mouseChildren = false;
            this._passInput.mouseEnabled = false;
            this._passInput.text = "";
         }
      }
      
      private function __frameEventHandler(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               if(FilterWordManager.IsNullorEmpty(this._nameInput.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                  SoundManager.instance.play("008");
               }
               else if(FilterWordManager.isGotForbiddenWords(this._nameInput.text,"name"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                  SoundManager.instance.play("008");
               }
               else if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passInput.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                  SoundManager.instance.play("008");
               }
               else
               {
                  GameInSocketOut.sendGameRoomSetUp(0,RoomInfo.MATCH_ROOM,false,this._passInput.text,this._nameInput.text,3,0,0,RoomManager.Instance.current.isCrossZone,0);
                  RoomManager.Instance.current.roomName = this._nameInput.text;
                  RoomManager.Instance.current.roomPass = this._passInput.text;
                  this.dispose();
               }
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function showMatchRoomSetView() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = this._frame;
      }
      
      public function dispose() : void
      {
         this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._soprts))
         {
            ObjectUtils.disposeObject(this._soprts);
         }
         this._soprts = null;
         if(Boolean(this._roomName))
         {
            ObjectUtils.disposeObject(this._roomName);
         }
         this._roomName = null;
         if(Boolean(this._password))
         {
            ObjectUtils.disposeObject(this._password);
         }
         this._password = null;
         if(Boolean(this._nameInput))
         {
            ObjectUtils.disposeObject(this._nameInput);
         }
         this._nameInput = null;
         if(Boolean(this._passInput))
         {
            ObjectUtils.disposeObject(this._passInput);
         }
         this._passInput = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._roomMode))
         {
            ObjectUtils.disposeObject(this._roomMode);
         }
         this._roomMode = null;
         if(Boolean(this._modelIcon))
         {
            ObjectUtils.disposeObject(this._modelIcon);
         }
         this._modelIcon = null;
         if(Boolean(this._checkBox))
         {
            ObjectUtils.disposeObject(this._checkBox);
         }
         this._checkBox = null;
         this._frame.dispose();
         this._frame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

