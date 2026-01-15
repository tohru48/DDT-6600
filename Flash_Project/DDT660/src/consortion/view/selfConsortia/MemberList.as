package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class MemberList extends Sprite implements Disposeable
   {
      
      private var _memberListBG:MovieImage;
      
      private var _menberListVLine:MutipleImage;
      
      private var _name:BaseButton;
      
      private var _job:BaseButton;
      
      private var _level:BaseButton;
      
      private var _offer:BaseButton;
      
      private var _week:BaseButton;
      
      private var _fightPower:BaseButton;
      
      private var _offLine:BaseButton;
      
      private var _search:SimpleBitmapButton;
      
      private var _nameText:FilterFrameText;
      
      private var _jobText:FilterFrameText;
      
      private var _levelText:FilterFrameText;
      
      private var _offerText:FilterFrameText;
      
      private var _weekText:FilterFrameText;
      
      private var _fightText:FilterFrameText;
      
      private var _offLineText:FilterFrameText;
      
      private var _list:ListPanel;
      
      private var _lastSort:String = "";
      
      private var _isDes:Boolean = false;
      
      private var _searchMemberFrame:SearchMemberFrame;
      
      public function MemberList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._memberListBG = ComponentFactory.Instance.creatComponentByStylename("consortion.menberList.bg");
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.MemberListVLine");
         this._name = ComponentFactory.Instance.creatComponentByStylename("memberList.name");
         this._job = ComponentFactory.Instance.creatComponentByStylename("memberList.job");
         this._level = ComponentFactory.Instance.creatComponentByStylename("memberList.level");
         this._offer = ComponentFactory.Instance.creatComponentByStylename("memberList.offer");
         this._week = ComponentFactory.Instance.creatComponentByStylename("memberList.week");
         this._fightPower = ComponentFactory.Instance.creatComponentByStylename("memberList.fightPower");
         this._offLine = ComponentFactory.Instance.creatComponentByStylename("memberList.offLine");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
         this._nameText.text = LanguageMgr.GetTranslation("tank.memberList.nameText.text");
         this._jobText = ComponentFactory.Instance.creatComponentByStylename("memberList.jobText");
         this._jobText.text = LanguageMgr.GetTranslation("tank.memberList.jobText.text");
         this._levelText = ComponentFactory.Instance.creatComponentByStylename("memberList.levelText");
         this._levelText.text = LanguageMgr.GetTranslation("tank.memberList.levelText.text");
         this._offerText = ComponentFactory.Instance.creatComponentByStylename("memberList.offerText");
         this._offerText.text = LanguageMgr.GetTranslation("tank.memberList.offerText.text");
         this._weekText = ComponentFactory.Instance.creatComponentByStylename("memberList.weekText");
         this._weekText.text = LanguageMgr.GetTranslation("tank.memberList.weekText.text");
         this._fightText = ComponentFactory.Instance.creatComponentByStylename("memberList.fightPowerText");
         this._fightText.text = LanguageMgr.GetTranslation("tank.memberList.fightPowerText.text");
         this._offLineText = ComponentFactory.Instance.creatComponentByStylename("memberList.offLineText");
         this._offLineText.text = LanguageMgr.GetTranslation("tank.memberList.offLineText.text");
         this._list = ComponentFactory.Instance.creatComponentByStylename("memberList.list");
         this._search = ComponentFactory.Instance.creatComponentByStylename("memberList.searchBtn");
         addChild(this._memberListBG);
         addChild(this._menberListVLine);
         addChild(this._name);
         addChild(this._job);
         addChild(this._level);
         addChild(this._offer);
         addChild(this._week);
         addChild(this._fightPower);
         addChild(this._offLine);
         addChild(this._nameText);
         addChild(this._jobText);
         addChild(this._levelText);
         addChild(this._offerText);
         addChild(this._weekText);
         addChild(this._fightText);
         addChild(this._offLineText);
         addChild(this._list);
         addChild(this._search);
         this.setTip(this._name,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.name"));
         this.setTip(this._job,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.duty"));
         this.setTip(this._level,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.level"));
         this.setTip(this._offer,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.contribute"));
         this.setTip(this._week,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.weekcontribute"));
         this.setTip(this._fightPower,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.battle"));
         this.setTip(this._offLine,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.time"));
         this.setTip(this._search,LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.search"));
         this.setListData();
      }
      
      private function setTip(btn:BaseButton, value:String) : void
      {
         btn.tipStyle = "ddt.view.tips.OneLineTip";
         btn.tipDirctions = "0";
         btn.tipData = value;
      }
      
      private function initEvent() : void
      {
         this._name.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._job.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._level.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offer.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._week.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._fightPower.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._offLine.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._search.addEventListener(MouseEvent.CLICK,this.__showSearchFrame);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBERLIST_COMPLETE,this.__listLoadCompleteHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD,this.__addMemberHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE,this.__removeMemberHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updataMemberHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._name))
         {
            this._name.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._job))
         {
            this._job.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._level))
         {
            this._level.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._offer))
         {
            this._offer.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._week))
         {
            this._week.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._fightPower))
         {
            this._fightPower.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._offLine))
         {
            this._offLine.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         }
         if(Boolean(this._search))
         {
            this._search.removeEventListener(MouseEvent.CLICK,this.__showSearchFrame);
         }
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBERLIST_COMPLETE,this.__listLoadCompleteHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD,this.__addMemberHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE,this.__removeMemberHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updataMemberHandler);
         if(Boolean(this._searchMemberFrame))
         {
            this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         }
      }
      
      public function __updataMemberHandler(event:ConsortionEvent) : void
      {
         var info:ConsortiaPlayerInfo = null;
         var target:ConsortiaPlayerInfo = event.data as ConsortiaPlayerInfo;
         var len:int = int(this._list.vectorListModel.elements.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._list.vectorListModel.elements[i] as ConsortiaPlayerInfo;
            if(info.ID == target.ID)
            {
               info = target;
               break;
            }
         }
         this._list.list.updateListView();
      }
      
      public function __addMemberHandler(event:ConsortionEvent) : void
      {
         var len:int = ConsortionModelControl.Instance.model.memberList.length;
         this._list.vectorListModel.append(event.data as ConsortiaPlayerInfo,len - 1);
         if(len <= 6)
         {
            this._list.vectorListModel.removeElementAt(this._list.vectorListModel.elements.length - 1);
         }
         this._list.list.updateListView();
      }
      
      public function __removeMemberHandler(event:ConsortionEvent) : void
      {
         this._list.vectorListModel.remove(event.data as ConsortiaPlayerInfo);
         var len:int = ConsortionModelControl.Instance.model.memberList.length;
         if(len < 6)
         {
            this.setListData();
         }
         this._list.list.updateListView();
      }
      
      private function __btnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isDes = this._isDes ? false : true;
         switch(event.currentTarget)
         {
            case this._name:
               this._lastSort = "NickName";
               break;
            case this._job:
               this._lastSort = "DutyLevel";
               break;
            case this._level:
               this._lastSort = "Grade";
               break;
            case this._offer:
               this._lastSort = "UseOffer";
               break;
            case this._week:
               this._lastSort = "LastWeekRichesOffer";
               break;
            case this._fightPower:
               this._lastSort = "FightPower";
               break;
            case this._offLine:
               this._lastSort = "OffLineHour";
         }
         this.sortOnItem(this._lastSort,this._isDes);
      }
      
      private function __listLoadCompleteHandler(event:ConsortionEvent) : void
      {
         this.setListData();
      }
      
      private function __showSearchFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._searchMemberFrame) && Boolean(this._searchMemberFrame.parent))
         {
            return;
         }
         this._searchMemberFrame = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame");
         this._searchMemberFrame.addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         LayerManager.Instance.addToLayer(this._searchMemberFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._searchMemberFrame.setFocus();
      }
      
      private function __onFrameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this.search(this._searchMemberFrame.getSearchText()))
               {
                  this.hideSearchFrame();
               }
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hideSearchFrame();
         }
      }
      
      private function search($searchText:String) : Boolean
      {
         var playerInfo:ConsortiaPlayerInfo = null;
         if(FilterWordManager.isGotForbiddenWords($searchText))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         if($searchText == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default") || $searchText == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
            return false;
         }
         if(StringHelper.getIsBiggerMaxCHchar($searchText,7))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         var searchText:String = $searchText;
         var players:Array = ConsortionModelControl.Instance.model.memberList.list;
         var searchOutcome:Array = [];
         var searchComplete:Boolean = false;
         for(var i:int = 0; i < players.length; i++)
         {
            playerInfo = players[i];
            if(playerInfo.NickName.indexOf(searchText) != -1)
            {
               searchOutcome.unshift(playerInfo);
               searchComplete = true;
            }
            else
            {
               searchOutcome.push(playerInfo);
            }
         }
         if(searchText == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
            return false;
         }
         if(!searchComplete)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
            return false;
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(searchOutcome);
         var len:int = int(searchOutcome.length);
         if(len < 6)
         {
            while(len < 6)
            {
               this._list.vectorListModel.append(null,len);
               len++;
            }
         }
         this._list.list.updateListView();
         return true;
      }
      
      private function hideSearchFrame() : void
      {
         if(Boolean(this._searchMemberFrame))
         {
            this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
            ObjectUtils.disposeObject(this._searchMemberFrame);
            this._searchMemberFrame = null;
         }
      }
      
      private function setListData() : void
      {
         var len:int = 0;
         if(ConsortionModelControl.Instance.model.memberList.length > 0)
         {
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(ConsortionModelControl.Instance.model.memberList.list);
            len = ConsortionModelControl.Instance.model.memberList.length;
            if(len < 6)
            {
               while(len < 6)
               {
                  this._list.vectorListModel.append(null,len);
                  len++;
               }
            }
            if(this._lastSort == "")
            {
               this._lastSort = "Init";
               this._isDes = false;
            }
            this.sortOnItem(this._lastSort,this._isDes);
         }
      }
      
      private function sortOnItem(field:String, des:Boolean = false) : void
      {
         var i:int = 0;
         var len:int = ConsortionModelControl.Instance.model.memberList.length;
         if(len < 6)
         {
            this._list.vectorListModel.elements.splice(len,6 - len + 1);
         }
         if(field == "Init")
         {
            this._list.vectorListModel.elements.sortOn("Grade",2 | 1 | 0x10);
            for(i = 0; i < this._list.vectorListModel.elements.length; i++)
            {
               if(Boolean(this._list.vectorListModel.elements[i]) && this._list.vectorListModel.elements[i].ID == PlayerManager.Instance.Self.ID)
               {
                  this._list.vectorListModel.elements.unshift(this._list.vectorListModel.elements[i]);
                  this._list.vectorListModel.elements.splice(i + 1,1);
               }
            }
         }
         else
         {
            this._list.vectorListModel.elements.sortOn(field,2 | 1 | 0x10);
         }
         if(des)
         {
            this._list.vectorListModel.elements.reverse();
         }
         if(len < 6)
         {
            while(len < 6)
            {
               this._list.vectorListModel.append(null,len);
               len++;
            }
         }
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._list))
         {
            this._list.vectorListModel.clear();
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._searchMemberFrame))
         {
            ObjectUtils.disposeObject(this._searchMemberFrame);
         }
         this._searchMemberFrame = null;
         if(Boolean(this._memberListBG))
         {
            ObjectUtils.disposeObject(this._memberListBG);
         }
         this._memberListBG = null;
         if(Boolean(this._menberListVLine))
         {
            ObjectUtils.disposeObject(this._menberListVLine);
         }
         this._menberListVLine = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._job))
         {
            ObjectUtils.disposeObject(this._job);
         }
         this._job = null;
         if(Boolean(this._level))
         {
            ObjectUtils.disposeObject(this._level);
         }
         this._level = null;
         if(Boolean(this._offer))
         {
            ObjectUtils.disposeObject(this._offer);
         }
         this._offer = null;
         if(Boolean(this._week))
         {
            ObjectUtils.disposeObject(this._week);
         }
         this._week = null;
         if(Boolean(this._fightPower))
         {
            ObjectUtils.disposeObject(this._fightPower);
         }
         this._fightPower = null;
         if(Boolean(this._offLine))
         {
            ObjectUtils.disposeObject(this._offLine);
         }
         this._offLine = null;
         if(Boolean(this._search))
         {
            ObjectUtils.disposeObject(this._search);
         }
         this._search = null;
         if(Boolean(this._nameText))
         {
            ObjectUtils.disposeObject(this._nameText);
         }
         this._nameText = null;
         if(Boolean(this._jobText))
         {
            ObjectUtils.disposeObject(this._jobText);
         }
         this._jobText = null;
         if(Boolean(this._levelText))
         {
            ObjectUtils.disposeObject(this._levelText);
         }
         this._levelText = null;
         if(Boolean(this._offerText))
         {
            ObjectUtils.disposeObject(this._offerText);
         }
         this._offerText = null;
         if(Boolean(this._weekText))
         {
            ObjectUtils.disposeObject(this._weekText);
         }
         this._weekText = null;
         if(Boolean(this._fightText))
         {
            ObjectUtils.disposeObject(this._fightText);
         }
         this._fightText = null;
         if(Boolean(this._offLineText))
         {
            ObjectUtils.disposeObject(this._offLineText);
         }
         this._offLineText = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

