package room.view.chooseMap
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.BagInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PVEMapPermissionManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ShineSelectButton;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import kingBless.KingBlessManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class DungeonChooseMapView extends Sprite implements Disposeable
   {
      
      public static const DUNGEON_NO:int = 11;
      
      public static const DEFAULT_MAP:int = -1;
      
      private var _titleLoader:DisplayLoader;
      
      private var _preViewLoader:DisplayLoader;
      
      private var _modebg:ScaleBitmapImage;
      
      private var _roomMode:Bitmap;
      
      private var _roomName:FilterFrameText;
      
      private var _roomPass:FilterFrameText;
      
      private var _nameInput:TextInput;
      
      private var _passInput:TextInput;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _modeDescriptionTxt:FilterFrameText;
      
      private var _getExpText:FilterFrameText;
      
      private var _fbMode:FilterFrameText;
      
      private var _topleftbg:ScaleBitmapImage;
      
      private var _getExpBg:Bitmap;
      
      private var _middlebg:MovieClip;
      
      private var _mapbg:MutipleImage;
      
      private var _chooseFB:Bitmap;
      
      private var _dungeonList:SimpleTileList;
      
      private var _maps:Array;
      
      private var _dungeonListContainer:ScrollPanel;
      
      private var _dungeonPreView:Sprite;
      
      private var _descriptionBg:ScaleBitmapImage;
      
      private var _descriptbg:ScaleBitmapImage;
      
      private var _prvviewbg:ScaleBitmapImage;
      
      private var _dungeonTitle:Sprite;
      
      private var _dungeonDescriptionTxt:TextArea;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _mapTypBtn_n:SelectedTextButton;
      
      private var _mapTypBtn_s:SelectedTextButton;
      
      private var _mapTypBtn_a:SelectedTextButton;
      
      private var _selectedDungeonType:int;
      
      private var _enterNumDes:FilterFrameText;
      
      private var _bgBottom:MutipleImage;
      
      private var _diff:Bitmap;
      
      private var _btns:Vector.<ShineSelectButton>;
      
      private var _group:SelectedButtonGroup;
      
      private var _easyBtn:ShineSelectButton;
      
      private var _normalBtn:ShineSelectButton;
      
      private var _hardBtn:ShineSelectButton;
      
      private var _heroBtn:ShineSelectButton;
      
      private var _epicBtn:ShineSelectButton;
      
      private var _bossBtn:SelectedCheckButton;
      
      private var _bossIMG:Bitmap;
      
      private var _bossBtnStrip:StripTip;
      
      private var _grayFilters:Array;
      
      private var _currentSelectedItem:DungeonMapItem;
      
      private var _rect1:Rectangle;
      
      private var _rect2:Rectangle;
      
      private var _rect3:Rectangle;
      
      private var _rect4:Rectangle;
      
      private var _dungeonInfoList:Dictionary;
      
      private var _selectedLevel:int = -1;
      
      private var _freeOpenBossCountBg:Bitmap;
      
      private var _freeOpenBossCountTxt:FilterFrameText;
      
      public function DungeonChooseMapView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var item:DungeonMapItem = null;
         this._modebg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.modeBg");
         addChild(this._modebg);
         this._roomMode = ComponentFactory.Instance.creatBitmap("asset.ddtroom.setView.modeWord");
         addChild(this._roomMode);
         PositionUtils.setPos(this._roomMode,"asset.ddtroom.dungeon.roomModePos");
         this._roomName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.name");
         addChild(this._roomName);
         PositionUtils.setPos(this._roomName,"asset.ddtroom.dungeon.roomNamePos");
         this._roomName.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.roomname");
         this._roomPass = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.password");
         addChild(this._roomPass);
         PositionUtils.setPos(this._roomPass,"asset.ddtroom.dungeon.roomPassPos");
         this._roomPass.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.password");
         this._nameInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.nameInput");
         addChild(this._nameInput);
         this._nameInput.textField.multiline = false;
         this._nameInput.textField.wordWrap = false;
         this._passInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.passInput");
         addChild(this._passInput);
         this._passInput.textField.restrict = "0-9 A-Z a-z";
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.selectBtn");
         addChild(this._checkBox);
         PositionUtils.setPos(this._checkBox,"asset.ddtroom.dungeon.chockBoxPos");
         this._topleftbg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.fbmodebg");
         addChild(this._topleftbg);
         this._fbMode = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.fbmode");
         addChild(this._fbMode);
         this._fbMode.text = LanguageMgr.GetTranslation("ddt.dungeonroom.choseMap.fbmode");
         this._modeDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descript");
         addChild(this._modeDescriptionTxt);
         this._modeDescriptionTxt.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonModeDescription");
         this._getExpBg = ComponentFactory.Instance.creat("asset.room.view.getExpBg");
         addChild(this._getExpBg);
         this._getExpText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.getExpdescript");
         addChild(this._getExpText);
         this._getExpText.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonGetExpDescription",PlayerManager.Instance.Self.DungeonExpReceiveNum,PlayerManager.Instance.Self.DungeonExpTotalNum);
         this._getExpBg.visible = false;
         this._getExpText.visible = false;
         this._middlebg = ClassUtils.CreatInstance("asset.ddtroom.dungeonChoose.middleBg") as MovieClip;
         addChild(this._middlebg);
         PositionUtils.setPos(this._middlebg,"asset.ddtroom.dungeon.middleBgPos");
         this._mapbg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.mapBg");
         addChild(this._mapbg);
         this._chooseFB = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeonChoose.chooseFB");
         addChild(this._chooseFB);
         this._dungeonList = ComponentFactory.Instance.creat("asset.room.view.chooseMap.mapList",[4]);
         this._maps = [];
         for(var i:int = 0; i < DUNGEON_NO; i++)
         {
            if(PathManager.solveDungeonOpenList && PathManager.solveDungeonOpenList.indexOf(String(i)) != -1 || PathManager.solveDungeonOpenList == null)
            {
               item = new DungeonMapItem();
               this._dungeonList.addChild(item);
               item.addEventListener(Event.SELECT,this.__onItemSelect);
               this._maps.push(item);
            }
         }
         this._dungeonListContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeonMapSetScrollPanel");
         this._dungeonListContainer.vScrollProxy = ScrollPanel.ON;
         addChild(this._dungeonListContainer);
         this._dungeonListContainer.setView(this._dungeonList);
         this._descriptionBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBexplainBg");
         addChild(this._descriptionBg);
         this._descriptbg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descriptsmallbg");
         addChild(this._descriptbg);
         this._prvviewbg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.previewbg");
         addChild(this._prvviewbg);
         this._dungeonDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descriptArea");
         addChild(this._dungeonDescriptionTxt);
         this._dungeonDescriptionTxt.textField.selectable = false;
         this._dungeonTitle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonTitle");
         addChild(this._dungeonTitle);
         this._dungeonPreView = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonPreView");
         addChild(this._dungeonPreView);
         this._mapTypBtn_n = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType1");
         this._mapTypBtn_n.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.normal");
         this._mapTypBtn_s = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType2");
         this._mapTypBtn_s.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.spaciel");
         this._mapTypBtn_a = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType4");
         this._mapTypBtn_a.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.activity");
         addChild(this._mapTypBtn_n);
         addChild(this._mapTypBtn_s);
         addChild(this._mapTypBtn_a);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._mapTypBtn_n);
         this._btnGroup.addSelectItem(this._mapTypBtn_s);
         this._btnGroup.addSelectItem(this._mapTypBtn_a);
         if(PathManager.advancedEnable)
         {
            this._mapTypBtn_a = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType3");
            this._mapTypBtn_a.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.advanced");
            addChild(this._mapTypBtn_a);
            this._btnGroup.addSelectItem(this._mapTypBtn_a);
         }
         this._btnGroup.selectIndex = 0;
         this._bgBottom = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.diffChooseBg");
         addChild(this._bgBottom);
         this._diff = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeonChoose.diff");
         addChild(this._diff);
         this._btns = new Vector.<ShineSelectButton>();
         this._group = new SelectedButtonGroup();
         this._easyBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.easyButton");
         addChild(this._easyBtn);
         this._btns.push(this._easyBtn);
         this._group.addSelectItem(this._easyBtn);
         this._normalBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.normalButton");
         addChild(this._normalBtn);
         this._btns.push(this._normalBtn);
         this._group.addSelectItem(this._normalBtn);
         this._hardBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.hardButton");
         addChild(this._hardBtn);
         this._btns.push(this._hardBtn);
         this._group.addSelectItem(this._hardBtn);
         this._heroBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.heroButton");
         addChild(this._heroBtn);
         this._btns.push(this._heroBtn);
         this._group.addSelectItem(this._heroBtn);
         this._epicBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.epicButton");
         addChild(this._epicBtn);
         this._btns.push(this._epicBtn);
         this._group.addSelectItem(this._epicBtn);
         this._easyBtn.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level0");
         this._normalBtn.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level1");
         this._hardBtn.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level2");
         this._heroBtn.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level3");
         this._epicBtn.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level4");
         this._bossBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.dungeonRoom.bossBtn");
         this._bossIMG = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeonChoose.boss");
         this._bossBtn.addChild(this._bossIMG);
         this._bossBtn.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
         addChild(this._bossBtn);
         this._bossBtnStrip = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.bossBtnStrip");
         this._bossBtnStrip.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
         PositionUtils.setPos(this._bossBtnStrip,"ddt.dungeonRoom.bossBtnStripPos");
         addChild(this._bossBtnStrip);
         this._freeOpenBossCountBg = ComponentFactory.Instance.creatBitmap("asset.room.kingbless.freeOpenBossCountBg");
         this._freeOpenBossCountTxt = ComponentFactory.Instance.creatComponentByStylename("room.kingbless.freeOpenBossCountTxt");
         addChild(this._freeOpenBossCountBg);
         addChild(this._freeOpenBossCountTxt);
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._rect1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos1");
         this._rect2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos2");
         this._rect3 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos3");
         this._rect4 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos4");
         this.updateDescription();
         this.updatePreView();
         this.updateLevelBtn();
         this.updateRoomInfo();
         this.initInfo();
         if(this.isBossBtnCanClick() && this._btnGroup.selectIndex != 1)
         {
            this.setBossBtnState(true);
         }
         else
         {
            this.setBossBtnState(false);
         }
         this.refreshFreeOpenBossView();
         if(this._btnGroup.selectIndex == 2)
         {
            this.setBtnVisible();
         }
      }
      
      private function isBossBtnCanClick() : Boolean
      {
         if(PlayerManager.Instance.Self.VIPLevel >= 7 && PlayerManager.Instance.Self.IsVIP)
         {
            return true;
         }
         if(KingBlessManager.instance.openType > 0)
         {
            return true;
         }
         return false;
      }
      
      private function refreshFreeOpenBossView() : void
      {
         var count:int = KingBlessManager.instance.getOneBuffData(KingBlessManager.DUNGEON_HERO);
         if(count <= 0)
         {
            this._freeOpenBossCountBg.visible = false;
            this._freeOpenBossCountTxt.visible = false;
         }
         else
         {
            this._freeOpenBossCountTxt.text = count.toString();
            this._freeOpenBossCountBg.visible = true;
            this._freeOpenBossCountTxt.visible = true;
         }
      }
      
      private function updateRoomInfo() : void
      {
         this._nameInput.text = RoomManager.Instance.current.Name;
         if(Boolean(RoomManager.Instance.current.roomPass))
         {
            this._checkBox.selected = true;
            this._passInput.text = RoomManager.Instance.current.roomPass;
         }
         else
         {
            this._checkBox.selected = false;
         }
         this.upadtePassTextBg();
      }
      
      private function initInfo() : void
      {
         var item:DungeonMapItem = null;
         switch(RoomManager.Instance.current.dungeonType)
         {
            case RoomInfo.DUNGEONTYPE_NO:
               this._btnGroup.selectIndex = 0;
               this.updateCommonItem();
               break;
            case RoomInfo.DUNGEONTYPE_SP:
               this._btnGroup.selectIndex = 1;
               this.updateSpecialItem();
               break;
            case RoomInfo.DUNGEONTYPE_AC:
               this._btnGroup.selectIndex = 2;
               this.updateActivityItem();
               break;
            case RoomInfo.DUNGEONTYPE_AD:
               this._btnGroup.selectIndex = 0;
               this.updateCommonItem();
            default:
               this.updateCommonItem();
         }
         var md:int = RoomManager.Instance.current.mapId;
         if(md > 0 && md != DEFAULT_MAP)
         {
            for each(item in this._maps)
            {
               if(item.mapId == md)
               {
                  this._currentSelectedItem = item;
                  this._currentSelectedItem.selected = true;
               }
            }
            switch(RoomManager.Instance.current.hardLevel)
            {
               case RoomInfo.EASY:
                  this._group.selectIndex = 0;
                  this._selectedLevel = RoomInfo.EASY;
                  break;
               case RoomInfo.NORMAL:
                  this._group.selectIndex = 1;
                  this._selectedLevel = RoomInfo.NORMAL;
                  break;
               case RoomInfo.HARD:
                  this._group.selectIndex = 2;
                  this._selectedLevel = RoomInfo.HARD;
                  break;
               case RoomInfo.HERO:
                  this._group.selectIndex = 3;
                  this._selectedLevel = RoomInfo.HERO;
            }
         }
      }
      
      private function initEvents() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._mapTypBtn_n.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_s.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_a.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._easyBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._normalBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._hardBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._heroBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._epicBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._bossBtn.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
      }
      
      private function removeEvents() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._mapTypBtn_n.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_s.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._mapTypBtn_a.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._easyBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._normalBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._hardBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._heroBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._epicBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._bossBtn.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         if(this._preViewLoader != null)
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         if(Boolean(this._enterNumDes))
         {
            this._enterNumDes.visible = false;
         }
         this._selectedDungeonType = this._btnGroup.selectIndex + 1;
         if(this._btnGroup.selectIndex == 0)
         {
            this.refreshFreeOpenBossView();
            if(this.isBossBtnCanClick())
            {
               this.setBossBtnState(true);
            }
            this.updateCommonItem();
         }
         else if(this._btnGroup.selectIndex == 1)
         {
            this.refreshFreeOpenBossView();
            this.setBossBtnState(false);
            this.updateSpecialItem();
         }
         else if(this._btnGroup.selectIndex == 2)
         {
            this.setBtnVisible();
            this.updateActivityItem();
         }
         else
         {
            if(this.isBossBtnCanClick())
            {
               this.refreshFreeOpenBossView();
               this.setBossBtnState(true);
            }
            else
            {
               this.setBossBtnState(false);
            }
            this.updateAdvancedItem();
         }
      }
      
      private function setBtnVisible() : void
      {
         this._bossBtn.visible = false;
         this._bossBtnStrip.visible = false;
         this._freeOpenBossCountBg.visible = false;
         this._freeOpenBossCountTxt.visible = false;
      }
      
      private function addEnterNumInfo() : void
      {
         var ticketCount:int = 0;
         switch(this._currentSelectedItem.mapId)
         {
            case 70001:
               if(Boolean(this._enterNumDes))
               {
                  removeChild(this._enterNumDes);
               }
               this._enterNumDes = ComponentFactory.Instance.creatComponentByStylename("room.tanabata.enterCountTxt");
               this._enterNumDes.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.todayEnterNum",PlayerManager.Instance.Self.activityTanabataNum.toString(),ServerConfigManager.instance.activityEnterNum.toString());
               addChild(this._enterNumDes);
               break;
            case 12016:
               if(Boolean(this._enterNumDes))
               {
                  removeChild(this._enterNumDes);
               }
               this._enterNumDes = ComponentFactory.Instance.creatComponentByStylename("room.tanabata.enterCountTxt");
               ticketCount = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(11742);
               this._enterNumDes.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.enterTicketCount",ticketCount,"1");
               addChild(this._enterNumDes);
         }
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __checkBoxClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._checkBox:
               this.upadtePassTextBg();
               break;
            case this._bossBtn:
               this.checkState();
         }
      }
      
      private function updateAdvancedItem() : void
      {
         var item:DungeonMapItem = null;
         this.reset();
         var j:int = 0;
         for(var i:int = 1; i < DUNGEON_NO; i++)
         {
            if(Boolean(MapManager.getByOrderingAdvancedDungeonInfo(i)))
            {
               item = this._maps[j++] as DungeonMapItem;
               item.mapId = MapManager.getByOrderingAdvancedDungeonInfo(i).ID;
            }
         }
      }
      
      private function updateCommonItem() : void
      {
         var dungeonInfo:DungeonInfo = null;
         var item:DungeonMapItem = null;
         this.reset();
         var j:int = 0;
         for(var i:int = 1; i < DUNGEON_NO; i++)
         {
            dungeonInfo = MapManager.getByOrderingDungeonInfo(i);
            if(Boolean(dungeonInfo))
            {
               item = this._maps[j++] as DungeonMapItem;
               item.mapId = dungeonInfo.ID;
               item.setLimitLevel(dungeonInfo.MinLv,dungeonInfo.MaxLv);
            }
         }
      }
      
      private function updateSpecialItem() : void
      {
         var dungeonInfo:DungeonInfo = null;
         var item:DungeonMapItem = null;
         this.reset();
         for(var i:int = 1; i < DUNGEON_NO; i++)
         {
            dungeonInfo = MapManager.getByOrderingAcademyDungeonInfo(i);
            if(Boolean(dungeonInfo))
            {
               item = this._maps[i - 1] as DungeonMapItem;
               item.mapId = MapManager.getByOrderingAcademyDungeonInfo(i).ID;
               item.setLimitLevel(dungeonInfo.MinLv,dungeonInfo.MaxLv);
            }
         }
      }
      
      private function updateActivityItem() : void
      {
         var dungeonInfo:DungeonInfo = null;
         var item:DungeonMapItem = null;
         this.reset();
         for(var i:int = 1; i < DUNGEON_NO; i++)
         {
            dungeonInfo = MapManager.getByOrderingActivityDungeonInfo(i);
            if(Boolean(dungeonInfo))
            {
               item = this._maps[i - 1] as DungeonMapItem;
               item.mapId = MapManager.getByOrderingActivityDungeonInfo(i).ID;
               item.setLimitLevel(dungeonInfo.MinLv,dungeonInfo.MaxLv);
            }
         }
      }
      
      private function reset() : void
      {
         var item:DungeonMapItem = null;
         this.InitChooseMapState();
         for(var i:int = 1; i < this._maps.length; i++)
         {
            item = this._maps[i - 1] as DungeonMapItem;
            item.selected = false;
            item.stopShine();
            item.mapId = DEFAULT_MAP;
         }
         for(var j:int = 0; j < this._btns.length; j++)
         {
            this._btns[j].selected = false;
            this._btns[j].stopShine();
         }
      }
      
      private function InitChooseMapState() : void
      {
         this._currentSelectedItem = null;
         this._normalBtn.visible = this._hardBtn.visible = this._heroBtn.visible = true;
         this._epicBtn.visible = false;
         this._normalBtn.enable = this._hardBtn.enable = this._heroBtn.enable = false;
         this._epicBtn.enable = false;
         this.adaptButtons(0);
         ObjectUtils.disposeAllChildren(this._dungeonPreView);
         if(Boolean(this._preViewLoader))
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
         this._preViewLoader = LoadResourceManager.Instance.createLoader(PathManager.SITE_MAIN + "image/map/10000/samll_map.png",BaseLoader.BITMAP_LOADER);
         this._preViewLoader.addEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         LoadResourceManager.Instance.startLoad(this._preViewLoader);
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         this._titleLoader = LoadResourceManager.Instance.createLoader(PathManager.SITE_MAIN + "image/map/10000/icon.png",BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         LoadResourceManager.Instance.startLoad(this._titleLoader);
         this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
      }
      
      private function upadtePassTextBg() : void
      {
         if(this._checkBox.selected)
         {
            this._passInput.mouseChildren = true;
            this._passInput.mouseEnabled = true;
            this._passInput.setFocus();
         }
         else
         {
            this._passInput.mouseChildren = false;
            this._passInput.mouseEnabled = false;
            this._passInput.text = "";
         }
      }
      
      public function get roomName() : String
      {
         return this._nameInput.text;
      }
      
      public function get roomPass() : String
      {
         return this._passInput.text;
      }
      
      public function get selectedDungeonType() : int
      {
         return this._selectedDungeonType;
      }
      
      public function get select() : Boolean
      {
         return this._bossBtn.selected;
      }
      
      private function __onItemSelect(evt:Event) : void
      {
         var btn:ShineSelectButton = null;
         this._bossBtn.selected = false;
         var targetMap:DungeonMapItem = evt.target as DungeonMapItem;
         if(Boolean(this._currentSelectedItem) && this._currentSelectedItem != targetMap)
         {
            this._currentSelectedItem.selected = false;
         }
         this._currentSelectedItem = targetMap;
         this.stopShineMap();
         this.stopShineLevelBtn();
         for each(btn in this._btns)
         {
            btn.selected = false;
         }
         this._selectedLevel = -1;
         this.updateDescription();
         this.updatePreView();
         this.updateLevelBtn();
         this.addEnterNumInfo();
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_3))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"guide.dungeon.step4ArrowPos","asset.trainer.dungeonGuide4Txt","guide.dungeon.step4TipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function showAlert() : void
      {
         var alert:Frame = ComponentFactory.Instance.creat("room.FifthPreview");
         alert.addEventListener(FrameEvent.RESPONSE,this.__onPreResponse);
         alert.escEnable = true;
         LayerManager.Instance.addToLayer(alert,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onPreResponse(event:FrameEvent) : void
      {
         var alert:Frame = event.target as Frame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onPreResponse);
         alert.dispose();
      }
      
      private function __btnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.stopShineLevelBtn();
         switch(evt.currentTarget)
         {
            case this._easyBtn:
               this._selectedLevel = DungeonInfo.EASY;
               break;
            case this._normalBtn:
               this._selectedLevel = DungeonInfo.NORMAL;
               break;
            case this._hardBtn:
               this._selectedLevel = DungeonInfo.HARD;
               break;
            case this._heroBtn:
               this._selectedLevel = DungeonInfo.HERO;
               break;
            case this._epicBtn:
               this._selectedLevel = DungeonInfo.EPIC;
         }
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_3))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"guide.dungeon.step5ArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function updateDescription() : void
      {
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         }
         this._titleLoader = LoadResourceManager.Instance.createLoader(this.solveTitlePath(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
         LoadResourceManager.Instance.startLoad(this._titleLoader);
         if(Boolean(this._currentSelectedItem))
         {
            this._dungeonDescriptionTxt.text = MapManager.getDungeonInfo(this._currentSelectedItem.mapId).Description;
         }
         else
         {
            this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         }
      }
      
      private function solveTitlePath() : String
      {
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(Boolean(this._currentSelectedItem))
         {
            result += this._currentSelectedItem.mapId.toString() + "/icon.png";
         }
         else
         {
            result += "10000/icon.png";
         }
         return result;
      }
      
      private function updatePreView() : void
      {
         ObjectUtils.disposeAllChildren(this._dungeonPreView);
         if(Boolean(this._preViewLoader))
         {
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
         this._preViewLoader = LoadResourceManager.Instance.createLoader(this.solvePreViewPath(),BaseLoader.BITMAP_LOADER);
         this._preViewLoader.addEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
         LoadResourceManager.Instance.startLoad(this._preViewLoader);
      }
      
      private function solvePreViewPath() : String
      {
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(Boolean(this._currentSelectedItem))
         {
            result += this._currentSelectedItem.mapId.toString() + "/samll_map.png";
         }
         else
         {
            result += "10000/samll_map.png";
         }
         return result;
      }
      
      private function setBossBtnState(value:Boolean) : void
      {
         this._bossBtn.visible = true;
         if(value)
         {
            this._bossBtnStrip.visible = false;
            this._bossBtn.mouseEnabled = this._bossBtn.buttonMode = true;
            this._bossBtn.filters = null;
         }
         else
         {
            this._bossBtnStrip.visible = true;
            this._bossBtn.mouseEnabled = this._bossBtn.buttonMode = false;
            this._bossBtn.filters = this._grayFilters;
         }
         this._bossBtn.selected = false;
      }
      
      private function updateLevelBtn() : void
      {
         this._easyBtn.visible = this._normalBtn.visible = this._hardBtn.visible = this._heroBtn.visible = true;
         this._epicBtn.visible = false;
         this._easyBtn.enable = this._normalBtn.enable = this._hardBtn.enable = this._heroBtn.enable = false;
         this._epicBtn.enable = false;
         if(Boolean(this._currentSelectedItem) && MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)
         {
            this.adaptButtons(this._currentSelectedItem.mapId);
            if(this._currentSelectedItem.mapId != 70001 && this._currentSelectedItem.mapId != 12016)
            {
               this._easyBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,0);
               this._normalBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,1);
               this._hardBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,2);
               this._heroBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId,3);
               this._epicBtn.enable = PVEMapPermissionManager.Instance.getPveMapEpicPermission(this._currentSelectedItem.mapId,PlayerManager.Instance.Self.PveEpicPermission);
            }
         }
         else
         {
            this.adaptButtons(0);
         }
      }
      
      private function adaptButtons(id:int) : void
      {
         var dungeonInfo:DungeonInfo = MapManager.getDungeonInfo(id);
         if(!dungeonInfo)
         {
            this._easyBtn.visible = false;
            this._normalBtn.x = this._rect3.x;
            this._hardBtn.x = this._rect3.y;
            this._heroBtn.x = this._rect3.width;
            return;
         }
         this._easyBtn.visible = dungeonInfo.SimpleTemplateIds != "";
         this._normalBtn.visible = dungeonInfo.NormalTemplateIds != "";
         this._hardBtn.visible = dungeonInfo.HardTemplateIds != "";
         this._heroBtn.visible = dungeonInfo.TerrorTemplateIds != "";
         this._epicBtn.visible = dungeonInfo.EpicTemplateIds != "";
         var visibleBtn:Vector.<ShineSelectButton> = new Vector.<ShineSelectButton>();
         for(var i:int = 0; i < this._btns.length; i++)
         {
            if(this._btns[i].visible)
            {
               visibleBtn.push(this._btns[i]);
            }
         }
         switch(visibleBtn.length)
         {
            case 0:
               break;
            case 1:
               visibleBtn[0].visible = false;
               switch(visibleBtn[0])
               {
                  case this._easyBtn:
                     this._selectedLevel = DungeonInfo.EASY;
                     break;
                  case this._normalBtn:
                     this._selectedLevel = DungeonInfo.NORMAL;
                     break;
                  case this._hardBtn:
                     this._selectedLevel = DungeonInfo.HARD;
                     break;
                  case this._heroBtn:
                     this._selectedLevel = DungeonInfo.HERO;
               }
               break;
            case 2:
               visibleBtn[0].x = this._rect2.x;
               visibleBtn[1].x = this._rect2.y;
               break;
            case 3:
               visibleBtn[0].x = this._rect3.x;
               visibleBtn[1].x = this._rect3.y;
               visibleBtn[2].x = this._rect3.width;
               break;
            case 4:
               visibleBtn[0].x = this._rect1.x;
               visibleBtn[1].x = this._rect1.y;
               visibleBtn[2].x = this._rect1.width;
               visibleBtn[3].x = this._rect1.height;
               break;
            case 5:
               visibleBtn[0].x = this._rect4.x;
               visibleBtn[1].x = this._rect4.y;
               visibleBtn[2].x = this._rect4.width;
               visibleBtn[3].x = this._rect4.height;
         }
      }
      
      private function __onTitleComplete(evt:LoaderEvent) : void
      {
         if(this._dungeonTitle && this._titleLoader && this._titleLoader.content)
         {
            ObjectUtils.disposeAllChildren(this._dungeonTitle);
            this._dungeonTitle.addChild(Bitmap(this._titleLoader.content));
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onTitleComplete);
            this._titleLoader = null;
         }
      }
      
      private function __onPreViewComplete(evt:LoaderEvent) : void
      {
         if(this._dungeonPreView && this._preViewLoader && this._preViewLoader.content)
         {
            ObjectUtils.disposeAllChildren(this._dungeonPreView);
            this._dungeonPreView.addChild(Bitmap(this._preViewLoader.content));
            this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onPreViewComplete);
            this._preViewLoader = null;
         }
      }
      
      public function dispose() : void
      {
         var item:DungeonMapItem = null;
         this.removeEvents();
         for each(item in this._maps)
         {
            item.removeEventListener(Event.SELECT,this.__onItemSelect);
         }
         this._titleLoader = null;
         this._preViewLoader = null;
         if(Boolean(this._modebg))
         {
            ObjectUtils.disposeObject(this._modebg);
         }
         this._modebg = null;
         if(Boolean(this._roomMode))
         {
            ObjectUtils.disposeObject(this._roomMode);
         }
         this._roomMode = null;
         if(Boolean(this._roomName))
         {
            ObjectUtils.disposeObject(this._roomName);
         }
         this._roomName = null;
         if(Boolean(this._roomPass))
         {
            ObjectUtils.disposeObject(this._roomPass);
         }
         this._roomPass = null;
         if(Boolean(this._nameInput))
         {
            ObjectUtils.disposeObject(this._nameInput);
         }
         this._nameInput = null;
         if(Boolean(this._passInput))
         {
            ObjectUtils.disposeObject(this._passInput);
         }
         this._passInput = null;
         if(Boolean(this._checkBox))
         {
            ObjectUtils.disposeObject(this._checkBox);
         }
         this._checkBox = null;
         if(Boolean(this._modeDescriptionTxt))
         {
            ObjectUtils.disposeObject(this._modeDescriptionTxt);
         }
         this._modeDescriptionTxt = null;
         if(Boolean(this._fbMode))
         {
            ObjectUtils.disposeObject(this._fbMode);
         }
         this._fbMode = null;
         if(Boolean(this._topleftbg))
         {
            ObjectUtils.disposeObject(this._topleftbg);
         }
         this._topleftbg = null;
         if(Boolean(this._getExpText))
         {
            ObjectUtils.disposeObject(this._getExpText);
         }
         this._getExpText = null;
         if(Boolean(this._middlebg))
         {
            ObjectUtils.disposeObject(this._middlebg);
         }
         this._middlebg = null;
         if(Boolean(this._mapbg))
         {
            ObjectUtils.disposeObject(this._mapbg);
         }
         this._mapbg = null;
         if(Boolean(this._chooseFB))
         {
            ObjectUtils.disposeObject(this._chooseFB);
         }
         this._chooseFB = null;
         if(Boolean(this._dungeonList))
         {
            ObjectUtils.disposeObject(this._dungeonList);
         }
         this._dungeonList = null;
         if(Boolean(this._dungeonListContainer))
         {
            ObjectUtils.disposeObject(this._dungeonListContainer);
         }
         this._dungeonListContainer = null;
         if(Boolean(this._dungeonPreView))
         {
            ObjectUtils.disposeObject(this._dungeonPreView);
         }
         this._dungeonPreView = null;
         if(Boolean(this._descriptionBg))
         {
            ObjectUtils.disposeObject(this._descriptionBg);
         }
         this._descriptionBg = null;
         if(Boolean(this._descriptbg))
         {
            ObjectUtils.disposeObject(this._descriptbg);
         }
         this._descriptbg = null;
         if(Boolean(this._prvviewbg))
         {
            ObjectUtils.disposeObject(this._prvviewbg);
         }
         this._prvviewbg = null;
         if(Boolean(this._dungeonTitle))
         {
            ObjectUtils.disposeObject(this._dungeonTitle);
         }
         this._dungeonTitle = null;
         if(Boolean(this._dungeonDescriptionTxt))
         {
            ObjectUtils.disposeObject(this._dungeonDescriptionTxt);
         }
         this._dungeonDescriptionTxt = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._mapTypBtn_n))
         {
            ObjectUtils.disposeObject(this._mapTypBtn_n);
         }
         this._mapTypBtn_n = null;
         if(Boolean(this._mapTypBtn_s))
         {
            ObjectUtils.disposeObject(this._mapTypBtn_s);
         }
         this._mapTypBtn_s = null;
         if(Boolean(this._mapTypBtn_a))
         {
            ObjectUtils.disposeObject(this._mapTypBtn_a);
         }
         this._mapTypBtn_a = null;
         if(Boolean(this._enterNumDes))
         {
            ObjectUtils.disposeObject(this._enterNumDes);
         }
         this._enterNumDes = null;
         if(Boolean(this._bgBottom))
         {
            ObjectUtils.disposeObject(this._bgBottom);
         }
         this._bgBottom = null;
         if(Boolean(this._diff))
         {
            ObjectUtils.disposeObject(this._diff);
         }
         this._diff = null;
         if(Boolean(this._group))
         {
            ObjectUtils.disposeObject(this._group);
         }
         this._group = null;
         if(Boolean(this._easyBtn))
         {
            ObjectUtils.disposeObject(this._easyBtn);
         }
         this._easyBtn = null;
         if(Boolean(this._normalBtn))
         {
            ObjectUtils.disposeObject(this._normalBtn);
         }
         this._normalBtn = null;
         if(Boolean(this._hardBtn))
         {
            ObjectUtils.disposeObject(this._hardBtn);
         }
         this._hardBtn = null;
         if(Boolean(this._heroBtn))
         {
            ObjectUtils.disposeObject(this._heroBtn);
         }
         this._heroBtn = null;
         if(Boolean(this._epicBtn))
         {
            ObjectUtils.disposeObject(this._epicBtn);
         }
         this._epicBtn = null;
         if(Boolean(this._bossBtn))
         {
            ObjectUtils.disposeObject(this._bossBtn);
         }
         this._bossBtn = null;
         if(Boolean(this._bossBtnStrip))
         {
            ObjectUtils.disposeObject(this._bossBtnStrip);
         }
         this._bossBtnStrip = null;
         for(var i:int = 0; i < this._btns.length; i++)
         {
            if(Boolean(this._btns[i]))
            {
               ObjectUtils.disposeObject(this._btns[i]);
            }
            this._btns[i] = null;
         }
         this._btns = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function checkState() : Boolean
      {
         if(!this._currentSelectedItem)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.selectDuplicate"));
            this._bossBtn.selected = false;
            this.shineMap();
            return false;
         }
         if(!MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.duplicate.notOpen"));
            return false;
         }
         if(this._selectedLevel < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.choicePermissionType"));
            this._bossBtn.selected = false;
            this.shineLevelBtn();
            return false;
         }
         if(FilterWordManager.IsNullorEmpty(this._nameInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            SoundManager.instance.play("008");
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._nameInput.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            SoundManager.instance.play("008");
            return false;
         }
         if(this._checkBox.selected && FilterWordManager.IsNullorEmpty(this._passInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            SoundManager.instance.play("008");
            return false;
         }
         return true;
      }
      
      private function shineMap() : void
      {
         var item:DungeonMapItem = null;
         for each(item in this._maps)
         {
            if(item.mapId > 0)
            {
               item.shine();
            }
         }
      }
      
      private function stopShineMap() : void
      {
         var item:DungeonMapItem = null;
         for each(item in this._maps)
         {
            item.stopShine();
         }
      }
      
      private function shineLevelBtn() : void
      {
         var btn:ShineSelectButton = null;
         for each(btn in this._btns)
         {
            if(btn.enable)
            {
               btn.shine();
            }
         }
      }
      
      private function stopShineLevelBtn() : void
      {
         var btn:ShineSelectButton = null;
         for each(btn in this._btns)
         {
            btn.stopShine();
         }
      }
      
      public function get selectedMapID() : int
      {
         return Boolean(this._currentSelectedItem) ? this._currentSelectedItem.mapId : 0;
      }
      
      public function get selectedLevel() : int
      {
         return this._selectedLevel;
      }
   }
}

