package beadSystem.views
{
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadFeedProgress;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.controls.DrillItemInfo;
   import beadSystem.controls.DrillSelectButton;
   import beadSystem.data.BeadEvent;
   import beadSystem.data.BeadLeadEvent;
   import beadSystem.model.BeadModel;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.HelpFrame;
   import store.data.HoleExpModel;
   import store.view.embed.EmbedStoneCell;
   import store.view.embed.EmbedUpLevelCell;
   import store.view.embed.HoleExpBar;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class BeadInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _character:ShowCharacter;
      
      private var _pointArray:Vector.<Point>;
      
      private var _progressLevel:BeadFeedProgress;
      
      private var _holeExpBar:HoleExpBar;
      
      public var _beadGetView:BeadGetView;
      
      private var _openHoleBtn:TextButton;
      
      private var _Cells:DictionaryData;
      
      private var _HoleOpen:DictionaryData;
      
      private var _stateList:DropList;
      
      private var _stateSelectBtn:DrillSelectButton;
      
      private var _beadHoleModel:HoleExpModel;
      
      private var _beadUpGradeTxt:FilterFrameText;
      
      private var _beadFeedCell:EmbedUpLevelCell;
      
      private var _helpButton:BaseButton;
      
      public function BeadInfoView()
      {
         super();
         this._HoleOpen = new DictionaryData();
         this.initView();
         this.initBeadEquip();
         this.beadGuide();
      }
      
      private function beadGuide() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.BEAD_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 16 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(29)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.BEAD_GUIDE,0,new Point(468,-33),"asset.trainer.txtBeadGuide","guide.bead.txtPos",this);
            }
         }
      }
      
      private function initView() : void
      {
         var stoneAttackCell:EmbedStoneCell = null;
         var stoneDefanceCell1:EmbedStoneCell = null;
         var stoneDefanceCell2:EmbedStoneCell = null;
         var i:int = 0;
         var stoneNeedOpen1:EmbedStoneCell = null;
         var stoneNeedOpen2:EmbedStoneCell = null;
         var stoneNeedOpen3:EmbedStoneCell = null;
         var stoneNeedOpen4:EmbedStoneCell = null;
         var stoneNeedOpen6:EmbedStoneCell = null;
         var stoneCell:EmbedStoneCell = null;
         this._Cells = new DictionaryData();
         this._bg = ComponentFactory.Instance.creatBitmap("beadSystem.info.bg");
         this.getCellsPoint();
         addChild(this._bg);
         stoneAttackCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[1,1]);
         stoneAttackCell.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint1")).x;
         stoneAttackCell.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint1")).y;
         stoneAttackCell.StoneType = 1;
         addChild(stoneAttackCell);
         this._Cells.add(1,stoneAttackCell);
         stoneDefanceCell1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[2,2]);
         stoneDefanceCell1.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint2")).x;
         stoneDefanceCell1.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint2")).y;
         stoneDefanceCell1.StoneType = 2;
         addChild(stoneDefanceCell1);
         this._Cells.add(2,stoneDefanceCell1);
         stoneDefanceCell2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[3,2]);
         stoneDefanceCell2.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint3")).x;
         stoneDefanceCell2.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint3")).y;
         stoneDefanceCell2.StoneType = 2;
         addChild(stoneDefanceCell2);
         this._Cells.add(3,stoneDefanceCell2);
         for(i = 4; i <= 12; i++)
         {
            stoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[i,3]);
            stoneCell.StoneType = 3;
            stoneCell.x = this._pointArray[i - 1].x;
            stoneCell.y = this._pointArray[i - 1].y;
            addChild(stoneCell);
            this._Cells.add(i,stoneCell);
         }
         stoneNeedOpen1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[13,3]);
         stoneNeedOpen1.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint13")).x;
         stoneNeedOpen1.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint13")).y;
         stoneNeedOpen1.StoneType = 3;
         addChild(stoneNeedOpen1);
         this._Cells.add(13,stoneNeedOpen1);
         this._HoleOpen.add(13,stoneNeedOpen1);
         stoneNeedOpen2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[14,3]);
         stoneNeedOpen2.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint14")).x;
         stoneNeedOpen2.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint14")).y;
         stoneNeedOpen2.StoneType = 3;
         addChild(stoneNeedOpen2);
         this._Cells.add(14,stoneNeedOpen2);
         this._HoleOpen.add(14,stoneNeedOpen2);
         stoneNeedOpen3 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[15,3]);
         stoneNeedOpen3.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint15")).x;
         stoneNeedOpen3.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint15")).y;
         stoneNeedOpen3.StoneType = 3;
         addChild(stoneNeedOpen3);
         this._Cells.add(15,stoneNeedOpen3);
         this._HoleOpen.add(15,stoneNeedOpen3);
         stoneNeedOpen4 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[16,3]);
         stoneNeedOpen4.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint16")).x;
         stoneNeedOpen4.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint16")).y;
         stoneNeedOpen4.StoneType = 3;
         addChild(stoneNeedOpen4);
         this._Cells.add(16,stoneNeedOpen4);
         this._HoleOpen.add(16,stoneNeedOpen4);
         var stoneNeedOpen5:EmbedStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[17,3]);
         stoneNeedOpen5.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint17")).x;
         stoneNeedOpen5.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint17")).y;
         stoneNeedOpen5.StoneType = 3;
         addChild(stoneNeedOpen5);
         this._Cells.add(17,stoneNeedOpen5);
         this._HoleOpen.add(17,stoneNeedOpen5);
         stoneNeedOpen6 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[18,3]);
         stoneNeedOpen6.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint18")).x;
         stoneNeedOpen6.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint18")).y;
         stoneNeedOpen6.StoneType = 3;
         addChild(stoneNeedOpen6);
         this._Cells.add(18,stoneNeedOpen6);
         this._HoleOpen.add(18,stoneNeedOpen6);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("beadSystem.FeedProgress");
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         this._progressLevel.scaleY = 0.8;
         this._progressLevel.scaleX = 0.8;
         addChild(this._progressLevel);
         this._holeExpBar = ComponentFactory.Instance.creatCustomObject("beadSystem.HoleExpBar");
         this._holeExpBar.visible = true;
         this._holeExpBar.setProgress(0);
         this._holeExpBar.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.HoleNoSelect");
         addChild(this._holeExpBar);
         this._beadFeedCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedUpLevelCell");
         this._beadFeedCell.x = this._pointArray[18].x;
         this._beadFeedCell.y = this._pointArray[18].y;
         addChild(this._beadFeedCell);
         BeadLeadManager.Instance.addEventListener(BeadLeadEvent.SPALINGUPLEVELCELL,this.spalingUpLevelCell);
         this._beadGetView = ComponentFactory.Instance.creatCustomObject("beadGetView");
         addChild(this._beadGetView);
         this._openHoleBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.openHole");
         this._openHoleBtn.text = LanguageMgr.GetTranslation("ddt.beadSystem.OpenHoleText");
         this._openHoleBtn.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.OpenHoleText");
         addChild(this._openHoleBtn);
         this._stateSelectBtn = ComponentFactory.Instance.creatCustomObject("beadSystem.DrillButton");
         addChild(this._stateSelectBtn);
         this._stateList = ComponentFactory.Instance.creatComponentByStylename("beadSystem.drillList");
         this._stateList.targetDisplay = this._stateSelectBtn;
         this._stateList.showLength = 5;
         this._beadUpGradeTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.upderBeadUpgradeCell.Text");
         this._beadUpGradeTxt.text = LanguageMgr.GetTranslation("ddt.beadSystem.underBeadFeedCellTxt");
         addChild(this._beadUpGradeTxt);
         this._helpButton = ComponentFactory.Instance.creatComponentByStylename("beadSystem.btnHelp");
         addChild(this._helpButton);
         this.updateBtn();
         this.initEvent();
         this.initHoleExp();
         BeadModel._BeadCells = this._HoleOpen;
      }
      
      private function spalingUpLevelCell(e:BeadLeadEvent) : void
      {
         if(Boolean(this._beadFeedCell))
         {
            BeadLeadManager.Instance.spalingUpLevelCell(this._beadFeedCell);
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(this.visible)
         {
            this._beadGetView.removeTimer();
         }
         super.visible = value;
      }
      
      private function loadStateList() : void
      {
         this._stateList.dataList = BeadModel.getDrillsIgnoreBindState().list.sort(this.drillSortFun);
      }
      
      private function __stateSelectClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(this._stateList.parent == null)
         {
            addChild(this._stateList);
            this._stateList.dataList = BeadModel.getDrillsIgnoreBindState().list.sort(this.drillSortFun);
         }
         else
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function drillSortFun(a:DrillItemInfo, b:DrillItemInfo) : int
      {
         return a.itemInfo.Level - b.itemInfo.Level;
      }
      
      private function __feedCellChanged(pEvent:BeadEvent) : void
      {
         var c:EmbedUpLevelCell = pEvent.currentTarget as EmbedUpLevelCell;
         if(Boolean(c.info))
         {
            this._progressLevel.currentExp = c.invenItemInfo.Hole2;
            if(c.invenItemInfo.Hole1 < 19)
            {
               this._progressLevel.upLevelExp = ServerConfigManager.instance.getBeadUpgradeExp()[c.invenItemInfo.Hole1 + 1];
            }
            this._progressLevel.intProgress(c.invenItemInfo);
         }
         else
         {
            this._progressLevel.resetProgress();
         }
      }
      
      private function __onOpenHoleClick(pEvent:MouseEvent) : void
      {
         var o:EmbedStoneCell = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var index:int = this.getSelectedHoleIndex();
         if(index == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipHoleNotSelected"));
            return;
         }
         for each(o in this._HoleOpen)
         {
            if(o.selected)
            {
               if(o.HoleLv == int(LanguageMgr.GetTranslation("ddt.beadSystem.MaxHoleLevel")))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.MaxHoleLevelText"));
               }
               else if(index >= 0 && Boolean(this._stateSelectBtn.DrillItem))
               {
                  if(o.HoleLv == this._stateSelectBtn.DrillItem.Level - 1)
                  {
                     if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._stateSelectBtn.DrillItem.TemplateID) > 0)
                     {
                        this.toShowNumberSelect(index,this._stateSelectBtn.DrillItem.TemplateID);
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.noEnoughDrills"));
                     }
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipErrorDrills"));
                  }
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoDrillSelected"));
               }
               break;
            }
         }
      }
      
      private function toShowNumberSelect(index:int, templateID:int) : void
      {
         var onNumberSelected:Function = null;
         onNumberSelected = function(num:int):void
         {
            SocketManager.Instance.out.sendBeadOpenHole(index,templateID,num);
         };
         var alert:OpenHoleNumAlertFrame = ComponentFactory.Instance.creatComponentByStylename("gemstone.openHoleNumAlertFrame");
         alert.curItemID = templateID;
         alert.initAlert();
         alert.callBack(onNumberSelected);
         LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function updateBtn() : void
      {
         if(BeadModel.getDrills().length <= 0)
         {
            this._stateSelectBtn.setValue(null);
         }
         this._stateSelectBtn.mouseChildren = this._stateSelectBtn.mouseEnabled = BeadModel.getDrills().length > 0;
         this._stateSelectBtn.filters = BeadModel.getDrills().length > 0 ? null : ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      public function startShine(info:ItemTemplateInfo) : void
      {
         var c:EmbedStoneCell = null;
         var itemInfo:InventoryItemInfo = info as InventoryItemInfo;
         for each(c in this._Cells)
         {
            if(!c.info && info.Property2 == c.StoneType.toString() && c.isOpend)
            {
               if(c.ID < 13)
               {
                  c.startShine();
               }
               else if(beadSystemManager.Instance.judgeLevel(int(itemInfo.Hole1),c.HoleLv))
               {
                  c.startShine();
               }
            }
         }
      }
      
      public function stopShine() : void
      {
         var c:EmbedStoneCell = null;
         for each(c in this._Cells)
         {
            c.stopShine();
         }
      }
      
      private function getSelectedHoleIndex() : int
      {
         var c:EmbedStoneCell = null;
         var vResult:int = -1;
         for each(c in this._HoleOpen)
         {
            if(c.selected)
            {
               vResult = c.ID;
               break;
            }
         }
         return this.getHoleIndex(vResult);
      }
      
      private function getHoleIndex(pID:int) : int
      {
         var vResult:int = -1;
         switch(pID)
         {
            case 13:
               vResult = 0;
               break;
            case 14:
               vResult = 1;
               break;
            case 15:
               vResult = 2;
               break;
            case 16:
               vResult = 3;
               break;
            case 17:
               vResult = 4;
               break;
            case 18:
               vResult = 5;
               break;
            default:
               vResult = -1;
         }
         return vResult;
      }
      
      private function initEvent() : void
      {
         var o:EmbedStoneCell = null;
         beadSystemManager.Instance.addEventListener(BeadEvent.LIGHTBTN,this.__LightBtn);
         beadSystemManager.Instance.addEventListener(BeadEvent.OPENBEADHOLE,this.__onOpenHole);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.addEventListener(BeadEvent.EQUIPBEAD,this.__beadCellChanged);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__onPropBagUpdate);
         this._openHoleBtn.addEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         this._stateSelectBtn.addEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         this._beadFeedCell.addEventListener(BeadEvent.BEADCELLCHANGED,this.__feedCellChanged);
         this._beadFeedCell.addEventListener(CellEvent.ITEM_CLICK,this.__onFeedCellClick);
         for each(o in this._Cells)
         {
            o.addEventListener(CellEvent.ITEM_CLICK,this.__clickHandler);
            o.addEventListener(CellEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         }
         this._helpButton.addEventListener(MouseEvent.CLICK,this.__help);
      }
      
      private function removeEvent() : void
      {
         beadSystemManager.Instance.removeEventListener(BeadEvent.LIGHTBTN,this.__LightBtn);
         beadSystemManager.Instance.removeEventListener(BeadEvent.OPENBEADHOLE,this.__onOpenHole);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.removeEventListener(BeadEvent.EQUIPBEAD,this.__beadCellChanged);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__onPropBagUpdate);
         this._openHoleBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         this._stateSelectBtn.removeEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         this._beadFeedCell.removeEventListener(BeadEvent.BEADCELLCHANGED,this.__feedCellChanged);
         this._beadFeedCell.removeEventListener(CellEvent.ITEM_CLICK,this.__onFeedCellClick);
         this._helpButton.removeEventListener(MouseEvent.CLICK,this.__help);
      }
      
      private function __help(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("beadSystem.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("beadSystem.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.beadSystem.beadDisc");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onPropBagUpdate(event:Event) : void
      {
         this.updateBtn();
         this._stateSelectBtn.DrillItem;
      }
      
      private function __hideStateList(event:MouseEvent) : void
      {
         if(Boolean(this._stateList.parent))
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function __onOpenHole(pEvent:BeadEvent) : void
      {
         this.initHoleExp();
      }
      
      private function initHoleExp() : void
      {
         if(BeadModel.drillInfo.length > 0)
         {
            this._HoleOpen[13].HoleExp = BeadModel.drillInfo[131];
            this._HoleOpen[14].HoleExp = BeadModel.drillInfo[141];
            this._HoleOpen[15].HoleExp = BeadModel.drillInfo[151];
            this._HoleOpen[16].HoleExp = BeadModel.drillInfo[161];
            this._HoleOpen[17].HoleExp = BeadModel.drillInfo[171];
            this._HoleOpen[18].HoleExp = BeadModel.drillInfo[181];
            this._HoleOpen[13].HoleLv = BeadModel.drillInfo[132];
            this._HoleOpen[14].HoleLv = BeadModel.drillInfo[142];
            this._HoleOpen[15].HoleLv = BeadModel.drillInfo[152];
            this._HoleOpen[16].HoleLv = BeadModel.drillInfo[162];
            this._HoleOpen[17].HoleLv = BeadModel.drillInfo[172];
            this._HoleOpen[18].HoleLv = BeadModel.drillInfo[182];
            this.updateHoleProgress();
         }
      }
      
      private function __LightBtn(pEvent:BeadEvent) : void
      {
         this._beadGetView.buttonState(pEvent.CellId);
      }
      
      private function __beadCellChanged(pEvent:Event) : void
      {
         this.initBeadEquip();
      }
      
      private function updateHoleProgress() : void
      {
         var c:EmbedStoneCell = null;
         for each(c in this._HoleOpen)
         {
            if(c.selected)
            {
               if(c.HoleLv > BeadModel.tempHoleLv)
               {
                  c.holeLvUp();
                  BeadModel.tempHoleLv = c.HoleLv;
                  this.showDrill(c.HoleLv);
               }
               this._holeExpBar.setProgress(c.HoleExp,BeadModel.getHoleExpByLv(c.HoleLv));
               this._holeExpBar.tipData = c.HoleLv + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + c.HoleExp + "/" + BeadModel.getHoleExpByLv(c.HoleLv);
               break;
            }
         }
      }
      
      protected function __clickHandler(evt:CellEvent) : void
      {
         var o:EmbedStoneCell = null;
         var c:EmbedStoneCell = null;
         SoundManager.instance.play("008");
         var cell:EmbedStoneCell = evt.currentTarget as EmbedStoneCell;
         if(cell.selected)
         {
            cell.dragStart();
            return;
         }
         for each(o in this._Cells)
         {
            if(o.ID < 16)
            {
               if(o.ID == cell.ID)
               {
                  this._holeExpBar.setProgress(0);
                  this._holeExpBar.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.HoleNoSelect");
                  break;
               }
            }
         }
         for each(c in this._HoleOpen)
         {
            if(c.ID == cell.ID)
            {
               BeadModel.tempHoleLv = c.HoleLv;
               cell.selected = true;
               this._holeExpBar.setProgress(c.HoleExp,BeadModel.getHoleExpByLv(c.HoleLv));
               this._holeExpBar.tipData = c.HoleLv + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + c.HoleExp + "/" + BeadModel.getHoleExpByLv(c.HoleLv);
               this.showDrill(c.HoleLv);
            }
            else
            {
               c.selected = false;
            }
         }
         if(cell.ID < 13)
         {
            cell.dragStart();
         }
      }
      
      private function showDrill(value:int) : void
      {
         var itemID:int = 0;
         switch(value)
         {
            case 0:
               itemID = 11035;
               break;
            case 1:
               itemID = 11036;
               break;
            case 2:
               itemID = 11026;
               break;
            case 3:
               itemID = 11027;
               break;
            case 4:
               itemID = 11034;
         }
         var itemInfo:Array = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(itemID);
         if(itemInfo.length == 0 || value == 5)
         {
            if(value != 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",value + 1));
            }
            return;
         }
         var AllCount:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(itemID);
         var drillInfo:DrillItemInfo = new DrillItemInfo();
         drillInfo.itemInfo = itemInfo[0];
         drillInfo.amount = AllCount;
         this._stateSelectBtn.setValue(drillInfo);
      }
      
      private function __doubleClickHandler(event:CellEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var cell:EmbedStoneCell = event.data as EmbedStoneCell;
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendBeadEquip(info.Place,-1);
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 1; i <= 19; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("bead.Embedpoint" + i);
            this._pointArray.push(point);
         }
      }
      
      private function initBeadEquip() : void
      {
         var o:EmbedStoneCell = null;
         var e:EmbedStoneCell = null;
         for each(o in this._Cells)
         {
            o.info = null;
         }
         for each(e in this._Cells)
         {
            e.itemInfo = PlayerManager.Instance.Self.BeadBag.getItemAt(e.ID);
            e.info = PlayerManager.Instance.Self.BeadBag.getItemAt(e.ID);
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.BEAD_GUIDE) && Boolean(e.info))
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.BEAD_GUIDE);
               SocketManager.Instance.out.syncWeakStep(Step.BEAD_GUIDE);
            }
         }
         this._beadFeedCell.invenItemInfo = this._beadFeedCell.itemInfo = PlayerManager.Instance.Self.BeadBag.getItemAt(31);
         this._beadFeedCell.info = PlayerManager.Instance.Self.BeadBag.getItemAt(31);
      }
      
      private function __onFeedCellClick(pEvent:CellEvent) : void
      {
         var cell:EmbedUpLevelCell = pEvent.currentTarget as EmbedUpLevelCell;
         if(Boolean(cell.info))
         {
            cell.dragStart();
         }
      }
      
      public function dispose() : void
      {
         var o:EmbedStoneCell = null;
         this.removeEvent();
         this._openHoleBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._progressLevel))
         {
            ObjectUtils.disposeObject(this._progressLevel);
         }
         this._progressLevel = null;
         if(Boolean(this._holeExpBar))
         {
            ObjectUtils.disposeObject(this._holeExpBar);
         }
         this._holeExpBar = null;
         if(Boolean(this._beadGetView))
         {
            ObjectUtils.disposeObject(this._beadGetView);
         }
         this._beadGetView = null;
         if(Boolean(this._openHoleBtn))
         {
            ObjectUtils.disposeObject(this._openHoleBtn);
         }
         this._openHoleBtn = null;
         if(Boolean(this._stateList))
         {
            ObjectUtils.disposeObject(this._stateList);
         }
         this._stateList = null;
         if(Boolean(this._stateSelectBtn))
         {
            ObjectUtils.disposeObject(this._stateSelectBtn);
         }
         this._stateSelectBtn = null;
         if(Boolean(this._beadFeedCell))
         {
            ObjectUtils.disposeObject(this._beadFeedCell);
         }
         this._beadFeedCell = null;
         if(Boolean(this._beadUpGradeTxt))
         {
            ObjectUtils.disposeObject(this._beadUpGradeTxt);
         }
         this._beadUpGradeTxt = null;
         if(this._Cells.length > 0)
         {
            for each(o in this._Cells)
            {
               o.removeEventListener(CellEvent.ITEM_CLICK,this.__clickHandler);
               o.removeEventListener(CellEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               ObjectUtils.disposeObject(o);
            }
         }
         if(Boolean(this._helpButton))
         {
            ObjectUtils.disposeObject(this._helpButton);
         }
         this._helpButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

