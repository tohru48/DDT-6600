package ddt.view.caddyII
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.view.SetsShopView;
   
   public class CaddyViewII extends RightView
   {
      
      public static const NEED_KEY:int = 4;
      
      public static const START_TURN:String = "caddy_start_turn";
      
      public static const START_MOVE_AFTER_TURN:String = "start_move_after_turn";
      
      public static const GOODSNUMBER:int = 30;
      
      private var _bg:ScaleBitmapImage;
      
      private var _gridBGI:MovieImage;
      
      private var _lookBtn:TextButton;
      
      private var _openBtn:BaseButton;
      
      private var _keyBtn:BaseButton;
      
      private var _boxBtn:BaseButton;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _keyNumberTxt:FilterFrameText;
      
      private var _boxNumberTxt:FilterFrameText;
      
      private var _lookTrophy:LookTrophy;
      
      private var _keyNumber:int;
      
      private var _boxNumber:int;
      
      private var _selectedCount:int;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _templateIDList:Vector.<int>;
      
      private var _turn:CaddyTurn;
      
      private var _vipDescTxt:FilterFrameText;
      
      private var _vipIcon:Image;
      
      private var isActive:Boolean = false;
      
      public function CaddyViewII()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function set item(val:ItemTemplateInfo) : void
      {
         if(_item != val)
         {
            _item = val;
            if(_item.TemplateID == EquipType.Gold_Caddy)
            {
               if(Boolean(this._turn))
               {
                  this._turn.setCaddyType(CaddyModel.Gold_Caddy);
               }
               this._boxBtn.tipData = _item.Name;
            }
            else if(_item.TemplateID == EquipType.Silver_Caddy)
            {
               if(Boolean(this._turn))
               {
                  this._turn.setCaddyType(CaddyModel.Silver_Caddy);
               }
               this._boxBtn.tipData = _item.Name;
            }
            else
            {
               if(Boolean(this._turn))
               {
                  this._turn.setCaddyType(CaddyModel.CADDY_TYPE);
               }
               this._boxBtn.tipData = _item.Name;
            }
            this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
         }
      }
      
      private function initView() : void
      {
         var goldBorder:ScaleBitmapImage = null;
         var node:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.caddy.NodeAsset");
         node.text = LanguageMgr.GetTranslation("tank.view.caddy.rightTitleTip");
         this._vipDescTxt = ComponentFactory.Instance.creatComponentByStylename("asset.caddy.VipDescTxt");
         this._vipDescTxt.text = LanguageMgr.GetTranslation("tank.view.caddy.VipDescTxt");
         this._vipIcon = ComponentFactory.Instance.creatComponentByStylename("caddy.VipIcon");
         var goodsNameBG:Image = ComponentFactory.Instance.creatComponentByStylename("caddy.GoodsNameBG");
         goldBorder = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGrid.goldBorder");
         var numberBG:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("caddy.numberBG");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGI");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.LookBtn");
         this._lookBtn.text = LanguageMgr.GetTranslation("tank.view.caddy.lookTrophy");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._keyBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.KeyBtn");
         this._keyBtn.addChild(this.creatShape());
         this._boxBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.BoxBtn");
         this._boxBtn.addChild(this.creatShape());
         PositionUtils.setPos(this._boxBtn,"caddyII.caddy.BoxBtn.point");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.goodsNameTxt");
         this._keyNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.keyNumberTxt");
         this._boxNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.boxNumberTxt");
         PositionUtils.setPos(this._boxNumberTxt,"caddyII.BoxNumberTxt.point");
         this._turn = ComponentFactory.Instance.creatCustomObject("caddy.CaddyTurn",[this._goodsNameTxt]);
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         _autoCheck.selected = SharedManager.Instance.autoCaddy;
         var font:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.bagHavingTip");
         font.text = LanguageMgr.GetTranslation("tank.view.award.bagHaving");
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(node);
         addChild(goodsNameBG);
         addChild(numberBG);
         addChild(this._lookBtn);
         addChild(this._openBtn);
         addChild(this._keyBtn);
         addChild(this._boxBtn);
         addChild(this._goodsNameTxt);
         addChild(this._keyNumberTxt);
         addChild(this._boxNumberTxt);
         addChild(this._turn);
         addChild(goldBorder);
         addChild(_autoCheck);
         addChild(font);
         this._keyBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBuyKey");
         this._boxBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBoxKey");
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY);
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openClick);
         this._keyBtn.addEventListener(MouseEvent.CLICK,this._buyKey);
         this._keyBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._keyBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._boxBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._boxBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._turn.addEventListener(CaddyTurn.TURN_COMPLETE,this._turnComplete);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function __selectedChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoCaddy = _autoCheck.selected;
      }
      
      private function __quickBuyMouseOut(evt:MouseEvent) : void
      {
         if(evt.currentTarget != this._keyBtn)
         {
            if(evt.currentTarget == this._boxBtn)
            {
            }
         }
      }
      
      private function __quickBuyMouseOver(evt:MouseEvent) : void
      {
         if(evt.currentTarget != this._keyBtn)
         {
            if(evt.currentTarget == this._boxBtn)
            {
            }
         }
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.removeEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openClick);
         this._keyBtn.removeEventListener(MouseEvent.CLICK,this._buyKey);
         this._keyBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._keyBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._boxBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._boxBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._turn.removeEventListener(CaddyTurn.TURN_COMPLETE,this._turnComplete);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function __buyBuff(evt:MouseEvent) : void
      {
         var item:ShopItemInfo = null;
         var carItem:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var list:Array = [];
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Train_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         var setspayFrame:SetsShopView = new SetsShopView();
         setspayFrame.initialize(list);
         LayerManager.Instance.addToLayer(setspayFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function creatShape(w:Number = 100, h:Number = 25) : Shape
      {
         var size:Point = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyBtn.ButtonSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         return shape;
      }
      
      private function _bagUpdate(e:BagEvent) : void
      {
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
      }
      
      private function _look(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(EquipType.isCaddy(_item))
         {
            this._lookTrophy.show(CaddyModel.instance.getCaddyTrophy(_item.TemplateID));
         }
         else if(!EquipType.isBead(int(_item.Property1)))
         {
            if(EquipType.isOfferPackage(_item))
            {
            }
         }
      }
      
      private function __openClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openBoxImp();
      }
      
      private function hasKey() : Boolean
      {
         var caddyPayBuff:BuffInfo = PlayerManager.Instance.Self.getBuff(BuffInfo.Caddy_Good);
         if(caddyPayBuff != null && caddyPayBuff.ValidCount > 0)
         {
            return this.keyNumber + 1 >= NEED_KEY;
         }
         return this.keyNumber >= NEED_KEY;
      }
      
      private function openBoxImp() : void
      {
         var hasKey:Boolean = this.hasKey();
         if(this.boxNumber >= 1 && hasKey)
         {
            if(CaddyModel.instance.bagInfo.itemNumber < CaddyBagView.SUM_NUMBER)
            {
               this._openBtn.enable = false;
            }
            this.getRandomTempId();
            SocketManager.Instance.out.sendRouletteBox(BagInfo.CADDYBAG,-1,_item.TemplateID);
         }
         else if(!hasKey)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyKey"));
         }
         else if(this.boxNumber < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
         }
      }
      
      private function _quickBuy() : void
      {
         this._buyKey(null);
      }
      
      private function _buyKey(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._showQuickBuy(QuickBuyCaddy.CADDYKEY_NUMBER);
      }
      
      private function _buyBox(e:MouseEvent) : void
      {
      }
      
      private function _showQuickBuy(id:int) : void
      {
         var quick:QuickBuyCaddy = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyCaddy");
         quick.show(id);
      }
      
      private function _turnComplete(e:Event) : void
      {
         dispatchEvent(new Event(START_MOVE_AFTER_TURN));
      }
      
      private function againImp() : void
      {
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.caddy.showChat",this._selectedGoodsInfo.Name + "x" + this._selectedGoodsInfo.Count));
      }
      
      override public function again() : void
      {
         this._openBtn.enable = true;
         this._turn.again();
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.caddy.showChat",this._selectedGoodsInfo.Name + "x" + this._selectedGoodsInfo.Count));
         if(SharedManager.Instance.autoCaddy)
         {
            if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            }
            else if(this.keyNumber < NEED_KEY)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyKey"));
            }
            else if(this.boxNumber < 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
            }
            else
            {
               this.openBoxImp();
            }
         }
      }
      
      public function set keyNumber(value:int) : void
      {
         this._keyNumber = value;
         this._keyNumberTxt.text = String(this._keyNumber);
      }
      
      public function get keyNumber() : int
      {
         return this._keyNumber;
      }
      
      public function set boxNumber(value:int) : void
      {
         this._boxNumber = value;
         this._boxNumberTxt.text = String(this._boxNumber);
      }
      
      public function get boxNumber() : int
      {
         return this._boxNumber;
      }
      
      override public function setSelectGoodsInfo(info:InventoryItemInfo) : void
      {
         this._openBtn.enable = false;
         this._selectedGoodsInfo = info;
         this._startTurn();
         this._turn.setTurnInfo(this._selectedGoodsInfo,this._templateIDList);
         this._turn.start(_item);
      }
      
      private function _startTurn() : void
      {
         var evt:CaddyEvent = new CaddyEvent(START_TURN);
         evt.info = this._selectedGoodsInfo;
         dispatchEvent(evt);
      }
      
      private function getRandomTempId() : void
      {
         var ran1:int = 0;
         var templateList:Vector.<BoxGoodsTempInfo> = BossBoxManager.instance.caddyBoxGoodsInfo;
         this._templateIDList = new Vector.<int>();
         var basic:int = Math.floor(templateList.length / GOODSNUMBER);
         var ran:int = Math.floor(Math.random() * basic);
         ran = ran == 0 ? 1 : ran;
         for(var i:int = 1; i <= GOODSNUMBER; i++)
         {
            if(ran * i < templateList.length)
            {
               this._templateIDList.push(templateList[ran * i].TemplateId);
            }
         }
         var itemID:int = 0;
         for(var j:int = 0; j < this._templateIDList.length; j++)
         {
            ran1 = Math.floor(Math.random() * this._templateIDList.length);
            itemID = this._templateIDList[j];
            this._templateIDList[j] = this._templateIDList[ran1];
            this._templateIDList[ran1] = itemID;
         }
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._gridBGI))
         {
            ObjectUtils.disposeObject(this._gridBGI);
         }
         this._gridBGI = null;
         if(Boolean(this._lookBtn))
         {
            ObjectUtils.disposeObject(this._lookBtn);
         }
         this._lookBtn = null;
         if(Boolean(this._openBtn))
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         if(Boolean(this._goodsNameTxt))
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
         if(Boolean(this._keyNumberTxt))
         {
            ObjectUtils.disposeObject(this._keyNumberTxt);
         }
         this._keyNumberTxt = null;
         if(Boolean(this._boxNumberTxt))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._boxNumberTxt = null;
         if(Boolean(this._lookTrophy))
         {
            ObjectUtils.disposeObject(this._lookTrophy);
         }
         this._lookTrophy = null;
         if(Boolean(this._turn))
         {
            ObjectUtils.disposeObject(this._turn);
         }
         this._turn = null;
         if(Boolean(this._keyBtn))
         {
            ObjectUtils.disposeObject(this._keyBtn);
         }
         this._keyBtn = null;
         if(Boolean(this._boxBtn))
         {
            ObjectUtils.disposeObject(this._boxBtn);
         }
         this._boxBtn = null;
         ObjectUtils.disposeObject(_autoCheck);
         _autoCheck = null;
         ObjectUtils.disposeObject(this._vipDescTxt);
         this._vipDescTxt = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         _item = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

