package cardSystem.view.cardEquip
{
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.elements.CardCell;
   import cardSystem.view.CardPropress;
   import cardSystem.view.CardSelect;
   import cardSystem.view.CardSmallPropress;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class CardEquipView extends Sprite implements Disposeable
   {
      
      private var _background:Bitmap;
      
      private var _background1:ScaleBitmapImage;
      
      private var _title:Bitmap;
      
      public var _equipCells:Vector.<CardCell>;
      
      private var _playerInfo:PlayerInfo;
      
      private var _viceCardBit:Vector.<Bitmap>;
      
      private var _mainCardBit:Bitmap;
      
      private var _clickEnable:Boolean = true;
      
      private var _cell3MouseSprite:Sprite;
      
      private var _cell4MouseSprite:Sprite;
      
      private var _open3Btn:TextButton;
      
      private var _open4Btn:TextButton;
      
      private var _dragArea:CardEquipDragArea;
      
      private var _collectBtn:TextButton;
      
      private var _resetSoulBtn:TextButton;
      
      private var _cardBtn:TextButton;
      
      private var _buyCardBoxBtn:TextButton;
      
      private var _cardList:CardSelect;
      
      private var _attackBg:Bitmap;
      
      private var _agilityBg:Bitmap;
      
      private var _defenceBg:Bitmap;
      
      private var _luckBg:Bitmap;
      
      private var _background2:MovieImage;
      
      private var _line:MovieImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textBg1:Scale9CornerImage;
      
      private var _textBg2:Scale9CornerImage;
      
      private var _textBg3:Scale9CornerImage;
      
      private var _levelPorgress:CardPropress;
      
      private var _levelPorgress1:CardSmallPropress;
      
      private var _levelPorgress2:CardSmallPropress;
      
      private var _levelPorgress3:CardSmallPropress;
      
      private var _levelPorgress4:CardSmallPropress;
      
      private var _CardGrove:GrooveInfo;
      
      private var _HunzhiBg:Bitmap;
      
      private var _ballPlay:MovieClip;
      
      private var _ballPlaySp:Component;
      
      private var _ballPlaySpTip:OneLineTip;
      
      private var _ballPlayCountTxt:FilterFrameText;
      
      private var _levelTxt1:FilterFrameText;
      
      private var _levelTxt2:FilterFrameText;
      
      private var _levelTxt3:FilterFrameText;
      
      private var _levelTxt4:FilterFrameText;
      
      private var _levelTxt5:FilterFrameText;
      
      private var _levelNumTxt1:FilterFrameText;
      
      private var _levelNumTxt2:FilterFrameText;
      
      private var _levelNumTxt3:FilterFrameText;
      
      private var _levelNumTxt4:FilterFrameText;
      
      private var _levelNumTxt5:FilterFrameText;
      
      private var _GrooveTxt:FilterFrameText;
      
      private var _btnHelp:BaseButton;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      private var _show3:Boolean;
      
      private var _resetAlert:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      private var _openFrame:BaseAlerFrame;
      
      private var _configFrame:BaseAlerFrame;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      public function CardEquipView()
      {
         super();
         this.initView();
         this.cardGuide();
      }
      
      public function set clickEnable(value:Boolean) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(this._clickEnable == value)
         {
            return;
         }
         this._clickEnable = value;
         if(this._clickEnable)
         {
            for(i = 0; i < 5; i++)
            {
               if(Boolean(this._equipCells[i]))
               {
                  this._equipCells[i].addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[i].addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
                  this._equipCells[j].setBtnVisible(true);
               }
            }
            if(this._equipCells[3].open)
            {
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(this._equipCells[4].open)
            {
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         else
         {
            for(j = 0; j < 5; j++)
            {
               if(Boolean(this._equipCells[j]))
               {
                  this._equipCells[j].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[j].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               }
            }
            if(!this._equipCells[3].open)
            {
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(!this._equipCells[4].open)
            {
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         this._collectBtn.visible = false;
         this._resetSoulBtn.visible = false;
         this._cardBtn.visible = false;
         this._ballPlaySp.visible = false;
         this._GrooveTxt.visible = false;
         this._HunzhiBg.visible = false;
         this._buyCardBoxBtn.visible = false;
         this.setCardsVisible(false);
      }
      
      private function cardGuide() : void
      {
         var data:DictionaryData = null;
         if(Boolean(this.playerInfo) && this.playerInfo.ID != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.CARD_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 14 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(25)))
            {
               data = PlayerManager.Instance.Self.cardBagDic;
               if(data.length > 0)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,0,new Point(486,-107),"asset.trainer.txtCardGuide2","guide.card.txtPos2",this);
                  PlayerManager.Instance.Self.cardEquipDic.addEventListener(DictionaryEvent.ADD,this.cardGuideComplete);
               }
            }
         }
      }
      
      private function cardGuideComplete(event:DictionaryEvent) : void
      {
         PlayerManager.Instance.Self.cardEquipDic.removeEventListener(DictionaryEvent.ADD,this.cardGuideComplete);
         NewHandContainer.Instance.clearArrowByID(ArrowType.CARD_GUIDE);
         SocketManager.Instance.out.syncWeakStep(Step.CARD_GUIDE);
      }
      
      private function createQuickBuyFrame() : void
      {
         this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quickBuyFrame.itemID = EquipType.MYSTICAL_CARDBOX;
         this._quickBuyFrame.buyFrom = 0;
      }
      
      private function initView() : void
      {
         var cell:CardCell = null;
         this._equipCells = new Vector.<CardCell>(5);
         this._CardGrove = new GrooveInfo();
         this._background = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.BG");
         this._background1 = ComponentFactory.Instance.creatComponentByStylename("cardEquipView.BG1");
         this._background2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.view.bgTwo");
         this._line = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.line");
         this._dragArea = new CardEquipDragArea(this);
         this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.collectBtn");
         this._collectBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsRecordText");
         this._resetSoulBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.resetSoulBtn");
         this._resetSoulBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.resetCardSoul");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.CardBtn");
         this._cardBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardsText");
         this._buyCardBoxBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.BuyCardBoxBtn");
         this._buyCardBoxBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.BuyCardBox");
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView1");
         this._textBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView2");
         this._textBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView3");
         this._textBg3 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView4");
         this._attackBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.gongji");
         this._agilityBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.minjie");
         this._defenceBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.fangyu");
         this._luckBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.luck");
         this._HunzhiBg = ComponentFactory.Instance.creatBitmap("asset.ddtcardsytems.hunzhi");
         this._levelTxt1 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText1");
         this._levelTxt2 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText2");
         this._levelTxt3 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText3");
         this._levelTxt4 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText4");
         this._levelTxt5 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText5");
         this._levelNumTxt1 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText1");
         this._levelNumTxt2 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText2");
         this._levelNumTxt3 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText3");
         this._levelNumTxt4 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText4");
         this._levelNumTxt5 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText5");
         this.__onUpdateProperty(null);
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdateProperty);
         this._GrooveTxt = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.GrooveText");
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._btnHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.texpSystem.btnHelp");
         this._btnHelp.x = 740;
         this._btnHelp.y = -123;
         addChild(this._btnHelp);
         this._levelTxt1.text = this._levelTxt2.text = this._levelTxt3.text = this._levelTxt4.text = this._levelTxt5.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText");
         this._levelNumTxt1.text = this._levelNumTxt2.text = this._levelNumTxt3.text = this._levelNumTxt4.text = this._levelNumTxt5.text = "0";
         if(!this._ballPlay)
         {
            this._ballPlay = ComponentFactory.Instance.creat("asset.cardSystem.ballPlay");
         }
         this._ballPlayCountTxt = ComponentFactory.Instance.creatComponentByStylename("cardSystem.ballPlayCountTxt");
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
         this._ballPlaySp = new Component();
         this._ballPlaySpTip = new OneLineTip();
         PositionUtils.setPos(this._ballPlaySpTip,"cardSystem.ballPlaySpTipPos");
         this._ballPlaySpTip.tipData = LanguageMgr.GetTranslation("ddt.cardSystem.buyCardSoulButtonTipsMsg");
         this._ballPlaySp.buttonMode = true;
         this._ballPlaySp.addEventListener(MouseEvent.ROLL_OVER,this.__ballPlaySpMouseOver);
         this._ballPlaySp.addEventListener(MouseEvent.ROLL_OUT,this.__ballPlaySpMouseOut);
         this._ballPlaySp.addChild(this._ballPlay);
         this._ballPlaySp.addChild(this._ballPlayCountTxt);
         this._HunzhiBg.x = 109;
         this._HunzhiBg.y = 175;
         this._attackBg.x = -9;
         this._attackBg.y = 315;
         this._agilityBg.x = 104;
         this._agilityBg.y = 315;
         this._defenceBg.x = -9;
         this._defenceBg.y = 340;
         this._luckBg.x = 104;
         this._luckBg.y = 343;
         addChild(this._background);
         addChild(this._background1);
         addChild(this._background2);
         addChild(this._line);
         addChild(this._dragArea);
         addChild(this._collectBtn);
         addChild(this._resetSoulBtn);
         addChild(this._cardBtn);
         addChild(this._buyCardBoxBtn);
         addChild(this._textBg);
         addChild(this._textBg1);
         addChild(this._textBg2);
         addChild(this._textBg3);
         addChild(this._attackBg);
         addChild(this._agilityBg);
         addChild(this._defenceBg);
         addChild(this._luckBg);
         addChild(this._HunzhiBg);
         this._cardList = new CardSelect();
         for(var i:int = 0; i < 5; i++)
         {
            if(i == 0)
            {
               cell = new CardCell(ComponentFactory.Instance.creatBitmap("asset.cardEquipView.mainCard"),i);
               cell.setContentSize(110,155);
               cell.setStarPos(59,154);
               this._levelPorgress = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress");
            }
            else
            {
               cell = new CardCell(ComponentFactory.Instance.creatComponentByStylename("CardEquipView.viceCardBG" + i),i);
               cell.setContentSize(94,133);
               this._levelPorgress1 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress1");
               this._levelPorgress2 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress2");
               this._levelPorgress3 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress3");
               this._levelPorgress4 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress4");
            }
            if(this._clickEnable)
            {
               cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            }
            cell.addEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            cell.addEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            this._equipCells[i] = cell;
            addChild(cell);
         }
         this._viceCardBit = new Vector.<Bitmap>(4);
         for(var j:int = 0; j < 4; j++)
         {
            this._viceCardBit[j] = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.viceCardBG");
         }
         this._mainCardBit = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.mainCardBorder");
         this.setCellPos();
         addChild(this._levelPorgress);
         addChild(this._levelPorgress1);
         addChild(this._levelPorgress2);
         addChild(this._levelPorgress3);
         addChild(this._levelPorgress4);
         addChild(this._levelTxt1);
         addChild(this._levelTxt2);
         addChild(this._levelTxt3);
         addChild(this._levelTxt4);
         addChild(this._levelTxt5);
         addChild(this._levelNumTxt1);
         addChild(this._levelNumTxt2);
         addChild(this._levelNumTxt3);
         addChild(this._levelNumTxt4);
         addChild(this._levelNumTxt5);
         addChild(this._GrooveTxt);
         addChild(this._ballPlaySp);
         this._ballPlaySp.x = 160;
         this._ballPlaySp.y = 162;
         addChild(this._ballPlaySpTip);
         this.isBallPlaySpTip();
      }
      
      private function setCardsVisible(bool:Boolean) : void
      {
         var card:CardCell = null;
         for each(card in this._equipCells)
         {
            if(Boolean(card))
            {
               card.updatebtnVible = bool;
            }
         }
      }
      
      protected function __onUpdateProperty(event:Event) : void
      {
         var _info:PlayerInfo = this._playerInfo;
         if(this._playerInfo == null || _info.propertyAddition == null)
         {
            return;
         }
      }
      
      private function createSprite(obj:CardCell) : Sprite
      {
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,obj.width,obj.height);
         s.graphics.endFill();
         s.x = obj.x;
         s.y = obj.y;
         s.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
         s.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
         return s;
      }
      
      private function removeSprite(s:Sprite, openBtn:BaseButton) : void
      {
         if(Boolean(s))
         {
            s.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
            s.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            openBtn.removeEventListener(MouseEvent.CLICK,this._openHandler);
            ObjectUtils.disposeObject(s);
            ObjectUtils.disposeObject(openBtn);
         }
         s = null;
         openBtn = null;
      }
      
      private function __showOpenBtn(event:MouseEvent) : void
      {
         var s:Sprite = event.currentTarget as Sprite;
         if(s == this._cell3MouseSprite)
         {
            this._show3 = true;
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
         else
         {
            this._show3 = false;
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
      }
      
      private function __hideOpenBtn(event:MouseEvent) : void
      {
         if(this._show3)
         {
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
         else
         {
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
      }
      
      public function shineMain() : void
      {
         this._equipCells[0].shine();
      }
      
      public function shineVice() : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            if(this._equipCells[i].open)
            {
               this._equipCells[i].shine();
            }
         }
      }
      
      public function stopShine() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            this._equipCells[i].stopShine();
         }
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         if(this._playerInfo == value)
         {
            return;
         }
         this._playerInfo = value;
         this.initEvent();
         this.setCellsData();
         this.__onUpdateProperty(null);
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      private function setCellsData() : void
      {
         var cardInfo:CardInfo = null;
         for each(cardInfo in this.playerInfo.cardEquipDic)
         {
            if(cardInfo.Count <= -1)
            {
               this._equipCells[cardInfo.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[cardInfo.Place].cardInfo = cardInfo;
            }
         }
      }
      
      private function setCellPos() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            PositionUtils.setPos(this._equipCells[i],"CardCell.Pos" + i);
         }
         for(var j:int = 0; j < 4; j++)
         {
            PositionUtils.setPos(this._viceCardBit[j],"CardCell.viceBorder.Pos" + j);
         }
         PositionUtils.setPos(this._mainCardBit,"CardCell.mainBorder.Pos");
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_CARD,this.__GetCard);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeSoul);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._resetSoulBtn.addEventListener(MouseEvent.CLICK,this.__resetSoulHandler);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__cardHandler);
         this._buyCardBoxBtn.addEventListener(MouseEvent.CLICK,this.__buyCardBoxHandler);
         this._btnHelp.addEventListener(MouseEvent.CLICK,this.__helpClick);
         this._ballPlaySp.addEventListener(MouseEvent.CLICK,this.__ballPlaySpClickHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
      }
      
      protected function __buyCardBoxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.createQuickBuyFrame();
         LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __changeSoul(event:PlayerPropertyEvent) : void
      {
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
         this.isBallPlaySpTip();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_CARD,this.__GetCard);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeSoul);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._resetSoulBtn.removeEventListener(MouseEvent.CLICK,this.__resetSoulHandler);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__cardHandler);
         this._buyCardBoxBtn.removeEventListener(MouseEvent.CLICK,this.__buyCardBoxHandler);
         this._btnHelp.removeEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      private function __GetCard(event:CrazyTankSocketEvent) : void
      {
         var Grooveinfo:GrooveInfo = null;
         var cardInfo:CardGrooveInfo = null;
         var cardInfo1:CardGrooveInfo = null;
         var current:int = 0;
         var difference:int = 0;
         var pkg:PackageIn = event.pkg;
         CardControl.Instance.model.PlayerId = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var num:int = pkg.readInt();
         var len:int = pkg.readInt();
         var grooveInfos:Vector.<GrooveInfo> = null;
         if(Boolean(CardControl.Instance.model.GrooveInfoVector))
         {
            grooveInfos = CardControl.Instance.model.GrooveInfoVector;
         }
         else
         {
            grooveInfos = new Vector.<GrooveInfo>(5);
         }
         for(var i:int = 0; i < len; i++)
         {
            Grooveinfo = new GrooveInfo();
            Grooveinfo.Place = pkg.readInt();
            Grooveinfo.Type = pkg.readInt();
            Grooveinfo.Level = pkg.readInt();
            Grooveinfo.GP = pkg.readInt();
            cardInfo = GrooveInfoManager.instance.getInfoByLevel(String(Grooveinfo.Level),String(Grooveinfo.Type));
            cardInfo1 = GrooveInfoManager.instance.getInfoByLevel(String(Grooveinfo.Level + 1),String(Grooveinfo.Type));
            if(len == 1)
            {
               if(Grooveinfo.Level > grooveInfos[Grooveinfo.Place].Level)
               {
                  if(Grooveinfo.Place == 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.MainUpdateCard",String(Grooveinfo.Level)));
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.UpdateCard",String(Grooveinfo.Place),String(Grooveinfo.Level)));
                  }
               }
            }
            if(Grooveinfo.Level == 40)
            {
               if(Grooveinfo.Place == 0)
               {
                  this._levelNumTxt1.text = Grooveinfo.Level.toString();
                  this._levelPorgress.setProgress(0,0);
                  this._levelPorgress.labelText = "0%";
                  grooveInfos[0] = Grooveinfo;
               }
               else if(Grooveinfo.Place == 1)
               {
                  this._levelNumTxt2.text = Grooveinfo.Level.toString();
                  this._levelPorgress1.setProgress(0,0);
                  this._levelPorgress1.labelText = "0%";
                  grooveInfos[1] = Grooveinfo;
               }
               else if(Grooveinfo.Place == 2)
               {
                  this._levelNumTxt3.text = Grooveinfo.Level.toString();
                  this._levelPorgress2.setProgress(0,0);
                  this._levelPorgress2.labelText = "0%";
                  grooveInfos[2] = Grooveinfo;
               }
               else if(Grooveinfo.Place == 3)
               {
                  this._levelNumTxt4.text = Grooveinfo.Level.toString();
                  this._levelPorgress3.setProgress(0,0);
                  this._levelPorgress3.labelText = "0%";
                  grooveInfos[3] = Grooveinfo;
               }
               if(Grooveinfo.Place == 4)
               {
                  this._levelNumTxt5.text = Grooveinfo.Level.toString();
                  this._levelPorgress4.setProgress(0,0);
                  this._levelPorgress4.labelText = "0%";
                  grooveInfos[4] = Grooveinfo;
               }
            }
            else
            {
               current = Grooveinfo.GP - int(cardInfo.Exp);
               difference = int(cardInfo1.Exp) - int(cardInfo.Exp);
               if(current >= difference)
               {
                  if(Boolean(this._playerInfo))
                  {
                     if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
                     {
                        SocketManager.Instance.out.sendUpdateSLOT(Grooveinfo.Place,0);
                     }
                  }
               }
               if(Grooveinfo.Place == 0)
               {
                  this._levelNumTxt1.text = Grooveinfo.Level.toString();
                  if(Grooveinfo.GP == 0)
                  {
                     this._levelPorgress.setProgress(0,Number(difference));
                  }
                  else
                  {
                     this._levelPorgress.setProgress(current,Number(difference));
                  }
                  grooveInfos[0] = Grooveinfo;
               }
               if(Grooveinfo.Place == 1)
               {
                  this._levelNumTxt2.text = Grooveinfo.Level.toString();
                  if(Grooveinfo.GP == 0)
                  {
                     this._levelPorgress1.setProgress(0,Number(difference));
                  }
                  else
                  {
                     this._levelPorgress1.setProgress(current,Number(difference));
                  }
                  grooveInfos[1] = Grooveinfo;
               }
               if(Grooveinfo.Place == 2)
               {
                  this._levelNumTxt3.text = Grooveinfo.Level.toString();
                  if(Grooveinfo.GP == 0)
                  {
                     this._levelPorgress2.setProgress(0,Number(difference));
                  }
                  else
                  {
                     this._levelPorgress2.setProgress(current,Number(difference));
                  }
                  grooveInfos[2] = Grooveinfo;
               }
               if(Grooveinfo.Place == 3)
               {
                  this._levelNumTxt4.text = Grooveinfo.Level.toString();
                  if(Grooveinfo.GP == 0)
                  {
                     this._levelPorgress3.setProgress(0,Number(difference));
                  }
                  else
                  {
                     this._levelPorgress3.setProgress(current,Number(difference));
                  }
                  grooveInfos[3] = Grooveinfo;
               }
               if(Grooveinfo.Place == 4)
               {
                  this._levelNumTxt5.text = Grooveinfo.Level.toString();
                  if(Grooveinfo.GP == 0)
                  {
                     this._levelPorgress4.setProgress(0,Number(difference));
                  }
                  else
                  {
                     this._levelPorgress4.setProgress(current,Number(difference));
                  }
                  grooveInfos[4] = Grooveinfo;
               }
            }
         }
         CardControl.Instance.model.GrooveInfoVector = grooveInfos;
         PlayerManager.Instance.Self.CardSoul = num;
      }
      
      private function __collectHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CardControl.Instance.showCollectView();
      }
      
      private function __resetSoulHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var grooveInfos:Vector.<GrooveInfo> = CardControl.Instance.model.GrooveInfoVector;
         var allGP:int = 0;
         for(var i:int = 0; i < grooveInfos.length; i++)
         {
            allGP += grooveInfos[i].GP;
         }
         if(allGP <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.resetCardSoulNo"));
            return;
         }
         var msgFilterFrameText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("CardSystem.resetCardSoul.alertText");
         var money:String = ServerConfigManager.instance.cardResetCardSoulMoney;
         msgFilterFrameText.htmlText = LanguageMgr.GetTranslation("tank.view.card.resetCardSoulText1") + "\n" + LanguageMgr.GetTranslation("tank.view.card.resetCardSoulText2",allGP,money);
         this._resetAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),"\t\t\t\t\t\t\t\t\t\t\t\t\t",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._resetAlert.height = 170;
         this._resetAlert.containerX = 50;
         this._resetAlert.containerY = 73;
         this._resetAlert.addChild(msgFilterFrameText);
         this._resetAlert.mouseEnabled = false;
         this._resetAlert.addEventListener(FrameEvent.RESPONSE,this.__resetAlertResponse);
      }
      
      private function __resetAlertResponse(event:FrameEvent) : void
      {
         if(this._resetAlert.hasEventListener(FrameEvent.RESPONSE))
         {
            this._resetAlert.removeEventListener(FrameEvent.RESPONSE,this.__resetAlertResponse);
         }
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(BuriedManager.Instance.checkMoney(this._resetAlert.isBand,int(ServerConfigManager.instance.cardResetCardSoulMoney)))
               {
                  this._resetAlert.dispose();
                  return;
               }
               SocketManager.Instance.out.sendResetCardSoul(this._resetAlert.isBand);
               this.__resetAllText();
               break;
         }
         if(Boolean(this._resetAlert))
         {
            this._resetAlert.dispose();
         }
      }
      
      private function __moneyConfirmHandler(evt:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         this._moneyConfirm.dispose();
         this._moneyConfirm = null;
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __resetAllText() : void
      {
         this._levelNumTxt1.text = "0";
         this._levelPorgress.setProgress(0,0);
         this._levelPorgress.labelText = "0%";
         this._levelNumTxt2.text = "0";
         this._levelPorgress1.setProgress(0,0);
         this._levelPorgress1.labelText = "0%";
         this._levelNumTxt3.text = "0";
         this._levelPorgress2.setProgress(0,0);
         this._levelPorgress2.labelText = "0%";
         this._levelNumTxt4.text = "0";
         this._levelPorgress3.setProgress(0,0);
         this._levelPorgress3.labelText = "0%";
         this._levelNumTxt5.text = "0";
         this._levelPorgress4.setProgress(0,0);
         this._levelPorgress4.labelText = "0%";
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
      }
      
      private function __ballPlaySpClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.buyCardSoulValueMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(CardTemplateInfoManager.instance.isShowBuyFrameSelectedCheck)
         {
            this.showBuyCardSoulTips();
         }
         else
         {
            if(PlayerManager.Instance.Self.GetSoulCount != 0)
            {
               CardTemplateInfoManager.instance.isBuyCardsSoul = true;
            }
            SocketManager.Instance.out.sendGetCardSoul();
         }
      }
      
      private function showBuyCardSoulTips() : void
      {
         var buyMoney:Number = ServerConfigManager.instance.buyCardSoulValueMoney;
         this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.cardSystem.getCardSoulMoneyMsg",buyMoney),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("cardSystem.buyFrameSelectedCheckButton");
         this._selectedCheckButton.text = LanguageMgr.GetTranslation("ddt.cardSystem.buyFrameSelectedCheckButtonTextMsg");
         this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
         this._tipsframe.addToContent(this._selectedCheckButton);
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.tipsDispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.GetSoulCount != 0)
            {
               CardTemplateInfoManager.instance.isBuyCardsSoul = true;
            }
            SocketManager.Instance.out.sendGetCardSoul();
         }
      }
      
      private function __onselectedCheckButtoClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         CardTemplateInfoManager.instance.isShowBuyFrameSelectedCheck = !this._selectedCheckButton.selected;
      }
      
      private function tipsDispose() : void
      {
         if(Boolean(this._selectedCheckButton))
         {
            this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
            ObjectUtils.disposeObject(this._selectedCheckButton);
            this._selectedCheckButton = null;
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      private function __cardHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pos:Point = this._cardBtn.localToGlobal(new Point(0,0));
         this._cardList.x = pos.x + this._cardBtn.width;
         this._cardList.y = 440;
         this._cardList.setVisible = true;
      }
      
      private function _openHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var title:String = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice4");
         var content:String = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open4");
         this._openFrame = AlertManager.Instance.simpleAlert(title,content,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._openFrame.addEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
      }
      
      private function __openFramehandler(event:FrameEvent) : void
      {
         this._openFrame.removeEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.openActive();
         }
         this._openFrame.dispose();
         this._openFrame = null;
      }
      
      private function openActive() : void
      {
         var content:String = null;
         if(this._show3 && CardControl.Instance.model.fourIsOpen() || !this._show3 && (CardControl.Instance.model.fiveIsOpen() || CardControl.Instance.model.fiveIsOpen2()))
         {
            if(this._show3)
            {
               this._equipCells[3].open = true;
               SocketManager.Instance.out.sendOpenViceCard(3);
               this.removeSprite(this._cell3MouseSprite,this._open3Btn);
            }
            else
            {
               this._equipCells[4].open = true;
               SocketManager.Instance.out.sendOpenViceCard(4);
               this.removeSprite(this._cell4MouseSprite,this._open4Btn);
            }
         }
         else
         {
            content = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen4");
            this._configFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),content,LanguageMgr.GetTranslation("ok"),"",false,false,true,LayerManager.BLCAK_BLOCKGOUND);
            this._configFrame.addEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         }
      }
      
      private function __configResponseHandler(event:FrameEvent) : void
      {
         this._configFrame.removeEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         this._configFrame.dispose();
         this._configFrame = null;
      }
      
      private function __remove(event:DictionaryEvent) : void
      {
         var cInfo:CardInfo = event.data as CardInfo;
         if(Boolean(this._equipCells[cInfo.Place]))
         {
            this._equipCells[cInfo.Place].cardInfo = null;
         }
      }
      
      private function __upData(event:DictionaryEvent) : void
      {
         var cInfo:CardInfo = event.data as CardInfo;
         if(Boolean(cInfo) && Boolean(this._equipCells[cInfo.Place]))
         {
            if(cInfo.Count <= -1)
            {
               this._equipCells[cInfo.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[cInfo.Place].cardInfo = cInfo;
               this._equipCells[cInfo.Place].playerInfo = this._playerInfo;
            }
         }
      }
      
      private function __getSoul(event:CrazyTankSocketEvent) : void
      {
         var cardSoul:int = 0;
         if(!CardTemplateInfoManager.instance.isBuyCardsSoul)
         {
            return;
         }
         CardTemplateInfoManager.instance.isBuyCardsSoul = false;
         var pkg:PackageIn = event.pkg;
         var b:Boolean = pkg.readBoolean();
         if(b)
         {
            cardSoul = pkg.readInt();
            PlayerManager.Instance.Self.CardSoul += cardSoul;
            PlayerManager.Instance.Self.GetSoulCount = pkg.readInt();
         }
      }
      
      private function isBallPlaySpTip() : void
      {
         this._ballPlaySpTip.visible = false;
         if(Boolean(this.playerInfo) && this.playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            if(PlayerManager.Instance.Self.GetSoulCount > 0)
            {
               this._ballPlaySpTip.visible = true;
            }
            if(PlayerManager.Instance.Self.isViewOther)
            {
               this._ballPlaySpTip.visible = false;
            }
         }
      }
      
      private function __ballPlaySpMouseOver(event:MouseEvent) : void
      {
         this._ballPlaySpTip.visible = true;
      }
      
      private function __ballPlaySpMouseOut(event:MouseEvent) : void
      {
         this.isBallPlaySpTip();
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.isViewOther = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
         this.tipsDispose();
         TweenLite.killTweensOf(this._open3Btn);
         TweenLite.killTweensOf(this._open4Btn);
         this.removeEvent();
         this.removeSprite(this._cell3MouseSprite,this._open3Btn);
         this.removeSprite(this._cell4MouseSprite,this._open4Btn);
         this._cell3MouseSprite = null;
         this._cell3MouseSprite = null;
         this._open3Btn = null;
         this._open4Btn = null;
         this._playerInfo = null;
         if(Boolean(this._dragArea))
         {
            this._dragArea.dispose();
         }
         this._dragArea = null;
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(Boolean(this._background1))
         {
            ObjectUtils.disposeObject(this._background1);
         }
         this._background1 = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._mainCardBit))
         {
            ObjectUtils.disposeObject(this._mainCardBit);
         }
         this._mainCardBit = null;
         if(Boolean(this._collectBtn))
         {
            ObjectUtils.disposeObject(this._collectBtn);
         }
         this._collectBtn = null;
         if(Boolean(this._resetSoulBtn))
         {
            ObjectUtils.disposeObject(this._resetSoulBtn);
         }
         this._resetSoulBtn = null;
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._buyCardBoxBtn))
         {
            ObjectUtils.disposeObject(this._buyCardBoxBtn);
         }
         this._buyCardBoxBtn = null;
         if(Boolean(this._btnHelp))
         {
            ObjectUtils.disposeObject(this._btnHelp);
         }
         this._btnHelp = null;
         if(Boolean(this._textBg))
         {
            ObjectUtils.disposeObject(this._textBg);
         }
         this._textBg = null;
         if(Boolean(this._textBg1))
         {
            ObjectUtils.disposeObject(this._textBg1);
         }
         this._textBg1 = null;
         if(Boolean(this._textBg2))
         {
            ObjectUtils.disposeObject(this._textBg2);
         }
         this._textBg2 = null;
         if(Boolean(this._textBg3))
         {
            ObjectUtils.disposeObject(this._textBg3);
         }
         this._textBg3 = null;
         if(Boolean(this._agilityBg))
         {
            ObjectUtils.disposeObject(this._agilityBg);
         }
         this._agilityBg = null;
         if(Boolean(this._attackBg))
         {
            ObjectUtils.disposeObject(this._attackBg);
         }
         this._attackBg = null;
         if(Boolean(this._defenceBg))
         {
            ObjectUtils.disposeObject(this._defenceBg);
         }
         this._defenceBg = null;
         if(Boolean(this._luckBg))
         {
            ObjectUtils.disposeObject(this._luckBg);
         }
         this._luckBg = null;
         if(Boolean(this._GrooveTxt))
         {
            ObjectUtils.disposeObject(this._GrooveTxt);
         }
         this._GrooveTxt = null;
         if(Boolean(this._levelNumTxt1))
         {
            ObjectUtils.disposeObject(this._levelNumTxt1);
         }
         this._levelNumTxt1 = null;
         if(Boolean(this._levelNumTxt2))
         {
            ObjectUtils.disposeObject(this._levelNumTxt2);
         }
         this._levelNumTxt2 = null;
         if(Boolean(this._levelNumTxt3))
         {
            ObjectUtils.disposeObject(this._levelNumTxt3);
         }
         this._levelNumTxt3 = null;
         if(Boolean(this._levelNumTxt4))
         {
            ObjectUtils.disposeObject(this._levelNumTxt4);
         }
         this._levelNumTxt4 = null;
         if(Boolean(this._levelNumTxt5))
         {
            ObjectUtils.disposeObject(this._levelNumTxt5);
         }
         this._levelNumTxt5 = null;
         if(Boolean(this._levelPorgress))
         {
            ObjectUtils.disposeObject(this._levelPorgress);
         }
         this._levelPorgress = null;
         if(Boolean(this._levelPorgress1))
         {
            ObjectUtils.disposeObject(this._levelPorgress1);
         }
         this._levelPorgress1 = null;
         if(Boolean(this._levelPorgress2))
         {
            ObjectUtils.disposeObject(this._levelPorgress2);
         }
         this._levelPorgress2 = null;
         if(Boolean(this._levelPorgress3))
         {
            ObjectUtils.disposeObject(this._levelPorgress3);
         }
         this._levelPorgress3 = null;
         if(Boolean(this._levelPorgress4))
         {
            ObjectUtils.disposeObject(this._levelPorgress4);
         }
         this._levelPorgress4 = null;
         if(Boolean(this._levelTxt1))
         {
            ObjectUtils.disposeObject(this._levelTxt1);
         }
         this._levelTxt1 = null;
         if(Boolean(this._levelTxt2))
         {
            ObjectUtils.disposeObject(this._levelTxt2);
         }
         this._levelTxt2 = null;
         if(Boolean(this._levelTxt3))
         {
            ObjectUtils.disposeObject(this._levelTxt3);
         }
         this._levelTxt3 = null;
         if(Boolean(this._levelTxt4))
         {
            ObjectUtils.disposeObject(this._levelTxt4);
         }
         this._levelTxt4 = null;
         if(Boolean(this._levelTxt5))
         {
            ObjectUtils.disposeObject(this._levelTxt5);
         }
         this._levelTxt5 = null;
         if(Boolean(this._HunzhiBg))
         {
            ObjectUtils.disposeObject(this._HunzhiBg);
         }
         this._HunzhiBg = null;
         if(Boolean(this._ballPlaySp))
         {
            this._ballPlaySp.removeEventListener(MouseEvent.CLICK,this.__ballPlaySpClickHandler);
            this._ballPlaySp.removeEventListener(MouseEvent.ROLL_OVER,this.__ballPlaySpMouseOver);
            this._ballPlaySp.removeEventListener(MouseEvent.ROLL_OUT,this.__ballPlaySpMouseOut);
            ObjectUtils.disposeObject(this._ballPlaySp);
            this._ballPlaySp = null;
         }
         if(Boolean(this._ballPlay))
         {
            ObjectUtils.disposeObject(this._ballPlay);
         }
         this._ballPlay = null;
         if(Boolean(this._ballPlaySpTip))
         {
            ObjectUtils.disposeObject(this._ballPlaySpTip);
         }
         this._ballPlaySpTip = null;
         if(Boolean(this._moneyConfirm))
         {
            ObjectUtils.disposeObject(this._moneyConfirm);
         }
         this._moneyConfirm = null;
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdateProperty);
         for(var i:int = 0; i < 5; i++)
         {
            if(Boolean(this._equipCells[i]))
            {
               this._equipCells[i].dispose();
               this._equipCells[i].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               this._equipCells[i].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               this._equipCells[i].removeEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
               this._equipCells[i].removeEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
               this._equipCells[i] = null;
            }
         }
         this._equipCells = null;
         for(var j:int = 0; j < this._viceCardBit.length; j++)
         {
            if(Boolean(this._viceCardBit[j]))
            {
               ObjectUtils.disposeObject(this._viceCardBit[j]);
            }
            this._viceCardBit[j] = null;
         }
         this._viceCardBit = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._btnOk.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            ObjectUtils.disposeObject(this._bgHelp);
            ObjectUtils.disposeObject(this._content);
            ObjectUtils.disposeObject(this._btnOk);
            this._bgHelp = null;
            this._content = null;
            this._btnOk = null;
            this._helpFrame.dispose();
            this._helpFrame = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __clickHandler(event:Event) : void
      {
         var info:ItemTemplateInfo = null;
         event.stopImmediatePropagation();
         if(event.target is BaseButton)
         {
            return;
         }
         var cell:CardCell = event.currentTarget as CardCell;
         if(Boolean(cell))
         {
            info = cell.info as ItemTemplateInfo;
         }
         if(info == null)
         {
            return;
         }
         if(!cell.locked)
         {
            SoundManager.instance.play("008");
            cell.dragStart();
         }
      }
      
      protected function __doubleClickHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         var cell:CardCell = event.currentTarget as CardCell;
         if(Boolean(cell.cardInfo))
         {
            event.stopImmediatePropagation();
            if(Boolean(cell) && !cell.locked)
            {
               SocketManager.Instance.out.sendMoveCards(cell.cardInfo.Place,cell.cardInfo.Place);
            }
         }
      }
      
      protected function _cellOverEff(event:MouseEvent) : void
      {
      }
      
      protected function _cellOutEff(event:MouseEvent) : void
      {
      }
      
      private function __helpClick(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("cardSystem.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("cardSystem.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
   }
}

