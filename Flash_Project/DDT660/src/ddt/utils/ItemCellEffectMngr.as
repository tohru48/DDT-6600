package ddt.utils
{
	import com.pickgliss.ui.ComponentFactory;
	import flash.display.MovieClip;
	
	public class ItemCellEffectMngr
	{
		
		private static var effectState:IState;
		
		public static const EFFECT_RUN_AROUND:int = 0;
		
		public static const SIZE_BAG_CELL:int = 100;
		
		public static const SIZE_SHOP_ITEM_CELL:int = 101;
		
		public function ItemCellEffectMngr()
		{
			super();
		}
		
		public static function getEffect(cellPos:Object, efftctType:int = 0, sizeType:int = 100) : MovieClip
		{
			var mc:MovieClip = null;
			switch(efftctType)
			{
				case EFFECT_RUN_AROUND:
					mc = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
					effectState = new StateRunAround();
					mc.mouseChildren = false;
					mc.mouseEnabled = false;
					effectState.setSize(mc,cellPos,sizeType);
					effectState = null;
					return mc;
				default:
					throw "没有这样的特效类型.";
			}
		}
	}
}

import flash.display.MovieClip;
import ddt.utils.ItemCellEffectMngr;

interface IState
{
	
	function setSize(param1:MovieClip, param2:Object, param3:int) : void;
}

class StateRunAround implements IState
{
	
	public function StateRunAround()
	{
		super();
	}
	
	public function setSize(tag:MovieClip, cellPos:Object, type:int) : void
	{
		switch(type)
		{
			case ItemCellEffectMngr.SIZE_BAG_CELL:
				tag.scaleX = tag.scaleY = 1;
				tag.x = cellPos.x - 1;
				tag.y = cellPos.y - 1;
				break;
			case ItemCellEffectMngr.SIZE_SHOP_ITEM_CELL:
				tag.scaleX = tag.scaleY = 56 / 45;
				tag.x = cellPos.x + 9;
				tag.y = cellPos.y + 10;
		}
	}
}
