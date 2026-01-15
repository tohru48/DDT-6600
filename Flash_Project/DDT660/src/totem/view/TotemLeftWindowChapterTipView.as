package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemLeftWindowChapterTipView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxtList:Vector.<FilterFrameText>;
      
      private var _titleTxtList:Array;
      
      private var _numTxtList:Array;
      
      private var _propertyTxtList:Array;
      
      public function TotemLeftWindowChapterTipView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._titleTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleListTxt").split(",");
         this._numTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.numListTxt").split(",");
         this._propertyTxtList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
         this.initView();
      }
      
      private function initView() : void
      {
         var tmp:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.chapterTip.bg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.titleTxt");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.nameTxt");
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._nameTxt);
         this._valueTxtList = new Vector.<FilterFrameText>();
         for(var i:int = 0; i < 7; i++)
         {
            tmp = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.valueTxt");
            tmp.y += i * 20;
            addChild(tmp);
            this._valueTxtList.push(tmp);
         }
      }
      
      public function show(chapterIndex:int) : void
      {
         var tmpIndex:int = chapterIndex - 1;
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleTxt",this._numTxtList[tmpIndex],this._titleTxtList[tmpIndex]);
         this._nameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.nameTxt",this._numTxtList[tmpIndex]);
         var addDataInfo:TotemAddInfo = TotemManager.instance.getAddInfo(chapterIndex * 70,(chapterIndex - 1) * 70 + 1);
         for(var i:int = 0; i < 7; i++)
         {
            this._valueTxtList[i].text = this._propertyTxtList[i] + "+" + this.getAddValue(i + 1,addDataInfo);
         }
      }
      
      private function getAddValue(index:int, addDataInfo:TotemAddInfo) : int
      {
         var tmpValue:int = 0;
         switch(index)
         {
            case 1:
               tmpValue = addDataInfo.Attack;
               break;
            case 2:
               tmpValue = addDataInfo.Defence;
               break;
            case 3:
               tmpValue = addDataInfo.Agility;
               break;
            case 4:
               tmpValue = addDataInfo.Luck;
               break;
            case 5:
               tmpValue = addDataInfo.Blood;
               break;
            case 6:
               tmpValue = addDataInfo.Damage;
               break;
            case 7:
               tmpValue = addDataInfo.Guard;
         }
         return tmpValue;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTxt = null;
         this._nameTxt = null;
         this._valueTxtList = null;
         this._titleTxtList = null;
         this._numTxtList = null;
         this._propertyTxtList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

