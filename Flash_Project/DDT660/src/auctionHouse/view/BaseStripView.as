package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import beadSystem.beadSystemManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BaseStripView extends Sprite implements Disposeable
   {
      
      protected var _info:AuctionGoodsInfo;
      
      protected var _state:int;
      
      private var _isSelect:Boolean;
      
      private var _cell:AuctionCellViewII;
      
      protected var _name:FilterFrameText;
      
      protected var _count:FilterFrameText;
      
      protected var _leftTime:FilterFrameText;
      
      private var _cleared:Boolean;
      
      protected var stripSelect_bit:Scale9CornerImage;
      
      protected var back_mc:Bitmap;
      
      protected var leftBG:ScaleLeftRightImage;
      
      public function BaseStripView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         this._cleared = false;
         this.back_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.CellBG");
         addChild(this.back_mc);
         this.leftBG = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.StripGoodsRightBG");
         addChild(this.leftBG);
         this._name = ComponentFactory.Instance.creat("auctionHouse.BaseStripName");
         addChild(this._name);
         this._count = ComponentFactory.Instance.creat("auctionHouse.BaseStripCount");
         addChild(this._count);
         this._leftTime = ComponentFactory.Instance.creat("auctionHouse.BaseStripLeftTime");
         addChild(this._leftTime);
         this._name.mouseEnabled = this._count.mouseEnabled = this._leftTime.mouseEnabled = false;
         this._cell = new AuctionCellViewII();
         this._cell.x = this.leftBG.x + 2;
         this._cell.y = 7;
         addChild(this._cell);
         this.stripSelect_bit = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauction.ListPos1");
         this.stripSelect_bit.width = 605;
         this.stripSelect_bit.visible = this.stripSelect_bit.mouseChildren = this.stripSelect_bit.mouseEnabled = false;
         addChild(this.stripSelect_bit);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      internal function get info() : AuctionGoodsInfo
      {
         return this._info;
      }
      
      internal function set info(value:AuctionGoodsInfo) : void
      {
         this._info = value;
         this.update();
         this.updateInfo();
      }
      
      internal function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
      internal function set isSelect(value:Boolean) : void
      {
         this._isSelect = value;
         if(this._state != 1)
         {
            this.update();
         }
      }
      
      internal function clearSelectStrip() : void
      {
         this._cleared = true;
         this.removeEvent();
         this._name.text = "";
         this._count.text = "";
         this._leftTime.text = "";
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         mouseEnabled = false;
         buttonMode = false;
         mouseChildren = false;
         this.stripSelect_bit.visible = false;
         this._isSelect = false;
         this._state = 1;
      }
      
      private function update() : void
      {
         if(this._cleared)
         {
            this.initView();
            this.addEvent();
         }
         this.stripSelect_bit.visible = this._isSelect ? true : false;
      }
      
      protected function updateInfo() : void
      {
         this.removeEvent();
         this._cell.info = this._info.BagItemInfo as ItemTemplateInfo;
         if(EquipType.isBead(int(this._cell.info.Property1)))
         {
            this._name.text = beadSystemManager.Instance.getBeadName(this._cell.itemInfo);
         }
         else
         {
            this._name.text = this._cell.info.Name;
         }
         this._cell.allowDrag = false;
         this._count.text = this._info.BagItemInfo.Count.toString();
         this._leftTime.text = this._info.getTimeDescription();
         mouseEnabled = true;
         buttonMode = true;
         this.addEvent();
      }
      
      override public function set height(value:Number) : void
      {
      }
      
      private function __over(event:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this.stripSelect_bit.visible = true;
      }
      
      private function __out(event:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this.stripSelect_bit.visible = false;
      }
      
      private function __click(event:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            SoundManager.instance.play("047");
         }
         this.isSelect = true;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      override public function get height() : Number
      {
         return this.stripSelect_bit.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         removeEventListener(MouseEvent.CLICK,this.__click);
         if(Boolean(this._info))
         {
            this._info = null;
         }
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this.back_mc))
         {
            ObjectUtils.disposeObject(this.back_mc);
         }
         this.back_mc = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._count))
         {
            ObjectUtils.disposeObject(this._count);
         }
         this._count = null;
         if(Boolean(this._leftTime))
         {
            ObjectUtils.disposeObject(this._leftTime);
         }
         this._leftTime = null;
         if(Boolean(this.stripSelect_bit))
         {
            ObjectUtils.disposeObject(this.stripSelect_bit);
         }
         this.stripSelect_bit = null;
         if(Boolean(this.leftBG))
         {
            ObjectUtils.disposeObject(this.leftBG);
         }
         this.leftBG = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

