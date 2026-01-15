package bagAndInfo.cell
{
   import beadSystem.beadSystemManager;
   import beadSystem.model.BeadInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.DragManager;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import magicStone.MagicStoneManager;
   
   [Event(name="change",type="flash.events.Event")]
   public class BaseCell extends Sprite implements ICell, ITipedDisplay, Disposeable
   {
      
      protected var _bg:DisplayObject;
      
      protected var _contentHeight:Number;
      
      protected var _contentWidth:Number;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _loadingasset:MovieClip;
      
      protected var _pic:CellContentCreator;
      
      protected var _picPos:Point;
      
      protected var _showLoading:Boolean;
      
      protected var _showTip:Boolean;
      
      protected var _smallPic:Sprite;
      
      protected var _tipData:Object;
      
      protected var _tipDirection:String;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _tipStyle:String;
      
      protected var _allowDrag:Boolean;
      
      private var _overBg:DisplayObject;
      
      private var _locked:Boolean;
      
      private var _isSurpriseRouletteCellGQ:Boolean = false;
      
      public function BaseCell(bg:DisplayObject, $info:ItemTemplateInfo = null, showLoading:Boolean = true, showTip:Boolean = true)
      {
         super();
         this._bg = bg;
         this._showLoading = showLoading;
         this._showTip = showTip;
         this.init();
         this.initTip();
         this.initEvent();
         this.info = $info;
      }
      
      public function set overBg(value:DisplayObject) : void
      {
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = value;
         if(Boolean(this._overBg))
         {
            this._overBg.visible = false;
            addChildAt(this._overBg,1);
         }
      }
      
      public function get overBg() : DisplayObject
      {
         return this._overBg;
      }
      
      public function set PicPos(value:Point) : void
      {
         this._picPos = value;
         this.updateSize(this._pic);
      }
      
      public function get allowDrag() : Boolean
      {
         return this._allowDrag;
      }
      
      public function set allowDrag(value:Boolean) : void
      {
         this._allowDrag = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this.clearLoading();
         this.clearCreatingContent();
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
      }
      
      public function dragStart() : void
      {
         if(this._info && !this.locked && stage && this._allowDrag)
         {
            if(DragManager.startDrag(this,this._info,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               this.locked = true;
            }
         }
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         if(effect.action == DragEffect.NONE)
         {
            this.locked = false;
         }
      }
      
      public function get editLayer() : int
      {
         return this._pic.editLayer;
      }
      
      public function getContent() : Sprite
      {
         return this._pic;
      }
      
      public function getSmallContent() : Sprite
      {
         this._pic.height = 40;
         this._pic.width = 40;
         return this._pic;
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function set grayFilters(b:Boolean) : void
      {
         if(b)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      override public function get height() : Number
      {
         return this._bg.height + this._bg.y * 2;
      }
      
      public function get info() : ItemTemplateInfo
      {
         if(this._info == null)
         {
            return null;
         }
         return this._info;
      }
      
      public function set info(value:ItemTemplateInfo) : void
      {
         var vItemInfo:InventoryItemInfo = null;
         var tempBeadInfo:BeadInfo = null;
         if(this._info == value && !this._info)
         {
            return;
         }
         if(Boolean(this._info))
         {
            this.clearCreatingContent();
            ObjectUtils.disposeObject(this._pic);
            this._pic = null;
            this.clearLoading();
            this._tipData = null;
            this.locked = false;
         }
         this._info = value;
         if(Boolean(this._info))
         {
            if(this._showLoading)
            {
               this.createLoading();
            }
            this._pic = new CellContentCreator();
            this._pic.info = this._info;
            this._pic.loadSync(this.createContentComplete);
            addChild(this._pic);
            if(EquipType.isCardBox(this.info))
            {
               this.tipStyle = "core.CardBoxTipPanel";
               this.tipData = this._info;
            }
            else if(this._info.CategoryID != EquipType.CARDEQUIP)
            {
               this.tipStyle = "core.GoodsTip";
               this._tipData = new GoodTipInfo();
               GoodTipInfo(this._tipData).itemInfo = this.info;
               vItemInfo = this.info as InventoryItemInfo;
               if(this.info.Property1 == "31")
               {
                  if(Boolean(vItemInfo) && vItemInfo.Hole2 > 0)
                  {
                     GoodTipInfo(this._tipData).exp = vItemInfo.Hole2;
                     GoodTipInfo(this._tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[vItemInfo.Hole1 + 1];
                     GoodTipInfo(this._tipData).beadName = vItemInfo.Name + "-" + beadSystemManager.Instance.getBeadName(vItemInfo);
                  }
                  else
                  {
                     tempBeadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(this.info.TemplateID);
                     if(Boolean(tempBeadInfo))
                     {
                        GoodTipInfo(this._tipData).exp = ServerConfigManager.instance.getBeadUpgradeExp()[tempBeadInfo.BaseLevel];
                        GoodTipInfo(this._tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[tempBeadInfo.BaseLevel + 1];
                        GoodTipInfo(this._tipData).beadName = value.Name + "-" + tempBeadInfo.Name + "Lv" + tempBeadInfo.BaseLevel;
                     }
                     else
                     {
                        GoodTipInfo(this._tipData).exp = 0;
                        GoodTipInfo(this._tipData).upExp = 0;
                        GoodTipInfo(this._tipData).beadName = "";
                     }
                  }
               }
               else if(this.info.Property1 == "81")
               {
                  if(Boolean(vItemInfo) && vItemInfo.StrengthenExp > 0)
                  {
                     GoodTipInfo(this._tipData).exp = vItemInfo.StrengthenExp - MagicStoneManager.instance.getNeedExp(this.info.TemplateID,vItemInfo.StrengthenLevel);
                  }
                  else
                  {
                     GoodTipInfo(this._tipData).exp = 0;
                  }
                  GoodTipInfo(this._tipData).upExp = MagicStoneManager.instance.getNeedExpPerLevel(this.info.TemplateID,this.info.Level + 1);
                  GoodTipInfo(this._tipData).beadName = this.info.Name + "Lv" + this.info.Level;
               }
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(value:Boolean) : void
      {
         if(this._locked == value)
         {
            return;
         }
         this._locked = value;
         this.updateLockState();
         if(this._info is InventoryItemInfo)
         {
            this._info["lock"] = this._locked;
         }
         dispatchEvent(new CellEvent(CellEvent.LOCK_CHANGED));
      }
      
      public function setColor(color:*) : Boolean
      {
         return this._pic.setColor(color);
      }
      
      public function setContentSize(cWidth:Number, cHeight:Number) : void
      {
         this._contentWidth = cWidth;
         this._contentHeight = cHeight;
         this.updateSize(this._pic);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirection = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      protected function clearCreatingContent() : void
      {
         if(this._pic == null)
         {
            return;
         }
         if(Boolean(this._pic.parent))
         {
            this._pic.parent.removeChild(this._pic);
         }
         this._pic.clearLoader();
         this._pic.dispose();
         this._pic = null;
      }
      
      protected function createChildren() : void
      {
         this._contentWidth = this._bg.width - 2;
         this._contentHeight = this._bg.height - 2;
         addChildAt(this._bg,0);
         this._pic = new CellContentCreator();
      }
      
      protected function createContentComplete() : void
      {
         this.clearLoading();
         this.updateSize(this._pic);
      }
      
      protected function createDragImg() : DisplayObject
      {
         var img:Bitmap = null;
         if(this._pic && this._pic.width > 0 && this._pic.height > 0)
         {
            img = new Bitmap(new BitmapData(this._pic.width / this._pic.scaleX,this._pic.height / this._pic.scaleY,true,0));
            img.bitmapData.draw(this._pic);
            return img;
         }
         return null;
      }
      
      protected function createLoading() : void
      {
         if(this._loadingasset == null)
         {
            this._loadingasset = ComponentFactory.Instance.creat("bagAndInfo.cell.BaseCellLoadingAsset");
         }
         this.updateSizeII(this._loadingasset);
         PositionUtils.setPos(this._loadingasset,"ddt.core.baseCell.loadingPos");
         addChild(this._loadingasset);
      }
      
      protected function init() : void
      {
         this._allowDrag = true;
         if(this._showTip)
         {
            ShowTipManager.Instance.addTip(this);
         }
         this.createChildren();
      }
      
      protected function initTip() : void
      {
         this.tipDirctions = "7,6,2,1,5,4,0,3,6";
         this.tipGapV = 10;
         this.tipGapH = 10;
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      protected function onMouseClick(evt:MouseEvent) : void
      {
      }
      
      protected function onMouseOut(evt:MouseEvent) : void
      {
         if(Boolean(this._overBg))
         {
            this._overBg.visible = false;
         }
      }
      
      protected function onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._overBg))
         {
            this._overBg.visible = true;
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.width = this._contentWidth - 2;
            sp.height = this._contentHeight - 2;
            if(this._picPos != null)
            {
               sp.x = this._picPos.x;
            }
            else
            {
               sp.x = Math.abs(sp.width - this._contentWidth) / 2;
            }
            if(this._picPos != null)
            {
               sp.y = this._picPos.y;
            }
            else
            {
               sp.y = Math.abs(sp.height - this._contentHeight) / 2;
            }
         }
      }
      
      protected function clearLoading() : void
      {
         if(Boolean(this._loadingasset))
         {
            this._loadingasset.stop();
         }
         ObjectUtils.disposeObject(this._loadingasset);
         this._loadingasset = null;
      }
      
      private function updateLockState() : void
      {
         if(this._locked)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      public function set surpriseRouletteCellGQ(value:Boolean) : void
      {
         this._isSurpriseRouletteCellGQ = value;
      }
      
      protected function updateSizeII(sp:Sprite) : void
      {
         if(this._isSurpriseRouletteCellGQ && Boolean(sp))
         {
            if(this._picPos != null)
            {
               sp.x = this._picPos.x - 2;
            }
            else
            {
               sp.x = Math.abs(sp.width - this._contentWidth) / 2;
            }
            if(this._picPos != null)
            {
               sp.y = this._picPos.y - 2;
            }
            else
            {
               sp.y = Math.abs(sp.height - this._contentHeight) / 2;
            }
         }
      }
   }
}

