package cardSystem.view.cardCollect
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import cardSystem.elements.PreviewCard;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class CollectPreview extends Sprite implements Disposeable
   {
      
      public static const PREVIEWCARD_ALL_LENGTH:int = 350;
      
      public static const PREVIEWCARD_WIDHT:int = 66;
      
      private var _bg:MovieImage;
      
      private var _setsName:GradientText;
      
      private var _stroyBG:MovieImage;
      
      private var _flower:Bitmap;
      
      private var _stroy:FilterFrameText;
      
      private var _itemInfo:SetsInfo;
      
      private var _previewCardVec:Vector.<PreviewCard>;
      
      private var _setsPropBG:Bitmap;
      
      private var _propExplain:GradientText;
      
      private var _propDescript:TextArea;
      
      public function CollectPreview()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.BG");
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.setsName");
         this._stroyBG = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.BG1");
         this._flower = ComponentFactory.Instance.creatBitmap("asset.ddtcardSytems.bg2");
         this._stroy = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.story");
         this._setsPropBG = ComponentFactory.Instance.creatBitmap("CollectPreview.setsPropBG");
         this._propExplain = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.propExplain");
         this._propDescript = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.propArea");
         addChild(this._bg);
         addChild(this._stroyBG);
         addChild(this._flower);
         addChild(this._stroy);
         addChild(this._setsPropBG);
         addChild(this._propExplain);
         addChild(this._propDescript);
         addChild(this._setsName);
         this._previewCardVec = new Vector.<PreviewCard>(5);
         for(var i:int = 0; i < 5; i++)
         {
            this._previewCardVec[i] = new PreviewCard();
            addChild(this._previewCardVec[i]);
            this._previewCardVec[i].y = 148;
         }
         this._propExplain.text = LanguageMgr.GetTranslation("ddt.cardSystem.preview.propExplain");
      }
      
      public function set info(value:SetsInfo) : void
      {
         if(this._itemInfo == value)
         {
            return;
         }
         this._itemInfo = value;
         this.upView();
      }
      
      private function upView() : void
      {
         var cardInfoVec:Vector.<CardInfo> = null;
         var singleLen:int = 0;
         var j:int = 0;
         var valueArr:Array = null;
         var value:String = null;
         cardInfoVec = CardControl.Instance.model.getSetsCardFromCardBag(this._itemInfo.ID);
         this._setsName.text = this._itemInfo.name;
         this._setsName.x = this._bg.x + this._bg.width / 2 - this._setsName.textWidth / 2;
         this._stroy.text = "    " + this._itemInfo.storyDescript;
         var len:int = int(this._itemInfo.cardIdVec.length);
         for(var i:int = 0; i < 5; i++)
         {
            if(i < len)
            {
               this._previewCardVec[i].cardId = this._itemInfo.cardIdVec[i];
               this._previewCardVec[i].visible = true;
               if(cardInfoVec.length > 0)
               {
                  for(j = 0; j < cardInfoVec.length; j++)
                  {
                     if(this._previewCardVec[i].cardId == cardInfoVec[j].TemplateID)
                     {
                        this._previewCardVec[i].cardInfo = cardInfoVec[j];
                        break;
                     }
                     if(j == cardInfoVec.length - 1)
                     {
                        this._previewCardVec[i].cardInfo = null;
                     }
                  }
               }
               else
               {
                  this._previewCardVec[i].cardInfo = null;
               }
            }
            else
            {
               this._previewCardVec[i].visible = false;
            }
         }
         singleLen = PREVIEWCARD_ALL_LENGTH / len;
         var lastX:int = 18 + singleLen / 2 - PREVIEWCARD_WIDHT / 2 + 5;
         for(var n:int = 0; n < len; n++)
         {
            this._previewCardVec[n].x = lastX;
            lastX += singleLen + 4;
         }
         var setsPropVec:Vector.<SetsPropertyInfo> = CardControl.Instance.model.setsList[this._itemInfo.ID];
         var len2:int = int(setsPropVec.length);
         var str:String = "";
         for(var m:int = 0; m < len2; m++)
         {
            valueArr = setsPropVec[m].value.split("|");
            if(valueArr.length == 4)
            {
               value = valueArr[0] + "/" + valueArr[1] + "/" + valueArr[2] + "/" + valueArr[3] + LanguageMgr.GetTranslation("cardSystem.preview.descript.level");
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1") + setsPropVec[m].condition + LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2") + " " + setsPropVec[m].Description.replace("{0}",value));
            }
            else
            {
               str = str.concat(LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1") + setsPropVec[m].condition + LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2") + " " + setsPropVec[m].Description.replace("{0}",valueArr[0]));
            }
            str = str.concat("\n\n");
         }
         this._propDescript.text = str;
         var tf:TextFormat = new TextFormat();
         tf.bold = true;
         var h:int = 0;
         var lastLen:int = 0;
         var string1:String = LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1");
         var string2:String = LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2");
         while(str.indexOf(string1) > -1)
         {
            if(h != 0)
            {
               lastLen += string1.length + string2.length + 1 + str.indexOf(string1);
            }
            this._propDescript.textField.setTextFormat(tf,lastLen,lastLen + string1.length + string2.length + 2);
            str = str.substr(str.indexOf(string2) + string2.length + 1,str.length);
            h++;
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._itemInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._setsName = null;
         this._stroyBG = null;
         this._stroy = null;
         for(var i:int = 0; i < this._previewCardVec.length; i++)
         {
            this._previewCardVec[i] = null;
         }
         this._previewCardVec = null;
         this._setsPropBG = null;
         this._propExplain = null;
         this._propDescript = null;
         this._flower = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

