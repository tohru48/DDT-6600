package treasureHunting.views
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.reader.AwardsInfo;
   import ddt.view.caddyII.reader.AwardsItem;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.GoodTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class TreasureRecordView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardTip:CardBoxTipPanel;
      
      private var _itemArr:Array;
      
      private var _isMySelf:Boolean;
      
      private var tempArr:Vector.<AwardsInfo>;
      
      protected var _goodTipPos:Point;
      
      private var _tipStageClickCount:int;
      
      public function TreasureRecordView()
      {
         super();
         this.initView();
         this.initEvents();
         CaddyModel.instance.setup(CaddyModel.TREASURE_HUNTING);
         SocketManager.Instance.out.sendRequestAwards(CaddyModel.TREASURE_HUNTING);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("treasureHunting.recordBG");
         addChild(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.recordVBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.recordScrollpanel");
         this._panel.setView(this._list);
         addChild(this._panel);
         this._panel.invalidateViewport(true);
         this._goodTipPos = new Point();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.addEventListener(CaddyModel.TREASURE_CHANGE,this._awardsChange);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.removeEventListener(CaddyModel.TREASURE_CHANGE,this._awardsChange);
      }
      
      protected function _getAwards(event:CrazyTankSocketEvent) : void
      {
         var info:AwardsInfo = null;
         var pkg:PackageIn = event.pkg;
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
         if(CaddyModel.instance.type == CaddyModel.TREASURE_HUNTING)
         {
            CaddyModel.instance.addTreasureInfoByArr(this.tempArr);
         }
      }
      
      private function _awardsChange(e:Event) : void
      {
         this._list.disposeAllChildren();
         this._itemArr = [];
         for(var i:int = 0; i < CaddyModel.instance.awardsList.length; i++)
         {
            this.addItem(CaddyModel.instance.awardsList[i]);
         }
         this._panel.invalidateViewport(true);
         this._panel.vScrollbar.scrollValue = 0;
      }
      
      public function addItem(info:AwardsInfo) : void
      {
         var item:AwardsItem = new AwardsItem();
         item.setTextFieldWidth(180);
         item.info = info;
         item.addEventListener(AwardsItem.GOODSCLICK,this._showLinkGoodsInfo);
         this._list.addChild(item);
         this._itemArr.push(item);
      }
      
      private function _showLinkGoodsInfo(e:CaddyEvent) : void
      {
         this._goodTipPos.x = e.point.x;
         this._goodTipPos.y = e.point.y;
         this.showLinkGoodsInfo(e.itemTemplateInfo);
      }
      
      private function showLinkGoodsInfo(item:ItemTemplateInfo, tipStageClickCount:uint = 0) : void
      {
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
      
      public function dispose() : void
      {
         var item:AwardsItem = null;
         this.removeEvents();
         for each(item in this._itemArr)
         {
            item.removeEventListener(AwardsItem.GOODSCLICK,this._showLinkGoodsInfo);
            ObjectUtils.disposeObject(item);
            item = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeObject(this._goodTip);
         this._goodTip = null;
         ObjectUtils.disposeObject(this._cardTip);
         this._cardTip = null;
      }
   }
}

