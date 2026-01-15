package ddt.view.chat
{
   import AvatarCollection.AvatarCollectionManager;
   import DDPlay.DDPlayManaer;
   import auctionHouse.controller.AuctionHouseController;
   import bagAndInfo.BagAndInfoManager;
   import beadSystem.beadSystemManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.AreaInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.CardsTipPanel;
   import ddt.view.tips.EquipmentCardsTips;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import ddt.view.tips.LaterEquipmentGoodView;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import growthPackage.GrowthPackageManager;
   import hall.event.NewHallEvent;
   import horseRace.controller.HorseRaceManager;
   import im.IMView;
   import lanternriddles.LanternRiddlesManager;
   import magicStone.MagicStoneManager;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActivityManager;
   import worldBossHelper.WorldBossHelperManager;
   
   use namespace chat_system;
   
   public class ChatOutputField extends Sprite
   {
      
      public static const GAME_STYLE:String = "GAME_STYLE";
      
      public static const GAME_WIDTH:int = 288;
      
      public static const GAME_HEIGHT:int = 106;
      
      public static const NORMAL_WIDTH:int = 440;
      
      public static const NORMAL_HEIGHT:int = 128;
      
      public static const NORMAL_STYLE:String = "NORMAL_STYLE";
      
      private static var _style:String = "";
      
      private var _contentField:TextField;
      
      private var _nameTip:ChatNamePanel;
      
      private var _transregionalNameTip:ChatTransregionalNamePanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardboxTip:CardBoxTipPanel;
      
      private var _cardTip:EquipmentCardsTips;
      
      private var _grooveTip:CardsTipPanel;
      
      private var _cardInfotTips:EquipmentCardsTips;
      
      private var _goodTipPos:Sprite = new Sprite();
      
      private var _srcollRect:Rectangle;
      
      private var _tipStageClickCount:int = 0;
      
      private var isStyleChange:Boolean = false;
      
      private var t_text:String;
      
      private var _functionEnabled:Boolean;
      
      public function ChatOutputField()
      {
         super();
         this.chat_system::style = NORMAL_STYLE;
      }
      
      public function set functionEnabled(value:Boolean) : void
      {
         this._functionEnabled = value;
      }
      
      public function set contentWidth(value:Number) : void
      {
         this._contentField.width = value;
         this.updateScrollRect(value,NORMAL_HEIGHT);
      }
      
      public function set contentHeight(value:Number) : void
      {
         this._contentField.height = value;
         this.updateScrollRect(NORMAL_WIDTH,value);
      }
      
      public function isBottom() : Boolean
      {
         return this._contentField.scrollV == this._contentField.maxScrollV;
      }
      
      public function get scrollOffset() : int
      {
         return this._contentField.maxScrollV - this._contentField.scrollV;
      }
      
      public function set scrollOffset(offset:int) : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV - offset;
         this.onScrollChanged();
      }
      
      public function setChats(chatData:Array) : void
      {
         var resultHtmlText:String = "";
         for(var i:int = 0; i < chatData.length; i++)
         {
            resultHtmlText += chatData[i].htmlMessage;
         }
         this._contentField.htmlText = resultHtmlText;
      }
      
      public function toBottom() : void
      {
         Helpers.delayCall(this.__delayCall);
         this._contentField.scrollV = int.MAX_VALUE;
         this.onScrollChanged();
      }
      
      chat_system function get goodTipPos() : Point
      {
         return new Point(this._goodTipPos.x,this._goodTipPos.y);
      }
      
      chat_system function showLinkGoodsInfo(item:ItemTemplateInfo, tipStageClickCount:uint = 0) : void
      {
         var tipData:GoodTipInfo = null;
         var vItemInfo:InventoryItemInfo = null;
         if(item.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardboxTip == null)
            {
               this._cardboxTip = new CardBoxTipPanel();
            }
            this._cardboxTip.tipData = item;
            this.setTipPos(this._cardboxTip);
            StageReferance.stage.addChild(this._cardboxTip);
         }
         else
         {
            if(this._goodTip == null)
            {
               this._goodTip = new GoodTip();
            }
            tipData = new GoodTipInfo();
            vItemInfo = item as InventoryItemInfo;
            if(item.Property1 == "31")
            {
               if(Boolean(vItemInfo) && vItemInfo.Hole2 > 0)
               {
                  tipData.exp = vItemInfo.Hole2;
                  tipData.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[vItemInfo.Hole1 + 1];
                  tipData.beadName = vItemInfo.Name + "-" + beadSystemManager.Instance.getBeadName(vItemInfo);
               }
               else
               {
                  tipData.beadName = item.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel;
                  tipData.exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel];
                  tipData.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel + 1];
               }
            }
            else if(item.Property1 == "81")
            {
               if(Boolean(vItemInfo) && vItemInfo.StrengthenExp > 0)
               {
                  tipData.exp = vItemInfo.StrengthenExp - MagicStoneManager.instance.getNeedExp(item.TemplateID,vItemInfo.StrengthenLevel);
               }
               else
               {
                  tipData.exp = 0;
               }
               tipData.upExp = MagicStoneManager.instance.getNeedExpPerLevel(item.TemplateID,item.Level + 1);
               tipData.beadName = item.Name + "Lv" + item.Level;
            }
            tipData.itemInfo = item;
            this._goodTip.tipData = tipData;
            ItemManager.Instance.playerInfo = PlayerManager.Instance.Self;
            this._goodTip.showTip(item);
            if(PathManager.suitEnable)
            {
               LaterEquipmentGoodView.isShow = false;
               this._goodTip.showSuitTip(item);
            }
            this.setTipPos(this._goodTip);
            StageReferance.stage.addChild(this._goodTip);
         }
         if(Boolean(this._nameTip) && Boolean(this._nameTip.parent))
         {
            this._nameTip.parent.removeChild(this._nameTip);
         }
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = tipStageClickCount;
      }
      
      chat_system function showBeadTip(pItem:ItemTemplateInfo, pBeadLv:int, pBeadExp:int) : void
      {
         if(this._goodTip == null)
         {
            this._goodTip = new GoodTip();
         }
         var vGoodTipData:GoodTipInfo = new GoodTipInfo();
         vGoodTipData.beadName = pItem.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(pItem.TemplateID).Name + "Lv" + pBeadLv;
         vGoodTipData.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[pBeadLv + 1];
         vGoodTipData.exp = pBeadExp;
         vGoodTipData.itemInfo = pItem;
         this._goodTip.tipData = vGoodTipData;
         this._goodTip.showTip(pItem);
         this.setTipPos(this._goodTip);
         StageReferance.stage.addChild(this._goodTip);
      }
      
      chat_system function showCardGrooveLinkGoodsInfo(item:GrooveInfo, tipStageClickCount:uint = 0) : void
      {
         this._grooveTip = new CardsTipPanel();
         this._grooveTip.tipData = item.Place;
         this._grooveTip.tipDirctions = "7,0";
         this.setTipPos2(this._grooveTip);
         StageReferance.stage.addChild(this._grooveTip);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = tipStageClickCount;
      }
      
      chat_system function showCardInfoLinkGoodsInfo(item:CardInfo, tipStageClickCount:uint = 0) : void
      {
         this._cardInfotTips = new EquipmentCardsTips();
         this._cardInfotTips.tipData = item;
         this._cardInfotTips.tipDirctions = "7,0";
         this.setTipPos2(this._cardInfotTips);
         StageReferance.stage.addChild(this._cardInfotTips);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = tipStageClickCount;
      }
      
      private function setTipPos(tip:Object) : void
      {
         tip.x = this._goodTipPos.x;
         tip.y = this._goodTipPos.y - tip.height - 10;
         if(tip.y < 0)
         {
            tip.y = 10;
         }
      }
      
      private function setTipPos2(tip:Object) : void
      {
         tip.tipGapH = 218;
         tip.tipGapV = 245;
         tip.x = 218;
         tip.y = 245;
      }
      
      chat_system function set style(value:String) : void
      {
         if(_style != value)
         {
            _style = value;
            this.disposeView();
            this.initView();
            this.initEvent();
            switch(value)
            {
               case NORMAL_STYLE:
                  this._contentField.styleSheet = ChatFormats.styleSheet;
                  this._contentField.width = NORMAL_WIDTH;
                  this._contentField.height = NORMAL_HEIGHT;
                  break;
               case GAME_STYLE:
                  this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                  this._contentField.width = GAME_WIDTH;
                  this._contentField.height = GAME_HEIGHT;
            }
            this._contentField.htmlText = this.t_text || "";
         }
      }
      
      private function __delayCall() : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV;
         this.onScrollChanged();
         removeEventListener(Event.ENTER_FRAME,this.__delayCall);
      }
      
      private function __onScrollChanged(event:Event) : void
      {
         this.onScrollChanged();
      }
      
      private function __onTextClicked(event:TextEvent) : void
      {
         var allProperties:Array;
         var i:int;
         var data:Object = null;
         var tipPos:Point = null;
         var props:Array = null;
         var selfZone:int = 0;
         var other:int = 0;
         var input:String = null;
         var specialIdx:int = 0;
         var pattern:RegExp = null;
         var str:String = null;
         var result:Object = null;
         var rect:Rectangle = null;
         var areaInfo:AreaInfo = null;
         var startIdx:int = 0;
         var endIdx:int = 0;
         var pos:Point = null;
         var legalIdx:int = 0;
         var nameTipPos:Point = null;
         var itemInfo:ItemTemplateInfo = null;
         var info:ItemTemplateInfo = null;
         var areaInfoII:AreaInfo = null;
         var self:PlayerInfo = null;
         var chatArr:Array = null;
         var chat:ChatData = null;
         SoundManager.instance.play("008");
         this.__stageClickHandler();
         data = {};
         allProperties = event.text.split("|");
         for(i = 0; i < allProperties.length; i++)
         {
            if(Boolean(allProperties[i].indexOf(":")))
            {
               props = allProperties[i].split(":");
               data[props[0]] = props[1];
            }
         }
         if(Boolean(data.jumptype))
         {
            switch(int(data.jumptype))
            {
               case 1:
                  if(StateManager.currentStateType != StateType.MAIN)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
                     return;
                  }
                  GrowthPackageManager.instance.loadUIModule(GrowthPackageManager.instance.showFrame);
                  break;
               case 2:
                  if(DDPlayManaer.Instance.isOpen)
                  {
                     DDPlayManaer.Instance.show();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.end"));
                  }
                  break;
               case 3:
                  if(WitchBlessingManager.Instance.isOpen())
                  {
                     WitchBlessingManager.Instance.onClickIcon();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.StartNot"));
                  }
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_CHANNEL)
         {
            ChatManager.Instance.inputChannel = int(data.channel);
            ChatManager.Instance.output.functionEnabled = true;
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               IMEManager.enable();
               areaInfo = new AreaInfo();
               areaInfo.areaID = data.zoneID;
               areaInfo.areaName = data.zoneName;
               ChatManager.Instance.output.functionEnabled = true;
               if(PathManager.crossServerChatSwitch)
               {
                  ChatManager.Instance.privateChatTo(data.tagname,0,areaInfo);
               }
               else
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               }
               if(this._transregionalNameTip == null)
               {
                  this._transregionalNameTip = ComponentFactory.Instance.creatCustomObject("chat.ChatTransregionalNamePanel");
               }
               this._transregionalNameTip.NickName = data["tagname"];
               this._transregionalNameTip.setVisible = true;
               PositionUtils.setPos(this._transregionalNameTip,this.getPos(data,this._transregionalNameTip));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,data.tagname));
            }
            if(this._nameTip == null)
            {
               this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
            }
            input = String(data.tagname);
            specialIdx = int(input.indexOf("$"));
            if(specialIdx > -1)
            {
               input = input.substr(0,specialIdx);
            }
            pattern = new RegExp(input,"g");
            str = this._contentField.text;
            result = pattern.exec(str);
            while(result != null)
            {
               startIdx = int(result.index);
               endIdx = startIdx + String(data.tagname).length;
               pos = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
               legalIdx = this._contentField.getCharIndexAtPoint(pos.x,pos.y);
               if(legalIdx >= startIdx && legalIdx <= endIdx)
               {
                  this._contentField.setSelection(startIdx,endIdx);
                  rect = this._contentField.getCharBoundaries(endIdx);
                  nameTipPos = this._contentField.localToGlobal(new Point(rect.x,rect.y));
                  this._nameTip.x = nameTipPos.x + rect.width;
                  this._nameTip.y = nameTipPos.y - this._nameTip.getHeight - (this._contentField.scrollV - 1) * 18;
                  break;
               }
               result = pattern.exec(str);
            }
            this._nameTip.playerName = String(data.tagname);
            if(Boolean(data.channel))
            {
               this._nameTip.channel = ChatFormats.Channel_Set[int(data.channel)];
            }
            else
            {
               this._nameTip.channel = null;
            }
            this._nameTip.message = String(data.message);
            if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            this._nameTip.setVisible = true;
            ChatManager.Instance.privateChatTo(data.tagname);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_GOODS)
         {
            tipPos = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = tipPos.x;
            this._goodTipPos.y = tipPos.y;
            itemInfo = ItemManager.Instance.getTemplateById(data.templeteIDorItemID);
            itemInfo.BindType = data.isBind == "true" ? 0 : 1;
            this.chat_system::showLinkGoodsInfo(itemInfo);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            tipPos = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = tipPos.x;
            this._goodTipPos.y = tipPos.y;
            if(data.key != "null")
            {
               info = ChatManager.Instance.model.getLink(data.key);
            }
            else
            {
               info = ChatManager.Instance.model.getLink(data.templeteIDorItemID);
            }
            if(Boolean(info))
            {
               this.chat_system::showLinkGoodsInfo(info);
            }
            else if(data.key != "null")
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(3,String(data.key),String(data.templeteIDorItemID));
            }
            else
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(2,String(data.templeteIDorItemID));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
         {
            areaInfoII = new AreaInfo();
            areaInfoII.areaID = data.zoneID;
            if(!data.zoneName || data.zoneName == "")
            {
               data.zoneName = PlayerManager.Instance.getAreaNameByAreaID(data.zoneID);
            }
            areaInfoII.areaName = data.zoneName;
            if(!areaInfoII.areaName)
            {
               areaInfoII.areaName = PlayerManager.Instance.getAreaNameByAreaID(areaInfoII.areaID);
            }
            ChatManager.Instance.output.functionEnabled = true;
            ChatManager.Instance.privateChatTo(data.tagname,0,areaInfoII);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_EFFORT)
         {
            if(!EffortManager.Instance.getMainFrameVisible())
            {
               EffortManager.Instance.isSelf = true;
               EffortManager.Instance.switchVisible();
            }
         }
         else if(int(data.clicktype) == ChatFormats.CARD_CAO)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            SocketManager.Instance.out.sendGetLinkGoodsInfo(4,String(data.key));
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_CARD_INFO)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            SocketManager.Instance.out.sendGetLinkGoodsInfo(5,String(data.key));
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_FASTINVITE)
         {
            if(StateManager.currentStateType == StateType.FIGHTING || WorldBossHelperManager.Instance.isInWorldBossHelperFrame)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.FastInvite.cannotInvite"));
               return;
            }
            if(StateManager.currentStateType != StateType.ROOM_LIST && StateManager.currentStateType != StateType.DUNGEON_LIST && StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.FastInvite.cannotInvite2"));
               return;
            }
            if(StateManager.currentStateType == StateType.ROOM_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(1,-1,data.roomId,data.password,true);
            }
            else if(StateManager.currentStateType == StateType.DUNGEON_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(2,-1,data.roomId,data.password,true);
            }
            else
            {
               SocketManager.Instance.out.sendGameLogin(4,-1,data.roomId,data.password,true);
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_FASTAUCTION)
         {
            StateManager.createStateAsync(StateType.AUCTION,function(e:*):void
            {
               new AuctionHouseController(true,data.auctionID);
            });
         }
         else if(int(data.clicktype) == ChatFormats.NEWYEARFOOD)
         {
            if(StateManager.currentStateType == StateType.MAIN)
            {
               SocketManager.Instance.out.sendInviteYearFoodRoom(true,int(data.senderId));
            }
         }
         else if(int(data.clicktype) == ChatFormats.HORESRACE)
         {
            if(StateManager.currentStateType == StateType.MAIN)
            {
               SoundManager.instance.play("008");
               self = PlayerManager.Instance.Self;
               if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                  return;
               }
               if(self.IsMounts)
               {
                  HorseRaceManager.Instance.enterView();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horseRace.noMount"));
               }
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_ENTERHUIKUI_ACTIVITY)
         {
            if(StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
               return;
            }
            WonderfulActivityManager.Instance.clickWonderfulActView = true;
            WonderfulActivityManager.Instance.isSkipFromHall = true;
            WonderfulActivityManager.Instance.skipType = data.rewardType;
            SocketManager.Instance.out.requestWonderfulActInit(1);
         }
         else if(int(data.clicktype) > ChatFormats.CLICK_ACT_TIP)
         {
            if(StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
               return;
            }
            WonderfulActivityManager.Instance.clickWonderfulActView = true;
            WonderfulActivityManager.Instance.isSkipFromHall = true;
            WonderfulActivityManager.Instance.skipType = data.rewardType;
            SocketManager.Instance.out.requestWonderfulActInit(1);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_INVITE_OLD_PLAYER)
         {
            SocketManager.Instance.out.sendConsortiaInvate(data.tagname);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_LANTERN_BEGIN)
         {
            if(StateManager.currentStateType == StateType.MAIN)
            {
               if(LanternRiddlesManager.instance.isBegin)
               {
                  LanternRiddlesManager.instance.show();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.openTips"));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_TIME_GIFTPACK)
         {
            if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST)
            {
               BagAndInfoManager.Instance.showBagAndInfo();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_NO_TIP)
         {
            ChatManager.Instance.notAgain = true;
            chatArr = ChatManager.Instance.model.currentChats;
            for each(chat in chatArr)
            {
               if(chat.type == ChatFormats.CLICK_NO_TIP)
               {
                  chat.htmlMessage = chat.htmlMessage.replace("<FONT  COLOR=\'#8dff1e\'>" + LanguageMgr.GetTranslation("notAlertAgain") + "</FONT>","<FONT  COLOR=\'#989898\'>" + LanguageMgr.GetTranslation("notAlertAgain") + "</FONT>");
               }
            }
            ChatManager.Instance.view.output.updateCurrnetChannel();
         }
         else if(int(data.clicktype) == ChatFormats.AVATAR_COLLECTION_TIP)
         {
            if(StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.pay.tipTxt"));
               return;
            }
            AvatarCollectionManager.instance.isSkipFromHall = true;
            BagAndInfoManager.Instance.showBagAndInfo(7);
         }
      }
      
      private function getPos(data:Object, namePanel:ChatTransregionalNamePanel) : Point
      {
         var rect:Rectangle = null;
         var startIdx:int = 0;
         var endIdx:int = 0;
         var pos:Point = null;
         var legalIdx:int = 0;
         var nameTipPos:Point = null;
         var point:Point = null;
         var input:String = String(data.tagname);
         var specialIdx:int = int(input.indexOf("$"));
         if(specialIdx > -1)
         {
            input = input.substr(0,specialIdx);
         }
         var pattern:RegExp = new RegExp(input,"g");
         var str:String = this._contentField.text;
         var result:Object = pattern.exec(str);
         while(result != null)
         {
            startIdx = int(result.index);
            endIdx = startIdx + String(data.tagname).length;
            pos = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
            legalIdx = this._contentField.getCharIndexAtPoint(pos.x,pos.y);
            if(legalIdx >= startIdx && legalIdx <= endIdx)
            {
               this._contentField.setSelection(startIdx,endIdx);
               rect = this._contentField.getCharBoundaries(endIdx);
               nameTipPos = this._contentField.localToGlobal(new Point(rect.x,rect.y));
               point = new Point();
               point.x = nameTipPos.x + rect.width;
               point.y = nameTipPos.y - namePanel.getHight() - (this._contentField.scrollV - 1) * 18;
               break;
            }
            result = pattern.exec(str);
         }
         return point;
      }
      
      private function __stageClickHandler(event:MouseEvent = null) : void
      {
         if(Boolean(event))
         {
            event.stopImmediatePropagation();
            event.stopPropagation();
         }
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
            {
               this._goodTip.parent.removeChild(this._goodTip);
               LaterEquipmentGoodView.isShow = true;
            }
            if(Boolean(this._cardboxTip) && Boolean(this._cardboxTip.parent))
            {
               this._cardboxTip.parent.removeChild(this._cardboxTip);
            }
            if(Boolean(this._cardTip) && Boolean(this._cardTip.parent))
            {
               this._cardTip.parent.removeChild(this._cardTip);
            }
            if(Boolean(this._grooveTip) && Boolean(this._grooveTip.parent))
            {
               this._grooveTip.parent.removeChild(this._grooveTip);
            }
            if(Boolean(this._cardInfotTips) && Boolean(this._cardInfotTips.parent))
            {
               this._cardInfotTips.parent.removeChild(this._cardInfotTips);
            }
            if(Boolean(StageReferance.stage))
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function disposeView() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         if(Boolean(this._contentField))
         {
            this.t_text = this._contentField.htmlText;
            removeChild(this._contentField);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         this._contentField.addEventListener(Event.SCROLL,this.__onScrollChanged);
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
         this._contentField.addEventListener(MouseEvent.MOUSE_OVER,this.__onFieldOver);
         this._contentField.addEventListener(MouseEvent.MOUSE_OUT,this.__onFieldOut);
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         PlayerManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.SETSELFPLAYERPOS,null,[event]));
      }
      
      protected function __onFieldOut(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      protected function __onFieldOver(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.ARROW;
      }
      
      private function initView() : void
      {
         this._contentField = new TextField();
         PositionUtils.setPos(this._contentField,"chat.outputfieldPos");
         this._contentField.multiline = true;
         this._contentField.wordWrap = true;
         this._contentField.filters = [new GlowFilter(0,1,4,4,8)];
         this._contentField.mouseWheelEnabled = false;
         Helpers.setTextfieldFormat(this._contentField,{
            "size":11,
            "leading":-1
         });
         this.updateScrollRect(NORMAL_WIDTH,NORMAL_HEIGHT);
         addChild(this._contentField);
      }
      
      private function onScrollChanged() : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
      }
      
      private function updateScrollRect($width:Number, $height:Number) : void
      {
         this._srcollRect = new Rectangle(0,0,$width,$height);
         this._contentField.scrollRect = this._srcollRect;
      }
   }
}

