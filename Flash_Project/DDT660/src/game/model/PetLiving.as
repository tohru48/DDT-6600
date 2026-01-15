package game.model
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.StringUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.PetSkillManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetLiving extends Living
   {
      
      private var _petinfo:PetInfo;
      
      private var _master:Player;
      
      private var _usedSkill:Array;
      
      private var _mp:int;
      
      private var _maxMp:int;
      
      public function PetLiving(petinfo:PetInfo, marster:Player, id:int, team:int, maxBlood:int)
      {
         super(-1,team,maxBlood);
         this._petinfo = petinfo;
         this._master = marster;
         this._mp = 0;
         this._maxMp = petinfo.MP;
         this._usedSkill = [];
      }
      
      public function get skills() : Array
      {
         return this._petinfo.skills;
      }
      
      public function get equipedSkillIDs() : Array
      {
         return this._petinfo.equipdSkills.list;
      }
      
      public function get master() : Player
      {
         return this._master;
      }
      
      override public function get name() : String
      {
         return this._petinfo.Name;
      }
      
      override public function get actionMovieName() : String
      {
         return "pet.asset.game." + StringUtils.trim(this._petinfo.GameAssetUrl);
      }
      
      public function get assetUrl() : String
      {
         return StringUtils.trim(this._petinfo.GameAssetUrl);
      }
      
      public function get assetReady() : Boolean
      {
         return ModuleLoader.hasDefinition(this.actionMovieName);
      }
      
      public function get MP() : int
      {
         return this._mp;
      }
      
      public function set MP(value:int) : void
      {
         if(this._mp == value)
         {
            return;
         }
         this._mp = value;
         dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
      }
      
      public function set MaxMP(value:int) : void
      {
         this._maxMp = value;
      }
      
      public function get MaxMP() : int
      {
         return this._maxMp;
      }
      
      public function get livingPetInfo() : PetInfo
      {
         return this._petinfo;
      }
      
      public function useSkill(skillID:int, isUse:Boolean) : void
      {
         var skill:PetSkillTemplateInfo = PetSkillManager.getSkillByID(skillID);
         if(Boolean(skill) && isUse)
         {
            this.MP -= skill.CostMP;
         }
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,skillID,0,isUse));
      }
   }
}

