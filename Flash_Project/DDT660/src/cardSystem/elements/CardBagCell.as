package cardSystem.elements
{
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardBagCell extends CardCell
   {
      
      private var _upGradeBtn:BaseButton;
      
      private var _buttonAndNumBG:Bitmap;
      
      private var _count:FilterFrameText;
      
      private var _timeLine:TimelineMax;
      
      private var _isMouseOver:Boolean;
      
      private var _tween0:TweenLite;
      
      private var _tween1:TweenLite;
      
      private var _tween2:TweenLite;
      
      private var _tween3:TweenLite;
      
      private var _mainCardBaiJin:Bitmap;
      
      private var _mainCardJin:Bitmap;
      
      private var _mainCardYin:Bitmap;
      
      private var _mainCardTong:Bitmap;
      
      private var _mainFont:Bitmap;
      
      private var _deputy:Bitmap;
      
      private var _collectCard:Boolean;
      
      public function CardBagCell(bg:DisplayObject, place:int = -1, $info:CardInfo = null, showLoading:Boolean = false, showTip:Boolean = true)
      {
         super(bg,place,$info,showLoading,showTip);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._mainCardBaiJin = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.baijin");
         this._mainCardJin = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.jin");
         this._mainCardYin = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.yin");
         this._mainCardTong = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.tong");
         this._mainFont = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.mainFont");
         this._deputy = ComponentFactory.Instance.creatBitmap("asset.ddtcardbag.bg");
         this._buttonAndNumBG = ComponentFactory.Instance.creatBitmap("asset.cardBag.cell.buttonbg");
         this._count = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.count");
         addChild(this._buttonAndNumBG);
         addChild(this._count);
         addChild(this._mainCardBaiJin);
         addChild(this._mainCardJin);
         addChild(this._mainCardYin);
         addChild(this._mainCardTong);
         addChild(this._mainFont);
         addChild(this._deputy);
         if(Boolean(_updateBtn))
         {
            _updateBtn.visible = false;
         }
         if(Boolean(_resetGradeBtn))
         {
            PositionUtils.setPos(_resetGradeBtn,"PropResetBtnPos");
            _resetGradeBtn.visible = false;
         }
         if(Boolean(_mainGold))
         {
            _mainGold.visible = false;
         }
         if(Boolean(_mainsilver))
         {
            _mainsilver.visible = false;
         }
         if(Boolean(_maincopper))
         {
            _maincopper.visible = false;
         }
         if(Boolean(_mainWhiteGold))
         {
            _mainWhiteGold.visible = false;
         }
         if(Boolean(_deputyGold))
         {
            _deputyGold.visible = false;
         }
         if(Boolean(_deputysilver))
         {
            _deputysilver.visible = false;
         }
         if(Boolean(_deputycopper))
         {
            _deputycopper.visible = false;
         }
         if(Boolean(_deputyWhiteGold))
         {
            _deputyWhiteGold.visible = false;
         }
         this._mainCardBaiJin.visible = false;
         this._mainCardBaiJin.x = 5;
         this._mainCardBaiJin.y = 75;
         this._mainCardJin.visible = false;
         this._mainCardJin.x = 5;
         this._mainCardJin.y = 75;
         this._mainCardYin.visible = false;
         this._mainCardYin.x = 5;
         this._mainCardYin.y = 75;
         this._mainCardTong.visible = false;
         this._mainCardTong.x = 5;
         this._mainCardTong.y = 75;
         this._mainFont.visible = false;
         this._deputy.visible = false;
         this._count.alpha = 0;
         this._buttonAndNumBG.alpha = 0;
         this._timeLine = new TimelineMax();
         this._timeLine.addEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         this._tween0 = new TweenLite(_starContainer,0.05,{
            "autoAlpha":0,
            "y":"5"
         });
         this._timeLine.append(this._tween0);
         this._tween1 = new TweenLite(this._buttonAndNumBG,0.1,{
            "autoAlpha":1,
            "y":"-5"
         });
         this._timeLine.append(this._tween1);
         this._timeLine.stop();
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         super.onMouseOver(evt);
         if(Boolean(cardInfo) && cardInfo.isFirstGet)
         {
            stopShine();
            if(Boolean(PlayerManager.Instance.Self.cardBagDic[cardInfo.Place]))
            {
               PlayerManager.Instance.Self.cardBagDic[cardInfo.Place].isFirstGet = false;
            }
         }
         if(cardInfo == null)
         {
            if(Boolean(_updateBtn))
            {
               _updateBtn.visible = false;
            }
            if(Boolean(_resetGradeBtn))
            {
               _resetGradeBtn.visible = false;
            }
            return;
         }
         this._isMouseOver = true;
         if(this._collectCard)
         {
            _resetGradeBtn.visible = false;
         }
         if(Boolean(_updateBtn))
         {
            _updateBtn.visible = false;
         }
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         super.onMouseOut(evt);
         if(cardInfo == null)
         {
            return;
         }
         this._isMouseOver = false;
         if(Boolean(_updateBtn))
         {
            _updateBtn.visible = false;
         }
         if(Boolean(_resetGradeBtn))
         {
            _resetGradeBtn.visible = false;
         }
         this.__timelineComplete();
      }
      
      private function __timelineComplete(event:TweenEvent = null) : void
      {
         if(this._timeLine.currentTime < this._timeLine.totalDuration)
         {
            return;
         }
         if(this._isMouseOver || locked)
         {
            return;
         }
         this._timeLine.reverse();
      }
      
      protected function __upGrade(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         CardControl.Instance.showUpGradeFrame(cardInfo);
      }
      
      override public function set cardInfo(value:CardInfo) : void
      {
         var _grooveinfo:GrooveInfo = new GrooveInfo();
         if(super.cardInfo == value && !super.cardInfo)
         {
            return;
         }
         super.cardInfo = value;
         setStar();
         if(Boolean(cardInfo))
         {
            if(cardInfo.isFirstGet && canShine)
            {
               shine();
            }
            else
            {
               stopShine();
            }
            this._count.text = String(cardInfo.Count);
            if(Boolean(this._tween2))
            {
               this._tween2.kill();
               this._timeLine.remove(this._tween2);
            }
            if(cardInfo.Count == 0)
            {
               this._count.visible = false;
            }
            else
            {
               this._count.visible = true;
               this._count.alpha = 0;
               this._tween2 = new TweenLite(this._count,0.05,{"autoAlpha":1});
               this._timeLine.append(this._tween2,-0.1);
            }
            if(Boolean(this._tween3))
            {
               this._tween3.kill();
               this._timeLine.remove(this._tween3);
            }
            if(cardInfo.Level >= EquipType.CardMaxLv)
            {
               if(Boolean(_resetGradeBtn))
               {
                  _resetGradeBtn.visible = false;
               }
               if(Boolean(this._upGradeBtn))
               {
                  this._upGradeBtn.visible = false;
               }
               if(Boolean(_updateBtn))
               {
                  _updateBtn.visible = false;
               }
               if(Boolean(_mainGold))
               {
                  _mainGold.visible = false;
               }
               if(Boolean(_mainsilver))
               {
                  _mainsilver.visible = false;
               }
               if(Boolean(_maincopper))
               {
                  _maincopper.visible = false;
               }
               if(Boolean(_deputyGold))
               {
                  _deputyGold.visible = false;
               }
               if(Boolean(_deputysilver))
               {
                  _deputysilver.visible = false;
               }
               if(Boolean(_deputycopper))
               {
                  _deputycopper.visible = false;
               }
               if(Boolean(_deputyWhiteGold))
               {
                  _deputyWhiteGold.visible = false;
               }
               this._tween3 = new TweenLite(_resetGradeBtn,0.05,{"alpha":1});
               this._timeLine.append(this._tween3,-0.15);
               tipStyle = "core.CardsTip";
            }
            else
            {
               if(this._upGradeBtn == null)
               {
                  this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.upGradeBtn");
                  addChild(this._upGradeBtn);
                  this._upGradeBtn.alpha = 0;
                  this._upGradeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__upGrade);
               }
               this._upGradeBtn.visible = false;
               this._upGradeBtn.alpha = 0;
               if(Boolean(_resetGradeBtn))
               {
                  _resetGradeBtn.visible = false;
               }
               if(Boolean(_updateBtn))
               {
                  _updateBtn.visible = false;
               }
               if(Boolean(_mainGold))
               {
                  _mainGold.visible = false;
               }
               if(Boolean(_mainsilver))
               {
                  _mainsilver.visible = false;
               }
               if(Boolean(_maincopper))
               {
                  _maincopper.visible = false;
               }
               if(Boolean(_deputyGold))
               {
                  _deputyGold.visible = false;
               }
               if(Boolean(_deputysilver))
               {
                  _deputysilver.visible = false;
               }
               if(Boolean(_deputycopper))
               {
                  _deputycopper.visible = false;
               }
               if(Boolean(_deputyWhiteGold))
               {
                  _deputyWhiteGold.visible = false;
               }
               this._tween3 = new TweenLite(this._upGradeBtn,0.05,{"alpha":1});
               this._timeLine.append(this._tween3,-0.15);
            }
            if(CardControl.Instance.signLockedCard == cardInfo.TemplateID)
            {
               this.locked = true;
            }
            if(cardInfo.templateInfo.Property8 == "1")
            {
               this._mainFont.visible = true;
               this._deputy.visible = false;
            }
            else
            {
               this._mainFont.visible = false;
               this._deputy.visible = true;
            }
            if(cardInfo.CardType == 1)
            {
               this._mainCardJin.visible = true;
            }
            else
            {
               this._mainCardJin.visible = false;
            }
            if(cardInfo.CardType == 2)
            {
               this._mainCardYin.visible = true;
            }
            else
            {
               this._mainCardYin.visible = false;
            }
            if(cardInfo.CardType == 3)
            {
               this._mainCardTong.visible = true;
            }
            else
            {
               this._mainCardTong.visible = false;
            }
            if(cardInfo.CardType == 4)
            {
               this._mainCardBaiJin.visible = true;
            }
            else
            {
               this._mainCardBaiJin.visible = false;
            }
         }
         else
         {
            super.info = null;
            tipData = null;
            stopShine();
            this._count.text = "";
            this._timeLine.restart();
            this._timeLine.stop();
            _starContainer.visible = false;
            this._mainCardBaiJin.visible = false;
            this._mainCardJin.visible = false;
            this._mainCardYin.visible = false;
            this._mainCardTong.visible = false;
            this._mainFont.visible = false;
            if(Boolean(this._upGradeBtn))
            {
               this._upGradeBtn.visible = false;
            }
            if(Boolean(_updateBtn))
            {
               _updateBtn.visible = false;
            }
            if(Boolean(_mainGold))
            {
               _mainGold.visible = false;
            }
            if(Boolean(_mainsilver))
            {
               _mainsilver.visible = false;
            }
            if(Boolean(_maincopper))
            {
               _maincopper.visible = false;
            }
            if(Boolean(_deputyGold))
            {
               _deputyGold.visible = false;
            }
            if(Boolean(_deputysilver))
            {
               _deputysilver.visible = false;
            }
            if(Boolean(_deputycopper))
            {
               _deputycopper.visible = false;
            }
            if(Boolean(_deputyWhiteGold))
            {
               _deputyWhiteGold.visible = false;
            }
            if(Boolean(_resetGradeBtn))
            {
               _resetGradeBtn.visible = false;
            }
            this._count.visible = false;
            this._buttonAndNumBG.visible = false;
         }
      }
      
      override public function get width() : Number
      {
         return _bg.width;
      }
      
      override public function get height() : Number
      {
         return _bg.height;
      }
      
      public function get collectCard() : Boolean
      {
         return this._collectCard;
      }
      
      public function set collectCard(value:Boolean) : void
      {
         this._collectCard = value;
      }
      
      override public function dispose() : void
      {
         this._timeLine.removeEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         if(Boolean(this._upGradeBtn))
         {
            this._upGradeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__upGrade);
         }
         ObjectUtils.disposeObject(this._upGradeBtn);
         this._upGradeBtn = null;
         ObjectUtils.disposeObject(this._mainCardBaiJin);
         this._mainCardBaiJin = null;
         ObjectUtils.disposeObject(this._mainCardJin);
         this._mainCardJin = null;
         ObjectUtils.disposeObject(this._mainCardTong);
         this._mainCardTong = null;
         ObjectUtils.disposeObject(this._mainCardYin);
         this._mainCardYin = null;
         ObjectUtils.disposeObject(this._mainFont);
         this._mainFont = null;
         ObjectUtils.disposeObject(this._mainFont);
         this._mainFont = null;
         this._timeLine.kill();
         this._timeLine = null;
         ObjectUtils.disposeAllChildren(this);
         this._count = null;
         this._buttonAndNumBG = null;
         super.dispose();
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.height = _contentHeight;
            sp.width = _contentWidth;
            sp.x = (_bg.width - _contentWidth) / 2;
            sp.y = (_bg.height - _contentHeight) / 2;
         }
      }
      
      override protected function createContentComplete() : void
      {
         clearLoading();
         this.updateSize(_pic);
      }
      
      override public function set locked(value:Boolean) : void
      {
         super.locked = value;
         if(value == true)
         {
            this._timeLine.restart();
            this._timeLine.stop();
         }
      }
   }
}

