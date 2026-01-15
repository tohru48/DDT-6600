package ddt.manager
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.pickgliss.toplevel.StageReferance;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.UICreatShortcut;
	import com.pickgliss.ui.text.FilterFrameText;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	public class MessageTipManager
	{
		
		private static var instance:MessageTipManager;
		
		private var _messageTip:Sprite;
		
		private var _tipString:String;
		
		private var _tipText:FilterFrameText;
		
		private var _tipBg:DisplayObject;
		
		private var _isPlaying:Boolean;
		
		private var _currentType:int;
		
		private var _ghostPropContent:PropMessageHolder;
		
		private var _emptyGridContent:EmptyGridMsgHolder;
		
		private var _autoUsePropContent:AutoUsePropMessage;
		
		private var _tipContainer:Sprite;
		
		private var _duration:Number;
		
		public function MessageTipManager()
		{
			super();
			this._tipContainer = new Sprite();
			this._tipContainer.mouseChildren = this._tipContainer.mouseEnabled = false;
			this._tipContainer.y = StageReferance.stageHeight >> 1;
			this._messageTip = new Sprite();
			this._tipBg = UICreatShortcut.creatAndAdd("core.Scale9CornerImage23",this._tipContainer);
			this._tipText = UICreatShortcut.creatAndAdd("core.messageTip.TipText",this._messageTip);
			this._tipText.filters = ComponentFactory.Instance.creatFilters("core.messageTip.TipTextFilter_1");
			this._tipText.antiAliasType = AntiAliasType.ADVANCED;
			this._tipText.mouseEnabled = this._messageTip.mouseEnabled = false;
			this._messageTip.mouseChildren = false;
			this._ghostPropContent = new PropMessageHolder();
			this._ghostPropContent.x = 130;
			this._ghostPropContent.y = 10;
			this._emptyGridContent = new EmptyGridMsgHolder();
			this._emptyGridContent.x = 130;
			this._emptyGridContent.y = 10;
			this._autoUsePropContent = new AutoUsePropMessage();
			this._autoUsePropContent.x = 130;
			this._autoUsePropContent.y = 10;
		}
		
		public static function getInstance() : MessageTipManager
		{
			if(instance == null)
			{
				instance = new MessageTipManager();
			}
			return instance;
		}
		
		public function get currentType() : int
		{
			return this._currentType;
		}
		
		public function get isPlaying() : Boolean
		{
			return this._isPlaying;
		}
		
		private function setContent(str:String) : DisplayObject
		{
			this.cleanContent();
			this._tipString = str;
			this._tipText.autoSize = "center";
			this._tipText.text = this._tipString;
			this._tipBg.width = this._tipText.textWidth + 260;
			this._tipBg.height = this._tipText.textHeight + 20;
			this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
			this._tipContainer.addChild(this._tipBg);
			this._tipContainer.addChild(this._messageTip);
			return this._tipContainer;
		}
		
		private function setGhostPropContent(str:String) : DisplayObject
		{
			this.cleanContent();
			this._ghostPropContent.setContent(str);
			this._tipBg.width = this._ghostPropContent.width + 260;
			this._tipBg.height = this._ghostPropContent.height + 20;
			this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
			this._ghostPropContent.x = this._tipBg.x + 130;
			this._tipContainer.addChild(this._tipBg);
			this._tipContainer.addChild(this._ghostPropContent);
			return this._tipContainer;
		}
		
		private function setFullPropContent(str:String) : DisplayObject
		{
			this.cleanContent();
			this._emptyGridContent.setContent(str);
			this._tipBg.width = this._emptyGridContent.width + 260;
			this._tipBg.height = this._emptyGridContent.height + 20;
			this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
			this._emptyGridContent.x = this._tipBg.x + 130;
			this._tipContainer.addChild(this._tipBg);
			this._tipContainer.addChild(this._emptyGridContent);
			return this._tipContainer;
		}
		
		private function setAutoUsePropContent(playerID:String) : DisplayObject
		{
			this.cleanContent();
			this._autoUsePropContent.setContent(playerID);
			this._tipBg.width = this._autoUsePropContent.width + 260;
			this._tipBg.height = this._autoUsePropContent.height + 20;
			this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
			this._autoUsePropContent.x = this._tipBg.x + 130;
			this._tipContainer.addChild(this._tipBg);
			this._tipContainer.addChild(this._autoUsePropContent);
			return this._tipContainer;
		}
		
		private function cleanContent() : void
		{
			while(this._tipContainer.numChildren > 0)
			{
				this._tipContainer.removeChildAt(0);
			}
		}
		
		private function showTip(tipContent:DisplayObject, replace:Boolean = false, duration:Number = 0.3) : void
		{
			if(!replace && this._isPlaying)
			{
				return;
			}
			if(Boolean(this._tipContainer.parent) && this._isPlaying)
			{
				TweenMax.killChildTweensOf(this._tipContainer.parent);
			}
			this._isPlaying = true;
			this._duration = duration;
			var tempY:int = (StageReferance.stageHeight - tipContent.height) / 2 - 10;
			TweenMax.fromTo(tipContent,0.3,{
				"y":StageReferance.stageHeight / 2 + 20,
				"alpha":0,
				"ease":Quint.easeIn,
				"onComplete":this.onTipToCenter,
				"onCompleteParams":[tipContent]
			},{
				"y":tempY,
				"alpha":1
			});
			LayerManager.Instance.addToLayer(tipContent,LayerManager.STAGE_DYANMIC_LAYER,false,0,false);
		}
		
		public function show(str:String, type:int = 0, replace:Boolean = false, duration:Number = 0.3) : void
		{
			var content:DisplayObject = null;
			if(!replace && this._isPlaying)
			{
				return;
			}
			this._tipString = str;
			switch(type)
			{
				case 1:
					content = this.setGhostPropContent(str);
					break;
				case 2:
					content = this.setFullPropContent(str);
					break;
				case 3:
					content = this.setAutoUsePropContent(str);
					break;
				default:
					content = this.setContent(str);
			}
			this._currentType = type;
			this.showTip(content,replace,duration);
		}
		
		private function onTipToCenter(content:DisplayObject) : void
		{
			TweenMax.to(content,this._duration,{
				"alpha":0,
				"ease":Quint.easeOut,
				"onComplete":this.hide,
				"onCompleteParams":[content],
				"delay":1.2
			});
		}
		
		public function kill() : void
		{
			this._isPlaying = false;
			if(Boolean(this._tipContainer.parent))
			{
				this._tipContainer.parent.removeChild(this._tipContainer);
			}
			TweenMax.killTweensOf(this._tipContainer);
		}
		
		public function hide(content:DisplayObject) : void
		{
			this._isPlaying = false;
			this._tipString = null;
			if(Boolean(content.parent))
			{
				content.parent.removeChild(content);
			}
			TweenMax.killTweensOf(content);
		}
	}
}

import bagAndInfo.cell.BaseCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.data.goods.ItemTemplateInfo;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import game.GameManager;
import game.model.Living;
import ddt.manager.LanguageMgr;
import ddt.manager.ItemManager;

class EmptyGridMsgHolder extends Sprite
{
	
	private var _textField:FilterFrameText;
	
	private var _item:PropHolder;
	
	public function EmptyGridMsgHolder()
	{
		super();
		mouseEnabled = false;
		mouseChildren = false;
		this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
		this._textField.x = 0;
		this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.EmptyGrid");
		addChild(this._textField);
		this._item = new PropHolder();
		addChild(this._item);
	}
	
	public function setContent(str:String) : void
	{
		var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(str));
		this._item.setInfo(item);
		this._item.x = this._textField.x + this._textField.width - 4;
	}
}

class PropMessageHolder extends Sprite
{
	
	private var _head:HeadHolder;
	
	private var _textField:FilterFrameText;
	
	private var _item:PropHolder;
	
	public function PropMessageHolder()
	{
		super();
		mouseEnabled = false;
		mouseChildren = false;
		this._head = new HeadHolder();
		addChild(this._head);
		this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
		this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.GhostProp");
		addChild(this._textField);
		this._item = new PropHolder();
		addChild(this._item);
	}
	
	public function setContent(str:String) : void
	{
		var arr:Array = str.split("|");
		var living:Living = GameManager.Instance.Current.findLiving(arr[0]);
		this._head.setInfo(living);
		var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(arr[1]);
		this._item.setInfo(item);
		this._textField.x = this._head.width - 3;
		this._item.x = this._textField.x + this._textField.width - 4;
	}
}

class AutoUsePropMessage extends Sprite
{
	
	private var _head:HeadHolder;
	
	private var _textField:FilterFrameText;
	
	private var _item:PropHolder;
	
	public function AutoUsePropMessage()
	{
		super();
		mouseEnabled = false;
		mouseChildren = false;
		this._head = new HeadHolder(false);
		addChild(this._head);
		this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
		addChild(this._textField);
		this._item = new PropHolder();
		addChild(this._item);
	}
	
	public function setContent(id:String) : void
	{
		var living:Living = GameManager.Instance.Current.findLiving(int(id));
		this._head.setInfo(living);
		var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10029);
		this._item.setInfo(item);
		this._textField.x = this._head.width - 3;
		this._textField.text = living.name + LanguageMgr.GetTranslation("tank.MessageTip.AutoGuide");
		this._item.x = this._textField.x + this._textField.width - 4;
	}
}

class PropHolder extends Sprite
{
	
	private var _itemCell:BaseCell;
	
	private var _fore:DisplayObject;
	
	private var _nameField:FilterFrameText;
	
	public function PropHolder()
	{
		super();
		this._itemCell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back"),null,false,false);
		addChild(this._itemCell);
		this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
		this._fore.y = 1;
		this._fore.x = 1;
		addChild(this._fore);
		this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.Prop.TextField");
		addChild(this._nameField);
	}
	
	public function setInfo(item:ItemTemplateInfo) : void
	{
		this._nameField.text = item.Name;
		this._itemCell.x = this._nameField.x + this._nameField.textWidth + 4;
		this._fore.x = this._itemCell.x + 1;
		this._itemCell.info = item;
	}
}

class HeadHolder extends Sprite implements Disposeable
{
	
	private var _back:DisplayObject;
	
	private var _fore:DisplayObject;
	
	private var _headShape:Shape;
	
	private var _buff:BitmapData;
	
	private var _drawRect:Rectangle = new Rectangle(0,0,36,36);
	
	private var _drawMatrix:Matrix = new Matrix();
	
	private var _nameField:FilterFrameText;
	
	public function HeadHolder(isDeath:Boolean = true)
	{
		super();
		this._back = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
		addChild(this._back);
		this._buff = new BitmapData(36,36,true,0);
		this._headShape = new Shape();
		var pen:Graphics = this._headShape.graphics;
		pen.beginBitmapFill(this._buff);
		pen.drawRect(0,0,36,36);
		pen.endFill();
		if(isDeath)
		{
			this._headShape.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
		}
		addChild(this._headShape);
		this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
		this._fore.y = 1;
		this._fore.x = 1;
		addChild(this._fore);
		this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.GhostProp.NameField");
		addChild(this._nameField);
	}
	
	public function setInfo(living:Living) : void
	{
		this._buff.fillRect(this._drawRect,0);
		var rect:Rectangle = this.getHeadRect(living);
		this._drawMatrix.identity();
		this._drawMatrix.scale(this._buff.width / rect.width,this._buff.height / rect.height);
		this._drawMatrix.translate(-rect.x * this._drawMatrix.a + 4,-rect.y * this._drawMatrix.d + 6);
		this._buff.draw(living.character.characterBitmapdata,this._drawMatrix);
		if(living.playerInfo != null)
		{
			this._nameField.text = living.playerInfo.NickName;
		}
		else
		{
			this._nameField.text = living.name;
		}
		this._nameField.setFrame(living.team);
	}
	
	private function getHeadRect(living:Living) : Rectangle
	{
		if(living.playerInfo.getShowSuits() && living.playerInfo.getSuitsType() == 1)
		{
			return new Rectangle(21,12,167,165);
		}
		return new Rectangle(16,58,170,170);
	}
	
	public function hide() : void
	{
	}
	
	public function dispose() : void
	{
	}
}
