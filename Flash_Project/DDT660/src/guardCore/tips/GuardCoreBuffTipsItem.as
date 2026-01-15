package guardCore.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import guardCore.data.GuardCoreInfo;
   
   public class GuardCoreBuffTipsItem extends Sprite implements Disposeable
   {
       
      
      private var _info:GuardCoreInfo;
      
      private var _icon:Bitmap;
      
      private var _name:FilterFrameText;
      
      public function GuardCoreBuffTipsItem(param1:GuardCoreInfo)
      {
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._icon = ComponentFactory.Instance.creatBitmap("asset.ddtcorei.guardCoreIcon" + this._info.Type);
         addChild(this._icon);
         this._name = ComponentFactory.Instance.creatComponentByStylename("guardCore.gameTips.text");
         this._name.text = this._info.Name + ":" + this._info.TipsDescription;
         addChild(this._name);
      }
      
      public function get info() : GuardCoreInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         ObjectUtils.disposeObject(this._name);
         this._info = null;
         this._icon = null;
         this._name = null;
      }
   }
}
