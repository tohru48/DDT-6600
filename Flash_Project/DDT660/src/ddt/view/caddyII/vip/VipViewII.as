package ddt.view.caddyII.vip
{
   import bagAndInfo.cell.BaseCell;
   import cardSystem.data.CardInfo;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
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
   import ddt.view.caddyII.RightView;
   import ddt.view.caddyII.bead.BeadItem;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class VipViewII extends RightView
   {
      
      public static var _instance:VipViewII;
      
      public static const CARD_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0.1;
      
      public static const SELECT_SCALE_NUMBER:Number = 0;
      
      private var _bg:ScaleBitmapImage;
      
      private var _bg1:Image;
      
      private var _gridBGI:MovieImage;
      
      private var _gridBGII:MovieImage;
      
      private var _openBtn:BaseButton;
      
      private var _turnBG:Bitmap;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _turnSprite:Sprite;
      
      private var _movie:MovieImage;
      
      private var _effect:IEffect;
      
      private var _selectCell:BaseCell;
      
      private var _selectSprite:Sprite;
      
      private var _vipItem:BeadItem;
      
      private var _endFrame:int;
      
      private var _startY:int;
      
      private var _vipID:int;
      
      private var _vipPlace:int;
      
      private var _vipInfo:ItemTemplateInfo;
      
      private var _selectGoodsInfo:InventoryItemInfo;
      
      private var _inputTxt:FilterFrameText;
      
      private var _localAutoOpen:Boolean;
      
      private var winTime:int;
      
      public function VipViewII()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public static function get instance() : VipViewII
      {
         if(_instance == null)
         {
            _instance = new VipViewII();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bead.numInput.bg2");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGII");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         var _goldBorder:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("bead.rightGrid.goldBorder");
         var openBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         var font:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bead.fontII");
         font.text = LanguageMgr.GetTranslation("tank.view.award.bagHaving");
         var getFontBG:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.card.getFontBG");
         var getFont:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.card.getFont");
         getFont.text = LanguageMgr.GetTranslation("tank.view.award.getVip");
         var goodsNameBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBGII");
         this._vipItem = ComponentFactory.Instance.creatCustomObject("card.cardCell");
         this._vipItem.hideBg();
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("bead.numberTxt2");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._turnBG = ComponentFactory.Instance.creatBitmap("asset.vip.turnBG");
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         for(var i:int = 0; i < this._movie.movie.currentLabels.length; i++)
         {
            if(this._movie.movie.currentLabels[i].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[i].frame;
            }
         }
         addChild(this._bg);
         addChild(this._bg1);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(this._openBtn);
         addChild(openBG);
         addChild(font);
         addChild(getFont);
         addChild(goodsNameBG);
         addChild(this._goodsNameTxt);
         addChild(_goldBorder);
         addChild(this._inputTxt);
         addChild(this._vipItem);
         addChild(this._turnSprite);
         this._turnBG.x = this._turnBG.width / -2;
         this._turnBG.y = this._turnBG.height * -1 + CARD_TURNSPRITE;
         this._turnSprite.addChild(this._turnBG);
         this._startY = this._turnSprite.y;
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         this._localAutoOpen = _autoCheck.selected = SharedManager.Instance.autoVip;
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         addChild(_autoCheck);
         this.creatEffect();
         this.createSelectCell();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._update);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._update);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function _update(e:BagEvent) : void
      {
         this._vipItem.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._vipID);
         this._inputTxt.text = String(this._vipItem.count);
      }
      
      private function _updateCaddyBag(e:DictionaryEvent) : void
      {
         this.moviePlay();
      }
      
      override public function setSelectGoodsInfo(info:InventoryItemInfo) : void
      {
         SoundManager.instance.play("139");
         this._selectGoodsInfo = info;
         this._turnSprite.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
         this._selectCell.info = this._selectGoodsInfo;
         this._startTurn();
      }
      
      private function _startTurn() : void
      {
         var evt:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         evt.info = this._selectGoodsInfo;
         dispatchEvent(evt);
      }
      
      private function _openClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function __selectedChanged(e:Event) : void
      {
         SharedManager.Instance.autoVip = this._localAutoOpen = _autoCheck.selected;
      }
      
      public function setCard(val:int, place:int) : void
      {
         this._vipID = val;
         this._vipPlace = place;
         this._vipInfo = ItemManager.Instance.getTemplateById(this._vipID);
         this._vipItem.info = this._vipInfo;
         this._vipItem.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._vipID);
         this._inputTxt.text = String(this._vipItem.count);
         this.creatTweenMagnify();
         this._goodsNameTxt.text = this._vipInfo.Name;
      }
      
      private function haveCardNumber(id:int) : int
      {
         var number:int = 0;
         var info:CardInfo = null;
         var dic:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         for each(info in dic)
         {
            if(info.TemplateID == id)
            {
               number += info.Count;
            }
         }
         return number;
      }
      
      private function createSelectCell() : void
      {
         var size:Point = ComponentFactory.Instance.creatCustomObject("bead.selectCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(0,1);
         shape.graphics.drawRoundRect(0,0,size.x,size.y,12);
         shape.graphics.endFill();
         this._selectCell = new BaseCell(shape);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChildAt(this._selectSprite,getChildIndex(this._movie));
         this._selectSprite.visible = false;
      }
      
      private function creatEffect() : void
      {
         this._effect = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._turnBG,{
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
         TweenLite.killTweensOf(this._turnSprite);
         this._turnSprite.scaleY = 1;
         this._turnSprite.scaleX = 1;
         this._turnSprite.y = this._startY;
         TweenLite.from(this._turnSprite,0.5,{
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER
         });
         TweenLite.to(this._turnSprite,0.4,{
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
         if(Boolean(this._goodsNameTxt))
         {
            this._goodsNameTxt.text = this._vipInfo.Name;
         }
      }
      
      private function openImp() : void
      {
         if(Boolean(this._vipItem))
         {
            if(this._vipItem.count > 0 && this._vipInfo.TemplateID == EquipType.VIP_COIN)
            {
               if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
               }
               else
               {
                  this._openBtn.enable = false;
                  this._localAutoOpen = SharedManager.Instance.autoVip;
                  SocketManager.Instance.out.sendRouletteBox(BagInfo.CADDYBAG,-2,this._vipInfo.TemplateID);
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.noVip"));
            }
         }
      }
      
      private function getCardPlace(place:int) : int
      {
         var info:InventoryItemInfo = null;
         var arr:Array = PlayerManager.Instance.Self.Bag.findCellsByTempleteID(this._vipID);
         for each(info in arr)
         {
            if(info.Place == place)
            {
               return place;
            }
         }
         return arr[0].Place;
      }
      
      private function getRandomCardPlace(place:int) : int
      {
         var info:InventoryItemInfo = null;
         var arr:Array = PlayerManager.Instance.Self.PropBag.findCellsByTempleteID(this._vipID);
         for each(info in arr)
         {
            if(info.Place == place)
            {
               return place;
            }
         }
         return arr[0].Place;
      }
      
      override public function again() : void
      {
         if(!this._turnSprite || !this._movie || !this._selectSprite || !this._openBtn)
         {
            return;
         }
         this._turnSprite.visible = true;
         this._movie.visible = false;
         this._movie.movie.gotoAndStop(1);
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
         if(this._localAutoOpen)
         {
            this.openImp();
         }
         else
         {
            this._openBtn.enable = true;
         }
      }
      
      private function moviePlay() : void
      {
         SoundManager.instance.play("139");
         this._openBtn.enable = false;
         this._turnSprite.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
      }
      
      private function __frameHandler(e:Event) : void
      {
         if(this._movie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectGoodsInfo.Name;
            if(Boolean(this._selectCell))
            {
               this._selectCell.info = this._selectGoodsInfo;
            }
            this.creatTweenSelectMagnify();
         }
      }
      
      public function get closeEnble() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         clearTimeout(this.winTime);
         TweenLite.killTweensOf(this._turnSprite);
         TweenLite.killTweensOf(this._selectSprite);
         this._vipInfo = null;
         this._selectGoodsInfo = null;
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
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
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
         if(Boolean(this._turnSprite))
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(Boolean(this._movie))
         {
            this._movie.movie.stop();
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
         }
         if(Boolean(this._effect))
         {
            ObjectUtils.disposeObject(this._effect);
         }
         this._effect = null;
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
         if(Boolean(this._vipItem))
         {
            ObjectUtils.disposeObject(this._vipItem);
         }
         this._vipItem = null;
         if(Boolean(_autoCheck))
         {
            ObjectUtils.disposeObject(_autoCheck);
         }
         _autoCheck = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

