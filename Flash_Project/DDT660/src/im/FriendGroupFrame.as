package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import im.info.CustomInfo;
   
   public class FriendGroupFrame extends Frame
   {
      
      private var _confirm:TextButton;
      
      private var _close:TextButton;
      
      private var _combox:ComboBox;
      
      public var nickName:String;
      
      private var _customList:Vector.<CustomInfo>;
      
      public function FriendGroupFrame()
      {
         var font:Bitmap = null;
         super();
         font = ComponentFactory.Instance.creatBitmap("asset.awardSystem.addFriendFont");
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.confirm");
         this._confirm.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         this._close = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.close");
         this._close.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         this._combox = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.choose");
         addToContent(font);
         addToContent(this._confirm);
         addToContent(this._close);
         addToContent(this._combox);
         this._combox.beginChanges();
         this._combox.selctedPropName = "text";
         var comboxModel:VectorListModel = this._combox.listPanel.vectorListModel;
         comboxModel.clear();
         this._customList = PlayerManager.Instance.customList;
         var names:Array = new Array();
         for(var i:int = 0; i < this._customList.length - 1; i++)
         {
            names.push(this._customList[i].Name);
         }
         comboxModel.appendAll(names);
         this._combox.listPanel.list.updateListView();
         this._combox.commitChanges();
         this._combox.textField.text = this._customList[0].Name;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      protected function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __confirmHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         for(var i:int = 0; i < this._customList.length; i++)
         {
            if(this._customList[i].Name == this._combox.textField.text)
            {
               SocketManager.Instance.out.sendAddFriend(this.nickName,this._customList[i].ID);
               break;
            }
         }
         this.dispose();
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      protected function __buttonClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHandler);
         this._combox.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._combox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._customList = null;
         if(Boolean(this._confirm))
         {
            ObjectUtils.disposeObject(this._confirm);
         }
         this._confirm = null;
         if(Boolean(this._close))
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(Boolean(this._combox))
         {
            ObjectUtils.disposeObject(this._combox);
         }
         this._combox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         IMController.Instance.clearGroupFrame();
      }
   }
}

