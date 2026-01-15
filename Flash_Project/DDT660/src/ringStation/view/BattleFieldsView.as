package ringStation.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.geom.Point;
   import ringStation.event.RingStationEvent;
   import ringStation.model.BattleFieldListItemInfo;
   import road7th.comm.PackageIn;
   
   public class BattleFieldsView extends Frame
   {
      
      private static const BATTLEFILEDSNUM:int = 11;
      
      private var _bg:MutipleImage;
      
      private var _itemVec:Vector.<BattleFieldsItem>;
      
      public function BattleFieldsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ringStation.view.battleFieldsView.titleInfo");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.battleField.bg");
         addToContent(this._bg);
         this.initItemData();
         this.sendPkg();
      }
      
      private function initItemData() : void
      {
         var i:int = 0;
         var infoItem:BattleFieldsItem = null;
         this._itemVec = new Vector.<BattleFieldsItem>();
         var pos:Point = PositionUtils.creatPoint("ringStation.view.battleField.itemPos");
         for(i = 0; i < BATTLEFILEDSNUM; i++)
         {
            infoItem = new BattleFieldsItem(i);
            infoItem.x = pos.x;
            infoItem.y = pos.y + i * 33.7;
            addToContent(infoItem);
            this._itemVec.push(infoItem);
         }
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendRingStationBattleField();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.addEventListener(RingStationEvent.RINGSTATION_NEWBATTLEFIELD,this.__onUpdateNewBattleField);
      }
      
      protected function __onUpdateNewBattleField(event:RingStationEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var info:BattleFieldListItemInfo = new BattleFieldListItemInfo();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            info.DareFlag = pkg.readBoolean();
            info.UserName = pkg.readUTF();
            info.SuccessFlag = pkg.readBoolean();
            info.Level = pkg.readInt();
            this._itemVec[i].update(info);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.removeEventListener(RingStationEvent.RINGSTATION_NEWBATTLEFIELD,this.__onUpdateNewBattleField);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         for(var i:int = 0; i < this._itemVec.length; i++)
         {
            if(Boolean(this._itemVec[i]))
            {
               ObjectUtils.disposeObject(this._itemVec[i]);
               this._itemVec[i] = null;
            }
         }
         this._itemVec.length = 0;
         this._itemVec = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

