package ddtBuried.items
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuriedCardItem extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      public var id:int;
      
      private var _tempID:int;
      
      private var _count:int;
      
      private var _isPress:Boolean;
      
      public function BuriedCardItem()
      {
         super();
         this.initView();
         useHandCursor = true;
         buttonMode = true;
         this.iniEvents();
      }
      
      private function iniEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      public function setGoodsInfo(id:int, count:int) : void
      {
         this._tempID = id;
         this._count = count;
      }
      
      public function set isPress(bool:Boolean) : void
      {
         this._isPress = bool;
      }
      
      private function mouseClickHander(event:MouseEvent) : void
      {
         var money:int = 0;
         money = int(BuriedManager.Instance.getTakeCardPay());
         SoundManager.instance.playButtonSound();
         BuriedManager.Instance.currCardIndex = this.id;
         if(this._isPress)
         {
            return;
         }
         this._isPress = true;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         if(money == 0)
         {
            SocketManager.Instance.out.takeCard();
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(BuriedManager.Instance.getRemindOverCard())
            {
               if(BuriedManager.Instance.checkMoney(BuriedManager.Instance.getRemindOverBind(),int(BuriedManager.Instance.getTakeCardPay()),SocketManager.Instance.out.takeCard))
               {
                  this._isPress = false;
                  BuriedManager.Instance.setRemindOverCard(false);
                  BuriedManager.Instance.setRemindOverBind(false);
                  BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDice",money),this.payForCardHander,this.clickCallBack);
                  return;
               }
               SocketManager.Instance.out.takeCard(BuriedManager.Instance.getRemindOverBind());
               return;
            }
            BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDice",money),this.payForCardHander,this.clickCallBack,this);
            this.mouseChildren = true;
            this.mouseEnabled = true;
         }
      }
      
      private function clickCallBack(bool:Boolean) : void
      {
         BuriedManager.Instance.setRemindOverCard(bool);
      }
      
      public function play() : void
      {
         this._mc.play();
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      private function payForCardHander(bool:Boolean) : void
      {
         var money:int = int(BuriedManager.Instance.getTakeCardPay());
         if(BuriedManager.Instance.checkMoney(bool,money,SocketManager.Instance.out.takeCard))
         {
            this._isPress = false;
            BuriedManager.Instance.setRemindOverCard(false);
            BuriedManager.Instance.showTransactionFrame(LanguageMgr.GetTranslation("buried.alertInfo.rollDice",money),this.payForCardHander,this.clickCallBack,this);
            return;
         }
         if(BuriedManager.Instance.getRemindOverCard())
         {
            BuriedManager.Instance.setRemindOverBind(bool);
         }
         SocketManager.Instance.out.takeCard(bool);
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("buried.card.fanpai");
         this._mc.x = 1;
         this._mc.y = -11;
         this._mc.stop();
         addChild(this._mc);
         this._mc.addFrameScript(80,this.takeOver);
         this._mc.addFrameScript(9,this.initCard);
      }
      
      private function initCard() : void
      {
         var info:ItemTemplateInfo = null;
         var cell:BagCell = null;
         info = ItemManager.Instance.getTemplateById(this._tempID);
         cell = new BagCell(0,info);
         cell.x = 39;
         cell.y = 107;
         cell.setBgVisible(false);
         cell.setCount(this._count);
         this._mc["mc"].addChild(cell);
         this._mc["mc"].goodsName.text = info.Name;
      }
      
      private function takeOver() : void
      {
         if(Boolean(this._mc))
         {
            this._mc.stop();
         }
         this.mouseEnabled = false;
         this.mouseChildren = false;
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.CARD_TAKE_OVER));
      }
      
      public function dispose() : void
      {
         this._isPress = false;
         this.removeEvents();
         if(Boolean(this._mc))
         {
            this._mc.stop();
            if(Boolean(this._mc["mc"]))
            {
               while(Boolean(this._mc["mc"].numChildren))
               {
                  ObjectUtils.disposeObject(this._mc["mc"].getChildAt(0));
               }
            }
            while(Boolean(this._mc.numChildren))
            {
               ObjectUtils.disposeObject(this._mc.getChildAt(0));
            }
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._mc = null;
      }
   }
}

