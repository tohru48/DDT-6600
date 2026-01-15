package invite.view
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.ListPanel;
	import com.pickgliss.ui.core.Disposeable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class NavigationList extends Sprite implements Disposeable
	{
		
		
		private var _type:int;
		
		private var _modeArr:Array;
		
		private var _buttons:Array;
		
		private var _list:ListPanel;
		
		private var _listBack:DisplayObject;
		
		private var _listArr:Array;
		
		public function NavigationList()
		{
			super();
			this.configUI();
		}
		
		private function configUI() : void
		{
			this._listBack = ComponentFactory.Instance.creatComponentByStylename("invite.list.BackgroundList");
			addChild(this._listBack);
		}
		
		public function get type() : int
		{
			return this._type;
		}
		
		public function set type(val:int) : void
		{
		}
		
		public function get list() : Array
		{
			return this._listArr;
		}
		
		public function set list(val:Array) : void
		{
		}
		
		public function get mode() : String
		{
			var string:String = "";
			for(var i:int = 0; i < this._modeArr.length; i++)
			{
				string = string + (this._modeArr[i] + ",");
			}
			return string.substr(0,string.length - 1);
		}
		
		public function set mode(val:String) : void
		{
			this._modeArr = val.split(",");
		}
		
		public function addNavButton(button:NavButton, type:int) : void
		{
			var proxy:ButtonProxy = new ButtonProxy();
			proxy.button = button;
			proxy.type = type;
			this._buttons.push(proxy);
		}
		
		private function setNavigationPos(pos:int) : void
		{
		}
		
		public function dispose() : void
		{
		}
	}
}

import invite.view.NavButton;

class ButtonProxy
{
	
	
	public var button:NavButton;
	
	public var type:int;
	
	function ButtonProxy()
	{
		super();
	}
}
