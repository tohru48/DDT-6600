package magicHouse.magicCollection
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseTipFrame;
   import shop.view.ShopItemCell;
   
   public class MagicHouseItemCell extends Sprite implements Disposeable
   {
      
      private var _type:int;
      
      private var _pos:int;
      
      private var _isOpen:Boolean = false;
      
      private var _info:ItemTemplateInfo;
      
      private var _cell:ShopItemCell;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _openEnable:Boolean;
      
      private var _frame:MagicHouseTipFrame;
      
      private var _alphaCell:Sprite;
      
      private var _itemContent:Component;
      
      public function MagicHouseItemCell()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._cell = this.createItemCell();
         addChild(this._cell);
         this._cell.x = -4;
         this._cell.y = -3;
         this._itemContent = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.itemTipContent");
         this._alphaCell = ComponentFactory.Instance.creat("magichouse.collectionItem.alphaCell");
         this._itemContent.addChild(this._alphaCell);
         this._itemContent.x = this._cell.x;
         this._itemContent.y = this._cell.y;
         this._alphaCell.width = 68;
         this._alphaCell.height = 68;
         addChild(this._itemContent);
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionView.itemCell.btn");
         addChild(this._openBtn);
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openItem);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openItem);
      }
      
      private function __openItem(e:MouseEvent) : void
      {
         if(this._openEnable)
         {
            if(!this._frame)
            {
               this._frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame");
               this._frame.titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
               this._frame.setTipText(LanguageMgr.GetTranslation("magichouse.collectionView.activateWeaponTip"));
               LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._frame.okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnHandler);
               this._frame.cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnHandler);
               this._frame.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
      }
      
      private function __okBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         this._openEnable = false;
         SocketManager.Instance.out.openMagicLib(this._type,this._pos);
      }
      
      private function __cancelBtnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
      }
      
      private function __confirmResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._openEnable = false;
            SocketManager.Instance.out.openMagicLib(this._type,this._pos);
         }
      }
      
      public function setFilter() : void
      {
         var b:Boolean = false;
         b = Boolean(MagicHouseManager.instance.equipOpenList[(this._type - 1) * 3 + this._pos]);
         if(b)
         {
            if(Boolean(this._cell.getContent()))
            {
               this._cell.getContent().filters = [];
            }
         }
         else
         {
            this._cell.getContent().filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         this._openBtn.visible = b;
         this._openEnable = b;
      }
      
      public function setOpened($b:Boolean) : void
      {
         this._isOpen = $b;
         this._openBtn.visible = !$b;
      }
      
      public function set cellInfo($info:ItemTemplateInfo) : void
      {
		  this._info = $info;
		  this._cell.info = $info;
		  
		  var obj:Object = new Object();
		  
		  if (this._info != null && this._info.hasOwnProperty("Name") && this._info.Name != null)
		  {
			  obj.titleName = this._info.Name;
		  }
		  else
		  {
			  //trace("[setInfo] _info veya Name null! Gelen info:", this._info);
			  obj.titleName = "Bilinmeyen";
		  }
         obj.type = EquipType.PARTNAME[this._info.CategoryID];
         obj.activate = this._isOpen;
         obj.datail = LanguageMgr.GetTranslation("magichouse.collectionItem.itemTip.activateDetail");
         obj.placed = LanguageMgr.GetTranslation("avatarCollection.itemTip.placeTxt") + " " + LanguageMgr.GetTranslation("tank.view.movement.MovementLeftView.action");
         this._itemContent.tipData = obj;
      }
      
      public function setTypeAndPos($type:int, $pos:int) : void
      {
         this._type = $type;
         this._pos = $pos;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      private function createItemCell() : ShopItemCell
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,46,46);
         sp.graphics.endFill();
         return CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._cell))
         {
            this._cell.dispose();
         }
         this._cell = null;
         if(Boolean(this._openBtn))
         {
            this._openBtn.dispose();
         }
         this._openBtn = null;
      }
   }
}

