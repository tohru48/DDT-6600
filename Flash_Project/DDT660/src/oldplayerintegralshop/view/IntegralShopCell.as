package oldplayerintegralshop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import battleGroud.data.BatlleData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
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
   import league.manager.LeagueManager;
   import oldplayerintegralshop.IntegralShopManager;
   import shop.view.ShopItemCell;
   
   public class IntegralShopCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _integral:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function IntegralShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.integralShopView.bg");
         addChild(this._bg);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("integralShopView.buyBtn");
         addChild(this._buyBtn);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("integralShopView.nameTxt");
         addChild(this._nameTxt);
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("integralShopView.needMoneyTxt");
         addChild(this._needMoneyTxt);
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,70,70);
         sp.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         PositionUtils.setPos(this._itemCell,"integralShopView.itemCell.pos");
         addChild(this._itemCell);
         this._integral = ComponentFactory.Instance.creatComponentByStylename("integralShopView.integral");
         this._integral.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopCellMoneyTxt");
         addChild(this._integral);
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
         if(IntegralShopManager.instance.integralNum < int(this._needMoneyTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.integral.unenoughIntegralText"),0,true);
            return;
         }
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.integral.buyConfirmTipTxt",this._needMoneyTxt.text,this._nameTxt.text),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmBuy);
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
            SocketManager.Instance.out.sendBuyRegressIntegralGoods(this._shopItemInfo.GoodsID,1);
         }
      }
      
      public function refreshShow(value:ShopItemInfo) : void
      {
         var tmpBattleData:BatlleData = null;
         this._shopItemInfo = value;
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
         this._itemCell.tipInfo = this._shopItemInfo;
         this._nameTxt.text = this._itemCell.info.Name;
         this._needMoneyTxt.text = this._shopItemInfo.AValue1.toString();
         if(LeagueManager.instance.militaryRank == -1)
         {
            return;
         }
         if(this._shopItemInfo.LimitGrade > LeagueManager.instance.militaryRank)
         {
            tmpBattleData = BattleGroudManager.Instance.getBattleDataByLevel(this._shopItemInfo.LimitGrade);
            this._itemCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
         }
         else
         {
            this._itemCell.filters = null;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.dispose();
            this._buyBtn = null;
         }
         if(Boolean(this._nameTxt))
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(Boolean(this._needMoneyTxt))
         {
            this._needMoneyTxt.dispose();
            this._needMoneyTxt = null;
         }
         if(Boolean(this._integral))
         {
            this._integral.dispose();
            this._integral = null;
         }
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmBuy);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

