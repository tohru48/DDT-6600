package room.transnational
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellContentCreator;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import room.view.RoomPropCell;
   
   public class TransnationalEquitmentCell extends BaseCell
   {
      
      private var popcelllist:Vector.<RoomPropCell>;
      
      protected var _petIcon:BitmapLoaderProxy;
      
      private var _EquitmentCellinfo:Object;
      
      public function TransnationalEquitmentCell(bg:DisplayObject)
      {
         super(bg);
      }
      
      private function initView() : void
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,49,49);
         sp.graphics.endFill();
      }
      
      public function set Cellinfo(value:Object) : void
      {
         if(this._EquitmentCellinfo == value && !this._EquitmentCellinfo)
         {
            return;
         }
         if(Boolean(this._EquitmentCellinfo))
         {
            clearCreatingContent();
            ObjectUtils.disposeObject(_pic);
            _pic = null;
            clearLoading();
            _tipData = null;
            locked = false;
         }
         this._EquitmentCellinfo = value;
         if(this._EquitmentCellinfo is ItemTemplateInfo)
         {
            if(_showLoading)
            {
               createLoading();
            }
            _pic = new CellContentCreator();
            _pic.info = this._EquitmentCellinfo as ItemTemplateInfo;
            _pic.loadSync(createContentComplete);
            addChild(_pic);
            _pic.width = 41;
            _pic.height = 41;
            tipStyle = "core.GoodsTip";
            _tipData = new GoodTipInfo();
            GoodTipInfo(_tipData).itemInfo = this._EquitmentCellinfo as ItemTemplateInfo;
         }
         else if(this._EquitmentCellinfo is PetTemplateInfo)
         {
            this.clearIcon();
            tipStyle = "room.transnational.TransnationalPetCellTips";
            _tipData = new Array();
            _tipData = TransnationalFightManager._petsSkill[this._EquitmentCellinfo.TemplateID];
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPetPic(this._EquitmentCellinfo as PetTemplateInfo,TransnationalFightManager.TRANSNATIONAL_PETLEVEL)),new Rectangle(0,0,41,41),true);
            this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            addChild(this._petIcon);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get Cellinfo() : Object
      {
         return this._EquitmentCellinfo;
      }
      
      private function clearIcon() : void
      {
         if(Boolean(this._petIcon))
         {
            this._petIcon.parent.removeChild(this._petIcon);
            this._petIcon = null;
         }
      }
      
      private function __fixPetIconPostion(e:Event) : void
      {
         if(Boolean(this._petIcon))
         {
            this._petIcon.x = 56 - this._petIcon.width >> 1;
            this._petIcon.y = 51 - this._petIcon.height >> 1;
         }
      }
   }
}

