package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyBagView;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.LookTrophy;
   import ddt.view.caddyII.RightView;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import store.view.shortcutBuy.ShortcutBuyFrame;
   
   public class BeadViewII extends RightView
   {
      
      public static const BeadFromSmelt:int = -1;
      
      public static const Bead:int = 1;
      
      public static const OFFER_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0;
      
      public static const SELECT_SCALE_NUMBER:Number = 0;
      
      private var _titleTipTxt:FilterFrameText;
      
      private var _bg:ScaleBitmapImage;
      
      private var _gridBGI:MovieImage;
      
      private var _gridBGII:MovieImage;
      
      private var _openBtn:BaseButton;
      
      private var _itemContainer:HBox;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _turnBG:ScaleFrameImage;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectCell:BaseCell;
      
      private var _selectSprite:Sprite;
      
      private var _lookTrophy:LookTrophy;
      
      private var _selectGoodsInfo:InventoryItemInfo;
      
      private var _selectItem:int = -1;
      
      private var _turnSprite:Sprite;
      
      private var _effect:IEffect;
      
      private var _startY:Number;
      
      private var _clickNumber:int;
      
      private var _turnItemShape:Shape;
      
      private var _cellId:Array = [EquipType.BEAD_ATTACK,EquipType.BEAD_DEFENSE,EquipType.BEAD_ATTRIBUTE];
      
      private var _smeltBeadCell:BeadItem;
      
      private var _beadQuickBuyBtn:BaseButton;
      
      private var _beadQuickBuyBtnText1:FilterFrameText;
      
      private var _turnCell:BeadCell;
      
      private var _hasCell:Boolean = false;
      
      private var _localAutoOpen:Boolean;
      
      private var _inputBg:Image;
      
      private var _font:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _buyType:int = 0;
      
      public function BeadViewII()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function get openBtn() : BaseButton
      {
         return this._openBtn;
      }
      
      private function updateTitleTip(val:int) : void
      {
         switch(val)
         {
            case EquipType.MYSTICAL_CARDBOX:
               this._titleTipTxt.text = LanguageMgr.GetTranslation("tank.view.bead.rightTitleTip2");
               break;
            case EquipType.MY_CARDBOX:
               this._titleTipTxt.text = LanguageMgr.GetTranslation("tank.view.bead.rightTitleTip3");
               break;
            default:
               this._titleTipTxt.text = LanguageMgr.GetTranslation("tank.view.bead.rightTitleTip");
         }
      }
      
      override public function setType(val:int) : void
      {
         _type = val;
         this._buyType = val;
         this.updateTitleTip(val);
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX)
         {
            this.clearCell();
            this.createBead();
            this.updateBead();
            this._beadQuickBuyBtn.visible = false;
            this._inputBg.visible = true;
            this._font.visible = true;
            this._inputTxt.visible = true;
            this._inputBg.visible = true;
            this._font.visible = true;
            this._inputTxt.visible = true;
         }
         else if(_type == EquipType.MY_CARDBOX)
         {
            this.clearCell();
            this.createBead();
            this.updateBead();
            this._beadQuickBuyBtn.visible = false;
            this._inputBg.visible = true;
            this._font.visible = true;
            this._inputTxt.visible = true;
         }
         else
         {
            this.clearBead();
            this.createCell();
            this._inputBg.visible = false;
            this._font.visible = false;
            this._inputTxt.visible = false;
         }
      }
      
      private function createCell() : void
      {
         var i:int = 0;
         var cell:BeadItem = null;
         if(this._hasCell)
         {
            return;
         }
         for(i = 0; i < this._cellId.length; i++)
         {
            cell = new BeadItem();
            cell.info = ItemManager.Instance.getTemplateById(this._cellId[i]);
            cell.buttonMode = true;
            cell.addEventListener(MouseEvent.CLICK,this._itemClick);
            this._itemContainer.addChild(cell);
            this._itemGroup.addSelectItem(cell);
            cell.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cellId[i]);
         }
         this._hasCell = true;
      }
      
      private function updateCell() : void
      {
         for(var i:int = 0; i < this._itemContainer.numChildren; i++)
         {
            (this._itemContainer.getChildAt(i) as BeadItem).count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cellId[i]);
         }
      }
      
      private function clearCell() : void
      {
         var item:BeadItem = null;
         while(this._itemContainer.numChildren > 0)
         {
            item = this._itemContainer.getChildAt(0) as BeadItem;
            item.removeEventListener(MouseEvent.CLICK,this._itemClick);
            ObjectUtils.disposeObject(item);
            this._itemGroup.removeSelectItem(item);
            item = null;
         }
         this._hasCell = false;
      }
      
      private function createBead() : void
      {
         this._smeltBeadCell = ComponentFactory.Instance.creatCustomObject("bead.SmeltBeadCell");
         this._smeltBeadCell.mouseEnabled = false;
         this._smeltBeadCell.info = ItemManager.Instance.getTemplateById(_type);
         addChild(this._smeltBeadCell);
         this._smeltBeadCell.hideBg();
         this._turnCell.info = ItemManager.Instance.getTemplateById(_type);
         this.creatTweenMagnify();
      }
      
      private function updateBead() : void
      {
         this._smeltBeadCell.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_type);
         this._inputTxt.text = String(this._smeltBeadCell.count);
      }
      
      private function clearBead() : void
      {
         if(Boolean(this._smeltBeadCell))
         {
            ObjectUtils.disposeObject(this._smeltBeadCell);
            this._smeltBeadCell = null;
         }
      }
      
      private function updateItemShape() : void
      {
         this._turnCell.x = this._turnCell.width / -2;
         this._turnCell.y = -89;
      }
      
      private function initView() : void
      {
         var goldBorder:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("bead.rightGrid.goldBorder");
         this._titleTipTxt = ComponentFactory.Instance.creatComponentByStylename("bead.titleTipTxt");
         this._titleTipTxt.text = LanguageMgr.GetTranslation("tank.view.bead.rightTitleTip");
         this._itemGroup = new SelectedButtonGroup();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._inputBg = ComponentFactory.Instance.creatComponentByStylename("bead.numInput.bg2");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGII");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("bead.selectBox");
         var openBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         this._font = ComponentFactory.Instance.creatComponentByStylename("bead.fontII");
         this._font.text = LanguageMgr.GetTranslation("tank.view.award.bagHaving");
         var goodsNameBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBGII");
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("bead.numberTxt2");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._turnBG = ComponentFactory.Instance.creatComponentByStylename("bead.turnBG");
         this._turnCell = new BeadCell();
         this._beadQuickBuyBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.bead.QuickBuyButton");
         this._beadQuickBuyBtnText1 = ComponentFactory.Instance.creatComponentByStylename("bead.quickBuyBtn.text");
         this._beadQuickBuyBtnText1.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         addChild(this._bg);
         addChild(this._inputBg);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(this._openBtn);
         addChild(this._itemContainer);
         addChild(openBG);
         addChild(this._font);
         addChild(goodsNameBG);
         addChild(this._inputTxt);
         addChild(goldBorder);
         addChild(this._titleTipTxt);
         addChild(this._goodsNameTxt);
         this._turnSprite.addChild(this._turnCell);
         addChild(this._turnSprite);
         this._beadQuickBuyBtn.addChild(this._beadQuickBuyBtnText1);
         this._beadQuickBuyBtn.addChild(this._beadQuickBuyBtnText1);
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         this._localAutoOpen = _autoCheck.selected = SharedManager.Instance.autoBead;
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         addChild(_autoCheck);
         this._turnBG.setFrame(1);
         this._startY = this._turnSprite.y;
         this.createSelectCell();
         this.updateItemShape();
         this.creatEffect();
         this.createCell();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._update);
         CaddyModel.instance.addEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadTypeChange);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         this._beadQuickBuyBtn.addEventListener(MouseEvent.CLICK,this.__beadQuickBuy);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function __selectedChanged(event:Event) : void
      {
         SharedManager.Instance.autoBead = this._localAutoOpen = _autoCheck.selected;
      }
      
      private function __beadQuickBuy(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showQuickBuyBead();
      }
      
      private function showQuickBuyBead() : void
      {
         var tmpSelectedIndex:int = 0;
         var cardQuick:CardBoxQuickBuy = null;
         if(_type != EquipType.MYSTICAL_CARDBOX && _type != EquipType.MY_CARDBOX)
         {
            tmpSelectedIndex = -1;
            if(this._buyType == CaddyModel.Bead_Attack || EquipType.isAttackBeadFromSmeltByID(this._buyType))
            {
               tmpSelectedIndex = 0;
            }
            else if(this._buyType == CaddyModel.Bead_Defense || EquipType.isDefenceBeadFromSmeltByID(this._buyType))
            {
               tmpSelectedIndex = 1;
            }
            else if(this._buyType == CaddyModel.Bead_Attribute || EquipType.isAttributeBeadFromSmeltByID(this._buyType))
            {
               tmpSelectedIndex = 2;
            }
            else
            {
               tmpSelectedIndex = this._clickNumber;
            }
            this.openShortcutBuyFrame(tmpSelectedIndex);
         }
         else
         {
            cardQuick = ComponentFactory.Instance.creatCustomObject("bead.CardBoxQuickBuy");
            LayerManager.Instance.addToLayer(cardQuick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function openShortcutBuyFrame(tmpSelectedIndex:int) : void
      {
         var quickBuy:ShortcutBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame");
         quickBuy.show(this._cellId,false,LanguageMgr.GetTranslation("tank.view.bead.quickBuyTitle"),5,tmpSelectedIndex,75);
      }
      
      private function __buyGoods(event:Event) : void
      {
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._update);
         CaddyModel.instance.removeEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadTypeChange);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         this._beadQuickBuyBtn.removeEventListener(MouseEvent.CLICK,this.__beadQuickBuy);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function createSelectCell() : void
      {
         var size:Point = ComponentFactory.Instance.creatCustomObject("bead.selectCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._selectCell = new BaseCell(shape);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChild(this._selectSprite);
         this._selectSprite.visible = false;
      }
      
      private function _update(e:BagEvent) : void
      {
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX)
         {
            this.updateBead();
         }
         else
         {
            this.updateCell();
         }
      }
      
      private function _beadTypeChange(e:Event) : void
      {
         if(!EquipType.isBeadFromSmeltByID(CaddyModel.instance.beadType) && CaddyModel.instance.beadType != EquipType.MYSTICAL_CARDBOX && CaddyModel.instance.beadType != EquipType.MY_CARDBOX)
         {
            this._itemGroup.selectIndex = this.selectItem = CaddyModel.instance.beadType;
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]).Name;
         }
         else
         {
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(CaddyModel.instance.beadType).Name;
         }
      }
      
      private function openImp() : void
      {
         var alert:BaseAlerFrame = null;
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX)
         {
            if(this._smeltBeadCell.count > 0)
            {
               if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
               }
               else
               {
                  this._openBtn.enable = false;
                  this._localAutoOpen = SharedManager.Instance.autoBead;
                  SocketManager.Instance.out.sendOpenDead(CaddyModel.instance.bagInfo.BagType,-2,_type);
               }
            }
            else
            {
               if(_type != EquipType.MYSTICAL_CARDBOX && _type != EquipType.MY_CARDBOX)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNode1"));
                  return;
               }
               if(_type != EquipType.MY_CARDBOX)
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bead.buyNoCardBox"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  alert.moveEnable = false;
                  alert.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNoCardBox1"));
            }
         }
         else
         {
            if((this._itemContainer.getChildAt(this._selectItem) as BeadItem).count <= 0)
            {
               this._clickNumber = this._selectItem;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNode1"));
               return;
            }
            if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            }
            else
            {
               this._openBtn.enable = false;
               this._localAutoOpen = SharedManager.Instance.autoBead;
               SocketManager.Instance.out.sendOpenDead(CaddyModel.instance.bagInfo.BagType,-2,this._cellId[this._selectItem]);
            }
         }
      }
      
      private function _openClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function _lookClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function _itemClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._clickNumber = this._itemContainer.getChildIndex(e.currentTarget as BeadItem);
         this._itemGroup.selectIndex = this.selectItem = this._clickNumber;
         this._buyType = this._clickNumber;
         if((this._itemContainer.getChildAt(this._clickNumber) as BeadItem).count <= 0)
         {
            this._localAutoOpen = false;
            e.stopImmediatePropagation();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNode1"));
            return;
         }
      }
      
      private function _response(e:FrameEvent) : void
      {
         ObjectUtils.disposeObject(e.currentTarget);
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.showQuickBuyBead();
         }
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         ObjectUtils.disposeObject(e.currentTarget);
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.openShortcutBuyFrame(this._clickNumber);
         }
      }
      
      private function creatEffect() : void
      {
         this._effect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._turnCell,{
            "color":EffectColorType.GOLD,
            "speed":0.4,
            "blurWidth":10,
            "intensity":40,
            "strength":0.6
         });
         this._effect.play();
      }
      
      private function creatTweenMagnify() : void
      {
         TweenMax.killTweensOf(this._turnSprite);
         this._turnSprite.scaleY = 1;
         this._turnSprite.scaleX = 1;
         this._turnSprite.y = this._startY;
         TweenMax.from(this._turnSprite,0.5,{
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER
         });
         TweenMax.to(this._turnSprite,0.4,{
            "delay":0.5,
            "y":this._startY + 4,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      private function creatTweenSelectMagnify() : void
      {
         TweenMax.from(this._selectSprite,0.7,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":320,
            "alpha":20,
            "onComplete":this._moveOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function _moveOk() : void
      {
         setTimeout(this._toMove,400);
      }
      
      private function _toMove() : void
      {
         dispatchEvent(new Event(RightView.START_MOVE_AFTER_TURN));
         if(Boolean(this._selectCell))
         {
            this._selectCell.info = null;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.visible = false;
         }
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX)
         {
            if(Boolean(this._goodsNameTxt))
            {
               this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(_type).Name;
            }
         }
         else if(Boolean(this._goodsNameTxt))
         {
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]).Name;
         }
      }
      
      public function set selectItem(value:int) : void
      {
         if(this._selectItem == value)
         {
            return;
         }
         this._selectItem = value;
         this._turnCell.info = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]);
         EffectManager.Instance.removeEffect(this._effect);
         this.creatTweenMagnify();
         this.creatEffect();
         CaddyModel.instance.beadType = this._cellId[this._selectItem];
      }
      
      public function get selectItem() : int
      {
         return this._selectItem;
      }
      
      override public function again() : void
      {
         this._turnSprite.visible = true;
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
         if(this._localAutoOpen)
         {
            this.openImp();
         }
      }
      
      override public function setSelectGoodsInfo(info:InventoryItemInfo) : void
      {
         SoundManager.instance.play("139");
         this._selectGoodsInfo = info;
         this._turnSprite.visible = false;
         this._selectSprite.visible = true;
         this._goodsNameTxt.text = this._selectGoodsInfo.Name;
         this.creatTweenSelectMagnify();
         this._selectCell.info = this._selectGoodsInfo;
         this._startTurn();
      }
      
      private function _startTurn() : void
      {
         var evt:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         evt.info = this._selectGoodsInfo;
         dispatchEvent(evt);
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         var item:BeadItem = null;
         this.removeEvents();
         TweenMax.killTweensOf(this._turnSprite);
         TweenMax.killTweensOf(this._selectSprite);
         while(this._itemContainer.numChildren > 0)
         {
            item = this._itemContainer.getChildAt(0) as BeadItem;
            item.removeEventListener(MouseEvent.CLICK,this._itemClick);
            ObjectUtils.disposeObject(item);
            item = null;
         }
         if(Boolean(this._beadQuickBuyBtn))
         {
            ObjectUtils.disposeObject(this._beadQuickBuyBtn);
         }
         this._beadQuickBuyBtn = null;
         if(Boolean(this._beadQuickBuyBtnText1))
         {
            ObjectUtils.disposeObject(this._beadQuickBuyBtnText1);
         }
         this._beadQuickBuyBtnText1 = null;
         if(Boolean(this._font))
         {
            ObjectUtils.disposeObject(this._font);
         }
         this._font = null;
         if(Boolean(this._inputTxt))
         {
            ObjectUtils.disposeObject(this._inputTxt);
         }
         this._inputTxt = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._inputBg))
         {
            ObjectUtils.disposeObject(this._inputBg);
         }
         this._inputBg = null;
         if(Boolean(this._gridBGI))
         {
            ObjectUtils.disposeObject(this._gridBGI);
         }
         this._gridBGI = null;
         if(Boolean(this._gridBGII))
         {
            ObjectUtils.disposeObject(this._gridBGII);
         }
         this._gridBGII = null;
         if(Boolean(this._openBtn))
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         if(Boolean(this._itemContainer))
         {
            ObjectUtils.disposeObject(this._itemContainer);
         }
         this._itemContainer = null;
         if(Boolean(this._turnBG))
         {
            ObjectUtils.disposeObject(this._turnBG);
         }
         this._turnBG = null;
         if(Boolean(this._goodsNameTxt))
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
         if(Boolean(this._selectCell))
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(Boolean(this._selectSprite))
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(Boolean(this._lookTrophy))
         {
            ObjectUtils.disposeObject(this._lookTrophy);
         }
         this._lookTrophy = null;
         if(Boolean(this._itemGroup))
         {
            ObjectUtils.disposeObject(this._itemGroup);
         }
         this._itemGroup = null;
         ObjectUtils.disposeObject(_autoCheck);
         _autoCheck = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

