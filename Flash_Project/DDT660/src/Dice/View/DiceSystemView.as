package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.DiceManager;
   import Dice.Event.DiceEvent;
   import Dice.VO.DiceAwardCell;
   import Dice.VO.DiceAwardInfo;
   import Dice.VO.DicePlayer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DiceSystemView extends Sprite implements Disposeable
   {
      
      private var _controller:DiceController;
      
      private var _bg:Bitmap;
      
      private var _luckIntegralView:DiceLuckIntegralView;
      
      private var _dicePanel:DiceSystemPanel;
      
      private var _rewardPanel:DiceRewarditemsBar;
      
      private var _toolbarView:DiceToolBar;
      
      private var _helpBtn:BaseButton;
      
      private var _helpFrame:Frame;
      
      private var _helpBG:Scale9CornerImage;
      
      private var _okBtn:TextButton;
      
      private var _content:MovieClip;
      
      private var _returnBtn:DiceReturnBar;
      
      private var _player:DicePlayer;
      
      private var _playView:DiceStartView;
      
      private var _treasureBoxArr:Array = [];
      
      private var start:int;
      
      private var end:int;
      
      public function DiceSystemView(control:DiceController)
      {
         super();
         this._controller = control;
         this.preInitialize();
         this.initialize();
         this.addEvent();
      }
      
      private function preInitialize() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.dice.mainBG");
         this._returnBtn = ComponentFactory.Instance.creat("asset.dice.returnMenu");
         this._toolbarView = ComponentFactory.Instance.creat("asset.dice.ToolBar");
         this._dicePanel = ComponentFactory.Instance.creat("asset.dice.dicePanel");
         this._rewardPanel = ComponentFactory.Instance.creat("asset.dice.diceRewardItemsBar");
         this._luckIntegralView = ComponentFactory.Instance.creat("asset.dice.luckIntegralView");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.helpBtn");
         this._playView = ComponentFactory.Instance.creatCustomObject("asset.dice.diceStartView");
         this._player = new DicePlayer();
         for(var i:int = 0; i < DiceController.Instance.MAX_LEVEL; i++)
         {
            this._treasureBoxArr[i] = ComponentFactory.Instance.creat("asset.dice.treasureBox.down" + (i + 1));
            PositionUtils.setPos(this._treasureBoxArr[i],"asset.dice.treasuerBox.down.pos");
         }
      }
      
      private function initialize() : void
      {
         addChild(this._bg);
         addChild(this._toolbarView);
         addChild(this._returnBtn);
         addChild(this._rewardPanel);
         addChild(this._dicePanel);
         addChild(this._helpBtn);
         this._dicePanel.Controller = this._controller;
         addChild(this._player);
         this._player.CurrentPosition = DiceController.Instance.CurrentPosition;
         addChild(this._luckIntegralView);
      }
      
      private function addEvent() : void
      {
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         DiceManager.Instance.addEventListener(DiceEvent.RETURN_DICE,this.__onReturn);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL,this.__onLuckIntegralChanged);
         DiceController.Instance.addEventListener(DiceEvent.ACTIVE_CLOSE,this.__onActiveClose);
         DiceController.Instance.addEventListener(DiceEvent.MOVIE_FINISH,this.__onMovieFinish);
         DiceController.Instance.addEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         DiceController.Instance.addEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_PLAYER_POSITION,this.__onPlayerPositionChanged);
      }
      
      private function __onReturn(event:DiceEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.MAIN);
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         DiceManager.Instance.removeEventListener(DiceEvent.RETURN_DICE,this.__onReturn);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL,this.__onLuckIntegralChanged);
         DiceController.Instance.removeEventListener(DiceEvent.ACTIVE_CLOSE,this.__onActiveClose);
         DiceController.Instance.removeEventListener(DiceEvent.MOVIE_FINISH,this.__onMovieFinish);
         DiceController.Instance.removeEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         DiceController.Instance.removeEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_PLAYER_POSITION,this.__onPlayerPositionChanged);
      }
      
      private function __onActiveClose(event:DiceEvent) : void
      {
         StateManager.setState(StateType.MAIN);
         this.dispose();
      }
      
      private function __onMovieFinish(event:DiceEvent) : void
      {
         this._player.PlayerWalkByPosition(this.start,this.end);
      }
      
      private function __getDiceResultData(event:DiceEvent) : void
      {
         this.start = int(event.resultData.position);
         this.end = (this.start + int(event.resultData.result)) % DiceController.Instance.CELL_COUNT;
         this.end += this.start > this.end && !DiceController.Instance.hasUsedFirstCell ? 1 : 0;
         if(Boolean(this._playView))
         {
            addChild(this._playView);
            swapChildren(this._playView,this._player);
            this._playView.play(DiceController.Instance.diceType,event.resultData.result);
         }
      }
      
      private function __onPlayerPositionChanged(event:DiceEvent) : void
      {
         this._player.CurrentPosition = DiceController.Instance.CurrentPosition;
      }
      
      private function __onPlayerState(event:DiceEvent) : void
      {
         this.__onLuckIntegralChanged(null);
         if(!event.resultData.isWalking)
         {
            this._playView.removeAllMovie();
         }
      }
      
      private function __onLuckIntegralChanged(event:DiceEvent) : void
      {
         var level:int = 0;
         var movie:MovieClip = null;
         if(DiceController.Instance.isPlayDownMovie)
         {
            DiceController.Instance.isPlayDownMovie = false;
            level = DiceController.Instance.LuckIntegralLevel;
            level -= 1;
            if(level == -1)
            {
               level = DiceController.Instance.MAX_LEVEL - 1;
            }
            movie = this._treasureBoxArr[level];
            movie.buttonMode = true;
            movie.addEventListener(MouseEvent.CLICK,this.__onDownTreasureBoxClick);
            movie.gotoAndPlay(2);
            LayerManager.Instance.addToLayer(movie,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __onDownTreasureBoxClick(event:MouseEvent) : void
      {
         var msg:String = null;
         var level:int = 0;
         var _templateInfo:Vector.<DiceAwardCell> = null;
         var i:int = 0;
         var movie:MovieClip = event.currentTarget as MovieClip;
         movie.removeEventListener(MouseEvent.CLICK,this.__onDownTreasureBoxClick);
         if(Boolean(movie.parent))
         {
            msg = LanguageMgr.GetTranslation("dice.Levelreward.caption");
            level = DiceController.Instance.LuckIntegralLevel;
            level -= 1;
            if(level == -1)
            {
               level = DiceController.Instance.MAX_LEVEL - 1;
            }
            _templateInfo = (DiceController.Instance.AwardLevelInfo[level] as DiceAwardInfo).templateInfo;
            for(i = 0; i < _templateInfo.length; i++)
            {
               msg += (_templateInfo[i] as DiceAwardCell).info.Name + "*" + (_templateInfo[i] as DiceAwardCell).count + "   ";
            }
            MessageTipManager.getInstance().show(msg,0,true);
            movie.parent.removeChild(movie);
         }
      }
      
      private function __onHelpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._helpFrame == null)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("asset.dice.helpFrame");
            this._helpBG = ComponentFactory.Instance.creatComponentByStylename("asset.dice.help.BG");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.helpFrame.OK");
            this._content = ComponentFactory.Instance.creat("asset.dice.helpConent");
            this._content.x = 55;
            this._content.y = 85;
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("dice.help.Title");
            this._helpFrame.addToContent(this._okBtn);
            this._helpFrame.addToContent(this._helpBG);
            this._helpFrame.addToContent(this._content);
            this._okBtn.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         DiceController.Instance.isPlayDownMovie = false;
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
         ObjectUtils.disposeObject(this._helpBG);
         this._helpBG = null;
         ObjectUtils.disposeObject(this._okBtn);
         this._okBtn = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._rewardPanel);
         this._rewardPanel = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         ObjectUtils.disposeObject(this._toolbarView);
         this._toolbarView = null;
         ObjectUtils.disposeObject(this._dicePanel);
         this._dicePanel = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._luckIntegralView);
         this._luckIntegralView = null;
         ObjectUtils.disposeObject(this._playView);
         this._playView = null;
         for(var i:int = int(this._treasureBoxArr.length); i > 0; i--)
         {
            ObjectUtils.disposeObject(this._treasureBoxArr[i - 1]);
            this._treasureBoxArr[i - 1] = null;
         }
         this._treasureBoxArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

