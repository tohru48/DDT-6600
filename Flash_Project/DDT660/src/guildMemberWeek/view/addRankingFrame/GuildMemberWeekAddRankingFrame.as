package guildMemberWeek.view.addRankingFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import guildMemberWeek.items.AddRankingWorkItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekAddRankingFrame extends BaseAlerFrame
   {
      
      private var _PlayerPointBookText:FilterFrameText;
      
      private var _DeductTaxExplainText:FilterFrameText;
      
      private var _BG:ScaleFrameImage;
      
      private var _DeductTaxExplainBG:ScaleFrameImage;
      
      private var _PlayerHavePointBG:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _PutInPointBookExplainText:FilterFrameText;
      
      private var _GetPointBookExplainText:FilterFrameText;
      
      private var _YesBtn:TextButton;
      
      private var _NoBtn:TextButton;
      
      private var _itemList:Vector.<AddRankingWorkItem>;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function GuildMemberWeekAddRankingFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
      }
      
      public function get itemList() : Vector.<AddRankingWorkItem>
      {
         return this._itemList;
      }
      
      public function set itemList(Message:Vector.<AddRankingWorkItem>) : void
      {
         this._itemList = Message;
      }
      
      private function initView() : void
      {
         var item:AddRankingWorkItem = null;
         titleText = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.AddRankingGiftLabel");
         this._BG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFrameBG");
         this._DeductTaxExplainBG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFrameExplainBG");
         this._PlayerHavePointBG = ComponentFactory.Instance.creat("asset.guildmemberweek.AddRankingFramePlayerPoint");
         this._YesBtn = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._YesBtn.text = LanguageMgr.GetTranslation("ok");
         this._YesBtn.x = 50;
         this._YesBtn.y = 300;
         this._NoBtn = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._NoBtn.text = LanguageMgr.GetTranslation("cancel");
         this._NoBtn.x = 270;
         this._NoBtn.y = 300;
         this._PlayerPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.PlayerPointBookTxt");
         this._DeductTaxExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.DeductTaxExplainTxt");
         this._PutInPointBookExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.PutInPointBookExplainLabelTxt");
         this._GetPointBookExplainText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.GetPointBookExplainLabelTxt");
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.RankingLabelTxt");
         addToContent(this._BG);
         addToContent(this._DeductTaxExplainBG);
         addToContent(this._PlayerHavePointBG);
         addToContent(this._YesBtn);
         addToContent(this._NoBtn);
         addToContent(this._PlayerPointBookText);
         addToContent(this._DeductTaxExplainText);
         addToContent(this._RankingText);
         addToContent(this._PutInPointBookExplainText);
         addToContent(this._GetPointBookExplainText);
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingListBox");
         this._itemList = new Vector.<AddRankingWorkItem>();
         for(var i:int = 0; i < 10; i++)
         {
            item = ComponentFactory.Instance.creatCustomObject("guildmemberweek.addRanking.AddRankingWorkItem");
            item.initView(i + 1);
            this.itemList.push(item);
            this._list.addChild(this.itemList[i]);
         }
         this._panel = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.panel");
         this._panel.setView(this._list);
         addToContent(this._panel);
         this._panel.invalidateViewport();
      }
      
      private function initText() : void
      {
         this.ChangePlayerMoneyShow(PlayerManager.Instance.Self.Money);
         this._RankingText.text = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.RankingLabel");
         this._DeductTaxExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.DeductTaxExplain");
         this._PutInPointBookExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.PutInPointBookExplainLabel");
         this._GetPointBookExplainText.text = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.GetPointBookExplainLabel");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._NoBtn.addEventListener(MouseEvent.CLICK,this.__CancelHandler);
         this._YesBtn.addEventListener(MouseEvent.CLICK,this.__OkHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._NoBtn.removeEventListener(MouseEvent.CLICK,this.__CancelHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.CancelThis();
         }
      }
      
      private function __CancelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.CancelThis();
      }
      
      private function CancelThis() : void
      {
         SoundManager.instance.play("008");
         GuildMemberWeekManager.instance.CloseAddRankingFrame();
      }
      
      private function __OkHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.DutyLevel > 3 || !GuildMemberWeekManager.instance.model.CanAddPointBook)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.CantNotAddPointBook"));
            return;
         }
         var i:int = 0;
         var L:int = int(this._itemList.length);
         for(var TempVector:Array = new Array(); i < L; )
         {
            TempVector.push(this.itemList[i].AddMoney);
            i++;
         }
         GuildMemberWeekManager.instance.model.PlayerAddPointBook = TempVector.concat();
         GuildMemberWeekManager.instance.Controller.CheckAddBookIsOK();
      }
      
      public function ChangePointBookShow(ItemID:int, Money:int) : void
      {
         var i:int = ItemID - 1;
         this.itemList[i].ChangeGetPointBook(Money);
      }
      
      public function ChangePlayerMoneyShow(Money:Number) : void
      {
         this._PlayerPointBookText.text = String(Money);
      }
      
      private function disposeItems() : void
      {
         var i:int = 0;
         var L:int = 0;
         if(Boolean(this.itemList))
         {
            i = 0;
            for(L = int(this.itemList.length); i < L; )
            {
               ObjectUtils.disposeObject(this.itemList[i]);
               this.itemList[i] = null;
               i++;
            }
            this.itemList = null;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
         this._BG = null;
         this._DeductTaxExplainBG = null;
         this._PlayerHavePointBG = null;
         this._panel = null;
         this._YesBtn = null;
         this._NoBtn = null;
         this._PlayerPointBookText = null;
         this._DeductTaxExplainText = null;
         this._RankingText = null;
         this._PutInPointBookExplainText = null;
         this._GetPointBookExplainText = null;
      }
   }
}

