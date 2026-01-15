package fightLib.view
{
   import com.pickgliss.effect.AddMovieEffect;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class LevelButton extends BaseButton
   {
      
      private var _shineEffect:IEffect;
      
      private var _shine:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _selectedBitmap:Bitmap;
      
      public function LevelButton()
      {
         super();
      }
      
      private static function createShineEffect(target:LevelButton) : IEffect
      {
         var position:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.LevelShinePosition");
         return EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,target,"fightLib.Lessons.LevelShine",position);
      }
      
      override protected function init() : void
      {
         super.init();
         this._shineEffect = createShineEffect(this);
         this._selectedBitmap = ComponentFactory.Instance.creatBitmap("fightLib.Lessons.hardness.Selected");
         addChildAt(this._selectedBitmap,0);
         this.enable = false;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._selectedBitmap))
         {
            ObjectUtils.disposeObject(this._selectedBitmap);
            this._selectedBitmap = null;
         }
         if(Boolean(this._shineEffect))
         {
            EffectManager.Instance.removeEffect(this._shineEffect);
            this._shineEffect = null;
         }
         super.dispose();
      }
      
      override public function set enable(value:Boolean) : void
      {
         if(_enable != value)
         {
            super.enable = value;
            if(_enable)
            {
               this.filters = null;
            }
            else
            {
               this.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            }
            if(this._shine)
            {
               this.shine = false;
            }
            if(this._selected)
            {
               this.selected = false;
            }
         }
      }
      
      public function get shine() : Boolean
      {
         return this._shine;
      }
      
      public function set shine(val:Boolean) : void
      {
         var movie:DisplayObject = null;
         if(this._shine != val)
         {
            this._shine = val;
            if(this._shine)
            {
               if(_enable)
               {
                  this._shineEffect.play();
               }
            }
            else
            {
               this._shineEffect.stop();
               for each(movie in AddMovieEffect(this._shineEffect).movie)
               {
                  if(movie is MovieClip)
                  {
                     MovieClip(movie).gotoAndStop(1);
                  }
               }
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(val:Boolean) : void
      {
         if(this._selected != val)
         {
            this._selected = val;
            this._selectedBitmap.visible = this._selected;
            this.setChildIndex(this._selectedBitmap,this.numChildren - 1);
         }
      }
   }
}

