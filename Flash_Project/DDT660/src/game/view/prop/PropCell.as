package game.view.prop
{
   import bagAndInfo.cell.DragEffect;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.BitmapManager;
   import ddt.manager.DragManager;
   import ddt.manager.SharedManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.aswing.KeyboardManager;
   
   public class PropCell extends Sprite implements Disposeable, ITipedDisplay, IDragable, IAcceptDrag
   {
      
      protected var _x:int;
      
      protected var _y:int;
      
      protected var _enabled:Boolean = false;
      
      protected var _info:PropInfo;
      
      protected var _asset:DisplayObject;
      
      protected var _isExist:Boolean;
      
      protected var _back:DisplayObject;
      
      protected var _fore:DisplayObject;
      
      protected var _shortcutKey:String;
      
      protected var _shortcutKeyShape:DisplayObject;
      
      protected var _tipInfo:ToolPropInfo;
      
      protected var _tweenMax:TweenLite;
      
      protected var _localVisible:Boolean = true;
      
      protected var _mode:int;
      
      protected var _bitmapMgr:BitmapManager;
      
      private var _allowDrag:Boolean;
      
      private var _grayFilters:Array;
      
      private var _isUsed:Boolean;
      
      public function PropCell(shortcutKey:String = null, mode:int = -1, allowDrag:Boolean = false)
      {
         super();
         this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
         this._shortcutKey = shortcutKey;
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mode = mode;
         mouseChildren = false;
         this._allowDrag = allowDrag;
         this.configUI();
         this.addEvent();
      }
      
      public function get shortcutKey() : String
      {
         return this._shortcutKey;
      }
      
      public function get isUsed() : Boolean
      {
         return this._isUsed;
      }
      
      public function set isUsed(value:Boolean) : void
      {
         this._isUsed = value;
      }
      
      public function dragStart() : void
      {
         if(Boolean(this._info) && this._allowDrag)
         {
            if(this._enabled)
            {
               DragManager.startDrag(this,this._info,this._asset,stage.mouseX,stage.mouseY,"none",false,true,false,false,true);
            }
            else
            {
               this._asset.filters = this._grayFilters;
               DragManager.startDrag(this,this._info,this._asset,stage.mouseX,stage.mouseY,"none",false,true,false,false,true);
            }
         }
      }
      
      public function setGrayFilter() : void
      {
         filters = this._grayFilters;
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         KeyboardManager.getInstance().isStopDispatching = false;
         if(effect.target == null || effect.target is PropCell == false)
         {
            this.info = this._info;
         }
         var cell:PropCell = effect.target as PropCell;
         var tempInfo:PropInfo = cell.info;
         var tempEnabled:Boolean = cell._enabled;
         var tempId:int = int(SharedManager.Instance.GameKeySets[cell.shortcutKey]);
         cell.info = this.info;
         SharedManager.Instance.GameKeySets[cell.shortcutKey] = SharedManager.Instance.GameKeySets[this.shortcutKey];
         this.info = tempInfo;
         SharedManager.Instance.GameKeySets[this.shortcutKey] = tempId;
         SharedManager.Instance.save();
         cell.enabled = this.enabled;
         this.enabled = tempEnabled;
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         if(this._allowDrag)
         {
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function set tipData(value:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 20;
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 20;
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "core.ToolPropTips";
      }
      
      public function set tipStyle(value:String) : void
      {
      }
      
      protected function configUI() : void
      {
         this._back = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemBack",null,false,true);
         addChild(this._back);
         this._fore = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemFore",null,false,true);
         this._fore.y = 2;
         this._fore.x = 2;
         addChild(this._fore);
         if(this._shortcutKey != null)
         {
            this._shortcutKeyShape = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + this._shortcutKey);
            Bitmap(this._shortcutKeyShape).smoothing = true;
            this._shortcutKeyShape.y = -2;
            addChild(this._shortcutKeyShape);
         }
         this._tipInfo = new ToolPropInfo();
         this._tipInfo.showThew = true;
         this.drawLayer();
      }
      
      protected function drawLayer() : void
      {
         if(this._shortcutKey == null)
         {
            return;
         }
         if(this._mode == FightPropMode.VERTICAL)
         {
            this._shortcutKeyShape.x = 36 - this._shortcutKeyShape.width;
         }
         else
         {
            this._shortcutKeyShape.x = 0;
         }
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      protected function __mouseOut(event:MouseEvent) : void
      {
         x = this._x;
         y = this._y;
         scaleX = scaleY = 1;
         if(this._shortcutKey != null)
         {
            this._shortcutKeyShape.scaleX = this._shortcutKeyShape.scaleY = 1;
         }
         if(Boolean(this._tweenMax))
         {
            this._tweenMax.pause();
         }
         if(this._enabled)
         {
            filters = null;
         }
         else
         {
            filters = this._grayFilters;
         }
      }
      
      protected function __mouseOver(event:MouseEvent) : void
      {
         if(this._info != null)
         {
            if(this._shortcutKey != null)
            {
               this._shortcutKeyShape.scaleX = this._shortcutKeyShape.scaleY = 0.9;
            }
            x = this._x - 3.6;
            y = this._y - 3.6;
            scaleX = scaleY = 1.2;
            if(this.enabled)
            {
               if(this._tweenMax == null)
               {
                  this._tweenMax = TweenMax.to(this,0.5,{
                     "repeat":-1,
                     "yoyo":true,
                     "glowFilter":{
                        "color":16777011,
                        "alpha":1,
                        "blurX":4,
                        "blurY":4,
                        "strength":3
                     }
                  });
               }
               this._tweenMax.play();
            }
            if(Boolean(parent))
            {
               parent.setChildIndex(this,parent.numChildren - 1);
            }
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      public function setMode(mode:int) : void
      {
         this._mode = mode;
         this.drawLayer();
      }
      
      public function set info(val:PropInfo) : void
      {
         var bitmap:Bitmap = null;
         ShowTipManager.Instance.removeTip(this);
         this._info = val;
         var asset:DisplayObject = this._asset;
         if(this._info != null)
         {
            bitmap = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + this._info.Template.Pic + "Asset");
            if(Boolean(bitmap))
            {
               bitmap.smoothing = true;
               bitmap.x = bitmap.y = 1;
               bitmap.width = bitmap.height = 35;
               addChildAt(bitmap,getChildIndex(this._fore));
            }
            this._asset = bitmap;
            this._tipInfo.info = this._info.Template;
            this._tipInfo.shortcutKey = this._shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
         }
         else
         {
            buttonMode = false;
         }
         if(asset != null)
         {
            ObjectUtils.disposeObject(asset);
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(val:Boolean) : void
      {
         if(this._enabled != val)
         {
            this._enabled = val;
            if(!this._enabled)
            {
               filters = this._grayFilters;
            }
            else
            {
               filters = null;
            }
         }
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function set isExist(val:Boolean) : void
      {
         this._isExist = val;
      }
      
      public function setPossiton(x:int, y:int) : void
      {
         this._x = x;
         this._y = y;
         this.x = this._x;
         this.y = this._y;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this);
         filters = null;
         if(Boolean(this._tweenMax))
         {
            this._tweenMax.kill();
         }
         this._tweenMax = null;
         ObjectUtils.disposeObject(this._asset);
         this._asset = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._fore);
         this._fore = null;
         ObjectUtils.disposeObject(this._shortcutKeyShape);
         this._shortcutKeyShape = null;
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         TweenLite.killTweensOf(this);
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function useProp() : void
      {
         if(this._localVisible)
         {
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function get localVisible() : Boolean
      {
         return this._localVisible;
      }
      
      public function setVisible(val:Boolean) : void
      {
         if(this._localVisible != val)
         {
            this._localVisible = val;
         }
      }
   }
}

