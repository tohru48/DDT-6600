package ddt.view.caddyII.reader
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class ReadAwardsView extends Sprite implements Disposeable, CaddyUpdate
   {
      
      private var _bg1:ScaleBitmapImage;
      
      protected var _bg2:MovieImage;
      
      private var _node:Bitmap;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardTip:CardBoxTipPanel;
      
      protected var _goodTipPos:Point;
      
      private var _tipStageClickCount:int;
      
      private var _isMySelf:Boolean;
      
      private var tempArr:Vector.<AwardsInfo>;
      
      public function ReadAwardsView()
      {
         super();
         this.initView();
         this.initEvents();
         this.requestAwards();
      }
      
      protected function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("caddy.readAwardsBGI");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.readAwardsBGII");
         this._node = ComponentFactory.Instance.creatBitmap("asset.caddy.AwardsNode");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.readVBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.ReaderScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._bg1);
         addChild(this._bg2);
         addChild(this._panel);
         addChild(this._node);
         this._goodTipPos = new Point();
         this._panel.invalidateViewport(true);
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.addEventListener(CaddyModel.AWARDS_CHANGE,this._awardsChange);
         CaddyModel.instance.addEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadAwardsChange);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.removeEventListener(CaddyModel.AWARDS_CHANGE,this._awardsChange);
         CaddyModel.instance.removeEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadAwardsChange);
      }
      
      private function requestAwards() : void
      {
         if(CaddyModel.instance.type == CaddyModel.CARD_TYPE || CaddyModel.instance.type == CaddyModel.MY_CARDBOX || CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX || CaddyModel.instance.type == CaddyModel.BEAD_TYPE)
         {
            SocketManager.Instance.out.sendRequestAwards(CaddyModel.instance.type);
         }
         else if(CaddyModel.instance.type == CaddyModel.BOMB_KING_BLESS)
         {
            SocketManager.Instance.out.sendRequestAwards(CaddyModel.instance.type + 1);
         }
         else if(CaddyModel.instance.type == CaddyModel.BEAD_TYPE)
         {
            SocketManager.Instance.out.sendRequestAwards(4);
         }
         else if(CaddyModel.instance.type == CaddyModel.CELEBRATION_BOX)
         {
            SocketManager.Instance.out.sendRequestAwards(14);
         }
         else
         {
            SocketManager.Instance.out.sendRequestAwards(3);
         }
      }
      
      private function _getAwards(evt:CrazyTankSocketEvent) : void
      {
         var info:AwardsInfo = null;
         var pkg:PackageIn = evt.pkg;
         if(pkg.bytesAvailable == 0)
         {
            return;
         }
         this._isMySelf = pkg.readBoolean();
         var count:int = pkg.readInt();
         this.tempArr = new Vector.<AwardsInfo>();
         for(var i:int = 0; i < count; i++)
         {
            info = new AwardsInfo();
            info.name = pkg.readUTF();
            info.TemplateId = pkg.readInt();
            info.count = pkg.readInt();
            info.zoneID = pkg.readInt();
            info.isLong = pkg.readBoolean();
            if(info.isLong)
            {
               info.zone = pkg.readUTF();
            }
            this.tempArr.push(info);
         }
         if(this._isMySelf)
         {
            CaddyModel.instance.clearAwardsList();
         }
         if(CaddyModel.instance.type == CaddyModel.CADDY_TYPE || CaddyModel.instance.type == CaddyModel.CELEBRATION_BOX)
         {
            CaddyModel.instance.addAwardsInfoByArr(this.tempArr);
         }
      }
      
      private function removeListChildEvent() : void
      {
         for(var i:int = 0; i < this._list.numChildren; i++)
         {
         }
      }
      
      private function _awardsChange(e:Event) : void
      {
         this.removeListChildEvent();
         this._list.disposeAllChildren();
         for(var i:int = 0; i < CaddyModel.instance.awardsList.length; i++)
         {
            this.addItem(CaddyModel.instance.awardsList[i]);
         }
         this._panel.invalidateViewport(true);
         this._panel.vScrollbar.scrollValue = 0;
      }
      
      private function _beadAwardsChange(e:Event) : void
      {
         this.removeListChildEvent();
         this._list.disposeAllChildren();
         for(var i:int = 0; i < CaddyModel.instance.beadAwardsList.length; i++)
         {
            this.addItem(CaddyModel.instance.beadAwardsList[i]);
         }
         this._panel.invalidateViewport(true);
         this._panel.vScrollbar.scrollValue = 0;
      }
      
      private function _showLinkGoodsInfo(e:CaddyEvent) : void
      {
         this._goodTipPos.x = e.point.x;
         this._goodTipPos.y = e.point.y;
         this.showLinkGoodsInfo(e.itemTemplateInfo);
      }
      
      private function showLinkGoodsInfo(item:ItemTemplateInfo, tipStageClickCount:uint = 0) : void
      {
         var tipData:GoodTipInfo = null;
         if(item.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardTip == null)
            {
               this._cardTip = new CardBoxTipPanel();
            }
            this._cardTip.tipData = item;
            this.setTipPos(this._cardTip);
         }
         else
         {
            if(!this._goodTip)
            {
               this._goodTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip");
            }
            tipData = new GoodTipInfo();
            if(item.Property1 == "31")
            {
               tipData.beadName = item.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel;
               tipData.exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel];
               tipData.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(item.TemplateID).BaseLevel + 1];
            }
            tipData.itemInfo = item;
            this._goodTip.tipData = tipData;
            this._goodTip.showTip(item);
            this.setTipPos(this._goodTip);
         }
         this._tipStageClickCount = tipStageClickCount;
      }
      
      private function setTipPos(tip:BaseTip) : void
      {
         tip.x = this._goodTipPos.x - tip.width;
         tip.y = this._goodTipPos.y - tip.height - 10;
         if(tip.y < 0)
         {
            tip.y = 10;
         }
         StageReferance.stage.addChild(tip);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
      }
      
      private function __stageClickHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         event.stopPropagation();
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(Boolean(this._cardTip))
            {
               this._cardTip.parent.removeChild(this._cardTip);
            }
            if(Boolean(StageReferance.stage))
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      public function addItem(info:AwardsInfo) : void
      {
         var item:AwardsItem = new AwardsItem();
         item.info = info;
         item.addEventListener(AwardsItem.GOODSCLICK,this._showLinkGoodsInfo);
         this._list.addChild(item);
      }
      
      public function update() : void
      {
         if(!this._isMySelf)
         {
            CaddyModel.instance.addAwardsInfoByArr(this.tempArr);
            this._isMySelf = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeListChildEvent();
         this.removeEvents();
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._node))
         {
            ObjectUtils.disposeObject(this._node);
         }
         this._node = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         this._goodTipPos = null;
         this.tempArr = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

