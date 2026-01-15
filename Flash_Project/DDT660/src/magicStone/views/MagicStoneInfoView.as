package magicStone.views
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import game.GameManager;
   import magicStone.MagicStoneManager;
   import magicStone.components.EmbedMgStoneCell;
   import magicStone.components.MagicStoneConfirmView;
   import magicStone.components.MagicStoneProgress;
   import magicStone.components.MgStoneCell;
   import magicStone.components.MgStoneUtils;
   import magicStone.data.MagicStoneEvent;
   import magicStone.stoneExploreView.StoneExploreView;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   import road7th.data.DictionaryData;
   import trainer.view.NewHandContainer;
   
   public class MagicStoneInfoView extends Sprite implements Disposeable
   {
      
      private static const CELL_LEN:int = 9;
      
      public static const UPDATE_CELL:int = 31;
      
      private var _bg:Bitmap;
      
      private var _lightBg:Bitmap;
      
      private var _whiteStone:Bitmap;
      
      private var _blueStone:Bitmap;
      
      private var _purpleStone:Bitmap;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _covertBtn:TextButton;
      
      private var _exploreBtn:SimpleBitmapButton;
      
      private var _exploreBatBtn:SimpleBitmapButton;
      
      private var _doubleScore:FilterFrameText;
      
      private var _oneLineTip:OneLineTip;
      
      private var _lightFilters:Array;
      
      private var _progress:MagicStoneProgress;
      
      private var _mgStoneCells:Vector.<EmbedMgStoneCell>;
      
      private var _cells:Dictionary;
      
      public var selectedIndex:int;
      
      private var _mgStonebag:BagInfo;
      
      private var _character:RoomCharacter;
      
      private var _currentModel:DressModel;
      
      private var _helpTxt:FilterFrameText;
      
      private var _stoneExploreBtn:SimpleBitmapButton;
      
      private var _stoneExploreView:StoneExploreView;
      
      public function MagicStoneInfoView()
      {
         super();
         this.selectedIndex = 1;
         this._mgStoneCells = new Vector.<EmbedMgStoneCell>();
         this._cells = new Dictionary();
         MagicStoneManager.instance.infoView = this;
         this._currentModel = new DressModel();
         this.updateModel();
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      public function updataCharacter(_info:PlayerInfo) : void
      {
         if(Boolean(this._character))
         {
            this._character.dispose();
            this._character = null;
         }
         this._character = CharactoryFactory.createCharacter(_info,"room") as RoomCharacter;
         this._character.showGun = false;
         this._character.show(false,-1);
         PositionUtils.setPos(this._character,"magicStone.characterPos");
         addChild(this._character);
      }
      
      private function initView() : void
      {
         var place:int = 0;
         var cell:EmbedMgStoneCell = null;
         this._bg = ComponentFactory.Instance.creat("magicStone.bg");
         addChild(this._bg);
         this._lightBg = ComponentFactory.Instance.creat("magicStone.lightBg");
         addChild(this._lightBg);
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.scoreTxt");
         addChild(this._scoreTxt);
         this._scoreTxt.text = "12354";
         this._covertBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.covertBtn");
         addChild(this._covertBtn);
         this._covertBtn.text = LanguageMgr.GetTranslation("magicStone.covertBtnTxt");
         this._exploreBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.exploreBtn");
         addChild(this._exploreBtn);
         this._exploreBatBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.exploreBatBtn");
         addChild(this._exploreBatBtn);
         this._progress = new MagicStoneProgress();
         PositionUtils.setPos(this._progress,"magicStone.progressPos");
         addChild(this._progress);
         this.updataCharacter(this._currentModel.model);
         for(var i:int = 0; i <= CELL_LEN - 1; i++)
         {
            place = MgStoneUtils.getPlace(i);
            cell = CellFactory.instance.createEmbedMgStoneCell(place) as EmbedMgStoneCell;
            cell.addEventListener(InteractiveEvent.CLICK,this.__cellClickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            PositionUtils.setPos(cell,"magicStone.mgStoneCellPos" + i);
            addChild(cell);
            this._mgStoneCells.push(cell);
            this._cells[place] = cell;
         }
         this._whiteStone = ComponentFactory.Instance.creat("magicStone.white");
         this._lightFilters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._doubleScore = ComponentFactory.Instance.creatComponentByStylename("magicStone.doubleScore");
         this._doubleScore.text = LanguageMgr.GetTranslation("magicStone.doubleScoreTxt");
         addChild(this._doubleScore);
         this._doubleScore.visible = MagicStoneManager.instance.isDoubleScore;
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("magicStone.helpTxt.LG");
         addChild(this._helpTxt);
         this._stoneExploreBtn = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExploreBtn");
         addChild(this._stoneExploreBtn);
         if(GameManager.exploreOver)
         {
            GameManager.exploreOver = false;
            this.__stoneExploreClick(null);
         }
      }
      
      public function updateModel() : void
      {
         var sItem:InventoryItemInfo = null;
         var tItem:InventoryItemInfo = null;
         var i:int = 0;
         var templateId:int = 0;
         var itemId:int = 0;
         var key:int = 0;
         var _self:SelfInfo = PlayerManager.Instance.Self;
         var _currentIndex:int = PlayerDressManager.instance.currentIndex;
         if(_self.Sex)
         {
            this._currentModel.model.updateStyle(_self.Sex,_self.Hide,DressModel.DEFAULT_MAN_STYLE,",,,,,,","");
         }
         else
         {
            this._currentModel.model.updateStyle(_self.Sex,_self.Hide,DressModel.DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
         var _bodyThings:DictionaryData = new DictionaryData();
         var dressArr:Array = PlayerDressManager.instance.modelArr[_currentIndex];
         var reSave:Boolean = false;
         if(Boolean(dressArr))
         {
            for(i = 0; i <= dressArr.length - 1; i++)
            {
               templateId = (dressArr[i] as DressVo).templateId;
               itemId = (dressArr[i] as DressVo).itemId;
               tItem = new InventoryItemInfo();
               sItem = _self.Bag.getItemByItemId(itemId);
               if(!sItem)
               {
                  sItem = _self.Bag.getItemByTemplateId(templateId);
                  reSave = true;
               }
               if(Boolean(sItem))
               {
                  tItem.setIsUsed(sItem.IsUsed);
                  ObjectUtils.copyProperties(tItem,sItem);
                  key = DressUtils.findItemPlace(tItem);
                  _bodyThings.add(key,tItem);
                  if(tItem.CategoryID == EquipType.FACE)
                  {
                     this._currentModel.model.Skin = tItem.Skin;
                  }
                  this._currentModel.model.setPartStyle(tItem.CategoryID,tItem.NeedSex,tItem.TemplateID,tItem.Color);
               }
            }
         }
         this._currentModel.model.Bag.items = _bodyThings;
      }
      
      private function initData() : void
      {
         var place:int = 0;
         var item:InventoryItemInfo = null;
         this._mgStonebag = PlayerManager.Instance.Self.magicStoneBag;
         this.clearCells();
         for(var i:int = 0; i <= CELL_LEN - 1; i++)
         {
            place = MgStoneUtils.getPlace(i);
            item = this._mgStonebag.getItemAt(place);
            if(Boolean(item))
            {
               this.setCellInfo(item.Place,item);
            }
         }
         this.updateProgress();
      }
      
      private function updateProgress() : void
      {
         var completed:int = 0;
         var total:int = 0;
         var updateItem:InventoryItemInfo = this._mgStonebag.getItemAt(UPDATE_CELL);
         if(Boolean(updateItem))
         {
            completed = updateItem.StrengthenExp - MagicStoneManager.instance.getNeedExp(updateItem.TemplateID,updateItem.StrengthenLevel);
            total = MagicStoneManager.instance.getNeedExpPerLevel(updateItem.TemplateID,updateItem.StrengthenLevel + 1);
            this._progress.setData(completed,total);
         }
         else
         {
            this._progress.setData(0,0);
         }
      }
      
      private function clearCells() : void
      {
         for(var i:int = 0; i <= CELL_LEN - 1; i++)
         {
            this._mgStoneCells[i].info = null;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._covertBtn.addEventListener(MouseEvent.CLICK,this.__covertBtnClick);
         this._exploreBtn.addEventListener(MouseEvent.CLICK,this.__exploreBtnClick);
         this._exploreBatBtn.addEventListener(MouseEvent.CLICK,this.__exploreBatBtnClick);
         this._stoneExploreBtn.addEventListener(MouseEvent.CLICK,this.__stoneExploreClick);
         PlayerManager.Instance.Self.magicStoneBag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         MagicStoneManager.instance.addEventListener(MagicStoneEvent.MAGIC_STONE_DOUBLESCORE,this.__magicStoneDoubleScore);
         MagicStoneManager.instance.addEventListener(MagicStoneManager.SHOWEXPLOREVIEW,this.__showExploreView);
      }
      
      private function __magicStoneDoubleScore(evt:MagicStoneEvent) : void
      {
         this._doubleScore.visible = MagicStoneManager.instance.isDoubleScore;
      }
      
      protected function __cellClickHandler(event:InteractiveEvent) : void
      {
         if((event.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,event.currentTarget,false,false,event.ctrlKey));
         }
      }
      
      protected function __doubleClickHandler(event:InteractiveEvent) : void
      {
         var info:InventoryItemInfo = (event.currentTarget as BagCell).info as InventoryItemInfo;
         if(info != null)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this.isBagFull())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.bagFull"));
            }
            else
            {
               SocketManager.Instance.out.moveMagicStone(info.Place,-1);
            }
         }
      }
      
      private function isBagFull() : Boolean
      {
         var item:InventoryItemInfo = null;
         for(var i:int = MgStoneUtils.BAG_START; i <= MgStoneUtils.BAG_END; i++)
         {
            item = this._mgStonebag.getItemAt(i);
            if(!item)
            {
               return false;
            }
         }
         return true;
      }
      
      protected function __cellClick(event:CellEvent) : void
      {
         var info:InventoryItemInfo = null;
         event.stopImmediatePropagation();
         var cell:MgStoneCell = event.data as MgStoneCell;
         if(Boolean(cell))
         {
            info = cell.itemInfo as InventoryItemInfo;
         }
         if(info == null)
         {
            return;
         }
         if(!cell.locked)
         {
            SoundManager.instance.play("008");
            cell.dragStart();
         }
      }
      
      protected function __updateGoods(event:BagEvent) : void
      {
         var item:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var changes:Dictionary = event.changedSlots;
         for each(item in changes)
         {
            if(item.Place >= 0 && item.Place <= UPDATE_CELL)
            {
               c = this._mgStonebag.getItemAt(item.Place);
               if(Boolean(c))
               {
                  this.setCellInfo(c.Place,c);
               }
               else
               {
                  this.setCellInfo(item.Place,null);
               }
               MagicStoneManager.instance.removeWeakGuide(2);
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
         this.updateProgress();
      }
      
      public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         var key:String = String(index);
         if(info == null)
         {
            if(Boolean(this._cells[key]))
            {
               this._cells[key].info = null;
            }
            return;
         }
         if(info.Count == 0)
         {
            this._cells[key].info = null;
         }
         else
         {
            this._cells[key].info = info;
         }
      }
      
      protected function __covertBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:MagicStoneShopFrame = ComponentFactory.Instance.creatCustomObject("magicStone.magicStoneShopFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      protected function __exploreBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpNeedMoney:int = this.getNeedMoney();
         if(MagicStoneManager.instance.isNoPrompt)
         {
            if(!(!MagicStoneManager.instance.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney))
            {
               SocketManager.Instance.out.exploreMagicStone(this.selectedIndex,MagicStoneManager.instance.isBand);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
            MagicStoneManager.instance.isNoPrompt = false;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("magicStone.exploreConfirmTxt",this.getNeedMoney()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"magicStone.confirmView",30,true,AlertManager.SELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
      }
      
      private function comfirmHandler(event:FrameEvent) : void
      {
         var tmpNeedMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            tmpNeedMoney = this.getNeedMoney();
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as MagicStoneConfirmView).isNoPrompt)
            {
               MagicStoneManager.instance.isNoPrompt = true;
               MagicStoneManager.instance.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.exploreMagicStone(this.selectedIndex,confirmFrame.isBand);
         }
      }
      
      public function getNeedMoney() : int
      {
         var serverStr:String = null;
         var strArr:Array = null;
         var arr:Array = null;
         var obj:Object = ServerConfigManager.instance.serverConfigInfo["OpenMagicBoxMoney"];
         if(Boolean(obj))
         {
            serverStr = obj.Value;
            if(Boolean(serverStr) && serverStr != "")
            {
               strArr = serverStr.split("|");
               if(Boolean(strArr[this.selectedIndex - 1]))
               {
                  arr = strArr[this.selectedIndex - 1].split(",");
                  return parseInt(arr[0]);
               }
            }
         }
         return 0;
      }
      
      public function getNeedMoney2(index:int) : int
      {
         var serverStr:String = null;
         var strArr:Array = null;
         var arr:Array = null;
         var obj:Object = ServerConfigManager.instance.serverConfigInfo["OpenMagicBoxMoney"];
         if(Boolean(obj))
         {
            serverStr = obj.Value;
            if(Boolean(serverStr) && serverStr != "")
            {
               strArr = serverStr.split("|");
               if(Boolean(strArr[index]))
               {
                  arr = strArr[index].split(",");
                  return parseInt(arr[0]);
               }
            }
         }
         return 0;
      }
      
      protected function __exploreBatBtnClick(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var remain:int = this.getBagRemain();
         var tmpNeedMoney:int = this.getNeedMoney() * 10;
         if(MagicStoneManager.instance.isBatNoPrompt)
         {
            if(!(!MagicStoneManager.instance.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney))
            {
               SocketManager.Instance.out.exploreMagicStone(this.selectedIndex,false,10);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
            MagicStoneManager.instance.isBatNoPrompt = false;
         }
         if(remain == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.bagFull"));
         }
         else
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("magicStone.exploreConfirmBatTxt",this.getNeedMoney() * 10),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"magicStone.confirmView",30,true,AlertManager.SELECTBTN);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.exploreBatHandler,false,0,true);
         }
      }
      
      private function exploreBatHandler(event:FrameEvent) : void
      {
         var tmpNeedMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.exploreBatHandler);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            tmpNeedMoney = this.getNeedMoney();
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as MagicStoneConfirmView).isNoPrompt)
            {
               MagicStoneManager.instance.isBatNoPrompt = true;
               MagicStoneManager.instance.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.exploreMagicStone(this.selectedIndex,false,10);
         }
      }
      
      private function reConfirmBatHandler(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmBatHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = this.getNeedMoney();
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.exploreMagicStone(this.selectedIndex,confirmFrame.isBand);
         }
      }
      
      private function getBagRemain() : int
      {
         var item:InventoryItemInfo = null;
         var count:int = 0;
         for(var i:int = MgStoneUtils.BAG_START; i <= MgStoneUtils.BAG_END; i++)
         {
            item = this._mgStonebag.getItemAt(i);
            if(!item)
            {
               count++;
            }
         }
         return count;
      }
      
      private function __stoneExploreClick(e:MouseEvent) : void
      {
         SocketManager.Instance.out.sendCheckMagicStoneNumber();
      }
      
      private function __showExploreView(e:Event) : void
      {
         this._stoneExploreView = ComponentFactory.Instance.creatComponentByStylename("MagicStone.StoneExploreViewFrame");
         LayerManager.Instance.addToLayer(this._stoneExploreView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function updateScore(num:int) : void
      {
         this._scoreTxt.text = num.toString();
      }
      
      private function removeEvents() : void
      {
         removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._covertBtn.removeEventListener(MouseEvent.CLICK,this.__covertBtnClick);
         this._exploreBtn.removeEventListener(MouseEvent.CLICK,this.__exploreBtnClick);
         this._exploreBatBtn.removeEventListener(MouseEvent.CLICK,this.__exploreBatBtnClick);
         this._stoneExploreBtn.removeEventListener(MouseEvent.CLICK,this.__stoneExploreClick);
         PlayerManager.Instance.Self.magicStoneBag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         MagicStoneManager.instance.removeEventListener(MagicStoneEvent.MAGIC_STONE_DOUBLESCORE,this.__magicStoneDoubleScore);
         MagicStoneManager.instance.removeEventListener(MagicStoneManager.SHOWEXPLOREVIEW,this.__showExploreView);
         for(var i:int = 0; i <= this._mgStoneCells.length - 1; i++)
         {
            if(Boolean(this._mgStoneCells[i]))
            {
               this._mgStoneCells[i].removeEventListener(InteractiveEvent.CLICK,this.__cellClickHandler);
               this._mgStoneCells[i].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            }
         }
      }
      
      public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(-1);
         MagicStoneManager.instance.infoView = null;
         if(Boolean(this._cells[UPDATE_CELL]) && Boolean(this._cells[UPDATE_CELL].info))
         {
            if(!this.isBagFull())
            {
               SocketManager.Instance.out.moveMagicStone(UPDATE_CELL,-1);
            }
         }
         this.removeEvents();
         for(var i:int = 0; i <= this._mgStoneCells.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._mgStoneCells[i]);
            this._mgStoneCells[i] = null;
         }
         this._cells = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._lightBg);
         this._lightBg = null;
         ObjectUtils.disposeObject(this._whiteStone);
         this._whiteStone = null;
         ObjectUtils.disposeObject(this._blueStone);
         this._blueStone = null;
         ObjectUtils.disposeObject(this._purpleStone);
         this._purpleStone = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._covertBtn);
         this._covertBtn = null;
         ObjectUtils.disposeObject(this._exploreBtn);
         this._exploreBtn = null;
         ObjectUtils.disposeObject(this._exploreBatBtn);
         this._exploreBatBtn = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._oneLineTip);
         this._oneLineTip = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._doubleScore);
         this._doubleScore = null;
      }
   }
}

