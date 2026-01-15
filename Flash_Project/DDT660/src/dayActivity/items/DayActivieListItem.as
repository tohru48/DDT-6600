package dayActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayActiveData;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import labyrinth.LabyrinthManager;
   import littleGame.LittleGameManager;
   import room.RoomManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import worldBossHelper.WorldBossHelperManager;
   
   public class DayActivieListItem extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      private var _txt5:FilterFrameText;
      
      private var _worldBossHelperBtn:SimpleBitmapButton;
      
      private var _data:DayActiveData;
      
      private var _index:int;
      
      public var id:int;
      
      private var clickSp:Sprite;
      
      private var _lastCreatTime:int = 0;
      
      public var seleLigthFun:Function;
      
      private var _selectLight:Bitmap;
      
      public var activityTypeID:int;
      
      public function DayActivieListItem(number:int)
      {
         super();
         this._index = number;
         this.clickSp = new Sprite();
         this.clickSp.useHandCursor = true;
         this.clickSp.buttonMode = true;
         this.clickSp.graphics.beginFill(16777215);
         this.clickSp.graphics.drawRect(0,0,80,20);
         this.clickSp.graphics.endFill();
         this.clickSp.alpha = 0;
         useHandCursor = true;
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      protected function mouseClickHander(event:MouseEvent) : void
      {
         if(this.seleLigthFun != null)
         {
            this.seleLigthFun(this,this._data.LevelLimit);
         }
      }
      
      public function get data() : DayActiveData
      {
         return this._data;
      }
      
      public function setData(data:DayActiveData) : void
      {
         this._data = data;
         this.id = this._data.ID;
         this.activityTypeID = this._data.ActivityTypeID;
         this.init(this._index);
      }
      
      public function initTxt(bool:Boolean) : void
      {
         ObjectUtils.disposeObject(this._txt1);
         ObjectUtils.disposeObject(this._txt2);
         ObjectUtils.disposeObject(this._txt3);
         ObjectUtils.disposeObject(this._txt4);
         ObjectUtils.disposeObject(this._txt5);
         if(Boolean(this._worldBossHelperBtn))
         {
            this._worldBossHelperBtn.removeEventListener(MouseEvent.CLICK,this.__worldBossHelperHandler);
         }
         ObjectUtils.disposeObject(this._worldBossHelperBtn);
         this._txt1 = null;
         this._txt2 = null;
         this._txt3 = null;
         this._txt4 = null;
         this._txt5 = null;
         this._worldBossHelperBtn = null;
         if(bool)
         {
            this._txt5 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.closetxt");
            this._txt5.text = LanguageMgr.GetTranslation("ddt.dayActivity.close");
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.ctxt1");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.ctxt2");
            this._txt2.wordWrap = true;
            this._txt2.multiline = true;
            this._txt2.width = 150;
            this._txt3 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.ctxt3");
            this._txt4 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.ctxt4");
            this.clickSp.mouseEnabled = false;
         }
         else
         {
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.txt1");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.txt2");
            this._txt2.wordWrap = true;
            this._txt2.multiline = true;
            this._txt2.width = 150;
            this._txt3 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.txt3");
            this._txt4 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.txt4");
            this._txt5 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.opentxt");
            this._txt5.text = LanguageMgr.GetTranslation("ddt.dayActivity.open");
            this._txt5.mouseEnabled = false;
            this.clickSp.useHandCursor = true;
            this.clickSp.buttonMode = true;
            this.clickSp.mouseEnabled = true;
            this.clickSp.addEventListener(MouseEvent.CLICK,this.clickHander);
         }
         this._txt1.autoSize = TextFieldAutoSize.CENTER;
         this._txt1.text = this._data.ActiveName;
         this._txt1.x = 3;
         this._txt1.y = this._txt1.numLines > 1 ? 1 : 11;
         addChild(this._txt1);
         var str:String = this._data.ActiveTime.substr(0,11) + "\n" + this._data.ActiveTime.substr(11,12);
         if(str.length < 15)
         {
            this._txt2.y = 9;
            this._txt2.height = 25;
         }
         else
         {
            this._txt2.y = 1;
            this._txt2.height = 40;
            this._txt2.wordWrap = true;
            this._txt2.multiline = true;
         }
         this._txt2.x = 113;
         this._txt2.text = str;
         addChild(this._txt2);
         this._txt3.x = 279;
         this._txt3.y = 11;
         if(this._data.Count == 0)
         {
            this._txt3.text = LanguageMgr.GetTranslation("ddt.dayActivity.notlimited");
         }
         else
         {
            if(this._data.TotalCount >= this._data.Count)
            {
               this._data.TotalCount = this._data.Count;
            }
            this._txt3.text = this._data.TotalCount + "/" + this._data.Count;
         }
         addChild(this._txt3);
         this._txt4.autoSize = TextFieldAutoSize.CENTER;
         this._txt4.text = this._data.Description;
         this._txt4.x = 369;
         this._txt4.y = this._txt4.numLines > 1 ? 3 : 11;
         addChild(this._txt4);
         if(this._data.ID == 1 || this._data.ID == 2 || this._data.ID == 19)
         {
            this._worldBossHelperBtn = ComponentFactory.Instance.creatComponentByStylename("day.activity.worldBossHelper.helperBtn");
            this._worldBossHelperBtn.buttonMode = true;
            this._worldBossHelperBtn.useHandCursor = true;
            this._worldBossHelperBtn.x = 490;
            this._worldBossHelperBtn.y = 4;
            this._worldBossHelperBtn.addEventListener(MouseEvent.CLICK,this.__worldBossHelperHandler);
            addChild(this._worldBossHelperBtn);
         }
         this._txt5.x = 590;
         this._txt5.y = 11;
         this.clickSp.x = 590;
         this.clickSp.y = 11;
         addChild(this._txt5);
         addChild(this.clickSp);
      }
      
      private function __worldBossHelperHandler(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
            return;
         }
         SoundManager.instance.playButtonSound();
         WorldBossHelperManager.Instance.setup();
      }
      
      public function upDataOpenState(bool:Boolean) : void
      {
         this.clickSp.removeEventListener(MouseEvent.CLICK,this.clickHander);
         ObjectUtils.disposeObject(this._txt5);
         if(bool)
         {
            this._txt5 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.closetxt");
            this._txt5.text = LanguageMgr.GetTranslation("ddt.dayActivity.close");
         }
         else
         {
            this._txt5 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.item.opentxt");
            this._txt5.text = LanguageMgr.GetTranslation("ddt.dayActivity.open");
         }
         this._txt5.x = 618;
         this._txt5.y = 6;
         this._txt5.mouseEnabled = false;
         this.clickSp.addEventListener(MouseEvent.CLICK,this.clickHander);
         addChild(this._txt5);
         addChild(this.clickSp);
      }
      
      public function updataCount(num:int) : void
      {
         if(num >= this._data.Count)
         {
            num = this._data.Count;
         }
         this._txt3.text = num + "/" + this._data.Count;
      }
      
      public function getTxt5str() : String
      {
         return this._txt5.text;
      }
      
      private function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(this.id)
         {
            case 0:
               break;
            case 1:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,5))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               StateManager.setState(StateType.WORLDBOSS_AWARD);
               break;
            case 2:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                  return;
               }
               StateManager.setState(StateType.WORLDBOSS_AWARD);
               break;
            case 3:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,30))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               LabyrinthManager.Instance.show();
               break;
            case 4:
               if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,19))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",19));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(3);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
               }
               break;
            case 5:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,21))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",21));
                  return;
               }
               GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
               break;
            case 6:
               if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,17))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               ComponentSetting.SEND_USELOG_ID(5);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
               }
               break;
            case 7:
               if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,10))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               if(!PlayerManager.Instance.checkEnterDungeon)
               {
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               ComponentSetting.SEND_USELOG_ID(4);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
               }
               break;
            case 8:
               if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,3))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(3);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
               }
               break;
            case 10:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,20))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                  return;
               }
               if(LittleGameManager.Instance.hasActive())
               {
                  StateManager.setState(StateType.LITTLEHALL);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
               }
               break;
            case 17:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,26))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",26));
                  return;
               }
               SocketManager.Instance.out.enterBuried();
               break;
            case 18:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,30))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               GameInSocketOut.sendSingleRoomBegin(RoomManager.CAMP_BATTLE_ROOM);
               break;
            case 19:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                  return;
               }
               SocketManager.Instance.out.enterWorldBossRoom();
               break;
            case 20:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,17))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                  return;
               }
               if(ConsortiaBattleManager.instance.isCanEnter)
               {
                  GameInSocketOut.sendSingleRoomBegin(4);
               }
               else if(PlayerManager.Instance.Self.ConsortiaID != 0)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
               }
               break;
         }
         DayActivityManager.Instance.dispose();
      }
      
      public function setBg(number:int) : void
      {
         this._bg.gotoAndStop(number % 2 + 1);
      }
      
      private function init(number:int) : void
      {
         this._bg = ComponentFactory.Instance.creat("day.list.Back");
         this._bg.gotoAndStop(number % 2 + 1);
         addChild(this._bg);
         this._selectLight = ComponentFactory.Instance.creat("day.sele.light");
         this._selectLight.scaleY = 45 / 47;
         this._selectLight.x = -4;
         this._selectLight.y = -3;
         this._selectLight.visible = false;
         addChild(this._selectLight);
      }
      
      public function setLigthVisible(value:Boolean) : void
      {
         if(Boolean(this._selectLight))
         {
            this._selectLight.visible = value;
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         if(Boolean(this._worldBossHelperBtn))
         {
            this._worldBossHelperBtn.removeEventListener(MouseEvent.CLICK,this.__worldBossHelperHandler);
         }
         this.clickSp.removeEventListener(MouseEvent.CLICK,this.clickHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this.seleLigthFun = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function get height() : Number
      {
         return 48;
      }
   }
}

