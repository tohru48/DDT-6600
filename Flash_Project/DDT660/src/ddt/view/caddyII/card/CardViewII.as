package ddt.view.caddyII.card
{
   import bagAndInfo.cell.BaseCell;
   import cardSystem.data.CardInfo;
   import com.greensock.TweenLite;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Sine;
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
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.RightView;
   import ddt.view.caddyII.bead.BeadItem;
   import ddt.view.caddyII.reader.AwardsInfo;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CardViewII extends RightView
   {
      
      public static var _instance:CardViewII;
      
      public static const CARD_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0.1;
      
      public static const SELECT_SCALE_NUMBER:Number = 0.05;
      
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
      
      private var _cardItem:BeadItem;
      
      private var _smeltBeadCell:BeadItem;
      
      private var _cardNumberTxt:FilterFrameText;
      
      private var _endFrame:int;
      
      private var _startY:int;
      
      private var _cardID:int;
      
      private var _cardPlace:int;
      
      private var _haveCardNumber:int;
      
      private var _cardInfo:ItemTemplateInfo;
      
      private var _selectGoodsInfo:ItemTemplateInfo;
      
      private var _inputTxt:FilterFrameText;
      
      private var _localAutoOpen:Boolean;
      
      private var info:CardInfo;
      
      private var mAwardSoul:AwardsInfo;
      
      private var winTime:int;
      
      private var mSprite:Sprite = new Sprite();
      
      private var mSpriteX:int;
      
      public function CardViewII()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public static function get instance() : CardViewII
      {
         if(_instance == null)
         {
            _instance = new CardViewII();
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
         getFont.text = LanguageMgr.GetTranslation("tank.view.award.getCard");
         var goodsNameBG:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBGII");
         this._cardItem = ComponentFactory.Instance.creatCustomObject("card.cardCell");
         this._cardItem.hideBg();
         this._smeltBeadCell = ComponentFactory.Instance.creatCustomObject("bead.SmeltBeadCell");
         addChild(this._smeltBeadCell);
         this._smeltBeadCell.hideBg();
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("bead.numberTxt2");
         this._cardNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.card.cardNumber");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._turnBG = ComponentFactory.Instance.creatBitmap("asset.card.turnBG");
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
         addChild(this._cardItem);
         addChild(this._turnSprite);
         this._turnBG.x = this._turnBG.width / -2;
         this._turnBG.y = this._turnBG.height * -1 + CARD_TURNSPRITE;
         this._turnSprite.addChild(this._turnBG);
         this._startY = this._turnSprite.y;
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         this._localAutoOpen = _autoCheck.selected = SharedManager.Instance.autoOfferPack;
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         addChild(_autoCheck);
         this.creatEffect();
         this.createSelectCell();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._upPropdate);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
         PlayerManager.Instance.addEventListener(CaddyModel.CARDS_NAME,this.__setGoodName);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._upPropdate);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
         PlayerManager.Instance.removeEventListener(CaddyModel.CARDS_NAME,this.__setGoodName);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function _update(e:BagEvent) : void
      {
         this._cardItem.count = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(this._cardID);
         this._inputTxt.text = String(this._cardItem.count);
      }
      
      private function _upPropdate(event:BagEvent) : void
      {
         this._smeltBeadCell.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cardID);
         this._inputTxt.text = String(this._smeltBeadCell.count);
      }
      
      private function _updateCaddyBag(e:DictionaryEvent) : void
      {
         var number:int = this.haveCardNumber(int(this._cardInfo.Property5));
         if(number == this._haveCardNumber)
         {
            this._cardNumberTxt.text = (int(this._cardNumberTxt.text) + number - this._haveCardNumber).toString();
            this._haveCardNumber = number;
            this.moviePlay();
         }
      }
      
      private function __getSoul(event:CrazyTankSocketEvent) : void
      {
         var tempArr:Vector.<AwardsInfo> = null;
         var info:AwardsInfo = null;
         var number:int = 0;
         var pkg:PackageIn = event.pkg;
         var b:Boolean = pkg.readBoolean();
         if(b)
         {
            tempArr = new Vector.<AwardsInfo>();
            info = new AwardsInfo();
            info.zoneID = pkg.readInt();
            info.name = "";
            number = this.haveCardNumber(int(this._cardInfo.Property5));
            PlayerManager.Instance.Self.CardSoul += info.zoneID;
            this._cardNumberTxt.text = (int(this._cardNumberTxt.text) + number - this._haveCardNumber).toString();
            this._haveCardNumber = number;
            this.mAwardSoul = info;
            this.moviePlay();
            tempArr.push(info);
            CaddyModel.instance.addAwardsInfoByArr(tempArr);
         }
      }
      
      private function __setGoodName(event:Event) : void
      {
         this.info = PlayerManager.Instance.Self.cardInfo;
         this._goodsNameTxt.text = this.info.templateInfo.Name;
         var card:String = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.card");
         if(this.info.CardType == 1)
         {
            this._goodsNameTxt.text += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.jin") + card;
         }
         else if(this.info.CardType == 2)
         {
            this._goodsNameTxt.text += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.yin") + card;
         }
         else if(this.info.CardType == 4)
         {
            this._goodsNameTxt.text += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.baijin") + card;
         }
         else
         {
            this._goodsNameTxt.text += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.tong") + card;
         }
      }
      
      private function _openClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function __selectedChanged(e:Event) : void
      {
         SharedManager.Instance.autoOfferPack = this._localAutoOpen = _autoCheck.selected;
      }
      
      public function setCard(val:int, place:int) : void
      {
         this._cardID = val;
         this._cardPlace = place;
         this._cardInfo = ItemManager.Instance.getTemplateById(this._cardID);
         this._cardItem.info = this._cardInfo;
         this._smeltBeadCell.info = ItemManager.Instance.getTemplateById(this._cardID);
         if(this._cardID == EquipType.MY_CARDBOX || this._cardID == EquipType.MYSTICAL_CARDBOX)
         {
            this._smeltBeadCell.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cardID);
            this._inputTxt.text = String(this._smeltBeadCell.count);
         }
         else
         {
            this._cardItem.count = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(this._cardID);
            this._inputTxt.text = String(this._cardItem.count);
         }
         this._selectGoodsInfo = ItemManager.Instance.getTemplateById(this._cardID);
         this._haveCardNumber = this.haveCardNumber(int(this._cardInfo.Property5));
         this.creatTweenMagnify();
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
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._selectCell = new BaseCell(shape);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChildAt(this._selectSprite,getChildIndex(this._movie));
         addChildAt(this.mSprite,getChildIndex(this._movie));
         this._selectSprite.visible = false;
         this.mSprite.visible = false;
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
         this._selectSprite.x = 164;
         this._selectSprite.y = 125;
         this._selectSprite.scaleY = 1;
         this._selectSprite.scaleX = 1;
         TweenLite.from(this._selectSprite,0.7,{
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
         TweenLite.to(this._selectSprite,0.3,{
            "scaleX":1.5,
            "scaleY":1.5,
            "repeat":1,
            "yoyo":true
         });
         TweenLite.to(this._selectSprite,0.3,{
            "delay":0.3,
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER,
            "x":550,
            "y":360
         });
         this.winTime = setTimeout(this._toMove,800);
      }
      
      private function _toMove() : void
      {
         TweenLite.killTweensOf(this._selectSprite);
         TweenLite.killTweensOf(this.mAwardSoul);
         if(Boolean(this._selectCell))
         {
            this._selectCell.info = null;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.visible = false;
            this._selectSprite.x = 164;
            this._selectSprite.y = 125;
            this._selectSprite.scaleX = this._selectSprite.scaleY = 1;
         }
         if(Boolean(this.mSprite))
         {
            this.mSprite.visible = false;
            ObjectUtils.disposeAllChildren(this.mSprite);
            this.mSprite.scaleX = this.mSprite.scaleY = 1;
         }
         if(Boolean(this._goodsNameTxt))
         {
            this._goodsNameTxt.text = "";
         }
         this.again();
      }
      
      private function openImp() : void
      {
         if(Boolean(this._cardItem))
         {
            if(this.haveCardNumber(int(this._cardInfo.Property5)) >= 997)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.moreCard"));
               this._openBtn.enable = true;
               return;
            }
            if(PlayerManager.Instance.Self.Grade < 20)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.openCardBox.text"));
               this._openBtn.enable = true;
               return;
            }
            if(this._cardItem.count > 0 && this._cardInfo.CategoryID == EquipType.CARDBOX)
            {
               this._openBtn.enable = false;
               this._localAutoOpen = SharedManager.Instance.autoOfferPack;
               SocketManager.Instance.out.sendOpenCardBox(this.getCardPlace(this._cardPlace),1);
            }
            else if(this._smeltBeadCell.count > 0 && (this._cardInfo.TemplateID == EquipType.MY_CARDBOX || this._cardInfo.TemplateID == EquipType.MYSTICAL_CARDBOX))
            {
               this._openBtn.enable = false;
               this._localAutoOpen = SharedManager.Instance.autoOfferPack;
               SocketManager.Instance.out.sendOpenRandomBox(this.getRandomCardPlace(this._cardPlace),1);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noCard"));
            }
         }
      }
      
      private function getCardPlace(place:int) : int
      {
         var info:InventoryItemInfo = null;
         var arr:Array = PlayerManager.Instance.Self.Bag.findCellsByTempleteID(this._cardID);
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
         var arr:Array = PlayerManager.Instance.Self.PropBag.findCellsByTempleteID(this._cardID);
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
            if(!this.mAwardSoul)
            {
               this._selectSprite.visible = true;
               if(Boolean(this._selectCell))
               {
                  this._selectCell.info = this._selectGoodsInfo;
               }
               this.creatTweenSelectMagnify();
            }
            else
            {
               this.mSprite.visible = true;
               if(Boolean(this._selectCell))
               {
                  this._selectCell.info = this._selectGoodsInfo;
               }
               this.createTweenSoulNum();
            }
            this.mAwardSoul = null;
         }
      }
      
      private function createTweenSoulNum() : void
      {
         this.SetSoulNumBmp(this.mAwardSoul.zoneID);
         this.mSprite.x = this.mSpriteX;
         this.mSprite.y = 120;
         this.mSprite.scaleY = 1;
         this.mSprite.scaleX = 1;
         TweenLite.from(this.mSprite,1,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":180,
            "alpha":20,
            "onComplete":this._showOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function _showOk() : void
      {
         if(!this.mSprite)
         {
            return;
         }
         TweenLite.to(this.mSprite,0.3,{
            "scaleX":1.3,
            "scaleY":1.3,
            "repeat":1,
            "yoyo":true
         });
         TweenLite.to(this.mSprite,0.5,{
            "scaleX":0,
            "scaleY":0,
            "x":this.mSpriteX,
            "y":80,
            "ease":Sine.easeIn
         });
         setTimeout(this._toMove,600);
      }
      
      private function SetSoulNumBmp(pSoulNum:int) : void
      {
         var temp:int = 0;
         var tempBmp:Bitmap = null;
         var zeroBmp:Bitmap = null;
         var vLength:int = int(pSoulNum.toString().length);
         var vMax:int = Math.pow(10,vLength - 1);
         while(pSoulNum != 0)
         {
            temp = Math.floor(pSoulNum / vMax);
            tempBmp = ComponentFactory.Instance.creatBitmap("asset.card.soulNum" + temp);
            tempBmp.x = this.mSprite.width;
            this.mSprite.addChild(tempBmp);
            pSoulNum -= temp * vMax;
            if(vMax == 10 && pSoulNum == 0)
            {
               zeroBmp = ComponentFactory.Instance.creatBitmap("asset.card.soulNum0");
               zeroBmp.x = this.mSprite.width;
               this.mSprite.addChild(zeroBmp);
            }
            vMax /= 10;
         }
         var hunStr:Bitmap = ComponentFactory.Instance.creatBitmap("asset.card.soulNum");
         hunStr.x = this.mSprite.width + 2;
         hunStr.y = -1;
         this.mSprite.addChild(hunStr);
         this.mSpriteX = Math.floor((315 - this.mSprite.width) / 2);
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
         this._cardInfo = null;
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
         if(Boolean(this._cardItem))
         {
            ObjectUtils.disposeObject(this._cardItem);
         }
         this._cardItem = null;
         if(Boolean(this._smeltBeadCell))
         {
            ObjectUtils.disposeObject(this._smeltBeadCell);
         }
         this._smeltBeadCell = null;
         if(Boolean(this._cardNumberTxt))
         {
            ObjectUtils.disposeObject(this._cardNumberTxt);
         }
         this._cardNumberTxt = null;
         if(Boolean(_autoCheck))
         {
            ObjectUtils.disposeObject(_autoCheck);
         }
         _autoCheck = null;
         if(Boolean(this.mSprite))
         {
            ObjectUtils.disposeObject(this.mSprite);
         }
         this.mSprite = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

