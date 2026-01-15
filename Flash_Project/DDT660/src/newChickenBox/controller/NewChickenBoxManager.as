package newChickenBox.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   import newChickenBox.events.NewChickenBoxEvents;
   import newChickenBox.model.NewChickenBoxModel;
   import newChickenBox.view.NewChickenBoxCell;
   import newChickenBox.view.NewChickenBoxFrame;
   import newChickenBox.view.NewChickenBoxItem;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class NewChickenBoxManager extends EventDispatcher
   {
      
      private static var _instance:NewChickenBoxManager = null;
      
      public var firstEnter:Boolean = true;
      
      private var _isOpen:Boolean = false;
      
      private var _model:NewChickenBoxModel;
      
      private var newChickenBoxFrame:NewChickenBoxFrame;
      
      private var timer:Timer;
      
      public function NewChickenBoxManager()
      {
         super();
         this._model = NewChickenBoxModel.instance;
      }
      
      public static function get instance() : NewChickenBoxManager
      {
         if(_instance == null)
         {
            _instance = new NewChickenBoxManager();
         }
         return _instance;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN,this.__init);
      }
      
      private function __init(event:CrazyTankSocketEvent) : void
      {
         this._isOpen = true;
         this.showNewBoxBtn();
         this.addSocketEvent();
         var pkg:PackageIn = event.pkg;
         this._model.canOpenCounts = pkg.readInt();
         this._model.openCardPrice = [];
         for(var i:int = 0; i < this._model.canOpenCounts; i++)
         {
            this._model.openCardPrice.push(pkg.readInt());
         }
         this._model.canEagleEyeCounts = pkg.readInt();
         this._model.eagleEyePrice = [];
         for(var j:int = 0; j < this._model.canEagleEyeCounts; j++)
         {
            this._model.eagleEyePrice.push(pkg.readInt());
         }
         this._model.flushPrice = pkg.readInt();
         this._model.endTime = pkg.readDate();
         WonderfulActivityManager.Instance.chickenEndTime = this._model.endTime;
      }
      
      public function showNewBoxBtn() : void
      {
         if(this._isOpen && PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.NEWCHICKENBOX,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.NEWCHICKENBOX,true,10);
         }
      }
      
      private function addSocketEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,this.__getItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CANCLICKCARDENABLE,this.__canclick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,this.__openCard);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,this.__openEye);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OVERSHOWITEMS,this.__overshow);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,this.__closeActivity);
      }
      
      private function __overshow(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this.timer = new Timer(50,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.sendOverShow);
         this.timer.start();
         var timer1:Timer = new Timer(5000,1);
         timer1.addEventListener(TimerEvent.TIMER_COMPLETE,this.sendAgain);
         timer1.start();
         if(Boolean(this.newChickenBoxFrame))
         {
            this.newChickenBoxFrame.closeButton.enable = false;
            this.newChickenBoxFrame.escEnable = false;
            this.newChickenBoxFrame.flushBnt.enable = false;
         }
      }
      
      private function sendAgain(e:TimerEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.newTurnStart"));
         this._model.countTime = 0;
         this._model.countEye = 0;
         this._model.canclickEnable = false;
         if(Boolean(this.newChickenBoxFrame))
         {
            this.newChickenBoxFrame.startBnt.enable = true;
            this.newChickenBoxFrame.eyeBtn.enable = false;
            this.newChickenBoxFrame.openCardBtn.enable = false;
            SocketManager.Instance.out.sendNewChickenBox();
            this.newChickenBoxFrame.closeButton.enable = true;
            this.newChickenBoxFrame.escEnable = true;
            this.newChickenBoxFrame.flushBnt.enable = true;
         }
      }
      
      private function sendOverShow(e:TimerEvent) : void
      {
         var times:int = 0;
         SocketManager.Instance.out.sendOverShowItems();
         this._model.countTime = 0;
         this._model.countEye = 0;
         if(Boolean(this.newChickenBoxFrame))
         {
            this.newChickenBoxFrame.startBnt.enable = false;
            this.newChickenBoxFrame.eyeBtn.enable = false;
            this.newChickenBoxFrame.openCardBtn.enable = false;
            times = this._model.canOpenCounts + 1 - this._model.countTime;
            this.newChickenBoxFrame.countNum.setFrame(times);
         }
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.sendOverShow);
         this.timer = null;
      }
      
      private function __canclick(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this._model.canclickEnable = pkg.readBoolean();
         this._model.dispatchEvent(new NewChickenBoxEvents(NewChickenBoxEvents.CANCLICKENABLE));
      }
      
      private function __getItem(e:CrazyTankSocketEvent) : void
      {
         var iteminfo:NewChickenBoxGoodsTempInfo = null;
         this._model.countTime = 0;
         this._model.countEye = 0;
         var pkg:PackageIn = e.pkg;
         this._model.lastFlushTime = pkg.readDate();
         this._model.freeFlushTime = pkg.readInt();
         this._model.freeRefreshBoxCount = pkg.readInt();
         this._model.freeEyeCount = pkg.readInt();
         this._model.freeOpenCardCount = pkg.readInt();
         this._model.isShowAll = pkg.readBoolean();
         this._model.boxCount = pkg.readInt();
         for(var i:int = 0; i < this._model.boxCount; i++)
         {
            iteminfo = new NewChickenBoxGoodsTempInfo();
            iteminfo.TemplateID = pkg.readInt();
            iteminfo.info = ItemManager.Instance.getTemplateById(iteminfo.TemplateID);
            iteminfo.StrengthenLevel = pkg.readInt();
            iteminfo.Count = pkg.readInt();
            iteminfo.ValidDate = pkg.readInt();
            iteminfo.AttackCompose = pkg.readInt();
            iteminfo.DefendCompose = pkg.readInt();
            iteminfo.AgilityCompose = pkg.readInt();
            iteminfo.LuckCompose = pkg.readInt();
            iteminfo.Position = pkg.readInt();
            iteminfo.IsSelected = pkg.readBoolean();
            iteminfo.IsSeeded = pkg.readBoolean();
            iteminfo.IsBinds = pkg.readBoolean();
            if(iteminfo.IsSelected)
            {
               ++this._model.countTime;
            }
            if(iteminfo.IsSeeded)
            {
               ++this._model.countEye;
            }
            if(this._model.isShowAll)
            {
               if(this.firstEnter)
               {
                  if(this._model.templateIDList.length == 18)
                  {
                     this._model.templateIDList[i] = iteminfo;
                  }
                  else
                  {
                     this._model.templateIDList.push(iteminfo);
                  }
                  this._model.countTime = 0;
                  this._model.countEye = 0;
               }
               else if(this._model.templateIDList.length == 18)
               {
                  this._model.templateIDList[i] = iteminfo;
               }
               this._model.canclickEnable = false;
            }
            else
            {
               if(this._model.templateIDList.length == 18)
               {
                  this._model.templateIDList[i] = iteminfo;
               }
               else
               {
                  this._model.templateIDList.push(iteminfo);
               }
               this._model.canclickEnable = true;
            }
         }
         this.loadModule();
      }
      
      private function showBoxFrame() : void
      {
         if(this.firstEnter)
         {
            this.newChickenBoxFrame = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.newChickenBoxFrame");
            if(this._model.isShowAll)
            {
               this.newChickenBoxFrame.startBnt.enable = true;
               this.newChickenBoxFrame.eyeBtn.enable = false;
               this.newChickenBoxFrame.openCardBtn.enable = false;
            }
            else
            {
               this.newChickenBoxFrame.startBnt.enable = false;
               this.newChickenBoxFrame.eyeBtn.enable = true;
               this.newChickenBoxFrame.openCardBtn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.firstEnterHelp"));
            }
            LayerManager.Instance.addToLayer(this.newChickenBoxFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.firstEnter = false;
            if(this._model.countEye < this._model.canEagleEyeCounts)
            {
               this.newChickenBoxFrame.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
            }
            else
            {
               this.newChickenBoxFrame.eyeBtn.enable = false;
            }
         }
         else if(Boolean(this.newChickenBoxFrame))
         {
            this.newChickenBoxFrame.newBoxView.getAllItem();
            this._model.canclickEnable = false;
            this.newChickenBoxFrame.firestGetTime();
            this.newChickenBoxFrame.refreshOpenCardBtnTxt();
            this.newChickenBoxFrame.refreshEagleEyeBtnTxt();
         }
      }
      
      private function loadModule() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEW_CHICKEN_BOX);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.NEW_CHICKEN_BOX)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.NEW_CHICKEN_BOX)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.showBoxFrame();
         }
      }
      
      private function __openCard(e:CrazyTankSocketEvent) : void
      {
         var bg:MovieClip = null;
         var pkg:PackageIn = e.pkg;
         var iteminfo:NewChickenBoxGoodsTempInfo = new NewChickenBoxGoodsTempInfo();
         iteminfo.TemplateID = pkg.readInt();
         iteminfo.info = ItemManager.Instance.getTemplateById(iteminfo.TemplateID);
         iteminfo.StrengthenLevel = pkg.readInt();
         iteminfo.Count = pkg.readInt();
         iteminfo.ValidDate = pkg.readInt();
         iteminfo.AttackCompose = pkg.readInt();
         iteminfo.DefendCompose = pkg.readInt();
         iteminfo.AgilityCompose = pkg.readInt();
         iteminfo.LuckCompose = pkg.readInt();
         iteminfo.Position = pkg.readInt();
         iteminfo.IsSelected = pkg.readBoolean();
         iteminfo.IsSeeded = pkg.readBoolean();
         iteminfo.IsBinds = pkg.readBoolean();
         this._model.freeOpenCardCount = pkg.readInt();
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,39,39);
         s.graphics.endFill();
         var cell:NewChickenBoxCell = new NewChickenBoxCell(s,iteminfo.info);
         if(iteminfo.IsSelected)
         {
            bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
         }
         else if(iteminfo.IsSeeded)
         {
            bg = ClassUtils.CreatInstance("asset.newChickenBox.chicken360") as MovieClip;
         }
         var item:NewChickenBoxItem = new NewChickenBoxItem(cell,bg);
         item.info = iteminfo;
         item.position = iteminfo.Position;
         this.newChickenBoxFrame.newBoxView.removeChild(this._model.itemList[iteminfo.Position]);
         this._model.itemList[iteminfo.Position] = item;
         this.newChickenBoxFrame.newBoxView.addChild(this._model.itemList[iteminfo.Position]);
         this._model.itemList[iteminfo.Position].bg = bg;
         this._model.itemList[iteminfo.Position].cell = cell;
         this._model.itemList[iteminfo.Position].cell.visible = false;
         var p:String = "newChickenBox.itemPos" + iteminfo.Position;
         PositionUtils.setPos(this._model.itemList[iteminfo.Position],p);
         ++this._model.countTime;
         var times:int = this._model.canOpenCounts + 1 - this._model.countTime;
         this.newChickenBoxFrame.countNum.setFrame(times);
         if(this._model.countTime >= this._model.canOpenCounts)
         {
            this.newChickenBoxFrame.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",0);
         }
         else
         {
            this.newChickenBoxFrame.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
         }
         this.newChickenBoxFrame.refreshOpenCardBtnTxt();
      }
      
      private function __openEye(e:CrazyTankSocketEvent) : void
      {
         var bg:MovieClip = null;
         var pkg:PackageIn = e.pkg;
         var iteminfo:NewChickenBoxGoodsTempInfo = new NewChickenBoxGoodsTempInfo();
         iteminfo.TemplateID = pkg.readInt();
         iteminfo.info = ItemManager.Instance.getTemplateById(iteminfo.TemplateID);
         iteminfo.StrengthenLevel = pkg.readInt();
         iteminfo.Count = pkg.readInt();
         iteminfo.ValidDate = pkg.readInt();
         iteminfo.AttackCompose = pkg.readInt();
         iteminfo.DefendCompose = pkg.readInt();
         iteminfo.AgilityCompose = pkg.readInt();
         iteminfo.LuckCompose = pkg.readInt();
         iteminfo.Position = pkg.readInt();
         iteminfo.IsSelected = pkg.readBoolean();
         iteminfo.IsSeeded = pkg.readBoolean();
         iteminfo.IsBinds = pkg.readBoolean();
         this._model.freeEyeCount = pkg.readInt();
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,39,39);
         s.graphics.endFill();
         var cell:NewChickenBoxCell = new NewChickenBoxCell(s,iteminfo.info);
         if(iteminfo.IsSelected)
         {
            bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
         }
         else if(iteminfo.IsSeeded)
         {
            bg = ClassUtils.CreatInstance("asset.newChickenBox.chicken360") as MovieClip;
         }
         ++this._model.countEye;
         var item:NewChickenBoxItem = new NewChickenBoxItem(cell,bg);
         item.info = iteminfo;
         item.position = iteminfo.Position;
         this.newChickenBoxFrame.newBoxView.removeChild(this._model.itemList[iteminfo.Position]);
         this._model.itemList[iteminfo.Position] = item;
         this.newChickenBoxFrame.newBoxView.addChild(this._model.itemList[iteminfo.Position]);
         this.newChickenBoxFrame.refreshEagleEyeBtnTxt();
         if(this._model.countEye < this._model.canEagleEyeCounts)
         {
            this.newChickenBoxFrame.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
         }
         else
         {
            this.newChickenBoxFrame.eyeBtn.enable = false;
            this.newChickenBoxFrame.setEyeLight(false);
            this.newChickenBoxFrame.setOpenCardLight(true);
            this._model.clickEagleEye = false;
         }
         this._model.itemList[iteminfo.Position].bg = bg;
         this._model.itemList[iteminfo.Position].cell = cell;
         this._model.itemList[iteminfo.Position].cell.visible = false;
         var p:String = "newChickenBox.itemPos" + iteminfo.Position;
         PositionUtils.setPos(this._model.itemList[iteminfo.Position],p);
         this.newChickenBoxFrame.newBoxView.getItemEvent(item);
      }
      
      public function enterNewBoxView(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendNewChickenBox();
      }
      
      private function removeSocketEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,this.__getItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CANCLICKCARDENABLE,this.__canclick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,this.__openCard);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,this.__openEye);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OVERSHOWITEMS,this.__overshow);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,this.__closeActivity);
      }
      
      private function __closeActivity(e:CrazyTankSocketEvent) : void
      {
         this._isOpen = false;
         this.firstEnter = true;
         this._model.canclickEnable = false;
         Mouse.show();
         this.removeSocketEvent();
         if(Boolean(this.newChickenBoxFrame))
         {
            this.newChickenBoxFrame.dispose();
            this.newChickenBoxFrame = null;
         }
         HallIconManager.instance.updateSwitchHandler(HallIconType.NEWCHICKENBOX,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.NEWCHICKENBOX,false);
      }
   }
}

