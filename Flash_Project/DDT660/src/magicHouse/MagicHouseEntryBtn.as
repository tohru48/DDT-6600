package magicHouse
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MagicHouseEntryBtn extends Component
   {
      
      private var _entryBtn:BaseButton;
      
      private var _content:Sprite;
      
      private var _iconMc:MovieClip;
      
      public function MagicHouseEntryBtn()
      {
         super();
         this._entryBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.hallStateView.entryBtn.alpha");
         addChild(this._entryBtn);
         this._content = new Sprite();
         this._iconMc = ComponentFactory.Instance.creat("asset.hallIcon.magichouseIcon");
         this._content.addChild(this._iconMc);
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._entryBtn))
         {
            ObjectUtils.disposeObject(this._entryBtn);
         }
         this._entryBtn = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._iconMc))
         {
            ObjectUtils.disposeObject(this._entryBtn);
         }
         this._iconMc = null;
         super.dispose();
      }
   }
}

