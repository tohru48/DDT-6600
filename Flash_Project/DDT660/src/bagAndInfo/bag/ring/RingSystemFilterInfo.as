package bagAndInfo.bag.ring
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   
   public class RingSystemFilterInfo extends Component
   {
       
      
      private var _info:FilterFrameText;
      
      public function RingSystemFilterInfo(param1:int)
      {
         super();
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "2,3,5,1";
         tipGapV = 4;
         this._info = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.fightData");
         addChild(this._info);
         this._info.setFrame(param1);
      }
      
      public function setInfoText(param1:Object) : void
      {
         this._info.text = param1.info + LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.TimesUnit");
         tipData = param1.tipData;
         this.width = this._info.width;
         this.height = this._info.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._info);
         this._info = null;
      }
   }
}
