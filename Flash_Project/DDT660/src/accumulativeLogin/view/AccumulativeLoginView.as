package accumulativeLogin.view
{
   import accumulativeLogin.AccumulativeManager;
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   import wonderfulActivity.views.IRightView;
   
   public class AccumulativeLoginView extends Sprite implements IRightView
   {
      
      private var _back:Bitmap;
      
      private var _progressBarBack:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _progressBarItemArr:Array;
      
      private var _clickSpriteArr:Array;
      
      private var _progressCompleteItem:MovieClip;
      
      private var _dayTxtArr:Array;
      
      private var _loginDayTxt:FilterFrameText;
      
      private var _loginDayNum:int;
      
      private var _awardDayNum:int;
      
      private var _hBox:HBox;
      
      private var _dataDic:Dictionary;
      
      private var _selectedDay:int;
      
      private var _selectedFiveWeaponId:int;
      
      private var _dayGiftPackDic:Dictionary;
      
      private var _fiveWeaponArr:Array;
      
      private var _bagCellBgArr:Array;
      
      private var _filter:ColorMatrixFilter;
      
      private var _movieStringArr:Array = ["wonderfulactivity.login.gun","wonderfulactivity.login.axe","wonderfulactivity.login.chick","wonderfulactivity.login.boomerang"];
      
      private var _movieVector:Vector.<AccumulativeMovieSprite>;
      
      private var _getButton:SimpleBitmapButton;
      
      public function AccumulativeLoginView()
      {
         super();
         this._movieVector = new Vector.<AccumulativeMovieSprite>();
         this._progressBarItemArr = new Array();
         this._clickSpriteArr = new Array();
         this._dayTxtArr = new Array();
         this._dayGiftPackDic = new Dictionary();
         this._bagCellBgArr = new Array();
         this._fiveWeaponArr = new Array();
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function init() : void
      {
         this.createFilter();
         this.initEvent();
         this.initView();
         this.initData();
         this.initViewWithData();
         this.selectedDay = this._loginDayNum;
      }
      
      private function createFilter() : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this._filter = new ColorMatrixFilter(matrix);
      }
      
      public function initEvent() : void
      {
         AccumulativeManager.instance.addEventListener(AccumulativeManager.ACCUMULATIVE_AWARD_REFRESH,this.__refreshAward);
      }
      
      protected function __refreshAward(event:Event) : void
      {
         this._loginDayNum = PlayerManager.Instance.Self.accumulativeLoginDays > 7 ? 7 : PlayerManager.Instance.Self.accumulativeLoginDays;
         this._awardDayNum = PlayerManager.Instance.Self.accumulativeAwardDays;
         this.checkMovieCanClick();
         if(this._awardDayNum >= this._loginDayNum)
         {
            this._getButton.enable = false;
         }
         else
         {
            this._getButton.enable = true;
         }
         this.selectedDay = this._selectedDay;
      }
      
      private function initView() : void
      {
         var dayTxt:FilterFrameText = null;
         var progressBarItem:Bitmap = null;
         var clickSp:Sprite = null;
         var movieClip:AccumulativeMovieSprite = null;
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.login.back");
         addChild(this._back);
         this._loginDayTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.accumulativeLogin.dayTxt");
         addChild(this._loginDayTxt);
         for(var j:int = 1; j < 8; j++)
         {
            dayTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.accumulativeLogin.dayTxt");
            addChild(dayTxt);
            dayTxt.text = "" + j;
            dayTxt.x = j == 7 ? 700 : 334 + 62 * (j - 1);
            dayTxt.y = 150;
            this._dayTxtArr.push(dayTxt);
         }
         this._progressBarBack = ComponentFactory.Instance.creat("wonderfulactivity.login.barback");
         addChild(this._progressBarBack);
         this._progressBar = ComponentFactory.Instance.creat("wonderfulactivity.login.bar");
         addChild(this._progressBar);
         for(var k:int = 0; k < 6; k++)
         {
            progressBarItem = ComponentFactory.Instance.creat("wonderfulactivity.login.barItem");
            progressBarItem.x = 334 + 62 * k;
            progressBarItem.y = 170;
            addChild(progressBarItem);
            this._progressBarItemArr.push(progressBarItem);
         }
         this._progressCompleteItem = ComponentFactory.Instance.creat("wonderfulactivity.login.barCompleteItem");
         addChild(this._progressCompleteItem);
         this._progressCompleteItem.y = 170;
         for(var ll:int = 0; ll < 7; ll++)
         {
            clickSp = new Sprite();
            clickSp.buttonMode = true;
            clickSp.graphics.beginFill(0,0);
            if(ll != 6)
            {
               clickSp.graphics.drawRect(this._progressBarItemArr[ll].x,170,this._progressBarItemArr[ll].width,this._progressBarItemArr[ll].height);
            }
            else
            {
               clickSp.graphics.drawRect(this._progressBarItemArr[5].x + 58,170,this._progressBarItemArr[5].width + 8,this._progressBarItemArr[5].height);
            }
            clickSp.graphics.endFill();
            clickSp.addEventListener(MouseEvent.CLICK,this.__showAwardHandler);
            addChild(clickSp);
            this._clickSpriteArr.push(clickSp);
         }
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulativeLogin.Hbox");
         addChild(this._hBox);
         for(var i:int = 0; i < this._movieStringArr.length; i++)
         {
            movieClip = new AccumulativeMovieSprite(this._movieStringArr[i]);
            movieClip.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
            addChild(movieClip);
            PositionUtils.setPos(movieClip,"wonderful.accumulativeLogin.moviePos" + (i + 1));
            this._movieVector.push(movieClip);
         }
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      protected function __showAwardHandler(event:MouseEvent) : void
      {
         var index:int = int(this._clickSpriteArr.indexOf(event.target));
         if(index != -1 && index + 1 != this.selectedDay)
         {
            this.selectedDay = index + 1;
         }
      }
      
      protected function __onClickHandler(event:MouseEvent) : void
      {
         var movie:AccumulativeMovieSprite = null;
         if(this._loginDayNum < 7)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulactivity.accumulativelogin.txt"));
            return;
         }
         if(event.currentTarget.state == 3)
         {
            return;
         }
         for each(movie in this._movieVector)
         {
            if(movie == event.currentTarget)
            {
               movie.state = 3;
               this._selectedFiveWeaponId = movie.data.ID;
            }
            else
            {
               movie.state = 1;
            }
         }
      }
      
      protected function __onOverHandler(event:MouseEvent) : void
      {
         (event.target as MovieClip).gotoAndPlay(2);
      }
      
      private function checkMovieCanClick() : void
      {
         var movie:AccumulativeMovieSprite = null;
         var accMovie:AccumulativeMovieSprite = null;
         if(this._loginDayNum >= 7 && this._awardDayNum >= 7)
         {
            for each(movie in this._movieVector)
            {
               movie.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
               movie.state = 1;
            }
         }
         if(this._loginDayNum >= 7 && this._awardDayNum < 7)
         {
            for each(accMovie in this._movieVector)
            {
               accMovie.state = 2;
            }
         }
      }
      
      private function initData() : void
      {
         this._loginDayNum = PlayerManager.Instance.Self.accumulativeLoginDays > 7 ? 7 : PlayerManager.Instance.Self.accumulativeLoginDays;
         this._awardDayNum = PlayerManager.Instance.Self.accumulativeAwardDays;
         if(this._awardDayNum < this._loginDayNum && this._awardDayNum < 7)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
         else
         {
            this._getButton.enable = false;
         }
         this._dataDic = AccumulativeManager.instance.dataDic;
      }
      
      private function initViewWithData() : void
      {
         var arr:Array = null;
         var data:AccumulativeLoginRewardData = null;
         var bagCellSp:Sprite = null;
         this.checkMovieCanClick();
         this._loginDayTxt.text = "" + this._loginDayNum;
         if(this._loginDayNum < 7)
         {
            this._progressBar.width = Boolean(this._progressBarItemArr[this._loginDayNum - 1]) ? this._progressBarItemArr[this._loginDayNum - 1].x - 265 : 0;
            this._progressCompleteItem.x = this._progressBar.width + 256;
         }
         else if(this._loginDayNum >= 7)
         {
            this._progressBar.width = this._progressBarItemArr[5].x - 265 + 55;
            this._progressCompleteItem.x = this._progressBar.width + 258;
         }
         if(!this._dataDic)
         {
            return;
         }
         for(var k:int = 1; k < 8; k++)
         {
            arr = new Array();
            for each(data in this._dataDic[k])
            {
               bagCellSp = this.createBagCellSp(data,k);
               arr.push(bagCellSp);
            }
            this._dayGiftPackDic[k] = arr;
         }
         for(var i:int = 0; i < this._movieVector.length; i++)
         {
            this._movieVector[i].tipData = this._fiveWeaponArr[i].tipData;
            this._movieVector[i].data = this._dataDic[7][i];
         }
      }
      
      private function __getAward(event:MouseEvent) : void
      {
         if(this._loginDayNum >= 7 && this._selectedFiveWeaponId == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulactivity.accumulativelogin.txt2"));
            return;
         }
         SocketManager.Instance.out.sendAccumulativeLoginAward(this._selectedFiveWeaponId);
      }
      
      private function set selectedDay(value:int) : void
      {
         var bagCellSp:Sprite = null;
         this._selectedDay = value;
         if(this._selectedDay > 7)
         {
            this._selectedDay = 7;
         }
         this._hBox.removeAllChild();
         for each(bagCellSp in this._dayGiftPackDic[this._selectedDay])
         {
            if(this._selectedDay <= this._awardDayNum)
            {
               this.graySp(bagCellSp);
            }
            else
            {
               bagCellSp.filters = null;
            }
            this._hBox.addChild(bagCellSp);
         }
      }
      
      private function graySp(sp:Sprite) : void
      {
         sp.filters = [this._filter];
      }
      
      private function get selectedDay() : int
      {
         return this._selectedDay;
      }
      
      private function createBagCellSp(data:AccumulativeLoginRewardData, index:int) : Sprite
      {
         var sp:Sprite = null;
         sp = new Sprite();
         var bagCellBg:Bitmap = ComponentFactory.Instance.creat("wonderfulactivity.login.bagCellBg");
         bagCellBg.scaleX = bagCellBg.scaleY = 0.7;
         sp.addChild(bagCellBg);
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = data.RewardItemID;
         info = ItemManager.fill(info);
         info.IsBinds = data.IsBind;
         info.ValidDate = data.RewardItemValid;
         info._StrengthenLevel = data.StrengthenLevel;
         info.AttackCompose = data.AttackCompose;
         info.DefendCompose = data.DefendCompose;
         info.AgilityCompose = data.AgilityCompose;
         info.LuckCompose = data.LuckCompose;
         var bagCell:BagCell = new BagCell(0);
         bagCell.info = info;
         bagCell.setCount(data.RewardItemCount);
         bagCell.setBgVisible(false);
         bagCell.x = bagCell.y = 4;
         sp.addChild(bagCell);
         if(index == 7)
         {
            this._fiveWeaponArr.push(bagCell);
         }
         return sp;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var bagCellArr:Array = null;
         var bCell:BagCell = null;
         var i:int = 0;
         var bitmap:Bitmap = null;
         var sp:Sprite = null;
         var txt:FilterFrameText = null;
         var k:int = 0;
         var sprite:Sprite = null;
         AccumulativeManager.instance.removeEventListener(AccumulativeManager.ACCUMULATIVE_AWARD_REFRESH,this.__refreshAward);
         for each(bagCellArr in this._dayGiftPackDic)
         {
            for(k = 0; k < bagCellArr.length; k++)
            {
               sprite = bagCellArr[k];
               ObjectUtils.disposeAllChildren(sprite);
               ObjectUtils.disposeObject(sprite);
            }
         }
         this._dayGiftPackDic = null;
         for each(bCell in this._fiveWeaponArr)
         {
            ObjectUtils.disposeObject(bCell);
            bCell = null;
         }
         this._fiveWeaponArr = null;
         for(i = 0; i < this._movieVector.length; i++)
         {
            this._movieVector[i].removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
            this._movieVector[i].dispose();
            this._movieVector[i] = null;
         }
         this._movieVector = null;
         for each(bitmap in this._progressBarItemArr)
         {
            if(Boolean(bitmap))
            {
               ObjectUtils.disposeObject(bitmap);
            }
            bitmap = null;
         }
         this._progressBarItemArr = null;
         for each(sp in this._clickSpriteArr)
         {
            if(Boolean(sp))
            {
               sp.graphics.clear();
            }
            sp.removeEventListener(MouseEvent.CLICK,this.__showAwardHandler);
            sp = null;
         }
         this._clickSpriteArr = null;
         for each(txt in this._dayTxtArr)
         {
            if(Boolean(txt))
            {
               ObjectUtils.disposeObject(txt);
            }
            txt = null;
         }
         this._dayTxtArr = null;
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(Boolean(this._progressCompleteItem))
         {
            ObjectUtils.disposeObject(this._progressCompleteItem);
         }
         this._progressCompleteItem = null;
         if(Boolean(this._loginDayTxt))
         {
            ObjectUtils.disposeObject(this._loginDayTxt);
         }
         this._loginDayTxt = null;
         if(Boolean(this._progressBarBack))
         {
            ObjectUtils.disposeObject(this._progressBarBack);
         }
         this._progressBarBack = null;
         if(Boolean(this._progressBar))
         {
            ObjectUtils.disposeObject(this._progressBar);
         }
         this._progressBar = null;
         if(Boolean(this._getButton))
         {
            this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         }
         ObjectUtils.disposeObject(this._getButton);
         this._getButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

