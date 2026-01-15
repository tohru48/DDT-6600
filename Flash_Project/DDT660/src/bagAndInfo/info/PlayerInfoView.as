package bagAndInfo.info
{
   import bagAndInfo.bag.NecklacePtetrochemicalView;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import bagAndInfo.energyData.EnergyData;
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import beadSystem.data.BeadEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.KingBlessIcon;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import game.GameManager;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import hall.event.NewHallEvent;
   import im.IMController;
   import magicStone.data.MagicStoneInfo;
   import powerUp.PowerUpMovieManager;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.RoomManager;
   import shop.manager.ShopBuyManager;
   import texpSystem.view.TexpInfoTipArea;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import vip.VipController;
   
   public class PlayerInfoView extends Sprite implements Disposeable
   {
      
      private var _info:PlayerInfo;
      
      private var _showSelfOperation:Boolean;
      
      private var _cellPos:Array;
      
      private var _energyData:EnergyData;
      
      private var _honorNameTxt:FilterFrameText;
      
      private var _honorNameCell:BaseCell;
      
      private var _playerInfoEffortHonorView:PlayerInfoEffortHonorView;
      
      private var _nickNameTxt:FilterFrameText;
      
      private var _consortiaTxt:FilterFrameText;
      
      private var _dutyField:FilterFrameText;
      
      private var _storeBtn:SimpleBitmapButton;
      
      private var _reputeField:FilterFrameText;
      
      private var _gesteField:FilterFrameText;
      
      private var _iconContainer:VBox;
      
      private var _levelIcon:LevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _bagDefinitionGroup:SelectedButtonGroup;
      
      private var _bagDefinitionBtnI:SelectedCheckButton;
      
      private var _bagDefinitionBtnII:SelectedCheckButton;
      
      private var _battle:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _hiddenControlsBg:Bitmap;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _achvEnable:Boolean = true;
      
      private var _addFriendBtn:TextButton;
      
      private var _buyAvatar:TextButton;
      
      private var _attackTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _magicAttackTxt:FilterFrameText;
      
      private var _magicDefenceTxt:FilterFrameText;
      
      private var _attackTxt1:FilterFrameText;
      
      private var _agilityTxt1:FilterFrameText;
      
      private var _defenceTxt1:FilterFrameText;
      
      private var _luckTxt1:FilterFrameText;
      
      private var _attackButton:GlowPropButton;
      
      private var _agilityButton:GlowPropButton;
      
      private var _defenceButton:GlowPropButton;
      
      private var _luckButton:GlowPropButton;
      
      private var _magicAttackButton:GlowPropButton;
      
      private var _magicDefenceButton:GlowPropButton;
      
      private var _damageTxt:FilterFrameText;
      
      private var _damageButton:PropButton;
      
      private var _armorTxt:FilterFrameText;
      
      private var _armorButton:PropButton;
      
      private var _HPText:FilterFrameText;
      
      private var _hpButton:PropButton;
      
      private var _vitality:FilterFrameText;
      
      private var _vitalityBuntton:PropButton;
      
      private var _textLevelPrpgress:FilterFrameText;
      
      private var _progressLevel:LevelProgress;
      
      private var _cellContent:Sprite;
      
      private var _character:RoomCharacter;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      private var _offerLabel:Bitmap;
      
      private var _offerSourcePosition:Point;
      
      private var _vipName:GradientText;
      
      private var _showEquip:Sprite;
      
      private var _showCard:Sprite;
      
      private var _cardEquipView:CardEquipView;
      
      private var _bg:MutipleImage;
      
      private var _bg1:MovieImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textBg1:Scale9CornerImage;
      
      private var _textBg2:Scale9CornerImage;
      
      private var _textBg3:Scale9CornerImage;
      
      private var _textBg4:Scale9CornerImage;
      
      private var _textBg5:Scale9CornerImage;
      
      private var _textBg6:Scale9CornerImage;
      
      private var _bg2:MovieImage;
      
      private var _gongxunbg:MovieImage;
      
      private var _characterSprite:TexpInfoTipArea;
      
      private var _isVisible:Boolean = true;
      
      private var _openNecklacePtetrochemicalView:SimpleBitmapButton;
      
      private var _necklacePtetrochemicalView:NecklacePtetrochemicalView;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _kingBlessIcon:KingBlessIcon;
      
      private var _switchShowII:Boolean = true;
      
      private var _isTextTips:Boolean;
      
      public function PlayerInfoView()
      {
         super();
         this.initView();
         this.initProperties();
         this.initPos();
         this.creatCells();
         this.initEvents();
      }
      
      private function cardGuide1() : void
      {
         var data:DictionaryData = null;
         if(!this._showSelfOperation)
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
                  this.cardGuide2(null);
               }
               else
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,0,new Point(-150,0),"asset.trainer.txtCardGuide1","guide.card.txtPos1",this);
                  PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.cardGuide2);
               }
            }
         }
      }
      
      private function cardGuide2(event:DictionaryEvent) : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.cardGuide2);
         NewHandContainer.Instance.showArrow(ArrowType.CARD_GUIDE,180,new Point(355,157),"","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset2");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bg");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.ddtbg");
         this._bg2.visible = this._showSelfOperation;
         addChild(this._bg2);
         this._dragDropArea = new PersonalInfoDragInArea();
         addChild(this._dragDropArea);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextView");
         addChild(this._textBg);
         this._textBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewI");
         addChild(this._textBg1);
         this._textBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewII");
         addChild(this._textBg2);
         this._textBg3 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewIII");
         addChild(this._textBg3);
         this._textBg4 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewIV");
         addChild(this._textBg4);
         this._textBg5 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewV");
         addChild(this._textBg5);
         this._textBg6 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewVI");
         addChild(this._textBg6);
         this._gongxunbg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.gongxunBg");
         addChild(this._gongxunbg);
         this._honorNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameText");
         this._honorNameTxt.setTextFormat(this._honorNameTxt.getTextFormat());
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,120,20);
         sp.graphics.endFill();
         this._honorNameCell = new BaseCell(sp,null,true,true);
         this._honorNameCell.tipDirctions = Directions.DIRECTION_R + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BR;
         this._honorNameCell.tipGapV = 10;
         this._honorNameCell.tipGapH = 10;
         this._honorNameCell.tipStyle = "core.CallPropTxtTips";
         this._honorNameCell.visible = false;
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._honorNameTxt);
            addChild(this._honorNameCell);
            this._honorNameCell.x = this._honorNameTxt.x - 10;
            this._honorNameCell.y = this._honorNameTxt.y;
         }
         this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNickNameText");
         this._consortiaTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewConsortiaText");
         addChild(this._consortiaTxt);
         this._bagDefinitionBtnI = ComponentFactory.Instance.creat("bag.DefinitionBtnI");
         addChild(this._bagDefinitionBtnI);
         this._bagDefinitionBtnII = ComponentFactory.Instance.creat("bag.DefinitionBtnII");
         addChild(this._bagDefinitionBtnII);
         this._bagDefinitionGroup = new SelectedButtonGroup();
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnI);
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnII);
         this._bagDefinitionBtnI.visible = false;
         this._bagDefinitionBtnII.visible = false;
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt);
         this._attackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AttackButton");
         this._attackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
         this._attackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.attactDetail");
         this._attackButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._attackButton);
         addChild(this._attackButton);
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt);
         this._agilityButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AgilityButton");
         this._agilityButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
         this._agilityButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.agilityDetail");
         this._agilityButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._agilityButton);
         addChild(this._agilityButton);
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt);
         this._defenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DefenceButton");
         this._defenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
         this._defenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.defenseDetail");
         this._defenceButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._defenceButton);
         addChild(this._defenceButton);
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt);
         this._luckButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.LuckButton");
         this._luckButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
         this._luckButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.luckDetail");
         this._luckButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._luckButton);
         addChild(this._luckButton);
         this._magicAttackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewMagicAttackText");
         addChild(this._magicAttackTxt);
         this._magicAttackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.MagicAttackButton");
         this._magicAttackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttack");
         this._magicAttackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDetail");
         this._magicAttackButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",0);
         ShowTipManager.Instance.addTip(this._magicAttackButton);
         addChild(this._magicAttackButton);
         if(PlayerInfoViewControl._isBattle)
         {
            ShowTipManager.Instance.removeTip(this._magicAttackButton);
         }
         this._magicDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewMagicDefenceText");
         addChild(this._magicDefenceTxt);
         this._magicDefenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.MagicDefenceButton");
         this._magicDefenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicDefence");
         this._magicDefenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicDefenceDetail");
         this._magicDefenceButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",0);
         ShowTipManager.Instance.addTip(this._magicDefenceButton);
         addChild(this._magicDefenceButton);
         if(PlayerInfoViewControl._isBattle)
         {
            ShowTipManager.Instance.removeTip(this._magicDefenceButton);
         }
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDamageText");
         addChild(this._damageTxt);
         this._damageButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DamageButton");
         this._damageButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage");
         this._damageButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.damageDetail");
         (this._damageButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",0,0,0);
         ShowTipManager.Instance.addTip(this._damageButton);
         addChild(this._damageButton);
         this._armorTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewArmorText");
         addChild(this._armorTxt);
         this._armorButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.ArmorButton");
         this._armorButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery");
         this._armorButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryDetail");
         (this._armorButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",0,0,0);
         ShowTipManager.Instance.addTip(this._armorButton);
         addChild(this._armorButton);
         this._HPText = ComponentFactory.Instance.creatComponentByStylename("personInfoViewHPText");
         addChild(this._HPText);
         this._hpButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.HPButton");
         this._hpButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp");
         this._hpButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpDetail");
         (this._hpButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._hpButton);
         addChild(this._hpButton);
         this._vitality = ComponentFactory.Instance.creatComponentByStylename("personInfoViewVitalityText");
         addChild(this._vitality);
         this._vitalityBuntton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.VitalityButton");
         this._vitalityBuntton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.energy");
         this._vitalityBuntton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.energyDetail");
         ShowTipManager.Instance.addTip(this._vitalityBuntton);
         addChild(this._vitalityBuntton);
         this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("personInfoViewStoreButton");
         this._storeBtn.tipData = LanguageMgr.GetTranslation("tank.view.shortcutforge.tip");
         addChild(this._storeBtn);
         this._storeBtn.visible = true;
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn1");
         PositionUtils.setPos(this._addFriendBtn,"bagAndInfo.FritendBtn.Pos");
         this._addFriendBtn.text = LanguageMgr.GetTranslation("tank.view.im.addFriendBtn");
         addChild(this._addFriendBtn);
         this._reputeField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.ReputeField");
         addChild(this._reputeField);
         this._gesteField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.GesteField");
         addChild(this._gesteField);
         this._offerLabel = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.OfferLabel");
         addChild(this._offerLabel);
         this._offerLabel.visible = false;
         this._offerSourcePosition = new Point(this._offerLabel.x,this._offerLabel.y);
         this._dutyField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.DutyField");
         addChild(this._dutyField);
         this._playerInfoEffortHonorView = new PlayerInfoEffortHonorView();
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._playerInfoEffortHonorView);
         }
         this._showEquip = new Sprite();
         addChild(this._showEquip);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.bagAndInfo.iconContainer");
         this._showEquip.addChild(this._iconContainer);
         this._showCard = new Sprite();
         addChild(this._showCard);
         this._showCard.visible = false;
         this._battle = ComponentFactory.Instance.creatComponentByStylename("personInfoViewBattleText");
         this._showEquip.addChild(this._battle);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLevelText");
         this._showEquip.addChild(this._levelTxt);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("LevelProgress");
         this._showEquip.addChild(this._progressLevel);
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         this._showEquip.addChild(this._hideGlassBtn);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideGlassCheckBox");
         this._showEquip.addChild(this._hideHatBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideSuitCheckBox");
         this._showEquip.addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
         this._showEquip.addChild(this._hideWingBtn);
         this._buyAvatar = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn2");
         this._buyAvatar.text = LanguageMgr.GetTranslation("ddt.bagandinfo.buyOtherCloth");
         this._buyAvatar.x = 138;
         this._buyAvatar.y = 82;
         this._showEquip.addChild(this._buyAvatar);
         this._cellContent = new Sprite();
         this._showEquip.addChild(this._cellContent);
         this._attackTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt1);
         PositionUtils.setPos(this._attackTxt1,"personInfoViewAttackTextPos");
         this._attackTxt1.visible = false;
         this._agilityTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt1);
         PositionUtils.setPos(this._agilityTxt1,"personInfoViewAgilityPos");
         this._agilityTxt1.visible = false;
         this._defenceTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt1);
         PositionUtils.setPos(this._defenceTxt1,"personInfoViewDefencePos");
         this._defenceTxt1.visible = false;
         this._luckTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt1);
         PositionUtils.setPos(this._luckTxt1,"personInfoViewLuckPos");
         this._luckTxt1.visible = false;
         this._openNecklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.OpenBtn");
         addChild(this._openNecklacePtetrochemicalView);
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(evt.ItemID,evt.ItemNum));
      }
      
      private function __createCardView(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createCardView);
            this.createCardEquip();
         }
      }
      
      private function createCardEquip() : void
      {
         try
         {
            this._cardEquipView = ComponentFactory.Instance.creatCustomObject("cardEquipView");
            this._showCard.addChild(this._cardEquipView);
            if(Boolean(this._info))
            {
               this._cardEquipView.playerInfo = this._info;
            }
            this._cardEquipView.clickEnable = this._switchShowII;
         }
         catch(pe:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createCardView);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CARD_SYSTEM);
         }
      }
      
      public function switchShow(value:Boolean) : void
      {
         LoadInterfaceManager.traceMsg("0");
         this._isTextTips = value;
         this._showEquip.visible = !value;
         this._showCard.visible = value;
         this._bg.visible = !value;
         this._bg1.visible = !value;
         this._bg2.visible = this._showSelfOperation;
         this._nickNameTxt.visible = !value;
         this._consortiaTxt.visible = !value;
         this._dutyField.visible = !value;
         this._reputeField.visible = !value;
         this._damageTxt.visible = !value;
         this._damageButton.visible = !value;
         this._armorTxt.visible = !value;
         this._armorButton.visible = !value;
         this._HPText.visible = !value;
         this._hpButton.visible = !value;
         this._vitality.visible = !value;
         this._vitalityBuntton.visible = !value;
         if(this._vipName != null)
         {
            this._vipName.visible = !value;
            this._isVisible = !value;
         }
         this._textBg1.visible = !value;
         this._textBg2.visible = !value;
         this._textBg3.visible = !value;
         this._textBg4.visible = !value;
         this._textBg5.visible = !value;
         this._textBg6.visible = !value;
         this._attackTxt.visible = !value;
         this._attackButton.visible = !value;
         this._agilityTxt.visible = !value;
         this._agilityButton.visible = !value;
         this._defenceTxt.visible = !value;
         this._defenceButton.visible = !value;
         this._luckTxt.visible = !value;
         this._luckButton.visible = !value;
         this._magicAttackTxt.visible = !value;
         this._magicAttackButton.visible = !value;
         this._magicDefenceTxt.visible = !value;
         this._magicDefenceButton.visible = !value;
         this._attackTxt1.visible = value;
         this._agilityTxt1.visible = value;
         this._defenceTxt1.visible = value;
         this._luckTxt1.visible = value;
         this.__onUpdatePlayerProperty(null);
         if(value && this._cardEquipView == null)
         {
            this.createCardEquip();
         }
         if(this._showSelfOperation && this._showEquip.visible)
         {
            this._openNecklacePtetrochemicalView.visible = true;
         }
         else
         {
            this._openNecklacePtetrochemicalView.visible = false;
         }
         LoadInterfaceManager.traceMsg("1");
      }
      
      public function cardEquipShine(info:CardInfo) : void
      {
         if(info.templateInfo.Property8 == "1")
         {
            this._cardEquipView.shineMain();
         }
         else
         {
            this._cardEquipView.shineVice();
         }
      }
      
      public function switchShowII(value:Boolean) : void
      {
         this._switchShowII = !value;
         this.switchShow(value);
         if(Boolean(this._cardEquipView))
         {
            this._cardEquipView.clickEnable = this._showSelfOperation;
         }
         this._addFriendBtn.visible = !value;
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._addFriendBtn.visible = false;
         }
      }
      
      private function initProperties() : void
      {
         this._storeBtn.transparentEnable = true;
         this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
      }
      
      private function initPos() : void
      {
         this._cellPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos3"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos4"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos5"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos6"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos7"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos8"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos9"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos10"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos11"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos12"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos13"),ComponentFactory.Instance
         .creatCustomObject("bagAndInfo.info.equip.pos14"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos15"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos16"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos17"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos18"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos19")];
      }
      
      private function initEvents() : void
      {
         this._storeBtn.addEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         this._buyAvatar.addEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.addEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.addEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.addEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.addEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._bagDefinitionGroup.addEventListener(Event.CHANGE,this._definitionGroupChange);
         this._openNecklacePtetrochemicalView.addEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      protected function __openNecklacePtetrochemicalView(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._necklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.necklacePtetrochemicalView");
         this._necklacePtetrochemicalView.show();
         this._necklacePtetrochemicalView.addEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
      }
      
      protected function __onNecklacePtetrochemicalClose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._necklacePtetrochemicalView.removeEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
            ObjectUtils.disposeObject(this._necklacePtetrochemicalView);
            this._necklacePtetrochemicalView = null;
         }
      }
      
      protected function __onUpdatePlayerProperty(event:Event) : void
      {
         var prop:String = null;
         var magicAttackDic:DictionaryData = null;
         var dic:DictionaryData = null;
         var propPropertySource:String = null;
         if(this._info.propertyAddition == null)
         {
            return;
         }
         var arr:Vector.<GlowPropButton> = Vector.<GlowPropButton>([this._attackButton,this._defenceButton,this._agilityButton,this._luckButton]);
         var propArr:Array = ["Attack","Defence","Agility","Luck"];
         var i:int = 0;
         var suitString:String = LanguageMgr.GetTranslation("tank.data.EquipType.suit");
         var gemString:String = LanguageMgr.GetTranslation("tank.data.EquipType.gem");
         for each(prop in propArr)
         {
            dic = this._info.getPropertyAdditionByType(prop);
            if(Boolean(dic))
            {
               propPropertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",dic["Texp"],dic["Card"],dic["Pet"],dic["Totem"],dic["gem"],dic["Bead"],dic["Avatar"],dic["MagicStone"]);
               if(!PathManager.solveGemstoneSwitch)
               {
                  propPropertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt.noGemstone",dic["Texp"],dic["Card"],dic["Pet"],dic["Totem"],dic["Bead"],dic["Avatar"],dic["MagicStone"]);
               }
               if(PathManager.suitEnable)
               {
                  propPropertySource += "\n" + suitString + "+" + dic["Suit"];
               }
               arr[i].propertySource = propPropertySource;
            }
            if(i >= 4)
            {
               break;
            }
            i++;
         }
         magicAttackDic = this._info.getPropertyAdditionByType("MagicAttack");
         if(Boolean(magicAttackDic))
         {
            GlowPropButton(this._magicAttackButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",magicAttackDic["MagicStone"],magicAttackDic["Horse"],magicAttackDic["HorsePicCherish"],magicAttackDic["Enchant"],magicAttackDic["Suit"]);
         }
         var magicDefenceDic:DictionaryData = this._info.getPropertyAdditionByType("MagicDefence");
         if(Boolean(magicDefenceDic))
         {
            GlowPropButton(this._magicDefenceButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",magicDefenceDic["MagicStone"],magicDefenceDic["Horse"],magicDefenceDic["HorsePicCherish"],magicDefenceDic["Enchant"],magicDefenceDic["Suit"]);
         }
         var hpDic:DictionaryData = this._info.getPropertyAdditionByType("HP");
         if(Boolean(hpDic))
         {
            GlowPropButton(this._hpButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxt",hpDic["Texp"],hpDic["Pet"],hpDic["Totem"],hpDic["Bead"],hpDic["Avatar"],hpDic["Horse"],hpDic["HorsePicCherish"]);
            if(PathManager.solveGemstoneSwitch)
            {
               GlowPropButton(this._hpButton).propertySource = GlowPropButton(this._hpButton).propertySource + ("\n" + gemString + "+" + hpDic["gem"]);
            }
            if(PathManager.suitEnable && Boolean(hpDic))
            {
               GlowPropButton(this._hpButton).propertySource = GlowPropButton(this._hpButton).propertySource + ("\n" + suitString + "+" + hpDic["Suit"]);
            }
         }
         var armorDic:DictionaryData = this._info.getPropertyAdditionByType("Armor");
         var tmp:int = 0;
         var tmp2:int = 0;
         var tmp3:int = 0;
         var tmp4:int = 0;
         var tmp5:int = 0;
         var tmp6:int = 0;
         if(Boolean(armorDic))
         {
            tmp = int(armorDic["Totem"]);
            tmp2 = int(armorDic["Bead"]);
            tmp3 = int(armorDic["Avatar"]);
            tmp4 = int(armorDic["Horse"]);
            tmp5 = int(armorDic["HorsePicCherish"]);
            tmp6 = int(armorDic["Pet"]);
         }
         var guardDic:DictionaryData = this._info.getPropertyAdditionByType("Guard");
         GlowPropButton(this._armorButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",StaticFormula.getCardRecoveryAddition(this._info),tmp,tmp2,tmp3,tmp4,tmp5,tmp6);
         if(PathManager.suitEnable && Boolean(guardDic))
         {
            GlowPropButton(this._armorButton).propertySource = GlowPropButton(this._armorButton).propertySource + ("\n" + suitString + "+" + guardDic["Suit"]);
         }
         var damageDic:DictionaryData = this._info.getPropertyAdditionByType("Damage");
         tmp = 0;
         tmp2 = 0;
         tmp3 = 0;
         if(Boolean(damageDic))
         {
            tmp = int(damageDic["Totem"]);
            tmp2 = int(damageDic["Bead"]);
            tmp3 = int(damageDic["Avatar"]);
            tmp4 = int(damageDic["Horse"]);
            tmp5 = int(damageDic["HorsePicCherish"]);
         }
         GlowPropButton(this._damageButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",StaticFormula.getCardDamageAddition(this._info),tmp,tmp2,tmp3,tmp4,tmp5);
         if(PathManager.suitEnable && Boolean(damageDic))
         {
            GlowPropButton(this._damageButton).propertySource = GlowPropButton(this._damageButton).propertySource + ("\n" + suitString + "+" + damageDic["Suit"]);
         }
         if(Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            if(!this._openNecklacePtetrochemicalView.parent)
            {
               addChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(Boolean(this._openNecklacePtetrochemicalView.parent))
         {
            this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
         }
      }
      
      private function removeEvent() : void
      {
         this._storeBtn.removeEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         this._buyAvatar.removeEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.removeEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.removeEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.removeEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.removeEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._openNecklacePtetrochemicalView.removeEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
         if(this._info is PlayerInfo)
         {
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.removeEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
         }
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
         this._bagDefinitionGroup.removeEventListener(Event.CHANGE,this._definitionGroupChange);
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      private function __storeBtnClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 5)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
            return;
         }
         BagStore.instance.show();
         BagStore.instance.isFromBagFrame = true;
      }
      
      private function __addFriendClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      private function __buyAvatarClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ShopBuyManager.Instance.buyAvatar(this._info);
      }
      
      private function __hideGlassClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.GLASS,this._hideGlassBtn.selected);
      }
      
      private function __hideHatClickHandler(evt:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.HEAD,this._hideHatBtn.selected);
      }
      
      private function __hideSuitClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.SUITS,this._hideSuitBtn.selected);
      }
      
      private function __hideWingClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.WING,this._hideWingBtn.selected);
      }
      
      private function creatCells() : void
      {
         var cell:PersonalInfoCell = null;
         this._cells = new Vector.<PersonalInfoCell>();
         for(var i:int = 0; i < 19; i++)
         {
            cell = CellFactory.instance.createPersonalInfoCell(i) as PersonalInfoCell;
            switch(i)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 11:
               case 13:
                  break;
               default:
                  cell.addEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
                  cell.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
                  break;
            }
            cell.x = this._cellPos[i].x;
            cell.y = this._cellPos[i].y;
            this._cellContent.addChild(cell);
            this._cells.push(cell);
         }
      }
      
      private function clearCells() : void
      {
         for(var i:int = 0; i < this._cells.length; i++)
         {
            if(Boolean(this._cells[i]))
            {
               if(this._cells[i].hasEventListener(CellEvent.ITEM_CLICK))
               {
                  this._cells[i].removeEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
               }
               if(this._cells[i].hasEventListener(CellEvent.DOUBLE_CLICK))
               {
                  this._cells[i].removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
               }
               if(Boolean(this._cells[i].parent))
               {
                  this._cells[i].parent.removeChild(this._cells[i] as PersonalInfoCell);
               }
               this._cells[i].dispose();
               this._cells[i] = null;
            }
         }
      }
      
      public function set info(value:*) : void
      {
         PlayerInfoViewControl.currentPlayer = value;
         if(this._info == value)
         {
            return;
         }
         if(PlayerInfoViewControl._isBattle)
         {
            this._info = value;
            if(this._info.ID == PlayerManager.Instance.Self.ID)
            {
               ShowTipManager.Instance.addTip(this._magicAttackButton);
               ShowTipManager.Instance.addTip(this._magicDefenceButton);
            }
            this.updateView(PlayerInfoViewControl._isBattle);
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            PlayerManager.Instance.removeEventListener(BeadEvent.EQUIPBEAD,this.__onBeadBagUpdate);
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.removeEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
            this._info = null;
         }
         this._info = value;
         if(Boolean(this._info))
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            this._info.Bag.addEventListener(BagEvent.UPDATE,this.__updateCells);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.addEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
            if(Boolean(this._cardEquipView))
            {
               this._cardEquipView.playerInfo = this._info;
            }
            ItemManager.Instance.playerInfo = this._info;
         }
         this.updateView();
      }
      
      protected function __onBeadBagUpdate(event:Event) : void
      {
         this.updatePersonInfo();
      }
      
      private function __changeHandler(evt:PlayerPropertyEvent) : void
      {
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         this.setTexpViewProTxt();
         if(Boolean(this._info) && Boolean(this._characterSprite))
         {
            this._characterSprite.info = this._info;
         }
      }
      
      private function __upVip(evt:Event) : void
      {
         this.__changeHandler(null);
      }
      
      private function __updateCells(evt:BagEvent) : void
      {
         var ps:String = null;
         var p:int = 0;
         for(ps in evt.changedSlots)
         {
            p = int(ps);
            if(p <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this._cells[p].info = this._info.Bag.getItemAt(p);
            }
            if(Boolean(GemstoneManager.Instance.getByPlayerInfoList(p,this._info.ID)))
            {
               if(Boolean(this._cells[p].info))
               {
                  (this._cells[p].info as InventoryItemInfo).gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(p,this._info.ID);
               }
            }
         }
         this.updateCells();
      }
      
      private function __equipMagicStone(event:BagEvent) : void
      {
         var place:String = null;
         var p:int = 0;
         for(place in event.changedSlots)
         {
            p = int(place);
            if(p <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this.updateCells();
               break;
            }
         }
      }
      
      private function __cellClickHandler(evt:CellEvent) : void
      {
         var cell:PersonalInfoCell = null;
         if(this._showSelfOperation)
         {
            cell = evt.data as PersonalInfoCell;
            cell.dragStart();
         }
      }
      
      private function __cellDoubleClickHandler(evt:CellEvent) : void
      {
         var cell:PersonalInfoCell = null;
         var info:InventoryItemInfo = null;
         if(this._showSelfOperation)
         {
            cell = evt.data as PersonalInfoCell;
            if(Boolean(cell) && Boolean(cell.info))
            {
               info = cell.info as InventoryItemInfo;
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,-1,info.Count);
            }
         }
      }
      
      private function updateView(bool:Boolean = false) : void
      {
         if(bool)
         {
            this.updatePersonInfo();
            this.updateCharacter();
            return;
         }
         this.updateCharacter();
         this.updateCells();
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         this.updateShowOperation();
         this.cardGuide1();
      }
      
      private function updateHide() : void
      {
         if(Boolean(this._info))
         {
            this._hideGlassBtn.selected = this._info.getGlassHide();
            this._hideHatBtn.selected = this._info.getHatHide();
            this._hideSuitBtn.selected = this._info.getSuitesHide();
            this._hideWingBtn.selected = this._info.wingHide;
         }
      }
      
      private function updateCharacter() : void
      {
         if(Boolean(this._info))
         {
            if(Boolean(this._character))
            {
               this._character.dispose();
               this._character = null;
            }
            this._character = CharactoryFactory.createCharacter(this._info,"room") as RoomCharacter;
            this._character.showGun = false;
            this._character.show(false,-1);
            this._character.x = 267;
            this._character.y = 108;
            this._showEquip.addChildAt(this._character,0);
            if(!this._characterSprite)
            {
               this._characterSprite = new TexpInfoTipArea();
               this._characterSprite.x = this._character.x;
               this._characterSprite.y = this._character.y;
               this._characterSprite.scaleX = -1;
               this._showEquip.addChildAt(this._characterSprite,0);
            }
            this._characterSprite.info = this._info;
         }
         else
         {
            this._character.dispose();
            this._character = null;
            ObjectUtils.disposeObject(this._characterSprite);
            this._characterSprite = null;
         }
      }
      
      private function updateCells() : void
      {
         var cell:PersonalInfoCell = null;
         var item:InventoryItemInfo = null;
         var mgStone:InventoryItemInfo = null;
         var attr:MagicStoneInfo = null;
         for each(cell in this._cells)
         {
            if(!this._info)
            {
               break;
            }
            item = this._info.Bag.getItemAt(cell.place);
            cell.info = item;
            if(Boolean(item))
            {
               item.gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(cell.place,this._info.ID);
               if(this._info == PlayerManager.Instance.Self)
               {
                  mgStone = PlayerManager.Instance.Self.magicStoneBag.getItemAt(cell.place);
                  if(!mgStone)
                  {
                     item.magicStoneAttr = null;
                  }
                  else
                  {
                     attr = new MagicStoneInfo();
                     attr.templateId = mgStone.TemplateID;
                     attr.level = mgStone.StrengthenLevel;
                     attr.attack = mgStone.AttackCompose;
                     attr.defence = mgStone.DefendCompose;
                     attr.agility = mgStone.AgilityCompose;
                     attr.luck = mgStone.LuckCompose;
                     attr.magicAttack = mgStone.MagicAttack;
                     attr.magicDefence = mgStone.MagicDefence;
                     item.magicStoneAttr = attr;
                  }
               }
            }
         }
         if(Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            if(!this._openNecklacePtetrochemicalView.parent)
            {
               addChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(Boolean(this._openNecklacePtetrochemicalView.parent))
         {
            this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
         }
      }
      
      private function getList(p:int) : Vector.<GemstListInfo>
      {
         for(var i:int = 0; i < 5; i++)
         {
            if(Boolean(PlayerManager.Instance.gemstoneInfoList[i]))
            {
               if(p == PlayerManager.Instance.gemstoneInfoList[i].equipPlace)
               {
                  return PlayerManager.Instance.gemstoneInfoList[i].list;
               }
            }
         }
         return null;
      }
      
      public function allowLvIconClick() : void
      {
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.allowClick();
         }
      }
      
      private function updateIcons() : void
      {
         var team:int = 0;
         if(Boolean(this._info))
         {
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.levelIcon");
               if(this._info.IsVIP)
               {
                  this._levelIcon.x += 1;
               }
            }
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            team = 1;
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               team = GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) == null ? -1 : GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team;
            }
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false,team);
            this._showEquip.addChild(this._levelIcon);
            if(this._info.SpouseID > 0)
            {
               if(this._marriedIcon == null)
               {
                  this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.MarriedIcon");
               }
               this._marriedIcon.tipData = {
                  "nickName":this._info.SpouseName,
                  "gender":this._info.Sex
               };
               this._iconContainer.addChild(this._marriedIcon);
            }
            else if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
         }
         else
         {
            if(Boolean(this._levelIcon))
            {
               this._levelIcon.dispose();
               this._levelIcon = null;
            }
            if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
         }
      }
      
      private function updatePersonInfo() : void
      {
         var value:String = null;
         var widthDuty:int = 0;
         var Denominator:int = 0;
         var Molecular:int = 0;
         if(this._info == null)
         {
            return;
         }
         this._levelTxt.text = this._info.Grade + "";
         if(PlayerInfoViewControl._isBattle)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? "" : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? "" : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(this._info.Damage),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(this._info.Guard),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(this._info.Blood),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(this._info.Energy),1);
            return;
         }
         this.__onUpdatePlayerProperty(null);
         this._reputeField.text = this._info == null ? "" : this._info.Repute.toString();
         this._gesteField.text = this._info == null ? "" : this._info.Offer.toString();
         this._dutyField.text = this._info.DutyName == null || this._info.DutyName == "" ? "" : (this._info.ConsortiaID > 0 ? "< " + this._info.DutyName + " >" : "");
         this._honorNameTxt.text = this._info.honor == null ? "" : this._info.honor;
         if(this._honorNameTxt.text == "")
         {
            this._honorNameCell.visible = false;
         }
         else
         {
            this._honorNameCell.visible = true;
            value = this._info.honor;
            if(Boolean(PlayerManager.Instance.callPropData) && Boolean(PlayerManager.Instance.callPropData[value]))
            {
               this._honorNameCell.tipData = PlayerManager.Instance.callPropData[value] as CallPropTxtTipInfo;
            }
            else
            {
               this._honorNameCell.tipData = new CallPropTxtTipInfo();
            }
         }
         this._nickNameTxt.text = this._info.NickName == null ? "" : this._info.NickName;
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(114,this._info.typeVIP);
            this._vipName.x = this._nickNameTxt.x;
            this._vipName.y = this._nickNameTxt.y;
            this._vipName.text = this._nickNameTxt.text;
            this._vipName.visible = this._isVisible;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._nickNameTxt);
         }
         else
         {
            addChild(this._nickNameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._consortiaTxt.text = this._info.ConsortiaName == null ? "" : (this._info.ConsortiaID > 0 ? this._info.ConsortiaName : "");
         this._dutyField.x = this._consortiaTxt.x + this._consortiaTxt.width + 6;
         if(this._dutyField.x + this._dutyField.width > 267)
         {
            this._dutyField.autoSize = TextFieldAutoSize.NONE;
            this._dutyField.isAutoFitLength = true;
            widthDuty = 260 - this._dutyField.x;
            this._dutyField.width = widthDuty;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._gesteField.visible = true;
            this._gongxunbg.visible = true;
            this._bg2.visible = this._showSelfOperation;
         }
         else
         {
            this._storeBtn.visible = true;
            this._storeBtn.enable = false;
            this._gesteField.visible = false;
            this._gongxunbg.visible = false;
            this._bg2.visible = false;
         }
         if(this._info.ConsortiaID > 0 && this._dutyField.x + this._dutyField.width > this._offerSourcePosition.x)
         {
            this._offerLabel.x = this._dutyField.x + this._dutyField.width;
         }
         else
         {
            this._offerLabel.x = this._offerSourcePosition.x + 32;
         }
         PowerUpMovieManager.isInPlayerInfoView = true;
         if(this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? "" : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? "" : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info)) <= 0 ? "" : Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info) <= 0 ? "" : StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info) <= 0 ? "" : StaticFormula.getEnergy(this._info)),1);
            if(this._info.isSelf)
            {
               this._battle.htmlText = this.getHtmlTextByString(String(this._info.FightPower),2);
            }
            else if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
            else
            {
               this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
            }
         }
         else
         {
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(RoomManager.Instance.current.selfRoomPlayer.playerInfo.ID == this._info.ID)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
            else
            {
               this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
            }
            this._attackTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Attack < 0 ? 0 : this._info.Attack),0);
            this._agilityTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Agility < 0 ? 0 : this._info.Agility),0);
            this._defenceTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Defence < 0 ? 0 : this._info.Defence),0);
            this._luckTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Luck < 0 ? 0 : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? 0 : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? 0 : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info)),1);
         }
         if(Boolean(this._info))
         {
            this._progressLevel.setProgress(Experience.getExpPercent(this._info.Grade,this._info.GP) * 100,100);
            Denominator = Experience.expericence[this._info.Grade] - Experience.expericence[this._info.Grade - 1];
            Molecular = this._info.GP - Experience.expericence[this._info.Grade - 1];
            if(this._info.Grade < Experience.expericence.length)
            {
               Molecular = Molecular > Denominator ? Denominator : Molecular;
            }
            if(StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this._progressLevel.tipData = "0/" + Denominator;
            }
            else if(Molecular > 0 && this._info.Grade < Experience.expericence.length)
            {
               this._progressLevel.tipData = Molecular + "/" + Denominator;
            }
            else if(this._info.Grade == Experience.expericence.length)
            {
               this._progressLevel.tipData = Molecular + "/0";
            }
            else
            {
               this._progressLevel.tipData = "0/" + Denominator;
            }
         }
         if(Boolean(this._info) && this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._definitionGroupChange();
         }
      }
      
      private function setTexpViewProTxt() : void
      {
         var dicAttack:DictionaryData = this._info.getPropertyAdditionByType("Attack");
         var dicDefence:DictionaryData = this._info.getPropertyAdditionByType("Defence");
         var dicAgility:DictionaryData = this._info.getPropertyAdditionByType("Agility");
         var dicLuck:DictionaryData = this._info.getPropertyAdditionByType("Luck");
         if(!dicAgility)
         {
            return;
         }
         this._attackTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(dicAttack["Card"] < 0 ? 0 : dicAttack["Card"]),0);
         this._agilityTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(dicAgility["Card"] < 0 ? 0 : dicAgility["Card"]),0);
         this._defenceTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(dicDefence["Card"] < 0 ? 0 : dicDefence["Card"]),0);
         this._luckTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(dicLuck["Card"] < 0 ? 0 : dicLuck["Card"]),0);
      }
      
      private function getHtmlTextByString(value:String, choiceHtmlText:int) : String
      {
         var sourceBegin:String = null;
         var sourceEnding:String = null;
         switch(choiceHtmlText)
         {
            case 0:
               sourceBegin = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#FFF6C9\' ><B>";
               sourceEnding = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 1:
               sourceBegin = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#FFF6C9\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               sourceEnding = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 2:
               sourceBegin = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#FFF6C9\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               sourceEnding = "</B></FONT></P></TEXTFORMAT>";
         }
         return sourceBegin + value + sourceEnding;
      }
      
      public function dispose() : void
      {
         PowerUpMovieManager.isInPlayerInfoView = false;
         this.removeEvent();
         this.clearCells();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._attackTxt);
         this._attackTxt = null;
         ObjectUtils.disposeObject(this._agilityTxt);
         this._agilityTxt = null;
         ObjectUtils.disposeObject(this._defenceTxt);
         this._defenceTxt = null;
         ObjectUtils.disposeObject(this._luckTxt);
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._magicAttackTxt);
         this._magicAttackTxt = null;
         ObjectUtils.disposeObject(this._magicDefenceTxt);
         this._magicDefenceTxt = null;
         ObjectUtils.disposeObject(this._damageTxt);
         this._damageTxt = null;
         ObjectUtils.disposeObject(this._armorTxt);
         this._armorTxt = null;
         ObjectUtils.disposeObject(this._HPText);
         this._HPText = null;
         ObjectUtils.disposeObject(this._vitality);
         this._vitality = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._kingBlessIcon);
         this._kingBlessIcon = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         this._vipIcon = null;
         this._marriedIcon = null;
         this._kingBlessIcon = null;
         if(Boolean(this._attackButton))
         {
            ShowTipManager.Instance.removeTip(this._attackButton);
            ObjectUtils.disposeObject(this._attackButton);
            this._attackButton = null;
         }
         if(Boolean(this._agilityButton))
         {
            ShowTipManager.Instance.removeTip(this._agilityButton);
            ObjectUtils.disposeObject(this._agilityButton);
            this._agilityButton = null;
         }
         if(Boolean(this._defenceButton))
         {
            ShowTipManager.Instance.removeTip(this._defenceButton);
            ObjectUtils.disposeObject(this._defenceButton);
            this._defenceButton = null;
         }
         if(Boolean(this._luckButton))
         {
            ShowTipManager.Instance.removeTip(this._luckButton);
            ObjectUtils.disposeObject(this._luckButton);
            this._luckButton = null;
         }
         if(Boolean(this._magicAttackButton))
         {
            ShowTipManager.Instance.removeTip(this._magicAttackButton);
            ObjectUtils.disposeObject(this._magicAttackButton);
            this._magicAttackButton = null;
         }
         if(Boolean(this._magicDefenceButton))
         {
            ShowTipManager.Instance.removeTip(this._magicDefenceButton);
            ObjectUtils.disposeObject(this._magicDefenceButton);
            this._magicDefenceButton = null;
         }
         if(Boolean(this._damageButton))
         {
            ShowTipManager.Instance.removeTip(this._damageButton);
            ObjectUtils.disposeObject(this._damageButton);
            this._damageButton = null;
         }
         if(Boolean(this._armorButton))
         {
            ShowTipManager.Instance.removeTip(this._armorButton);
            ObjectUtils.disposeObject(this._armorButton);
            this._armorButton = null;
         }
         if(Boolean(this._hpButton))
         {
            ShowTipManager.Instance.removeTip(this._hpButton);
            ObjectUtils.disposeObject(this._hpButton);
            this._hpButton = null;
         }
         if(Boolean(this._vitalityBuntton))
         {
            ShowTipManager.Instance.removeTip(this._vitalityBuntton);
            ObjectUtils.disposeObject(this._vitalityBuntton);
            this._vitalityBuntton = null;
         }
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bg1);
         this._bg1 = null;
         ObjectUtils.disposeObject(this._showEquip);
         ObjectUtils.disposeObject(this._textBg);
         this._textBg = null;
         ObjectUtils.disposeObject(this._textBg1);
         this._textBg1 = null;
         ObjectUtils.disposeObject(this._textBg2);
         this._textBg2 = null;
         ObjectUtils.disposeObject(this._textBg3);
         this._textBg3 = null;
         ObjectUtils.disposeObject(this._textBg4);
         this._textBg4 = null;
         ObjectUtils.disposeObject(this._textBg5);
         this._textBg5 = null;
         ObjectUtils.disposeObject(this._textBg6);
         this._textBg6 = null;
         ObjectUtils.disposeObject(this._bg2);
         this._bg2 = null;
         this._showEquip = null;
         ObjectUtils.disposeObject(this._showCard);
         this._showCard = null;
         ObjectUtils.disposeObject(this._cardEquipView);
         this._cardEquipView = null;
         ObjectUtils.disposeObject(this._honorNameTxt);
         this._honorNameTxt = null;
         ObjectUtils.disposeObject(this._honorNameCell);
         this._honorNameCell = null;
         ObjectUtils.disposeObject(this._nickNameTxt);
         this._nickNameTxt = null;
         ObjectUtils.disposeObject(this._consortiaTxt);
         this._consortiaTxt = null;
         ObjectUtils.disposeObject(this._battle);
         this._battle = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._characterSprite);
         this._characterSprite = null;
         ObjectUtils.disposeObject(this._progressLevel);
         this._progressLevel = null;
         ObjectUtils.disposeObject(this._reputeField);
         this._reputeField = null;
         ObjectUtils.disposeObject(this._gesteField);
         this._gesteField = null;
         ObjectUtils.disposeObject(this._dutyField);
         this._dutyField = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideHatBtn);
         this._hideHatBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._storeBtn);
         this._storeBtn = null;
         ObjectUtils.disposeObject(this._addFriendBtn);
         this._addFriendBtn = null;
         ObjectUtils.disposeObject(this._buyAvatar);
         this._buyAvatar = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnI);
         this._bagDefinitionBtnI = null;
         ObjectUtils.disposeObject(this._bagDefinitionGroup);
         this._bagDefinitionGroup = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnII);
         this._bagDefinitionBtnII = null;
         ObjectUtils.disposeObject(this._playerInfoEffortHonorView);
         this._playerInfoEffortHonorView = null;
         ObjectUtils.disposeObject(this._cellContent);
         this._cellContent = null;
         ObjectUtils.disposeObject(this._offerLabel);
         this._offerLabel = null;
         ObjectUtils.disposeObject(this._dragDropArea);
         this._dragDropArea = null;
         ObjectUtils.disposeObject(this._openNecklacePtetrochemicalView);
         this._openNecklacePtetrochemicalView = null;
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         this._energyData = null;
      }
      
      public function startShine(info:ItemTemplateInfo) : void
      {
         var shineIndex:Array = null;
         var i:int = 0;
         if(info.NeedSex == 0 || info.NeedSex == (PlayerManager.Instance.Self.Sex ? 1 : 2))
         {
            shineIndex = this.getCellIndex(info).split(",");
            for(i = 0; i < shineIndex.length; i++)
            {
               if(int(shineIndex[i]) >= 0)
               {
                  (this._cells[int(shineIndex[i])] as PersonalInfoCell).shine();
               }
            }
         }
      }
      
      public function stopShine() : void
      {
         var ds:PersonalInfoCell = null;
         for each(ds in this._cells)
         {
            (ds as PersonalInfoCell).stopShine();
         }
         if(Boolean(this._cardEquipView))
         {
            this._cardEquipView.stopShine();
         }
      }
      
      private function getCellIndex(info:ItemTemplateInfo) : String
      {
         if(EquipType.isWeddingRing(info))
         {
            return "9,10,16";
         }
         switch(info.CategoryID)
         {
            case EquipType.HEAD:
               return "0";
            case EquipType.GLASS:
               return "1";
            case EquipType.HAIR:
               return "2";
            case EquipType.EFF:
               return "3";
            case EquipType.CLOTH:
               return "4";
            case EquipType.FACE:
               return "5";
            case EquipType.ARM:
               return "6";
            case EquipType.ARMLET:
            case EquipType.TEMPARMLET:
               return "7,8";
            case EquipType.RING:
            case EquipType.TEMPRING:
               return "9,10";
            case EquipType.SUITS:
               return "11";
            case EquipType.NECKLACE:
               return "12";
            case EquipType.WING:
               return "13";
            case EquipType.CHATBALL:
               return "14";
            case EquipType.OFFHAND:
               return "15";
            case EquipType.HEALSTONE:
               return "18";
            case EquipType.TEMPWEAPON:
               return "6";
            case EquipType.BADGE:
               return "17";
            default:
               return "-1";
         }
      }
      
      public function get showSelfOperation() : Boolean
      {
         return this._showSelfOperation;
      }
      
      public function set showSelfOperation(value:Boolean) : void
      {
         this._showSelfOperation = value;
         this.updateShowOperation();
      }
      
      private function updateShowOperation() : void
      {
         this._honorNameTxt.visible = !this.showSelfOperation;
         this._playerInfoEffortHonorView.visible = this.showSelfOperation;
         this._storeBtn.visible = true;
         this._storeBtn.enable = this._showSelfOperation;
         this._buyAvatar.visible = !this._showSelfOperation && this._info != null && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID) && PlayerManager.Instance.Self.Grade > 2 && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.TRAINER1 && StateManager.currentStateType != StateType.TRAINER2 && StateManager.currentStateType != StateType.HOT_SPRING_ROOM && StateManager.currentStateType != StateType.CHURCH_ROOM && StateManager.currentStateType != StateType.LITTLEGAME && StateManager.currentStateType != StateType.ROOM_LOADING;
         if(this._info is SelfInfo)
         {
            this._buyAvatar.visible = false;
         }
         else if(Boolean(this._info))
         {
            this.createVipAndKing();
         }
         this._hideGlassBtn.visible = this._hideHatBtn.visible = this._hideSuitBtn.visible = this._hideWingBtn.visible = this._showSelfOperation;
         this._addFriendBtn.visible = !this._showSelfOperation && this._info != null && this._info.ID != PlayerManager.Instance.Self.ID && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID);
         if(this._showSelfOperation && this._showEquip.visible)
         {
            this._openNecklacePtetrochemicalView.visible = true;
         }
         else
         {
            this._openNecklacePtetrochemicalView.visible = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(Boolean(this._openNecklacePtetrochemicalView.parent))
            {
               this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(!this._openNecklacePtetrochemicalView.parent && Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            addChild(this._openNecklacePtetrochemicalView);
         }
         if(!this._info || this._info.ID != PlayerManager.Instance.Self.ID || !this._showSelfOperation)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         this._bagDefinitionBtnI.visible = true;
         this._bagDefinitionBtnII.visible = true;
         if(Boolean(this._info))
         {
            if(this._info.IsShowConsortia && Boolean(this._info.ConsortiaName))
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(!this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else if(!this._info.IsShowConsortia && Boolean(this._info.ConsortiaName))
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else
            {
               this._bagDefinitionBtnI.visible = false;
               this._bagDefinitionBtnII.visible = false;
            }
         }
      }
      
      private function createVipAndKing() : void
      {
         if(this._info.IsVIP)
         {
            if(this._vipIcon == null)
            {
               this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.VipIcon");
               this._iconContainer.addChild(this._vipIcon);
            }
            this._vipIcon.setInfo(this._info);
            if(!this._info.IsVIP)
            {
               this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               this._vipIcon.filters = null;
            }
         }
         else if(Boolean(this._vipIcon))
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(this._kingBlessIcon == null)
         {
            this._kingBlessIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.KingBlessIcon",[2]);
            this._iconContainer.addChild(this._kingBlessIcon);
         }
         this._kingBlessIcon.setInfo(this._info.isOpenKingBless,this._info.isSelf);
         if(Boolean(this._marriedIcon))
         {
            if(this._iconContainer.contains(this._marriedIcon))
            {
               this._iconContainer.removeChild(this._marriedIcon);
               this._iconContainer.addChild(this._marriedIcon);
            }
         }
      }
      
      private function getShowAcademyIcon() : Boolean
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               return true;
            }
            return false;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            return true;
         }
         return false;
      }
      
      public function setAchvEnable(val:Boolean) : void
      {
         this._achvEnable = val;
         this.updateShowOperation();
      }
      
      private function _definitionGroupChange(e:Event = null) : void
      {
         if(e != null)
         {
            SoundManager.instance.play("008");
         }
         var arr:Array = EffortManager.Instance.getHonorArray();
         if(arr.length < 1 && !this._info.ConsortiaName)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         if(this._bagDefinitionGroup.selectIndex == 0)
         {
            if(arr.length < 1)
            {
               if(Boolean(e))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notDesignation"));
               }
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(Boolean(e))
            {
               PlayerManager.Instance.Self.IsShowConsortia = false;
               SocketManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETITLE));
            }
         }
         else if(!this._info.ConsortiaName)
         {
            if(Boolean(e))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notSociaty"));
            }
            this._bagDefinitionGroup.selectIndex = 0;
         }
         else if(Boolean(e))
         {
            PlayerManager.Instance.Self.IsShowConsortia = true;
            SocketManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETITLE));
         }
         if(Boolean(e))
         {
            SocketManager.Instance.out.sendChangeDesignation(PlayerManager.Instance.Self.IsShowConsortia);
         }
      }
   }
}

