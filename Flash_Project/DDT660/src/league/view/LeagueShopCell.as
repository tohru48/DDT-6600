package league.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import battleGroud.data.BatlleData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import league.manager.LeagueManager;
   import shop.view.ShopItemCell;
   
   public class LeagueShopCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moneyIcon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _cannotBuyTipTxt:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function LeagueShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.leagueShopCell.bg");
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("asset.leagueShopCell.moneyIcon");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.buyBtn");
         this._buyBtn.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.nameTxt");
         this._nameTxt.autoSize = TextFieldAutoSize.CENTER;
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.needMoneyTxt");
         this._cannotBuyTipTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.cannotBuyTipTxt");
         this._cannotBuyTipTxt.autoSize = TextFieldAutoSize.CENTER;
         this._cannotBuyTipTxt.visible = false;
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,70,70);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         PositionUtils.setPos(this._itemCell,"leagueShopCell.itemCell.pos");
         addChild(this._bg);
         addChild(this._moneyIcon);
         addChild(this._buyBtn);
         addChild(this._nameTxt);
         addChild(this._needMoneyTxt);
         addChild(this._cannotBuyTipTxt);
         addChild(this._itemCell);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.buyHandler,false,0,true);
      }
      
      private function buyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.leagueMoney < int(this._needMoneyTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.league.unenoughMoneyTxpTxt"),0,true);
            return;
         }
         var _quickFrame:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quickFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quickFrame.setItemID(this._shopItemInfo.TemplateID,6);
         _quickFrame.buyFrom = 0;
         LayerManager.Instance.addToLayer(_quickFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __confirmBuy(evt:FrameEvent) : void
      {
         var items:Array = null;
         var types:Array = null;
         var colors:Array = null;
         var places:Array = null;
         var dresses:Array = null;
         var goodsTypes:Array = null;
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmBuy);
         this._confirmFrame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            items = [this._shopItemInfo.GoodsID];
            types = [1];
            colors = [""];
            places = [""];
            dresses = [""];
            goodsTypes = [this._shopItemInfo.isDiscount];
            SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,null,0,goodsTypes);
         }
      }
      
      public function refreshShow(value:ShopItemInfo) : void
      {
         var tmpBattleData:BatlleData = null;
         this._shopItemInfo = value;
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
         this._itemCell.tipInfo = this._shopItemInfo;
         this._nameTxt.text = this._itemCell.info.Name;
         if(this._nameTxt.text.length > 22)
         {
            this._nameTxt.text = this._itemCell.info.Name.substr(0,20) + "...";
         }
         this._nameTxt.y = this._nameTxt.numLines > 1 ? 0 : 7;
         this._needMoneyTxt.text = this._shopItemInfo.AValue1.toString();
         if(LeagueManager.instance.militaryRank == -1)
         {
            return;
         }
         if(this._shopItemInfo.LimitGrade > LeagueManager.instance.militaryRank)
         {
            this._buyBtn.visible = false;
            this._cannotBuyTipTxt.visible = true;
            tmpBattleData = BattleGroudManager.Instance.getBattleDataByLevel(this._shopItemInfo.LimitGrade);
            this._cannotBuyTipTxt.text = LanguageMgr.GetTranslation("ddt.league.cannotBuyTipTxt",tmpBattleData.Name);
            this._cannotBuyTipTxt.y = this._cannotBuyTipTxt.numLines > 1 ? 49 : 57;
            this._itemCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
         }
         else
         {
            this._buyBtn.visible = true;
            this._cannotBuyTipTxt.visible = false;
            this._itemCell.filters = null;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moneyIcon = null;
         this._buyBtn = null;
         this._nameTxt = null;
         this._needMoneyTxt = null;
         this._cannotBuyTipTxt = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmBuy);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

