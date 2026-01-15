package guardCore.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import guardCore.GuardCoreManager;
   import guardCore.data.GuardCoreInfo;
   
   public class GuardCoreTips extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _name:FilterFrameText;
      
      private var _describe:FilterFrameText;
      
      private var _keepTurn:FilterFrameText;
      
      private var _next:FilterFrameText;
      
      private var _nextGrade:FilterFrameText;
      
      private var _nextDescribe:FilterFrameText;
      
      private var _nextKeepTurn:FilterFrameText;
      
      private var _type:int;
      
      private var _grade:int;
      
      private var _guardGrade:int;
      
      private var _vBox:VBox;
      
      private const RED:uint = 16711680;
      
      private const GREEN:uint = 1895424;
      
      public function GuardCoreTips()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("guardCore.TipsBg");
         addChild(this._bg);
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsVBox");
         addChild(this._vBox);
         this._name = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsName");
         this._describe = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsDescribe");
         this._keepTurn = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsDescribe1");
         this._next = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsNext");
         this._next.text = LanguageMgr.GetTranslation("guardCore.tipsNext");
         this._nextGrade = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsName");
         this._nextDescribe = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsDescribe");
         this._nextKeepTurn = ComponentFactory.Instance.creatComponentByStylename("guardCore.tipsDescribe1");
         super.init();
      }
      
      private function updateView() : void
      {
         var _loc1_:GuardCoreInfo = null;
         var _loc2_:GuardCoreInfo = null;
         this._vBox.disposeAllChildren();
         if(GuardCoreManager.instance.getGuardCoreIsOpen(this._grade,this._type))
         {
            _loc1_ = GuardCoreManager.instance.getGuardCoreInfo(this._guardGrade,this._type);
            _loc2_ = GuardCoreManager.instance.getGuardCoreInfoBySkillGrade(_loc1_.SkillGrade + 1,this._type);
            this._name.text = _loc1_.Name;
            this._describe.text = LanguageMgr.GetTranslation("guardCore.tipsGuardEffect",_loc1_.Description);
            if(_loc1_.KeepTurn == 0)
            {
               this._keepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurnForever");
            }
            else
            {
               this._keepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurn",_loc1_.KeepTurn);
            }
            this._vBox.addChild(this._name);
            this._vBox.addChild(this.getLine());
            this._vBox.addChild(this._describe);
            this._vBox.addChild(this._keepTurn);
            this._vBox.addChild(this.getLine());
            this._vBox.addChild(this._next);
            if(_loc2_ == null)
            {
               this._nextDescribe.text = LanguageMgr.GetTranslation("guardCore.tipsMaxGrade");
               this._vBox.addChild(this._nextDescribe);
            }
            else
            {
               this._nextGrade.text = LanguageMgr.GetTranslation("guardCore.tipsNeedGuard",_loc2_.GuardGrade);
               this._nextGrade.textColor = this.RED;
               this._nextDescribe.text = LanguageMgr.GetTranslation("guardCore.tipsGuardEffect",_loc2_.Description);
               if(_loc2_.KeepTurn == 0)
               {
                  this._nextKeepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurnForever");
               }
               else
               {
                  this._nextKeepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurn",_loc2_.KeepTurn);
               }
               this._vBox.addChild(this._nextGrade);
               this._vBox.addChild(this._nextDescribe);
               this._vBox.addChild(this._nextKeepTurn);
            }
         }
         else
         {
            _loc1_ = GuardCoreManager.instance.getGuardCoreInfoBySkillGrade(1,this._type);
            this._name.text = _loc1_.Name;
            this._describe.text = LanguageMgr.GetTranslation("guardCore.tipsNotOpen");
            this._nextGrade.text = LanguageMgr.GetTranslation("guardCore.tipsNeedGrade",_loc1_.GainGrade);
            this._nextGrade.textColor = this.RED;
            this._nextDescribe.text = LanguageMgr.GetTranslation("guardCore.tipsGuardEffect",_loc1_.Description);
            if(_loc1_.KeepTurn == 0)
            {
               this._nextKeepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurnForever");
            }
            else
            {
               this._nextKeepTurn.text = LanguageMgr.GetTranslation("guardCore.tipsKeepTurn",_loc1_.KeepTurn);
            }
            this._vBox.addChild(this._name);
            this._vBox.addChild(this.getLine());
            this._vBox.addChild(this._describe);
            this._vBox.addChild(this.getLine());
            this._vBox.addChild(this._next);
            this._vBox.addChild(this._nextGrade);
            this._vBox.addChild(this._nextDescribe);
            this._vBox.addChild(this._nextKeepTurn);
         }
         this.resetTextSize(this._describe);
         this.resetTextSize(this._nextDescribe);
         this._vBox.arrange();
         this._bg.height = this._vBox.height + this._vBox.y + 8;
         this._bg.width = this._vBox.width + 8;
         this.width = this._bg.width;
         this.height = this._bg.height;
      }
      
      private function resetTextSize(param1:FilterFrameText) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1.textWidth > 160)
         {
            _loc2_ = param1.getCharIndexAtPoint(160,23);
            _loc3_ = param1.text.substring(0,_loc2_);
            _loc4_ = param1.text.substring(_loc2_,param1.text.length);
            param1.text = _loc3_ + "\n" + _loc4_;
         }
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(this._type == param1.type && this._grade == param1.grade && this._guardGrade == param1.guardGrade)
         {
            return;
         }
         _tipData = param1;
         this._type = param1.type;
         this._grade = param1.grade;
         this._guardGrade = param1.guardGrade;
         this.updateView();
      }
      
      private function getLine() : Image
      {
         var _loc1_:Image = null;
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         _loc1_.width = 160;
         return _loc1_;
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
