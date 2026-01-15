package horse.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddtDeed.DeedManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.utils.getTimer;
   import horse.HorseManager;
   import horse.data.HorseSkillExpVo;
   import horse.data.HorseSkillGetVo;
   import shop.manager.ShopBuyManager;
   
   public class HorseSkillUpFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _expBg:Bitmap;
      
      private var _expCover:Bitmap;
      
      private var _expPerTxt:FilterFrameText;
      
      private var _rightArrow:Bitmap;
      
      private var _countTitleTxt:FilterFrameText;
      
      private var _txtBg:Bitmap;
      
      private var _countTxt:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _upBtn:SimpleBitmapButton;
      
      private var _freeUpBtn:SimpleBitmapButton;
      
      private var _freeUpTxt:FilterFrameText;
      
      private var _curSkillCell:HorseSkillCell;
      
      private var _upCurSkillCell:HorseSkillCell;
      
      private var _upNextSkillCell:HorseSkillCell;
      
      private var _itemCell:HorseFrameRightBottomItemCell;
      
      private var _index:int;
      
      private var _skillExp:HorseSkillExpVo;
      
      private var _dataList:Vector.<HorseSkillGetVo>;
      
      private var _lastUpClickTime:int = 0;
      
      private var _maxCount:int;
      
      private var _itemCount:int;
      
      protected var _toLinkTxt:FilterFrameText;
      
      public function HorseSkillUpFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("horse.skillUpFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.upFrame.bg");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillUpFrame.levelTxt");
         this._expBg = ComponentFactory.Instance.creatBitmap("asset.horse.upFrame.expBg");
         this._expCover = ComponentFactory.Instance.creatBitmap("asset.horse.upFrame.expCover");
         this._expPerTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.progressTxt");
         this._expPerTxt.x = 57;
         this._expPerTxt.y = 39;
         this._rightArrow = ComponentFactory.Instance.creatBitmap("asset.horse.upFrame.rightArrow");
         this._countTitleTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillUpFrame.countTitleTxt");
         this._countTitleTxt.text = LanguageMgr.GetTranslation("horse.skillUpFrame.countTitleTxt");
         this._txtBg = ComponentFactory.Instance.creatBitmap("asset.horse.upFrame.txtBg");
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillUpFrame.countTxt");
         this._countTxt.restrict = "0-9";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("horse.upFrame.maxBtn");
         this._upBtn = ComponentFactory.Instance.creatComponentByStylename("horse.upFrame.upBtn");
         this._freeUpBtn = ComponentFactory.Instance.creatComponentByStylename("horse.upFrame.upBtn2");
         this._freeUpTxt = ComponentFactory.Instance.creatComponentByStylename("horse.upFrame.upBtn2Txt");
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.horse.frame.itemBg");
         this._itemCell = new HorseFrameRightBottomItemCell(11165);
         PositionUtils.setPos(this._itemCell,"horse.skillUpframe.itemCellPos");
         addToContent(this._bg);
         addToContent(this._levelTxt);
         addToContent(this._expBg);
         addToContent(this._expCover);
         addToContent(this._expPerTxt);
         addToContent(this._rightArrow);
         addToContent(this._itemCell);
         addToContent(this._countTitleTxt);
         addToContent(this._txtBg);
         addToContent(this._countTxt);
         addToContent(this._maxBtn);
         addToContent(this._upBtn);
         addToContent(this._freeUpBtn);
         addToContent(this._freeUpTxt);
         this._toLinkTxt = ComponentFactory.Instance.creat("petAndHorse.risingStar.toLinkTxt");
         this._toLinkTxt.mouseEnabled = true;
         this._toLinkTxt.htmlText = LanguageMgr.GetTranslation("petAndHorse.risingStar.toLinkTxtValue");
         PositionUtils.setPos(this._toLinkTxt,"petAndHorse.risingStar.toLinkTxtPos4");
         addToContent(this._toLinkTxt);
         this._toLinkTxt.visible = false;
         this.refreshFreeTipTxt();
      }
      
      public function show(index:int, skillExp:HorseSkillExpVo, dataList:Vector.<HorseSkillGetVo>) : void
      {
         this._index = index;
         this._skillExp = skillExp;
         this._dataList = dataList;
         this.refreshView();
         this.calMaxCountUpAndItem();
         if(this._itemCount > 0)
         {
            this._countTxt.text = "1";
         }
         else
         {
            this._countTxt.text = "0";
         }
      }
      
      private function refreshView(isReCell:Boolean = true) : void
      {
         var curExp:int = 0;
         var nextExp:int = 0;
         if(isReCell)
         {
            ObjectUtils.disposeObject(this._curSkillCell);
            ObjectUtils.disposeObject(this._upCurSkillCell);
            ObjectUtils.disposeObject(this._upNextSkillCell);
            this._curSkillCell = new HorseSkillCell(this._skillExp.skillId);
            PositionUtils.setPos(this._curSkillCell,"horse.skillUpframe.cellPos1");
            this._upCurSkillCell = new HorseSkillCell(this._dataList[this._index].SkillID);
            PositionUtils.setPos(this._upCurSkillCell,"horse.skillUpframe.cellPos2");
            if(this._index >= this._dataList.length - 1)
            {
               this._upNextSkillCell = new HorseSkillCell(this._dataList[this._index].SkillID);
            }
            else
            {
               this._upNextSkillCell = new HorseSkillCell(this._dataList[this._index + 1].SkillID);
            }
            PositionUtils.setPos(this._upNextSkillCell,"horse.skillUpframe.cellPos3");
            addToContent(this._curSkillCell);
            addToContent(this._upCurSkillCell);
            addToContent(this._upNextSkillCell);
         }
         this._levelTxt.text = LanguageMgr.GetTranslation("horse.skillUpFrame.levelTxt",this._dataList[this._index].Level);
         if(this._index < this._dataList.length - 1)
         {
            curExp = this._skillExp.exp - this._dataList[this._index].Exp;
            nextExp = this._dataList[this._index + 1].Exp - this._dataList[this._index].Exp;
            this._expCover.scaleX = curExp / nextExp;
            this._expPerTxt.text = curExp + "/" + nextExp;
         }
         else
         {
            this._expCover.scaleX = 1;
            this._expPerTxt.text = "0/0";
         }
      }
      
      private function calMaxCountUpAndItem() : void
      {
         var curExp:int = 0;
         var nextExp:int = 0;
         var upExp:int = 0;
         if(this._index < this._dataList.length - 1)
         {
            curExp = this._skillExp.exp - this._dataList[this._index].Exp;
            nextExp = this._dataList[this._index + 1].Exp - this._dataList[this._index].Exp;
            upExp = int(ItemManager.Instance.getTemplateById(11165).Property2);
            this._maxCount = Math.ceil((nextExp - curExp) / upExp);
         }
         this._itemCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11165);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upBtn.addEventListener(MouseEvent.CLICK,this.upClickHandler,false,0,true);
         this._freeUpBtn.addEventListener(MouseEvent.CLICK,this.upClickHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.maxClickHandler,false,0,true);
         this._countTxt.addEventListener(Event.CHANGE,this.countTxtChangeHandler);
         HorseManager.instance.addEventListener(HorseManager.UP_SKILL,this.upSkillSucHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
         this._toLinkTxt.addEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.addEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function refreshFreeTipTxt(event:Event = null) : void
      {
         var freeCount1:int = 0;
         freeCount1 = DeedManager.instance.getOneBuffData(DeedManager.HORSE_ANGER);
         if(freeCount1 > 0)
         {
            this._freeUpBtn.visible = true;
            this._freeUpTxt.visible = true;
            this._freeUpTxt.text = "(" + freeCount1 + ")";
            this._upBtn.visible = false;
         }
         else
         {
            this._freeUpTxt.text = "(" + freeCount1 + ")";
            this._freeUpBtn.visible = false;
            this._freeUpTxt.visible = false;
            this._upBtn.visible = true;
         }
      }
      
      private function itemUpdateHandler(event:BagEvent) : void
      {
         var curCount:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11165);
         if(this._itemCount > curCount)
         {
            this._countTxt.text = String(int(this._countTxt.text) - (this._itemCount - curCount));
         }
         this._itemCount = curCount;
         this.countTxtChangeHandler(null);
      }
      
      private function upSkillSucHandler(event:Event) : void
      {
         var isReCell:Boolean = false;
         if(this._skillExp.skillId != this._dataList[this._index].SkillID)
         {
            ++this._index;
            isReCell = true;
         }
         this.refreshView(isReCell);
         this.calMaxCountUpAndItem();
      }
      
      private function countTxtChangeHandler(event:Event) : void
      {
         var inputCount:int = int(this._countTxt.text);
         if(this._itemCount > 0 && inputCount <= 0)
         {
            this._countTxt.text = "1";
         }
         else if(inputCount > this._itemCount)
         {
            this._countTxt.text = this._itemCount.toString();
         }
      }
      
      private function maxClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._countTxt.text = this._maxCount.toString();
         this.countTxtChangeHandler(null);
      }
      
      private function upClickHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._index >= this._dataList.length - 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillCannotUp"));
            return;
         }
         if(getTimer() - this._lastUpClickTime <= 1000)
         {
            return;
         }
         this._lastUpClickTime = getTimer();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var freeCount1:int = DeedManager.instance.getOneBuffData(DeedManager.HORSE_ANGER);
         if(freeCount1 > 0)
         {
            SocketManager.Instance.out.sendHorseUpSkill(this._skillExp.skillId,1);
            return;
         }
         if(int(this._countTxt.text) <= 0)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("horse.itemConfirmBuyPrompt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.buyConfirm,false,0,true);
            return;
         }
         var tmp:int = int(this._countTxt.text);
         tmp = Math.min(tmp,this._maxCount);
         SocketManager.Instance.out.sendHorseUpSkill(this._skillExp.skillId,tmp);
      }
      
      private function buyConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.buyConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            ShopBuyManager.Instance.buy(11165,1,-1);
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upBtn.removeEventListener(MouseEvent.CLICK,this.upClickHandler);
         this._freeUpBtn.addEventListener(MouseEvent.CLICK,this.upClickHandler,false,0,true);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.maxClickHandler);
         this._countTxt.removeEventListener(Event.CHANGE,this.countTxtChangeHandler);
         HorseManager.instance.removeEventListener(HorseManager.UP_SKILL,this.upSkillSucHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
         this._toLinkTxt.removeEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         DeedManager.instance.removeEventListener(DeedManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function __toLinkTxtHandler(evt:TextEvent) : void
      {
         SoundManager.instance.playButtonSound();
         StateManager.setState(StateType.DUNGEON_LIST);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._levelTxt = null;
         this._expBg = null;
         this._expCover = null;
         this._expPerTxt = null;
         this._rightArrow = null;
         this._countTitleTxt = null;
         this._txtBg = null;
         this._countTxt = null;
         this._maxBtn = null;
         this._upBtn = null;
         ObjectUtils.disposeObject(this._freeUpBtn);
         this._freeUpBtn = null;
         ObjectUtils.disposeObject(this._freeUpTxt);
         this._freeUpTxt = null;
         this._curSkillCell = null;
         this._upCurSkillCell = null;
         this._upNextSkillCell = null;
         this._itemCell = null;
         this._skillExp = null;
         this._dataList = null;
         ObjectUtils.disposeObject(this._toLinkTxt);
         this._toLinkTxt = null;
      }
   }
}

