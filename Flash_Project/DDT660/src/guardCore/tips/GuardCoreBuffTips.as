package guardCore.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import guardCore.data.GuardCoreInfo;
   
   public class GuardCoreBuffTips extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _vBox:VBox;
      
      public function GuardCoreBuffTips()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.guardCoreGameTips.Bg");
         addChild(this._bg);
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("core.guardCoreGameTips.VBox");
         addChild(this._vBox);
         super.init();
      }
      
      private function updateView() : void
      {
         var _loc3_:GuardCoreBuffTipsItem = null;
         this._vBox.disposeAllChildren();
         var _loc1_:Array = _tipData as Array;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new GuardCoreBuffTipsItem(_loc1_[_loc2_] as GuardCoreInfo);
            this._vBox.addChild(_loc3_);
            _loc2_++;
         }
         this.width = this._bg.width = this._vBox.width + this._vBox.x * 2;
         this.height = this._bg.height = this._vBox.height + this._vBox.y * 2;
      }
      
      override public function set tipData(param1:Object) : void
      {
         _tipData = param1;
         this.updateView();
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         super.dispose();
      }
   }
}
