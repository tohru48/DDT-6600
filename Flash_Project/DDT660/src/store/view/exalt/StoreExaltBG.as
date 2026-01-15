package store.view.exalt
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.StrengthDataManager;
   import store.data.StoreEquipExperience;
   import store.events.StoreIIEvent;
   import store.view.strength.StrengthStone;
   
   public class StoreExaltBG extends Sprite implements IStoreViewBG
   {
      
      public static const INTERVAL:int = 1400;
      
      private var _titleBG:Bitmap;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _exaltBtn:BaseButton;
      
      private var _progressBar:StoreExaltProgressBar;
      
      private var _equipmentCellBg:Image;
      
      private var _goodCellBg:Bitmap;
      
      private var _equipmentCellText:FilterFrameText;
      
      private var _rockText:FilterFrameText;
      
      private var _pointArray:Vector.<Point>;
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _quick:QuickBuyFrame;
      
      private var _continuous:SelectedCheckButton;
      
      private var _timer:Timer;
      
      private var _helpBtn:BaseButton;
      
      private var _movieI:MovieClip;
      
      private var _movieII:MovieClip;
      
      private var _luckyText:FilterFrameText;
      
      private var _lastExaltTime:int = 0;
      
      private var _aler:ExaltSelectNumAlertFrame;
      
      public function StoreExaltBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:int = 0;
         var item:StoreCell = null;
         this._titleBG = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.TitleText",this);
         this._buyBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.buyBtn",this);
         this._exaltBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.exaltBtn",this);
         this._progressBar = UICreatShortcut.creatAndAdd("store.view.exalt.storeExaltProgressBar",this);
         this._progressBar.progress(0,0);
         this._helpBtn = UICreatShortcut.creatAndAdd("ddtstore.HelpButton",this);
         this._continuous = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.SelectedCheckButton",this);
         this._continuous.selected = false;
         this._equipmentCellBg = UICreatShortcut.creatAndAdd("ddtstore.StoreIIStrengthBG.stoneCellBg",this);
         PositionUtils.setPos(this._equipmentCellBg,"ddtstore.StoreIIStrengthBG.EquipmentCellBgPos");
         this._equipmentCellText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText",LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText"),this);
         PositionUtils.setPos(this._equipmentCellText,"ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
         this._goodCellBg = UICreatShortcut.creatAndAdd("asset.ddtstore.GoodPanel",this);
         PositionUtils.setPos(this._goodCellBg,"ddtstore.StoreIIStrengthBG.StrengthCellBg1Point");
         this._rockText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.GoodCellText",LanguageMgr.GetTranslation("store.Strength.GoodPanelText.StoreExaltRock"),this);
         PositionUtils.setPos(this._rockText,"ddtstore.StoreIIStrengthBG.StrengthStoneText1Point");
         this.getCellsPoint();
         this._items = new Array();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         for(i = 0; i < this._pointArray.length; i++)
         {
            switch(i)
            {
               case 0:
                  item = new StrengthStone([StoneType.EXALT,StoneType.EXALT_1],i);
                  break;
               case 1:
                  item = new ExaltItemCell(i);
                  break;
            }
            item.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i] = item;
            item.x = this._pointArray[i].x;
            item.y = this._pointArray[i].y;
            addChild(item);
         }
      }
      
      private function initEvent() : void
      {
         this._exaltBtn.addEventListener(MouseEvent.CLICK,this.__onExaltClick);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._continuous.addEventListener(MouseEvent.CLICK,this.__continuousClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
         StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i].dispose();
         }
         this._exaltBtn.removeEventListener(MouseEvent.CLICK,this.__onExaltClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._continuous.removeEventListener(MouseEvent.CLICK,this.__continuousClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
         StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
      }
      
      protected function __exaltFinish(event:StoreIIEvent) : void
      {
         this.showSuccessMovie();
      }
      
      protected function __exaltFail(event:StoreIIEvent) : void
      {
         var tempW:int = 0;
         var tempH:int = 0;
         var tempY:int = 0;
         ObjectUtils.disposeObject(this._luckyText);
         this._luckyText = null;
         this._luckyText = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.luckyText");
         this._luckyText.text = LanguageMgr.GetTranslation("store.view.exalt.luckyTips",int(event.data));
         tempW = this._luckyText.width;
         tempH = this._luckyText.height;
         tempY = this._luckyText.y;
         this._luckyText.width /= 2;
         this._luckyText.height /= 2;
         this._luckyText.alpha = 0.5;
         TweenMax.fromTo(this._luckyText,2,{
            "y":tempY - 30,
            "alpha":1,
            "width":tempW,
            "height":tempH
         },{
            "y":tempY - 60,
            "alpha":0,
            "width":0,
            "height":0,
            "onComplete":this.onComplete
         });
         addChild(this._luckyText);
         SoundManager.instance.play("171");
         if(this._continuous.selected)
         {
            setTimeout(this.sendExalt,1000);
         }
      }
      
      private function onComplete() : void
      {
         ObjectUtils.disposeObject(this._luckyText);
         this._luckyText = null;
      }
      
      protected function __helpClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var movie:MovieClip = ComponentFactory.Instance.creatCustomObject("store.view.exalt.HelpBG");
         var frame:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         frame.setView(movie);
         frame.titleText = LanguageMgr.GetTranslation("store.StoreExaltBG.say");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      protected function __continuousClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._continuous.selected)
         {
            this.disposeTimer();
         }
      }
      
      private function disposeTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onRepeatCount);
            this._timer = null;
            this._exaltBtn.enable = true;
         }
      }
      
      protected function __onRepeatCount(event:TimerEvent) : void
      {
         if(this.isExalt() && this.equipisAdapt(this._items[1].info))
         {
            this.sendExalt();
         }
         else
         {
            this.disposeTimer();
         }
      }
      
      protected function __onBuyClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.buyRock();
      }
      
      protected function __onExaltClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var time:int = getTimer();
         if(time - this._lastExaltTime > INTERVAL)
         {
            this._lastExaltTime = time;
            this.sendExalt();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
         }
      }
      
      private function sendContinuousExalt() : void
      {
         if(this.isExalt())
         {
            if(this._continuous.selected)
            {
               this._timer = new Timer(INTERVAL);
               this._timer.addEventListener(TimerEvent.TIMER,this.__onRepeatCount);
               this._timer.start();
               this._exaltBtn.enable = false;
            }
            else
            {
               this.disposeTimer();
            }
         }
      }
      
      private function sendExalt() : void
      {
         if(this.isExalt())
         {
            SocketManager.Instance.out.sendItemExalt();
            this.showExaltMovie();
         }
      }
      
      private function isExalt() : Boolean
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         if(this._items == null)
         {
            return false;
         }
         if(StrengthStone(this._items[0]).itemInfo == null || ExaltItemCell(this._items[1]).itemInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warning"));
            return false;
         }
         if(Boolean(this._items[1].info) && this._items[1].info.StrengthenLevel >= 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
            return false;
         }
         if(int(this._items[0].info.Property3) != 0)
         {
            if(this._items[1].info.StrengthenLevel - 11 == int(this._items[0].info.Property3))
            {
               return true;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningII"));
            return false;
         }
         return true;
      }
      
      private function getCellsPoint() : void
      {
         this._pointArray = new Vector.<Point>();
         var point:Point = ComponentFactory.Instance.creatCustomObject("store.view.exalt.StoreExaltBG.point0");
         this._pointArray.push(point);
         var point2:Point = ComponentFactory.Instance.creatCustomObject("store.view.exalt.StoreExaltBG.point1");
         this._pointArray.push(point2);
      }
      
      protected function __itemInfoChange(event:Event) : void
      {
         var itemCell:ExaltItemCell = null;
         var info:InventoryItemInfo = null;
         var max:int = 0;
         if(event.currentTarget is ExaltItemCell)
         {
            itemCell = event.currentTarget as ExaltItemCell;
            info = itemCell.info as InventoryItemInfo;
            if(Boolean(info))
            {
               if(ExaltItemCell(this._items[1]).actionState)
               {
                  ExaltItemCell(this._items[1]).actionState = false;
               }
               max = int(StoreEquipExperience.expericence[info.StrengthenLevel + 1]);
               if(max == 0)
               {
                  this._progressBar.progress(0,0);
               }
               else
               {
                  this._progressBar.progress(info.StrengthenExp,max);
               }
            }
            else
            {
               this._progressBar.progress(0,0);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function showSuccessMovie() : void
      {
         if(Boolean(this._movieI))
         {
            this._movieI.stop();
         }
         ObjectUtils.disposeObject(this._movieI);
         this._movieI = null;
         this._movieI = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieI",this);
         this._movieI.gotoAndPlay(1);
         this._movieI.addFrameScript(this._movieI.totalFrames - 1,this.disposeSuccessMovie);
      }
      
      private function showExaltMovie() : void
      {
         if(Boolean(this._movieII))
         {
            this._movieII.stop();
         }
         else
         {
            this._movieII = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieII",this);
         }
         this._movieII.gotoAndPlay(1);
         this._movieII.addFrameScript(this._movieII.totalFrames - 1,this.disposeExaltMovie);
      }
      
      private function disposeExaltMovie() : void
      {
         if(Boolean(this._movieII))
         {
            this._movieII.stop();
         }
         ObjectUtils.disposeObject(this._movieII);
         this._movieII = null;
      }
      
      private function disposeSuccessMovie() : void
      {
         if(Boolean(this._movieI))
         {
            this._movieI.stop();
         }
         ObjectUtils.disposeObject(this._movieI);
         this._movieI = null;
      }
      
      private function buyRock() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quick.itemID = EquipType.EXALT_ROCK;
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dragDrop(source:BagCell) : void
      {
         var ds:StoreCell = null;
         if(source == null)
         {
            return;
         }
         var info:InventoryItemInfo = source.info as InventoryItemInfo;
         for each(ds in this._items)
         {
            if(ds.info == info)
            {
               ds.info = null;
               source.locked = false;
               return;
            }
         }
         for each(ds in this._items)
         {
            if(Boolean(ds))
            {
               if(ds is StoneCell)
               {
                  if((ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
                  {
                     if(this.isAdaptToStone(info))
                     {
                        if(info.Count == 1)
                        {
                           SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1,true);
                        }
                        else
                        {
                           this.showNumAlert(info,ds.index);
                        }
                        return;
                     }
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                  }
               }
               else if(ds is ExaltItemCell)
               {
                  if(info.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else if(source.info.CanStrengthen && this.equipisAdapt(info))
                  {
                     SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
                     ExaltItemCell(this._items[1]).actionState = true;
                     return;
                  }
               }
            }
         }
         if(EquipType.isExaltStone(info))
         {
            for each(ds in this._items)
            {
               if(ds is StoneCell && (ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
               {
                  if(this.isAdaptToStone(info))
                  {
                     if(info.Count == 1)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1,true);
                     }
                     else
                     {
                        this.showNumAlert(info,ds.index);
                     }
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
               }
            }
         }
      }
      
      private function showNumAlert(info:InventoryItemInfo, index:int) : void
      {
         this._aler = ComponentFactory.Instance.creat("store.view.exalt.exaltSelectNumAlertFrame");
         this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
         this._aler.goodsinfo = info;
         this._aler.index = index;
         this._aler.show(info.Count);
      }
      
      private function sellFunction(_nowNum:int, goodsinfo:InventoryItemInfo, index:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(goodsinfo.BagType,goodsinfo.Place,BagInfo.STOREBAG,index,_nowNum,true);
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function isAdaptToStone(info:InventoryItemInfo) : Boolean
      {
         if(this._items[0].info != null && this._items[0].info.Property1 != info.Property1)
         {
            return false;
         }
         return true;
      }
      
      private function equipisAdapt(info:InventoryItemInfo) : Boolean
      {
         if(info.StrengthenLevel >= 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
            return false;
         }
         return true;
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         for(place in items)
         {
            itemPlace = int(place);
            if(this._items.hasOwnProperty(itemPlace))
            {
               this._items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            }
         }
      }
      
      public function updateData() : void
      {
         if(Boolean(PlayerManager.Instance.Self.StoreBag.items[0]) && this.isAdaptToStone(PlayerManager.Instance.Self.StoreBag.items[0]))
         {
            this._items[0].info = PlayerManager.Instance.Self.StoreBag.items[0];
         }
         else
         {
            this._items[0].info = null;
         }
         if(Boolean(PlayerManager.Instance.Self.StoreBag.items[1]) && EquipType.isStrengthStone(PlayerManager.Instance.Self.StoreBag.items[1]))
         {
            this._items[1].info = PlayerManager.Instance.Self.StoreBag.items[1];
         }
         else
         {
            this._items[1].info = null;
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
         this._items[0].info = null;
         this._items[1].info = null;
         this.disposeTimer();
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeExaltMovie();
         ObjectUtils.disposeObject(this._titleBG);
         this._titleBG = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._exaltBtn);
         this._exaltBtn = null;
         ObjectUtils.disposeObject(this._progressBar);
         this._progressBar = null;
         ObjectUtils.disposeObject(this._equipmentCellBg);
         this._equipmentCellBg = null;
         ObjectUtils.disposeObject(this._goodCellBg);
         this._goodCellBg = null;
         ObjectUtils.disposeObject(this._equipmentCellText);
         this._equipmentCellText = null;
         ObjectUtils.disposeObject(this._rockText);
         this._rockText = null;
         ObjectUtils.disposeObject(this._area);
         this._area = null;
         ObjectUtils.disposeObject(this._quick);
         this._quick = null;
         ObjectUtils.disposeObject(this._continuous);
         this._continuous = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onRepeatCount);
            this._timer = null;
         }
         this._items = null;
      }
   }
}

