package wantstrong.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   import littleGame.LittleGameManager;
   import road7th.data.DictionaryData;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   import wantstrong.WantStrongManager;
   import wantstrong.data.WantStrongMenuData;
   
   public class WantStrongDetail extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _item:WantStrongMenuData;
      
      private var _titleFrameText:FilterFrameText;
      
      private var _contentFrameText:FilterFrameText;
      
      private var _freeBackContentFrameText:FilterFrameText;
      
      private var _freeNumFrameText:FilterFrameText;
      
      private var _freeHonorFrameText:FilterFrameText;
      
      private var _allBackContentFrameText:FilterFrameText;
      
      private var _allNumFrameText:FilterFrameText;
      
      private var _allHonorFrameText:FilterFrameText;
      
      private var _goBtn:SimpleBitmapButton;
      
      private var _freeBackBtn:SimpleBitmapButton;
      
      private var _allBackBtn:SimpleBitmapButton;
      
      private var _icon:Bitmap;
      
      private var _bagInfoItems:DictionaryData;
      
      private var _cell:BagCell;
      
      public function WantStrongDetail(item:WantStrongMenuData)
      {
         super();
         this._item = item;
         this.initView();
      }
      
      private function initView() : void
      {
         var lightStar:Bitmap = null;
         var grayStar:Bitmap = null;
         this._bg = ComponentFactory.Instance.creat("wantstrong.right.cellbg");
         addChild(this._bg);
         this._titleFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.rightTitle.Text");
         this._titleFrameText.text = this._item.title;
         addChild(this._titleFrameText);
         for(var i:int = 0; i < this._item.starNum; i++)
         {
            lightStar = ComponentFactory.Instance.creatBitmap("wantstrong.right.xing");
            lightStar.x = 198 + 21 * i;
            lightStar.y = 6;
            addChild(lightStar);
         }
         for(var j:int = this._item.starNum; j < 5; j++)
         {
            grayStar = ComponentFactory.Instance.creatBitmap("wantstrong.right.grayxing");
            grayStar.x = 135 + 21 * j;
            grayStar.y = 6;
            addChild(grayStar);
         }
         if(this._item.type != 5)
         {
            this._contentFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.rightContent.Text");
            this._contentFrameText.text = this._item.description;
            addChild(this._contentFrameText);
            this._goBtn = ComponentFactory.Instance.creatComponentByStylename("wantstrong.goon");
            this._goBtn.addEventListener(MouseEvent.CLICK,this.goBtnHandler);
            addChild(this._goBtn);
         }
         else
         {
            this._freeBackContentFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.freeBackRightContent.Text");
            this._freeBackContentFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.freeFindBack");
            addChild(this._freeBackContentFrameText);
            this._freeNumFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.freeBackRightContentNum.Text");
            this._freeNumFrameText.text = "" + this._item.awardNum * 0.1;
            addChild(this._freeNumFrameText);
            this._freeHonorFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.freeBackRightContentHonor.Text");
            if(this._freeNumFrameText.length > 3)
            {
               this._freeHonorFrameText.x += 8;
            }
            if(this._item.awardType == 1)
            {
               this._freeHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.honor");
            }
            else if(this._item.awardType == 2)
            {
               this._freeHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.prestige");
            }
            else
            {
               this._freeHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.token");
            }
            addChild(this._freeHonorFrameText);
            this._allBackContentFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.allBackRightContent.Text");
            this._allBackContentFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.allFindBack");
            addChild(this._allBackContentFrameText);
            this._allNumFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.allBackRightContentNum.Text");
            this._allNumFrameText.text = "" + this._item.awardNum;
            addChild(this._allNumFrameText);
            this._allHonorFrameText = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.mainFrame.allBackRightContentHonor.Text");
            if(this._allNumFrameText.length > 4)
            {
               this._allHonorFrameText.x += 8;
            }
            if(this._item.awardType == 1)
            {
               this._allHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.honor");
            }
            else if(this._item.awardType == 2)
            {
               this._allHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.prestige");
            }
            else
            {
               this._allHonorFrameText.text = LanguageMgr.GetTranslation("ddt.wantStrong.view.token");
            }
            addChild(this._allHonorFrameText);
            this._freeBackBtn = ComponentFactory.Instance.creatComponentByStylename("wantstrong.freeback");
            this._freeBackBtn.addEventListener(MouseEvent.CLICK,this.freeBackBtnHandler);
            this._allBackBtn = ComponentFactory.Instance.creatComponentByStylename("wantstrong.allback");
            this._allBackBtn.addEventListener(MouseEvent.CLICK,this.allBackBtnHandler);
            this._freeBackBtn.enable = this._item.freeBackBtnEnable;
            this._allBackBtn.enable = this._item.allBackBtnEnable;
            addChild(this._freeBackBtn);
            addChild(this._allBackBtn);
         }
         this._icon = ComponentFactory.Instance.creatBitmap(this._item.iconUrl);
         this._icon.x = 18;
         this._icon.y = 40;
         addChild(this._icon);
      }
      
      private function freeBackBtnHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.wantStrong.view.freeFindBackAlert"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertFreeBack);
      }
      
      private function __alertFreeBack(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendWantStrongBack(this._item.bossType,false);
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertFreeBack);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function allBackBtnHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.wantStrong.view.allFindBackAlert",this._item.moneyNum),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertAllBack);
      }
      
      private function __alertAllBack(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertAllBack);
         SoundManager.instance.playButtonSound();
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertAllBack);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(frame.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendWantStrongBack(this._item.bossType,true,frame.isBand);
               break;
         }
         frame.dispose();
      }
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._item.moneyNum)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._item.moneyNum)
         {
            return false;
         }
         return true;
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            SocketManager.Instance.out.sendWantStrongBack(this._item.bossType,true,false);
         }
         e.currentTarget.dispose();
      }
      
      private function goBtnHandler(event:MouseEvent) : void
      {
         var storeMainView:StoreMainView = null;
         var storeMainView2:StoreMainView = null;
         SoundManager.instance.playButtonSound();
         var target:WantStrongDetail = event.target.parent as WantStrongDetail;
         this._bagInfoItems = PlayerManager.Instance.Self.PropBag.items;
         switch(target._item.id)
         {
            case 101:
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 102:
               BagAndInfoManager.Instance.showBagAndInfo(5);
               break;
            case 103:
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
               }
               else
               {
                  BagStore.instance.show(BagStore.FORGE_STORE,3);
               }
               break;
            case 104:
               BagAndInfoManager.Instance.showBagAndInfo(4);
               break;
            case 105:
               WantStrongManager.Instance.close();
               FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
               StateManager.setState(StateType.FARM);
               break;
            case 106:
               BagStore.instance.show(BagStore.BAG_STORE);
               break;
            case 107:
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView.skipFromWantStrong(StoreMainView.FUSION);
               break;
            case 108:
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView2 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView2.skipFromWantStrong(StoreMainView.COMPOSE);
               break;
            case 109:
               BagAndInfoManager.Instance.showBagAndInfo(21);
               break;
            case 110:
               WantStrongManager.Instance.close();
               SocketManager.Instance.out.enterBuried();
               break;
            case 111:
               BagStore.instance.show(BagStore.FORGE_STORE,1);
               break;
            case 112:
               BagStore.instance.show(BagStore.FORGE_STORE,0);
               break;
            case 201:
               LabyrinthManager.Instance.show();
               break;
            case 202:
               TaskManager.instance.switchVisible();
               break;
            case 203:
               WantStrongManager.Instance.close();
               StateManager.currentStateType = StateType.ROOM_LIST;
               RoomListController.instance.enter();
               break;
            case 204:
               if(!LittleGameManager.Instance.hasActive())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.wantStrong.view.fight2Alert"));
                  break;
               }
               WantStrongManager.Instance.close();
               StateManager.setState(StateType.LITTLEHALL);
               break;
            case 301:
               CalendarManager.getInstance().open(1,true);
               break;
            case 302:
               WantStrongManager.Instance.close();
               StateManager.currentStateType = StateType.DUNGEON_LIST;
               DungeonListController.instance.enter();
               break;
            case 401:
               WantStrongManager.Instance.close();
               StateManager.currentStateType = StateType.DUNGEON_LIST;
               DungeonListController.instance.enter();
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._goBtn))
         {
            this._goBtn.removeEventListener(MouseEvent.CLICK,this.goBtnHandler);
         }
         if(Boolean(this._freeBackBtn))
         {
            this._freeBackBtn.removeEventListener(MouseEvent.CLICK,this.freeBackBtnHandler);
         }
         if(Boolean(this._allBackBtn))
         {
            this._allBackBtn.removeEventListener(MouseEvent.CLICK,this.allBackBtnHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
         }
         if(Boolean(this._bagInfoItems))
         {
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleFrameText = null;
         this._contentFrameText = null;
         this._freeBackContentFrameText = null;
         this._freeNumFrameText = null;
         this._freeHonorFrameText = null;
         this._allBackContentFrameText = null;
         this._allNumFrameText = null;
         this._allHonorFrameText = null;
         this._freeBackBtn = null;
         this._allBackBtn = null;
         this._goBtn = null;
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

