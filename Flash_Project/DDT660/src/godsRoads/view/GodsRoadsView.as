package godsRoads.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import godsRoads.data.GodsRoadsMissionInfo;
   import godsRoads.data.GodsRoadsMissionVo;
   import godsRoads.data.GodsRoadsStepVo;
   import godsRoads.data.GodsRoadsVo;
   import godsRoads.manager.GodsRoadsManager;
   import godsRoads.model.GodsRoadsModel;
   import labyrinth.LabyrinthManager;
   import ringStation.RingStationManager;
   import room.RoomManager;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   import wantstrong.WantStrongManager;
   
   public class GodsRoadsView extends Frame
   {
      
	   private var _view:Sprite = new Sprite();
	   
	   private var _model:GodsRoadsModel = GodsRoadsManager.instance._model;
	   
	   private var _listPanel:ListPanel;
	   
	   private var _data:GodsRoadsVo;
	   
	   private var _currentLv:int = _model.godsRoadsData.currentLevel;
	   
	   private var _currentMissionID:int;
	   
	   private var _currentStep:GodsRoadsStepVo = _model.godsRoadsData.steps[_currentLv - 1];
      
      private var _missionContentTxt:FilterFrameText;
      
      private var _missionProgressTxt:FilterFrameText;
      
      private var _missionStatusTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _progressTxt:FilterFrameText;
      
      private var _statusTxt:FilterFrameText;
      
      private var _stepProgressTxt:FilterFrameText;
      
      private var _stepProgressNum:FilterFrameText;
      
      private var _smallBtn:BaseButton;
      
      private var _bigBtn:BaseButton;
      
      private var _stepIsOpen:Boolean = false;
      
      private var _btnArr:Vector.<GodsRoadsFlag> = new Vector.<GodsRoadsFlag>(7);
      
      private var _missionAwardsView:Sprite = new Sprite();
      
      private var _stepAwardsView:Sprite = new Sprite();
      
      public function GodsRoadsView()
      {
         super();
         escEnable = true;
      }
      
      public function initView() : void
      {
         addToContent(this._view);
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.GodsRoads.bg");
         this._view.addChild(bg);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("godsRoads.missionList");
         this._view.addChild(this._listPanel);
         this._listPanel.list.setListData(this._model.godsRoadsData.currentSteps.missionVos);
         this._listPanel.list.updateListView();
         this._missionContentTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionProgressTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionStatusTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionContentTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.contenttxt");
         this._missionProgressTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.progresstxt");
         this._missionStatusTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.statustxt");
         PositionUtils.setPos(this._missionContentTxt,"godsRoads.missionContentPos1");
         PositionUtils.setPos(this._missionProgressTxt,"godsRoads.missionContentPos2");
         PositionUtils.setPos(this._missionStatusTxt,"godsRoads.missionContentPos3");
         this._view.addChild(this._missionContentTxt);
         this._view.addChild(this._missionProgressTxt);
         this._view.addChild(this._missionStatusTxt);
         this._contentTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         this._progressTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         this._statusTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         PositionUtils.setPos(this._contentTxt,"godsRoads.contentPos1");
         PositionUtils.setPos(this._progressTxt,"godsRoads.contentPos2");
         PositionUtils.setPos(this._statusTxt,"godsRoads.contentPos3");
         this._view.addChild(this._contentTxt);
         this._view.addChild(this._progressTxt);
         this._view.addChild(this._statusTxt);
         this._stepProgressTxt = ComponentFactory.Instance.creat("godsRoads.stepProgress");
         PositionUtils.setPos(this._stepProgressTxt,"godsRoads.stepProgressPos");
         this._view.addChild(this._stepProgressTxt);
         this._stepProgressNum = ComponentFactory.Instance.creat("godsRoads.stepProgressNum");
         PositionUtils.setPos(this._stepProgressNum,"godsRoads.stepProgressPos1");
         this._view.addChild(this._stepProgressNum);
         this._smallBtn = ComponentFactory.Instance.creat("godsRoads.smallAwardsBtn");
         this._smallBtn.enable = false;
         this._bigBtn = ComponentFactory.Instance.creat("godsRoads.bigAwardsBtn");
         this._bigBtn.enable = false;
         this._view.addChild(this._smallBtn);
         this._view.addChild(this._bigBtn);
         this.initBtn();
         PositionUtils.setPos(this._missionAwardsView,"godsRoads.missionAwardsViewPos");
         this._view.addChild(this._missionAwardsView);
         PositionUtils.setPos(this._stepAwardsView,"godsRoads.stepAwardsViewPos");
         this._view.addChild(this._stepAwardsView);
         this.initEvent();
      }
      
      private function initBtn() : void
      {
         for(var i:int = 0; i < 7; i++)
         {
            this._btnArr[i] = ComponentFactory.Instance.creat("godsRoads.GodsRoadsFlag" + (i + 1),[i + 1]);
            this._btnArr[i].enable = false;
            this._view.addChild(this._btnArr[i]);
         }
      }
      
      public function changeSteps(lv:int, mission:int = 0) : void
      {
         this._listPanel.vectorListModel.clear();
         this._stepIsOpen = this._btnArr[lv - 1].isOpened;
         this._currentLv = lv;
         this._currentStep = this._model.godsRoadsData.steps[this._currentLv - 1];
         if(this._currentStep.getFinishPerNum() == 100)
         {
            if(this._currentStep.isGetAwards)
            {
               this._bigBtn.enable = false;
            }
            else
            {
               this._bigBtn.enable = true;
            }
         }
         else
         {
            this._bigBtn.enable = false;
         }
         this._listPanel.list.setListData(this._currentStep.missionVos);
         this._listPanel.list.updateListView();
         this._listPanel.list.currentSelectedIndex = mission;
         this._stepProgressTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.stepProgress");
         this._stepProgressNum.text = this._currentStep.getFinishPerString();
         GodsRoadsManager.instance.lastStep = this._currentStep.currentStep;
         this.flushStepAwards();
      }
      
      public function updateView(_model:GodsRoadsModel, stepIndex:int = 0, missionIndex:int = 0) : void
      {
         this._data = _model.godsRoadsData;
         for(var i:int = 0; i < 7; i++)
         {
            if(i + 1 <= this._data.currentLevel)
            {
               this._btnArr[i].enable = true;
               if(i + 1 <= this._data.currentLevel)
               {
                  this._btnArr[i].progressNum = this._data.steps[i].getFinishPerNum();
               }
               else
               {
                  this._btnArr[i].showProgress = false;
               }
            }
            else
            {
               this._btnArr[i].enable = false;
            }
         }
         if(Boolean(stepIndex))
         {
            this.changeSteps(stepIndex,missionIndex);
         }
         else
         {
            this.changeSteps(this._data.currentLevel);
         }
      }
      
      private function flushStepAwards() : void
      {
         var i:int = 0;
         var awardsBox:Bitmap = null;
         var itemInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         ObjectUtils.disposeAllChildren(this._stepAwardsView);
         var awardsArr:Array = this._currentStep.awards;
         for(i = 0; i < awardsArr.length; i++)
         {
            awardsBox = ComponentFactory.Instance.creatBitmap("asset.godsRoads.stepAwardsBox");
            itemInfo = awardsArr[i] as InventoryItemInfo;
            cell = new BagCell(i,itemInfo,false,awardsBox,false);
            cell.setContentSize(48,48);
            cell.setCount(awardsArr[i].Count);
            cell.x = i % 5 * 50;
            cell.y = int(i / 5) * 50;
            this._stepAwardsView.addChild(cell);
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(FrameEvent.RESPONSE,this.__response);
         if(Boolean(this._listPanel))
         {
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            this._listPanel.list.currentSelectedIndex = 0;
         }
         this._smallBtn.addEventListener(MouseEvent.CLICK,this.getMissionAwards);
         this._bigBtn.addEventListener(MouseEvent.CLICK,this.getStepAwards);
      }
      
      private function __response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK)
         {
            removeEventListener(FrameEvent.RESPONSE,this.__response);
            this.dispose();
         }
      }
      
      private function getMissionAwards(e:MouseEvent) : void
      {
         SocketManager.Instance.out.getGodsRoadsAwards(1,this._currentMissionID);
      }
      
      private function getStepAwards(e:MouseEvent) : void
      {
         SocketManager.Instance.out.getGodsRoadsAwards(2,this._currentLv);
      }
      
      private function __itemClick(e:ListItemEvent) : void
      {
         var i:int = 0;
         var info:GodsRoadsMissionInfo = null;
         var awardsBox:Bitmap = null;
         var itemInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         ObjectUtils.disposeAllChildren(this._missionAwardsView);
         var missionCell:GodsRoadsMisstionCell = e.cell as GodsRoadsMisstionCell;
         var mVo:GodsRoadsMissionVo = missionCell.getCellValue();
         this._currentMissionID = mVo.ID;
         GodsRoadsManager.instance.lastMssion = e.index;
         var awardsArr:Array = mVo.awards;
         for(i = 0; i < awardsArr.length; i++)
         {
            awardsBox = ComponentFactory.Instance.creatBitmap("asset.godsRoads.missionAwardsBox");
            itemInfo = awardsArr[i] as InventoryItemInfo;
            cell = new BagCell(i,itemInfo,false,awardsBox,false);
            cell.setContentSize(42,42);
            cell.setCount(awardsArr[i].Count);
            cell.x = i % 5 * 44;
            cell.y = int(i / 5) * 44;
            this._missionAwardsView.addChild(cell);
         }
         info = this._model.getMissionInfoById(mVo.ID);
         if(info.Detail.length > 26)
         {
            this._contentTxt.text = info.Detail.substring(0,26) + "...";
         }
         else
         {
            this._contentTxt.text = info.Detail;
         }
         var tempInt:int = mVo.condition1;
         if(tempInt > info.Para2)
         {
            tempInt = info.Para2;
         }
         this._progressTxt.text = tempInt + "/" + info.Para2;
         if(mVo.isFinished)
         {
            this._progressTxt.text = info.Para2 + "/" + info.Para2;
            this._statusTxt.textFormatStyle = "godsRoads.TextFormat5";
            this._statusTxt.filterString = "godsRoads.GF5";
            this._statusTxt.mouseEnabled = false;
            this._statusTxt.htmlText = LanguageMgr.GetTranslation("ddt.godsRoads.finishedTxt");
            this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
            if(mVo.isGetAwards)
            {
               this._smallBtn.enable = false;
            }
            else
            {
               this._smallBtn.enable = true;
            }
         }
         else
         {
            this._smallBtn.enable = false;
            if(this._stepIsOpen)
            {
               this._statusTxt.textFormatStyle = "godsRoads.TextFormat6";
               this._statusTxt.filterString = "godsRoads.GF6";
               this._statusTxt.mouseEnabled = true;
               this._statusTxt.htmlText = "<u><a href=\'event:" + info.IndexType + "\'>" + LanguageMgr.GetTranslation("ddt.godsRoads.gotoView") + "</a></u>";
               this._statusTxt.addEventListener(TextEvent.LINK,this.__linkFunc);
            }
            else
            {
               this._statusTxt.textFormatStyle = "godsRoads.TextFormat";
               this._statusTxt.filterString = "godsRoads.GF5";
               this._statusTxt.mouseEnabled = false;
               this._statusTxt.htmlText = LanguageMgr.GetTranslation("ddt.godsRoads.noOpenTxt");
               if(this._statusTxt.hasEventListener(TextEvent.LINK))
               {
                  this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
               }
            }
         }
      }
      
      private function __linkFunc(e:TextEvent) : void
      {
         var storeMainView2:StoreMainView = null;
         var storeMainView3:StoreMainView = null;
         var storeMainView:StoreMainView = null;
         var indexType:int = int(e.text);
         switch(indexType)
         {
            case 31:
               if(PlayerManager.Instance.Self.Grade < 8)
               {
                  TaskManager.instance.switchVisible();
               }
               else
               {
                  WantStrongManager.Instance.setup();
               }
               break;
            case 32:
               if(PlayerManager.Instance.Self.Grade < 12)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",12));
                  return;
               }
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
               break;
            case 33:
               if(PlayerManager.Instance.Self.Grade < 17)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               break;
            case 34:
               if(PlayerManager.Instance.Self.Grade < 3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",3));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               break;
            case 35:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView2 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView2.skipFromWantStrong(StoreMainView.STRENGTH);
               break;
            case 36:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView3 = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView3.skipFromWantStrong(StoreMainView.COMPOSE);
               break;
            case 37:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",10));
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               break;
            case 38:
               break;
            case 39:
               if(PlayerManager.Instance.Self.Grade < 16)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",16));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
               break;
            case 40:
               if(PlayerManager.Instance.Self.Grade < 19)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",19));
                  return;
               }
               RingStationManager.instance.show();
               break;
            case 41:
               BagAndInfoManager.Instance.showBagAndInfo(3);
               break;
            case 42:
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 43:
               LabyrinthManager.Instance.show();
               break;
            case 44:
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                  return;
               }
               GameInSocketOut.sendSingleRoomBegin(RoomManager.CAMP_BATTLE_ROOM);
               break;
            case 45:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               storeMainView = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               storeMainView.skipFromWantStrong(StoreMainView.EXALT);
               break;
         }
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this._statusTxt.hasEventListener(TextEvent.LINK))
         {
            this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
         }
         if(Boolean(this._listPanel))
         {
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
         if(Boolean(this._view))
         {
            ObjectUtils.removeChildAllChildren(this._view);
         }
         this._view = null;
         super.dispose();
      }
   }
}

