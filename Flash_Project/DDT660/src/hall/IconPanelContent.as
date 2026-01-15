package hall
{
	import com.greensock.TweenMax;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.ScaleBitmapImage;
	import com.pickgliss.utils.ObjectUtils;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class IconPanelContent extends Sprite implements Disposeable
	{
		
		public static const LEFT:String = "left";
		
		public static const RIGHT:String = "right";
		
		private var _openBtnSprite:Sprite;
		
		private var _openBtnBg:Bitmap;
		
		private var _closeBtnBg:Bitmap;
		
		private var _iconPanelBg:ScaleBitmapImage;
		
		private var _iconArray:Array;
		
		private var _iconSprite:Sprite;
		
		private var rowNum:int;
		
		private var columnWidth:Number;
		
		private var columnHeight:Number;
		
		private var sideSpace:Number;
		
		public var direction:String;
		
		private var iconRectangle:Rectangle;
		
		private var maskSprite:Sprite;
		
		private var tweenMax:TweenMax;
		
		private var isRollOver:Boolean = false;
		
		public function IconPanelContent($direction:String = "left", $rowNum:int = 5, $columnWidth:Number = 90, $columnHeight:Number = 350, $sideSpace:Number = 5)
		{
			super();
			this.direction = $direction;
			this.rowNum = $rowNum;
			this.columnWidth = $columnWidth;
			this.columnHeight = $columnHeight;
			this.sideSpace = $sideSpace;
			this.init();
		}
		
		private function init() : void
		{
			this.iconRectangle = new Rectangle(0,0,this.columnWidth,this.columnHeight / this.rowNum);
			this.maskSprite = new Sprite();
			this.maskSprite.graphics.beginFill(0);
			this.maskSprite.graphics.drawRect(0,0,this.columnWidth,this.columnHeight);
			this.maskSprite.graphics.endFill();
			addChild(this.maskSprite);
			this._iconPanelBg = ComponentFactory.Instance.creatComponentByStylename("asset.hall.iconPanelBg");
			this._iconPanelBg.height = this.columnHeight + this.sideSpace;
			this._iconPanelBg.width = this.columnWidth;
			this._iconPanelBg.alpha = 0;
			super.addChild(this._iconPanelBg);
			this._openBtnBg = ComponentFactory.Instance.creatBitmap("asset.hall.iconPanelScollOpenBtnBg");
			this._closeBtnBg = ComponentFactory.Instance.creatBitmap("asset.hall.iconPanelScollCloseBtnBg");
			this._openBtnSprite = new Sprite();
			this._openBtnSprite.addChild(this._openBtnBg);
			this._openBtnSprite.addChild(this._closeBtnBg);
			super.addChild(this._openBtnSprite);
			if(this.direction != LEFT)
			{
				this._openBtnBg.scaleX = -1;
				this._openBtnBg.x += this._openBtnBg.width;
				this._closeBtnBg.scaleX = -1;
				this._closeBtnBg.x += this._closeBtnBg.width;
				this._iconPanelBg.scaleX = -1;
				this._iconPanelBg.x = this._iconPanelBg.width;
			}
			addEventListener(MouseEvent.ROLL_OVER,this.__openOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,this.__openOverHandler);
			this._iconArray = new Array();
			this._iconSprite = new Sprite();
			this._iconSprite.y = this.sideSpace;
			super.addChild(this._iconSprite);
			this._iconSprite.mask = this.maskSprite;
			this.isButtonOpen(false);
			this.updateButtonPos();
		}
		
		private function isButtonOpen(bool:Boolean) : void
		{
			if(bool)
			{
				this._openBtnBg.visible = false;
				this._closeBtnBg.visible = true;
			}
			else
			{
				this._openBtnBg.visible = true;
				this._closeBtnBg.visible = false;
			}
		}
		
		private function __openOverHandler(event:MouseEvent) : void
		{
			if(this.isResetBG())
			{
				this.updateButtonPos();
				return;
			}
			var bgAlpha:int = 0;
			if(event.type == MouseEvent.ROLL_OVER)
			{
				this.isRollOver = true;
				bgAlpha = 1;
			}
			else
			{
				this.isRollOver = false;
			}
			this.isButtonOpen(this.isRollOver);
			this.updateBgAndMask(this.isRollOver,true,bgAlpha);
		}
		
		private function updateBgAndMask($isRollOver:Boolean = true, $isMovie:Boolean = false, $bgAlpha:int = 1) : void
		{
			var tempWidth:Number = NaN;
			var num1:int = (this.validLength($isRollOver) - 1) / this.rowNum;
			var tempX:Number = num1 * this.iconRectangle.width;
			tempWidth = tempX + this.iconRectangle.width;
			if(this.direction == LEFT)
			{
				if(tempX > 0)
				{
					tempX = -tempX;
				}
			}
			else if(tempX > 0)
			{
				tempX += this.iconRectangle.width;
			}
			else
			{
				tempX = this.iconRectangle.width;
			}
			if($isMovie)
			{
				this.tweenMax = TweenMax.to(this._iconPanelBg,0.5,{
					"alpha":$bgAlpha,
					"x":tempX,
					"width":tempWidth,
					"onUpdate":this.onUpdate,
					"onComplete":this.onComplete
				});
			}
			else
			{
				this._iconPanelBg.x = tempX;
				this._iconPanelBg.width = tempWidth;
				this.onUpdate();
			}
		}
		
		private function onUpdate() : void
		{
			if(this.direction == LEFT)
			{
				this.maskSprite.x = this._iconPanelBg.x;
			}
			else
			{
				this.maskSprite.x = this._iconPanelBg.x - this._iconPanelBg.width;
			}
			this.maskSprite.width = this._iconPanelBg.width;
			this.updateButtonPos();
		}
		
		private function onComplete() : void
		{
			this.killTweenMaxs();
		}
		
		private function updateButtonPos() : void
		{
			if(!this._openBtnSprite || !this.maskSprite)
			{
				return;
			}
			if(this.direction == LEFT)
			{
				this._openBtnSprite.x = this.maskSprite.x - this._openBtnSprite.width + 7;
			}
			else
			{
				this._openBtnSprite.x = this.maskSprite.x + this.maskSprite.width - 5;
			}
			this._openBtnSprite.y = (this.maskSprite.height - this._openBtnSprite.height) / 2;
			if(this._iconArray.length > this.rowNum)
			{
				this._openBtnSprite.visible = true;
			}
			else
			{
				this._openBtnSprite.visible = false;
			}
		}
		
		private function updateIconsPos() : void
		{
			var num1:int = 0;
			var num2:int = 0;
			var icon:Sprite = null;
			for(var i:int = 0; i < this._iconArray.length; i++)
			{
				num1 = i / this.rowNum;
				num2 = i % this.rowNum;
				icon = this._iconArray[i].icon;
				icon.x = num1 * this.iconRectangle.width;
				if(this.direction == LEFT)
				{
					if(icon.x > 0)
					{
						icon.x = -icon.x;
					}
				}
				icon.y = num2 * this.iconRectangle.height;
			}
		}
		
		private function isResetBG() : Boolean
		{
			if(this._iconArray.length <= this.rowNum)
			{
				if(this.direction == LEFT)
				{
					this._iconPanelBg.x = 0;
				}
				else
				{
					this._iconPanelBg.x = this.iconRectangle.width;
				}
				this._iconPanelBg.width = this.iconRectangle.width;
				this._iconPanelBg.alpha = 0;
				this.maskSprite.x = 0;
				this.maskSprite.width = this._iconPanelBg.width;
				return true;
			}
			return false;
		}
		
		public function addIcon(icon:DisplayObject, orderId:int) : DisplayObject
		{
			var sp:Sprite = new Sprite();
			sp.addChild(icon);
			var obj:Object = {};
			obj.orderId = orderId;
			obj.icon = sp;
			this._iconSprite.addChild(sp);
			this._iconArray.push(obj);
			return icon;
		}
		
		public function iconSortOn(key:String = "orderId") : void
		{
			this._iconArray.sortOn(key,Array.NUMERIC);
		}
		
		public function arrange() : void
		{
			if(this.isResetBG())
			{
				this.updateButtonPos();
			}
			else
			{
				this.updateBgAndMask(this.isRollOver);
			}
			this.updateIconsPos();
		}
		
		private function validLength($isRollOver:Boolean) : int
		{
			if(!$isRollOver)
			{
				return this.rowNum;
			}
			return this._iconArray.length;
		}
		
		private function killTweenMaxs() : void
		{
			if(!this.tweenMax)
			{
				return;
			}
			this.tweenMax.kill();
			this.tweenMax = null;
		}
		/*
		public function removeChildren() : void
		{
		var sp:Sprite = null;
		while(this._iconSprite.numChildren > 0)
		{
		this._iconSprite.removeChildAt(0);
		}
		for(var i:int = 0; i < this._iconArray.length; i++)
		{
		sp = this._iconArray[i].icon;
		while(sp.numChildren > 0)
		{
		sp.removeChildAt(0);
		}
		this._iconArray[i] = null;
		}
		this._iconArray = [];
		}
		*/
		
		public function dispose() : void
		{
			this.killTweenMaxs();
			removeEventListener(MouseEvent.ROLL_OVER,this.__openOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,this.__openOverHandler);
			ObjectUtils.disposeObject(this._openBtnBg);
			this._openBtnBg = null;
			ObjectUtils.disposeObject(this._closeBtnBg);
			this._closeBtnBg = null;
			ObjectUtils.disposeObject(this._iconPanelBg);
			this._iconPanelBg = null;
			ObjectUtils.disposeObject(this._openBtnSprite);
			this._openBtnSprite = null;
			this.removeChildren();
			this._iconArray = null;
			ObjectUtils.disposeObject(this._iconSprite);
			this._iconSprite = null;
			this.iconRectangle = null;
			ObjectUtils.disposeObject(this.maskSprite);
			this.maskSprite = null;
			if(Boolean(this.parent))
			{
				this.parent.removeChild(this);
			}
		}
	}
}

