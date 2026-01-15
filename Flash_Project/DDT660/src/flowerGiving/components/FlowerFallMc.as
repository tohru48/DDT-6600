package flowerGiving.components
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FlowerFallMc extends Sprite implements Disposeable
	{
		
		
		private var _flowerMc:MovieClip;
		
		private var _frequency:Number = 0.5;
		
		private var _flag:Number = 0;
		
		private var _flowerArr:Array;
		
		private var _num:int;
		
		private var _loadingSpriteWidth:int = 1010;
		
		private var _loadingSpriteHeight:int = 610;
		
		private var _fsr:Number = 0.5235988333333332;
		
		private var _tempv:Number;
		
		private var _tempr:Number;
		
		public var isOver:Boolean = false;
		
		public function FlowerFallMc()
		{
			this._tempv = 2 + Math.random() * 1000 / 1000 * 2 * 0.8 - 0.8;
			this._tempr = Math.random() * 1000 / 1000 * this._fsr * 2 - this._fsr;
			super();
			this._flowerArr = new Array();
			var _loc1_:int = 0;
			while(_loc1_ < 100)
			{
				this._flowerMc = ComponentFactory.Instance.creat("asset.flowerGiving.flowerMc");
				this._flowerArr.push(this._flowerMc);
				_loc1_++;
			}
			addEventListener(Event.ENTER_FRAME,this.__update);
		}
		
		private function __update(param1:Event) : void
		{
			var _loc2_:MovieClip = null;
			var _loc3_:MovieClip = null;
			if(!this.isOver)
			{
				this._flag += this._frequency;
				while(this._flag > 1)
				{
					this._flag -= 1;
					if(this._num >= 100)
					{
						return;
					}
					_loc2_ = this._flowerArr[this._num] as MovieClip;
					_loc2_.addEventListener(Event.ENTER_FRAME,this.__flowerUpdate);
					++this._num;
					this.initFlower(_loc2_);
					addChild(_loc2_);
				}
			}
			else
			{
				this._flag += this._frequency;
				while(this._flag > 1)
				{
					this._flag -= 1;
					--this._num;
					if(this._num < 0)
					{
						dispatchEvent(new Event(Event.COMPLETE));
						return;
					}
					_loc3_ = this._flowerArr[this._num] as MovieClip;
					_loc3_.removeEventListener(Event.ENTER_FRAME,this.__flowerUpdate);
					if(Boolean(_loc3_.parent))
					{
						removeChild(_loc3_);
					}
					_loc3_ = null;
				}
			}
		}
		
		private function initFlower(param1:MovieClip) : void
		{
			param1.x = Math.random() * this._loadingSpriteWidth;
			param1.y = Math.random() * 10;
			param1.gx = this._tempv * Math.sin(this._tempr);
			param1.gy = 8 + this._tempv * Math.cos(this._tempr);
			param1.rot = Math.random() * 1000 / 1000 * 2 * 8 - 8;
			param1.scaleY = param1.scaleX = 0.7 * Math.random();
		}
		
		private function __flowerUpdate(param1:Event) : void
		{
			var _loc2_:MovieClip = null;
			_loc2_ = param1.target as MovieClip;
			_loc2_.x += _loc2_.gx;
			_loc2_.y += _loc2_.gy;
			_loc2_.rotation += _loc2_.rot;
			if(_loc2_.y > this._loadingSpriteHeight)
			{
				this.initFlower(_loc2_);
			}
		}
		
		public function dispose() : void
		{
			var _loc2_:MovieClip = null;
			var _loc1_:int = 0;
			while(_loc1_ < this._flowerArr.length)
			{
				_loc2_ = this._flowerArr[_loc1_] as MovieClip;
				_loc2_.removeEventListener(Event.ENTER_FRAME,this.__flowerUpdate);
				if(Boolean(_loc2_.parent))
				{
					removeChild(_loc2_);
				}
				_loc2_ = null;
				_loc1_++;
			}
			removeEventListener(Event.ENTER_FRAME,this.__update);
		}
	}
}
