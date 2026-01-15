package game.model
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.manager.PathManager;
   
   public class GameNeedPetSkillInfo
   {
      
      private var _pic:String;
      
      private var _effect:String;
      
      public function GameNeedPetSkillInfo()
      {
         super();
      }
      
      public function get pic() : String
      {
         return this._pic;
      }
      
      public function set pic(value:String) : void
      {
         this._pic = value;
      }
      
      public function get effect() : String
      {
         return this._effect;
      }
      
      public function set effect(value:String) : void
      {
         this._effect = value;
      }
      
      public function get effectClassLink() : String
      {
         return "asset.game.skill.effect." + this.effect;
      }
      
      public function startLoad() : void
      {
         if(!this.effect)
         {
            return;
         }
         LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(this.effect),BaseLoader.MODULE_LOADER);
      }
   }
}

