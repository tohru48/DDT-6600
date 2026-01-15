package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import ddt.data.FightBuffInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.LivingEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import flash.geom.Rectangle;
   import game.model.Living;
   import pet.date.PetSkillTemplateInfo;
   import phy.maps.Map;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovieEvent;
   
   public class GamePet extends GameLiving
   {
      
      private var _master:GamePlayer;
      
      private var _effectClassLink:String;
      
      public function GamePet(info:Living, master:GamePlayer)
      {
         super(info);
         this._master = master;
         _testRect = new Rectangle(-3,3,6,3);
         _mass = 5;
         _gravityFactor = 50;
      }
      
      public function get master() : GamePlayer
      {
         return this._master;
      }
      
      public function set effectClassLink(value:String) : void
      {
         this._effectClassLink = value;
      }
      
      public function get effectClassLink() : String
      {
         return this._effectClassLink;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         _info.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
      }
      
      private function __usePetSkill(event:LivingEvent) : void
      {
         var skill:PetSkillTemplateInfo = null;
         if(Boolean(event.paras[0]))
         {
            skill = PetSkillManager.getSkillByID(event.value);
            if(skill == null)
            {
               throw new Error("找不到技能，技能ID为：" + event.value);
            }
            if(skill.isActiveSkill)
            {
               _propArray.push(new BitmapLoaderProxy(PathManager.solveSkillPicUrl(skill.Pic),new Rectangle(0,0,40,40)));
               doUseItemAnimation();
            }
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         _info.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
      }
      
      override protected function initView() : void
      {
         super.initView();
         initMovie();
         if(Boolean(_bloodStripBg) && Boolean(_bloodStripBg.parent))
         {
            _bloodStripBg.parent.removeChild(_bloodStripBg);
         }
         if(Boolean(_HPStrip) && Boolean(_HPStrip.parent))
         {
            _HPStrip.parent.removeChild(_HPStrip);
         }
         _nickName.x += 20;
         _nickName.y -= 20;
      }
      
      override public function get layer() : int
      {
         return PhysicsLayer.GameLiving;
      }
      
      override public function get smallView() : SmallObject
      {
         return null;
      }
      
      override protected function initSmallMapObject() : void
      {
      }
      
      override public function setMap(map:Map) : void
      {
         super.setMap(map);
         if(Boolean(map))
         {
            __posChanged(null);
         }
      }
      
      override protected function __playEffect(evt:ActionMovieEvent) : void
      {
         if(Boolean(evt.data))
         {
            if(ModuleLoader.hasDefinition("asset.game.skill.effect." + evt.data.effect))
            {
               this._master.showEffect("asset.game.skill.effect." + evt.data.effect);
            }
            else
            {
               this._master.showEffect(FightBuffInfo.DEFUALT_EFFECT);
            }
         }
      }
      
      public function showMasterEffect() : void
      {
         if(Boolean(this._effectClassLink))
         {
            if(ModuleLoader.hasDefinition(this._effectClassLink))
            {
               this._master.showEffect(this._effectClassLink);
            }
            else
            {
               this._master.showEffect(FightBuffInfo.DEFUALT_EFFECT);
            }
         }
         this._effectClassLink = null;
      }
      
      override protected function __playerEffect(evt:ActionMovieEvent) : void
      {
         this.showMasterEffect();
      }
      
      override public function update(dt:Number) : void
      {
         super.update(dt);
      }
      
      public function prepareForShow() : void
      {
      }
      
      public function show() : void
      {
         this.master.map.addPhysical(this);
      }
      
      public function hide() : void
      {
         this.master.map.removePhysical(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

