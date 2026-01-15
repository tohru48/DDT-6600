package treasureHunting.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class LuckRankItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _selectedBg:ScaleLeftRightImage;
      
      private var _sortText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _numberText:FilterFrameText;
      
      public function LuckRankItem(number:int)
      {
         super();
         this.initView(number);
      }
      
      private function initView(number:int) : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("treasreHunting.rankItemBG");
         this._selectedBg = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.ScaleLeftRightImage1");
         this._selectedBg.visible = false;
         this._sortText = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Luck.sortTxt");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Luck.NameTxt");
         this._numberText = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Luck.NumberTxt");
         this._bg.setFrame(number % 2 + 1);
         addChild(this._bg);
         addChild(this._selectedBg);
         addChild(this._sortText);
         addChild(this._nameText);
         addChild(this._numberText);
      }
      
      public function update(sortNumber:int, name:String, number:int) : void
      {
         this._bg.setFrame(sortNumber % 2 + 1);
         this._sortText.text = sortNumber + 1 + "th";
         this._nameText.text = name;
         this._numberText.text = number.toString();
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selectedBg.visible = value;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._selectedBg))
         {
            ObjectUtils.disposeObject(this._selectedBg);
         }
         this._selectedBg = null;
         if(Boolean(this._sortText))
         {
            ObjectUtils.disposeObject(this._sortText);
         }
         this._sortText = null;
         if(Boolean(this._nameText))
         {
            ObjectUtils.disposeObject(this._nameText);
         }
         this._nameText = null;
         if(Boolean(this._numberText))
         {
            ObjectUtils.disposeObject(this._numberText);
         }
         this._numberText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

