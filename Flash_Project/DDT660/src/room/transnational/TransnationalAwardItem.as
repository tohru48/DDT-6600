package room.transnational
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopGoodItem;
   
   public class TransnationalAwardItem extends ShopGoodItem
   {
      
      private static const AwardItemCell_Size:int = 61;
      
      private var _changeBtn:SimpleBitmapButton;
      
      private var _ScoresTxt:FilterFrameText;
      
      private var _ByScores:FilterFrameText;
      
      public function TransnationalAwardItem()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         _itemBg = ComponentFactory.Instance.creatComponentByStylename("TransnationalAward.GoodItemBg");
         _itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemCellBg");
         _itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("Transnational.GoodItemName");
         this._ByScores = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemPrice");
         _dotLine = ComponentFactory.Instance.creatComponentByStylename("TransnationalAward.GoodItemDotLine");
         this._changeBtn = ComponentFactory.Instance.creatComponentByStylename("asset.Transnationalshop.Exchange");
         this._ScoresTxt = ComponentFactory.Instance.creatComponentByStylename("asset.Transnationalshop.Scores");
         this._ScoresTxt.text = LanguageMgr.GetTranslation("littlegame.AwardScore");
         _itemCell = creatItemCell();
         PositionUtils.setPos(_itemCell,"ddtshop.ShopGoodItemCellPos");
         _itemCellBtn = new Sprite();
         _itemCellBtn.buttonMode = true;
         _itemCellBtn.addChild(_itemCell);
         _itemBg.setFrame(1);
         _itemCellBg.setFrame(1);
         addChild(_itemBg);
         addChild(_itemCellBg);
         addChild(_dotLine);
         addChild(_itemCellBtn);
         addChild(this._changeBtn);
         addChild(_itemNameTxt);
         addChild(this._ByScores);
         addChild(this._ScoresTxt);
      }
      
      override protected function addEvent() : void
      {
         this._changeBtn.addEventListener(MouseEvent.CLICK,this.__changeClick);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         _itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      private function __changeClick(evt:MouseEvent) : void
      {
         if(_shopItemInfo == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(TransnationalFightManager.Instance.currentScores < _shopItemInfo.getItemPrice(1).scoreValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack"));
            return;
         }
         SocketManager.Instance.out.sendButTransnationalGoods(_shopItemInfo.GoodsID);
      }
      
      override protected function __itemMouseOver(event:MouseEvent) : void
      {
         if(!_itemCell.info)
         {
            return;
         }
         if(Boolean(_lightMc))
         {
            addChild(_lightMc);
         }
         parent.addChild(this);
         _isMouseOver = true;
      }
      
      override protected function __itemMouseOut(event:MouseEvent) : void
      {
         ObjectUtils.disposeObject(_lightMc);
         if(!_shopItemInfo)
         {
            return;
         }
         _isMouseOver = false;
      }
      
      override protected function removeEvent() : void
      {
         if(Boolean(this._changeBtn))
         {
            this._changeBtn.removeEventListener(MouseEvent.CLICK,this.__changeClick);
         }
         if(Boolean(_itemCellBtn))
         {
            _itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         }
         if(Boolean(_itemCellBtn))
         {
            _itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         }
         if(Boolean(_itemBg))
         {
            _itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         }
      }
      
      override public function set shopItemInfo(value:ShopItemInfo) : void
      {
         if(Boolean(value))
         {
            this._ByScores.visible = true;
            _itemNameTxt.visible = true;
            this._ScoresTxt.visible = true;
            this._changeBtn.visible = true;
            _dotLine.visible = true;
            _itemCell.info = value.TemplateInfo;
            _shopItemInfo = value;
            _itemCell.tipInfo = value;
            _itemNameTxt.text = _itemCell.info.Name;
            if(_itemNameTxt.numLines > 1)
            {
               this._ByScores.y = 37;
               this._ScoresTxt.y = 37;
            }
            else
            {
               this._ByScores.y = 29;
               this._ScoresTxt.y = 29;
            }
            this._ByScores.text = String(value.AValue1);
         }
         else
         {
            this._ByScores.visible = false;
            _itemNameTxt.visible = false;
            this._ScoresTxt.visible = false;
            this._changeBtn.visible = false;
            _dotLine.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._ByScores);
         this._ByScores = null;
         ObjectUtils.disposeObject(this._ScoresTxt);
         this._ScoresTxt = null;
         ObjectUtils.disposeObject(this._changeBtn);
         this._changeBtn = null;
         super.dispose();
      }
   }
}

