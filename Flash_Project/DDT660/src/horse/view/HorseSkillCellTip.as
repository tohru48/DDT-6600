package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import horse.data.HorseSkillVo;
   
   public class HorseSkillCellTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _consumeTitleTxt:FilterFrameText;
      
      private var _consumeContentTxt:FilterFrameText;
      
      private var _descTitleTxt:FilterFrameText;
      
      private var _descContentTxt:FilterFrameText;
      
      private var _coolDownTxt:FilterFrameText;
      
      private var _lineImg:ScaleBitmapImage;
      
      private var _lineImg2:ScaleBitmapImage;
      
      private var _container:Sprite;
      
      private var _tipInfo:HorseSkillVo;
      
      private var LEADING:int = 5;
      
      public function HorseSkillCellTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.nameTxt");
         this._consumeTitleTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.titleTxt");
         this._consumeTitleTxt.text = LanguageMgr.GetTranslation("ddt.pets.skillTipLost");
         this._consumeContentTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.contentTxt");
         this._descTitleTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.titleTxt");
         this._descTitleTxt.text = LanguageMgr.GetTranslation("ddt.pets.skillTipDesc");
         this._descContentTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.contentTxt");
         this._coolDownTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.coolDownTxt");
         this._lineImg = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.line");
         this._lineImg2 = ComponentFactory.Instance.creatComponentByStylename("horse.skillCellTip.line");
         this._container = new Sprite();
         this._container.addChild(this._nameTxt);
         this._container.addChild(this._consumeTitleTxt);
         this._container.addChild(this._consumeContentTxt);
         this._container.addChild(this._descTitleTxt);
         this._container.addChild(this._descContentTxt);
         this._container.addChild(this._coolDownTxt);
         this._container.addChild(this._lineImg);
         this._container.addChild(this._lineImg2);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
      }
      
      override public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      override public function set tipData(data:Object) : void
      {
         this._tipInfo = data as HorseSkillVo;
         this.updateView();
      }
      
      private function updateView() : void
      {
         this._nameTxt.text = this._tipInfo.Name;
         this._consumeContentTxt.text = this._tipInfo.CostEnergy + LanguageMgr.GetTranslation("energy");
         this._descContentTxt.text = this._tipInfo.Description;
         this._coolDownTxt.text = LanguageMgr.GetTranslation("tank.game.actions.cooldown") + ": " + this._tipInfo.ColdDown + LanguageMgr.GetTranslation("tank.game.actions.turn");
         this.fixPos();
         this._bg.width = this._container.width + 15;
         this._bg.height = this._container.height + 15;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function fixPos() : void
      {
         this._lineImg.y = this._nameTxt.y + this._nameTxt.textHeight + this.LEADING;
         this._consumeTitleTxt.y = this._lineImg.y + this._lineImg.height + this.LEADING;
         this._consumeTitleTxt.x = this._nameTxt.x;
         this._consumeContentTxt.x = this._consumeTitleTxt.x + this._consumeTitleTxt.textWidth + this.LEADING;
         this._consumeContentTxt.y = this._consumeTitleTxt.y;
         this._descTitleTxt.x = this._nameTxt.x;
         this._descTitleTxt.y = this._consumeContentTxt.y + this._consumeContentTxt.textHeight + this.LEADING;
         this._descContentTxt.x = this._descTitleTxt.x + this._descTitleTxt.textWidth + this.LEADING;
         this._descContentTxt.y = this._descTitleTxt.y;
         this._lineImg2.y = this._descContentTxt.y + this._descContentTxt.textHeight + this.LEADING * 2;
         this._coolDownTxt.x = this._nameTxt.x;
         this._coolDownTxt.y = this._lineImg2.y + this._lineImg2.height + this.LEADING;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._container);
         ObjectUtils.disposeObject(this._container);
         this._bg = null;
         this._nameTxt = null;
         this._consumeTitleTxt = null;
         this._consumeContentTxt = null;
         this._descTitleTxt = null;
         this._descContentTxt = null;
         this._coolDownTxt = null;
         this._lineImg = null;
         this._lineImg2 = null;
         this._container = null;
         this._tipInfo = null;
         super.dispose();
      }
   }
}

