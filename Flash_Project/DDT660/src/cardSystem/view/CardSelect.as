package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.view.cardCollect.CardSelectItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class CardSelect extends ChatBasePanel implements Disposeable
   {
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<CardSelectItem>;
      
      private var _cardinfo:Vector.<CardInfo>;
      
      private var _cardIdVec:Vector.<int>;
      
      private var _bagCard:Vector.<CardInfo>;
      
      private var _equipArr:Array;
      
      public function CardSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<CardSelectItem>();
         this._cardinfo = new Vector.<CardInfo>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.CardListBg");
         this._list = new VBox();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("CardBagView.cardselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var item:CardSelectItem = null;
         var infoList:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for(var i:int = 0; i < infoList.length; i++)
         {
            item = new CardSelectItem();
            item.info = infoList[i];
            item.addEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            this._itemList.push(item);
            this._list.addChild(item);
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(e:CardEvent) : void
      {
         var info:SetsInfo = null;
         SoundManager.instance.play("008");
         var id:int = int(e.data.id);
         var infoList:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for each(info in infoList)
         {
            if(int(info.ID) == id)
            {
               this._cardIdVec = info.cardIdVec;
               break;
            }
         }
         if(this._cardIdVec != null)
         {
            this.moveAllCard();
         }
      }
      
      private function getbagCard() : Vector.<CardInfo>
      {
         var bagCardDic:DictionaryData = null;
         var cInfo:CardInfo = null;
         var cardInfo:CardInfo = null;
         var temp:Vector.<CardInfo> = new Vector.<CardInfo>();
         for(var i:int = 0; i < this._cardIdVec.length; i++)
         {
            bagCardDic = PlayerManager.Instance.Self.cardBagDic;
            cInfo = null;
            for each(cardInfo in bagCardDic)
            {
               if(cardInfo.TemplateID == this._cardIdVec[i])
               {
                  temp.push(cardInfo);
                  break;
               }
            }
         }
         return temp;
      }
      
      private function dealNeedEquip() : void
      {
         var place:String = null;
         var i:int = 0;
         var index:int = 0;
         for(place in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(PlayerManager.Instance.Self.cardEquipDic == null)
            {
               break;
            }
            for(i = 0; i < this._bagCard.length; i++)
            {
               if(PlayerManager.Instance.Self.cardEquipDic[place].TemplateID == this._bagCard[i].TemplateID)
               {
                  this._bagCard.splice(i,1);
                  index = int(this._equipArr.indexOf(int(place)));
                  if(index > -1)
                  {
                     this._equipArr.splice(index,1);
                  }
                  break;
               }
            }
         }
      }
      
      private function moveAllCard() : void
      {
         var place:String = null;
         var j:int = 0;
         var n:int = 0;
         var mplace:int = 0;
         var sendCardObj:DictionaryData = new DictionaryData();
         this._bagCard = this.getbagCard();
         if(this._bagCard.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noHaveCard"));
            return;
         }
         this._equipArr = [1,2,3,4];
         this.dealNeedEquip();
         for(var i:int = 0; i < this._bagCard.length; i++)
         {
            if(this._bagCard[i].templateInfo.Property8 == "1")
            {
               sendCardObj.add(0,this._bagCard[i].Place);
            }
            else
            {
               for(j = 1; j < 5; j++)
               {
                  if(PlayerManager.Instance.Self.cardEquipDic[j] == null)
                  {
                     if(sendCardObj[j] == null)
                     {
                        sendCardObj.add(j,this._bagCard[i].Place);
                        break;
                     }
                  }
                  if(j == 4)
                  {
                     for(n = 0; n < this._equipArr.length; n++)
                     {
                        mplace = int(this._equipArr[n]);
                        if(sendCardObj[mplace] == null)
                        {
                           this._equipArr.splice(n,1);
                           sendCardObj.add(mplace,this._bagCard[i].Place);
                           break;
                        }
                     }
                  }
               }
            }
         }
         for(place in sendCardObj)
         {
            SocketManager.Instance.out.sendMoveCards(sendCardObj[place],int(place));
         }
         if(sendCardObj.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.text"));
         }
         if(sendCardObj.length > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
         }
      }
      
      override protected function __hideThis(event:MouseEvent) : void
      {
         var target:DisplayObject = event.target as DisplayObject;
         if(DisplayUtils.isTargetOrContain(target,this._panel.vScrollbar))
         {
            return;
         }
         SoundManager.instance.play("008");
         setVisible = false;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         while(i < this._itemList.length)
         {
            this._itemList[i].removeEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[i]);
            this._itemList[i] = null;
            i++;
         }
         this._itemList = null;
      }
   }
}

