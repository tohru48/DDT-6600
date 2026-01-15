package lottery
{
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.loader.LoaderManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.manager.StateManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.utils.RequestVairableCreater;
	import ddt.view.MainToolBar;
	import ddt.view.tips.MultipleLineTip;
	import ddt.view.tips.OneLineTip;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import lottery.contorller.WaitingResultHandler;
	import lottery.data.LotteryCardResultVO;
	import lottery.data.LotteryModel;
	import lottery.data.LotteryResultAnalyzer;
	import lottery.data.LotteryWorldWagerAnalyzer;
	import lottery.view.CardLotteryHelpFrame;
	import lottery.view.CardLotteryResultFrame;
	import lottery.view.LuckyLotteryAwardFrame;
	import lottery.view.LuckyLotteryFailureFrame;
	import lottery.view.LuckyLotteryHelpFrame;
	
	public class LotteryContorller extends BaseStateView
	{
		
		private static const btnArray:Array = ["luckyLottery_btn","cardLottery_btn","luckyHelp_btn","cardHelp_btn","cardResult_btn"];
		
		private static const mcArray:Array = ["luckyLottery_mc","cardLottery_mc","luckyHelp_mc","cardHelp_mc","cardResult_mc"];
		
		private static const btnTipArray:Array = [LanguageMgr.GetTranslation("tank.lottery.luckyLottery.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardLottery.btnTip"),LanguageMgr.GetTranslation("tank.lottery.luckyHelp.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardHelp.btnTip"),LanguageMgr.GetTranslation("tank.lottery.cardResult.btnTip")];
		
		private var _hallAsset:MovieClip;
		
		private var _hallDesc:Bitmap;
		
		private var _worldWagerBg:Bitmap;
		
		private var _worldWagerField:GradientText;
		
		private var _btnMultiTips:MultipleLineTip;
		
		private var _btnTips:OneLineTip;
		
		private var _lotteryResultList:Vector.<LotteryCardResultVO>;
		
		private var _isShowResultFrame:Boolean;
		
		private var _waitHandler:WaitingResultHandler;
		
		private var _alphaGound:Sprite;
		
		public function LotteryContorller()
		{
			super();
		}
		
		override public function enter(prev:BaseStateView, data:Object = null) : void
		{
			this._hallAsset = ComponentFactory.Instance.creat("asset.lotteryHall.hallMainViewAsset");
			addChild(this._hallAsset);
			this._worldWagerField = ComponentFactory.Instance.creatComponentByStylename("lottery.worldWagerTxt");
			addChild(this._worldWagerField);
			this._worldWagerField.text = "";
			this._btnMultiTips = ComponentFactory.Instance.creatCustomObject("lottery.multipleLineTip");
			this._btnTips = ComponentFactory.Instance.creatCustomObject("lottery.oneLineTip");
			MainToolBar.Instance.show();
			this.loadWorldWager();
			this.loadLotteryResult();
			this.addEvent();
		}
		
		private function addEvent() : void
		{
			var idx:int = 0;
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKY_LOTTERY,this.__onLuckyLottery);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,this.__onGotoCardLottery);
			for(var i:int = 0; i < btnArray.length; i++)
			{
				idx = i;
				this._hallAsset[mcArray[idx]].buttonMode = this._hallAsset[mcArray[idx]].mouseEnable = this._hallAsset[mcArray[idx]].mouseChildren = false;
				this._hallAsset[btnArray[idx]].buttonMode = this._hallAsset[btnArray[idx]].mouseEnable = this._hallAsset[btnArray[idx]].mouseChildren = true;
				this._hallAsset[btnArray[idx]].addEventListener(MouseEvent.CLICK,this.__onBtnClick);
				this._hallAsset[btnArray[idx]].addEventListener(MouseEvent.MOUSE_OVER,this.__onBtnOver);
				this._hallAsset[btnArray[idx]].addEventListener(MouseEvent.MOUSE_OUT,this.__onBtnOut);
			}
		}
		
		private function removeEvent() : void
		{
			var idx:int = 0;
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKY_LOTTERY,this.__onLuckyLottery);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,this.__onGotoCardLottery);
			for(var i:int = 0; i < btnArray.length; i++)
			{
				idx = i;
				this._hallAsset[btnArray[idx]].removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
				this._hallAsset[btnArray[idx]].removeEventListener(MouseEvent.MOUSE_OVER,this.__onBtnOver);
				this._hallAsset[btnArray[idx]].removeEventListener(MouseEvent.MOUSE_OUT,this.__onBtnOut);
			}
		}
		
		private function loadWorldWager() : void
		{
			var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
			var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("GetWorldWealth.ashx"),BaseLoader.REQUEST_LOADER,args);
			loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
			loader.analyzer = new LotteryWorldWagerAnalyzer(this.onLoadWorldWagerComplete);
			loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
			LoaderManager.Instance.startLoad(loader);
		}
		
		private function onLoadWorldWagerComplete(analyzer:LotteryWorldWagerAnalyzer) : void
		{
			this._worldWagerField.text = String(analyzer.worldWager);
		}
		
		private function loadLotteryResult() : void
		{
			var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
			var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("QueryWealthDivineNum.ashx"),BaseLoader.REQUEST_LOADER,args);
			loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
			loader.analyzer = new LotteryResultAnalyzer(this.onLoadLotteryResultComplete);
			loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
			LoaderManager.Instance.startLoad(loader);
		}
		
		private function onLoadLotteryResultComplete(analyzer:LotteryResultAnalyzer) : void
		{
			this._lotteryResultList = analyzer.lotteryResultList;
			if(this._isShowResultFrame)
			{
				this.showLotteryResult();
			}
		}
		
		private function __onLoadError(evt:LoaderEvent) : void
		{
		}
		
		private function __onLuckyLottery(evt:CrazyTankSocketEvent) : void
		{
			var result:Object = new Object();
			var code:int = evt.pkg.readInt();
			result["code"] = code;
			if(code == 1)
			{
				result["TemplateId"] = evt.pkg.readInt();
				result["timeLimit"] = evt.pkg.readInt();
			}
			else if(code == 3)
			{
				result["messageTip"] = evt.pkg.readUTF();
				this.onWaitResultComplete(result);
				return;
			}
			if(Boolean(this._waitHandler))
			{
				this._waitHandler.setResult(result);
			}
			else
			{
				this.onWaitResultComplete(result);
			}
		}
		
		private function onWaitResultComplete(result:*) : void
		{
			var luckyAward:LuckyLotteryAwardFrame = null;
			if(result == null)
			{
				return;
			}
			var code:int = int(result["code"]);
			if(code == 1)
			{
				luckyAward = new LuckyLotteryAwardFrame();
				luckyAward.setInfo(result["TemplateId"],result["timeLimit"]);
				this.popupFrame(luckyAward);
			}
			else if(code == 2)
			{
				this.popupFrame(new LuckyLotteryFailureFrame());
			}
			else
			{
				MessageTipManager.getInstance().show(result["messageTip"]);
			}
			MovieClip(this._hallAsset["luckyLottery_mc"]).gotoAndPlay(1);
			this._hallAsset["luckyLottery_btn"].buttonMode = this._hallAsset["luckyLottery_btn"].mouseEnabled = this._hallAsset["luckyLottery_btn"].mouseChildren = true;
			if(Boolean(this._alphaGound.parent))
			{
				this._alphaGound.parent.removeChild(this._alphaGound);
			}
			if(Boolean(this._waitHandler))
			{
				this._waitHandler.dispose();
			}
			this._waitHandler = null;
		}
		
		private function __onGotoCardLottery(evt:CrazyTankSocketEvent) : void
		{
			var isStart:Boolean = evt.pkg.readBoolean();
			var cardLotteryPerMoney:int = evt.pkg.readInt();
			LotteryModel.cardLotteryMoney = Number(cardLotteryPerMoney);
			StateManager.setState(StateType.LOTTERY_CARD);
		}
		
		private function luckLottery() : void
		{
			if(Boolean(this._waitHandler))
			{
				this._waitHandler.dispose();
			}
			this._waitHandler = new WaitingResultHandler(2000,this.onWaitResultComplete);
			this._waitHandler.wait();
			if(this._alphaGound == null)
			{
				this._alphaGound = new Sprite();
				this._alphaGound.graphics.beginFill(0,0.001);
				this._alphaGound.graphics.drawRect(50,50,50,50);
				this._alphaGound.graphics.endFill();
			}
			LayerManager.Instance.addToLayer(this._alphaGound,LayerManager.GAME_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
			SocketManager.Instance.out.sendLuckLottery();
		}
		
		private function __onBtnClick(evt:MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var mcName:String = mcArray[btnArray.indexOf(evt.currentTarget.name)];
			var mc:MovieClip = MovieClip(this._hallAsset[mcName]);
			mc.gotoAndPlay(3);
			switch(evt.currentTarget.name)
			{
				case "luckyLottery_btn":
					evt.currentTarget.buttonMode = evt.currentTarget.mouseEnabled = evt.currentTarget.mouseChildren = false;
					this.luckLottery();
					mc.gotoAndStop(3);
					break;
				case "cardLottery_btn":
					SocketManager.Instance.out.gotoCardLottery();
					break;
				case "luckyHelp_btn":
					this.popupFrame(new LuckyLotteryHelpFrame());
					break;
				case "cardHelp_btn":
					this.popupFrame(new CardLotteryHelpFrame());
					break;
				case "cardResult_btn":
					this.showLotteryResult();
			}
		}
		
		private function __onBtnOver(evt:MouseEvent) : void
		{
			var pos:Point = null;
			var idx:int = int(btnArray.indexOf(evt.currentTarget.name));
			var mcName:String = mcArray[idx];
			var mc:MovieClip = MovieClip(this._hallAsset[mcName]);
			if(mcName == "luckyLottery_mc")
			{
				if(mc.currentFrame != 3)
				{
					mc.gotoAndStop(2);
				}
			}
			else
			{
				mc.gotoAndStop(2);
			}
			var btnTip:OneLineTip = this._btnTips;
			if(mcName == "cardLottery_mc" || mcName == "luckyLottery_mc")
			{
				btnTip = this._btnMultiTips;
			}
			btnTip.tipData = btnTipArray[idx];
			btnTip.visible = true;
			LayerManager.Instance.addToLayer(btnTip,LayerManager.GAME_TOP_LAYER);
			pos = DisplayObject(evt.currentTarget).localToGlobal(new Point(0,0));
			btnTip.x = pos.x;
			btnTip.y = pos.y - btnTip.height;
		}
		
		private function __onBtnOut(evt:MouseEvent) : void
		{
			var mcName:String = mcArray[btnArray.indexOf(evt.currentTarget.name)];
			var mc:MovieClip = MovieClip(this._hallAsset[mcName]);
			if(mcName == "luckyLottery_mc")
			{
				if(mc.currentFrame != 3)
				{
					mc.gotoAndStop(1);
				}
			}
			else
			{
				mc.gotoAndStop(1);
			}
			if(Boolean(this._btnTips.parent))
			{
				this._btnTips.parent.removeChild(this._btnTips);
			}
			if(Boolean(this._btnMultiTips.parent))
			{
				this._btnMultiTips.parent.removeChild(this._btnMultiTips);
			}
		}
		
		override public function leaving(next:BaseStateView) : void
		{
			this.removeEvent();
			if(Boolean(this._hallAsset))
			{
				ObjectUtils.disposeObject(this._hallAsset);
			}
			this._hallAsset = null;
			if(Boolean(this._worldWagerField))
			{
				ObjectUtils.disposeObject(this._worldWagerField);
			}
			this._worldWagerField = null;
			if(Boolean(this._btnTips))
			{
				ObjectUtils.disposeObject(this._btnTips);
			}
			this._btnTips = null;
			if(Boolean(this._btnMultiTips))
			{
				ObjectUtils.disposeObject(this._btnMultiTips);
			}
			this._btnMultiTips = null;
			super.leaving(next);
		}
		
		public function showLotteryResult() : void
		{
			if(this._lotteryResultList == null)
			{
				this.loadLotteryResult();
				this._isShowResultFrame = true;
			}
			else
			{
				this.popupFrame(new CardLotteryResultFrame(this._lotteryResultList));
			}
		}
		
		private function popupFrame(frame:Sprite) : void
		{
			LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
		}
		
		override public function getBackType() : String
		{
			return StateType.MAIN;
		}
		
		override public function getType() : String
		{
			return StateType.LOTTERY_HALL;
		}
	}
}

