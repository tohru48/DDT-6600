package guildMemberWeek.items
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class ShowGuildMemberDataItem extends Sprite implements Disposeable
   {
      
      private var _RankingBitmp:ScaleFrameImage;
      
      private var _RankingText:FilterFrameText;
      
      private var _MemberNameText:FilterFrameText;
      
      private var _MemberContributeText:FilterFrameText;
      
      private var _AddRankingText:FilterFrameText;
      
      private var _AddRankingBtn:BaseButton;
      
      private var _AddRankingSprite:Sprite;
      
      private var _AddRankingBg:Bitmap;
      
      private var _itemCells:Array;
      
      public var Count:int = 1;
      
      private var _templateInfo:ItemTemplateInfo;
      
      public function ShowGuildMemberDataItem()
      {
         super();
      }
      
      public function GetTemplateInfo(TemplateID:int) : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(TemplateID);
      }
      
      public function initView(Ranking:int) : void
      {
         this._RankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.RankingTxt");
         this._RankingText.text = Ranking + "th";
         this._MemberNameText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.MemberNameTxt");
         this._MemberContributeText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.MemberContributeTxt");
         this._AddRankingText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrame.left.ShowGuildMemberDataItem.AddRankingTxt");
         this._AddRankingBg = ComponentFactory.Instance.creatBitmap("swf.guildmember.MainFrame.Left.Ranking.png");
         this._AddRankingSprite = new Sprite();
         this._AddRankingSprite.addChild(this._AddRankingBg);
         this._AddRankingSprite.addChild(this._AddRankingText);
         this._AddRankingBtn = GuildMemberWeekManager.instance.returnComponentBnt(this._AddRankingSprite);
         this._AddRankingBtn.y = 5;
         this._AddRankingBtn.x = 465;
         this._AddRankingBtn.buttonMode = false;
         if(Ranking <= 3)
         {
            this._RankingText.visible = false;
            this._RankingBitmp = ComponentFactory.Instance.creat("toffilist.guildMemberWeektopThreeRink");
            this._RankingBitmp.setFrame(Ranking);
         }
         else
         {
            this._RankingText.visible = true;
         }
         addChild(this._RankingText);
         addChild(this._MemberNameText);
         addChild(this._MemberContributeText);
         addChild(this._AddRankingBtn);
         addChild(this._AddRankingSprite);
         if(Boolean(this._RankingBitmp))
         {
            addChild(this._RankingBitmp);
         }
      }
      
      protected function creatItemCell() : BaseCell
      {
         var cell:BaseCell = null;
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,30,30);
         sp.graphics.endFill();
         cell = new BaseCell(sp,null,true,true);
         cell.tipDirctions = "7,6,2,1,5,4,0,3,6";
         cell.tipGapV = 10;
         cell.tipGapH = 10;
         cell.tipStyle = "core.GoodsTip";
         return cell;
      }
      
      public function initMember(MemberName:String, MemberContribute:String) : void
      {
         this._MemberNameText.text = MemberName;
         this._MemberContributeText.text = MemberContribute;
      }
      
      public function initAddPointBook(AddRanking:int) : void
      {
         this._AddRankingText.text = String(AddRanking);
         this._AddRankingBtn.tipData = LanguageMgr.GetTranslation("guildMemberWeek.MainDataLabel.CanGetPointBook") + this._AddRankingText.text;
         this._AddRankingBtn.tipGapH = 520;
      }
      
      public function initItemCell(GiftMessage:String) : void
      {
         var Tgift:Array = null;
         var i:int = 0;
         var C:int = 0;
         var itemCell:BaseCell = null;
         var tempNumberShow:FilterFrameText = null;
         this._itemCells = new Array();
         Tgift = GiftMessage.split(",");
         i = 0;
         var L:int = int(Tgift.length);
         var Tpoint:Point = PositionUtils.creatPoint("guildMemberWeek.ShowGift.cellPos");
         var StartX:int = Tpoint.x;
         var StartY:int = Tpoint.y;
         C = 0;
         for(i = 0; i < L; i += 2)
         {
            itemCell = this.creatItemCell();
            itemCell.buttonMode = true;
            itemCell.width = 30;
            itemCell.height = 30;
            itemCell.info = this.GetTemplateInfo(int(Tgift[i]));
            itemCell.buttonMode = true;
            itemCell.x = StartX + C * 35;
            itemCell.y = StartY;
            tempNumberShow = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.left.giftNumberShowTxt");
            tempNumberShow.text = "";
            if(Tgift[i + 1] != undefined)
            {
               tempNumberShow.text = Tgift[i + 1];
            }
            itemCell.addChild(tempNumberShow);
            this._itemCells.push([itemCell,tempNumberShow,int(Tgift[i + 1])]);
            addChild(itemCell);
            C++;
         }
      }
      
      private function disposeItemCell() : void
      {
         var L:int = 0;
         var i:int = 0;
         if(Boolean(this._itemCells))
         {
            L = int(this._itemCells.length);
            i = 0;
            for(i = 0; i < L; i++)
            {
               ObjectUtils.disposeObject(this._itemCells[i][1]);
               ObjectUtils.disposeObject(this._itemCells[i][0]);
               this._itemCells[i][0] = null;
               this._itemCells[i][1] = null;
               this._itemCells[i][2] = null;
               this._itemCells[i] = null;
            }
            this._itemCells = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeItemCell();
         ObjectUtils.disposeObject(this._RankingText);
         this._RankingText = null;
         ObjectUtils.disposeObject(this._MemberNameText);
         this._MemberNameText = null;
         ObjectUtils.disposeObject(this._MemberContributeText);
         this._MemberContributeText = null;
         ObjectUtils.disposeAllChildren(this._AddRankingBtn);
         ObjectUtils.disposeObject(this._AddRankingBtn);
         this._AddRankingBtn = null;
         if(Boolean(this._RankingBitmp))
         {
            ObjectUtils.disposeObject(this._RankingBitmp);
         }
         this._RankingBitmp = null;
         if(Boolean(this._AddRankingSprite))
         {
            ObjectUtils.disposeAllChildren(this._AddRankingSprite);
         }
         this._AddRankingSprite = null;
         this._AddRankingBg = null;
         this._AddRankingText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

