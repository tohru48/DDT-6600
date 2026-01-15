package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.view.smallMap.SmallBox;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class SimpleBox extends SimpleObject
   {
      
      private var _dieMC:MovieClipWrapper;
      
      private var _box:ScaleFrameImage;
      
      private var _ghostBox:MovieClip;
      
      private var _smallBox:SmallObject;
      
      private var _isGhostBox:Boolean;
      
      private var _subType:int = 0;
      
      private var _localVisible:Boolean = true;
      
      private var _constainer:DisplayObjectContainer;
      
      private var _self:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
      
      private var _visible:Boolean = true;
      
      public function SimpleBox(id:int, model:String, subType:int = 1)
      {
         this._subType = subType;
         super(id,1,model,"");
         this.x = x;
         this.y = y;
         _canCollided = true;
         if(this.isGhost)
         {
            setCollideRect(-8,-8,16,16);
         }
         else
         {
            setCollideRect(-15,-15,30,30);
         }
         this._smallBox = new SmallBox();
         this._isGhostBox = false;
         if(this.isGhost)
         {
            _canCollided = this.visible = !this._self.isLiving;
            this.smallView.visible = false;
         }
         else
         {
            this.smallView.visible = _canCollided = this.visible = this._self.isLiving;
         }
         this.addEvent();
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallBox;
      }
      
      override public function get layer() : int
      {
         if(this._isGhostBox)
         {
            return PhysicsLayer.GhostBox;
         }
         return super.layer;
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.DIE,this.__onSelfPlayerDie);
         this._self.addEventListener(LivingEvent.REVIVE,this.__onSelfPlayerRevive);
      }
      
      private function __click(evt:MouseEvent) : void
      {
         if(Boolean(parent))
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.DIE,this.__onSelfPlayerDie);
         this._self.removeEventListener(LivingEvent.REVIVE,this.__onSelfPlayerRevive);
         removeEventListener(MouseEvent.CLICK,this.__click);
         if(Boolean(this._dieMC))
         {
            this._dieMC.removeEventListener(Event.COMPLETE,this.__boxDieComplete);
         }
      }
      
      public function get isGhost() : Boolean
      {
         return this._subType > 1;
      }
      
      public function get subType() : int
      {
         return this._subType;
      }
      
      public function get psychic() : int
      {
         return GhostBoxModel.getInstance().getPsychicByType(this._subType);
      }
      
      protected function setIsGhost(value:Boolean) : void
      {
         if(value == this._isGhostBox)
         {
            return;
         }
         this._isGhostBox = value;
         if(!this._isGhostBox == GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            this.visible = true;
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function pickByLiving(living:Living) : void
      {
         living.pick(this);
         if(!this._self.isLiving)
         {
            SoundManager.instance.play("018");
         }
         this.die();
      }
      
      override protected function creatMovie(model:String) : void
      {
         if(this.isGhost)
         {
            this._ghostBox = ClassUtils.CreatInstance("asset.game.GhostBox" + (this._subType - 1)) as MovieClip;
            this._ghostBox.mouseChildren = this._ghostBox.mouseEnabled = false;
            this._ghostBox.visible = this.isGhost;
            this._ghostBox.x = this._ghostBox.y = 4;
            this._ghostBox.gotoAndPlay("stand");
            addChild(this._ghostBox);
         }
         else
         {
            this._box = ComponentFactory.Instance.creatComponentByStylename("asset.game.simpleBoxPicAsset");
            this._box.x = -this._box.width >> 1;
            this._box.y = -this._box.height >> 1;
            this._box.setFrame(int(model));
            addChild(this._box);
         }
      }
      
      public function setContainer(constainer:DisplayObjectContainer) : void
      {
         this._constainer = constainer;
         if(super.visible)
         {
            if(this.isGhost)
            {
               if(!this._self.isLiving && !parent)
               {
                  this._constainer.addChild(this);
               }
            }
            else
            {
               this._constainer.addChild(this);
            }
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(!this._self.isLiving)
         {
            if(this.isGhost && RoomManager.Instance.current && (RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM))
            {
               super.visible = false;
            }
            else
            {
               super.visible = value && this.isGhost;
            }
         }
         else
         {
            super.visible = value && !this.isGhost;
         }
      }
      
      override public function collidedByObject(obj:PhysicalObj) : void
      {
         if(obj is SimpleBomb)
         {
            SimpleBomb(obj).owner.pick(this);
            if(!this.isGhost && this._self.isLiving)
            {
               SoundManager.instance.play("018");
            }
            this.die();
         }
      }
      
      override public function die() : void
      {
         var movie:MovieClip = null;
         if(!_isLiving)
         {
            return;
         }
         _canCollided = false;
         if(visible)
         {
            if(this.isGhost)
            {
               movie = ClassUtils.CreatInstance("asset.game.GhostBoxDie") as MovieClip;
               if(Boolean(this._ghostBox) && Boolean(this._ghostBox.parent))
               {
                  this._ghostBox.stop();
                  this._ghostBox.parent.removeChild(this._ghostBox);
               }
            }
            else
            {
               movie = ClassUtils.CreatInstance("asset.game.pickBoxAsset") as MovieClip;
               if(Boolean(this._box) && Boolean(this._box.parent))
               {
                  this._box.parent.removeChild(this._box);
               }
            }
            this._dieMC = new MovieClipWrapper(movie,true,true);
            this._dieMC.addEventListener(Event.COMPLETE,this.__boxDieComplete);
            addChild(this._dieMC.movie);
            this.smallView.visible = false;
         }
         super.die();
      }
      
      protected function __boxDieComplete(event:Event) : void
      {
         if(Boolean(this._dieMC))
         {
            this._dieMC.removeEventListener(Event.COMPLETE,this.__boxDieComplete);
            this.dispose();
         }
      }
      
      override public function isBox() : Boolean
      {
         return true;
      }
      
      override public function get canCollided() : Boolean
      {
         if(this.isGhost)
         {
            return !this._self.isLiving;
         }
         return _canCollided;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._dieMC);
         this._dieMC = null;
         ObjectUtils.disposeObject(this._smallBox);
         this._smallBox = null;
         ObjectUtils.disposeObject(this._ghostBox);
         this._ghostBox = null;
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         this._self = null;
         super.dispose();
      }
      
      override public function playAction(action:String) : void
      {
         switch(action)
         {
            case "BoxNormal":
               this._box.visible = true;
               this.setIsGhost(false);
               break;
            case "BoxColorChanged":
               if(Boolean(this._box))
               {
                  this._box.visible = false;
               }
               this.setIsGhost(true);
               break;
            case "BoxColorRestored":
               if(Boolean(this._box))
               {
                  this._box.visible = false;
               }
               this.setIsGhost(true);
         }
      }
      
      private function __onSelfPlayerDie(evt:Event) : void
      {
         if(!this._self.isLast)
         {
            this.visible = this.isGhost;
         }
      }
      
      private function __onSelfPlayerRevive(evt:Event) : void
      {
         if(this.isGhost)
         {
            this.visible = false;
         }
      }
   }
}

