package boguAdventure
{
   import boguAdventure.event.BoguAdventureEvent;
   import boguAdventure.model.BoguAdventureCellInfo;
   import boguAdventure.model.BoguAdventureModel;
   import boguAdventure.model.BoguAdventureType;
   import boguAdventure.player.BoguAdventurePlayer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class BoguAdventureControl extends EventDispatcher
   {
      
      public static const SIGN_MAX_COUNT:int = 10;
      
      public var changeMouse:Boolean;
      
      public var currentIndex:int;
      
      private var _hp:int;
      
      public var isMove:Boolean;
      
      public var signFocus:Point;
      
      public var mineFocus:Point;
      
      public var mineNumFocus:Point;
      
      private var _bogu:BoguAdventurePlayer;
      
      private var _model:BoguAdventureModel;
      
      public function BoguAdventureControl()
      {
         super();
         this.init();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOGU_ADVENTURE,this.__onAllEvent);
      }
      
      private function init() : void
      {
         this._model = new BoguAdventureModel();
         this.signFocus = new Point(9,39);
         this.mineFocus = new Point(21,42);
         this.mineNumFocus = new Point(9,70);
      }
      
      private function __onAllEvent(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case BoguAdventureType.ENTER_BOGUADVENTURE:
               this.enterGame(pkg);
               break;
            case BoguAdventureType.UPDATE_CELL:
               this.updateCell(pkg);
               break;
            case BoguAdventureType.REVIVE_GAME:
               this.revive(pkg);
               break;
            case BoguAdventureType.ACQUIRE_AWARD:
               this.acquireAward(pkg);
               break;
            case BoguAdventureType.FREE_RESET:
               this._model.resetCount = pkg.readInt();
               this._model.isFreeReset = pkg.readBoolean();
               dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_RESET));
         }
      }
      
      private function enterGame(pkg:PackageIn) : void
      {
         var count:int = 0;
         var info:BoguAdventureCellInfo = null;
         var tip:String = null;
         var j:int = 0;
         var infoList:Vector.<BoguAdventureCellInfo> = new Vector.<BoguAdventureCellInfo>();
         this.currentIndex = pkg.readInt();
         this.hp = pkg.readInt();
         this._model.isAcquireAward1 = Boolean(pkg.readInt() == 1);
         this._model.isAcquireAward2 = Boolean(pkg.readInt() == 1);
         this._model.isAcquireAward3 = Boolean(pkg.readInt() == 1);
         this._model.openCount = pkg.readInt();
         this._model.findMinePrice = pkg.readInt();
         this._model.revivePrice = pkg.readInt();
         this._model.resetPrice = pkg.readInt();
         this._model.isFreeReset = pkg.readBoolean();
         this._model.resetCount = pkg.readInt();
         count = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            info = new BoguAdventureCellInfo();
            info.index = pkg.readInt();
            info.state = pkg.readInt();
            info.result = pkg.readInt();
            info.aroundMineCount = pkg.readInt();
            infoList.push(info);
         }
         this._model.mapInfoList = infoList;
         var awardCount:Array = [];
         var awardGoodsTip:Array = [];
         for(i = 0; i < 3; i++)
         {
            awardCount.push(pkg.readInt());
            count = pkg.readInt();
            tip = "";
            for(j = 0; j < count; j++)
            {
               tip += ItemManager.Instance.getTemplateById(pkg.readInt()).Name + "x";
               tip += pkg.readInt().toString();
               tip += "\n";
            }
            awardGoodsTip.push(tip);
         }
         this._model.awardCount = awardCount;
         this._model.awardGoodsTip = awardGoodsTip;
         if(Boolean(this._bogu))
         {
            dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_MAP));
         }
      }
      
      private function updateCell(pkg:PackageIn) : void
      {
         var type:int = pkg.readInt();
         var index:int = pkg.readInt();
         var result:int = pkg.readInt();
         this._model.findMinePrice = pkg.readInt();
         if(type == 4)
         {
            this.currentIndex = index;
            this.hp = pkg.readInt();
            this._model.openCount = pkg.readInt();
         }
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_CELL,{
            "type":type,
            "result":result,
            "index":index
         }));
      }
      
      private function revive(pkg:PackageIn) : void
      {
         this.hp = pkg.readInt();
      }
      
      private function acquireAward(pkg:PackageIn) : void
      {
         this._model.isAcquireAward1 = Boolean(pkg.readInt() == 1);
         this._model.isAcquireAward2 = Boolean(pkg.readInt() == 1);
         this._model.isAcquireAward3 = Boolean(pkg.readInt() == 1);
      }
      
      public function checkGameOver() : Boolean
      {
         if(this._model.openCount >= this._model.awardCount[2])
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.gameOver"));
            return true;
         }
         if(this._hp <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.hpNotEnough"));
            return true;
         }
         if(!BoguAdventureManager.instance.isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.activityOver"));
            return true;
         }
         return false;
      }
      
      public function walk(path:Array) : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.WALK,path));
      }
      
      public function walkComplete() : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.STOP));
      }
      
      public function playActionComplete(data:Object = null) : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.ACTION_COMPLETE,data));
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(value:int) : void
      {
         if(this._hp == value)
         {
            return;
         }
         this._hp = value;
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.CHANGE_HP));
      }
      
      public function get bogu() : BoguAdventurePlayer
      {
         return this._bogu;
      }
      
      public function set bogu(value:BoguAdventurePlayer) : void
      {
         this._bogu = value;
         if(this._model.mapInfoList != null)
         {
            dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_MAP));
         }
      }
      
      public function get model() : BoguAdventureModel
      {
         return this._model;
      }
      
      public function checkGetAward() : Boolean
      {
         if(this._model.openCount >= this._model.awardCount[0] && !this._model.isAcquireAward1 || this._model.openCount >= this._model.awardCount[1] && !this._model.isAcquireAward2 || this._model.openCount >= this._model.awardCount[2] && !this._model.isAcquireAward3)
         {
            return true;
         }
         return false;
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOGU_ADVENTURE,this.__onAllEvent);
         this._bogu = null;
         this._model.dispose();
         this._model = null;
         this.signFocus = null;
         this.mineFocus = null;
         this.mineNumFocus = null;
      }
   }
}

