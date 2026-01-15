package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BadLuckItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _sortText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _numberText:FilterFrameText;
      
      public function BadLuckItem(unmber:int)
      {
         super();
         this.initView(unmber);
      }
      
      private function initView(unmber:int) : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.bacLuckItemBG");
         this._sortText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.sortTxt");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NameTxt");
         this._numberText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NumberTxt");
         addChild(this._bg);
         this._bg.setFrame(unmber % 2 + 1);
         addChild(this._sortText);
         addChild(this._nameText);
         addChild(this._numberText);
      }
      
      public function update(sortNumber:int, name:String, number:int) : void
      {
         var tempIndex:int = 0;
         this._bg.setFrame(sortNumber % 2 + 1);
         this._sortText.text = sortNumber + 1 + "th";
         this._nameText.text = name;
         if(this._nameText.textWidth > this._nameText.width)
         {
            tempIndex = this._nameText.getCharIndexAtPoint(this._nameText.width - 25,this._nameText.y + 2);
            this._nameText.text = name.substring(0,tempIndex) + "...";
         }
         this._numberText.text = number.toString();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
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

