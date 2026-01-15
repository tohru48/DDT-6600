package catchInsect.componets
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RoomMenuView extends Sprite implements Disposeable
   {
      
      private var _menuIsOpen:Boolean = true;
      
      private var _BG:Bitmap;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _switchIMG:ScaleFrameImage;
      
      private var _returnBtn:SimpleBitmapButton;
      
      public function RoomMenuView()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("catchInsect.room.menuBG");
         addChild(this._BG);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.switchBtn");
         addChild(this._closeBtn);
         this._switchIMG = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.switchIMG");
         this._switchIMG.setFrame(1);
         this._closeBtn.addChild(this._switchIMG);
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.returnBtn");
         addChild(this._returnBtn);
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.backRoomList);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.switchMenu);
      }
      
      private function backRoomList(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("catchInsect.leavingScene"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__frameResponse);
      }
      
      private function __frameResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse);
         switch(e.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.enterOrLeaveInsectScene(1);
               SoundManager.instance.play("008");
               dispatchEvent(new Event(Event.CLOSE));
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               alert.dispose();
         }
      }
      
      private function switchMenu(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._menuIsOpen)
         {
            this._switchIMG.setFrame(2);
         }
         else
         {
            this._switchIMG.setFrame(1);
         }
         addEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
      }
      
      private function menuShowOrHide(evt:Event) : void
      {
         var offset:int = 0;
         offset = 34;
         if(this._menuIsOpen)
         {
            this.x += 20;
            if(this.x >= StageReferance.stageWidth - offset)
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - offset;
               this._menuIsOpen = false;
            }
         }
         else
         {
            this.x -= 20;
            if(this.x <= StageReferance.stageWidth - this.width)
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - this.width + 5;
               this._menuIsOpen = true;
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._switchIMG);
         this._BG = null;
         this._closeBtn = null;
         this._switchIMG = null;
         this._returnBtn = null;
      }
   }
}

