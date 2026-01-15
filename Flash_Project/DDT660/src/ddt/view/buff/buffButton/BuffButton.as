package ddt.view.buff.buffButton
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.BuffTipInfo;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuffButton extends Sprite implements Disposeable, ITipedDisplay
   {
      
      protected static var Setting:Boolean = false;
      
      protected var _info:BuffInfo;
      
      private var _canClick:Boolean;
      
      protected var _tipStyle:String;
      
      protected var _tipData:BuffTipInfo;
      
      protected var _tipDirctions:String;
      
      protected var _tipGapV:int;
      
      protected var _tipGapH:int;
      
      public function BuffButton(bgString:String)
      {
         super();
         /*
		 var bm:Bitmap = ComponentFactory.Instance.creatBitmap(bgString);
         bm.height = 33;
         bm.width = 33;
         addChild(bm);
		 */
         this._canClick = true;
         buttonMode = this._canClick;
         this._tipStyle = "core.buffTip";
         this._tipGapV = 2;
         this._tipGapH = 2;
         this._tipDirctions = "7,6,5,1,6,4";
         ShowTipManager.Instance.addTip(this);
         this.initEvents();
      }
      
      public static function createBuffButton(buffID:int, str:String = "") : BuffButton
      {
         var doubleExp:BuffButton = null;
         var doubleGeste:BuffButton = null;
         switch(buffID)
         {
            case 0:
               return new DoubExpBuffButton();
            case 1:
               return new DoubGesteBuffButton();
            case 2:
               return new DoublePrestigeBuffButton();
            case 3:
               return new DoubleContributeButton();
            default:
               return null;
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onclick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      protected function __onclick(evt:MouseEvent) : void
      {
         if(!this.CanClick)
         {
            return;
         }
         SoundManager.instance.play("008");
      }
      
      protected function __onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._info) && this._info.IsExist)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      protected function __onMouseOut(evt:MouseEvent) : void
      {
         if(Boolean(this._info) && this._info.IsExist)
         {
            filters = null;
         }
      }
      
      protected function checkBagLocked() : Boolean
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         return true;
      }
      
      protected function buyBuff(bool:Boolean = true) : void
      {
         SocketManager.Instance.out.sendUseCard(-1,-1,[ShopManager.Instance.getMoneyShopItemByTemplateID(this._info.buffItemInfo.TemplateID).GoodsID],1,false,bool);
      }
      
      protected function createTipRender() : Sprite
      {
         return new Sprite();
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         width = width;
         height = height;
      }
      
      private function updateView() : void
      {
         if(this._info != null && this._info.IsExist)
         {
            filters = null;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set CanClick(value:Boolean) : void
      {
         this._canClick = value;
         buttonMode = this._canClick;
      }
      
      public function get CanClick() : Boolean
      {
         return this._canClick;
      }
      
      public function set info(value:BuffInfo) : void
      {
         this._info = value;
         if(this._info.Type != BuffInfo.GROW_HELP && this._info.Type != BuffInfo.LABYRINTH_BUFF)
         {
            this.updateView();
         }
      }
      
      public function get info() : BuffInfo
      {
         return this._info;
      }
      
      protected function __onBuyResponse(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         Setting = false;
         SoundManager.instance.play("008");
         var isBand:Boolean = (evt.target as BaseAlerFrame).isBand;
         (evt.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
         (evt.target as BaseAlerFrame).dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            needMoney = ShopManager.Instance.getMoneyShopItemByTemplateID(this._info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue;
            if(BuriedManager.Instance.checkMoney(isBand,needMoney))
            {
               return;
            }
            this.buyBuff(isBand);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function get tipData() : Object
      {
         this._tipData = new BuffTipInfo();
         if(Boolean(this._info))
         {
            this._tipData.isActive = this._info.IsExist;
            this._tipData.describe = this._info.description;
            this._tipData.name = this._info.buffName;
            this._tipData.isFree = false;
            this._tipData.day = this._info.getLeftTimeByUnit(TimeManager.DAY_TICKS);
            this._tipData.hour = this._info.getLeftTimeByUnit(TimeManager.HOUR_TICKS);
            this._tipData.min = this._info.getLeftTimeByUnit(TimeManager.Minute_TICKS);
         }
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value as BuffTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
   }
}

