package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   import im.IMController;
   
   public class ClubRecordItem extends Sprite implements Disposeable
   {
      
      private static var RECORDITEM_HEIGHT:int = 30;
      
      private var _info:*;
      
      private var _type:int;
      
      private var _name:FilterFrameText;
      
      private var _button:TextButton;
      
      private var _contactChairmanBtn:TextButton;
      
      private var _copyName:TextButton;
      
      public function ClubRecordItem(type:int)
      {
         super();
         this._type = type;
         this.init();
      }
      
      override public function get height() : Number
      {
         return RECORDITEM_HEIGHT;
      }
      
      private function init() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("club.recordItem.name");
         this._contactChairmanBtn = ComponentFactory.Instance.creatComponentByStylename("club.contactChairmanBtn");
         this._copyName = ComponentFactory.Instance.creatComponentByStylename("club.copyNameBtn");
         if(this._type == ClubRecordList.INVITE)
         {
            this._button = ComponentFactory.Instance.creatComponentByStylename("club.acceptInvent");
            this._button.text = LanguageMgr.GetTranslation("club.acceptInvent.text");
         }
         else
         {
            this._button = ComponentFactory.Instance.creatComponentByStylename("club.cancelApply");
            this._button.text = LanguageMgr.GetTranslation("club.cancelApplyText");
            this._copyName.addEventListener(MouseEvent.CLICK,this.__copyHandler);
            this._contactChairmanBtn.addEventListener(MouseEvent.CLICK,this.__contactChairman);
            addChild(this._contactChairmanBtn);
            addChild(this._copyName);
         }
         this._contactChairmanBtn.text = LanguageMgr.GetTranslation("club.contactChairmanBtnText");
         this._copyName.text = LanguageMgr.GetTranslation("club.copyNameBtnText");
         addChild(this._name);
         addChild(this._button);
         this._button.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __copyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         System.setClipboard(this._info.ChairmanName);
      }
      
      private function __contactChairman(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.alertPrivateFrame(this._info.ChairmanID);
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._type == ClubRecordList.INVITE)
         {
            SocketManager.Instance.out.sendConsortiaInvatePass(this._info.ID);
         }
         else
         {
            SocketManager.Instance.out.sendConsortiaTryinDelete(this._info.ID);
         }
      }
      
      public function set info(info:*) : void
      {
         this._info = info;
         this._name.text = info.ConsortiaName;
      }
      
      public function dispose() : void
      {
         this._button.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(Boolean(this._contactChairmanBtn))
         {
            this._contactChairmanBtn.removeEventListener(MouseEvent.CLICK,this.__contactChairman);
            ObjectUtils.disposeObject(this._contactChairmanBtn);
            this._contactChairmanBtn = null;
         }
         if(Boolean(this._copyName))
         {
            this._copyName.removeEventListener(MouseEvent.CLICK,this.__copyHandler);
            ObjectUtils.disposeObject(this._copyName);
            this._copyName = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._button))
         {
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

