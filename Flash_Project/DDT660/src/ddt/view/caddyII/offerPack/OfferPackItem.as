package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class OfferPackItem extends Sprite implements Disposeable
   {
      
      public static const HSpace:int = 10;
      
      private var _count:int = 0;
      
      private var _countField:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _seleceted:Boolean = false;
      
      private var _selecetedShin:Scale9CornerImage;
      
      private var _iconCell:BagCell;
      
      public function OfferPackItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var bounds:Rectangle = null;
         this._iconCell = CellFactory.instance.createPersonalInfoCell(-1,null,true) as BagCell;
         bounds = ComponentFactory.Instance.creatCustomObject("ddt.view.caddyII.offerPack.OfferPackItem.cellBounds");
         this._iconCell.x = bounds.x;
         this._iconCell.y = bounds.y;
         this._iconCell.width = bounds.width;
         this._iconCell.height = bounds.height;
         var countFieldBG:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("offer.oferItemCountBg");
         this._countField = ComponentFactory.Instance.creatComponentByStylename("caddy.OfferPack.PackItem.CountField");
         addChild(this._iconCell);
         addChild(countFieldBG);
         addChild(this._countField);
         this._selecetedShin = ComponentFactory.Instance.creatComponentByStylename("offer.oferItemShin");
         addChild(this._selecetedShin);
         this._selecetedShin.visible = this._selecetedShin.mouseChildren = this._selecetedShin.mouseEnabled = false;
         mouseChildren = true;
         buttonMode = true;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      private function __overHandler(e:MouseEvent) : void
      {
         this._selecetedShin.visible = true;
      }
      
      private function __outHandler(e:MouseEvent) : void
      {
         if(!this._seleceted)
         {
            this._selecetedShin.visible = false;
         }
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(val:int) : void
      {
         this._count = val;
         if(Boolean(this._countField))
         {
            this._countField.text = String(this._count);
         }
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(val:ItemTemplateInfo) : void
      {
         if(this._info != val)
         {
            this._info = val;
            this._iconCell.info = this._info;
            this.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._info.TemplateID);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._seleceted;
      }
      
      public function set selected(val:Boolean) : void
      {
         if(this._seleceted != val)
         {
            this._seleceted = val;
            if(Boolean(this._selecetedShin))
            {
               this._selecetedShin.visible = this._seleceted;
            }
         }
      }
      
      override public function get width() : Number
      {
         return 53;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._info = null;
         if(Boolean(this._countField))
         {
            ObjectUtils.disposeObject(this._countField);
         }
         this._countField = null;
         if(Boolean(this._selecetedShin))
         {
            ObjectUtils.disposeObject(this._selecetedShin);
         }
         this._selecetedShin = null;
         if(Boolean(this._iconCell))
         {
            ObjectUtils.disposeObject(this._iconCell);
         }
         this._iconCell = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

