package ddt.view.tips
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import battleGroud.BattleGroudManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AreaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.view.playerThumbnail.HeadFigure;
   import game.view.playerThumbnail.PlayerThumbnail;
   import im.IMController;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="playerThumbnailTipItemClick",type="flash.events.Event")]
   public class PlayerThumbnailTip extends Sprite implements Disposeable, ITip
   {
      
      public static const VIEW_INFO:int = 0;
      
      public static const MAKE_FRIEND:int = 1;
      
      public static const PRIVATE_CHAT:int = 2;
      
      private var _isBattle:Boolean;
      
      private var _bg:Image;
      
      private var _items:Vector.<SimpleItem>;
      
      private var _playerTipDisplay:PlayerThumbnail;
      
      public function PlayerThumbnailTip()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var pos:Point = null;
         var btn:SimpleItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("game.playerThumbnailTipBg");
         addChild(this._bg);
         this._items = new Vector.<SimpleItem>();
         pos = PositionUtils.creatPoint("game.PlayerThumbnailTipItemPos");
         for(var i:int = 0; i < 3; i++)
         {
            btn = ComponentFactory.Instance.creatComponentByStylename("game.PlayerThumbnailTipItem");
            (btn.foreItems[0] as FilterFrameText).text = LanguageMgr.GetTranslation("game.PlayerThumbnailTipItemText_" + i.toString());
            btn.addEventListener(MouseEvent.ROLL_OVER,this.__onMouseOver);
            btn.addEventListener(MouseEvent.ROLL_OUT,this.__onMouseOut);
            btn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
            btn.backItem.visible = false;
            btn.buttonMode = true;
            btn.x = pos.x;
            btn.y = pos.y;
            pos.y += btn.height - 2;
            this._items.push(btn);
            addChild(btn);
         }
         addEventListener(Event.ADDED_TO_STAGE,this.__addStageEvent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      public function set tipDisplay(value:PlayerThumbnail) : void
      {
         this._playerTipDisplay = value;
      }
      
      public function get tipDisplay() : PlayerThumbnail
      {
         return this._playerTipDisplay;
      }
      
      private function __addStageEvent(e:Event) : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__removeStageEvent);
      }
      
      private function __removeStageEvent(e:MouseEvent) : void
      {
         if(e.target is HeadFigure)
         {
            return;
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__removeStageEvent);
         e.stopImmediatePropagation();
         e.stopPropagation();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __removeFromStage(e:Event) : void
      {
         dispatchEvent(new Event("playerThumbnailTipItemClick"));
      }
      
      private function __onMouseOver(e:MouseEvent) : void
      {
         var btn:SimpleItem = e.currentTarget as SimpleItem;
         if(Boolean(btn) && Boolean(btn.backItem))
         {
            btn.backItem.visible = true;
         }
      }
      
      private function __onMouseOut(e:MouseEvent) : void
      {
         var btn:SimpleItem = e.currentTarget as SimpleItem;
         if(Boolean(btn) && Boolean(btn.backItem))
         {
            btn.backItem.visible = false;
         }
      }
      
      private function __onMouseClick(e:MouseEvent) : void
      {
         var toSetFocus:Boolean = false;
         var playerInfo:PlayerInfo = null;
         var areaInfo:AreaInfo = null;
         var zoneName:String = null;
         PlayerInfoViewControl.isOpenFromBag = false;
         var btn:SimpleItem = e.currentTarget as SimpleItem;
         var idx:int = int(this._items.indexOf(btn));
         this._isBattle = false;
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            this._isBattle = true;
         }
         switch(idx)
         {
            case VIEW_INFO:
               PlayerManager.Instance.Self.isViewOther = true;
               if(this._isBattle)
               {
                  PlayerInfoViewControl._isBattle = this._isBattle;
                  playerInfo = this._playerTipDisplay.info;
                  playerInfo.Agility = BattleGroudManager.Instance.playerBattleData.Agility;
                  playerInfo.Attack = BattleGroudManager.Instance.playerBattleData.Attack;
                  playerInfo.Defence = BattleGroudManager.Instance.playerBattleData.Defend;
                  playerInfo.Luck = BattleGroudManager.Instance.playerBattleData.Lucky;
                  playerInfo.Damage = BattleGroudManager.Instance.playerBattleData.Damage;
                  playerInfo.Blood = BattleGroudManager.Instance.playerBattleData.Blood;
                  playerInfo.Energy = BattleGroudManager.Instance.playerBattleData.Energy;
                  playerInfo.Guard = BattleGroudManager.Instance.playerBattleData.Guard;
                  PlayerInfoViewControl.view(playerInfo,false,this._isBattle);
               }
               else
               {
                  PlayerInfoViewControl.view(this._playerTipDisplay.info,false);
               }
               break;
            case MAKE_FRIEND:
               if(this._playerTipDisplay.info.ZoneID > 0 && this._playerTipDisplay.info.ZoneID != PlayerManager.Instance.Self.ZoneID)
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("core.crossZone.AddFriendUnable"));
               }
               else
               {
                  IMController.Instance.addFriend(this._playerTipDisplay.info.NickName);
               }
               break;
            case PRIVATE_CHAT:
               if(this._playerTipDisplay.info.ZoneID > 0 && this._playerTipDisplay.info.ZoneID != PlayerManager.Instance.Self.ZoneID)
               {
                  areaInfo = new AreaInfo();
                  areaInfo.areaID = this._playerTipDisplay.info.ZoneID;
                  zoneName = PlayerManager.Instance.getAreaNameByAreaID(this._playerTipDisplay.info.ZoneID);
                  areaInfo.areaName = zoneName;
                  ChatManager.Instance.output.functionEnabled = true;
                  ChatManager.Instance.privateChatTo(this._playerTipDisplay.info.NickName,0,areaInfo);
               }
               else
               {
                  ChatManager.Instance.privateChatTo(this._playerTipDisplay.info.NickName);
                  toSetFocus = true;
               }
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__removeStageEvent);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(toSetFocus)
         {
            ChatManager.Instance.setFocus();
         }
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function set tipData(data:Object) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var btn:SimpleItem = null;
         this._isBattle = false;
         this._playerTipDisplay = null;
         ObjectUtils.disposeObject(this._bg);
         for(var i:int = 0; i < this._items.length; i++)
         {
            btn = this._items[i];
            ObjectUtils.disposeObject(btn);
            btn = null;
         }
         this._items = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

