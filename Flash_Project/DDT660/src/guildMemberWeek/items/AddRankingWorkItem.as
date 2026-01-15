package guildMemberWeek.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class AddRankingWorkItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _RankingBitmp:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _AddPointBookText:FilterFrameText;
      
      private var _GetPointBookText:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _ShowGetPointBookText:FilterFrameText;
      
      private var _PointBookBitmp:Bitmap;
      
      private var _ItemID:int = 0;
      
      public function AddRankingWorkItem()
      {
         super();
      }
      
      public function get AddMoney() : int
      {
         return int(this._inputTxt.text);
      }
      
      public function initView(Ranking:int) : void
      {
         this._ItemID = Ranking;
         if(Ranking % 2 == 0)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.guildmemberweek.AddRankingFrame.ItemA");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.guildmemberweek.AddRankingFrame.ItemB");
         }
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.RankingTxt");
         this._AddPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.AddPointBookTxt");
         this._GetPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.GetPointBookTxt");
         this._ShowGetPointBookText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRankingFrame.Item.ShowGetPointBookTxt");
         this._PointBookBitmp = ComponentFactory.Instance.creatBitmap("swf.guildmember.MainFrame.Left.Ranking.png");
         this._PointBookBitmp.x = 327;
         this._PointBookBitmp.y = 8;
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.addRanking.inputTxt");
         this._inputTxt.tabEnabled = false;
         if(Ranking <= 3)
         {
            this._RankingText.visible = false;
            this._RankingBitmp = ComponentFactory.Instance.creat("toffilist.guildMemberWeektopThreeRink");
            this._RankingBitmp.setFrame(Ranking);
            this._RankingBitmp.y = 4;
            this._RankingBitmp.x = -4;
         }
         else
         {
            this._RankingText.visible = true;
         }
         addChild(this._bg);
         addChild(this._RankingText);
         if(Boolean(this._RankingBitmp))
         {
            addChild(this._RankingBitmp);
         }
         addChild(this._AddPointBookText);
         addChild(this._GetPointBookText);
         addChild(this._ShowGetPointBookText);
         addChild(this._PointBookBitmp);
         addChild(this._inputTxt);
         this.initText();
         this.initEvent();
      }
      
      public function initText() : void
      {
         this._AddPointBookText.text = LanguageMgr.GetTranslation("money");
         this._GetPointBookText.text = LanguageMgr.GetTranslation("money");
         this._RankingText.text = this._ItemID + "th";
         this._ShowGetPointBookText.text = "0";
         this._inputTxt.text = "0";
      }
      
      public function initEvent() : void
      {
         addEventListener(KeyboardEvent.KEY_UP,this.__ItemWorkCheckKeyboard);
         addEventListener(FocusEvent.FOCUS_OUT,this.__ItemWorkFocusEvent);
      }
      
      private function RemoveEvent() : void
      {
         removeEventListener(KeyboardEvent.KEY_UP,this.__ItemWorkCheckKeyboard);
         removeEventListener(FocusEvent.FOCUS_OUT,this.__ItemWorkFocusEvent);
      }
      
      private function __ItemWorkCheckKeyboard(event:KeyboardEvent) : void
      {
         this._ItemWork();
      }
      
      private function __ItemWorkFocusEvent(event:FocusEvent) : void
      {
         this._ItemWork();
      }
      
      private function _ItemWork() : void
      {
         var tempAllMoney:Number = NaN;
         if(this._inputTxt.text == "")
         {
            this._inputTxt.text = "0";
         }
         var Money:Number = Number(this._inputTxt.text);
         var AllMoney:Number = 0;
         var N:int = this._ItemID - 1;
         var i:int = 0;
         var L:int = int(GuildMemberWeekManager.instance.model.PlayerAddPointBook.length);
         for(i = 0; i < L; i++)
         {
            if(i != N)
            {
               AllMoney += GuildMemberWeekManager.instance.model.PlayerAddPointBook[i];
            }
         }
         if(Money < 0)
         {
            Money = PlayerManager.Instance.Self.Money - AllMoney;
         }
         else
         {
            tempAllMoney = AllMoney + Money;
            if(tempAllMoney >= PlayerManager.Instance.Self.Money)
            {
               Money = PlayerManager.Instance.Self.Money - AllMoney;
            }
         }
         this._inputTxt.text = String(Money);
         GuildMemberWeekManager.instance.Controller.upPointBookData(this._ItemID,Money);
      }
      
      public function ChangeGetPointBook(Money:int) : void
      {
         this._ShowGetPointBookText.text = String(Money);
      }
      
      public function dispose() : void
      {
         this.RemoveEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._RankingText);
         this._RankingText = null;
         if(Boolean(this._RankingBitmp))
         {
            ObjectUtils.disposeObject(this._RankingBitmp);
         }
         this._RankingBitmp = null;
         ObjectUtils.disposeObject(this._AddPointBookText);
         this._AddPointBookText = null;
         ObjectUtils.disposeObject(this._GetPointBookText);
         this._GetPointBookText = null;
         ObjectUtils.disposeObject(this._ShowGetPointBookText);
         this._ShowGetPointBookText = null;
         ObjectUtils.disposeObject(this._PointBookBitmp);
         this._PointBookBitmp = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

