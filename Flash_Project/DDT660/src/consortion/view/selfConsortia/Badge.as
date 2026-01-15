package consortion.view.selfConsortia
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.BadgeInfo;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Badge extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const LARGE:String = "large";
      
      public static const NORMAL:String = "normal";
      
      public static const SMALL:String = "small";
      
      private static const LARGE_SIZE:int = 78;
      
      private static const NORMAL_SIZE:int = 48;
      
      private static const SMALL_SIZE:int = 28;
      
      private var _size:String = "large";
      
      private var _badgeID:int = -1;
      
      private var _buyDate:Date;
      
      private var _badge:Bitmap;
      
      private var _loader:BitmapLoader;
      
      private var _clickEnale:Boolean = false;
      
      private var _tipInfo:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String = "consortion.view.selfConsortia.BadgeTip";
      
      private var _showTip:Boolean;
      
      public function Badge(size:String = "small")
      {
         super();
         this._size = size;
         graphics.beginFill(16777215,0);
         var s:int = 0;
         if(this._size == LARGE)
         {
            s = LARGE_SIZE;
         }
         else if(this._size == NORMAL)
         {
            s = NORMAL_SIZE;
         }
         else if(this._size == SMALL)
         {
            s = SMALL_SIZE;
         }
         graphics.drawRect(0,0,s,s);
         graphics.endFill();
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         if(this._size == SMALL)
         {
            this._tipStyle = "ddt.view.tips.OneLineTip";
         }
         else
         {
            this._tipStyle = "consortion.view.selfConsortia.BadgeTip";
         }
      }
      
      public function get showTip() : Boolean
      {
         return this._showTip;
      }
      
      public function set showTip(value:Boolean) : void
      {
         this._showTip = value;
         if(this._showTip)
         {
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            ShowTipManager.Instance.removeTip(this);
         }
      }
      
      public function get clickEnale() : Boolean
      {
         return this._clickEnale;
      }
      
      public function set clickEnale(value:Boolean) : void
      {
         if(value == this._clickEnale)
         {
            return;
         }
         this._clickEnale = value;
         if(this._clickEnale)
         {
            addEventListener(MouseEvent.CLICK,this.onClick);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function onClick(event:MouseEvent) : void
      {
         var shopFrame:BadgeShopFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.badgeShopFrame");
         LayerManager.Instance.addToLayer(shopFrame,LayerManager.GAME_DYNAMIC_LAYER,true);
      }
      
      public function get buyDate() : Date
      {
         return this._buyDate;
      }
      
      public function set buyDate(value:Date) : void
      {
         this._buyDate = value;
      }
      
      public function get badgeID() : int
      {
         return this._badgeID;
      }
      
      public function set badgeID(value:int) : void
      {
         if(value == this._badgeID)
         {
            return;
         }
         this._badgeID = value;
         this.getTipInfo();
         this.updateView();
      }
      
      private function getTipInfo() : void
      {
         this._tipInfo = {};
         var badgeinfo:BadgeInfo = BadgeInfoManager.instance.getBadgeInfoByID(this._badgeID);
         if(Boolean(badgeinfo))
         {
            this._tipInfo.name = badgeinfo.BadgeName;
            this._tipInfo.LimitLevel = badgeinfo.LimitLevel;
            this._tipInfo.ValidDate = badgeinfo.ValidDate;
            if(Boolean(this._buyDate))
            {
               this._tipInfo.buyDate = this._buyDate;
            }
         }
      }
      
      private function updateView() : void
      {
         this.removeBadge();
         this._loader = LoadResourceManager.Instance.createLoader(PathManager.solveBadgePath(this._badgeID),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.addEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function removeBadge() : void
      {
         if(Boolean(this._badge))
         {
            if(Boolean(this._badge.parent))
            {
               this._badge.parent.removeChild(this._badge);
            }
            this._badge.bitmapData.dispose();
            this._badge = null;
         }
      }
      
      private function onComplete(event:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         if(this._loader.isSuccess)
         {
            this._badge = this._loader.content as Bitmap;
            this._badge.smoothing = true;
            if(this._size == LARGE)
            {
               this._badge.width = this._badge.height = LARGE_SIZE;
            }
            else if(this._size == NORMAL)
            {
               this._badge.width = this._badge.height = NORMAL_SIZE;
            }
            else
            {
               this._badge.width = this._badge.height = SMALL_SIZE;
            }
            addChild(this._badge);
         }
      }
      
      private function onError(event:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
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
         this._tipInfo = value;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
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
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         }
         this._loader = null;
         this._tipInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

