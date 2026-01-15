package church.view.menu
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MenuPanel extends Sprite
   {
      
      public static const STARTPOS:int = 10;
      
      public static const STARTPOS_OFSET:int = 18;
      
      public static const GUEST_X:int = 9;
      
      public static const THIS_X_OFSET:int = 95;
      
      public static const THIS_Y_OFSET:int = 55;
      
      private var _info:PlayerInfo;
      
      private var _kickGuest:MenuItem;
      
      private var _blackGuest:MenuItem;
      
      private var _bg:ScaleBitmapImage;
      
      public function MenuPanel()
      {
         var startPos:Number = NaN;
         super();
         this._bg = ComponentFactory.Instance.creat("church.weddingRoom.guestListMenuBg");
         addChildAt(this._bg,0);
         startPos = STARTPOS;
         this._kickGuest = new MenuItem(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom"));
         this._kickGuest.x = GUEST_X;
         this._kickGuest.y = startPos;
         startPos += STARTPOS_OFSET;
         this._kickGuest.addEventListener("menuClick",this.__menuClick);
         addChild(this._kickGuest);
         this._blackGuest = new MenuItem(LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.btnText"));
         this._blackGuest.x = GUEST_X;
         this._blackGuest.y = startPos;
         startPos += STARTPOS_OFSET;
         this._blackGuest.addEventListener("menuClick",this.__menuClick);
         addChild(this._blackGuest);
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         this._info = value;
      }
      
      private function __mouseClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      private function __menuClick(event:Event) : void
      {
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.menu.MenuPanel.menuClick"));
            return;
         }
         if(Boolean(this._info))
         {
            switch(event.currentTarget)
            {
               case this._kickGuest:
                  SocketManager.Instance.out.sendChurchKick(this._info.ID);
                  break;
               case this._blackGuest:
                  SocketManager.Instance.out.sendChurchForbid(this._info.ID);
            }
         }
      }
      
      public function show() : void
      {
         var pos:Point = null;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         if(Boolean(stage) && Boolean(parent))
         {
            pos = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY));
            this.x = pos.x;
            this.y = pos.y;
            if(x + THIS_X_OFSET > stage.stageWidth)
            {
               this.x = x - THIS_X_OFSET;
            }
            if(y + THIS_Y_OFSET > stage.stageHeight)
            {
               y = stage.stageHeight - THIS_Y_OFSET;
            }
         }
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._blackGuest.removeEventListener("menuClick",this.__menuClick);
         this._info = null;
         if(Boolean(this._kickGuest) && Boolean(this._kickGuest.parent))
         {
            this._kickGuest.parent.removeChild(this._kickGuest);
         }
         if(Boolean(this._kickGuest))
         {
            this._kickGuest.dispose();
         }
         this._kickGuest = null;
         if(Boolean(this._blackGuest) && Boolean(this._blackGuest.parent))
         {
            this._blackGuest.parent.removeChild(this._blackGuest);
         }
         if(Boolean(this._blackGuest))
         {
            this._blackGuest.dispose();
         }
         this._blackGuest = null;
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

