package beadSystem.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   
   public class BeadBtnTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _discTxt:FilterFrameText;
      
      private var _beadTipData:Object;
      
      private var _nameList:Array;
      
      private var _priceList:Array;
      
      public function BeadBtnTip()
      {
         super();
         this.initView();
         this.initData();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.bg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.name");
         this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.disc");
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._discTxt);
      }
      
      private function initData() : void
      {
         var nameListStr:String = LanguageMgr.GetTranslation("ddt.beadSystem.requestBeadNames");
         this._nameList = nameListStr.split(",");
         this._priceList = ServerConfigManager.instance.getRequestBeadPrice();
      }
      
      override public function get tipData() : Object
      {
         return this._beadTipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         var tmpName:String = null;
         var tmpDisc:int = 0;
         this._beadTipData = data;
         var place:int = int(data);
         switch(place)
         {
            case 0:
               tmpName = this._nameList[0];
               tmpDisc = int(this._priceList[0]);
               break;
            case 1:
               tmpName = this._nameList[1];
               tmpDisc = int(this._priceList[1]);
               break;
            case 2:
               tmpName = this._nameList[2];
               tmpDisc = int(this._priceList[2]);
               break;
            case 3:
               tmpName = this._nameList[3];
               tmpDisc = int(this._priceList[3]);
               break;
            default:
               tmpName = "";
               tmpDisc = 0;
         }
         this._nameTxt.text = tmpName;
         this._discTxt.text = "Fiyat(Kupon):" + tmpDisc.toString();
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         this._bg.width = this._discTxt.x + this._discTxt.width + 15;
         this._bg.height = this._discTxt.y + this._discTxt.height + 10;
      }
      
      override public function dispose() : void
      {
         this._beadTipData = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._discTxt))
         {
            ObjectUtils.disposeObject(this._discTxt);
         }
         this._discTxt = null;
         super.dispose();
      }
   }
}

