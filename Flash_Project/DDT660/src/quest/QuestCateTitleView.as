package quest
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.ScaleFrameImage;
	import com.pickgliss.utils.ClassUtils;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.utils.PositionUtils;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	public class QuestCateTitleView extends Sprite implements Disposeable
	{
		
		private var _type:int;
		
		private var _isExpanded:Boolean;
		
		private static const rLum:Number = 0.2225;
		private static const gLum:Number = 0.7169;
		private static const bLum:Number = 0.0606;
		
		private static var bwMatrix:Array = [
			QuestCateTitleView.rLum, QuestCateTitleView.gLum, QuestCateTitleView.bLum, 0, 0,
			QuestCateTitleView.rLum, QuestCateTitleView.gLum, QuestCateTitleView.bLum, 0, 0,
			QuestCateTitleView.rLum, QuestCateTitleView.gLum, QuestCateTitleView.bLum, 0, 0,
			0, 0, 0, 1, 0
		];
		
		private var cmf:ColorMatrixFilter;
		
		private var bg:ScaleFrameImage;
		
		private var titleImg:ScaleFrameImage;
		
		private var titleIconImg:ScaleFrameImage;
		
		private var bmpNEW:MovieClip;
		
		private var bmpOK:Bitmap;
		
		private var bmpRecommond:Bitmap;
		
		private var _expandBg:DisplayObject;
		
		public function QuestCateTitleView(cateID:int = 0)
		{
			super();
			this._type = cateID;
			this.cmf = new ColorMatrixFilter(bwMatrix);
			this.initView();
			this.initEvent();
			this.isExpanded = false;
		}
		
		override public function get width() : Number
		{
			return this.bg.width;
		}
		
		override public function get height() : Number
		{
			return this.bg.height;
		}
		
		private function initView() : void
		{
			buttonMode = true;
			this.bg = ComponentFactory.Instance.creatComponentByStylename("quest.QuestCateTitleBG");
			addChild(this.bg);
			this.bg.setFrame(1);
			this.titleImg = ComponentFactory.Instance.creat("core.quest.MCQuestCateTitle");
			addChild(this.titleImg);
			this._expandBg = ComponentFactory.Instance.creatCustomObject("asset.core.QuestCateExpandBg");
			this._expandBg.visible = false;
			addChild(this._expandBg);
			this.titleIconImg = ComponentFactory.Instance.creat("core.quest.MCQuestCateTitleIcon");
			addChild(this.titleIconImg);
			this.titleIconImg.setFrame(this._type + 1);
			this.bmpNEW = ClassUtils.CreatInstance("asset.quest.newMovie") as MovieClip;
			this.bmpNEW.visible = false;
			addChild(this.bmpNEW);
			PositionUtils.setPos(this.bmpNEW,"quest.bmpNEWPos");
			this.bmpOK = ComponentFactory.Instance.creat("asset.core.quest.textImg.OK");
			this.bmpOK.visible = false;
			PositionUtils.setPos(this.bmpOK,"asset.core.questcateTile.okPos");
			addChild(this.bmpOK);
			this.bmpRecommond = ComponentFactory.Instance.creatBitmap("asset.core.quest.recommend");
			this.bmpRecommond.rotation = 15;
			this.bmpRecommond.smoothing = true;
			PositionUtils.setPos(this.bmpRecommond,"quest.cateTitleView.recommendPos");
			this.bmpRecommond.visible = false;
			addChild(this.bmpRecommond);
		}
		
		private function initEvent() : void
		{
		}
		
		public function set taskStyle(style:int) : void
		{
			this.bg.setFrame(style);
		}
		
		public function set enable(value:Boolean) : void
		{
			if(!value)
			{
				filters = [this.cmf];
				buttonMode = false;
				mouseChildren = false;
				mouseEnabled = false;
			}
			else
			{
				filters = null;
				buttonMode = true;
				mouseEnabled = true;
				mouseChildren = true;
			}
		}
		
		public function get isExpanded() : Boolean
		{
			return this._isExpanded;
		}
		
		public function set isExpanded(value:Boolean) : void
		{
			this._isExpanded = value;
			if(value == true)
			{
				this.bg.setFrame(2);
				this.titleImg.setFrame(this._type + 8);
			}
			else
			{
				this.bg.setFrame(1);
				this.titleImg.setFrame(this._type + 1);
			}
			this._expandBg.visible = this._isExpanded;
		}
		
		public function haveNew() : void
		{
			this.bmpNEW.visible = true;
			this.bmpNEW.gotoAndPlay(1);
			this.bmpOK.visible = false;
			this.bmpRecommond.visible = false;
		}
		
		public function haveCompleted() : void
		{
			this.bmpNEW.visible = false;
			this.bmpOK.visible = true;
			this.bmpRecommond.visible = false;
		}
		
		public function haveNoTag() : void
		{
			this.bmpNEW.visible = false;
			this.bmpOK.visible = false;
			this.bmpRecommond.visible = false;
		}
		
		public function haveRecommond() : void
		{
			this.bmpNEW.visible = false;
			this.bmpOK.visible = false;
			this.bmpRecommond.visible = true;
		}
		
		public function dispose() : void
		{
			bwMatrix = null;
			this.cmf = null;
			ObjectUtils.disposeObject(this.titleIconImg);
			this.titleIconImg = null;
			if(Boolean(this.bg))
			{
				ObjectUtils.disposeObject(this.bg);
			}
			this.bg = null;
			if(Boolean(this.titleImg))
			{
				ObjectUtils.disposeObject(this.titleImg);
			}
			this.titleImg = null;
			if(Boolean(this.bmpNEW))
			{
				ObjectUtils.disposeObject(this.bmpNEW);
			}
			this.bmpNEW = null;
			if(Boolean(this.bmpOK))
			{
				ObjectUtils.disposeObject(this.bmpOK);
			}
			this.bmpOK = null;
			if(Boolean(this.bmpRecommond))
			{
				ObjectUtils.disposeObject(this.bmpRecommond);
			}
			this.bmpRecommond = null;
			if(Boolean(parent))
			{
				parent.removeChild(this);
			}
		}
	}
}

