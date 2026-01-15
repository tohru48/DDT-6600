package zodiac
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import cryptBoss.CryptBossManager;
   import dayActivity.DayActivityManager;
   import ddt.bagStore.BagStore;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import horse.HorseManager;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   
   public class ZodiacMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _title:MovieClip;
      
      private var _details:FilterFrameText;
      
      private var _quest:FilterFrameText;
      
      private var _lastCount:FilterFrameText;
      
      private var _awards:Array;
      
      private var _boxBtnBitmap:Bitmap;
      
      private var _boxBtnBitmapDark:Bitmap;
      
      private var _boxMask:MovieClip;
      
      private var _boxAwardBtn:MovieClip;
      
      private var _boxComponent:Component;
      
      private var _addBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _gotofinishBtn:SimpleBitmapButton;
      
      private var _getAwardBtn:SimpleBitmapButton;
      
      private var _helpframe:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _index:int;
      
      private var _last:int;
      
      private var _indexType:int;
      
      public function ZodiacMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("zodiac.mainview.bg");
         addChild(this._bg);
         this._title = ClassUtils.CreatInstance("zodiac.mainview.title.mc");
         PositionUtils.setPos(this._title,"zodiac.mainview.titlemc.pos");
         addChild(this._title);
         this._details = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.details.txt");
         addChild(this._details);
         this._quest = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.quest.txt");
         addChild(this._quest);
         this._boxBtnBitmapDark = ComponentFactory.Instance.creatBitmap("zodiac.mainview.boxbitmap");
         this._boxBtnBitmapDark.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._boxBtnBitmap = ComponentFactory.Instance.creatBitmap("zodiac.mainview.boxbitmap");
         this._boxMask = ClassUtils.CreatInstance("zodiac.mainview.boxbitmap.mask");
         this._boxBtnBitmap.mask = this._boxMask;
         this._boxAwardBtn = ClassUtils.CreatInstance("zodiac.mainview.boxshine");
         this._boxAwardBtn.visible = false;
         this._boxComponent = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.boxconent");
         this._boxComponent.addChild(this._boxBtnBitmapDark);
         this._boxComponent.addChild(this._boxBtnBitmap);
         this._boxComponent.addChild(this._boxMask);
         this._boxComponent.addChild(this._boxAwardBtn);
         this._boxComponent.buttonMode = false;
         var allawardinfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(201585);
         var cell:BagCell = new BagCell(0,allawardinfo,false);
         this._boxComponent.tipData = cell.tipData;
         addChild(this._boxComponent);
         this._lastCount = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.lastcount.txt");
         addChild(this._lastCount);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.addcounts.btn");
         addChild(this._addBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.help.btn");
         addChild(this._helpBtn);
         this._gotofinishBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.gotofinish.btn");
         addChild(this._gotofinishBtn);
         this._gotofinishBtn.visible = false;
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.getaward.btn");
         addChild(this._getAwardBtn);
         this._getAwardBtn.visible = false;
      }
      
      private function initEvent() : void
      {
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__addCounts);
         this._boxComponent.addEventListener(MouseEvent.CLICK,this.__getAwardAll);
         this._gotofinishBtn.addEventListener(MouseEvent.CLICK,this.__gotoFinish);
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__showHelpFrame);
      }
      
      private function removeEvent() : void
      {
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__addCounts);
         this._boxComponent.removeEventListener(MouseEvent.CLICK,this.__getAwardAll);
         this._gotofinishBtn.removeEventListener(MouseEvent.CLICK,this.__gotoFinish);
         this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__showHelpFrame);
      }
      
      private function __addCounts(e:MouseEvent) : void
      {
         var frame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(PlayerManager.Instance.Self.Money >= ServerConfigManager.instance.zodiacAddPrice)
         {
            frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("zodiac.mainview.addCountstip",ServerConfigManager.instance.zodiacAddPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
            frame.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      private function __onAlertResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.zodiacAddCounts();
         }
         frame.dispose();
      }
      
      private function __gotoFinish(e:MouseEvent) : void
      {
         var storeMainView:StoreMainView = null;
         var storeMainView2:StoreMainView = null;
         var storeMainView3:StoreMainView = null;
         var storeMainView4:StoreMainView = null;
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         switch(this._indexType)
         {
            case 34:
               if(PlayerManager.Instance.Self.Grade < 3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               break;
            case 41:
               if(PlayerManager.Instance.Self.Grade < 25)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(3);
               break;
            case 42:
               if(PlayerManager.Instance.Self.Grade < 13)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",13));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 37:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               break;
            case 46:
               if(PlayerManager.Instance.Self.Grade < 18)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",18));
                  return;
               }
               StateManager.setState(StateType.AUCTION);
               break;
            case 35:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               break;
            case 47:
               if(PlayerManager.Instance.Self.Grade < 28)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",28));
                  return;
               }
               HorseManager.instance.loadModule();
               break;
            case 33:
               if(PlayerManager.Instance.Self.Grade < 17)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               break;
            case 48:
               if(PlayerManager.Instance.Self.Grade < 40)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",40));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(8);
               break;
            case 49:
               break;
            case 50:
               FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
               break;
            case 51:
               if(PlayerManager.Instance.Self.Grade < 14)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",14));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(4);
               break;
            case 52:
               if(PlayerManager.Instance.Self.Grade < 31)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",31));
                  return;
               }
               CryptBossManager.instance.show();
               break;
            case 53:
               DayActivityManager.Instance.initActivityFrame();
               break;
            case 45:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView.skipFromWantStrong(StoreMainView.EXALT);
               break;
            case 54:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,0);
               break;
            case 55:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,1);
               break;
            case 56:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,2);
               break;
            case 57:
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,3);
               break;
            case 58:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,4);
               break;
            case 59:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView2 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView2.skipFromWantStrong(StoreMainView.FUSION);
               break;
            case 60:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView3 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView3.skipFromWantStrong(StoreMainView.TRANSF);
               break;
            case 61:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView4 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView4.skipFromWantStrong(StoreMainView.COMPOSE);
               break;
            case 62:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(5);
               break;
            case 63:
               if(PlayerManager.Instance.Self.Grade < 16)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",16));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(6);
               break;
            case 64:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.AVATARCOLLECTIONVIEW);
               break;
            case 65:
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BAGANDINFO,"",BagView.DRESS);
               break;
            case 66:
               if(PlayerManager.Instance.Self.Grade < 6)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",6));
                  return;
               }
               StateManager.setState(StateType.SHOP);
               break;
            case 67:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
               break;
         }
         ZodiacManager.instance.frameDispose();
      }
      
      private function __getAward(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         SocketManager.Instance.out.zodiacGetAward(ZodiacManager.instance.questArr[this._index - 1]);
      }
      
      private function __getAwardAll(e:MouseEvent) : void
      {
         if(this._boxAwardBtn.visible == false)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         SocketManager.Instance.out.zodiacGetAwardAll();
      }
      
      private function __showHelpFrame(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(!this._helpframe)
         {
            this._helpframe = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.main");
            this._helpframe.titleText = LanguageMgr.GetTranslation("zodiac.mainframe.title");
            this._helpframe.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("zodiac.frame.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpframe.addToContent(this._bgHelp);
            this._helpframe.addToContent(this._content);
            this._helpframe.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._helpframe.parent.removeChild(this._helpframe);
         }
      }
      
      private function __closeHelpFrame(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpframe.parent.removeChild(this._helpframe);
      }
      
      public function setViewIndex($index:int) : void
      {
         if($index == 0)
         {
            $index = 1;
         }
         this._index = $index;
         this._title.gotoAndStop(this._index);
         this._details.text = LanguageMgr.GetTranslation("zodiac.mainview.constellation" + this._index);
         this.setQuestInfo();
         this.updateView();
      }
      
      public function updateView() : void
      {
         var propress:int = 0;
         this._last = ZodiacManager.instance.maxCounts - ZodiacManager.instance.finshedCounts;
         this._lastCount.text = this._last.toString();
         propress = 0;
         for(var index:int = 1; index <= 13; index++)
         {
            if((ZodiacManager.instance.awardRecord >> index & 1) == 1)
            {
               propress++;
            }
         }
         this._boxMask.y = this._boxBtnBitmap.y + this._boxBtnBitmap.height - propress * 4;
         if(propress == 12)
         {
            this._boxBtnBitmap.visible = this._boxBtnBitmapDark.visible = this._boxMask.visible = false;
            this._boxAwardBtn.visible = true;
            this._boxComponent.buttonMode = true;
         }
         if(propress == 13)
         {
            this._boxBtnBitmap.visible = true;
            this._boxBtnBitmapDark.visible = this._boxMask.visible = false;
            this._boxAwardBtn.visible = false;
            this._boxComponent.buttonMode = false;
         }
         var info:QuestInfo = TaskManager.instance.getQuestByID(ZodiacManager.instance.questArr[this._index - 1]);
         this.refreshQuestBtn(this._index,info);
      }
      
      private function setQuestInfo() : void
      {
         var a:int = 0;
         var info:QuestInfo = null;
         var pos:Point = null;
         var i:int = 0;
         var reward:QuestItemReward = null;
         var tinfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         if(this._awards != null)
         {
            for(a = 0; a < this._awards.length; )
            {
               removeChild(this._awards[0]);
               this._awards.shift();
            }
         }
         else
         {
            this._awards = [];
         }
         var questID:int = int(ZodiacManager.instance.questArr[this._index - 1]);
         if(questID != 0)
         {
            info = TaskManager.instance.getQuestByID(questID);
            if((ZodiacManager.instance.awardRecord >> this._index & 1) == 1)
            {
               this._quest.text = info.Detail + "(" + LanguageMgr.GetTranslation("zodiac.mainview.questcomplete") + ")";
            }
            else
            {
               this._quest.text = info.conditionDescription[0];
            }
            this._indexType = ZodiacManager.instance.indexTypeArr[questID];
            this.refreshQuestBtn(this._index,info);
            if(Boolean(info.itemRewards))
            {
               pos = PositionUtils.creatPoint("zodiac.mainview.awardcell.pos");
               for(i = 0; i < info.itemRewards.length; i++)
               {
                  reward = info.itemRewards[i];
                  tinfo = new InventoryItemInfo();
                  tinfo.TemplateID = reward.itemID;
                  tinfo.Count = reward.count[0];
                  tinfo.AttackCompose = reward.AttackCompose;
                  tinfo.DefendCompose = reward.DefendCompose;
                  tinfo.LuckCompose = reward.LuckCompose;
                  tinfo.AgilityCompose = reward.AgilityCompose;
                  tinfo.StrengthenLevel = reward.StrengthenLevel;
                  tinfo.MagicAttack = reward.MagicAttack;
                  tinfo.MagicDefence = reward.MagicDefence;
                  tinfo.IsBinds = reward.isBind;
                  tinfo.ValidDate = reward.ValidateTime;
                  ItemManager.fill(tinfo);
                  cell = new BagCell(0,tinfo,false,ComponentFactory.Instance.creatBitmap("zodiac.mainview.awardcell.bg"),false);
                  cell.setContentSize(53,53);
                  cell.setCount(tinfo.Count);
                  cell.x = pos.x + 78 * (i % 3);
                  cell.y = pos.y + 62 * (int(i / 3) % 3);
                  addChild(cell);
                  this._awards.push(cell);
               }
            }
         }
         else
         {
            this._indexType = 0;
         }
      }
      
      private function refreshQuestBtn(index:int, info:QuestInfo) : void
      {
         if(info == null)
         {
            return;
         }
         if((ZodiacManager.instance.awardRecord >> index & 1) == 1)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = false;
         }
         else if(info.isAchieved)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = false;
         }
         else if(info.isCompleted)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = true;
         }
         else
         {
            this._gotofinishBtn.visible = this._indexType == 0 || this._indexType == 49 ? false : true;
            this._getAwardBtn.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

