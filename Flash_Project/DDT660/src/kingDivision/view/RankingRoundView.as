package kingDivision.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingDivision.KingDivisionManager;
   import kingDivision.data.KingDivisionConsortionItemInfo;
   import kingDivision.data.KingDivisionPackageType;
   
   public class RankingRoundView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _winBg:Bitmap;
      
      private var _proBar:ProgressBarView;
      
      private var _points:FilterFrameText;
      
      private var _awardsBtn:BaseButton;
      
      private var _numberImg:Bitmap;
      
      private var _numberTxt:FilterFrameText;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _cup:Bitmap;
      
      private var _base:Bitmap;
      
      private var _info:PlayerInfo;
      
      private var _character:RoomCharacter;
      
      private var _fireWorkds:MovieClip;
      
      private var _zone:int;
      
      private var _kingImg:Bitmap;
      
      private var _kingBase:Bitmap;
      
      private var _kingTxt:GradientText;
      
      private var _items:Vector.<KingCell>;
      
      private var _itemsEight:Vector.<KingCell>;
      
      private var _itemsFour:Vector.<KingCell>;
      
      private var _itemsTwo:Vector.<KingCell>;
      
      private var _blind:Bitmap;
      
      private var _match:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _timerUpdate:Timer;
      
      private var eliminateInfo:Vector.<KingDivisionConsortionItemInfo>;
      
      private var eliminateAllZoneInfo:Vector.<KingDivisionConsortionItemInfo>;
      
      private var isWin:Boolean;
      
      private var index:int = 0;
      
      private var isConsortiaID:Boolean;
      
      private var _areaStyle:String;
      
      private var _areaSex:Boolean;
      
      private var _areaConsortionName:String;
      
      private var isCheckTime:Boolean;
      
      public function RankingRoundView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.16gameframe");
         this._winBg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.winframe");
         this._winBg.visible = false;
         this._points = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.pointsTxt");
         this._points.text = KingDivisionManager.Instance.points.toString();
         this._awardsBtn = ComponentFactory.Instance.creat("rankingRoundView.awardsBtn");
         this._numberImg = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.number");
         this._numberTxt = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.numberTxt");
         this._numberTxt.text = KingDivisionManager.Instance.gameNum.toString();
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.startBtn");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.cancelBtn");
         this._cancelBtn.visible = false;
         this._cup = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.cup");
         this._base = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.base");
         this._blind = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.blind");
         this._blind.visible = false;
         this._match = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.match");
         this._match.visible = false;
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.rankingRoundView.timeTxt");
         addChild(this._bg);
         addChild(this._winBg);
         addChild(this._points);
         addChild(this._awardsBtn);
         addChild(this._numberImg);
         addChild(this._numberTxt);
         addChild(this._startBtn);
         addChild(this._cancelBtn);
         addChild(this._base);
         addChild(this._cup);
         addChild(this._blind);
         addChild(this._match);
         addChild(this._timeTxt);
         this.createCell(1,16);
         this.createCell(2,8);
         this.createCell(3,4);
         this.createCell(4,2);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timerUpdate = new Timer(60000);
         this._timerUpdate.addEventListener(TimerEvent.TIMER,this.__updateConsortionMessage);
         this._timerUpdate.start();
         this.playerIsConsortion();
         this.checkGameStartTimer();
      }
      
      private function addEvent() : void
      {
         this._awardsBtn.addEventListener(MouseEvent.CLICK,this.__onClickAwardsBtn);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._awardsBtn.removeEventListener(MouseEvent.CLICK,this.__onClickAwardsBtn);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         this._timerUpdate.removeEventListener(TimerEvent.TIMER,this.__updateConsortionMessage);
      }
      
      private function __onStartBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._timerUpdate.stop();
         if(!KingDivisionManager.Instance.checkGameTimeIsOpen())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.checkGameTimesIsOpen"));
            return;
         }
         if(KingDivisionManager.Instance.gameNum <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.gameNum"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < KingDivisionManager.Instance.level)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.gameLevel",KingDivisionManager.Instance.level));
            return;
         }
         if(KingDivisionManager.Instance.checkCanStartGame())
         {
            this.startGame();
         }
      }
      
      private function startGame() : void
      {
         var type:int = 0;
         if(KingDivisionManager.Instance.states == 1)
         {
            type = KingDivisionPackageType.CONSORTIA_MATCH_FIGHT;
         }
         else if(KingDivisionManager.Instance.states == 2)
         {
            type = KingDivisionPackageType.CONSORTIA_MATCH_FIGHT_AREA;
         }
         GameInSocketOut.sendKingDivisionGameStart(type);
      }
      
      private function __onCancelBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.cancelMatch();
      }
      
      public function cancelMatch() : void
      {
         this._timerUpdate.start();
         this._startBtn.visible = true;
         this._awardsBtn.mouseEnabled = true;
         this._cancelBtn.visible = false;
         this._blind.visible = false;
         this._match.visible = false;
         this._timeTxt.text = "";
         this._timer.stop();
         this._timer.reset();
         GameInSocketOut.sendCancelWait();
      }
      
      private function playerIsConsortion() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID <= 0)
         {
            this._startBtn.visible = false;
            this._cancelBtn.visible = false;
            this._blind.visible = false;
            this._match.visible = false;
            if(Boolean(this._numberImg))
            {
               ObjectUtils.disposeObject(this._numberImg);
               this._numberImg = null;
            }
            if(Boolean(this._numberTxt))
            {
               ObjectUtils.disposeObject(this._numberTxt);
               this._numberTxt = null;
            }
            return;
         }
         this._startBtn.visible = true;
      }
      
      public function updateMessage(score:int, gameNum:int) : void
      {
         this._points.text = score.toString();
         this._numberTxt.text = gameNum.toString();
      }
      
      private function __timer(evt:TimerEvent) : void
      {
         var min:uint = this._timer.currentCount / 60;
         var sec:uint = this._timer.currentCount % 60;
         this._timeTxt.text = sec > 9 ? sec.toString() : "0" + sec;
      }
      
      public function updateButtons() : void
      {
         this._startBtn.visible = false;
         this._awardsBtn.mouseEnabled = false;
         if(Boolean(this._cancelBtn))
         {
            ObjectUtils.disposeObject(this._cancelBtn);
            this._cancelBtn = null;
         }
         if(Boolean(this._blind))
         {
            ObjectUtils.disposeObject(this._blind);
            this._blind = null;
         }
         if(Boolean(this._match))
         {
            ObjectUtils.disposeObject(this._match);
            this._match = null;
         }
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.cancelBtn");
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
         this._cancelBtn.visible = true;
         this._blind = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.blind");
         this._blind.visible = true;
         this._match = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.match");
         this._match.visible = true;
         addChild(this._blind);
         addChild(this._match);
         addChild(this._cancelBtn);
         if(Boolean(this._timer) && !this._timer.running)
         {
            if(Boolean(this._timeTxt))
            {
               ObjectUtils.disposeObject(this._timeTxt);
               this._timeTxt = null;
            }
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.rankingRoundView.timeTxt");
            this._timeTxt.text = "00";
            addChild(this._timeTxt);
            this._timer.start();
         }
      }
      
      private function createCell(round:int, count:int) : void
      {
         var cell:KingCell = null;
         if(round == 1)
         {
            this._items = new Vector.<KingCell>(1);
         }
         else if(round == 2)
         {
            this._itemsEight = new Vector.<KingCell>(1);
         }
         else if(round == 3)
         {
            this._itemsFour = new Vector.<KingCell>(1);
         }
         else if(round == 4)
         {
            this._itemsTwo = new Vector.<KingCell>(1);
         }
         for(var i:int = 1; i <= count; i++)
         {
            cell = ComponentFactory.Instance.creatCustomObject("kingdivision.rankingRoundView." + round + "." + i);
            cell.mouseEnabled = true;
            cell.index = round;
            addChild(cell);
            if(round == 1)
            {
               this._items.push(cell);
            }
            else if(round == 2)
            {
               this._itemsEight.push(cell);
            }
            else if(round == 3)
            {
               this._itemsFour.push(cell);
            }
            else if(round == 4)
            {
               this._itemsTwo.push(cell);
            }
         }
      }
      
      public function set progressBarView(value:ProgressBarView) : void
      {
         this._proBar = value;
      }
      
      public function set zone(value:int) : void
      {
         this._zone = value;
         this.updateCell();
      }
      
      private function updateCell() : void
      {
         if(this._zone == 0)
         {
            this.eliminateInfo = KingDivisionManager.Instance.model.eliminateInfo;
            this.promotion(this.eliminateInfo);
         }
         else if(this._zone == 1)
         {
            this.eliminateAllZoneInfo = KingDivisionManager.Instance.model.eliminateAllZoneInfo;
            this.promotion(this.eliminateAllZoneInfo);
         }
      }
      
      private function promotion(info:Vector.<KingDivisionConsortionItemInfo>) : void
      {
         if(info == null)
         {
            return;
         }
         var date:Date = TimeManager.Instance.Now();
         var dateArr:Array = KingDivisionManager.Instance.dateArr;
         var dateArrArea:Array = KingDivisionManager.Instance.allDateArr;
         if(this._zone == 0)
         {
            this.topSixteen(info);
            if(dateArr[1] <= date.date)
            {
               this.promotionGuild(this._items,this._itemsEight,1,9,16);
            }
            if(dateArr[2] <= date.date)
            {
               this.promotionGuild(this._itemsEight,this._itemsFour,2,5,8);
            }
            if(dateArr[3] <= date.date)
            {
               this.promotionGuild(this._itemsFour,this._itemsTwo,3,3,4);
            }
            if(dateArr[4] <= date.date)
            {
               this.topOne();
            }
         }
         else if(this._zone == 1)
         {
            this.topSixteenArea(info);
            if(dateArrArea[1] <= date.date)
            {
               this.promotionGuildArea(this._items,this._itemsEight,1,9,16);
            }
            if(dateArrArea[1] <= date.date)
            {
               this.promotionGuildArea(this._itemsEight,this._itemsFour,2,5,8);
            }
            if(dateArrArea[1] <= date.date)
            {
               this.promotionGuildArea(this._itemsFour,this._itemsTwo,3,3,4);
            }
            if(dateArrArea[1] <= date.date)
            {
               this.topOneArea();
            }
         }
         if(Boolean(this._cup))
         {
            ObjectUtils.disposeObject(this._cup);
            this._cup = null;
         }
         if(Boolean(this._base))
         {
            ObjectUtils.disposeObject(this._base);
            this._base = null;
         }
         this._cup = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.cup");
         this._base = ComponentFactory.Instance.creatBitmap("asset.rankingRoundView.base");
         addChild(this._base);
         addChild(this._cup);
         if(this.isWin)
         {
            this.championMC();
         }
         if(!this.isConsortiaID)
         {
            this.rankNoMeConsortion();
         }
      }
      
      private function topSixteen(eliminateInfo:Vector.<KingDivisionConsortionItemInfo>) : void
      {
         if(eliminateInfo == null)
         {
            return;
         }
         this.index = 0;
         for(var i:int = 1; i <= 16; i++)
         {
            if(this.index >= eliminateInfo.length)
            {
               break;
            }
            if(eliminateInfo[this.index].conState >= 0)
            {
               if(this.isConsortiaID || i <= eliminateInfo.length && PlayerManager.Instance.Self.ConsortiaID == eliminateInfo[i - 1].conID && eliminateInfo[i - 1].isGame)
               {
                  this.isConsortiaID = true;
               }
               else
               {
                  this.isConsortiaID = false;
               }
               if(i % 2 != 0)
               {
                  if(this.index < 4)
                  {
                     this._items[i].setNickName(eliminateInfo[this.index],"right");
                  }
                  else
                  {
                     this._items[i].setNickName(eliminateInfo[this.index]);
                  }
                  ++this.index;
               }
               else if(this.index + 7 < eliminateInfo.length)
               {
                  if(this.index + 7 < 12)
                  {
                     this._items[i].setNickName(eliminateInfo[this.index + 7],"right");
                  }
                  else
                  {
                     this._items[i].setNickName(eliminateInfo[this.index + 7]);
                  }
               }
            }
         }
      }
      
      private function topSixteenArea(info:Vector.<KingDivisionConsortionItemInfo>) : void
      {
         if(info == null)
         {
            return;
         }
         this.index = 0;
         for(var i:int = 1; i <= 16; i++)
         {
            if(this.index >= info.length)
            {
               break;
            }
            if(info[this.index].consortionState >= 0)
            {
               if(this.isConsortiaID || i <= info.length && PlayerManager.Instance.Self.ConsortiaID == info[i - 1].consortionIDArea && info[i - 1].consortionIsGame)
               {
                  this.isConsortiaID = true;
               }
               else
               {
                  this.isConsortiaID = false;
               }
               if(i % 2 != 0)
               {
                  if(this.index < 4)
                  {
                     this._items[i].setNickName(info[this.index],"right");
                  }
                  else
                  {
                     this._items[i].setNickName(info[this.index]);
                  }
                  ++this.index;
               }
               else if(this.index + 7 < info.length)
               {
                  if(this.index + 7 < 12)
                  {
                     this._items[i].setNickName(info[this.index + 7],"right");
                  }
                  else
                  {
                     this._items[i].setNickName(info[this.index + 7]);
                  }
               }
            }
         }
      }
      
      private function promotionGuild(cell:Vector.<KingCell>, proCell:Vector.<KingCell>, state:int, num:int, linkName:int) : void
      {
         var bitMap:Bitmap = null;
         this.index = 1;
         for(var i:int = 1; i < cell.length; i++)
         {
            if(cell[i]._playerInfo != null)
            {
               if(cell[i]._playerInfo.conState >= state)
               {
                  if(this.isConsortiaID || PlayerManager.Instance.Self.ConsortiaID == cell[i]._playerInfo.conID && cell[i]._playerInfo.isGame)
                  {
                     this.isConsortiaID = true;
                  }
                  else
                  {
                     this.isConsortiaID = false;
                  }
                  if(i < num)
                  {
                     proCell[this.index].setNickName(cell[i]._playerInfo,"right");
                  }
                  else
                  {
                     proCell[this.index].setNickName(cell[i]._playerInfo);
                  }
                  bitMap = ComponentFactory.Instance.creatBitmap("asst.kingdivision." + linkName + "." + i);
                  addChild(bitMap);
                  ++this.index;
               }
            }
         }
      }
      
      private function promotionGuildArea(cell:Vector.<KingCell>, proCell:Vector.<KingCell>, state:int, num:int, linkName:int) : void
      {
         var bitMap:Bitmap = null;
         this.index = 1;
         for(var i:int = 1; i < cell.length; i++)
         {
            if(cell[i]._playerInfo != null)
            {
               if(cell[i]._playerInfo.consortionState >= state)
               {
                  if(this.isConsortiaID || PlayerManager.Instance.Self.ConsortiaID == cell[i]._playerInfo.consortionIDArea && PlayerManager.Instance.Self.ZoneID == cell[i]._playerInfo.areaID && cell[i]._playerInfo.consortionIsGame)
                  {
                     this.isConsortiaID = true;
                  }
                  else
                  {
                     this.isConsortiaID = false;
                  }
                  if(i < num)
                  {
                     proCell[this.index].setNickName(cell[i]._playerInfo,"right");
                  }
                  else
                  {
                     proCell[this.index].setNickName(cell[i]._playerInfo);
                  }
                  bitMap = ComponentFactory.Instance.creatBitmap("asst.kingdivision." + linkName + "." + i);
                  addChild(bitMap);
                  ++this.index;
               }
            }
         }
      }
      
      private function topOne() : void
      {
         var bitMap:Bitmap = null;
         for(var t:int = 1; t < this._itemsTwo.length; t++)
         {
            if(this._itemsTwo[t]._playerInfo != null)
            {
               if(this._itemsTwo[t]._playerInfo.conState >= 4)
               {
                  if(KingDivisionManager.Instance.isThisZoneWin)
                  {
                     this._areaStyle = this._itemsTwo[t]._playerInfo.conStyle;
                     this._areaSex = this._itemsTwo[t]._playerInfo.conSex;
                     this._areaConsortionName = this._itemsTwo[t]._playerInfo.conName;
                     this.isWin = true;
                  }
                  else
                  {
                     KingDivisionManager.Instance.thisZoneNickName = this._itemsTwo[t]._playerInfo.name;
                     this.isWin = true;
                  }
                  bitMap = ComponentFactory.Instance.creatBitmap("asst.kingdivision.2." + t);
                  addChild(bitMap);
                  break;
               }
               this._areaStyle = null;
               KingDivisionManager.Instance.thisZoneNickName = "";
            }
         }
      }
      
      private function topOneArea() : void
      {
         var bitMap:Bitmap = null;
         for(var t:int = 1; t < this._itemsTwo.length; t++)
         {
            if(this._itemsTwo[t]._playerInfo != null)
            {
               if(this._itemsTwo[t]._playerInfo.consortionState >= 4)
               {
                  this._areaStyle = this._itemsTwo[t]._playerInfo.consortionStyle;
                  this._areaSex = this._itemsTwo[t]._playerInfo.consortionSex;
                  this._areaConsortionName = this._itemsTwo[t]._playerInfo.consortionNameArea;
                  this.isWin = true;
                  bitMap = ComponentFactory.Instance.creatBitmap("asst.kingdivision.2." + t);
                  addChild(bitMap);
                  break;
               }
               this._areaStyle = null;
            }
         }
      }
      
      public function setDateStages(arr:Array) : void
      {
         var date:Date = TimeManager.Instance.Now();
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == date.date)
            {
               this._proBar.proBarAllMovie.gotoAndStop(i + 1);
               break;
            }
            if(arr[i] < date.date)
            {
               this._proBar.proBarAllMovie.gotoAndStop(5);
            }
         }
      }
      
      private function __onClickAwardsBtn(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var rewView:RewardView = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.RewardView");
         LayerManager.Instance.addToLayer(rewView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function setPlayerInfo(nickName:String) : void
      {
         this._info = new PlayerInfo();
         if(KingDivisionManager.Instance.states == 2 && !KingDivisionManager.Instance.isThisZoneWin)
         {
            this._info.Style = this._areaStyle;
            this._info.Sex = this._areaSex;
            if(Boolean(this._info.Style))
            {
               this.updateCharacter();
            }
            return;
         }
         if(nickName == PlayerManager.Instance.Self.NickName)
         {
            this._info = PlayerManager.Instance.Self;
         }
         else
         {
            this._info = PlayerManager.Instance.findPlayerByNickName(this._info,nickName);
         }
         if(KingDivisionManager.Instance.isThisZoneWin)
         {
            this._info.Style = this._areaStyle;
            this._info.Sex = this._areaSex;
            if(Boolean(this._info.Style))
            {
               this.updateCharacter();
            }
         }
         else if(Boolean(this._info.ID) && Boolean(this._info.Style))
         {
            this.updateCharacter();
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(nickName,true);
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
      }
      
      private function __playerInfoChange(event:PlayerPropertyEvent) : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         this.updateCharacter();
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
            this._character.x = 466;
            this._character.y = 93;
            addChild(this._character);
            if(this._fireWorkds == null)
            {
               this._fireWorkds = ComponentFactory.Instance.creatCustomObject("asset.rankingRoundView.fireWorkds");
               addChild(this._fireWorkds);
            }
            if(this._kingBase == null)
            {
               this._kingBase = ComponentFactory.Instance.creatBitmap("asset.kingdivision.kingbase");
               addChild(this._kingBase);
            }
            if(this._kingImg == null)
            {
               this._kingImg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.king");
               addChild(this._kingImg);
            }
            if(this._kingTxt == null)
            {
               this._kingTxt = ComponentFactory.Instance.creatComponentByStylename("rankingRoundView.kingTxt");
               addChild(this._kingTxt);
            }
            if(KingDivisionManager.Instance.states == 2 && !KingDivisionManager.Instance.isThisZoneWin)
            {
               this._kingTxt.text = this._areaConsortionName;
            }
            else if(KingDivisionManager.Instance.isThisZoneWin)
            {
               this._kingTxt.text = this._areaConsortionName;
            }
            else
            {
               this._kingTxt.text = this._info.ConsortiaName;
            }
         }
         else
         {
            this._character.dispose();
            this._character = null;
         }
      }
      
      private function championMC() : void
      {
         if(KingDivisionManager.Instance.thisZoneNickName == "" && this._areaStyle == "")
         {
            this._cup.visible = true;
            this._startBtn.visible = true;
            this._cancelBtn.visible = false;
            this._winBg.visible = false;
            return;
         }
         if(this._zone == 0 && (KingDivisionManager.Instance.thisZoneNickName != "" || this._areaStyle != ""))
         {
            this.setPlayerInfo(KingDivisionManager.Instance.thisZoneNickName);
         }
         else if(this._zone == 1 && this._areaStyle != "")
         {
            this.setPlayerInfo(KingDivisionManager.Instance.allZoneNickName);
         }
         this._winBg.visible = true;
         this._cup.visible = false;
         this._startBtn.visible = false;
         this._cancelBtn.visible = false;
         this._points.text = "---";
         if(Boolean(this._numberTxt))
         {
            this._numberTxt.text = "---";
         }
      }
      
      private function rankNoMeConsortion() : void
      {
         if(Boolean(this._numberImg))
         {
            ObjectUtils.disposeObject(this._numberImg);
            this._numberImg = null;
         }
         if(Boolean(this._numberTxt))
         {
            ObjectUtils.disposeObject(this._numberTxt);
            this._numberTxt = null;
         }
         this._startBtn.visible = false;
         this._cancelBtn.visible = false;
         this._blind.visible = false;
         this._match.visible = false;
         this._timeTxt.text = "";
         this._timer.stop();
         this._timer.reset();
      }
      
      private function __updateConsortionMessage(evt:TimerEvent) : void
      {
         if(!this.isCheckTime)
         {
            this.checkGameStartTimer();
         }
         KingDivisionManager.Instance.updateConsotionMessage();
      }
      
      private function checkGameStartTimer() : void
      {
         if(!KingDivisionManager.Instance.checkGameTimeIsOpen())
         {
            this._startBtn.enable = false;
            this._startBtn.mouseEnabled = false;
            this._startBtn.mouseChildren = false;
         }
         else
         {
            this._startBtn.enable = true;
            this._startBtn.mouseEnabled = true;
            this._startBtn.mouseChildren = true;
            this.isCheckTime = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.isCheckTime = false;
         KingDivisionManager.Instance.thisZoneNickName = "";
         ObjectUtils.disposeObject(this._awardsBtn);
         this._awardsBtn = null;
         ObjectUtils.disposeObject(this._fireWorkds);
         this._fireWorkds = null;
         ObjectUtils.disposeObject(this._points);
         this._points = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._numberTxt);
         this._numberTxt = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._kingTxt);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this.eliminateInfo);
         this.eliminateInfo = null;
         ObjectUtils.disposeObject(this.eliminateAllZoneInfo);
         this.eliminateAllZoneInfo = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            ObjectUtils.disposeObject(this._timer);
            this._timer = null;
         }
         if(Boolean(this._timerUpdate))
         {
            this._timerUpdate.stop();
            ObjectUtils.disposeObject(this._timerUpdate);
            this._timerUpdate = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

