package room.transnational
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import pet.date.PetSkill;
   import pet.date.PetTemplateInfo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   
   public class TransnationalFightManager extends EventDispatcher
   {
      
      private static var Tfight:TransnationalFightManager;
      
      public static var _weaponList:Vector.<ItemTemplateInfo>;
      
      public static var _auxList:Vector.<ItemTemplateInfo>;
      
      public static var _petList:Vector.<PetTemplateInfo>;
      
      public static var _petsSkill:DictionaryData;
      
      public static var TRANSNATIONAL_SECWEAPONLEVEL:int;
      
      public static var TRANSNATIONAL_WEAPON:int = 7;
      
      public static var TRANSNATIONAL_AUX:int = 17;
      
      public static var TRANSNATIONAL_PETLEVEL:int = 30;
      
      public static var LEFTCELL_WEAPON:int = 0;
      
      public static var LEFTCELL_AUX:int = 1;
      
      public static var LEFTCELL_PET:int = 2;
      
      public static var SCORESDAILETOTAL:int = 2000;
      
      private var TransnatinalRoomView:TransnationalFightRoomController;
      
      private var callback:Function;
      
      private var _isfromTransnational:Boolean = false;
      
      private var _actived:Boolean = false;
      
      private var _currentScores:int;
      
      private var _dailyScores:int;
      
      public function TransnationalFightManager()
      {
         super();
      }
      
      public static function get Instance() : TransnationalFightManager
      {
         if(Tfight == null)
         {
            Tfight = new TransnationalFightManager();
         }
         return Tfight;
      }
      
      public function set ShowIcon(value:Function) : void
      {
         this.callback = value;
      }
      
      public function Setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TRANSNATIONALFIGHT_ACTIVED,this.__actived);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TRANSNATIONALSCORE_UPDATA,this.__updataScores);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TRANSNATIONALfIGHT_OVER,this.__overActivity);
      }
      
      private function __overActivity(event:CrazyTankSocketEvent) : void
      {
         this._actived = false;
         this.callback(this._actived);
         this.hideTransnationalRoomView();
      }
      
      public function get isfromTransnational() : Boolean
      {
         return this._isfromTransnational;
      }
      
      public function set isfromTransnational(value:Boolean) : void
      {
         this._isfromTransnational = value;
      }
      
      private function __updataScores(event:CrazyTankSocketEvent) : void
      {
         this.dailyScores = event.pkg.readInt();
         this.currentScores = event.pkg.readInt();
         if(Boolean(this.TransnatinalRoomView))
         {
            this.TransnatinalRoomView.updataScores();
         }
      }
      
      private function __actived(evt:CrazyTankSocketEvent) : void
      {
         var petskills:Array = null;
         var weapId:int = 0;
         var weaitemInfo:InventoryItemInfo = null;
         var secweapId:int = 0;
         var secweapitemInfo:InventoryItemInfo = null;
         var petId:int = 0;
         var petsSkill:int = 0;
         var petInfo:PetTemplateInfo = null;
         var kk:int = 0;
         var petskillId:int = 0;
         var petskill:PetSkill = null;
         _weaponList = new Vector.<ItemTemplateInfo>();
         _auxList = new Vector.<ItemTemplateInfo>();
         _petList = new Vector.<PetTemplateInfo>();
         _petsSkill = new DictionaryData();
         this._actived = true;
         if(this.callback != null)
         {
            this.callback(this._actived);
         }
         TRANSNATIONAL_SECWEAPONLEVEL = evt.pkg.readInt();
         var weapCouns:int = evt.pkg.readInt();
         for(var i:int = 0; i < weapCouns; i++)
         {
            weapId = evt.pkg.readInt();
            weaitemInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(weaitemInfo,ItemManager.Instance.getTemplateById(weapId));
            weaitemInfo.StrengthenLevel = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL;
            weaitemInfo.CanCompose = false;
            weaitemInfo.CanStrengthen = false;
            weaitemInfo.BindType = 4;
            _weaponList.push(weaitemInfo);
         }
         var secweapCouns:int = evt.pkg.readInt();
         for(var j:int = 0; j < secweapCouns; j++)
         {
            secweapId = evt.pkg.readInt();
            secweapitemInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(secweapitemInfo,ItemManager.Instance.getTemplateById(secweapId));
            if(secweapId != EquipType.WishKingBlessing)
            {
               secweapitemInfo.StrengthenLevel = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL;
            }
            secweapitemInfo.CanCompose = false;
            secweapitemInfo.CanStrengthen = false;
            secweapitemInfo.BindType = 4;
            _auxList.push(secweapitemInfo);
         }
         var petCouns:int = evt.pkg.readInt();
         for(var k:int = 0; k < petCouns; k++)
         {
            petId = evt.pkg.readInt();
            petsSkill = evt.pkg.readInt();
            petInfo = PetInfoManager.getPetByTemplateID(petId);
            if(petInfo == null)
            {
               return;
            }
            petskills = new Array();
            _petList.push(petInfo);
            for(kk = 0; kk < petsSkill; kk++)
            {
               petskillId = evt.pkg.readInt();
               petskill = new PetSkill(petskillId);
               petskills.push(petskill);
            }
            _petsSkill.add(petInfo.TemplateID,petskills);
         }
         TRANSNATIONAL_PETLEVEL = evt.pkg.readInt();
         SCORESDAILETOTAL = evt.pkg.readInt();
      }
      
      private function __equipment(evt:CrazyTankSocketEvent) : void
      {
         var info:ItemTemplateInfo = new ItemTemplateInfo();
      }
      
      public function hasActived() : Boolean
      {
         return this._actived;
      }
      
      public function get dailyScores() : int
      {
         return this._dailyScores;
      }
      
      public function set dailyScores(value:int) : void
      {
         this._dailyScores = value;
      }
      
      public function get currentScores() : int
      {
         return this._currentScores;
      }
      
      public function set currentScores(value:int) : void
      {
         this._currentScores = value;
      }
      
      public function enterTransnationalFight() : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendTransnationalBegin(RoomManager.TRANSNATIONAL_ROOM);
      }
      
      public function show(player:String, mainWeaID:int, secWeaID:int, petID:int, lever:int) : void
      {
         if(this.TransnatinalRoomView == null || this.TransnatinalRoomView.isdispose)
         {
            if(Boolean(this.TransnatinalRoomView))
            {
               this.TransnatinalRoomView.dispose();
               this.TransnatinalRoomView = null;
            }
            this.TransnatinalRoomView = ComponentFactory.Instance.creat("room.transnational.TransnationalRoomView");
         }
         this.TransnatinalRoomView.playerStyle(player,mainWeaID,secWeaID,petID,lever);
         this.TransnatinalRoomView.updataScores();
         this.TransnatinalRoomView.show();
         this.TransnatinalRoomView.addEventListener(FrameEvent.RESPONSE,this.___onTransnationalRoomEvent);
      }
      
      public function hide() : void
      {
         if(Boolean(this.TransnatinalRoomView.parent))
         {
            this.TransnatinalRoomView.cancel();
            this.TransnatinalRoomView.parent.removeChild(this.TransnatinalRoomView);
         }
      }
      
      private function ___onTransnationalRoomEvent(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.playButtonSound();
            GameInSocketOut.revertPlayerInfo(TransnationalPackageType.UPDATE_PLAYER_DATA);
            this.hide();
         }
      }
      
      private function hideTransnationalRoomView() : void
      {
         if(Boolean(this.TransnatinalRoomView))
         {
            this.TransnatinalRoomView.removeEventListener(FrameEvent.RESPONSE,this.___onTransnationalRoomEvent);
            this.TransnatinalRoomView.dispose();
            ObjectUtils.disposeObject(this.TransnatinalRoomView);
            this.TransnatinalRoomView = null;
         }
      }
   }
}

