package ddtBuried.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import ddtBuried.items.BuriedCardItem;
   import ddtBuried.items.BuriedItem;
   import ddtBuried.items.BuriedReturnBtn;
   import ddtBuried.items.ShowCard;
   import ddtBuried.items.WashCard;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuriedView extends Sprite implements Disposeable
   {
      
      private static const GOODSID:int = 11680;
      
      private var _btnList:Vector.<BuriedItem>;
      
      private var _cardList:Vector.<BuriedCardItem>;
      
      private var _iconList:Array = ["buried.stone","buried.bindMoney","buried.money"];
      
      private var _moneyList:Array = [BuriedManager.Instance.getBuriedStoneNum(),PlayerManager.Instance.Self.Money.toString(),PlayerManager.Instance.Self.BandMoney.toString()];
      
      private var _back:Bitmap;
      
      private var _shopBtn:SimpleBitmapButton;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _showCard:ShowCard;
      
      private var _washCard:WashCard;
      
      private var _cardContent:Sprite;
      
      private var _returnBtn:BuriedReturnBtn;
      
      private var _fileTxt:FilterFrameText;
      
      private var _wordBack:Bitmap;
      
      public function BuriedView()
      {
         super();
         this._btnList = new Vector.<BuriedItem>();
         this._cardList = new Vector.<BuriedCardItem>();
         this.initView();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.startHandler);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this.openShopHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.CARD_SHOW_OVER,this.cardShowOverHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.CARD_WASH_START,this.cardWashStartHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.CARD_WASH_OVER,this.cardWashHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.TAKE_CARD,this.cardTakeHander);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.UpDate_Stone_Count,this.upDateStoneHander);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onUpdate);
      }
      
      private function removeEvents() : void
      {
         this._shopBtn.removeEventListener(MouseEvent.CLICK,this.openShopHander);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.startHandler);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.UpDate_Stone_Count,this.upDateStoneHander);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onUpdate);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.CARD_SHOW_OVER,this.cardShowOverHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.CARD_WASH_START,this.cardWashStartHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.CARD_WASH_OVER,this.cardWashHander);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.TAKE_CARD,this.cardTakeHander);
      }
      
      private function upDateStoneHander(e:BuriedEvent) : void
      {
         this._btnList[0].upDateTxt(BuriedManager.Instance.getBuriedStoneNum());
      }
      
      private function openShopHander(e:MouseEvent) : void
      {
         BuriedManager.Instance.openshopHander();
         SoundManager.instance.playButtonSound();
      }
      
      private function onUpdate(e:PlayerPropertyEvent) : void
      {
         this._btnList[1].upDateTxt(PlayerManager.Instance.Self.Money.toString());
         this._btnList[2].upDateTxt(PlayerManager.Instance.Self.BandMoney.toString());
      }
      
      private function returnToDice(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      private function cardTakeHander(e:BuriedEvent) : void
      {
         var obj:Object = e.data;
         this._cardList[BuriedManager.Instance.currCardIndex].play();
         this._cardList[BuriedManager.Instance.currCardIndex].setGoodsInfo(e.data.tempID,e.data.count);
      }
      
      private function cardWashStartHander(e:BuriedEvent) : void
      {
         if(!this._washCard)
         {
            this._washCard = new WashCard();
            addChild(this._washCard);
         }
         this._washCard.visible = true;
         this._washCard.play();
      }
      
      private function cardWashHander(e:BuriedEvent) : void
      {
         this._cardContent.visible = true;
         this._washCard.visible = false;
         this._washCard.resetFrame();
      }
      
      private function cardShowOverHander(e:BuriedEvent) : void
      {
         this._startBtn.mouseEnabled = true;
      }
      
      private function startHandler(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._startBtn.mouseEnabled = false;
         this._startBtn.visible = false;
         this._showCard.visible = false;
         if(!this._washCard)
         {
            this._washCard = new WashCard();
            this._washCard.x = 492;
            this._washCard.y = 242;
            addChild(this._washCard);
         }
         this._washCard.visible = true;
         this._washCard.play();
      }
      
      private function initView() : void
      {
         var item:BuriedItem = null;
         var cardItem:BuriedCardItem = null;
         this._back = ComponentFactory.Instance.creat("buried.open.back");
         addChild(this._back);
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("buried.shopBtn");
         addChild(this._shopBtn);
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("buried.findBtn");
         addChild(this._startBtn);
         this._startBtn.mouseEnabled = false;
         this._wordBack = ComponentFactory.Instance.creat("buried.word.back");
         this._wordBack.x = 150;
         this._wordBack.y = 360;
         addChild(this._wordBack);
         for(var i:int = 0; i < 3; i++)
         {
            item = new BuriedItem(this._moneyList[i],this._iconList[i]);
            item.x = (item.width + 4) * i + 139;
            item.y = 554;
            addChild(item);
            this._btnList.push(item);
         }
         this._cardContent = new Sprite();
         this._cardContent.x = 101;
         this._cardContent.y = 118;
         this._cardContent.visible = false;
         addChild(this._cardContent);
         for(var j:int = 0; j < 5; j++)
         {
            cardItem = new BuriedCardItem();
            cardItem.id = j;
            cardItem.x = (cardItem.width + 19) * j;
            this._cardContent.addChild(cardItem);
            this._cardList.push(cardItem);
         }
         this._showCard = new ShowCard();
         this._showCard.x = 493;
         this._showCard.y = 306;
         addChild(this._showCard);
         this._returnBtn = new BuriedReturnBtn();
         addChild(this._returnBtn);
         this._fileTxt = ComponentFactory.Instance.creatComponentByStylename("ddtburied.view.descriptTxt");
         this._fileTxt.text = LanguageMgr.GetTranslation("buried.alertInfo.buriedAtion");
         addChild(this._fileTxt);
      }
      
      private function clearCardItem() : void
      {
         for(var i:int = 0; i < this._cardList.length; i++)
         {
            this._cardList[i].dispose();
            ObjectUtils.disposeObject(this._cardList[i]);
            this._cardList[i] = null;
         }
      }
      
      private function clearBtnList() : void
      {
         for(var i:int = 0; i < this._btnList.length; i++)
         {
            this._btnList[i].dispose();
            ObjectUtils.disposeObject(this._btnList[i]);
            this._btnList[i] = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         BuriedManager.Instance.currCardIndex = 0;
         if(Boolean(this._cardList))
         {
            this.clearCardItem();
         }
         if(Boolean(this._btnList))
         {
            this.clearBtnList();
         }
         this._showCard.dispose();
         if(Boolean(this._washCard))
         {
            this._washCard.dispose();
         }
         this._returnBtn.dispose();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._cardList = null;
         this._btnList = null;
      }
   }
}

