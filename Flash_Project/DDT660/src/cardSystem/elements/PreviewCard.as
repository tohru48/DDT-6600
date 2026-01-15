package cardSystem.elements
{
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PreviewCard extends Sprite implements Disposeable
   {
      
      private var _cardId:int;
      
      private var _cell:CardCell;
      
      private var _bg:Bitmap;
      
      private var _Goldbg:Bitmap;
      
      private var _WhiteGoldbg:Bitmap;
      
      private var _Silverbg:Bitmap;
      
      private var _Coppebg:Bitmap;
      
      private var _prop:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _cardName:FilterFrameText;
      
      public function PreviewCard()
      {
         super();
         this.initView();
      }
      
      public function get cardId() : int
      {
         return this._cardId;
      }
      
      public function set cardId(value:int) : void
      {
         this._cardId = value;
         this._cardName.text = ItemManager.Instance.getTemplateById(this.cardId).Name;
         this._cardName.y = 41 - this._cardName.textHeight / 2;
      }
      
      private function initView() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,57,70);
         s.graphics.endFill();
         this._cell = new CardCell(s);
         this._cell.setContentSize(52,70);
         this._cell.starVisible = false;
         this._cell.Visibles = false;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.storyCard.BG");
         this._WhiteGoldbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.WhiteGrodCard.BG");
         this._Goldbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.GrodCard.BG");
         this._Silverbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.SilverCard.BG");
         this._Coppebg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.CopperCard.BG");
         this._prop = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.Propset");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.name");
         PositionUtils.setPos(this._cell,"PreviewCard.cellPos");
         addChild(this._bg);
         addChild(this._WhiteGoldbg);
         addChild(this._Goldbg);
         addChild(this._Silverbg);
         addChild(this._Coppebg);
         addChild(this._cardName);
         addChild(this._cell);
         addChild(this._prop);
         this._bg.visible = this._Goldbg.visible = this._Silverbg.visible = this._Coppebg.visible = false;
      }
      
      public function set cardInfo(info:CardInfo) : void
      {
         var cardTempleInfo:CardTemplateInfo = null;
         var str:String = "";
         if(Boolean(info))
         {
            this._cardInfo = info;
            this._cell.cardInfo = info;
            this._cell.visible = true;
            this._cell.Visibles = false;
            cardTempleInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(info.TemplateID),String(info.CardType));
            if(info.templateInfo.Attack != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",Number(cardTempleInfo.AttackRate)) + "<br/>");
            }
            if(info.templateInfo.Defence != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",Number(cardTempleInfo.DefendRate)) + "<br/>");
            }
            if(info.templateInfo.Agility != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",Number(cardTempleInfo.AgilityRate)) + "<br/>");
            }
            if(info.templateInfo.Luck != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",Number(cardTempleInfo.LuckyRate)) + "<br/>");
            }
            if(parseInt(info.templateInfo.Property4) != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage",Number(cardTempleInfo.DamageRate)) + "<br/>");
            }
            if(parseInt(info.templateInfo.Property5) != 0)
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",Number(cardTempleInfo.GuardRate)) + "<br/>");
            }
            if(info.CardType == 1)
            {
               this._Goldbg.visible = true;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(info.CardType == 2)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = true;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(info.CardType == 3)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = true;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(info.CardType == 4)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = true;
               this._bg.visible = false;
            }
            else
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = true;
            }
         }
         else
         {
            this._cell.cardInfo = null;
            this._cell.visible = false;
            this._Goldbg.visible = false;
            this._Silverbg.visible = false;
            this._WhiteGoldbg.visible = false;
            this._Coppebg.visible = false;
            this._bg.visible = true;
            str = LanguageMgr.GetTranslation("ddt.cardSystem.cardProp.unknown");
         }
         this._prop.htmlText = str;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      public function dispose() : void
      {
         this._cardInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._cell = null;
         this._bg = null;
         this._prop = null;
         this._cardName = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

