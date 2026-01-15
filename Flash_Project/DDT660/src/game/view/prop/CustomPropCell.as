package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.FightPropEevnt;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.view.control.FightControlBar;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class CustomPropCell extends PropCell
   {
      
      private var _deleteBtn:SimpleBitmapButton;
      
      private var _type:int;
      
      private var _lockIcon:Bitmap;
      
      private var _isLock:Boolean = false;
      
      private var _countTxt:FilterFrameText;
      
      public function CustomPropCell(shortcutKey:String, mode:int, type:int)
      {
         super(shortcutKey,mode);
         this._type = type;
         mouseChildren = false;
         if(Boolean(this._type))
         {
            _tipInfo.valueType = null;
         }
      }
      
      public function set isLock(value:Boolean) : void
      {
         if(value)
         {
            this._lockIcon.visible = true;
            this.info = null;
         }
         else
         {
            this._lockIcon.visible = false;
         }
         this._isLock = value;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._deleteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn");
         this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.game.onlyLockIcon");
         this._lockIcon.visible = false;
         addChild(this._lockIcon);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("game.customPropCell.countTxt");
         this._countTxt.visible = false;
         addChild(this._countTxt);
      }
      
      override protected function drawLayer() : void
      {
      }
      
      override protected function __mouseOut(event:MouseEvent) : void
      {
         if(Boolean(this._deleteBtn.parent))
         {
            removeChild(this._deleteBtn);
         }
         x = _x;
         y = _y;
         scaleX = scaleY = 1;
         _shortcutKeyShape.scaleX = _shortcutKeyShape.scaleY = 1;
         if(Boolean(_tweenMax))
         {
            _tweenMax.pause();
         }
         filters = null;
      }
      
      override protected function __mouseOver(event:MouseEvent) : void
      {
         if(GameManager.Instance.Current.mapIndex != 1405)
         {
            if(_info && !(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM) && _info.TemplateID != 10471)
            {
               if(RoomManager.Instance.current.type != RoomInfo.TREASURELOST_ROOM)
               {
                  addChild(this._deleteBtn);
               }
            }
         }
         super.__mouseOver(event);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         addEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function __deleteClick(event:MouseEvent) : void
      {
      }
      
      private function deleteContainMouse() : Boolean
      {
         var rect:Rectangle = this._deleteBtn.getBounds(this);
         return rect.contains(mouseX,mouseY);
      }
      
      private function deleteProp() : void
      {
         dispatchEvent(new FightPropEevnt(FightPropEevnt.DELETEPROP));
      }
      
      private function __clicked(event:MouseEvent) : void
      {
         StageReferance.stage.focus = null;
         var self:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         if(_info && _info.TemplateID == 10467 && !self.usePassBall)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.usePassBall"));
            return;
         }
         if(Boolean(this._deleteBtn.parent) && this.deleteContainMouse())
         {
            this.deleteProp();
         }
         else
         {
            this.useProp();
         }
      }
      
      override public function set enabled(val:Boolean) : void
      {
         if(_enabled != val)
         {
            _enabled = val;
            if(!_enabled)
            {
               if(Boolean(_asset))
               {
                  _asset.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               this.__mouseOut(null);
            }
            else if(Boolean(_asset))
            {
               _asset.filters = null;
            }
         }
      }
      
      override public function useProp() : void
      {
         var self:LocalPlayer = null;
         if(_info != null && !isUsed)
         {
            if(_info.Template.CategoryID == 10 && _info.Template.Property1 == "54")
            {
               if(!GameManager.Instance.Current.selfGamePlayer.isAttacking)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotAttacking"));
                  return;
               }
               if(!GameManager.Instance.Current.isHasOneDead)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.game.reviveItem.cannotUseTxt"));
                  return;
               }
            }
            self = GameManager.Instance.Current.selfGamePlayer;
            if(_info && _info.TemplateID == 10611 && !self.usePassBall)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.usePassBall"));
               return;
            }
            isUsed = true;
            setTimeout(this.resetIsUse,1000);
            dispatchEvent(new FightPropEevnt(FightPropEevnt.USEPROP));
         }
      }
      
      private function resetIsUse() : void
      {
         isUsed = false;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      override public function set info(val:PropInfo) : void
      {
         var bitmap:Bitmap = null;
         if(this._isLock)
         {
            return;
         }
         ShowTipManager.Instance.removeTip(this);
         _info = val;
         var asset:DisplayObject = _asset;
         if(_info != null)
         {
            bitmap = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + _info.Template.Pic + "Asset");
            if(Boolean(bitmap))
            {
               bitmap.smoothing = true;
               bitmap.x = bitmap.y = 1;
               bitmap.width = bitmap.height = 35;
               addChildAt(bitmap,getChildIndex(_fore));
            }
            if(Boolean(_asset))
            {
               bitmap.filters = _asset.filters;
            }
            _asset = bitmap;
            _tipInfo.info = _info.Template;
            _tipInfo.shortcutKey = _shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
            if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               this._countTxt.text = (_info.Template as InventoryItemInfo).Count.toString();
               this._countTxt.visible = true;
            }
         }
         else
         {
            buttonMode = false;
            this._countTxt.visible = false;
         }
         if(asset != null)
         {
            ObjectUtils.disposeObject(asset);
         }
         isUsed = false;
         if(_info == null)
         {
            this.__mouseOut(null);
         }
      }
      
      public function setCount(count:int) : void
      {
         this._countTxt.text = count.toString();
         this._countTxt.visible = true;
      }
      
      override public function setPossiton(x:int, y:int) : void
      {
         super.setPossiton(x,y);
         this.x = _x;
         this.y = _y;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._deleteBtn))
         {
            ObjectUtils.disposeObject(this._deleteBtn);
            this._deleteBtn = null;
         }
         ObjectUtils.disposeObject(this._lockIcon);
         this._lockIcon = null;
         super.dispose();
      }
      
      override public function get tipDirctions() : String
      {
         if(this._type != FightControlBar.LIVE)
         {
            return "4,5,7,1,6,2";
         }
         return super.tipDirctions;
      }
   }
}

