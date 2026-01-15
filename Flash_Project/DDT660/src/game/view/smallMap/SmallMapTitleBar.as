package game.view.smallMap
{
   import bombKing.BombKingManager;
   import christmas.controller.ChristmasRoomController;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PathInfo;
   import ddt.data.map.MissionInfo;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import game.GameManager;
   import game.view.DungeonHelpView;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.transnational.TransnationalFightManager;
   import setting.controll.SettingController;
   
   public class SmallMapTitleBar extends Sprite implements Disposeable
   {
      
      private static const Ellipse:int = 4;
      
      private var _w:int = 162;
      
      private var _h:int = 23;
      
      private var _hardTxt:FilterFrameText;
      
      private var _back:BackBar;
      
      private var _exitBtn:SimpleBitmapButton;
      
      private var _settingBtn:SimpleBitmapButton;
      
      private var _turnButton:GameTurnButton;
      
      private var _mission:MissionInfo;
      
      private var _missionHelp:DungeonHelpView;
      
      private var _fieldNameLoader:DisplayLoader;
      
      private var _fieldName:Bitmap;
      
      private var alert:BaseAlerFrame;
      
      private var alert1:BaseAlerFrame;
      
      private var alert2:BaseAlerFrame;
      
      private var _startDate:Date;
      
      public function SmallMapTitleBar(mission:MissionInfo)
      {
         super();
         this._startDate = TimeManager.Instance.Now();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = new BackBar();
         addChild(this._back);
         this._back.visible = PathManager.smallMapBorderEnable();
         this._hardTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.smallMapHardTxt");
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            addChild(this._hardTxt);
         }
         this._settingBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.settingButton");
         this.setTip(this._settingBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
         addChild(this._settingBtn);
         this._exitBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.exitButton");
         this.setTip(this._exitBtn,LanguageMgr.GetTranslation("tank.game.ToolStripView.exit"));
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._exitBtn.enable = false;
         }
         addChild(this._exitBtn);
         this._turnButton = ComponentFactory.Instance.creatCustomObject("GameTurnButton",[this]);
         var roomType:int = RoomManager.Instance.current.type;
         if(!RoomManager.Instance.current.isDungeonType && roomType != RoomInfo.FIGHT_LIB_ROOM && roomType != RoomInfo.FRESHMAN_ROOM && roomType != RoomInfo.CONSORTIA_BATTLE)
         {
            this._fieldNameLoader = LoadResourceManager.Instance.createLoader(this.solveMapPath(),BaseLoader.BITMAP_LOADER);
            this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            LoadResourceManager.Instance.startLoad(this._fieldNameLoader);
            this._back.tipStyle = "ddt.view.tips.PreviewTip";
            this._back.tipDirctions = "3,1";
            this._back.tipGapV = 5;
         }
         this.drawBackgound();
      }
      
      private function __onLoadComplete(evt:LoaderEvent) : void
      {
         this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         this._back.tipData = Bitmap(this._fieldNameLoader.content);
         ShowTipManager.Instance.addTip(this._back);
      }
      
      private function solveMapPath() : String
      {
         var result:String = PathManager.SITE_MAIN + "image/map/";
         if(GameManager.Instance.Current.gameMode == 8)
         {
            return result + "1133/icon.png";
         }
         var mapId:int = GameManager.Instance.Current.mapIndex;
         if(RoomManager.Instance.current.mapId > 0)
         {
            mapId = RoomManager.Instance.current.mapId;
         }
         return result + (mapId.toString() + "/icon.png");
      }
      
      public function get turnButton() : GameTurnButton
      {
         return this._turnButton;
      }
      
      private function setTip(btn:SimpleBitmapButton, data:String) : void
      {
         btn.tipStyle = "ddt.view.tips.OneLineTip";
         btn.tipDirctions = "3,6,1";
         btn.tipGapV = 5;
         btn.tipData = data;
      }
      
      private function drawBackgound() : void
      {
         var pen:Graphics = null;
         if(PathManager.smallMapBorderEnable())
         {
            pen = graphics;
            pen.clear();
            pen.lineStyle(1,3355443,1,true);
            pen.beginFill(16777215,0.8);
            pen.endFill();
            pen.moveTo(0,this._h);
            pen.lineTo(0,Ellipse);
            pen.curveTo(0,0,Ellipse,0);
            pen.lineTo(this._w - Ellipse,0);
            pen.curveTo(this._w,0,this._w,Ellipse);
            pen.lineTo(this._w,this._h);
            pen.endFill();
         }
         this._exitBtn.x = this._w - this._exitBtn.width - 2;
         this._settingBtn.x = this._exitBtn.x - this._settingBtn.width - 2;
         this._turnButton.x = this._settingBtn.x - this._turnButton.width - 2;
      }
      
      public function setBarrier(val:int, max:int) : void
      {
         this._turnButton.text = val + "/" + max;
      }
      
      private function removeEvent() : void
      {
         this._exitBtn.removeEventListener(MouseEvent.CLICK,this.__exit);
         this._settingBtn.removeEventListener(MouseEvent.CLICK,this.__set);
         this._turnButton.removeEventListener(MouseEvent.CLICK,this.__turnFieldClick);
      }
      
      private function addEvent() : void
      {
         this._exitBtn.addEventListener(MouseEvent.CLICK,this.__exit);
         this._settingBtn.addEventListener(MouseEvent.CLICK,this.__set);
         this._turnButton.addEventListener(MouseEvent.CLICK,this.__turnFieldClick);
      }
      
      private function __turnFieldClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new DungeonInfoEvent(DungeonInfoEvent.DungeonHelpChanged));
         StageReferance.stage.focus = null;
      }
      
      private function __turnCountChanged(evt:RoomEvent) : void
      {
         this._turnButton.text = this._mission.turnCount + "/" + this._mission.maxTurnCount;
      }
      
      private function __set(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SettingController.Instance.switchVisible();
      }
      
      private function __exit(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == 5)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitLib"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(GameManager.Instance.Current.selfGamePlayer.selfDieTimeDelayPassed)
            {
               if(RoomManager.Instance.current.type < 2)
               {
                  this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this.alert1.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
                  this.alert1.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
               }
               else
               {
                  this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
                  this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
               }
            }
            return;
         }
         var playTime:Number = TimeManager.Instance.TimeSpanToNow(this._startDate).time;
         if(RoomManager.Instance.current.type >= 2 && RoomManager.Instance.current.type != RoomInfo.SCORE_ROOM && RoomManager.Instance.current.type != RoomInfo.RANK_ROOM && RoomManager.Instance.current.type != RoomInfo.ENCOUNTER_ROOM && RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM && RoomManager.Instance.current.type != RoomInfo.SINGLE_BATTLE && RoomManager.Instance.current.type != RoomInfo.SPECIAL_ACTIVITY_DUNGEON && RoomManager.Instance.current.type != RoomInfo.TRANSNATIONALFIGHT_ROOM && RoomManager.Instance.current.type != RoomInfo.CHRISTMAS_ROOM && RoomManager.Instance.current.type != RoomInfo.ENTERTAINMENT_ROOM && RoomManager.Instance.current.type != RoomInfo.CONSORTIA_MATCH_SCORE && RoomManager.Instance.current.type != RoomInfo.ENTERTAINMENT_ROOM_PK && RoomManager.Instance.current.type != RoomInfo.CONSORTIA_MATCH_RANK && RoomManager.Instance.current.type != RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE && RoomManager.Instance.current.type != RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseEntertainmentHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(playTime < PathInfo.SUCIDE_TIME)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ToolStripView.cannotExit"));
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CHRISTMAS_ROOM)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseChristmasHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_SCORE)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseChristmasHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_RANK)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseChristmasHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseChristmasHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
         {
            this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this.alert2.addEventListener(FrameEvent.RESPONSE,this.__responseChristmasHandler);
            this.alert2.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
            return;
         }
         this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this.alert1.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.alert1.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function __responseEntertainmentHandler(evt:FrameEvent) : void
      {
         (evt.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         (evt.target as BaseAlerFrame).dispose();
         if(evt.target == this.alert)
         {
            this.alert = null;
         }
         else if(evt.target == this.alert1)
         {
            this.alert1 = null;
         }
         else if(evt.target == this.alert2)
         {
            this.alert2 = null;
         }
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGamePlayerExit();
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function __onKeyDown(evt:KeyboardEvent) : void
      {
         evt.stopImmediatePropagation();
         if(evt.keyCode == Keyboard.ENTER)
         {
            (evt.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
            if(RoomManager.Instance.isTransnationalFight())
            {
               TransnationalFightManager.Instance.isfromTransnational = true;
            }
            if(RoomManager.Instance.isChristmasFight())
            {
               ChristmasManager.isToRoom = true;
               StateManager.setState(StateType.CHRISTMAS_ROOM);
            }
         }
         else if(evt.keyCode == Keyboard.ESCAPE)
         {
            (evt.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
         }
      }
      
      private function __responseChristmasHandler(evt:FrameEvent) : void
      {
         (evt.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         (evt.target as BaseAlerFrame).dispose();
         if(evt.target == this.alert)
         {
            this.alert = null;
         }
         else if(evt.target == this.alert1)
         {
            this.alert1 = null;
         }
         else if(evt.target == this.alert2)
         {
            this.alert2 = null;
         }
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGamePlayerExit();
            if(RoomManager.Instance.isChristmasFight())
            {
               if(ChristmasRoomController.isTimeOver)
               {
                  ChristmasRoomController.isTimeOver = false;
                  StateManager.setState(StateType.MAIN);
                  return;
               }
               ChristmasManager.isToRoom = true;
               StateManager.setState(StateType.CHRISTMAS_ROOM);
            }
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         (evt.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         (evt.target as BaseAlerFrame).dispose();
         if(evt.target == this.alert)
         {
            this.alert = null;
         }
         else if(evt.target == this.alert1)
         {
            this.alert1 = null;
         }
         else if(evt.target == this.alert2)
         {
            this.alert2 = null;
         }
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(BombKingManager.instance.Recording)
            {
               BombKingManager.instance.reset();
               StateManager.setState(StateType.MAIN);
            }
            else
            {
               GameInSocketOut.sendGamePlayerExit();
               if(RoomManager.Instance.isTransnationalFight())
               {
                  TransnationalFightManager.Instance.isfromTransnational = true;
               }
               SocketManager.Instance.out.outCampBatttle();
            }
         }
      }
      
      public function set enableExit(b:Boolean) : void
      {
         this._exitBtn.enable = b;
      }
      
      override public function set width(value:Number) : void
      {
         this._w = value;
         this._back.width = value + 0.5;
         this.drawBackgound();
      }
      
      override public function set height(value:Number) : void
      {
         this._h = value;
         this.drawBackgound();
      }
      
      public function set title(val:String) : void
      {
         this._hardTxt.text = val;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._hardTxt))
         {
            ObjectUtils.disposeObject(this._hardTxt);
            this._hardTxt = null;
         }
         if(Boolean(this._exitBtn))
         {
            ObjectUtils.disposeObject(this._exitBtn);
            this._exitBtn = null;
         }
         if(Boolean(this._settingBtn))
         {
            ObjectUtils.disposeObject(this._settingBtn);
            this._settingBtn = null;
         }
         if(Boolean(this._turnButton))
         {
            ObjectUtils.disposeObject(this._turnButton);
            this._turnButton = null;
         }
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this.alert))
         {
            ObjectUtils.disposeObject(this.alert);
            this.alert = null;
         }
         if(Boolean(this._fieldName))
         {
            ObjectUtils.disposeObject(this._fieldName);
         }
         this._fieldName = null;
         if(Boolean(this._fieldNameLoader))
         {
            this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         }
         this._fieldNameLoader = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.core.ITipedDisplay;
import com.pickgliss.utils.ObjectUtils;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

class BackBar extends Sprite implements Disposeable, ITipedDisplay
{
   
   private var _w:Number = 1;
   
   private var _back1:Bitmap;
   
   private var _back2:Bitmap;
   
   private var _back3:Bitmap;
   
   protected var _tipData:Object;
   
   protected var _tipDirction:String;
   
   protected var _tipGapV:int;
   
   protected var _tipGapH:int;
   
   protected var _tipStyle:String;
   
   public function BackBar()
   {
      super();
      this._back1 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack1");
      this._back2 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack2");
      this._back3 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack3");
   }
   
   override public function set width(value:Number) : void
   {
      this._w = value;
      this.draw();
   }
   
   private function draw() : void
   {
      var pen:Graphics = graphics;
      pen.clear();
      pen.beginBitmapFill(this._back1.bitmapData,null,true,true);
      pen.drawRect(0,0,this._back1.width,this._back1.height);
      pen.endFill();
      pen.beginBitmapFill(this._back2.bitmapData,null,true,true);
      pen.drawRect(this._back1.width,0,this._w - this._back1.width - this._back3.width,this._back1.height);
      pen.endFill();
      var drawmatrix:Matrix = new Matrix();
      drawmatrix.tx = this._w - this._back3.width;
      pen.beginBitmapFill(this._back3.bitmapData,drawmatrix,true,true);
      pen.drawRect(this._w - this._back3.width,0,this._back3.width,this._back1.height);
      pen.endFill();
   }
   
   public function get tipData() : Object
   {
      return this._tipData;
   }
   
   public function set tipData(value:Object) : void
   {
      if(this._tipData == value)
      {
         return;
      }
      this._tipData = value;
   }
   
   public function get tipDirctions() : String
   {
      return this._tipDirction;
   }
   
   public function set tipDirctions(value:String) : void
   {
      if(this._tipDirction == value)
      {
         return;
      }
      this._tipDirction = value;
   }
   
   public function get tipGapV() : int
   {
      return this._tipGapV;
   }
   
   public function set tipGapV(value:int) : void
   {
      if(this._tipGapV == value)
      {
         return;
      }
      this._tipGapV = value;
   }
   
   public function get tipGapH() : int
   {
      return this._tipGapH;
   }
   
   public function set tipGapH(value:int) : void
   {
      if(this._tipGapH == value)
      {
         return;
      }
      this._tipGapH = value;
   }
   
   public function get tipStyle() : String
   {
      return this._tipStyle;
   }
   
   public function set tipStyle(value:String) : void
   {
      if(this._tipStyle == value)
      {
         return;
      }
      this._tipStyle = value;
   }
   
   public function asDisplayObject() : DisplayObject
   {
      return this;
   }
   
   public function dispose() : void
   {
      if(Boolean(this._back1))
      {
         ObjectUtils.disposeObject(this._back1);
         this._back1 = null;
      }
      if(Boolean(this._back2))
      {
         ObjectUtils.disposeObject(this._back2);
         this._back2 = null;
      }
      if(Boolean(this._back3))
      {
         ObjectUtils.disposeObject(this._back3);
         this._back3 = null;
      }
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
}
