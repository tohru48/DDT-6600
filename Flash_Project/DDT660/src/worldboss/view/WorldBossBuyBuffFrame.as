package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossBuffInfo;
   
   public class WorldBossBuyBuffFrame extends Sprite implements Disposeable
   {
      
      public static var IsAutoShow:Boolean = true;
      
      private static var _autoBuyBuffItem:DictionaryData = new DictionaryData();
      
      private var _notAgainBtn:SelectedCheckButton;
      
      private var _selectedArr:Array = new Array();
      
      private var _cartList:VBox;
      
      private var _cartScroll:ScrollPanel;
      
      private var _frame:Frame;
      
      private var _innerBg:Image;
      
      private var _moneyTip:FilterFrameText;
      
      private var _moneyBg:Image;
      
      private var _money:FilterFrameText;
      
      private var _bottomBg:Image;
      
      public function WorldBossBuyBuffFrame()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function drawFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("worldboss.buyBuff.FrameTitle");
         addChild(this._frame);
      }
      
      private function drawItemCountField() : void
      {
         this._notAgainBtn = ComponentFactory.Instance.creatComponentByStylename("worldbossnotAgainBtn");
         this._notAgainBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.NotAgain");
         this._notAgainBtn.selected = !IsAutoShow;
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrame.bottomBg");
         this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TicketTextBg");
         PositionUtils.setPos(this._moneyBg,"worldboss.buyBuffFrame.moneyBg");
         this._money = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerMoney");
         PositionUtils.setPos(this._money,"worldboss.buyBuffFrame.money");
         this._money.text = PlayerManager.Instance.Self.Money.toString();
         this._moneyTip = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBUffFrame.moneyTip");
         this._moneyTip.text = LanguageMgr.GetTranslation("worldboss.buyBuff.moneyTip");
         this._frame.addToContent(this._notAgainBtn);
         this._frame.addToContent(this._bottomBg);
         this._frame.addToContent(this._moneyBg);
         this._frame.addToContent(this._money);
         this._frame.addToContent(this._moneyTip);
      }
      
      protected function drawPayListField() : void
      {
         this._innerBg = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuyBuffFrameBg");
         this._frame.addToContent(this._innerBg);
      }
      
      protected function init() : void
      {
         this._cartList = new VBox();
         this.drawFrame();
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("worldBoss.BuffItemList");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this.drawPayListField();
         this._frame.addToContent(this._cartScroll);
         this.drawItemCountField();
         this.setList();
      }
      
      private function setList() : void
      {
         var cItem:BuffCartItem = null;
         var arr:Array = WorldBossManager.Instance.bossInfo.buffArray;
         for(var i:int = 0; i < arr.length; i++)
         {
            cItem = new BuffCartItem();
            cItem.buffItemInfo = arr[i] as WorldBossBuffInfo;
            this._cartList.addChild(cItem);
            this._selectedArr.push(cItem);
            cItem.selected(_autoBuyBuffItem.hasKey(cItem.buffID));
            cItem.addEventListener(Event.SELECT,this.__itemSelected);
         }
         this._cartScroll.invalidateViewport();
         this.updatePrice();
      }
      
      private function addEvent() : void
      {
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._notAgainBtn.addEventListener(Event.SELECT,this.__againChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF,this.__getBuff);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropertyChanged);
      }
      
      protected function __onPropertyChanged(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties[PlayerInfo.MONEY]))
         {
            this._money.text = PlayerManager.Instance.Self.Money.toString();
         }
      }
      
      private function removeEvent() : void
      {
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._notAgainBtn.removeEventListener(Event.SELECT,this.__againChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BUYBUFF,this.__getBuff);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropertyChanged);
      }
      
      private function __itemSelected(e:Event = null) : void
      {
         this.updatePrice();
         var cartItem:BuffCartItem = e.currentTarget as BuffCartItem;
         if(cartItem.IsSelected)
         {
            _autoBuyBuffItem.add(cartItem.buffID,cartItem.buffID);
         }
         else
         {
            _autoBuyBuffItem.remove(cartItem.buffID);
         }
      }
      
      private function updatePrice() : void
      {
         var item:BuffCartItem = null;
         var num:int = 0;
         for each(item in this._selectedArr)
         {
            if(item.IsSelected)
            {
               num += item.price;
            }
         }
      }
      
      private function __againChange(e:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._notAgainBtn.selected)
         {
            IsAutoShow = false;
         }
         else
         {
            IsAutoShow = true;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.buyBuff.setShowSucess"));
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function __frameEventHandler(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __getBuff(evt:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var buffID:int = 0;
         var item:BuffCartItem = null;
         var pkg:PackageIn = evt.pkg;
         if(pkg.readBoolean())
         {
            count = pkg.readInt();
            if(count > 1)
            {
               this.dispose();
            }
            for(i = 0; i < count; i++)
            {
               buffID = pkg.readInt();
               for each(item in this._selectedArr)
               {
                  if(buffID == item.buffID)
                  {
                     WorldBossManager.Instance.bossInfo.myPlayerVO.buffID = buffID;
                     item.changeStatusBuy();
                  }
               }
            }
            this.updatePrice();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._frame);
         ObjectUtils.disposeAllChildren(this);
         this._bottomBg = null;
         this._moneyTip = null;
         this._moneyBg = null;
         this._money = null;
         this._selectedArr = null;
         this._cartList = null;
         this._cartScroll = null;
         this._innerBg = null;
         this._frame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

