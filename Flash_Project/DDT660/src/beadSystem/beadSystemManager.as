package beadSystem
{
   import beadSystem.data.BeadEvent;
   import beadSystem.model.BeadModel;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class beadSystemManager extends EventDispatcher
   {
      
      private static var _instance:beadSystemManager;
      
      private var _isFirstLoadPackage:Boolean = true;
      
      public function beadSystemManager()
      {
         super();
      }
      
      public static function get Instance() : beadSystemManager
      {
         if(_instance == null)
         {
            _instance = new beadSystemManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_OPEN_PACKAGE,this.__onOpenPackage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_HOLE_INFO,this.__onOpenHole);
      }
      
      private function __onOpenPackage(pEvent:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = pEvent.pkg as PackageIn;
         var index:int = pkg.readInt();
         dispatchEvent(new BeadEvent(BeadEvent.LIGHTBTN,index));
         BeadModel.beadRequestBtnIndex = index;
      }
      
      private function __onOpenHole(pEvent:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new BeadEvent(BeadEvent.OPENBEADHOLE,0));
      }
      
      public function getEquipPlace(pInfo:InventoryItemInfo) : int
      {
         var all:int = 0;
         var i:int = 0;
         if(pInfo.Property1 == "31" && pInfo.Property2 == "1")
         {
            return 1;
         }
         if(pInfo.Property1 == "31" && pInfo.Property2 == "2")
         {
            if(Boolean(PlayerManager.Instance.Self.BeadBag.getItemAt(2)))
            {
               if(Boolean(PlayerManager.Instance.Self.BeadBag.getItemAt(3)))
               {
                  return 2;
               }
               return 3;
            }
            return 2;
         }
         if(pInfo.Property1 == "31" && pInfo.Property2 == "3")
         {
            all = 5;
            if(PlayerManager.Instance.Self.Grade >= 15)
            {
               all = 6;
            }
            if(PlayerManager.Instance.Self.Grade >= 18)
            {
               all = 7;
            }
            if(PlayerManager.Instance.Self.Grade >= 21)
            {
               all = 8;
            }
            if(PlayerManager.Instance.Self.Grade >= 24)
            {
               all = 9;
            }
            if(PlayerManager.Instance.Self.Grade >= 27)
            {
               all = 10;
            }
            if(PlayerManager.Instance.Self.Grade >= 30)
            {
               all = 11;
            }
            if(PlayerManager.Instance.Self.Grade >= 33)
            {
               all = 12;
            }
            for(i = 4; i <= all; i++)
            {
               if(!PlayerManager.Instance.Self.BeadBag.getItemAt(i))
               {
                  return i;
               }
            }
            return 4;
         }
         return -1;
      }
      
      public function getBeadNameTextFormatStyle(pLv:int) : String
      {
         var vResultStr:String = null;
         switch(pLv)
         {
            case 1:
            case 2:
            case 7:
            case 8:
            case 13:
            case 14:
               vResultStr = "beadSystem.beadCell.name.tf2";
               break;
            case 3:
            case 4:
            case 9:
            case 10:
            case 15:
            case 16:
               vResultStr = "beadSystem.beadCell.name.tf3";
               break;
            case 5:
            case 6:
            case 11:
            case 12:
            case 17:
               vResultStr = "beadSystem.beadCell.name.tf4";
               break;
            case 18:
            case 19:
               vResultStr = "beadSystem.beadCell.name.tf5";
               break;
            default:
               vResultStr = "beadSystem.beadCell.name.tf1";
         }
         return vResultStr;
      }
      
      public function judgeLevel(beadLevel:int, holeLevel:int) : Boolean
      {
         switch(holeLevel)
         {
            case 1:
               if(1 <= beadLevel && beadLevel <= 4)
               {
                  return true;
               }
               break;
            case 2:
               if(1 <= beadLevel && beadLevel <= 8)
               {
                  return true;
               }
               break;
            case 3:
               if(1 <= beadLevel && beadLevel <= 12)
               {
                  return true;
               }
               break;
            case 4:
               if(1 <= beadLevel && beadLevel <= 16)
               {
                  return true;
               }
               break;
            case 5:
               return true;
            default:
               return false;
         }
         return false;
      }
      
      public function getBeadMcIndex(pLv:int) : int
      {
         var vResult:int = 0;
         switch(pLv)
         {
            case 1:
            case 2:
               vResult = 2;
               break;
            case 3:
            case 4:
               vResult = 3;
               break;
            case 5:
            case 6:
               vResult = 4;
               break;
            case 7:
            case 8:
               vResult = 7;
               break;
            case 9:
            case 10:
               vResult = 8;
               break;
            case 11:
            case 12:
               vResult = 9;
               break;
            case 13:
            case 14:
               vResult = 10;
               break;
            case 15:
            case 16:
               vResult = 11;
               break;
            case 17:
               vResult = 12;
         }
         return vResult;
      }
      
      public function getBeadName(item:InventoryItemInfo) : String
      {
         var res:String = "";
         if(!item || !EquipType.isBead(int(item.Property1)))
         {
            return "";
         }
         if(item.Hole2 > 0)
         {
            res = BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).Name + "Lv" + item.Hole1;
         }
         else
         {
            res = BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel;
         }
         return res;
      }
   }
}

