package cardSystem.view.cardCollect
{
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.elements.CardBagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class CollectBagItem extends Sprite implements Disposeable
   {
      
      public static const itemCellWidth:int = 78;
      
      private var _container:HBox;
      
      private var _setsInfo:SetsInfo;
      
      private var _setsName:GradientText;
      
      private var _cardsVector:Vector.<CardBagCell>;
      
      private var _seleted:Boolean;
      
      private var _itemBG:MovieImage;
      
      private var _light:Scale9CornerImage;
      
      private var _itemInfo:DictionaryData;
      
      public function CollectBagItem()
      {
         super();
         this.initView();
      }
      
      public function set seleted(value:Boolean) : void
      {
         this._seleted = value;
         if(this._seleted)
         {
            this._light.visible = true;
         }
         else
         {
            this._light.visible = false;
         }
      }
      
      public function get seleted() : Boolean
      {
         return this._seleted;
      }
      
      private function initView() : void
      {
         var i:int = 0;
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.BG");
         this._light = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.light");
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.setsName");
         this._container = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.container");
         addChild(this._itemBG);
         addChild(this._light);
         addChild(this._setsName);
         addChild(this._container);
         this._cardsVector = new Vector.<CardBagCell>(5);
         for(i = 0; i < 5; i++)
         {
            this._cardsVector[i] = new CardBagCell(ComponentFactory.Instance.creatBitmap("asset.cardBag.cardBGOne"));
            this._cardsVector[i].setContentSize(68,92);
            this._cardsVector[i].starVisible = false;
            this._cardsVector[i].mouseChildren = false;
            this._cardsVector[i].mouseEnabled = false;
            this._container.addChild(this._cardsVector[i]);
         }
      }
      
      public function set setsInfo(value:SetsInfo) : void
      {
         this._setsInfo = value;
         this.upView();
      }
      
      public function get setsInfo() : SetsInfo
      {
         return this._setsInfo;
      }
      
      private function upView() : void
      {
         var i:int = 0;
         var j:int = 0;
         this.seleted = false;
         var len:int = 0;
         if(Boolean(this._setsInfo))
         {
            this._setsName.text = this._setsInfo.name;
            len = int(this._setsInfo.cardIdVec.length);
            for(i = 0; i < 5; i++)
            {
               if(i < len)
               {
                  this._cardsVector[i].visible = true;
                  this._cardsVector[i].cardID = this._setsInfo.cardIdVec[i];
                  this._cardsVector[i].filters = null;
               }
               else
               {
                  this._cardsVector[i].visible = false;
               }
            }
         }
         else
         {
            len = 5;
            this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSyste.bagItem.unkwon");
            for(j = 0; j < 5; j++)
            {
               this._cardsVector[j].visible = true;
               this._cardsVector[j].cardInfo = null;
               this._cardsVector[j].showCardName(LanguageMgr.GetTranslation("ddt.cardSyste.bagItem.unkwon"));
               this._cardsVector[j].filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._cardsVector[j].mouseChildren = false;
               this._cardsVector[j].mouseEnabled = false;
            }
         }
         this._itemBG.width = itemCellWidth * len + 5;
         this._light.width = itemCellWidth * len + 15 + len * 2;
      }
      
      public function setSetsDate(date:Vector.<CardInfo>) : void
      {
         var j:int = 0;
         var setsLen:int = int(this._setsInfo.cardIdVec.length);
         var dateLen:int = int(date.length);
         for(var i:int = 0; i < setsLen; i++)
         {
            if(dateLen > 0)
            {
               for(j = 0; j < dateLen; j++)
               {
                  if(this._cardsVector[i].cardID == date[j].TemplateID)
                  {
                     this._cardsVector[i].cardInfo = date[j];
                     this._cardsVector[i].collectCard = true;
                     break;
                  }
                  if(j == dateLen - 1)
                  {
                     this._cardsVector[i].cardInfo = null;
                     this._cardsVector[i].showCardName(ItemManager.Instance.getTemplateById(this._cardsVector[i].cardID).Name);
                  }
               }
            }
            else
            {
               this._cardsVector[i].cardInfo = null;
               this._cardsVector[i].showCardName(ItemManager.Instance.getTemplateById(this._cardsVector[i].cardID).Name);
            }
         }
      }
      
      public function dispose() : void
      {
         this._setsInfo = null;
         this._itemInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._container = null;
         this._setsName = null;
         for(var i:int = 0; i < this._cardsVector.length; i++)
         {
            this._cardsVector[i] = null;
         }
         this._cardsVector = null;
         this._itemBG = null;
         this._light = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

