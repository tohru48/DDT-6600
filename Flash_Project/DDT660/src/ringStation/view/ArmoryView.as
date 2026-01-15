package ringStation.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import labyrinth.data.RankingInfo;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   
   public class ArmoryView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _closeBg:ScaleBitmapImage;
      
      private var _closeBtn:BaseButton;
      
      private var _list:ListPanel;
      
      public function ArmoryView()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ringStation.view.armoryView.titleInfo");
         this._bg = ComponentFactory.Instance.creat("ringStation.view.armory.bg");
         addToContent(this._bg);
         this._closeBg = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.closeBg");
         addToContent(this._closeBg);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.closeBtn");
         addToContent(this._closeBtn);
         this._list = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.armory.List");
         addToContent(this._list);
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendRingStationArmory();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._closeBtn.addEventListener(MouseEvent.CLICK,__onCloseClick);
         SocketManager.Instance.addEventListener(RingStationEvent.RINGSTATION_ARMORY,this.__getArmoryInfo);
      }
      
      protected function __getArmoryInfo(event:RingStationEvent) : void
      {
         var info:RankingInfo = null;
         var pkg:PackageIn = event.pkg;
         var list:Array = new Array();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            info = new RankingInfo();
            info.PlayerRank = pkg.readInt();
            info.FamLevel = pkg.readInt();
            info.PlayerName = pkg.readUTF();
            info.Fighting = pkg.readInt();
            pkg.readInt();
            list.push(info);
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(list);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,__onCloseClick);
         SocketManager.Instance.removeEventListener(RingStationEvent.RINGSTATION_ARMORY,this.__getArmoryInfo);
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
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._closeBg))
         {
            this._closeBg.dispose();
            this._closeBg = null;
         }
         if(Boolean(this._closeBtn))
         {
            this._closeBtn.dispose();
            this._closeBtn = null;
         }
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
      }
   }
}

