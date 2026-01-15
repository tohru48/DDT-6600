package kingBless.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class KingBlessBuffTipView extends BaseTip
   {
      
      private var _bg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _valueTxtList:Vector.<FilterFrameText>;
      
      private var _tipTxt:FilterFrameText;
      
      private var _valueNameList:Array;
      
      public function KingBlessBuffTipView()
      {
         var i:int = 0;
         var valueTxt:FilterFrameText = null;
         super();
         this._valueNameList = LanguageMgr.GetTranslation("ddt.kingBless.game.buffTipView.valueNameTxtList").split(",");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.kingbless.buffTipViewBg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("game.kingbless.tipView.titleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxtList").split(",")[0];
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("game.kingbless.tipView.tipTxt");
         this._tipTxt.text = LanguageMgr.GetTranslation("ddt.kingBless.game.buffTipView.tipTxt");
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._tipTxt);
         this._valueTxtList = new Vector.<FilterFrameText>(4);
         for(i = 0; i < 4; i++)
         {
            valueTxt = ComponentFactory.Instance.creatComponentByStylename("game.kingbless.tipView.valueTxt");
            valueTxt.y += i * 20;
            addChild(valueTxt);
            this._valueTxtList[i] = valueTxt;
         }
      }
      
      override public function set tipData(data:Object) : void
      {
         var value:int = int(data);
         for(var i:int = 0; i < 4; i++)
         {
            this._valueTxtList[i].text = LanguageMgr.GetTranslation("ddt.kingBless.game.buffTipView.valueTxt",this._valueNameList[i],value);
         }
      }
      
      override public function get width() : Number
      {
         if(Boolean(this._bg))
         {
            return this._bg.width;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._bg))
         {
            return this._bg.height;
         }
         return super.height;
      }
      
      override public function dispose() : void
      {
         var tmp:FilterFrameText = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._tipTxt);
         this._tipTxt = null;
         for each(tmp in this._valueTxtList)
         {
            ObjectUtils.disposeObject(tmp);
         }
         this._valueTxtList = null;
         this._valueNameList = null;
         super.dispose();
      }
   }
}

