package room.transnational
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import road7th.utils.StringHelper;
   
   public class TransnationalPetCellTips extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var name_txt:FilterFrameText;
      
      private var petskill:FilterFrameText;
      
      private var _lostTxt:FilterFrameText;
      
      private var _descLbl:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _coolDownTxt:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      private var _splitImg2:ScaleBitmapImage;
      
      private var _tempData:PetSkillTemplateInfo;
      
      private var _skill:Array;
      
      private var _container:Sprite;
      
      public function TransnationalPetCellTips()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         addChildAt(this._bg,0);
      }
      
      override public function get tipData() : Object
      {
         return this._skill;
      }
      
      override public function set tipData(data:Object) : void
      {
         this._skill = data as Array;
         if(!this._skill)
         {
            return;
         }
         this.clearView();
         this.updateView();
      }
      
      private function clearView() : void
      {
         while(numChildren > 1)
         {
            removeChildAt(1);
         }
      }
      
      private function updateView() : void
      {
         var bgH:Number = NaN;
         var i:int = 0;
         var petskill:PetSkill = null;
         bgH = 0;
         for(i = 0; i < this._skill.length; i++)
         {
            petskill = this._skill[i];
            this.name_txt = ComponentFactory.Instance.creat("Transnational.PetSkillTip.name");
            this.name_txt.text = StringHelper.trim(petskill.Name) + "(" + (petskill.isActiveSkill ? LanguageMgr.GetTranslation("core.petskillTip.activeSkill") : LanguageMgr.GetTranslation("core.petskillTip.passiveSkill")) + ")";
            this.name_txt.y += i * (this.name_txt.textHeight + 10);
            if(i < this._skill.length - 1)
            {
               this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
               this._splitImg.x = this.name_txt.x;
               this._splitImg.y = this.name_txt.y + this.name_txt.textHeight + 3;
               this._splitImg.width -= 18;
            }
            bgH += this.name_txt.textHeight;
            addChild(this._splitImg);
            addChild(this.name_txt);
         }
         this._bg.width = 170;
         this._bg.height = bgH + 40;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         this._tempData = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         if(Boolean(this._splitImg2))
         {
            ObjectUtils.disposeObject(this._splitImg2);
            this._splitImg2 = null;
         }
         if(Boolean(this._splitImg))
         {
            ObjectUtils.disposeObject(this._splitImg);
            this._splitImg = null;
         }
         if(Boolean(this._descTxt))
         {
            ObjectUtils.disposeObject(this._descTxt);
            this._descTxt = null;
         }
         if(Boolean(this._coolDownTxt))
         {
            ObjectUtils.disposeObject(this._coolDownTxt);
            this._coolDownTxt = null;
         }
         if(Boolean(this.name_txt))
         {
            ObjectUtils.disposeObject(this.name_txt);
            this.name_txt = null;
         }
         if(Boolean(this._lostTxt))
         {
            ObjectUtils.disposeObject(this._lostTxt);
            this._lostTxt = null;
         }
         if(Boolean(this._descLbl))
         {
            ObjectUtils.disposeObject(this._descLbl);
            this._descLbl = null;
         }
         if(Boolean(this.petskill))
         {
            ObjectUtils.disposeObject(this.petskill);
            this.petskill = null;
         }
         super.dispose();
      }
   }
}

