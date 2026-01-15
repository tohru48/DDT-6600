package eliteGame.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.DDT;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EliteGameRuleView extends Sprite implements Disposeable
   {
      
      private var _rulebg:Scale9CornerImage;
      
      private var _scroll:ScrollPanel;
      
      private var _ruleBmp:MovieClip;
      
      private var _btnbg:ScaleBitmapImage;
      
      private var _award30_40:SelectedButton;
      
      private var _award41_60:SelectedButton;
      
      private var _levelSelGroup:SelectedButtonGroup;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _hBox:HBox;
      
      private var _textHBox:HBox;
      
      private var _sixteen:SelectedTextButton;
      
      private var _eight:SelectedTextButton;
      
      private var _four:SelectedTextButton;
      
      private var _two:SelectedTextButton;
      
      private var _one:SelectedTextButton;
      
      private var _rewardBg1:MutipleImage;
      
      private var _rewardBg2:Scale9CornerImage;
      
      private var _joinScoreRoom:TextButton;
      
      private var _showRank:TextButton;
      
      private var _goodsCountText:FilterFrameText;
      
      private var _goodsCountArray:Array = new Array(8);
      
      private var _awardHbox:HBox;
      
      private var _cells:Vector.<BaseCell>;
      
      private var _is30_40:Boolean = true;
      
      public function EliteGameRuleView()
      {
         super();
         this.initView();
         this.initEvent();
         this._is30_40 = !(PlayerManager.Instance.Self.Grade >= 40 && PlayerManager.Instance.Self.Grade <= 60);
         this._btnGroup.selectIndex = 4;
      }
      
      private function initView() : void
      {
         this._rulebg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.bg");
         this._scroll = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.scroll");
         this._ruleBmp = ClassUtils.CreatInstance("asset.ddtelitegame.rule") as MovieClip;
         PositionUtils.setPos(this._ruleBmp,"ddteliteGame.Preview.ruleview.staicText.pos");
         this._award30_40 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.award30_40");
         this._award30_40.autoSelect = true;
         this._award41_60 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.award41_60");
         this._levelSelGroup = new SelectedButtonGroup();
         this._levelSelGroup.addSelectItem(this._award30_40);
         this._levelSelGroup.addSelectItem(this._award41_60);
         this._levelSelGroup.selectIndex = 1;
         this._btnGroup = new SelectedButtonGroup();
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.hbox");
         this._sixteen = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.sixteen");
         this._eight = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.eight");
         this._four = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.four");
         this._two = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.two");
         this._one = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.two");
         this._rewardBg1 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.rewardBg1");
         this._rewardBg2 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.rewardBg2");
         this._btnbg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.btnBg");
         this._joinScoreRoom = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.joinRoom");
         this._showRank = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.showRank");
         this._awardHbox = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.awardhbox");
         this._textHBox = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.Texthbox");
         this._joinScoreRoom.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.createRoom");
         this._showRank.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.check16");
         addChild(this._rulebg);
         addChild(this._scroll);
         addChild(this._award30_40);
         addChild(this._award41_60);
         addChild(this._rewardBg1);
         addChild(this._rewardBg2);
         addChild(this._hBox);
         addChild(this._btnbg);
         addChild(this._joinScoreRoom);
         addChild(this._showRank);
         addChild(this._awardHbox);
         addChild(this._textHBox);
         this._cells = new Vector.<BaseCell>(8);
         for(var i:int = 0; i < 8; i++)
         {
            this._cells[i] = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.awardcellBg"));
            this._awardHbox.addChild(this._cells[i]);
            this._goodsCountText = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.Preview.ruleview.goodsCount");
            this._goodsCountArray[i] = this._goodsCountText;
            this._textHBox.addChild(this._goodsCountArray[i]);
         }
         this._hBox.addChild(this._sixteen);
         this._hBox.addChild(this._eight);
         this._hBox.addChild(this._four);
         this._hBox.addChild(this._two);
         this._hBox.addChild(this._one);
         this._btnGroup.addSelectItem(this._one);
         this._btnGroup.addSelectItem(this._two);
         this._btnGroup.addSelectItem(this._four);
         this._btnGroup.addSelectItem(this._eight);
         this._btnGroup.addSelectItem(this._sixteen);
         this._scroll.setView(this._ruleBmp);
         this._sixteen.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.btn16");
         this._eight.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.btn8");
         this._four.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.btn4");
         this._two.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.btn2");
         this._one.text = LanguageMgr.GetTranslation("ddt.elitegame.preview.ruleview.btn1");
         this._joinScoreRoom.enable = false;
         this.checkState();
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._award30_40.addEventListener(MouseEvent.CLICK,this.__award30_40handler);
         this._award41_60.addEventListener(MouseEvent.CLICK,this.__award41_60handler);
         this._joinScoreRoom.addEventListener(MouseEvent.CLICK,this.__joinHandler);
         this._showRank.addEventListener(MouseEvent.CLICK,this.__showHandler);
         EliteGameController.Instance.addEventListener(EliteGameEvent.ELITEGAME_STATE_CHANGE,this.__stateChangeHandler);
         EliteGameController.Instance.addEventListener(EliteGameEvent.AWARD_DATA_READY,this.__awardDataHandler);
      }
      
      private function __awardDataHandler(event:EliteGameEvent) : void
      {
         this.upaward();
      }
      
      protected function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this._hBox.arrange();
         this.upaward();
      }
      
      private function __award30_40handler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._is30_40 = true;
         this.upaward();
      }
      
      private function __award41_60handler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._is30_40 = false;
         this.upaward();
      }
      
      private function upaward() : void
      {
         var vec:Vector.<InventoryItemInfo> = null;
         var i:int = 0;
         if(EliteGameController.Instance.Model.award30_39 != null && EliteGameController.Instance.Model.award40_60 != null)
         {
            vec = this._is30_40 ? EliteGameController.Instance.Model.award30_39[(this._btnGroup.selectIndex + 1).toString()] : EliteGameController.Instance.Model.award40_60[(this._btnGroup.selectIndex + 1).toString()];
            for(i = 0; i < 8; i++)
            {
               this._cells[i].info = i < vec.length ? vec[i] : null;
               this._goodsCountArray[i].text = i < vec.length ? vec[i].Count.toString() : "";
            }
         }
      }
      
      private function checkState() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 30 && PlayerManager.Instance.Self.Grade <= 40 && this.hasState(EliteGameController.SCORE_PHASE_30_40) || PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= DDT.THE_HIGHEST_LV && this.hasState(EliteGameController.SCORE_PHASE_41_50))
         {
            this._joinScoreRoom.enable = true;
         }
         else
         {
            this._joinScoreRoom.enable = false;
         }
         if(this.hasState(EliteGameController.CHAMPION_PHASE_30_40) || this.hasState(EliteGameController.CHAMPION_PHASE_41_50))
         {
         }
      }
      
      private function hasState(state:int) : Boolean
      {
         var arr:Array = EliteGameController.Instance.getState();
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == state)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function __stateChangeHandler(event:Event) : void
      {
         this.checkState();
      }
      
      protected function __showHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         EliteGameController.Instance.alertPaarungFrame();
      }
      
      protected function __joinHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         EliteGameController.Instance.joinEliteGame();
      }
      
      public function dispose() : void
      {
         this._joinScoreRoom.removeEventListener(MouseEvent.CLICK,this.__joinHandler);
         this._showRank.removeEventListener(MouseEvent.CLICK,this.__showHandler);
         EliteGameController.Instance.removeEventListener(EliteGameEvent.ELITEGAME_STATE_CHANGE,this.__stateChangeHandler);
         if(Boolean(this._ruleBmp))
         {
            ObjectUtils.disposeObject(this._ruleBmp);
         }
         this._ruleBmp = null;
         if(Boolean(this._btnbg))
         {
            ObjectUtils.disposeObject(this._btnbg);
         }
         this._btnbg = null;
         if(Boolean(this._joinScoreRoom))
         {
            ObjectUtils.disposeObject(this._joinScoreRoom);
         }
         this._joinScoreRoom = null;
         if(Boolean(this._showRank))
         {
            ObjectUtils.disposeObject(this._showRank);
         }
         this._showRank = null;
         if(Boolean(this._goodsCountText))
         {
            ObjectUtils.disposeObject(this._goodsCountText);
         }
         this._goodsCountText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

