package cardSystem.elements
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.view.CardInputFrame;
   import com.greensock.TweenMax;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardCell extends BaseCell
   {
      
      private var _open:Boolean;
      
      private var isVible:Boolean = true;
      
      private var _cardInfo:CardInfo;
      
      private var _playerInfo:PlayerInfo;
      
      private var _place:int;
      
      private var _cardID:int;
      
      protected var _starContainer:Sprite;
      
      protected var _levelBG:Bitmap;
      
      protected var _level:FilterFrameText;
      
      private var _starVisible:Boolean = true;
      
      private var _cardName:FilterFrameText;
      
      private var _shine:IEffect;
      
      protected var _isShine:Boolean;
      
      private var _canShine:Boolean;
      
      protected var _updateBtn:TextButton;
      
      protected var _resetGradeBtn:TextButton;
      
      protected var _mainWhiteGold:Bitmap;
      
      protected var _mainGold:Bitmap;
      
      protected var _mainsilver:Bitmap;
      
      protected var _maincopper:Bitmap;
      
      protected var _deputyWhiteGold:Bitmap;
      
      protected var _deputyGold:Bitmap;
      
      protected var _deputysilver:Bitmap;
      
      protected var _deputycopper:Bitmap;
      
      private var _tweenMax:TweenMax;
      
      public function CardCell(bg:DisplayObject, place:int = -1, $info:CardInfo = null, showLoading:Boolean = false, showTip:Boolean = true)
      {
         this._place = place;
         super(bg,this._cardInfo == null ? null : ItemManager.Instance.getTemplateById(this._cardInfo.TemplateID),showLoading,showTip);
         this.open = true;
         this.cardInfo = $info;
         this.setStar();
      }
      
      public function set canShine(value:Boolean) : void
      {
         this._canShine = value;
      }
      
      public function get canShine() : Boolean
      {
         return this._canShine;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         this._playerInfo = value;
      }
      
      public function showCardName(name:String) : void
      {
         if(this._cardName == null)
         {
            this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.name");
            addChild(this._cardName);
         }
         this._cardName.text = name;
         this._cardName.y = _bg.height / 2 - this._cardName.textHeight / 2;
      }
      
      public function set cardID(value:int) : void
      {
         if(this._cardID == value)
         {
            return;
         }
         this._cardID = value;
      }
      
      public function get cardID() : int
      {
         return this._cardID;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createStar();
      }
      
      public function shine() : void
      {
         if(this._tweenMax != null)
         {
            TweenMax.killTweensOf(this);
            this._tweenMax.kill();
            this._tweenMax = null;
            filters = null;
            if(this.open)
            {
               this.open = true;
            }
            else
            {
               this.open = false;
            }
         }
         this._tweenMax = TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3
            }
         });
      }
      
      public function stopShine() : void
      {
         TweenMax.killTweensOf(this);
         filters = null;
         if(this.open)
         {
            this.open = true;
         }
         else
         {
            this.open = false;
         }
      }
      
      protected function createStar() : void
      {
         this._starContainer = new Sprite();
         addChild(this._starContainer);
         this._mainWhiteGold = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.mainwhitegold");
         addChild(this._mainWhiteGold);
         this._mainGold = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.maingold");
         addChild(this._mainGold);
         this._mainsilver = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.mainsilver");
         addChild(this._mainsilver);
         this._maincopper = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.maincopper");
         addChild(this._maincopper);
         this._mainWhiteGold.visible = this._mainGold.visible = this._mainsilver.visible = this._maincopper.visible = false;
         this._mainGold.x = this._mainsilver.x = this._maincopper.x = 0;
         this._mainGold.y = this._mainsilver.y = this._maincopper.y = -3;
         this._mainWhiteGold.x = 2;
         this._mainWhiteGold.y = 5;
         this._deputyWhiteGold = ComponentFactory.Instance.creatBitmap("asset.cardSystem.deputywhitegold");
         this._deputyWhiteGold.x = 1;
         this._deputyWhiteGold.y = 10;
         addChild(this._deputyWhiteGold);
         this._deputyGold = ComponentFactory.Instance.creatBitmap("asset.cardSystem.deputygold");
         addChild(this._deputyGold);
         this._deputysilver = ComponentFactory.Instance.creatBitmap("asset.cardSystem.deputysilver");
         addChild(this._deputysilver);
         this._deputycopper = ComponentFactory.Instance.creatBitmap("asset.cardSystem.deputycopple");
         addChild(this._deputycopper);
         this._deputyWhiteGold.visible = this._deputyGold.visible = this._deputysilver.visible = this._deputycopper.visible = false;
         this._updateBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcard.BtnUpdate");
         this._updateBtn.text = LanguageMgr.GetTranslation("tank.view.card.Grooveupdate");
         PositionUtils.setPos(this._updateBtn,"cardSystem.UpdateBtn.pos");
         addChild(this._updateBtn);
         this._updateBtn.addEventListener(MouseEvent.MOUSE_DOWN,this._UpdateHandler);
         this._resetGradeBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.propReset");
         this._resetGradeBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.reset");
         this._resetGradeBtn.x = this._updateBtn.x - 47;
         this._resetGradeBtn.y = this._updateBtn.y;
         addChild(this._resetGradeBtn);
         this._resetGradeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__propReset);
         if(this._place != 0)
         {
            this._levelBG = ComponentFactory.Instance.creatBitmap("asset.cardBag.cell.smalllevelbg");
            this._level = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.small");
            PositionUtils.setPos(this._level,"cardSystem.level.small.pos");
            this._starContainer.x = _bg.width - this._levelBG.width - 3;
            this._starContainer.y = _bg.height - this._levelBG.height - 3;
         }
         else
         {
            this._levelBG = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.cell.levelBg");
            this._level = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
            PositionUtils.setPos(this._level,"cardSystem.level.big.pos");
            PositionUtils.setPos(this._updateBtn,"cardSystem.UpdateBtnOne.pos");
            this._resetGradeBtn.x = this._updateBtn.x - 61;
            this._resetGradeBtn.y = this._updateBtn.y;
            this._starContainer.x = _bg.width - this._levelBG.width + 13;
            this._starContainer.y = _bg.height - this._levelBG.height - 4;
         }
      }
      
      private function _UpdateHandler(event:MouseEvent) : void
      {
         var alert1:CardInputFrame = null;
         event.stopImmediatePropagation();
         if(event.currentTarget is BaseButton)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(CardControl.Instance.model.GrooveInfoVector[this._place].Level == 40)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HightLevel"));
               return;
            }
            alert1 = ComponentFactory.Instance.creatComponentByStylename("cardSystem.CardInputFrame");
            LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.place = this._place;
            event.stopPropagation();
         }
      }
      
      protected function __propReset(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         CardControl.Instance.showPropResetFrame(this.cardInfo);
      }
      
      public function setStarPos(posX:int, posY:int) : void
      {
         this._starContainer.x = posX;
         this._starContainer.y = posY;
      }
      
      public function set cardInfo(value:CardInfo) : void
      {
         var _grooveinfo:GrooveInfo = new GrooveInfo();
         this._cardInfo = value;
         if(this._cardInfo == null)
         {
            super.info = null;
            if(Boolean(this._cardName))
            {
               this._cardName.visible = true;
            }
            this._mainWhiteGold.visible = this._mainGold.visible = this._mainsilver.visible = this._maincopper.visible = false;
            this._deputyWhiteGold.visible = this._deputyGold.visible = this._deputysilver.visible = this._deputycopper.visible = false;
            ShowTipManager.Instance.removeAllTip();
            _tipData = this._place;
            tipStyle = "core.CardsTip";
         }
         else
         {
            super.info = this._cardInfo.templateInfo;
            if(this._cardInfo.TemplateID > 0)
            {
               _pic.parent.setChildIndex(_pic,1);
            }
            if(Boolean(this._cardName))
            {
               this._cardName.visible = false;
            }
            if(this._cardInfo.CardType == 1 && this._cardInfo.Place == 0)
            {
               this._mainGold.visible = true;
               this._maincopper.visible = false;
               this._mainsilver.visible = false;
               this._mainWhiteGold.visible = false;
            }
            else if(this._cardInfo.CardType == 2 && this._cardInfo.Place == 0)
            {
               this._mainsilver.visible = true;
               this._maincopper.visible = false;
               this._mainGold.visible = false;
               this._mainWhiteGold.visible = false;
            }
            else if(this._cardInfo.CardType == 3 && this._cardInfo.Place == 0)
            {
               this._maincopper.visible = true;
               this._mainGold.visible = false;
               this._mainsilver.visible = false;
               this._mainWhiteGold.visible = false;
            }
            if(this._cardInfo.CardType == 4 && this._cardInfo.Place == 0)
            {
               this._mainGold.visible = false;
               this._maincopper.visible = false;
               this._mainsilver.visible = false;
               this._mainWhiteGold.visible = true;
            }
            else if(this._cardInfo.CardType == 1 && this._cardInfo.Place != 0)
            {
               this._deputyGold.visible = true;
               this._deputycopper.visible = false;
               this._deputysilver.visible = false;
               this._deputyWhiteGold.visible = false;
            }
            else if(this._cardInfo.CardType == 2 && this._cardInfo.Place != 0)
            {
               this._deputysilver.visible = true;
               this._deputycopper.visible = false;
               this._deputyGold.visible = false;
               this._deputyWhiteGold.visible = false;
            }
            else if(this._cardInfo.CardType == 3 && this._cardInfo.Place != 0)
            {
               this._deputycopper.visible = true;
               this._deputysilver.visible = false;
               this._deputyGold.visible = false;
               this._deputyWhiteGold.visible = false;
            }
            else if(this._cardInfo.CardType == 4 && this._cardInfo.Place != 0)
            {
               this._deputyGold.visible = false;
               this._deputycopper.visible = false;
               this._deputysilver.visible = false;
               this._deputyWhiteGold.visible = true;
            }
            else
            {
               this._mainWhiteGold.visible = this._mainGold.visible = this._mainsilver.visible = this._maincopper.visible = false;
               this._deputyWhiteGold.visible = this._deputyGold.visible = this._deputysilver.visible = this._deputycopper.visible = false;
            }
            tipData = value;
            ShowTipManager.Instance.removeAllTip();
            tipStyle = "core.EquipmentCardsTips";
         }
         ShowTipManager.Instance.removeAllTip();
         this.setStar();
      }
      
      public function get cardInfo() : CardInfo
      {
         return this._cardInfo;
      }
      
      public function set updatebtnVible(value:Boolean) : void
      {
         this.isVible = value;
      }
      
      public function get updatebtnVible() : Boolean
      {
         return this.isVible;
      }
      
      protected function setStar() : void
      {
         if(this.cardInfo == null)
         {
            this._starContainer.visible = false;
            this._updateBtn.visible = false;
            this._resetGradeBtn.visible = false;
         }
         else
         {
            if(this._starVisible)
            {
               this._starContainer.visible = true;
            }
            this._level.text = this._cardInfo.Level < 10 ? "0" + this._cardInfo.Level : this._cardInfo.Level.toString();
         }
      }
      
      public function set starVisible(value:Boolean) : void
      {
         this._starVisible = value;
         this._starContainer.visible = value;
      }
      
      public function set Visibles(value:Boolean) : void
      {
         this._mainWhiteGold.visible = value;
         this._mainGold.visible = value;
         this._mainsilver.visible = value;
         this._maincopper.visible = value;
         this._deputyGold.visible = value;
         this._deputysilver.visible = value;
         this._deputycopper.visible = value;
         this._deputyWhiteGold.visible = value;
      }
      
      public function set open(value:Boolean) : void
      {
         this._open = value;
         if(value)
         {
            filters = null;
            mouseEnabled = true;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
            mouseEnabled = false;
         }
      }
      
      public function get open() : Boolean
      {
         return this._open;
      }
      
      public function set place(value:int) : void
      {
         if(this._place == value)
         {
            return;
         }
         this._place = value;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      override public function dragStart() : void
      {
         if(this._cardInfo && !locked && stage && allowDrag)
         {
            if(DragManager.startDrag(this,this._cardInfo,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,false,true))
            {
               locked = true;
               CardControl.Instance.signLockedCard = this.cardInfo.TemplateID;
            }
         }
         if(Boolean(_info) && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.cardInfo,true));
         }
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var cInfo:CardInfo = null;
         if(effect.data is CardInfo)
         {
            cInfo = effect.data as CardInfo;
            if(locked)
            {
               if(cInfo == this.cardInfo)
               {
                  locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(this._place != -1)
               {
                  if(!this.open)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.notOpen"));
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._place == 0 && cInfo.templateInfo.Property8 == "0")
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.cannotMoveCardMain"));
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._place <= 4 && this._place > 0 && cInfo.templateInfo.Property8 == "1")
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.cannotMoveCardOther"));
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._place > 4 && cInfo.Place < 5)
                  {
                     SocketManager.Instance.out.sendMoveCards(cInfo.Place,cInfo.Place);
                     effect.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveCards(cInfo.Place,this._place);
                     effect.action = DragEffect.NONE;
                  }
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         effect.action = DragEffect.NONE;
         locked = false;
      }
      
      override public function dispose() : void
      {
         TweenMax.killTweensOf(this);
         this._cardInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._starContainer = null;
         this._levelBG = null;
         this._cardName = null;
         this._updateBtn = null;
         this._resetGradeBtn = null;
         removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.height = _contentHeight;
            sp.width = _contentWidth;
            sp.x = (_bg.width - _contentWidth) / 2;
            sp.y = (_bg.height - _contentHeight) / 2 - 7;
         }
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         if(this.open && !locked)
         {
            this.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         if(this.cardInfo == null)
         {
            if(Boolean(this._updateBtn) && Boolean(this._resetGradeBtn))
            {
               if(CardControl.Instance.model.PlayerId == PlayerManager.Instance.Self.ID && this.isVible)
               {
                  this._updateBtn.visible = true;
                  this._resetGradeBtn.visible = false;
               }
               else
               {
                  this._updateBtn.visible = false;
                  this._resetGradeBtn.visible = false;
               }
            }
         }
         else if(Boolean(this._updateBtn) && Boolean(this._resetGradeBtn))
         {
            if(CardControl.Instance.model.PlayerId == PlayerManager.Instance.Self.ID && this.isVible)
            {
               this._updateBtn.visible = true;
               this._resetGradeBtn.visible = true;
            }
            else
            {
               this._updateBtn.visible = false;
               this._resetGradeBtn.visible = false;
            }
         }
      }
      
      public function setBtnVisible(value:Boolean) : Boolean
      {
         return this._updateBtn.visible = value;
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         if(Boolean(this._updateBtn))
         {
            this._updateBtn.visible = false;
         }
         if(Boolean(this._resetGradeBtn))
         {
            this._resetGradeBtn.visible = false;
         }
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         if(this.open && !locked)
         {
            this.filters = null;
         }
         if(Boolean(this._updateBtn))
         {
            this._updateBtn.visible = false;
         }
         if(Boolean(this._resetGradeBtn))
         {
            this._resetGradeBtn.visible = false;
         }
      }
      
      override protected function createDragImg() : DisplayObject
      {
         var img:Bitmap = null;
         if(_pic && _pic.width > 0 && _pic.height > 0)
         {
            img = new Bitmap(new BitmapData(_pic.width / _pic.scaleX,_pic.height / _pic.scaleY,true,0),"auto",true);
            img.bitmapData.draw(_pic);
            img.width = 103;
            img.height = 144;
            return img;
         }
         return null;
      }
   }
}

