package ddt.utils
{
	import com.pickgliss.events.ComponentEvent;
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.Frame;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.image.Scale9CornerImage;
	import com.pickgliss.ui.vo.AlertInfo;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SoundManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class HelpFrameUtils
	{
		
		private static var _instance:HelpFrameUtils;
		
		
		public function HelpFrameUtils()
		{
			super();
		}
		
		public static function get Instance() : HelpFrameUtils
		{
			if(_instance == null)
			{
				_instance = new HelpFrameUtils();
			}
			return _instance;
		}
		
		public function simpleHelpButton(param1:Sprite, param2:String, param3:Object = null, param4:String = "", param5:Object = null, param6:Number = 0, param7:Number = 0, param8:Boolean = true, param9:Boolean = true, param10:Object = null, param11:int = 3) : *
		{
			var _loc13_:* = null;
			var _loc14_:Object = null;
			var _loc12_:* = ComponentFactory.Instance.creatComponentByStylename(param2);
			if(param3)
			{
				if(param3 is Point)
				{
					_loc12_.x = param3.x;
					_loc12_.y = param3.y;
				}
				else
				{
					for(_loc13_ in param3)
					{
						_loc12_[_loc13_] = param3[_loc13_];
					}
				}
			}
			if(param5)
			{
				_loc14_ = {
					"titleText":param4,
					"content":param5,
					"width":param6,
					"height":param7,
					"isShowContentBg":param8,
					"isShow":param9,
					"alertInfo":param10,
					"showLayerType":param11
				};
				_loc12_.tipData = {"helpFrameData":_loc14_};
				_loc12_.addEventListener(MouseEvent.CLICK,this.__helpButtonClick);
				_loc12_.addEventListener(ComponentEvent.DISPOSE,this.__helpButtonDispose);
			}
			if(param1 is Frame)
			{
				Frame(param1).addToContent(_loc12_);
			}
			else
			{
				param1.addChild(_loc12_);
			}
			return _loc12_;
		}
		
		private function __helpButtonClick(param1:MouseEvent) : void
		{
			var _loc2_:Object = null;
			SoundManager.instance.playButtonSound();
			if(param1.currentTarget.hasOwnProperty("tipData") && param1.currentTarget.tipData && param1.currentTarget.tipData.helpFrameData)
			{
				_loc2_ = param1.currentTarget.tipData.helpFrameData;
				this.simpleHelpFrame(_loc2_.titleText,_loc2_.content,_loc2_.width,_loc2_.height,_loc2_.isShowContentBg,_loc2_.isShow,_loc2_.alertInfo,_loc2_.showLayerType);
			}
		}
		
		private function __helpButtonDispose(param1:ComponentEvent) : void
		{
			param1.currentTarget.removeEventListener(MouseEvent.CLICK,this.__helpButtonClick);
			param1.currentTarget.removeEventListener(ComponentEvent.DISPOSE,this.__helpButtonDispose);
		}
		
		public function simpleHelpFrame(param1:String, param2:Object, param3:Number, param4:Number, param5:Boolean = true, param6:Boolean = true, param7:Object = null, param8:int = 3) : BaseAlerFrame
		{
			var _loc10_:BaseAlerFrame = null;
			var _loc11_:* = null;
			var _loc12_:Scale9CornerImage = null;
			var _loc13_:int = 0;
			var _loc14_:Object = null;
			var _loc9_:AlertInfo = new AlertInfo();
			_loc9_.sound = "008";
			_loc9_.mutiline = true;
			_loc9_.buttonGape = 15;
			_loc9_.autoDispose = true;
			_loc9_.showCancel = false;
			_loc9_.moveEnable = true;
			_loc9_.escEnable = true;
			_loc9_.submitLabel = LanguageMgr.GetTranslation("ok");
			if(param7)
			{
				if(param7 is AlertInfo)
				{
					ObjectUtils.copyProperties(_loc9_,param7);
				}
				else
				{
					for(_loc11_ in param7)
					{
						_loc9_[_loc11_] = param7[_loc11_];
					}
				}
			}
			_loc10_ = ComponentFactory.Instance.creatComponentByStylename("BaseFrame");
			_loc10_.info = _loc9_;
			_loc10_.moveInnerRectString = "0,30,0,30,1";
			_loc10_.width = param3;
			_loc10_.height = param4;
			_loc10_.titleText = param1;
			_loc10_.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
			if(param5)
			{
				_loc12_ = ComponentFactory.Instance.creatComponentByStylename("core.Scale9CornerImage.scale9CornerImagereleaseContentTextBG");
				_loc12_.width = _loc10_.width - 30;
				_loc12_.height = _loc10_.height - 98;
				_loc12_.x = (_loc10_.width - _loc12_.width) / 2;
				_loc12_.y = 40;
				_loc10_.addToContent(_loc12_);
			}
			if(param2 is DisplayObject)
			{
				_loc10_.addToContent(param2 as DisplayObject);
			}
			else if(param2 is Array)
			{
				_loc13_ = 0;
				while(_loc13_ < param2.length)
				{
					_loc14_ = param2[_loc13_];
					if(_loc14_ is DisplayObject)
					{
						_loc10_.addToContent(_loc14_ as DisplayObject);
					}
					else
					{
						_loc10_.addToContent(ComponentFactory.Instance.creat(_loc14_ as String));
					}
					_loc13_++;
				}
			}
			else
			{
				_loc10_.addToContent(ComponentFactory.Instance.creat(param2 as String));
			}
			if(param6)
			{
				LayerManager.Instance.addToLayer(_loc10_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
			}
			return _loc10_;
		}
		
		private function __helpFrameRespose(param1:FrameEvent) : void
		{
			if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
			{
				SoundManager.instance.playButtonSound();
				param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
				param1.currentTarget.dispose();
			}
		}
	}
}
