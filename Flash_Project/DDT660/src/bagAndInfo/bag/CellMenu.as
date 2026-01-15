package bagAndInfo.bag
{
	import bagAndInfo.cell.BagCell;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.BaseButton;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.manager.SoundManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import playerDress.components.DressUtils;
	
	public class CellMenu extends Sprite
	{
		
		private static var _instance:CellMenu;
		
		public static const ADDPRICE:String = "addprice";
		
		public static const MOVE:String = "move";
		
		public static const OPEN:String = "open";
		
		public static const USE:String = "use";
		
		public static const OPEN_BATCH:String = "open_batch";
		
		public static const COLOR_CHANGE:String = "color_change";
		
		public static const SELL:String = "delete";
		
		private var _bg:Bitmap;
		
		private var _bg2:Bitmap;
		
		private var _bgNoe:Bitmap;
		
		private var _cell:BagCell;
		
		private var _addpriceitem:BaseButton;
		
		private var _moveitem:BaseButton;
		
		private var _openitem:BaseButton;
		
		private var _useitem:BaseButton;
		
		private var _openBatchItem:BaseButton;
		
		private var _colorChangeItem:BaseButton;
		
		private var _sellItem:BaseButton;
		
		private var _list:Sprite;
		
		public function CellMenu(single:SingletonFoce)
		{
			super();
			this.init();
		}
		
		public static function get instance() : CellMenu
		{
			if(_instance == null)
			{
				_instance = new CellMenu(new SingletonFoce());
			}
			return _instance;
		}
		
		private function init() : void
		{
			this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBGAsset");
			this._bg2 = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBG2Asset");
			this._bgNoe = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBGOneAsset");
			addChild(this._bg);
			addChild(this._bg2);
			addChild(this._bgNoe);
			this._list = new Sprite();
			this._list.x = 5;
			this._list.y = 5;
			addChild(this._list);
			graphics.beginFill(0,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			addEventListener(MouseEvent.CLICK,this.__mouseClick);
			this._addpriceitem = ComponentFactory.Instance.creatComponentByStylename("addPriceBtn");
			this._moveitem = ComponentFactory.Instance.creatComponentByStylename("moveGoodsBtn");
			this._openitem = ComponentFactory.Instance.creatComponentByStylename("openGoodsBtn");
			this._useitem = ComponentFactory.Instance.creatComponentByStylename("useGoodsBtn");
			this._openBatchItem = ComponentFactory.Instance.creatComponentByStylename("openBatchGoodsBtn");
			this._colorChangeItem = ComponentFactory.Instance.creatComponentByStylename("colorChangeBtn");
			this._sellItem = ComponentFactory.Instance.creatComponentByStylename("sellBtn");
			this._moveitem.y = 27;
			this._addpriceitem.addEventListener(MouseEvent.CLICK,this.__addpriceClick);
			this._moveitem.addEventListener(MouseEvent.CLICK,this.__moveClick);
			this._openitem.addEventListener(MouseEvent.CLICK,this.__openClick);
			this._useitem.addEventListener(MouseEvent.CLICK,this.__useClick);
			this._openBatchItem.addEventListener(MouseEvent.CLICK,this.__openBatchClick);
			this._colorChangeItem.addEventListener(MouseEvent.CLICK,this.__colorChangeClick);
			this._sellItem.addEventListener(MouseEvent.CLICK,this.__sellClick);
		}
		
		public function get cell() : BagCell
		{
			return this._cell;
		}
		
		private function __mouseClick(evt:MouseEvent) : void
		{
			this.hide();
			SoundManager.instance.play("008");
		}
		
		private function __addpriceClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			dispatchEvent(new Event(ADDPRICE));
			this.hide();
		}
		
		private function __moveClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			dispatchEvent(new Event(MOVE));
			this.hide();
		}
		
		private function __openClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			dispatchEvent(new Event(OPEN));
			this.hide();
		}
		
		private function __useClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			if(Boolean(parent))
			{
				parent.removeChild(this);
			}
			dispatchEvent(new Event(USE));
			this.hide();
		}
		
		private function __openBatchClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			if(Boolean(parent))
			{
				parent.removeChild(this);
			}
			dispatchEvent(new Event(OPEN_BATCH));
			this.hide();
		}
		
		private function __colorChangeClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			dispatchEvent(new Event(COLOR_CHANGE));
			this.hide();
		}
		
		private function __sellClick(evt:MouseEvent) : void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.play("008");
			dispatchEvent(new Event(SELL));
			this.hide();
		}
		
		public function show(cell:BagCell, x:int, y:int) : void
		{
			var info:ItemTemplateInfo = null;
			this._cell = cell;
			if(this._cell == null)
			{
				return;
			}
			info = this._cell.info;
			if(info == null)
			{
				return;
			}
			this._bg.visible = true;
			this._bg2.visible = false;
			this._bgNoe.visible = false;
			this._openitem.x = 0;
			this._openitem.y = 0;
			this._moveitem.x = 0;
			this._moveitem.y = 27;
			if(DressUtils.isDress(info as InventoryItemInfo))
			{
				if(InventoryItemInfo(info).getRemainDate() <= 0)
				{
					this._list.addChild(this._addpriceitem);
				}
				else
				{
					this._list.addChild(this._colorChangeItem);
				}
				this._list.addChild(this._sellItem);
				this._colorChangeItem.y = -1;
				this._sellItem.y = 28;
			}
			else
			{
				if(InventoryItemInfo(info).getRemainDate() <= 0)
				{
					this._list.addChild(this._addpriceitem);
				}
				else if(EquipType.isCardSoule(info) || EquipType.isPackage(info) || info.CategoryID == EquipType.EVERYDAYGIFTRECORD)
				{
					this._list.addChild(this._openitem);
					if(EquipType.isCanBatchHandler(info as InventoryItemInfo) || this.isCanBatch(info.TemplateID))
					{
						this._list.addChild(this._openBatchItem);
						this._bg.visible = false;
						this._bg2.visible = true;
						this._bgNoe.visible = false;
						this._openitem.x = -2;
						this._openitem.y = -2;
						this._openBatchItem.x = -2;
						this._openBatchItem.y = 27;
						this._moveitem.x = -2;
						this._moveitem.y = 56;
					}
				}
				else if(EquipType.isPetEgg(info))
				{
					this._list.addChild(this._openitem);
				}
				else if(EquipType.canBeUsed(info))
				{
					this._list.addChild(this._useitem);
					if(EquipType.isCard(info) && EquipType.isCanBatchHandler(info as InventoryItemInfo))
					{
						this._list.addChild(this._openBatchItem);
						this._bg.visible = false;
						this._bg2.visible = true;
						this._bgNoe.visible = false;
						this._useitem.x = -2;
						this._useitem.y = -2;
						this._openBatchItem.x = -2;
						this._openBatchItem.y = 27;
						this._moveitem.x = -2;
						this._moveitem.y = 56;
					}
				}
				this._list.addChild(this._moveitem);
			}
			LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
			this.x = x;
			this.y = y;
		}
		
		private function isCanBatch(id:int) : Boolean
		{
			if(id > 121999 && id <= 129999)
			{
				return true;
			}
			return false;
		}
		
		public function hide() : void
		{
			if(Boolean(parent))
			{
				parent.removeChild(this);
			}
			while(this._list.numChildren > 0)
			{
				this._list.removeChildAt(0);
			}
			this._cell = null;
		}
		
		public function get showed() : Boolean
		{
			return stage != null;
		}
	}
}

class SingletonFoce
{
	
	public function SingletonFoce()
	{
		super();
	}
}
